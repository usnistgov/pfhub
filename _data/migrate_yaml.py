import os
import glob

from toolz.curried import pipe, valmap, itemmap, do, map, update_in, assoc
import yaml

from simulations import get_path, read_yaml


def migrate(func):
    return pipe(
        get_yaml_data(),
        dict,
        valmap(func),
        do(itemmap(lambda x: write_yaml_data(*x)))
    )


def get_yaml_data():
    return pipe(
        os.path.join(get_path(), 'simulations/*/meta.y*ml'),
        glob.glob,
        sorted,
        map(lambda path_: (path_, read_yaml(path_)))
    )


def write_yaml_data(filepath, data):
    with open(filepath, 'w') as stream:
        yaml.safe_dump(data, stream, default_flow_style=False, indent=2)
    return (filepath, data)


if __name__ == '__main__':
    ## add github_id to metadata
    # migrate(
    #     update_in(keys=['metadata'],
    #               func=assoc(key='github_id', value=None))
    #     )

    migrate(
        update_in(keys=['metadata'],
                  func=assoc(key='github_id', value=""))
        )
