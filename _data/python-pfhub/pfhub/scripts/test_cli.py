"""Test the PFHub command line tool
"""

import os

from click.testing import CliRunner

from .cli import (
    cli,
    download_zenodo,
    download,
    convert,
    validate,
    validate_old,
    convert_to_old,
)


def test_cli():
    """Test top-level of CLI tool"""
    runner = CliRunner()
    result = runner.invoke(cli)
    assert result.exit_code == 0


def test_download_zenodo(tmpdir):
    """Test downloading a Zenodo record"""
    runner = CliRunner()
    result = runner.invoke(
        download_zenodo, ["https://zenodo.org/record/7255597", "--dest", tmpdir]
    )
    assert result.exit_code == 0
    file1 = os.path.join(tmpdir, "phase_field_1.tsv")
    file2 = os.path.join(tmpdir, "stats.tsv")
    assert result.output == f"Writing: {file1}, {file2}\n"


def test_download_zenodo_bad(tmpdir):
    """Check the error message on a bad link"""
    runner = CliRunner()
    result = runner.invoke(download_zenodo, ["https://blah.com", "--dest", tmpdir])
    assert result.exit_code == 1
    assert (
        result.output
        == "https://blah.com does not match any expected regex for Zenodo\n"
    )


def test_download_zenodo_sandbox(tmpdir):
    """Test downloading from the Zenodo sandbox"""
    runner = CliRunner()
    result = runner.invoke(
        download_zenodo, ["https://sandbox.zenodo.org/record/657937", "--dest", tmpdir]
    )
    assert result.exit_code == 0
    file1 = os.path.join(
        tmpdir, "marines-sniper-rifle-aiming-scope-weapon-shooting-special-gun.jpg"
    )
    assert result.output == f"Writing: {file1}\n"


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


def test_download_record(tmpdir):
    """Test downloading a meta.yaml using only the record name"""
    runner = CliRunner()
    record = "fenics_1a_ivan"
    result = runner.invoke(download, [record, "--dest", tmpdir])
    assert result.exit_code == 0
    file1 = os.path.join(tmpdir, "meta.yaml")
    file2 = os.path.join(tmpdir, "1a_square_periodic_out.csv")
    assert result.output == f"Writing: {file1}, {file2}\n"


def test_download_zenodo_record(tmpdir):
    """Test downloading a PFHub record, but from Zenodo"""
    runner = CliRunner()
    record = "fipy_1a_10.5281/zenodo.7474506"
    result = runner.invoke(download, [record, "--dest", tmpdir])
    assert result.exit_code == 0
    file2 = os.path.join(tmpdir, "pfhub.json")
    file1 = os.path.join(tmpdir, "free_energy.csv")
    assert result.output == f"Writing: {file1}, {file2}\n"


def test_download_exist(tmpdir):
    """URL doesn't exist"""
    runner = CliRunner()
    yaml_url = "https://blah.com"
    result = runner.invoke(download, [yaml_url, "--dest", tmpdir])
    assert result.exit_code == 1
    assert result.output.splitlines()[1] == "https://blah.com is invalid"


def test_download_not_file(tmpdir):
    """URL not a file"""
    runner = CliRunner()
    yaml_url = "https://google.com"
    result = runner.invoke(download, [yaml_url, "--dest", tmpdir])
    assert result.exit_code == 1
    assert result.output == "https://google.com is not a link to a file\n"


def test_download_not_valid(tmpdir):
    """Not a valid meta.yaml"""
    runner = CliRunner()
    yaml_url = "https://raw.githubusercontent.com/usnistgov/pfhub/master/.travis.yml"
    result = runner.invoke(download, [yaml_url, "--dest", tmpdir])
    assert result.exit_code == 1
    assert result.output == f"{yaml_url} is not valid\n"


def convert_helper(runner, tmpdir):
    """Download an old schema YAML and convert to the new schema"""
    base = "https://raw.githubusercontent.com/usnistgov/pfhub"
    end = "master/_data/simulations/fenics_1a_ivan/meta.yaml"
    yaml_url = ("/").join([base, end])
    runner.invoke(download, [yaml_url, "--dest", tmpdir])
    yaml_path = os.path.join(tmpdir, "meta.yaml")
    result = runner.invoke(convert, [yaml_path, "--dest", tmpdir])
    return result, runner


def test_convert_to_zenodo(tmpdir):
    """Conversion from meta.yaml to pfhub.json"""
    runner = CliRunner()
    result, _ = convert_helper(runner, tmpdir)
    file1 = os.path.join(tmpdir, "pfhub.yaml")
    file2 = os.path.join(tmpdir, "free_energy_1a.csv")
    assert result.exit_code == 0
    assert result.output == f"Writing: {file1}, {file2}\n"


def test_convert_to_zenodo_valid(tmpdir):
    """Test conversion if not a valid YAML"""
    runner = CliRunner()
    base = os.path.split(__file__)[0]
    yaml_path = os.path.join(base, "..", "templates", "8a_data.yaml")
    result = runner.invoke(convert, [yaml_path, "--dest", tmpdir])
    assert result.exit_code == 1
    assert result.output == f"{yaml_path} is not valid\n"


def test_convert_to_zenodo_not_yaml(tmpdir):
    """Test if not a YAML"""
    runner = CliRunner()
    result = runner.invoke(convert, [__file__, "--dest", tmpdir])
    assert result.exit_code == 1
    assert result.output == f"{__file__} is not valid\n"


def test_validate_old():
    """Test validating the old schema"""
    runner = CliRunner()
    base = os.path.split(__file__)[0]
    yaml_path = os.path.join(base, "..", "schema", "example_old.yaml")
    result = runner.invoke(validate_old, [yaml_path])
    assert result.exit_code == 0
    assert result.output == f"{yaml_path} is valid\n"


def test_validate():
    """Test validating the new schema"""
    runner = CliRunner()
    base = os.path.split(__file__)[0]
    yaml_path = os.path.join(base, "..", "schema", "example.yaml")
    result = runner.invoke(validate, [yaml_path])
    assert result.exit_code == 0
    assert result.output.splitlines()[-1] == f"{yaml_path} is valid"


def test_validate_old_not_valid():
    """Test the old schema when the yaml file is invalid"""
    runner = CliRunner()
    base = os.path.split(__file__)[0]
    yaml_path = os.path.join(base, "..", "schema", "example.yaml")
    result = runner.invoke(validate_old, [yaml_path])
    assert result.exit_code == 1
    assert result.output == f"{yaml_path} is not valid\n"


def test_validate_not_valid():
    """Test the new schema when the yaml file is invalid"""
    runner = CliRunner()
    base = os.path.split(__file__)[0]
    yaml_path = os.path.join(base, "..", "schema", "example_old.yaml")
    result = runner.invoke(validate, [yaml_path])
    assert result.exit_code == 1
    assert result.output.splitlines()[-1] == f"{yaml_path} is not valid"


def test_validate_keyerror():
    """Test the new schema when the file isn't a yaml file"""
    runner = CliRunner()
    result = runner.invoke(validate, [__file__])
    assert result.exit_code == 1
    assert result.output.splitlines()[-1] == f"{__file__} is not valid"


def test_convert_to_old(tmpdir):
    """Test converting from new to old"""
    runner = CliRunner()
    _, runner = convert_helper(runner, tmpdir)
    yamlpath = os.path.join(tmpdir, "pfhub.yaml")
    metapath = os.path.join(tmpdir, "meta")
    os.mkdir(metapath)
    result = runner.invoke(convert_to_old, [yamlpath, "--dest", metapath])
    file_ = os.path.join(metapath, "meta.yaml")
    assert result.exit_code == 0
    assert result.output.splitlines()[-1] == f"Writing: {file_}"


def test_convert_to_old_missing_file():
    """Test convert_to_old if file is missing"""
    runner = CliRunner()
    base = os.path.split(__file__)[0]
    yaml_path = os.path.join(base, "..", "schema", "example_old.yaml")
    result = runner.invoke(convert_to_old, [yaml_path])
    assert result.exit_code == 1
    assert result.output.splitlines()[-1] == f"{yaml_path} is not valid"
