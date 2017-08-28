"""Data pipelines to parse benchmark YAML for charts.

Extracts benchmark YAML and combines with template chart YAML for Vega
charts. Run `python _data/charts.py` to build the charts.
"""
# pylint: disable=no-value-for-parameter

import glob
import os
import json
import re

from dateutil.parser import parse
import jinja2
# pylint: disable=redefined-builtin, no-name-in-module
from toolz.curried import map, pipe, get, curry, filter, compose, juxt
from toolz.curried import valmap, itemmap, groupby, memoize, keymap, update_in
import yaml


def fcompose(*args):
    """Helper function to compose functions.

    >>> f = lambda x: x - 2
    >>> g = lambda x: 2 * x
    >>> f(g(3))
    4
    >>> fcompose(g, f)(3)
    4

    Args:
      *args: tuple of functions

    Returns:
      composed functions
    """
    return compose(*args[::-1])


def read_yaml(filepath):
    """Read a YAML file

    Args:
      filepath: the path to the YAML file

    Returns:
      returns a dictionary
    """
    with open(filepath) as stream:
        data = yaml.safe_load(stream)
    return data


@curry
def write_json(data, filepath):
    """Write a JSON file

    Args:
      data: the dictionary to write
      filepath: the path to the JSON file

    Returns:
      returns a tuple of (filepath, data)
    """
    with open(filepath, 'w') as stream:
        json.dump(data, stream, sort_keys=True, indent=2)
    return (filepath, data)


def get_path():
    """Return the local file path for this file.

    Returns:
      the filepath
    """
    return pipe(
        __file__,
        os.path.realpath,
        os.path.split,
        get(0)
    )


@curry
def update_dict(dict_, **kwargs):
    """Add keys to a new dictionary.

    Args:
      dict_: the dictionary to add to
      kwargs: the key, value pairs to add

    Returns:
      a new dictionary
    """
    return dict(list(dict_.items()) + list(kwargs.items()))


@curry
def filter_data(field, yaml_data):
    """Extract a field of data from the YAML files.

    Args:
      field: the name of the field to extract
      yaml_data: the benchmark YAML data

    Returns:
      the filtered data from the YAML data
    """
    def debug(x):
        def f(y):
            y = update_in(y, ['transform'], lambda xx: xx + [dict(expr="datum.x > 0.01", type="filter")])
            # y['transform'].append(dict(expr="datum.x > 0.01", type="filter"))
            return y
        return list(map(f, x))

    return pipe(
        yaml_data,
        dict,
        valmap(lambda val: val['data']),
        valmap(filter(lambda item: item['name'].lower() == field)),
        valmap(list),
        valmap(get(0)),
        itemmap(lambda item: (item[0], update_dict(item[1], name=item[0]))),
        lambda dict_: sorted(list(dict_.values()),
                             key=lambda item: item['name']),
        map(update_in(keys=['transform'],
                      func=lambda x: x + [dict(expr="datum.x > 0.01",
                                               type="filter")]))
    )


@curry
def filter_memory_data(yaml_data):
    """Filter the memory time data from the meta.yaml's

    Args:
      yaml_data: the benchmark YAML data

    Returns:
      memory versus time data
    """
    def time_ratio(data):
        """Calcuate the sim_time over wall_time ration
        """
        return pipe(
            data[-1],
            juxt(lambda x: x.get('sim_time', x.get('time')),
                 lambda x: x.get('wall_time', x.get('time'))),
            lambda x: float(x[0]) / float(x[1])
        )

    def memory_usage(data):
        """Calculate the memory usage in KB
        """
        unit_map = dict(GB=1048576.,
                        KB=1.,
                        MB=1024.)
        if isinstance(data, dict):
            data_ = data
        else:
            data_ = data[-1]
        key = next(k for k in data_.keys() if 'value' in k)
        return float(data_[key]) * unit_map[data_.get('unit', 'KB')]

    def make_datum(data):
        """Build an item in the data list for one simulation
        """
        return dict(
            name='efficiency',
            values=[dict(time_ratio=time_ratio(data['run_time']),
                         memory_usage=memory_usage(data['memory_usage']))],
        )

    return pipe(
        yaml_data,
        dict,
        valmap(lambda x: x['data']),
        valmap(
            filter(
                lambda item: item['name'].lower() in ('memory_usage',
                                                      'run_time')
            )
        ),
        valmap(map(lambda x: (x['name'], x['values']))),
        valmap(dict),
        valmap(make_datum),
        itemmap(lambda item: (item[0], update_dict(item[1], name=item[0]))),
        lambda dict_: sorted(list(dict_.values()),
                             key=lambda item: item['name'])
    )


def get_yaml_data():
    """Read in the YAML data but don't group

    Returns:
      list of tuples of (name, data_dict)
    """
    return pipe(
        os.path.join(get_path(), 'simulations/*/meta.yaml'),
        glob.glob,
        sorted,
        map(lambda path_: (os.path.split(os.path.split(path_)[0])[1],
                           read_yaml(path_))),
        filter(lambda item: item[0] not in ['example', 'example_minimal', 'test_lander'])
    )


def vega2to3(data):
    """Transform a Vega data list from version 2 to 3.

    Args:
      data: vega data list

    Returns:
      update vega data list
    """
    def keymapping(key):
        """Map vega data  keys from version 2 to 3

        The mapping is `test` -> `expr` and `field` -> `as` otherwise
        the input key is just returned.

        Args:
          key: the key to map

        Returns:
          a new key
        """
        return dict(test='expr',
                    field='as').get(key, key)
    update_transform = fcompose(
        map(keymap(keymapping)),
        list
    )
    return pipe(
        data,
        map(update_in(keys=['transform'],
                      func=update_transform,
                      default=[])),
        list
    )


def get_data(filter_func):
    """Read in the YAML data and group by benchmark id

    Args:
      filter_func: function to filter data

    Returns:
      a dictionary with benchmark ids as keys and lists of appropriate
      data for values
    """

    return pipe(
        get_yaml_data(),
        groupby(
            lambda item: "{0}.{1}".format(item[1]['benchmark']['id'],
                                          str(item[1]['benchmark']['version']))
        ),
        valmap(filter_func),
        valmap(vega2to3)
    )


def get_chart_file(j2_file_name):
    """Get the name of the chart file

    Returns:
      the chart YAML file

    """
    return os.path.join(get_path(), 'charts', j2_file_name)


@curry
def write_chart_json(j2_file_name, item):
    """Write a chart JSON file.

    Args:
      j2_file_name: the name of the Jinja template file
      item: a (benchmark_id, chart_dict) pair

    Returns:
      returns the (filepath, json_data) pair
    """
    file_name = fcompose(
        lambda x: r"{0}_{1}".format(x, j2_file_name),
        lambda x: re.sub(r"([0-9]+[abcd])\.(.+)\.yaml\.j2",
                         r"\1\2.json",
                         x)
    )
    return pipe(
        item[0],
        file_name,
        lambda file_: os.path.join(get_path(), '../_data/charts', file_),
        write_json(item[1])
    )


@memoize
def get_marks():
    """Get the mark data for the free energy charts

    Returns:
      a dictionary defined in marks.yaml
    """
    return pipe(
        os.path.join(get_path(), 'marks.yaml'),
        read_yaml
    )


def process_chart(id_, data, j2_file_name):
    """Process chart's YAML with data.

    Args:
      id_: the benchmark ID
      data: the data to process the YAML file
      j2_file_name: the name of the j2 file to process

    Returns:
      the rendered YAML as a dictionary
    """
    return pipe(
        get_chart_file(j2_file_name),
        render_yaml(data=data, id_=id_, marks=get_marks()[id_]),
        yaml.load
    )


def to_datetime(datetime_str, format_="%Y/%m/%d %H:%M:%S"):
    """Datetime formater for Jinja template.
    """
    return parse(datetime_str).strftime(format_)


@curry
def render_yaml(tpl_path, **kwargs):
    """Return the rendered yaml template.

    Args:
      tpl_path: path to the YAML jinja template
      **kwargs: data to render in the template

    Returns:
      the rendered template string
    """
    path, filename = os.path.split(tpl_path)
    loader = jinja2.FileSystemLoader(path or './')
    env = jinja2.Environment(loader=loader)
    env.filters['to_yaml'] = yaml.dump
    env.filters['to_datetime'] = to_datetime
    return env.get_template(filename).render(**kwargs)


def main(filter_func, j2_file_name):
    """Generate the chart JSON files

    Args:
      filter_func: function to filter simulaton YAML data
      j2_file_name: the j2 file name to insert the data into

    Returns:
      list of (filepath, chart_json) pairs
    """
    return pipe(
        get_data(filter_func),
        itemmap(
            lambda item: (
                item[0],
                process_chart(item[0], item[1], j2_file_name)
            )
        ),
        itemmap(write_chart_json(j2_file_name))
    )


def landing_page_j2():
    """Get the name of the chart file

    Returns:
      the chart YAML file

    """
    return os.path.join(get_path(), 'charts', 'simulations.yaml.j2')


def landing_page_json():
    """Generate the landing page JSON vega spec.

    Returns:
      (filepath, chart_json) pairs
    """
    def extract_id(name):
        """Extract benchmark ID from png path
        """
        return name.replace("../images/", "").replace('_free_energy.png', '')
    return pipe(
        ['1a.1_free_energy.png',
         '1b.1_free_energy.png',
         '1c.1_free_energy.png',
         '1d.1_free_energy.png',
         '2a.1_free_energy.png',
         '2b.1_free_energy.png',
         '2c.1_free_energy.png',
         '2d.1_free_energy.png'],
        map(lambda name: os.path.join("..", 'images', name)),
        enumerate,
        map(
            lambda tup: (
                lambda count, name: dict(path=name,
                                         col=(count % 4),
                                         row=count // 4,
                                         link=extract_id(name))
                )(*tup)
        ),
        list,
        lambda data: j2_to_json(landing_page_j2(),
                                os.path.join(get_path(),
                                             '../_data/charts',
                                             'simulations.json'),
                                data=data)
    )


def j2_to_json(path_in, path_out, **kwargs):
    """Render a yaml.j2 chart to JSON.

    Args:
      path_in: the j2 template path
      path_out: the JSON path to write to
      kwargs: data to pass to the j2 template

    Returns:
      the file path and JSON string
    """
    return pipe(
        render_yaml(path_in, **kwargs),
        yaml.load,
        write_json(filepath=path_out)
    )


if __name__ == "__main__":
    main(filter_data('free_energy'), 'free_energy.yaml.j2')
    main(filter_memory_data, 'memory.yaml.j2')
    landing_page_json()
