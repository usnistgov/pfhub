"""Functions used by other modules
"""
from urllib.error import HTTPError, URLError

from toolz.curried import compose, curry
import yaml
import pandas


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
    with open(filepath) as stream:
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
    >>> read_csv(',', 'http://blah.csv')
    <urlopen error [Errno -2] Name or service not known> for http://blah.csv

    """

    try:
        return pandas.read_csv(path, sep=sep_, engine="python")
    except (HTTPError, URLError, FileNotFoundError) as error:
        print(f"{error} for {path}")
        return None
