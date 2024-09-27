"""Tools for rendering the PFHub data.
"""

import os
import pathlib

from toolz.curried import filter as filter_
from toolz.curried import map as map_
from toolz.curried import (
    get_in,
    curry,
    assoc,
    pipe,
    do,
    get,
    tail,
    merge_with,
    identity,
    valmap,
    juxt,
    second,
    merge,
)
import numpy as np
import yaml
import pandas
import plotly.express as px
import plotly.graph_objects as go
from scipy.interpolate import griddata

from .func import (
    sequence,
    read_yaml,
    fullmatch,
    get_data_from_yaml,
    concat_items,
    make_id,
    read_yaml_from_url,
)
from .zenodo import zenodo_to_pfhub


BENCHMARK_PATH = str(
    pathlib.Path(__file__).resolve().parent / "../../simulation_list.yaml"
)


make_author = lambda x: pipe(
    x, get_in(["metadata", "author"]), get(["first", "last"]), " ".join
)


def read_add_name(yaml_url):
    """Add the name field to the meta.yaml data.

    Args:
      yaml_url: the url to the YAML file

    Returns:
      a dictionary of the data in the YAML file along with the name of
      the result

    Test using temporary test data

    >>> assert read_add_name(getfixture('yaml_data_file').as_uri())['name'] == 'result'

    >>> assert read_add_name(
    ...     getfixture('yaml_data_file_with_name'
    ... ).as_uri())['name'] == 'result1'

    """
    matchzenodo = fullmatch(r"https://doi.org/\d{2}.\d{4}/zenodo.\d{7}")
    process = (
        lambda x: yaml.safe_load(zenodo_to_pfhub(x))
        if matchzenodo(x)
        else read_yaml_from_url(x)
    )

    return pipe(
        yaml_url,
        process,
        lambda x: x
        if "name" in x
        else assoc(x, "name", os.path.split(os.path.split(yaml_url)[0])[1]),
    )


@curry
def resolve_path(benchmark_path, url):
    """Fix a relative path from the simulation_list.yaml file

    Relative paths are allowed in the simulation_list.yaml. This turns
    those relative paths into correct URIs if not already a URI.

    Args:
      benchmark_path: path to the file with the benchmark result list
      url: the URL to repair

    Returns:
      the repaired URL

    >>> resolve_path(None, "file:///blah/blah")
    'file:///blah/blah'

    """
    if url[:4] in ["http", "file"]:
        return url
    return (pathlib.Path(benchmark_path).parent / url).as_uri()


@curry
def get_yaml_data(benchmark_path, benchmark_ids):
    """Get all the simulation yaml data for the given benchmarks

    Args:
      benchmark_path: path to data file used by glob
      benchmark_ids: sequence of benchmark ids

    Returns:
      all the data for the given benchmarks

    >>> d = getfixture('test_data_path')
    >>> data = list(get_yaml_data(str(d), ['1a.1', '2a.1']))
    >>> assert data[0]['name'] in ['result1', 'result2']
    >>> assert data[1]['name'] in ['result1', 'result2']


    """
    return pipe(
        benchmark_path,
        read_yaml,
        map_(resolve_path(benchmark_path)),
        map_(read_add_name),
        filter_(lambda x: make_id(x) in benchmark_ids),
    )


@curry
def update_column(func, columns, dataframe):
    """Apply function to columns in a dataframe

    Args:
      func: the function to apply
      columns: the columns to apply the function
      dataframe: the dataframe to change

    Returns:
      a new dataframe with updated columns

    >>> update_column(
    ...     lambda x: x + 1,
    ...     columns=('x',),
    ...     dataframe=pandas.DataFrame(dict(x=[1, 2], y=[1, 2]))
    ... )
       x  y
    0  2  1
    1  3  2

    """
    return dataframe.apply(lambda x: func(x) if x.name in columns else x)


def table_results(data):
    """Generate a simpler record for a table of data

    Args:
      data: data from a meta.yaml

    Returns:
      a flattened subset of the data suitable for a table of data

    >>> import datetime
    >>> expected = merge(dict(
    ...     Name='result',
    ...     Code='code_name',
    ...     Benchmark='1a.1',
    ...     Author='first last',
    ...     Timestamp=datetime.date(2021, 12, 7),
    ... ), {"GitHub ID": "githubid"})
    >>> data = read_add_name(getfixture('yaml_data_file').as_uri())
    >>> assert table_results(data) == expected

    """
    return merge(
        {
            "Name": data["name"],
            "Code": data["metadata"]["implementation"]["name"],
            "Benchmark": make_id(data),
            "Author": make_author(data),
            "Timestamp": data["metadata"]["timestamp"],
        },
        {"GitHub ID": data["metadata"]["author"]["github_id"]},
    )


@curry
def get_table_data(benchmark_ids, benchmark_path=BENCHMARK_PATH):
    """Get a Pandas DataFrame of result data

    Args:
      benchmark_ids: sequence of benchmark ids
      benchmark_path: path to data file used by glob

    Returns:
      Pandas DataFrame of data

    >>> d = getfixture('test_data_path')
    >>> actual= get_table_data(['1a.1', '2a.1'], benchmark_path=str(d.resolve()))
    >>> print(actual.sort_values(['Name']).to_string(index=False))
       Name      Code Benchmark     Author  Timestamp GitHub ID
    result1 code_name      1a.1 first last 2021-12-07  githubid
    result2 code_name      2a.1 first last 2021-12-07  githubid

    """
    to_datetime = lambda x: pandas.to_datetime(x, errors="raise", utc=True)
    format_date = lambda x: x.dt.strftime("%Y-%m-%d", format='mixed')
    return pipe(
        benchmark_ids,
        get_yaml_data(benchmark_path),
        map_(table_results),
        pandas.DataFrame,
        update_column(to_datetime, ["Timestamp"]),
        update_column(format_date, ["Timestamp"]),
        lambda x: x.sort_values(by="Timestamp", ascending=False),
    )


@curry
def make_clickable(pfhub_path, name):
    """Return a link to the results name

    Args:
      pfhub_path: path to the pfhub base name
      name: the name of the simulation

    Returns:
      complete path to the simulation link

    >>> print(make_clickable('https://blah.com/', 'blah'))
    <a target="_blank" href="https://blah.com/simulations/display/?sim=blah">blah</a>
    """  # pylint: disable=line-too-long # noqa: E501
    link = os.path.join(pfhub_path, "simulations/display/?sim=")
    return f'<a target="_blank" href="{link}{name}">{name}</a>'


@curry
def get_table_data_style(
    benchmark_ids,
    benchmark_path=BENCHMARK_PATH,
    pfhub_path="https://pages.nist.gov/pfhub",
):
    """Get a Pandas DataFrame of result data styled

    Args:
      benchmark_ids: sequence of benchmark ids
      benchmark_path: path to data file used by glob

    Returns:
      Pandas DataFrame style object

    >>> d = getfixture('test_data_path')
    >>> actual= get_table_data_style(['1a.1', '2a.1'], benchmark_path=str(d.resolve()))
    >>> print(actual)  # doctest: +ELLIPSIS
    <pandas.io.formats.style.Styler object at ...>

    """
    return pipe(
        get_table_data(benchmark_ids, benchmark_path=benchmark_path),
        lambda x: x.reindex(
            ["Benchmark", "Timestamp", "Name", "Code", "Author", "GitHub ID"], axis=1
        ),
        lambda x: x.style.format({"Name": make_clickable(pfhub_path)}).hide(
            axis="index"
        ),
        lambda x: x.hide(axis="columns", subset="Benchmark"),
    )


@curry
def get_result_data(data_names, benchmark_ids, keys, benchmark_path=BENCHMARK_PATH):
    """Get result data concatenated into a single DataFrame

    Args:
      data_names: the names of the data blocks
      benchmark_ids: sequence of benchmark ids
      keys: columns of each data item
      benchmark_path: path to data file used by glob

    Returns:
      Pandas DataFrame of concatenated data

    >>> d = getfixture('test_data_path')
    >>> actual = get_result_data(
    ...     ['free_energy'],
    ...     ['1a.1', '2a.1'],
    ...     ['x', 'y'],
    ...     benchmark_path=str(d),
    ... )
    >>> print(actual.sort_values(['x', 'y', 'sim_name']).to_string(index=False))
      x   y    data_set benchmark_id sim_name
    0.0 0.0 free_energy         1a.1  result1
    0.0 0.0 free_energy         2a.1  result2
    1.0 1.0 free_energy         1a.1  result1
    1.0 1.0 free_energy         2a.1  result2

    """
    return pipe(
        benchmark_ids,
        get_yaml_data(benchmark_path),
        map_(
            lambda x: (
                {"benchmark_id": make_id(x), "sim_name": x["name"]},
                get_data_from_yaml(data_names, keys, x),
            )
        ),
        concat_items,
    )


def line_plot(
    data_name,
    benchmark_id,
    layout=None,
    columns=("x", "y"),
    benchmark_path=BENCHMARK_PATH,
):
    """Generate a Plotly line plot from the benchmark data  # noqa: E501

    Args:
      data_name: the name of the data blocks
      benchmark_id: the benchmark_id
      layout: dictionary with "x", "y" and "title" keys to customize the plot
      columns: the columns to plot from the data blocks
      benchmark_path: path to data files (used by glob)

    >>> d = getfixture('test_data_path')
    >>> line_plot(
    ...     'free_energy',
    ...     '1a.1',
    ...     columns=('x', 'y'),
    ...     benchmark_path=str(d),
    ... )
    Figure({
        'data': [{'hovertemplate': 'Simulation Result=result1<br>x=%{x}<br>y=%{y}<extra></extra>',
    ...
                   'yaxis': {'anchor': 'x', 'domain': [0.0, 1.0], 'title': {'text': 'y'}}}
    })

    """
    if layout is None:
        layout = {}

    aspect_ratio = get("aspect_ratio", layout, False)

    return pipe(
        get_result_data(
            [data_name], [benchmark_id], list(columns), benchmark_path=benchmark_path
        ),
        lambda x: px.line(
            x,
            x=columns[0],
            y=columns[1],
            color="sim_name",
            labels={
                columns[0]: get("x_label", layout, default="x"),
                columns[1]: get("y_label", layout, default="y"),
                "sim_name": "Simulation Result",
            },
            title=get("title", layout, default=""),
            log_x=get("log_x", layout, default=False),
            log_y=get("log_y", layout, default=False),
            range_y=get("range_y", layout, default=None),
        ),
        do(
            lambda x: x.update_layout(
                title_x=0.5,
                yaxis=(
                    {"scaleratio": aspect_ratio, "scaleanchor": "x"}
                    if aspect_ratio
                    else {}
                ),
            )
        ),
    )


def levelset_plot(
    data, layout=None, columns=("x", "y", "z"), mask_func=lambda x: slice(len(x))
):
    """Generate a Plotly level set plot

    Args:
      data: extracted data as a data frame
      layout: dictionary with "x", "y" and "title" keys to customize the plot
      mask_func: function to apply to remove values (helps to reduce memory usage)

    >>> x, y = np.mgrid[-1:1:10j, -1:1:10j]
    >>> x = x.flatten()
    >>> y = y.flatten()
    >>> r = np.sqrt((x)**2 + (y)**2)
    >>> z = 1 - r
    >>> sim_name = ['a'] * len(x)
    >>> d = dict(x=x, y=y, z=z, sim_name=sim_name)
    >>> df = pandas.DataFrame(d)
    >>> levelset_plot(df, layout={'levelset' : 0.5})
    Figure({
        'data': [{'colorscale': [[0, 'rgb(229, 134, 6)'], [1, 'rgb(229, 134, 6)']],
    ...
                   'yaxis': {'range': [-1, 1], 'scaleanchor': 'x', 'scaleratio': 1}}
    })
    >>> df.z = df.z - 0.5
    >>> levelset_plot(df)
    Figure({
        'data': [{'colorscale': [[0, 'rgb(229, 134, 6)'], [1, 'rgb(229, 134, 6)']],
    ...
                   'yaxis': {'range': [-1, 1], 'scaleanchor': 'x', 'scaleratio': 1}}
    })

    """
    if layout is None:
        layout = {}

    colorscale = lambda index: pipe(
        px.colors.qualitative.Vivid,
        lambda x: x[index % len(x)],
        lambda x: [[0, x], [1, x]],
    )

    get_contour = lambda df, name, counter: go.Contour(
        z=df[columns[2]],
        x=df[columns[0]],
        y=df[columns[1]],
        contours={
            "start": get("levelset", layout, 0.0),
            "end": get("levelset", layout, 0.0),
            "size": 0.0,
            "coloring": "lines",
        },
        colorbar=None,
        showscale=False,
        line_width=2,
        name=name,
        showlegend=True,
        colorscale=colorscale(counter),
    )

    update_layout = lambda fig: fig.update_layout(
        title=get("title", layout, ""),
        title_x=0.5,
        xaxis={"range": get("range", layout, [-1, 1]), "constrain": "domain"},
        yaxis={
            "scaleanchor": "x",
            "scaleratio": 1,
            "range": get("range", layout, [-1, 1]),
        },
    )

    return pipe(
        data,
        lambda df: df[mask_func(df)],
        lambda x: x.groupby("sim_name"),
        enumerate,
        map_(lambda x: get_contour(df=x[1][1], name=x[1][0], counter=x[0])),
        list,
        go.Figure,
        do(update_layout),
    )


def make_grid(stepsx, stepsy):
    """Generate a grid using Numpy's mgrid

    Args:
      stepsx: [low, high], number of points in x direction
      stepsy: [low, high], number of points in y direction

    Returns:
      mesh-grid ndarrays all of the same dimensions

    >>> make_grid(([0.1, 0.9], 2), ([0.1, 0.3], 3))
    (array([[0.1, 0.1, 0.1],
           [0.9, 0.9, 0.9]]), array([[0.1, 0.2, 0.3],
           [0.1, 0.2, 0.3]]))

    """
    slice_ = lambda x, n: slice(x[0], x[1], n * 1j)
    grid_x, grid_y = np.mgrid[slice_(*stepsx), slice_(*stepsy)]
    return grid_x, grid_y


@curry
def interp(keys, stepsx, stepsy, dataframe):
    """Interpolate unstructured data to a grid

    Args:
      keys: columns in dataframe to use
      stepsx: [low, high], number of points in x direction
      stepsy: [low, high], number of points in y direction

    Returns:
      interpolated values

    >>> expected = [[0, 0.5], [0.25, 0.75], [0.5, 1], [0, 0], [0, 0 ]]
    >>> actual = interp(
    ...     ['x', 'y', 'z'],
    ...     ([0., 2.], 5),
    ...     ([0., 1.], 2),
    ...     pandas.DataFrame(dict(
    ...         x=[0, 1, 0, 1, 0.5],
    ...         y=[0, 0, 1, 1, 0.5],
    ...         z=[0, 0.5, 0.5, 1, 0.5])
    ...     )
    ... )
    >>> assert np.allclose(actual, expected)

    """
    return griddata(
        np.array([dataframe[keys[0]], dataframe[keys[1]]]).T,
        dataframe[keys[2]],
        make_grid(stepsx, stepsy),
        method="cubic",
        fill_value=0.0,
    )


@curry
def order_of_accuracy_values_(keys, stepsx, stepsy, dataframe):
    """Calculate order of accuracy from benchmark field data for a series
    of data items

    Args:
      keys: the column names to used (e.g. ['x', 'y', 'phase_field'])
      stepsx: [low, high], number of points in x direction
      stepsy: [low, high], number of points in y direction
      dataframe: dataframe with columns corresponding to the keys

    Returns:
      tuple of estimated grid spacings and L2 norms

    >>> def make_df(nx):
    ...     x, y = np.mgrid[0:1:(nx - 1) * 1j, 0:1:(nx - 1) * 1j]
    ...     x = x.flatten()
    ...     y = y.flatten()
    ...     return pandas.DataFrame(
    ...        dict(x=x, y=y, z=x * y, sim_name='sim1', data_set=nx)
    ...     )

    >>> out = order_of_accuracy_values_(
    ...     ('x', 'y', 'z'),
    ...     ([0, 1], 1000),
    ...     ([0, 1], 1000),
    ...     pandas.concat([make_df(10), make_df(20), make_df(40)])
    ... )

    >>> v = out['sim1']
    >>> accuracy = (np.log(v[1][-1]) - np.log(v[1][0])) / (
    ...     np.log(v[0][-1]) - np.log(v[0][0])
    ... )
    >>> assert accuracy > 2

    """

    effective_dx = lambda df: np.sqrt(cell_area(len(df)))
    cell_area = (
        lambda n: (stepsx[0][1] - stepsx[0][0]) * (stepsy[0][1] - stepsy[0][0]) / n
    )

    norm = curry(
        lambda ref, x: np.linalg.norm(x - ref, ord=2)
        * np.sqrt(cell_area(stepsx[1] * stepsy[1]))
    )
    clean = sequence(list, tail(-1), np.array)

    error = sequence(
        map_(interp(keys, stepsx, stepsy)),
        list,
        lambda x: map_(norm(x[0]), x),
        clean,
    )

    dx_clean = sequence(map_(effective_dx), clean)

    return pipe(
        dataframe.data_set,
        dataframe.groupby,
        map_(second),
        list,
        # data,
        map_(lambda x: x.groupby("sim_name")),
        map_(tuple),
        map_(dict),
        merge_with(identity),
        valmap(sequence(curry(sorted)(key=len, reverse=True), juxt((dx_clean, error)))),
    )


def plot_order_of_accuracy(
    dataframe,
    keys,
    stepsx=([0, 1], 1000),
    stepsy=([0, 1], 1000),
    layout=None,
):  # pragma: no cover
    """Plot an order of accuracy plots for a series of result uploads.

    Args:
      dataframe: dataframe with columns corresponding to the keys
      keys: the column names to used (e.g. ['x', 'y', 'phase_field'])
      stepsx: [low, high], number of points in x direction
      stepsy: [low, high], number of points in y direction
      layout: dictionary with "x", "y" and "title" keys to customize the plot
      benchmark_path: path to data files used by glob

    """
    if layout is None:
        layout = {}

    make_order = lambda df: pandas.DataFrame(
        {
            "x": df.x,
            "y": df.x**2 * df.y[0] / df.x[0] ** 2,
            "sim_name": r"Δx<sup>2</sup>",
        }
    )

    return pipe(
        dataframe,
        order_of_accuracy_values_(keys, stepsx, stepsy),
        lambda x: x.items(),
        map_(lambda x: {"x": x[1][0], "y": x[1][1], "sim_name": x[0]}),
        map_(pandas.DataFrame),
        list,
        lambda x: pandas.concat(x + [make_order(x[0])]),
        lambda df: px.line(
            df,
            x="x",
            y="y",
            color="sim_name",
            log_x=True,
            log_y=True,
            labels=get("labels", layout, {}),
        ),
        lambda x: x.update_layout(
            title=get("title", layout, ""),
            title_x=0.5,
        ),
    )


def efficiency_plot(benchmark_id, benchmark_path=BENCHMARK_PATH):  # pragma: no cover
    """Plot memory usage vs. runtime for a given benchmark

    Args:
      benchmark_id: the benchmark ID to plot
      benchmark_path: path to data file used by glob
    """

    def df_time(id_):
        norm = lambda x: x.wall_time.astype(float) / x.sim_time.astype(float)
        return pipe(
            get_result_data(
                ["run_time"],
                [id_],
                ["sim_time", "wall_time"],
                benchmark_path=benchmark_path,
            ),
            lambda x: get(
                x.groupby(["sim_name"])["sim_time"].transform(max) == x["sim_time"], x
            ),
            lambda x: x.assign(time_norm=norm(x)),
        )

    def df_memory(id_):
        mem = {"KB": 1, "MB": 1024, "GB": 1024**2}
        func = lambda x: x.value * mem.get(x.unit, 1.0)
        return pipe(
            get_result_data(
                ["memory_usage"],
                [id_],
                ["value", "unit"],
                benchmark_path=benchmark_path,
            ),
            lambda x: x.assign(memory_norm=x.apply(func, axis=1)),
        )

    return pipe(
        pandas.merge(
            df_time(benchmark_id),
            df_memory(benchmark_id),
            on="sim_name",
        ),
        lambda x: px.scatter(
            x,
            x="time_norm",
            y="memory_norm",
            log_x=True,
            log_y=True,
            title="Numerical Efficiency",
            color="sim_name",
            labels={
                "sim_name": "Simulation Result",
                "time_norm": r"<i>t</i><sub>Wall</sub> / <i>t</i><sub>Sim</sub> *",
                "memory_norm": "Memory Usage [KB]",
            },
        ),
        lambda x: x.update_layout(title_x=0.5),
    )
