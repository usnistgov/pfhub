"""Script to migrate the meta.yaml files

Script to migrate the meta.yaml files when the schema changes. Edit
the callback function at the bottom of the file.

"""

import os
import glob

# pylint: disable=redefined-builtin
from toolz.curried import pipe, valmap, itemmap, do, map
import yaml

from simulations import get_path, read_yaml


def migrate(func):
    """Migrate the meta.yaml files using a callback function.

    This function reads and writes to the meta.yaml files.

    Args:
      func: the callback function which takes the YAML dictionary and
        returns a new dictionary

    Returns:
      a dictionary with file names as keys and values as dictionaries
      of the updated YAML data.
    """
    return pipe(
        get_yaml_data(),
        dict,
        valmap(func),
        do(itemmap(lambda x: write_yaml_data(*x)))
    )


def get_yaml_data():
    """Read the meta.yaml files

    Returns:
      a dictionary with keys as the file paths and values as
      dictionaries of YAML data
    """
    return pipe(
        os.path.join(get_path(), 'simulations/*/meta.y*ml'),
        glob.glob,
        sorted,
        map(lambda path_: (path_, read_yaml(path_)))
    )


def write_yaml_data(filepath, data):
    """Write data to YAML file

    Args:
      filepath: the path to the YAML file
      data: a dictionary to write to the YAML file

    """
    with open(filepath, 'w') as stream:
        yaml.safe_dump(data, stream, default_flow_style=False, indent=2)
    return (filepath, data)


if __name__ == '__main__':
    def migrate_f(data):
        """Migrate function
        """
        if 'github_id' in data['metadata']:
            data['metadata']['author']['github_id'] = \
                data['metadata']['github_id']
            del data['metadata']['github_id']
        if 'email' in data['metadata']:
            data['metadata']['author']['email'] = data['metadata']['email']
            del data['metadata']['email']
        if 'details' in data['metadata']['hardware']:
            del data['metadata']['hardware']['details']
        if 'details' in data['metadata']['implementation']:
            del data['metadata']['implementation']['details']
        if 'end_condition' in data['metadata']['implementation']:
            del data['metadata']['implementation']['end_condition']
        if 'software' in data['metadata']:
            data['metadata']['implementation']['name'] = \
                data['metadata']['software']['name']
            del data['metadata']['software']
        data['metadata']['hardware']['acc_architecture'] = 'none'
        if 'architecture' in data['metadata']['hardware']:
            data['metadata']['hardware']['cpu_architecture'] = \
                data['metadata']['hardware']['architecture']
            del data['metadata']['hardware']['architecture']
        if 'container_url' not in data['metadata']['implementation']:
            data['metadata']['implementation']['container_url'] = ''
        if 'nodes' not in data['metadata']['hardware']:
            data['metadata']['hardware']['nodes'] = 1
        if 'clock_rate' not in data['metadata']['hardware']:
            data['metadata']['hardware']['clock_rate'] = 0
        if 'cpu_architecture' not in data['metadata']['hardware']:
            data['metadata']['hardware']['cpu_architecture'] = 'x86_64'
        return data

    migrate(migrate_f)
