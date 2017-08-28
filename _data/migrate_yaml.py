"""Script to migrate the meta.yaml files

Script to migrate the meta.yaml files when the schema changes. Edit
the callback function at the bottom of the file.

"""

import os
import glob

# pylint: disable=redefined-builtin
from toolz.curried import pipe, valmap, itemmap, do, map, assoc
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
    # migrate(
    #     update_in(keys=['metadata'],
    #               func=assoc(key='github_id', value=""))
    #     )

    # def ff(dd):
    #     if dd['metadata']['author'] == "Trevor Keller":
    #         if dd['metadata']['github_id'] == '':
    #             dd['metadata']['github_id'] = 'tkphd'
    #     return dd
    # def ff(dd):
    #     def update(d):
    #         if d["name"] == "run_time":
    #             if "sim_time" in d["values"][0] and "time" in d["values"][0]:
    #                 d['values'][0]["wall_time"] = d["values"][0]["time"]
    #                 del d["values"][0]["time"]
    #         return d
    #     dd["data"] = list(map(update, dd['data']))
    #     return dd
    # def f(x):
    #     def g(y):
    #         if y["name"] == "free_energy":
    #             y["transform"] = list(filter(lambda xx: xx["type"] != "filter",
    #                                          y["transform"]))
    #         return y
    #     x["data"] = list(map(g, x["data"]))
    #     return x
    # def f(x):
    #     if x["metadata"]["author"] == "Daniel Schwen":
    #         x["metadata"]["github_id"] = "dschwen"
    #     return x
    # def f(x):
    #     def g(y):
    #         if y["name"] == "memory_usage":
    #             y.pop("transform", None)
    #             if type(y["values"]) is dict:
    #                 y["values"] = [y["values"]]
    #             if "value_m" in y["values"][0]:
    #                 y["values"][0]["value"] = y["values"][0]["value_m"]
    #                 del y["values"][0]["value_m"]
    #         return y
    #     x['data'] = list(map(g, x['data']))
    #     if x["metadata"]["author"] == "Daniel Schwen":
    #         x["metadata"]["github_id"] = "dschwen"
    #     return x
    # def f(x):
    #     def h(y):
    #         if "expr" in y and "field" in y and "type" in y:
    #             y["as"] = y["field"]
    #             del y["field"]
    #         return y

    #     def g(y):
    #         if y["name"] == "free_energy":
    #             y['transform'] = list(map(h, y['transform']))
    #         return y
    #     x['data'] = list(map(g, x['data']))
    #     return x
    # def f(x):
    #     def g(y):
    #         if y["name"] == "memory_usage":
    #             if "value_per_rank" in y["values"][0]:
    #                 y["values"][0]["value"] = y["values"][0]["value_per_rank"]
    #                 del y["values"][0]["value_per_rank"]
    #         return y
    #     x['data'] = list(map(g, x['data']))
    #     return x
    def f(x):
        if x["metadata"]["author"] == "PC. Simon":
            x["metadata"]["github_id"] = "simopier"
        return x

    migrate(f)
