---
title: "Submit a New Code"
layout: essay
comment: >-
  How to submit a code to the list of <a
  href="/pfhub/codes">suggested codes</a>
---

### Call for Community Codes

This website is intended to help users make their own decisions regarding
the suitability of the available codes for their research goals. For example,
all codes are not equally suited to for solving all types of physics that may
be incorporated into phase field models.  Or, a certain trade-off between
performance and flexibility may be needed.  The numerical performance of the codes
for the various benchmark problems will likely form the major basis for
comparison, but other factors may be considered, such as the ease of installation,
the learning curve to use the code, software compatiblity with different computing
platforms, and available documentation.

### Requirements

If you develop or use a code for phase field simulations, you are
encouraged to submit it for inclusion on this site if it meets the
following criteria.

  1. Input files for at least one of the [benchmark problems]({{
     site.baseurl }}/#benchmarks) are publicly available.

  2. The program used to run the input files is available to other
     researchers with an appropriate license agreement.

  3. The program is distributed with documentation to help new users
     install the software and come up to speed on its use for solving
     phase field problems.

Note that these criteria do not exclude proprietary or closed-source
software, so long as the benchmark problems can be implemented in an
open format.  However, if your code is "internal use only" or lacks
documentation, we cannot consider it a "community code."

### Follow-up

After your code is added to the list, please upload at least one
[benchmark result]({{ site.baseurl }}/simulations/#simulations) to
provide users with a side-by-side comparison.

### How to Submit

To add a code to the list, you need to interact with the GitHub repository
for this website.  Update the [`codes.yaml`]({{
site.links.github }}/blob/nist-pages/_data/codes.yaml){:}
file in the repository and submit a pull-request.

The YAML file includes fields for the name of the code, a link to an
image logo, a description and a home page. For example,

    - name: My Great Phase Field Code
      logo: http://goo.gl/bsTHP2
      description: The Fastest Phase Field Solver in the West
      home_page: http://great-code.org
      badges:
        - href: https://pypi.python.org/pypi/FiPy/3.1
          src: https://img.shields.io/pypi/dm/FiPy.svg?style=flat
      examples:
        - name: Cahn-Hilliard
          href: http://a/link.ipynb.html

Badges can be added for services such as
[Openhub](https://www.openhub.net){:} and
[Travis CI](https://travis-ci.org){:}. Please include
the license badge and an
[Openhub](https://www.openhub.net){:} badge at a
minimum. Also, include links to any available annotated phase field
examples.
