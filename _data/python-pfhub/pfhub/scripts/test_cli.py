"""Test the PFHub command line tool
"""

import os

from click.testing import CliRunner

from .cli import cli, download


def test_cli():
    """Test top-level of CLI tool"""
    runner = CliRunner()
    result = runner.invoke(cli)
    assert result.exit_code == 0


def test_download_zenodo(tmpdir):
    """Test downloading a Zenodo record"""
    runner = CliRunner()
    result = runner.invoke(
        download, ["https://zenodo.org/record/7255597", "--dest", tmpdir]
    )
    assert result.exit_code == 0
    file1 = os.path.join(tmpdir, "phase_field_1.tsv")
    file2 = os.path.join(tmpdir, "stats.tsv")
    assert result.output == f"Writing: {file1}, {file2}\n"


def test_download_meta(tmpdir):
    """Test downloading a meta.yaml"""
    runner = CliRunner()
    base = "https://raw.githubusercontent.com/usnistgov/pfhub"
    end = "master/_data/simulations/fenics_1a_ivan/meta.yaml"
    yaml_url = os.path.join(base, end)
    result = runner.invoke(download, [yaml_url, "--dest", tmpdir])
    assert result.exit_code == 0
    file1 = os.path.join(tmpdir, "meta.yaml")
    file2 = os.path.join(tmpdir, "1a_square_periodic_out.csv")
    assert result.output == f"Writing: {file1}, {file2}\n"


def test_download_broken(tmpdir):
    """Test downloading if the URL is incorrect"""
    runner = CliRunner()
    yaml_url = "https://blah.com"
    result = runner.invoke(download, [yaml_url, "--dest", tmpdir])
    assert result.exit_code == 0
    assert result.output == "https://blah.com does not match any expected regex\n"
