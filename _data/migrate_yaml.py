"""Script to migrate the meta.yaml files

Script to migrate the meta.yaml files when the schema changes. Edit
the callback function at the bottom of the file.

"""

import os
import glob

# pylint: disable=redefined-builtin
from toolz.curried import pipe, valmap, itemmap, do, get, map, curry
import yaml


def get_path():
    """Return the local file path for this file.

    Returns:
      the filepath
    """
    return pipe(__file__, os.path.realpath, os.path.split, get(0))


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
        get_yaml_data(), dict, valmap(func), do(itemmap(lambda x: write_yaml_data(*x)))
    )


def get_yaml_data():
    """Read the meta.yaml files

    Returns:
      a dictionary with keys as the file paths and values as
      dictionaries of YAML data
    """
    return pipe(
        os.path.join(get_path(), "simulations/*/meta.y*ml"),
        glob.glob,
        sorted,
        map(lambda path_: (path_, read_yaml(path_))),
    )


@curry
def write_yaml_data(filepath, data):
    """Write data to YAML file

    Args:
      filepath: the path to the YAML file
      data: a dictionary to write to the YAML file

    """
    with open(filepath, "w") as stream:
        yaml.safe_dump(data, stream, default_flow_style=False, indent=2)
    return (filepath, data)


if __name__ == "__main__":

    def migrate_f(data):
        """Migration callback"""
        if "MOOSE" in data["metadata"]["implementation"]["name"]:
            data["metadata"]["implementation"]["name"] = "moose"
        if data["metadata"]["implementation"]["name"] == "1stOrderSemiOpt.edp":
            data["metadata"]["implementation"]["name"] = "custom"
        if "tester" in data["metadata"]["implementation"]["name"]:
            data["metadata"]["implementation"]["name"] = "custom"
        print(data["metadata"]["implementation"]["name"])

        return data

    migrate(migrate_f)
