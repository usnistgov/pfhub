import os
from toolz.curried import map, pipe, get, curry, filter, valmap, itemmap, groupby, memoize # pylint: disable=redefined-builtin, no-name-in-module
from simulations import get_path, render_yaml, get_yaml_data, write_json
import yaml

def table_yaml():
    """Path to table YAML.
    """
    return os.path.join(get_path(), 'table.yaml.j2')

@curry
def write_yaml(data, filepath):
    with open(filepath, 'w') as stream:
        yaml.dump(data, stream, indent=2)
    return (filepath, data)

def build_table_json():
    return pipe(
        get_yaml_data(),
        lambda data: render_yaml(table_yaml(), data=data),
        yaml.load,
        write_yaml(filepath=os.path.join(get_path(), '../data/data_table.yaml'))
    )

if __name__ == '__main__':
    print(build_table_json())
