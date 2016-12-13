---
title: "Submit a New Code"
layout: essay
comment: >-
  How to submit codes to the <a
  href="/chimad-phase-field/#codes" target="_blank">list</a> on the front page.
---

### Requirements

The main requirements for listing a code are that the code includes an
[open source license](http://choosealicense.com){:target="_blank"}, is
available via a public repository and includes annotated phase field
examples.

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
