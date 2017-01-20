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
[_data/simulations](https://github.com/usnistgov/chimad-phase-field/tree/master/_data/simulations).
A `meta.yaml` file stores the meta data for only one simulation.
A new directory is required for each new simulation.

To record a new simulation, use the following workflow.

 1. [Fork](https://help.github.com/articles/fork-a-repo/) the [website repository]({{ site.links.github }}).

 2. Edit the repository by adding a new directory to
    [`_data/simulations`]({{ site.links.simmeta }}) and create
    `meta.yaml` in the directory.

 3. Fill out the `meta.yaml` using the schema outlined below.
    This is a text-based summary of the benchmark problem,
    your implementation and the hardware used to execute it,
    and links to key data produced by the software at runtime.    

 4. Submit a [pull
    request](https://help.github.com/articles/creating-a-pull-request/)
    for the new `meta.yaml`.


<h4>Minimal Example</h4>

Each key-value description of a specific simulation contains the following three parts:

1. `benchmark`:
   Specify the benchmark problem and version you have implemented.

2. `metadata`:
   Summarize the runtime environment, software and hardware, used to produce this result.

3. `data`:
   Capture salient outputs from the simulation, particularly the free energy evolution.

Following is the minimal description of a simulation, with relevant comments.
The definitive archetype resides at [`_data/simulations/example/example.yaml`]({{
site.links.simmeta }}/example/meta.yaml). Anything after a # is a comment.
Indented blocks following a field (`name+:`) are interpteted as lists,
which may be nested several levels. The YAML format of this document is a
list of lists of dictionaries (or an array of arrays of maps, for the C-minded).

```
---    # signifies beginning of a YAML block
benchmark:
  # Refer to the problem definition for appropriate value.
  id: 1a    # number+letter, from problem description
  version: 1    # number, from problem description

metadata:
  # Describe the runtime environment, hardware and software
  summary: concise description of this contribution    #
  author: name    # preferably yours
  email: "name@organization"    # in quotes
  timestamp: "Day, DD MM YYYY HH:MM:SS -ZONE"    #, e.g. 'date -R' on Linux
  hardware:    #
    # relevant details of your machine or cluster
    cores: 6    #, number actually used if less than total available
  software:    #
    # software framework your application is built upon, from the (website)[{{ site.url }}]
    name: name    # all lower-case, e.g. fipy or moose or prisms, etc.

data:
  # Values for use in tables, charts, galleries, etc.
  # Use Vega standard to help generate graphics directly; see
  # https://github.com/vega/vega/wiki/Data and
  # https://vega.github.io/vega-lite/docs/data.html.
  # Broadly, a list of key-value pairs defined minimally with
  # two keys, 'name' and 'values', to help the parser determine
  # where these data belong on the final site. If 'values' are
  # multiply defined, indent and specify keys 'time' for simulation time
  # and 'value' for appropriate datum.
  - name: timestep
    values: floating-point-value     # non-dimensional
  - name: run_time
    # wall time, in seconds, when specified simulation-times were reached
    values:
      sim_times: [0, 19.5312]
      time: [0.0, 179.43]
  - name: memory_usage
    values: 27232    # peak, in KB
  - name: free_energy
    url: http://somewhere/data.csv    # gist.github.com if you're unsure where to store your data
    format: csv    # preferred, with column headings 'time,free_energy'
```

If you would like to submit additional information, each of the blocks in the
example admits a `details:` block. This will not be parsed for the website,
but may be of use to other users or for future reference.


<h5> The Schema </h5>

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
