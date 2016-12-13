---
title: "Development Guide"
layout: essay
comment: How to develop this site
---

## Overview

The following guide is an overview on how to update the site for each
particular element.  The site is tested on
[Travis CI](https://travis-ci.org/usnistgov/chimad-phase-field) using
[HTMLProofer][HTMLPROOFER], which automatically checks the site for
errors. The [`.travis.yml`][TRAVISYML] file contains everything
required to build the site. Note that if the instructions below and
the [`.travis.yml`][TRAVISYML] are not synced then the build outlined
in the [`travis.yml`][TRAVISYML] should be used.

## Build and Serve the Site

The site uses the [Jekyll][JEKYLL] static web site generator. To build
the environment required to serve the site, use the following
commands.

    $ sudo apt-get update
    $ sudo apt-get install ruby
    $ sudo gem install jekyll jekyll-coffeescript

Then clone the GitHub repository.

    $ git clone https://github.com/usnistgov/chimad-phase-field.git
    $ cd chimad-phase-field
    $ jekyll serve


At this point [Jekyll][JEKYLL] should be serving the site. Go to
`http://localhost:4000/chimad-phase-field` to view the site.

## Add a New Phase Field Code

To add a new phase field code to the list of codes on the front page,
follow the [submission instructions]({{ site.baseurl
}}/submit_a_new_code) on the main site. [Jekyll][JEKYLL] will
automatically rebuild the site after `codes.yaml` is edited.

## Add a new workshop

To add a new workshop edit the [`workshop.yaml`]({{ site.links.github
}}/blob/nist-pages/data/workshops.yaml) file. The following fields need to
be included for each entry.

    - name: "Phase Field Methods Workshop I"
      date: "Jan 9-10, 2015"
      href: http://planitpurple.northwestern.edu/event/474167/xJDsFEfb
      number: 1
      contact: mailto:daniel.wheeler@nist.gov
      description: >-
        Workshop held at Northwestern University to discuss code
        collaboration in phase field modelling.
      icon_links:
        - name: contact organizer
          type: email
          href: "mailto:daniel.wheeler@nist.gov?subject=First Phase Field Methods Workshop"
        - name: Download PDF
          type: file_download
          href: "{{ site.baseurl }}/docs/CHiMaD_PhaseFieldWorkshop.pdf"

For each of the `icon_links`, the `type` field must correspond to a
[Materialize icon](https://material.io/icons/).

## Update the Community Page

The community page supports dynamic additions using Google
Forms. Google Forms stores the data in a Google Docs spreadsheet. The
link for the spreadsheet is stored in the [`_config.yaml`]({{
site.links.github }}/blob/nist-pages/_config.yml) file under
`links.members`. Currently the following fields are required in the
form with the exact string matches.

    - Name
    - "Bio (one or two sentences)"
    - URL
    - Email
    - "Home Page"
    - "Twitter Handle"
    - "GitHub Handle"
    - "Other Links"

## Update and Build the Hexbin

To build the Hexbin, a Python environment is required. To setup the
environment use [Conda][CONDA].

    $ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    $ bash miniconda.sh -b -p $HOME/miniconda
    $ export PATH="$HOME/miniconda/bin:$PATH"
    $ conda update conda
    $ conda create -n test-environment python=3

Create an environment with the required packages

    $ source activate test-environment
    $ conda install -n test-environment pillow numpy
    $ conda install progressbar2

Update the data in the [`hexbin.yaml`]({{ site.links.github
}}/blob/nist-pages/data/hexbin.yaml) file. The following format is used for each entry.

    - image: http://www.mem.drexel.edu/ysun/files/density.png
      url: http://www.mem.drexel.edu/ysun/Solidification.htm
      title: Solidification Simulation
      description: >-
        Phase-Field Simulation of Solidification (Collaborator:
        Prof. Christoph Beckermann, University of Iowa)

The `url` field is the page that describes the image or the work
associated with the image.  After updating rebuild the Hexbin.

    $ make hexbin

[Jekyll][JEKYLL] should automatically update the site.

## Add a Jupyter Notebook

A lot of the site is built using Jupyter Notebooks. To render the
notebooks as HTML, first generate the Python environment outlined
above, and then install Jupyter.

    $ source activate test-environment
    $ conda install -n test-environment jupyter

Make a new notebook or edit an existing one and then rebuild the
notebook HTML.

    $ make notebooks

This should automatically generate the HTML and [Jekyll][JEKYLL] will
render it on the site. For example, a notebook in the base directory
named `my_notebook.ipynb` will be rendered at
`http://localhost:4000/chimad-phase-field/my_notebook.ipynb`.

## Add a new Benchmark Problem

To add a new benchmark problem include a notebook describing the new
problem and then link to it via the [`benchmarks.yaml`]({{
site.links.github }}/blob/nist-pages/data/benchmarks.yaml) file with
the following fields.

    - title: Spinodal Decomposition
      url: "benchmarks/benchmark1.ipynb/"
      description: Test the diffusion of a solute in a matrix.
      image: http://www.comsol.com/model/image/2054/big.png

## Testing

The site can be tested at the command line using
[HTMLProofer][HTMLPROOFER]. This validates the generated HTML
output. First install [HTMLProofer][HTMLPROOFER].

    $ sudo gem install html-proofer

Make fresh builds of all the notebooks to check that they can be built.

    $ find . -name "*.ipynb" -type f -not -path "*/.ipynb_checkpoints/*" -exec touch {} \;
    $ make notebooks

Make a fresh Hexbin to check its build process.

    $ touch data/hexbin.yaml
    $ make hexbin

Use [HTMLProofer][HTMLPROOFER] to check the site.

    $ jekyll build -d ./_site/chimad-phase-field && htmlproofer --allow-hash-href --empty-alt-ignore --checks-to-ignore ImageCheck ./_site

Note that the images are not checked for valid HTML and for links as
the images that are auto-generated by Jupyter which seems to break
HTML guidelines (no alt tag for example). Also note that the rendered
HTML needs to be written to `./_site/chimad-phase-field` rather than
`/_site` for [HTMLProofer][HTMLProofer] to check the internal links
correctly.

[TRAVISYML]: {{ site.links.github }}/blob/nist-pages/.travis.yml
[CONDA]: http://conda.pydata.org/docs/index.html
[JEKYLL]: https://jekyllrb.com
[HTMLPROOFER]: https://github.com/gjtorikian/html-proofer
