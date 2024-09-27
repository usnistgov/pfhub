"""Functions used by other modules
"""
from functools import wraps
from urllib.error import HTTPError, URLError
import logging
import http
import urllib
import io
from datetime import timedelta
import pathlib
import re
import os

import chevron
from toolz.curried import compose, curry, pipe, get, thread_first, do
from toolz.curried import filter as filter_
from toolz.curried import map as map_
import yaml
import pandas
from requests_cache import CachedSession
import requests
import dateutil


fullmatch = curry(re.fullmatch)

make_id = lambda x: ".".join([x["benchmark"]["id"], str(x["benchmark"]["version"])])


@curry
def apply_transform(transform, values):
    """Apply a vega transform to a set of values

    This is an inplace operation. This was difficult to implement with
    "exec" without inplace.

    Args:
      transform: vega style transform as a dictionary
      values: the values to transform as a DataFrame

    >>> transform = {'type' : 'formula', 'expr' : '2 * datum.time', 'as' : 'x'}
    >>> df = pandas.DataFrame(dict(time=[0, 1, 2]))
    >>> apply_transform(transform, df)
    >>> df
       time  x
    0     0  0
    1     1  2
    2     2  4

    >>> apply_transform({'type' : 'blah'}, None)
    Traceback (most recent call last):
    ...
    RuntimeError: blah transform type is not supported

    """
    if transform["type"] == "formula":
        datum = values  # pylint: disable=unused-variable  # noqa: F841
        exec(  # pylint: disable=exec-used
            "values[transform['as']] = " + transform["expr"]
        )
    else:
        raise RuntimeError(f"{transform['type']} transform type is not supported")


def maybe(func):
    """Decorator to allow functions to have the maybe construct.

    A "maybe" function returns None if passed None.

    Args:
      func: the function to decorate

    Returns:
      the decorated function

    >>> @maybe
    ... def add1(x):
    ...     return x + 1

    >>> add1(None)
    >>> add1(1)
    2

    """

    @curry
    def wrapper(*args):
        if args[-1] is None:
            return None
        return func(*args)

    return wraps(func)(wrapper)


def get_cached_session():
    """Get the cached session"""
    return CachedSession(
        expire_after=timedelta(days=30), backend="sqlite", use_temp=True
    )


def sequence(*args):
    """Compose functions in order

    Args:
      args: the functions to compose

    Returns:
      composed functions

    >>> assert sequence(lambda x: x + 1, lambda x: x * 2)(3) == 8
    """
    return compose(*args[::-1])


def read_yaml(filepath):
    """Read a YAML file

    Args:
      filepath: the path to the YAML file

    Returns:
      returns a dictionary

    Test by reading from temporary test data

    >>> yaml_data = read_yaml(getfixture('yaml_data_file'))
    >>> assert yaml_data['benchmark']['id'] == '1a'

    Read yaml from a URL

    >>> url = "https://raw.githubusercontent.com/usnistgov/pfhub/master/_data/simulations/fipy_1a_travis/meta.yaml"
    >>> data = read_yaml(url)
    >>> print(data['benchmark']['id'])
    1a
    """  # pylint: disable=line-too-long # noqa: E501
    if urllib.parse.urlparse(str(filepath)).scheme in ("http", "https"):
        session = get_cached_session()
        with io.StringIO(
            session.get(filepath).content.decode("utf-8"), newline=None
        ) as stream:
            data = yaml.safe_load(stream)
    else:
        with open(filepath, encoding="utf-8") as stream:
            data = yaml.safe_load(stream)

    return data


def sep_help(format_, remove_whitespace=True):
    """Determine seperator based on file type

    Args:
      format_: format string

    Returns:
      file separator character

    >>> sep_help(None)
    ','

    """
    if format_ is None:
        return ","

    if format_ == "csv":
        if remove_whitespace:
            return r",\s*"
        return ","

    if format_ == "tsv":
        return "\t"

    raise RuntimeError(f"{format_} data format not supported")


def sep(data_format):
    r"""Determine separator based on file type

    Args:
      data_format: data format block from Vega spec

    Returns:
      file separator character

    >>> sep(None)
    ','
    >>> sep({'type': 'csv'})
    ','
    >>> sep({'type': 'tsv'})
    '\t'
    >>> sep({'type': 'csv', 'remove_whitespace': True})
    ',\\s*'
    >>> sep({'type': 'blah'})
    Traceback (most recent call last):
    ...
    RuntimeError: blah data format not supported
    """
    if data_format is None:
        return sep_help(None)

    return sep_help(
        data_format["type"],
        "remove_whitespace" in data_format and data_format["remove_whitespace"],
    )


@curry
def read_csv(sep_, path):
    """Read CSV file with a specified separator

    Args:
      sep_: the separator character
      path: the path to the csv file

    Returns:
      File content as a DataFrame

    >>> read_csv(',', getfixture('csv_file'))
       x  y
    0  0  0
    1  1  1
    >>> caplog = getfixture('caplog')
    >>> caplog.set_level(logging.DEBUG)
    >>> read_csv(',', 'http://blah.csv')
    >>> print(caplog.text)  #doctest: +SKIP
    DEBUG    requests_cache.backends:__init__.py:76 Initializing backend: None http_cache
        ...
    DEBUG    root:func.py:... [Errno -2] Name or service not known> for http://blah.csv
    <BLANKLINE>

    """  # pylint: disable=line-too-long # noqa: E501

    try:
        if urllib.parse.urlparse(str(path)).scheme in ("http", "https"):
            session = get_cached_session()
            path_ = io.StringIO(session.get(path).content.decode("utf-8"), newline=None)
        else:
            path_ = path

        return pandas.read_csv(path_, sep=sep_, engine="python")
    except (
        HTTPError,
        URLError,
        FileNotFoundError,
        http.client.IncompleteRead,
        requests.exceptions.ConnectionError,
        pandas.errors.ParserError,
    ) as error:
        logging.debug("%s for %s", error, path)
        return None


@curry
def debug(stmt, data):  # pragma: no cover
    """Helpful debug function"""
    print(stmt)
    print(data)
    return data


def get_json(url):
    """Get the json from the URL

    Results are cached

    Args:
      url: the url

    Returns:
      contents.json()
    """
    return get_cached_session().get(url).json()


def render(template_name, sub_dict):
    """Render the template using a substitution dictionary.

    Args:
      template_name: the template name in the templates directory
      the dictionary

    Returns:
      the rendered template

    """
    with open(
        pathlib.Path(__file__).parent.resolve()
        / "templates"
        / f"{template_name}.mustache",
        "r",
        encoding="utf-8",
    ) as fstream:
        data = chevron.render(fstream, sub_dict)

    return data


def get_text(url):
    """get the text from a url response

    Results are cached

    Args:
      url: the url

    Returns:
      content.text
    """
    data = get_cached_session().get(url)
    return "" if data.status_code == 400 else data.text


def read_yaml_from_url(url):
    """Read a YAML file from a URL

    Args:
      url: the URL

    Returns:
      contents of the YAML file

    Just returns empty string with broken URL

    >>> import requests_mock
    >>> url = "http://test.com"
    >>> with requests_mock.Mocker() as m:
    ...     _ = m.get(url, text="---\\na: 1")
    ...     read_yaml_from_url(url)
    ...
    {'a': 1}

    """
    matchfile = fullmatch(r"file:///[\S]+")
    if matchfile(url):
        with urllib.request.urlopen(url) as fpointer:
            return yaml.safe_load(fpointer)
    else:
        return yaml.safe_load(get_text(url))


@curry
def get_data_from_yaml(data_names, keys, yaml_data):
    """Get data from a single meta.yaml

    Args:
      data_names: the names of the data blocks to extract
      keys: columns of each data item
      yaml_data: dictionary from a single meta.yaml

    Returns:
      DataFrame from the YAML data block

    >>> from .main import get_yaml_data
    >>> d = getfixture('test_data_path')
    >>> data = list(get_yaml_data(str(d), ['1a.1', '2a.1']))

    >>> get_data_from_yaml(['free_energy'], ['x', 'y'], data[0])
         x    y     data_set
    0  0.0  0.0  free_energy
    1  1.0  1.0  free_energy
    """
    return pipe(
        yaml_data,
        get("data"),
        filter_(lambda x: x["name"] in data_names),
        map_(lambda x: ({"data_set": x["name"]}, read_vega_data(keys, x))),
        concat_items,
    )


def concat_items(items):
    """Assign new columns and then concatenate sequence of dataframes

    Args:
      items: sequence of tuples `[(x0, y0), ...]`. `x0` is a
        dictionary of new columns and `y0` are dataframes

    Returns:
      concatenated dataframes

    >>> x = pandas.DataFrame(dict(x=[1, 2]))
    >>> concat_items([(dict(z='z'), x)])
       x  z
    0  1  z
    1  2  z
    >>> x = pandas.DataFrame(dict(x=[1, 2]))
    >>> y = pandas.DataFrame(dict(y=[1, 2]))
    >>> concat_items([(dict(z='z'), x), (dict(), y)])
         x    z    y
    0  1.0    z  NaN
    1  2.0    z  NaN
    0  NaN  NaN  1.0
    1  NaN  NaN  2.0

    """
    concat = lambda x: pandas.concat(x) if x != [] else None
    return pipe(items, map_(lambda x: assign(x[0], x[1])), compact, list, concat)


def compact(items):
    """Remove None items from sequence

    Args:
      items: sequence to remove Nones from

    Returns:
      new sequence with no Nones

    >>> list(compact([1, None, 2]))
    [1, 2]

    """
    return filter(lambda x: x is not None, items)


def read_vega_data(keys, data):
    """Read vega data given keys to exract

    Read a vega data block given the keys (or columns) to extract

    Args:
      keys: columns of each data item
      data: the data block with the given columns

    Returns:
      The data columns in a pandas DataFrame

    """
    read_url = sequence(
        get("url"),
        read_csv(sep(data.get("format"))),
    )

    read_values = sequence(get("values"), pandas.DataFrame)

    return pipe(
        data,
        read_url if "url" in data else read_values,
        apply_transforms(data),
        maybe(lambda x: get(keys, x, None)),
    )


@maybe
def apply_transforms(data, values):
    """Apply a series of Vega transforms to a set of values

    Args:
      data: the data block with the transforms
      values: the values to transform as a DataFrame

    Returns:
      returns a new set of values as a DataFrame

    >>> data_block = dict(transform=[
    ...     {'type' : 'formula', 'expr' : '2 * datum.time', 'as' : 'x'},
    ...     {'type' : 'formula', 'expr' : 'datum.energy / 2', 'as' : 'z'}
    ... ])
    >>> df = pandas.DataFrame(dict(time=[0, 1, 2], energy=[10, 20, 30]))
    >>> apply_transforms(data_block, df)
       time  energy  x     z
    0     0      10  0   5.0
    1     1      20  2  10.0
    2     2      30  4  15.0

    >>> apply_transforms(dict(), df)
       time  energy  x     z
    0     0      10  0   5.0
    1     1      20  2  10.0
    2     2      30  4  15.0

    """
    if "transform" in data:
        return thread_first(
            values, *list(map_(lambda x: do(apply_transform(x)), data["transform"]))
        )
    return values


@maybe
def assign(columns, dataframe):
    """Curried version of assigning columns to a dataframe

    Args:
      columns: the new columns to append to the dataframe
      dataframe: dataframe to append to

    Returns:
      a new dataframe

    >>> assign(
    ...     dict(c=[5, 6]),
    ...     pandas.DataFrame(dict(a=[1, 2], b=[3, 4]))
    ... )
       a  b  c
    0  1  3  5
    1  2  4  6

    """
    return dataframe.assign(**columns)


def convert_date(str_):
    """Convert a date/time in any format to a year-month-dat format."""
    return str(dateutil.parser.parse(str(str_))).split(" ", maxsplit=1)[0]


@curry
def write_files(string_dict, dest):
    """Write files from a dict

    Args:
      string_dict: dict of file names as keys and contents as values
      dest: the destination directory

    Returns:
      the file paths of the written paths
    """

    @curry
    def write(dir_, item):
        path = os.path.join(dir_, f"{item[0]}")
        with open(path, "w", encoding="utf-8") as fstream:
            fstream.write(item[1])
        return path

    return list(map_(write(dest), string_dict.items()))
