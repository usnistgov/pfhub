from .func import fullmatch, read_yaml, render, get_data_from_yaml
from .zenodo import zenodo_to_meta
from toolz.curried import pipe, dissoc
from toolz.curried import map as map_
from dotwiz import DotWiz
import tempfile
from shutil import make_archive
import os
import pathlib


def convert(url):
    """Convert a PFHub record between different storage versions.

    Take a PFHub records stored at a URL and convert it to another
    version of PFHub storage.

    Args:
      url: the url of the PFHub record file

    Returns:
      returns a link to a file or link to a tarball of files

    """

    match_zenodo = fullmatch(r"https://doi.org/\d{2}.\d{4}/zenodo.\d{7}")
    match_meta = fullmatch(r"https://.*/meta.yaml")

    if match_zenodo(url):
        return zenodo_to_meta(url)

    if match_meta(url):
        return meta_to_zenodo(url)

    raise RuntimeError(f'"{url}" conversion is not yet implemented')


def meta_to_zenodo(url):

    the_yaml = read_yaml(url)

    benchmark_id = the_yaml["benchmark"]["id"]
    schema_path = (
        pathlib.Path(__file__).parent.resolve()
        / "templates"
        / f"{benchmark_id}_data.yaml"
    )

    schema_data = read_yaml(schema_path)

    timeseries_ = []
    for item in schema_data:
        print(item)
        schema = item["schema"]
        if schema["type"] == "file_timeseries":
            data_name = item["name"]
            df = get_data_from_yaml([data_name], ["x", "y"], the_yaml)
            df = df.rename(schema["columns"])
            timeseries_.append(
                dict(
                    dataframe=df,
                    name=schema["name"],
                    format=schema["format"],
                    columns=list(
                        map_((lambda x: dict(name=x)), schema["columns"].values())
                    ),
                )
            )

    data = pipe(
        the_yaml,
        lambda x: render_pfhub_schema(
            DotWiz(**x),
            get_data_from_yaml(["run_time"], ["wall_time", "sim_time"], x),
            get_data_from_yaml(["memory_usage"], ["value"], x),
            list(map_((lambda x: dissoc(x, "dataframe")), timeseries_)),
        ),
    )

    tmp = tempfile.mkdtemp()

    with open(tmp + "/pfhub.yaml", "w") as f:
        f.write(data)

    make_archive("./pfhub", "zip", tmp)

    return os.path.abspath("./pfhub.zip")


def render_pfhub_schema(data, time_data, memory_data, timeseries):
    return render(
        "pfhub.schema",
        dict(
            problem=data.benchmark.id,
            benchmark_version=data.benchmark.version,
            summary=data.metadata.summary,
            contributors=[
                dict(
                    id="github:" + data.metadata.author.github_id,
                    name=data.metadata.author.first + " " + data.metadata.author.last,
                    email=data.metadata.author.email,
                )
            ],
            framework=[dict(name=data.metadata.implementation.name)],
            implementation_url=data.metadata.implementation.repo.url,
            date=data.metadata.timestamp,
            wall_time=time_data.wall_time.iloc[-1],
            memory=memory_data.value.iloc[-1],
            fictive_time=time_data.sim_time.iloc[-1],
            hardware=[
                dict(
                    architecture=data.metadata.hardware.cpu_architecture,
                    cores=data.metadata.hardware.cores,
                    nodes=data.metadata.hardware.nodes,
                )
            ],
            file_timeseries=timeseries,
        ),
    )
