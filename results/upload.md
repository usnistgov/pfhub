```python
from pfhub.convert import convert
```

```python
!rm pfhub.yaml pfhub.zip free_energy_1a.csv
```

```python
out = convert("https://raw.githubusercontent.com/usnistgov/pfhub/master/_data/simulations/fipy_1a_travis/meta.yaml")
```

```python
out = convert("https://raw.githubusercontent.com/usnistgov/pfhub/master/_data/simulations/prismspf_1a/meta.yaml")
```

```python
!unzip pfhub.zip
```

```python
!cat pfhub.yaml
```

```python
!cat free_energy_1a.csv
```

```python
dict(a=1, b=2).values()
```

```python
!cat /run/user/33396/tmp4qnskpwq/pfhub.yaml
```

```python
!file /home/wd15/git/pfhub/simulations/pfhub.zip

```

```python
!unzip /home/wd15/git/pfhub/simulations/pfhub.zip
```

```python
!cat pfhub.yaml
```

```python
!ls
```

```python
!ls
```

```python
print(convert("https://doi.org/10.5281/zenodo.7474506", to="version1"))
```

<!-- #raw -->
---
title: "Manual Result Upload"
layout: essay
comment: >-
  How to add a new benchmark result manually. However, in most cases
  it is easier to use the automated <a
  href="/pfhub/simulations/upload_form">upload form</a>.

---
<!-- #endraw -->

<h4> Overview </h4>

The following are instructions for adding benchmark results to the
[benchmark tables and charts]({{ site.baseurl }}/simulations). Please
feel free to upload benchmark results via pull requests on
GitHub. More benchmark results will greatly improve the utility of the
website and encourage community collaboration.


Each benchmark result is stored in a [YAML file][YAML] called
`meta.yaml` in a separate directory in [_data/simulations]({{
site.links.github }}/tree/master/_data/simulations).  A [YAML file][YAML]
is a minimal, human readable syntax for structured
data. The `meta.yaml` file stores the meta data for only one benchmark
result and a new directory is required for each new benchmark result.


<h4> How to Upload </h4>

To record a new benchmark result, use the following workflow.

 1. <a
 href="https://docs.github.com/en/get-started/quickstart/fork-a-repo"
 data-proofer-ignore>Fork</a> the [website repository]({{
 site.links.github }}).

 2. Edit the repository by adding a new directory to
    [`_data/simulations`]({{ site.links.simmeta }}) and create
    `meta.yaml` in the directory. The name of the directory becomes
    the name of the benchmark result on the website so try to use a
    descriptive name for the directory.

 3. Fill out the `meta.yaml` using the schema outlined below.  This is
    a text-based summary of the benchmark problem, your implementation
    and the hardware used to execute it, and links to data displayed
    on the website.

 4. Submit a <a
    href="https://help.github.com/articles/creating-a-pull-request/"
    data-proofer-ignore>pull request</a> for the new `meta.yaml`. At
    this stage the website test suite will check the `meta.yaml`
    against the schema. The website developer can then work with the
    benchmark uploader to refine the `meta.yaml` so that all the data
    associated with the benchmark result is available to be displayed
    on the website.

<h4>Minimal Example of a YAML Benchmark File</h4>

Each [YAML][YAML] description of a specific benchmark result contains
the following three parts:

 1. `benchmark`: specify the benchmark problem and version you have
    implemented,

 2. `metadata`: summarize the runtime environment, software and
    hardware, used to produce this result and

 3. `data`: capture salient outputs from the benchmark result,
    particularly the free energy evolution to be displayed on the
    website

The following is the minimal description of a benchmark result with
relevant comments. The definitive archetype resides at
[`_data/simulations/example/example.yaml`]({{ site.links.simmeta
}}/example/meta.yaml). To understand the YAML syntax consult either
the [Ansible documentation][YAML] for a simple overview or the [YAML
site](http://www.yaml.org/) for a more in depth description.

```
---
# miminal example with the required fields
benchmark:
  # Refer to the problem definition for appropriate value.
  id: 1a    # number+letter, from problem description
  version: 1    # number, from problem description

metadata:
  # Describe the runtime environment, hardware and software
  summary: concise description of this contribution    #
  author: name    # preferably yours
  email: "name@organization"    # in quotes
  timestamp: "Day, DD MM YYYY HH:MM:SS -ZONE"    #, e.g. 'date -R' on Linux or any valid timestamp
  hardware:    #
    # relevant details of your machine or cluster
    architecture: i686   # architecture of the environment
    cores: 6    # number actually used if less than total available
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
  # multiply defined, indent and specify keys 'time' for execution time
  # and 'value' for appropriate datum.
  - name: run_time
    # wall time, in seconds, when specified execution-times were reached
    values:
      - sim_time: 0.0
        time: 0.0
      - sim_time: 2.0
        time: 1.0
      - sim_time: 8.0
        time: 2.0
  - name: memory_usage
    values: 27232    # peak, in KB
  - name: free_energy
    url: https://somewhere/data.csv
    format:
      type: csv
      parse:
        free_energy: number
        time: number

```

If you would like to submit additional information, each of the blocks
in the example admits a `details:` block. This is currently not parsed
for the website, but may be of use to other users aor for future
reference.

<h5> The Schema (Layout of the YAML File) </h5>

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
benchmark result that are important but not included in other fields
within the metadata section. The `metadata.software.details` section
uses the Vega data spec as described in the next section.

<h5> Data </h5>

The `data` section consists of any number of `name` and `values`
pairs. For example, the `data` section can describe the run time, the
memory usage and data about the free energy at different time
steps. Note that this is data not known before starting the
execution. The format for the `data` section is the [Vega data
spec](https://github.com/vega/vega/wiki/Data). The basic data model
used by Vega is tabular data, similar to a spreadsheet or database
table.  Individual data sets are assumed to contain a collection of
records (or "rows"), which may contain any number of named data
attributes (fields, or "columns"). The `url` field can either link to
JSON or CSV data currently, but we can extend the possible formats as
the need arises.

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

<h4> Automated Testing of Benchmark Uploads</h4>

The uploaded `meta.yaml` file is automatically tested to check that it
is in compliance with the schema when the pull-request is
submitted. The results of this check will appear on the pull-request
page. Repairs to the `meta.yaml` may be necessary to pass the tests.
If the tests all pass, the web site dev will need to check that the
formatting and links work for displaying the charts and tables, which
is not entirely automated by the test suite. Further repairs may be
necessary at this stage.

[YAML]: https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html
