from toolz.curried import filter as filter_
from toolz.curried import map as map_
from toolz.curried import get_in, curry, assoc, pipe, thread_first, do, get
import glob
import os
from urllib.error import HTTPError
import yaml
import pandas


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


make_id = lambda x: '.'.join(
    [x['benchmark']['id'], str(x['benchmark']['version'])]
)


def read_add_name(yaml_path):
    return assoc(
        read_yaml(yaml_path),
        'name',
        os.path.split(os.path.split(yaml_path)[0])[1]
    )

def maybe(func):
    @curry
    def wrapper(*args):
        x = args[-1]
        if x is None:
            return None
        else:
            return func(*args)
    return wrapper


@maybe
def assign(columns, df):
    return df.assign(**columns)


def compact(items):
    return filter(lambda x: x is not None, items)

def concat_items(items):
    stuff = list(items)
    # print('stuff', stuff)
    out = list(compact(map_(lambda x: assign(x[0], x[1]), stuff)))
    if len(out) > 0:
        return pandas.concat(out)
    else:
        return None


def get_result_data(data_names, benchmark_ids, keys):
    return pipe(
        '../_data/simulations/*/meta.yaml',
        glob.glob,
        map_(read_add_name),
        filter_(lambda x: make_id(x) in benchmark_ids),
        map_(lambda x: (dict(benchmark_id=make_id(x), sim_name=x['name']), get_data_from_yaml(data_names, keys, x))),
        concat_items
    )


@curry
def get_data_from_yaml(data_names, keys, yaml_data):
    return pipe(
        yaml_data,
        get('data'),
        filter_(lambda x: x['name'] in data_names),
        map_(lambda x: (dict(data_set=x['name']), read_vega_data(keys, x))),
        concat_items
    )

@curry
def apply_transform(transform, values):
    if transform['type'] == 'formula':
        datum = values
        exec("values[transform['as']] = " + transform['expr'])
    else:
        raise RunTimeError(f"{transform['type']} transform type is not supported")



@maybe
def apply_transforms(data, values):
    if 'transform' in data:
        return thread_first(
            values,
            *list(map_(lambda x: do(apply_transform(x)), data['transform']))
        )
    else:
        return values

def sep(data_format):
    if 'remove_whitespace' in data_format and data_format['remove_whitespace']:
        return ',\s+'
    else:
        return ','

@curry
def read_csv(sep, path):
    try:
        return pandas.read_csv(path, sep=sep, engine='python')
    except HTTPError:
        print(f"404 for {path}")
        return None

def read_vega_data(keys, data):
    if 'url' in data:
        if data['format']['type'] == 'csv':
            return pipe(
                data['url'],
                read_csv(sep(data['format'])),
                maybe(lambda x: x[list(data['format']['parse'].keys())]),
                apply_transforms(data),
                maybe(get(keys))
            )
        else:
            raise RunTimeError(f"{data['format']} data format not supported")

    else:
        return pipe(
            data['values'],
            pandas.DataFrame,
            apply_transforms(data),
            maybe(get(keys))
        )
