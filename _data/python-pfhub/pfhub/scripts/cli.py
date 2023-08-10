"""The CLI command line tool
"""

import re

import click
import click_params
from toolz.curried import pipe, get
from toolz.curried import map as map_

from ..convert import meta_to_zenodo, download_file
from ..convert import download_zenodo as download_zenodo_
from ..convert import download_meta as download_meta_
from ..func import compact

import tempfile
import pykwalify
import pykwalify.core
import shutil


EPILOG = "See the documentation at \
https://github.com/usnistgov/pfhub/blob/master/CLI.md (under construction)"



@click.group(epilog=EPILOG)
def cli():
    """Submit results to PFHub and manipulate PFHub data"""



def output(local_filepaths):
    def echo(local_filepath, newline, comma=","):
        formatted_path = click.format_filename(local_filepath)
        click.secho(message=f" {formatted_path}" + comma, fg="green", nl=newline)

    click.secho(message="Writing:", fg="green", nl=False)
    for local_filepath in local_filepaths[:-1]:
        echo(local_filepath, False)
    echo(local_filepaths[-1], True, comma="")


@cli.command(epilog=EPILOG)
@click.argument("url", type=click_params.URL)
@click.option(
    "--dest",
    "-d",
    help="destination directory",
    default="./",
    type=click.Path(exists=True),
)
def download_zenodo(url, dest):
    """Download a Zenodo record

    Works with any Zenodo link

    Args:
      url: the URL of either a meta.yaml or Zenodo record
      dest: the destination directory
    """
    record_id = get_zenodo_record_id(url, zenodo_regexs())
    sandbox = False
    if record_id is None:
        record_id = get_zenodo_record_id(url, zenodo_sandbox_regexs())
        sandbox = True

    if record_id is not None:
        local_filepaths = download_zenodo_(record_id, sandbox=sandbox, dest=dest)
        output(local_filepaths)
    else:
        click.secho(f"{url} does not match any expected regex for Zenodo", fg="red")


@cli.command(epilog=EPILOG)
@click.argument("url", type=click_params.URL)
@click.option(
    "--dest",
    "-d",
    help="destination directory",
    default="./",
    type=click.Path(exists=True),
)
def download_meta(url, dest):
    """Download a record from pfhub

    Download a meta.yaml from any URL

    Args:
      url: the URL of either a meta.yaml or Zenodo record
      dest: the destination directory
    """

    is_meta = check_meta_url(url)
    if is_meta:
        local_filepaths = download_meta_(url, dest=dest)
        output(local_filepaths)
    else:
        click.secho(f"{url} is not a valid PFHub meta.yaml", fg="red")


@cli.command(epilog=EPILOG)
@click.argument("file_path", type=click.Path(exists=True))
@click.option(
    "--dest",
    "-d",
    help="destination directory",
    default="./",
    type=click.Path(exists=False),
)
def convert_to_zenodo(file_path, dest):
    """Convert a meta.yaml into a format suitable for Zenodo submission

    Args:
      file_path: the URL of the meta.yaml
      dest: the destination directory

    """
    is_meta = check_meta(file_path)
    if is_meta:
        local_filepaths = [meta_to_zenodo(file_path)]
        output(local_filepaths)
    else:
        click.secho(f"{file_path} is not a valid PFHub meta.yaml", fg="red")



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


def check_meta_url(url):
    """Check that a file is a valid meta.yaml
    """
    tmpdir = tempfile.mkdtemp()
    file_path = download_file(url, dest=tmpdir)
    result = check_meta(file_path)
    shutil.rmtree(tmpdir)
    return result


def check_meta(path):
    try:
        c = pykwalify.core.Core(source_file=path, schema_files=["schema.yaml"])
    except pykwalify.errors.CoreError:
        return False
    try:
        c.validate(raise_exception=True)
    except pykwalify.errors.SchemaError:
        return False
    return True


def check_linkml(path):
    """Check that a file has a valid linkml pfhub schema
    """
    pass
