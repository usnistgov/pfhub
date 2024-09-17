"""Functions used by other modules
"""
from urllib.error import HTTPError, URLError
import logging
import http
import urllib
import io
from datetime import timedelta

from toolz.curried import compose, curry
import yaml
import pandas
from requests_cache import CachedSession
import requests


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

    """
    with open(filepath, encoding="utf-8") as stream:
        data = yaml.safe_load(stream)
    return data


def sep_help(format_, remove_whitespace=True):
    """Determine seperator baed on file type

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
