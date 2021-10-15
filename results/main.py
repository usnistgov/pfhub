from toolz.curried import filter as filter_
from toolz.curried import map as map_
from toolz.curried import get_in, curry, assoc, pipe, thread_first, do, get, compose, get_in, tail, merge_with, identity, valmap, juxt
import numpy as np
import glob
import os
from urllib.error import HTTPError, URLError
import yaml
import pandas
import plotly.express as px
import plotly.graph_objects as go
from scipy.interpolate import griddata


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

make_author = lambda x: pipe(
    x,
    get_in(['metadata', 'author']),
    get(['first', 'last']),
    lambda y: ' '.join(y)
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
        if x is None or len(x) == 0:
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
    return pipe(
        items,
        map_(lambda x: assign(x[0], x[1])),
        compact,
        list,
        maybe(pandas.concat)
    )


@curry
def update_column(func, columns, df):
    return df.apply(lambda x: func(x) if x.name in columns else x)


def table_results(data):
    return dict(
        Name=data['name'],
        Code=data['metadata']['implementation']['name'],
        Benchmark=make_id(data),
        Author=make_author(data),
        Timestamp=data['metadata']['timestamp']
    )


def get_yaml_data(benchmark_ids):
    return pipe(
        '../_data/simulations/*/meta.yaml',
        glob.glob,
        map_(read_add_name),
        filter_(lambda x: make_id(x) in benchmark_ids)
    )

def get_table_data(benchmark_ids):
    return pipe(
        benchmark_ids,
        get_yaml_data,
        map_(table_results),
        pandas.DataFrame,
        update_column(pandas.to_datetime, ["Timestamp"])
    )


@curry
def get_result_data(data_names, benchmark_ids, keys):
    return pipe(
        benchmark_ids,
        get_yaml_data,
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
    if data_format is None:
        return ','
    if data_format['type'] == 'csv':
        if 'remove_whitespace' in data_format and data_format['remove_whitespace']:
            return ',\s+'
        else:
            return ','
    elif data_format['type'] == 'tsv':
        return '\t'
    else:
        raise RunTimeError(f"{data_format} data format not supported")

@curry
def read_csv(sep, path):
    try:
        return pandas.read_csv(path, sep=sep, engine='python')
    except (HTTPError, URLError) as error:
        print(f"{error} for {path}")
        return None


def sequence(*args):
    """Compose functions in order

    Args:
      args: the functions to compose

    Returns:
      composed functions

    >>> assert sequence(lambda x: x + 1, lambda x: x * 2)(3) == 8
    """
    return compose(*args[::-1])


def read_vega_data(keys, data):
    read_url = sequence(
        get('url'),
        read_csv(sep(data.get('format'))),
        maybe(lambda x: x[list(data['format']['parse'].keys())])
    )

    read_values = sequence(
        get('values'),
        pandas.DataFrame
    )

    return pipe(
        data,
        read_url if 'url' in data else read_values,
        apply_transforms(data),
        maybe(get(keys))
    )


def line_plot(data_name, benchmark_id, layout=dict(), columns=('x', 'y')):
    return pipe(
        get_result_data([data_name], [benchmark_id], list(columns)),
        lambda x: px.line(
            x,
            x=columns[0],
            y=columns[1],
            color='sim_name',
            labels=dict(x=get('x', layout, default='x'), y=get('y', layout, default='y'), sim_name='Simulation Result'),
            title=get('title', layout, default='')
        ),
        do(lambda x: x.update_layout(title_x=0.5)),
    )


def levelset_plot(data_name, benchmark_id, layout=dict(), columns=('x', 'y', 'z'), mask_func=lambda x: slice(len(x))):
    colorscale = lambda index: pipe(
        px.colors.qualitative.Vivid,
        lambda x: x[index % len(x)],
        lambda x: [[0, x], [1, x]]
    )

    get_contour = lambda df, name, counter: go.Contour(
        z=df[columns[2]],
        x=df[columns[0]],
        y=df[columns[1]],
        contours=dict(
            start=get('levelset', layout, 0.0),
            end=get('levelset', layout, 0.0),
            size=0.0,
            coloring='lines'
        ),
        colorbar=None,
        showscale=False,
        line_width=2,
        name=name,
        showlegend=True,
        colorscale=colorscale(counter)
    )

    update_layout = lambda fig: fig.update_layout(
        title=get('title', layout, ''),
        title_x=0.5,
        xaxis=dict(
            range=get('range', layout, [-1, 1]),
            constrain='domain'
        ),
        yaxis=dict(
            scaleanchor = "x",
            scaleratio = 1,
            range=get('range', layout, [-1, 1]),
        )
    )

    return pipe(
        get_result_data([data_name], [benchmark_id], list(columns)),
        lambda df: df[mask_func(df)],
        lambda x: x.groupby('sim_name'),
        enumerate,
        map_(lambda x: get_contour(df=x[1][1], name=x[1][0], counter=x[0])),
        list,
        go.Figure,
        do(update_layout)
    )


def make_grid(nx, ny, rangex, rangey):
    sl = lambda x, n: slice(x[0], x[1], n * 1j)
    grid_x, grid_y =  np.mgrid[sl(rangex, nx), sl(rangey, ny)]
    return grid_x, grid_y

@curry
def interp(keys, nx, ny, rangex, rangey, df):
    return griddata(
        np.array([df[keys[0]], df[keys[1]]]).T,
        df[keys[2]],
        make_grid(nx, ny, rangex, rangey),
        method='cubic',
        fill_value=0.0
    )

def order_of_accuracy_values(data_names, benchmark_id, keys, rangex, rangey, nx=1000, ny=1000):
    effective_dx = lambda df: np.sqrt(cell_area(len(df)))
    cell_area = lambda n: (rangex[1] - rangex[0]) * (rangey[1] - rangey[0]) / n

    norm = curry(lambda ref, x: np.linalg.norm(x - ref, ord=2) * np.sqrt(cell_area(nx * nx)))
    clean = sequence(list, tail(-1), np.array)

    error = sequence(
        map_(interp(keys, nx, ny, rangex, rangey)),
        list,
        lambda x: map_(norm(x[0]), x),
        clean
    )

    dx_clean = sequence(
        map_(effective_dx),
        clean
    )

    return pipe(
        data_names,
        map_(get_result_data(benchmark_ids=[benchmark_id], keys=keys)),
        list,
        map_(lambda x: x.groupby('sim_name')),
        map_(tuple),
        map_(dict),
        merge_with(identity),
        valmap(sequence(
            curry(sorted)(key=len, reverse=True),
            juxt((dx_clean, error))
        ))
    )


def plot_order_of_accuracy(data_names, benchmark_id, keys, rangex, rangey, nx=1000, ny=1000, layout=dict()):
    def make_order(df):
        return pandas.DataFrame(dict(
            x=df.x, y=df.x**2 * df.y[0] / df.x[0]**2, sim_name=r'Δx<sup>2</sup>'
        ))

    return pipe(
        order_of_accuracy_values(
            data_names,
            benchmark_id,
            keys,
            rangex=rangex,
            rangey=rangey,
            nx=nx,
            ny=ny
        ).items(),
        map_(lambda x: dict(x=x[1][0], y=x[1][1], sim_name=x[0])),
        map_(pandas.DataFrame),
        list,
        lambda x: pandas.concat(x + [make_order(x[0])]),
        lambda df: px.line(df, x='x', y='y', color='sim_name', log_x=True, log_y=True, labels=get('labels', layout, dict())),
        lambda x: x.update_layout(
            title=get('title', layout, ''),
            title_x=0.5,
        )
    )
