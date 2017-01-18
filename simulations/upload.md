---
title: "Simulation Upload"
layout: essay
comment: How to add a new simulation result
---

<h4> Overview </h4>

The following are instructions for adding simulation results to the
[simulation tables and charts]({{ site.baseurl }}/simulations). Please
feel free to upload simulation results via pull requests on
GitHub. More simulations results will greatly improve the utility of
the website and encourage community collaboration.

<h4> How to Upload </h4>

Each simulation result is stored in a file called `meta.yaml` in a
separate directory in
[_data/simulations](https://github.com/usnistgov/chimad-phase-field/tree/master/_data/simulations). A
`meta.yaml` file stores the meta data for only one simulation. A new
directory is required for each new simulation.

To
record a new simulation, use the following workflow.

 1. [Fork](https://help.github.com/articles/fork-a-repo/) the [website repository]({{ site.links.github }}).

 2. Edit the repository by adding a new directory to
    [`_data/simulations`]({{ site.links.simmeta }}) and create
    `meta.yaml` in the directory.

 3. Fill out the `meta.yaml` using the schema outlined below.

 4. Submit a [pull
    request](https://help.github.com/articles/creating-a-pull-request/)
    for the new `meta.yaml`.

<h4> The Schema </h4>

Many examples can be found in [`_data/simulations`]({{
site.links.simmeta }}) and these can be used as templates. The
complete schema is outlined in
[`_data/simulations/example/schema.yaml`]({{ site.links.simmeta
}}/example/schema.yaml). A `meta.yaml` file contains three sections:
`benchmark_id`, `metadata` and `data`.

<h5> Benchmark </h5>

The `benchmark` section includes a `id` and a `version`. This is in
anticipation of version changes to the benchmark problems. The current
choices are `1a`, `1b`, `1c`, `1d`, `2a`, `2b`, `2c` and `2d` for the
`id` value and either `0` or `1` for the `version` value.

    benchmark:
      id: 1a
      version: 1

<h5> Metadata </h5>

The `metadata` section describes the details about the code being
used, but not the outcomes (outcomes go in the `data` section). See
[`_data/simulations/example/meta.yaml`]({{ site.links.simmeta
}}/example/meta.yaml) for all possible fields in the `metadata`
section.

Note that the `metadata.software.details` section takes any number of

    - name: a name
      values: any valid JSON

pairs. This section is open for adding any specific details about the
simulation that are important but not included in other fields within
the metadata section. The `metadata.software.details` section uses the
Vega data spec as described in the next section.

<h5> Data </h5>

The `data` section consists of any number of `name` and `values`
pairs. For example, the `data` section can describe the run time, the
memory usage and data about the free energy at different time
steps. Note that this is data not known before starting the
simulation. The format for the `data` section is the [Vega data
spec](https://github.com/vega/vega/wiki/Data). The basic data model
used by Vega is tabular data, similar to a spreadsheet or database
table.  Individual data sets are assumed to contain a collection of
records (or "rows"), which may contain any number of named data
attributes (fields, or "columns"). The `url` field can either link to
JSON or CSV data currently.

For the charts, there must be a `free_energy` section with
`free_energy` and `time` fields. Other required fields will be added
as more details are displayed on the website. For example, the
following is in [`_data/simulations/moose_1d_sta/meta.yaml`]({{
site.links.simmeta }}/moose_1d_sta/meta.yaml).

    - name: free_energy
      url: https://gist.githubusercontent.com/wd15/41e21ea1090057c42a59380d90367763/raw/a211864b3269e86eb63db6f3dd9167ed18b92d08/hackathon_p1_sphere_STA.csv
      format:
        type: csv
        parse:
          TotalEnergy: number
          time: number
      transform:
        - type: formula
          field: free_energy
          expr: datum.TotalEnergy
        - type: filter
          test: "datum.time > 1.0"
        - type: filter
          test: "datum.time < 1e6"

It describes the `free_energy` by generating `free_energy` and `time`
fields from a CSV file. It describes how to parse the CSV file and
filters time values that are either too large or too small.

Please read the [Vega data
spec](https://github.com/vega/vega/wiki/Data) for more details.

<h4> Testing </h4>

After submitting a pull request, the `meta.yaml` is checked against
the schema on Travis CI and things may need to be repaired. The web
site dev will need to check that the formatting and links work for
displaying the charts and tables. Repairs to the `meta.yaml` may be
necessary at this stage.
