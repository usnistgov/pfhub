---
title: "Overview"
---

# CHiMaD - Phase Field

This repository is the basis for a website for the CHiMaD - Phase
Field group that met at the workshop in January 2015. See the [PDF
file](https://drive.google.com/file/d/0B4101gT3tHveaGhmajZ4cE1fQWM/view?usp=sharing)
describing the workshop.

We aim to address the following issues:

 * collate data comparing code capabilities

 * collate date about phase field developers

 * finalize a set of canonical phase field examples

 * push scripts, recipes (IPython notebooks for example) for building
   and running phase field codes that solve the canonical examples (or
   any other phase field examples)

 * link to virtual machines for phase field codes

 * store phase field meta analysis on such things as efficiency
   (memory use), convergence, capabilities or ease of use

 * eventually include meta analysis tools for automated testing of
   multiple phase field codes

 * eventually include a generic high level API to describe phase field
   problems with hooks into multiple codes

## [Mailing List](MAILING_LIST.md)

If you would like to discuss this repository, you can either submit an
issue on the [issue tracker](../../issues) or sign up for
`chimad-phase-field@nist.gov` list (see
[instructions](MAILING_LIST.md)).

## Generating the Hexbin

In order to generate the hexbin, you need to run

    $ python hexbin.py

This loads `hexbin.yaml` with the images and links and builds the a
10x10 grid of thumbnail images (`../images/hexbin.jpg`) that can be
used in the display. The `phase_field_hexbin.js` assumes a 10x10 grid
and that code is pretty much taken straight from
http://d3js.org/. `hexbin.py` also dumps `../json/hexbin.json` which
should be read by `phase_field_hexbin.js`, but currently it is just
pasted into the Javascript.

### Requirements

The script requires `progressbar2`. Install with

    $ pip install progressbar2
