import pytest


def make_yaml_content(id_, version):
    return f"""
---
benchmark:
  id: {id_}
  version: {version}
metadata:
  implementation:
    name: code_name
  author:
    first: first
    last: last
  timestamp: 2021-12-07
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
"""


def make_yaml(dir_, name, id_, version):
    d1 = dir_ / name
    d1.mkdir(exist_ok=True)
    yaml_file = d1 / "meta.yaml"
    yaml_file.write_text(make_yaml_content(id_, version))
    return yaml_file


@pytest.fixture
def yaml_data_file(tmp_path):
    tmp_path.mkdir(exist_ok=True)
    return make_yaml(tmp_path, "result", "1a", 1)


@pytest.fixture
def test_data_path(tmp_path):
    dir_ = tmp_path / "results"
    dir_.mkdir(exist_ok=True)
    make_yaml(dir_, "result1", "1a", 1)
    make_yaml(dir_, "result2", "2a", 1)
    return dir_


@pytest.fixture
def csv_file(tmp_path):
    tmp_path.mkdir(exist_ok=True)
    csv_file = tmp_path / "file.csv"
    csv_file.write_text("x,y\n0,0\n1,1\n")
    return csv_file
