"""Data pipeline to build data for simulation data table.
"""

import os

import yaml
from toolz.curried import pipe, curry# pylint: disable=redefined-builtin, no-name-in-module
from simulations import get_path, render_yaml, get_yaml_data


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

def build_table_yaml():
    """Make simulation datatable from meta.yaml's.
    """
    return pipe(
        get_yaml_data(),
        lambda data: render_yaml(table_yaml(), data=data),
        yaml.load,
        write_yaml(filepath=os.path.join(get_path(), '../data/data_table.yaml')) # pylint: disable=no-value-for-parameter
    )

if __name__ == "__main__":
    build_table_yaml()
