"""The CLI command line tool
"""

import re

import click
import click_params
from toolz.curried import pipe, get
from toolz.curried import map as map_

from ..convert import download_zenodo, download_meta
from ..func import compact


EPILOG = "See the documentation at \
https://github.com/usnistgov/pfhub/blob/master/CLI.md (under construction)"


def zenodo_regexs():
    """Regular expression for acceptable Zenodo URLs"""
    return [
        r"https://doi.org/10.5281/zenodo.(\d{1,})",
        r"https://zenodo.org/api/records/(\d{1,})",
        r"https://zenodo.org/record/(\d{1,})",
    ]


def zenodo_sandbox_regexs():
    """Regular expression for acceptable Zenodo sandbox URLs"""
    return [
        r"https://sandbox.zenodo.org/record/(\d{1,})",
        r"https://sandbox.zenodo.org/api/records/(\d{1,})",
    ]


def get_zenodo_record_id(url, regexs):
    """Get the record from a Zenodo URL

    Args:
      url: any URL (doesn't need to be Zenodo)
      regexs: acceptable regexs

    Returns:
      Record ID or None
    """
    return pipe(
        regexs,
        map_(lambda x: re.fullmatch(x, url)),
        compact,
        map_(lambda x: x.groups()[0]),
        list,
        get(0, default=None),
    )


@click.group(epilog=EPILOG)
def cli():
    """Submit results to PFHub and manipulate PFHub data"""


@cli.command(epilog=EPILOG)
@click.argument("url", type=click_params.URL)
@click.option(
    "--dest",
    "-d",
    help="destination directory",
    default="./",
    type=click.Path(exists=True),
)
def download(url, dest):
    """Download a PFHub record

    Download an old meta.yaml or a new PFHub record stored on Zenodo.

    Args:
      url: the URL of either a meta.yaml or Zenodo record
    """

    def output(local_filepaths):
        def echo(local_filepath, newline, comma=","):
            formatted_path = click.format_filename(local_filepath)
            click.secho(message=f" {formatted_path}" + comma, fg="green", nl=newline)

        click.secho(message="Writing:", fg="green", nl=False)
        for local_filepath in local_filepaths[:-1]:
            echo(local_filepath, False)
        echo(local_filepaths[-1], True, comma="")

    record_id = get_zenodo_record_id(url, zenodo_regexs())
    sandbox = False
    if record_id is None:
        record_id = get_zenodo_record_id(url, zenodo_sandbox_regexs())
        sandbox = True

    if record_id is not None:
        local_filepaths = download_zenodo(record_id, sandbox=sandbox, dest=dest)
        output(local_filepaths)
    elif re.fullmatch(r".*/meta.yaml", url):
        local_filepaths = download_meta(url, dest=dest)
        output(local_filepaths)
    else:
        click.secho(f"{url} does not match any expected regex", fg="red")
