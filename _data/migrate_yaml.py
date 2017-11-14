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
        author = data['metadata']['author']
        if author == "A. M. Jokisaari":
            author = "Andrea Jokisaari"
        data['metadata']['author'] = dict(first=author.split(' ')[0],
                                          last=author.split(' ')[-1])
        return data

    migrate(migrate_f)
