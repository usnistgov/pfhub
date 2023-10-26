"""Module to convert a pfhub.yaml to meta.json (new to old)
"""

import re

from dotwiz import DotWiz
from toolz.curried import get, pipe
from toolz.curried import map as map_

from .func import read_yaml, render, write_files


def to_old(path, dest):
    """Convert from new schema to old schema

    Args:
      path: the path to the YAML file
      dest: destination directory for output files

    Returns:
      the paths for the output files
    """
    data_all = DotWiz(read_yaml(path))
    str_ = render_meta(data_all)
    return write_files({"meta.yaml": str_}, dest)


def get_github_id(str_):
    """Get a GitHub ID from a string

    Args:
      str_: a string

    Returns:
      the GitHub ID or None

    >>> print(get_github_id("github: wd15"))
    wd15

    >>> print(get_github_id("wd15"))
    <BLANKLINE>

    """

    github_ = re.match(r"github:(.*)", str_)
    if github_:
        return github_.groups()[0].strip()
    return ""


def subs(data_all, lines_and_contours):
    """Dict substitution for new to old schema transform

    Args:
      data_all: all the input data as dotwiz object
      lines_and_contours: dictionary of lines and contours

    Returns:
      a substitution dict
    """
    github_id = get_github_id(data_all.contributors[0].id)
    return {
        "first": get(0, data_all.contributors[0].name.split(" "), ""),
        "last": get(1, data_all.contributors[0].name.split(" "), ""),
        "github_id": github_id if github_id else "",
        "summary": data_all.summary,
        "timestamp": data_all.date_created,
        "cpu_architecture": data_all.results.hardware.architecture,
        "acc_architecture": "none",
        "parallel_model": "",
        "clock_rate": "0.0",
        "cores": data_all.results.hardware.cores,
        "nodes": data_all.results.hardware.nodes,
        "benchmark_id": data_all.benchmark_problem.split(".")[0],
        "benchmark_version": data_all.benchmark_problem.split(".")[1],
        "software_name": data_all.framework[0].name,
        "container_url": "",
        "repo_url": data_all.framework[0].url,
        "wall_time": data_all.results.time_in_s,
        "sim_time": data_all.results.fictive_time,
        "memory_usage": data_all.results.memory_in_kb,
        "lines": lines_and_contours["lines"],
        "contours": lines_and_contours.get("contour", []),
        "name": data_all.id,
        "repo_version": "aaaaa",
    }


def render_meta(data_all):
    """Render the meta file"""
    return render(
        "pfhub_meta", subs(data_all, {"lines": get_lines(data_all), "contours": []})
    )


def get_lines(data_all):
    """Build the lines list of substitutions"""

    def get_line(item):
        return {
            "description": "",
            "url": item.name,
            "ext_type": item.name.split(".")[1],
            "name": item.name.split(".")[0],
            "x_field": item.columns[0],
            "y_field": item.columns[1],
        }

    return pipe(data_all.results.dataset_temporal, map_(get_line), list)
