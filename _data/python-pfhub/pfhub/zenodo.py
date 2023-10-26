"""Download and convert a Zenodo DOI to a PFHub meta.yaml string
"""
import pathlib
import re

from toolz.curried import get, get_in, pipe, curry, itemmap, assoc, groupby
from toolz.curried import filter as filter_
from toolz.curried import map as map_
from toolz.functoolz import memoize
import pandas

from .func import read_yaml, read_csv, sep_help, get_json, render


def get_file_url(pattern, zenodo_json):
    r"""Get the URL for file matching the pattern in the Zenodo record

    Args:
      pattern: filename or regex pattern
      zenodo_json: the json dictionary from Zenodo with the list of
        files

    Returns:
       the first matching file URL for the give pattern.

    >>> zenodo_json = dict(files=[
    ...     dict(key="wow_blah.txt",
    ...          links=dict(self="https://zenodo/file/wow_blah.txt"))
    ... ])

    >>> get_file_url(r"wow\S+.txt", zenodo_json)
    'https://zenodo/file/wow_blah.txt'

    """
    return pipe(
        zenodo_json,
        get("files"),
        filter_(lambda x: re.fullmatch(pattern, x["key"].lower())),
        list,
        get_in([0, "links", "self"]),
    )


def match_col_name(col_names, key, pattern):
    r"""Find the matching column names from the pattern

    Args:
      col_names: list of names
      key: the data item key

    Returns:
      matching col name if key is a field key

    >>> match_col_name(['blah', 'wow'], 'field', r'bla\S')
    'blah'

    """
    if "field" in key:
        return list(filter_((lambda x: re.fullmatch(pattern, x.lower())), col_names))[0]

    return pattern


@memoize
def get_col_names(url, ext_type):
    """Get col names from a csv file

    Args:
      url: url to the CSV file
      ext_type: e.g. 'csv'

    Returns:
      the column names

    """
    return read_csv(sep_help(ext_type), url).columns


def transform(url, dat):
    r"""Fill out a template data item.

    Args:
      url: the URL to the data file (normally a CSV file)
      dat: the data item dictionary

    Returns:
      a transformed data item dictionary

    >>> dat = dict(
    ...     name="free_energy",
    ...     x_field=r'[\S]*time[\S]*',
    ...     y_field=r'[\S]*energy[\S]*'
    ... )

    >>> from pprint import pp
    >>> pp(transform(getfixture("free_energy_csv"), dat))  # doctest:+ELLIPSIS
    {'name': 'free_energy',
     'x_field': 'time',
     'y_field': 'free_energy',
     'url': PosixPath('.../free_energy.csv'),
     'ext_type': 'csv'}

    """

    ext_type = pathlib.Path(url).suffix[1:]
    select_col_name = lambda kv: (
        kv[0],
        match_col_name(get_col_names(url, ext_type), *kv),
    )
    return pipe(
        url,
        assoc(dat, "url"),
        itemmap(select_col_name),
        lambda x: assoc(x, "ext_type", ext_type),
    )


@curry
def transform_data_item(zenodo_json, dat):
    """Fill out a template data item

    See "transform" above for a test case

    Args:
      zenodo_json: the zenodo_json string
      data: the data item dictionary

    Returns
      a transformed data item dictionary
    """
    return transform(get_file_url(dat["url"], zenodo_json), dat)


def read_and_transform_data(benchmark_id, zenodo_json):
    """Generate data items from a Zenodo record

    Given a benchmark_id and the contents of a Zenodo record, generate
    the data items required for a PFHub meta.yaml.

    Args:
      benchmark_id: the benchmark_id
      zenodo_json: the Zenodo record

    Returns:
      a dictionary aggregated by data type (line or contour currently)

    """
    return pipe(
        pathlib.Path(__file__).parent.resolve()
        / "templates"
        / f"{benchmark_id}_data.yaml",
        read_yaml,
        map_(transform_data_item(zenodo_json)),
        list,
        groupby(lambda x: x["type"]),
    )


def subs(pfhub_meta, zenodo_meta, benchmark, lines_and_contours):
    """Mappings from the Zenodo data to PFHub meta.yaml

    Args:
      pfhub_meta: meta section from the pfhub.json
      zenodo_meta: meta section from the Zenodo record
      benchmark: benchmark ID and version
      lines_and_contours: data items for the PFHub record aggregated
        based on type

    Returns:
      dictionary of keys ready to input into a PFHub meta.yaml
      template

    """

    get_name = lambda x: x["creators"][0]["name"].replace(" ", "").split(",")

    name = f"{pfhub_meta['software']['name']}_{benchmark['id']}_{zenodo_meta['doi']}"
    return {
        "first": get(1, get_name(zenodo_meta), ""),
        "last": get_name(zenodo_meta)[0],
        "orcid": zenodo_meta["creators"][0]["orcid"],
        "summary": re.sub("<[^<]+?>", "", zenodo_meta["description"]),
        "timestamp": str(pandas.to_datetime(zenodo_meta["publication_date"])),
        "cpu_architecture": pfhub_meta["hardware"]["cpu_architecture"],
        "acc_architecture": pfhub_meta["hardware"]["acc_architecture"],
        "parallel_model": pfhub_meta["hardware"].get("parallel_model", "serial"),
        "clock_rate": pfhub_meta["hardware"]["clock_rate"],
        "cores": pfhub_meta["hardware"]["cores"],
        "nodes": pfhub_meta["hardware"]["nodes"],
        "benchmark_id": benchmark["id"],
        "benchmark_version": benchmark["version"],
        "software_name": pfhub_meta["software"]["name"],
        "container_url": pfhub_meta["container_url"],
        "repo_url": pfhub_meta["implementation_url"],
        "wall_time": pfhub_meta["run_time"]["wall_time"],
        "sim_time": pfhub_meta["run_time"]["sim_time"],
        "memory_usage": pfhub_meta["memory_usage"],
        "lines": lines_and_contours["line"],
        "contours": lines_and_contours.get("contour", []),
        "name": name,
    }


def render_meta(pfhub_json, zenodo_json):
    """Render the meta.yaml as a string from a Zenodo record using a
    template

    Args:
      pfhub_json: the PFHub json file from Zenodo
      zenodo_json: the Zenodo record

    Returns:
      string of the generated PFHub meta.yaml

    """
    return render(
        "pfhub_meta",
        subs(
            pfhub_json["metadata"],
            zenodo_json["metadata"],
            pfhub_json["benchmark"],
            read_and_transform_data(pfhub_json["benchmark"]["id"], zenodo_json),
        ),
    )


def zenodo_to_pfhub(url):
    """Generate a PFHub meta.yaml from a Zenodo record.

    Args:
      url: Zenodo DOI

    Returns:
      a meta.yaml string

    >>> _ = list(map(print, zenodo_to_pfhub(
    ...     'https://doi.org/10.5281/zenodo.7199253'
    ... ).splitlines()[:10]))  # doctest: +NORMALIZE_WHITESPACE
    ---
    name: "fipy_8a_10.5281/zenodo.7199253"
    metadata:
      author:
        first: Daniel
        last: Wheeler
        email:
        github_id:
      timestamp: "2022-08-31 00:00:00"
      summary: FiPy implementation of benchmark 8a

    """

    return pipe(
        url,
        pathlib.Path,
        lambda x: "https://zenodo.org/api/records/" + x.name.split(".")[1],
        get_json,
        lambda x: render_meta(get_json(get_file_url("pfhub.json", x)), x),
    )


zenodo_to_meta = zenodo_to_pfhub
