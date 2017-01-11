"""Data pipelines to parse benchmark YAML for charts.

Extracts benchmark YAML and combines with template chart YAML for Vega
charts. Run `python _data/charts.py` to build the charts.
"""

import glob
import os
import json

import jinja2
from toolz.curried import map, pipe, get, curry, filter, valmap, itemmap, groupby, memoize # pylint: disable=redefined-builtin, no-name-in-module
import yaml


def free_energy_file():
    """Get the free energy chart template file name

    Returns:
      the file name
    """
    return 'free_energy.yaml.j2'

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

def filter_data(yaml_data):
    """Extract the free_energy data from the YAML files.

    Args:
      yaml_data: the benchmark YAML data

    Returns:
      the free_energy data from the YAML data
    """
    return pipe(
        yaml_data,
        dict,
        valmap(lambda val: val['data']),
        valmap(filter(lambda item: item['name'].lower() == 'free_energy')),
        valmap(list),
        valmap(get(0)),
        itemmap(lambda item: (item[0], update_dict(item[1], name=item[0]))),
        lambda dict_: list(dict_.values())
    )

def get_data():
    """Read in the YAML data and group by benchmark id

    Returns:
      a dictionary with benchmark ids as keys and lists of appropriate
      data for values
    """
    return pipe(
        os.path.join(get_path(), 'simulations/*/meta.yaml'),
        glob.glob,
        sorted,
        map(lambda path_: (os.path.split(os.path.split(path_)[0])[1], read_yaml(path_))),
        filter(lambda item: item[0] != 'example'),
        groupby(lambda item: item[1]['benchmark_id']),
        valmap(filter_data),
    )

def get_chart_file():
    """Get the name of the chart file

    Returns:
      the chart YAML file

    """
    return os.path.join(get_path(), 'charts', free_energy_file())


def write_chart_json(item):
    """Write a chart JSON file.

    Args:
      item: a (benchmark_id, chart_dict) pair

    Returns:
      returns the (filepath, json_data) pair
    """
    return pipe(
        item[0],
        lambda id_: item[0] + "_" + free_energy_file().replace('.yaml', '.json').replace('.j2', ''),
        lambda file_: os.path.join(get_path(), '../data/charts', file_),
        write_json(item[1]) # pylint: disable=no-value-for-parameter
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


def process_chart(id_, data):
    """Process chart's YAML with data.

    Args:
      id_: the benchmark ID
      data: the data to process the YAML file

    Returns:
      the rendered YAML as a dictionary
    """
    return pipe(
        get_chart_file(),
        render_yaml(data=data, id_=id_, marks=get_marks()[id_]), # pylint: disable=no-value-for-parameter
        yaml.load
    )

@curry
def render_yaml(tpl_path, **kwargs):
    """Return the rendered yaml template.

    Args:
      tpl_path: path to the YAML jinja template
      **kwargs: data to render in the template

    Retuns:
      the rendered template string
    """
    path, filename = os.path.split(tpl_path)
    loader = jinja2.FileSystemLoader(path or './')
    env = jinja2.Environment(loader=loader)
    env.filters['to_yaml'] = yaml.dump
    return env.get_template(filename).render(**kwargs)

def main():
    """Generate the chart JSON files

    Returns:
      list of (filepath, chart_json) pairs
    """
    return pipe(
        get_data(),
        itemmap(
            lambda item: (
                item[0],
                process_chart(item[0], item[1])
            )
        ),
        itemmap(write_chart_json)
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
    return pipe(
        ['1a_free_energy.png',
         '1b_free_energy.png',
         '1c_free_energy.png',
         '1d_free_energy.png',
         '2a_free_energy.png',
         '2b_free_energy.png',
         '2c_free_energy.png',
         '2d_free_energy.png'],
        map(lambda name: os.path.join("..", 'images', name)),
        enumerate,
        map(
            lambda tup: (lambda count, name: dict(path=name,
                                                  col=(count % 4),
                                                  row=count // 4,
                                                  link=name.replace("../images/", "")[:2])

            )(*tup)
        ),
        list,
        lambda data: render_yaml(landing_page_j2(), data=data),
        yaml.load,
        write_json(filepath=os.path.join(get_path(), '../data/charts/simulations.json')) # pylint: disable=no-value-for-parameter
    )


if __name__ == "__main__":
    main()
    landing_page_json()
