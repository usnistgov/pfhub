"""Test the PFHub command line tool
"""

from click.testing import CliRunner
from .cli import cli


def test_cli():
    """Test top-level of CLI tool"""
    runner = CliRunner()
    result = runner.invoke(cli)
    assert result.exit_code == 0
    assert result.output == "hello\n"
