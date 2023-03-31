"""Setup for pytest
"""

import pytest
import yaml


def make_yaml_content(id_, version, name=None):
    """Generate some test yaml content

    Args:
      id_: the benchmark id_ (e.g. "8a")
      version: the version (e.g. "1")

    Returns:
      yaml result content as string
    """
    data = f"""
---
benchmark:
  id: {id_}
  version: {version}
metadata:
  implementation:
    name: code_name
    repo:
      url: https://github.com
      version: dsfa
  hardware:
    acc_architecture: none
    clock_rate: 0
    cores: 1
    cpu_architecture: x86_64
    nodes: 1
  author:
    first: first
    last: last
    github_id: githubid
    email: first.last@email.com
  timestamp: 2021-12-07
  summary: "the summary"
data:
  - name: free_energy
    type: line
    values:
      - x: 0.0
        y: 0.0
        z: 0.0
      - x: 1.0
        y: 1.0
        z: 1.0
    transform:
      - type: formula
        expr: datum.x
        as: a
      - type: formula
        expr: datum.y * 2
        as: b
  - name: run_time
    values:
      - sim_time: 1.0
        wall_time: 1.0
  - name: memory_usage
    values:
      - value: 1.0
"""
    if name is not None:
        data = data + f"\nname: {name}"
    return data


def make_yaml(dir_, name, id_, version, add_name=False):
    """Generate a yaml file for test purposes

    Args:
      dir_: the result directory to write to
      name: name of the result
      id_: the benchmark id_ (e.g. "8a")
      version: the version (e.g. "1")
      name: the name of the simulation (e.g. "fipy1a")

    Returns:
      name of the file created
    """
    dir_name = dir_ / name
    dir_name.mkdir(exist_ok=True)
    yaml_file = dir_name / "meta.yaml"
    yaml_file.write_text(
        make_yaml_content(id_, version, name=name if add_name else None)
    )
    return yaml_file


@pytest.fixture
def yaml_data_file(tmp_path):
    """Generate a yaml test file

    Args:
      tmp_path: temporary area to use to write files

    Returns:
      name of the data file
    """
    tmp_path.mkdir(exist_ok=True)
    return make_yaml(tmp_path, "result", "1a", 1)


@pytest.fixture
def yaml_data_file_with_name(tmp_path):
    """Generate a yaml test file with name included

    Args:
      tmp_path: temporary area to use to write files

    Returns:
      name of the data file
    """
    tmp_path.mkdir(exist_ok=True)
    return make_yaml(tmp_path, "result1", "1a", 1, add_name=True)


@pytest.fixture
def test_data_path(tmp_path):
    """Generate two result data files

    Args:
      tmp_path: temporary area to use to write files

    Returns:
      the name of the directory used for writing the files
    """
    dir_ = tmp_path / "results"
    dir_.mkdir(exist_ok=True)
    make_yaml(dir_, "result1", "1a", 1)
    make_yaml(dir_, "result2", "2a", 1)
    file_path = dir_ / "list.yaml"
    with open(file_path, "w", encoding="utf-8") as stream:
        yaml.dump(["result1/meta.yaml", "result2/meta.yaml"], stream)
    return file_path


@pytest.fixture
def csv_file(tmp_path):
    """Generate a csv file for test purposes

    Args:
      tmp_path: temporary area to use to write files

    Returns:
      path to the csv file
    """
    tmp_path.mkdir(exist_ok=True)
    csv_file_path = tmp_path / "file.csv"
    csv_file_path.write_text("x,y\n0,0\n1,1\n")
    return csv_file_path


@pytest.fixture
def free_energy_csv(tmp_path):
    """Generate a CSV file for test purposes

    Args:
      tmp_path: temporary area to use to write files

    Returns:
      path to the csv file

    """
    tmp_path.mkdir(exist_ok=True)
    csv_file_path = tmp_path / "free_energy.csv"
    csv_file_path.write_text("time,free_energy\n0,0\n1,1\n")
    return csv_file_path
