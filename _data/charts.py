"""Data pipelines to parse benchmark YAML for charts.

Extracts benchmark YAML and combines with template chart YAML for Vega
charts. Run `python _data/charts.py` to build the charts.
"""

import glob
import os
import json

from toolz.curried import map, pipe, get, curry, filter, valmap, itemmap, groupby, memoize # pylint: disable=redefined-builtin, no-name-in-module

import ruamel.yaml as yaml


def id_to_yaml():
    """Maps benchmark id to the Vega YAML template.

    Returns:
      the mapping as a dict
    """
    return {'1a' : '1a_free_energy.yaml',
            '1b' : '1b_free_energy.yaml'}

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
        os.path.join(get_path(), 'benchmarks/*/meta.yaml'),
        glob.glob,
        map(lambda path_: (os.path.split(os.path.split(path_)[0])[1], read_yaml(path_))),
        filter(lambda item: item[0] != 'example'),
        groupby(lambda item: item[1]['benchmark']['id']),
        valmap(filter_data),
    )

@memoize
def get_chart(id_):
    """Read the chart YAML

    Args:
      id_: the benchmark id

    Returns:
      the chart template

    """
    return read_yaml(os.path.join(get_path(), 'charts', id_to_yaml()[id_]))

def write_chart_json(item):
    """Write a chart JSON file.

    Args:
      item: a (benchmark_id, chart_dict) pair

    Returns:
      returns the (filepath, json_data) pair
    """
    return pipe(
        item[0],
        lambda id_: id_to_yaml()[id_].replace('.yaml', '.json'),
        lambda file_: os.path.join(get_path(), '../data/charts', file_),
        write_json(item[1]) # pylint: disable=no-value-for-parameter
    )

def update_chart_data(chart_data, data):
    """Update the chart YAML with the benchmark YAML data.

    Args:
      chart_data: the chart YAML
      data: the benchmark YAML data

    Returns:
      the updated chart data
    """
    return pipe(
        data,
        map(lambda datum: update_dict(chart_data['marks'][0],
                                      **{'from' : dict(data=datum['name'])})),
        list,
        lambda marks: update_dict(chart_data, marks=marks),
        lambda chart_data_: update_dict(chart_data_,
                                        data=chart_data_['data'] + data)
    )

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
                update_chart_data(get_chart(item[0]), item[1])
            )
        ),
        itemmap(write_chart_json)
    )

if __name__ == "__main__":
    main()
