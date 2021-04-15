"""Run this to check the size of all the data available in the
simulation results. Will give a summary of data types and sizes by
simulations and aggregated.

"""

from pathlib import Path
import requests

from toolz.curried import map as fmap
from toolz.curried import filter as ffilter
from toolz.curried import compose, groupby, valmap, merge
import numpy as np
from pandas import DataFrame, concat

from migrate_yaml import get_yaml_data


# number of bytes in a megabyte
MBFACTOR = float(1 << 20)


def sequence(*args):
    """Compose functions in reverse
    """
    return compose(*args[::-1])


# pylint: disable=invalid-name
filesize_from_url = sequence(
    lambda x: requests.head(x, allow_redirects=True),
    lambda x: x.headers.get("content-length", 0),
    lambda x: int(x) / MBFACTOR,
)


def filesize(filename):
    """Return the size of file
    """
    return Path(filename).stat().st_size / MBFACTOR


# pylint: disable=invalid-name
sizes = sequence(
    ffilter(lambda x: "url" in x),
    fmap(lambda x: dict(size_mb=filesize_from_url(x["url"]), type=x["type"])),
    groupby(lambda x: x["type"]),
    valmap(lambda x: np.sum(list(fmap(lambda y: y["size_mb"], x)))),
)


def aggregate(data_meta):
    """Given a meta data element return a dictionary of the aggregated
    data type file sizes.
    """
    return merge(
        dict(meta=filesize(data_meta[0]), name=Path(data_meta[0]).parts[-2]),
        sizes(data_meta[1]["data"]),
    )


# pylint: disable=invalid-name
dataframe = sequence(
    fmap(aggregate),
    list,
    DataFrame,
    lambda x: x.fillna(0.0),
    lambda x: concat([x, x.sum(axis=1, numeric_only=True)], axis=1)
    .rename(columns={0: "total"})
    .sort_values("total", ascending=False),
)


if __name__ == "__main__":
    data = list(get_yaml_data())
    df = dataframe(data)
    print(df.head())
    print()
    print(df.describe())
    print()
    print(df.sum(axis=0, numeric_only=True))
