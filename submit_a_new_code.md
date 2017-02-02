---
title: "Submit a New Code"
layout: essay
comment: >-
  How to submit codes to the <a
  href="/chimad-phase-field/#codes" target="_blank">list</a> on the front page.
---

### Call for Community Codes

This website is intended to help users judge for themselves the
suitability of available codes for their purposes. Performance on the
various benchmark problems are expected to form the major basis for
comparison, but consideration should also be given to ease of
installation, use, and comprehension of the code.

### Requirements

If you develop or use a code for phase field simulations, you are
encouraged to submit it for inclusion on this site if it meets the
following criteria.

  1. Input files for at least one of the [benchmark problems]({{
     site.baseurl }}/#benchmarks) are publicly available.

  2. The program used to run the input files is readily available to
     other researchers.

  3. The program is distributed with documentation to help new users
     install the software and come up to speed on its use for solving
     phase field problems.

Note that these criteria do not exclude proprietary or closed-source
software, so long as the benchmark problems can be implemented in an
open format.  However, if your code is "internal use only" or lacks
documentation, we cannot consider it a "community code."

### Follow-up

After your code is added to the list, please upload at least one
[simulation result]({{ site.baseurl }}/simulations/#simulations) to
provide users with a side-by-side comparison.

### How to Submit

To add a code to the list, update the [`codes.yaml`]({{
site.links.github }}/blob/nist-pages/data/codes.yaml){:target="_blank"}
file via the GitHub repository for this web site and submit a
pull-request.

The YAML file includes fields for the name of the code, a link to an
image logo, a description and a home page. For example,

    - name: My Great Phase Field Code
      logo: http://goo.gl/bsTHP2
      description: Solves all phase field problems
      home_page: http://chimad-phase-field.org
      badges:
        - href: https://pypi.python.org/pypi/FiPy/3.1
          src: https://img.shields.io/pypi/dm/FiPy.svg?style=flat
      examples:
        - name: Cahn-Hilliard
          href: http://usnistgov.github.io/chimad-phase-field/hackathon1/fipy/1a.ipynb/

Badges can be added for services such as
[Openhub](https://www.openhub.net){:target="_blank"} and
[Travis CI](https://travis-ci.org){:target="_blank"}. Please include
the license badge and an
[Openhub](https://www.openhub.net){:target="_blank"} badge at a
minimum. Also, include links to any available annotated phase field
examples.
