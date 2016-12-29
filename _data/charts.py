from toolz.curried import map, pipe, compose, get, do, curry, count, pluck, juxt, flip, remove, filter, keyfilter, valfilter, valmap, itemmap
import ruamel.yaml as yaml
import glob
import os

def read_yaml(filepath):
    with open(filepath) as stream:
        data = yaml.safe_load(stream)
    return dict(name=os.path.split(os.path.split(filepath)[0])[1], data=data)

def get_path():
    return pipe(
        __file__,
        os.path.realpath,
        os.path.split,
        get(0)
    )

@curry
def update_dict(dict_, **kwargs):
    return dict(list(dict_.items()) + list(kwargs.items()))


data = pipe(
    os.path.join(get_path(), 'benchmarks/*/meta.yaml'),
    glob.glob,
    map(read_yaml),
    dict,
    keyfilter(lambda key: key != 'example'),
    groupby()
    valfilter(lambda val: val['benchmark']['id'] == '1a'),
    valmap(lambda val: val['data']),
    valmap(filter(lambda item: item['name'].lower() == 'free_energy')),
    valmap(list),
    valmap(get(0)),
    itemmap(lambda item: (item[0], update_dict(item[1], name=item[0]))),
    lambda dict_: list(dict_.values())
    # itemmap(lambda key, val:, (key, list(dict(**vals).items()) +
    # filter(lambda data: data['data']['benchmark']['id'].lower() == '1a'),
    # map(lambda data: dict(name=data['name'], data=data['data']['data'])),
    # # map(filter(lambda data: data['data']['name'].lower() == 'free_energy')),
    # # map(list),
)

print(data)

print(update_dict(dict(a=1, b=3), a=2, b=4))
