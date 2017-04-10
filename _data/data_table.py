"""Data pipeline to build data for simulation data table.
"""
# pylint: disable=no-value-for-parameter

import os

import yaml
# pylint: disable=redefined-builtin, no-name-in-module
from toolz.curried import pipe, curry, map, groupby, get, valmap, count

from simulations import get_path, render_yaml, get_yaml_data, j2_to_json


def table_yaml():
    """Path to table YAML.
    """
    return os.path.join(get_path(), 'table.yaml.j2')


@curry
def write_yaml(data, filepath):
    """Write yaml
    """
    with open(filepath, 'w') as stream:
        yaml.dump(data, stream, indent=2)
    return (filepath, data)


def make_table_yaml():
    """Make simulation datatable from meta.yaml's.
    """
    return pipe(
        get_yaml_data(),
        lambda data: render_yaml(table_yaml(), data=data),
        yaml.load,
        write_yaml(filepath=os.path.join(get_path(),
                                         '../_data/data_table.yaml'))
    )


def groupby_count(func):
    """Group the simulation data based on a function.

    Args:
      func: function to group by

    Returns:
      grouped data
    """
    return pipe(
        get_yaml_data(),
        map(get(1)),
        groupby(func),
        valmap(count),
    )


def code_upload_yaml_path():
    """Path to the upload chart j2.
    """
    return os.path.join(get_path(), 'charts', 'code_upload.yaml.j2')


def make_upload_chart(gfunc, yaml_path, json_path, title):
    """Create an upload chart

    Args:
      gfunc: the group by function
      yaml_path: the template path
      json_path: the path to write to
      title: the title of the chart

    Returns:
      the chart JSON
    """
    return pipe(
        gfunc,
        groupby_count,
        lambda data: list(data.items()),
        lambda data: sorted(data, key=lambda item: (-item[1], item[0])),
        lambda data: j2_to_json(yaml_path,
                                json_path,
                                data=data,
                                title=title)
    )


if __name__ == "__main__":
    make_table_yaml()
    make_upload_chart(lambda item: item['metadata']['software']['name'],
                      code_upload_yaml_path(),
                      os.path.join(get_path(),
                                   '../_data/charts/code_upload.json'),
                      'Uploads per Code')

    make_upload_chart(lambda item: item['benchmark']['id'],
                      code_upload_yaml_path(),
                      os.path.join(get_path(),
                                   '../_data/charts/benchmark_upload.json'),
                      'Uploads per Benchmark')
