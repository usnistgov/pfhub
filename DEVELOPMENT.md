---
title: "Development Guide"
layout: essay
comment: How to develop this site
---

<p align="center">
<a href="https://travis-ci.org/usnistgov/chimad-phase-field" target="_blank">
<img src="https://api.travis-ci.org/usnistgov/chimad-phase-field.svg"
alt="Travis CI">
</a>
</p>

<h4> Overview </h4>

The following guide is an overview on how to update the site for each
particular element. Many of these tasks require that you have an
account on [GitHub][GITHUB]. Tasks are grouped below according to
where you should edit the site: on the [master GitHub repository]({{
site.links.github }}) or your personal
[fork](https://help.github.com/articles/fork-a-repo/), or on your
local machine.

The site is tested on
[Travis CI](https://travis-ci.org/usnistgov/chimad-phase-field) using
[HTMLProofer][HTMLPROOFER], which automatically checks the site for
errors. The [`.travis.yml`][TRAVISYML] file contains everything
required to build the site. Note that if the instructions below and
the [`.travis.yml`][TRAVISYML] are not synced then the build outlined
in the [`travis.yml`][TRAVISYML] should be used.

<h4> Updates on GitHub </h4>

Several common tasks can be accomplished on [GitHub][GITHUB]
by editing files
[in-place](https://help.github.com/articles/editing-files-in-another-user-s-repository/).
Doing so will automatically fork the repository to your
[GitHub][GITHUB] account and submit a pull request to update the
[master GitHub repository]({{ site.links.github }})
with your content.

<h5> Add a New Phase Field Code </h5>

To add a new phase field code to the list of codes on the front page,
follow the [submission instructions]({{ site.baseurl
}}/submit_a_new_code) on the main site. [Jekyll][JEKYLL] will
automatically rebuild the site after `codes.yaml` is edited.

<h5> Add a New Workshop </h5>

To add a new workshop edit the [`workshop.yaml`]({{ site.links.github
}}/blob/nist-pages/_data/workshops.yaml) file. The following fields need to
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
Materialize icon.

<h5> Add a New Page </h5>

To add a new page create the page as a Markdown file directly on
[GitHub]({{ site.links.github }}). For example, click "Create new
file" on [GitHub]({{ site.links.github }}) called `my-page.md` and add
the contents

    ---
    layout: basic
    ---

    # My Phase Field Page

    Something about phase field ...

Submit a pull request on [GitHub]({{ site.links.github }}) and this
page will appear under `.../chimad-phase-field/test-page` after the
pull-request is merged.

<h4> Updates on Your Local machine </h4>

Some tasks involve adding new files or rebuilding existing ones. These
are best done on your local machine, on a
[clone of your fork](https://guides.github.com/activities/forking/)
of the
[master GitHub repository]({{ site.links.github }}).
You are encouraged to serve a local version of the site for testing before
[pushing your commits](https://help.github.com/articles/pushing-to-a-remote/)
and issuing a
[pull request](https://help.github.com/articles/creating-a-pull-request/).

<h5> Build and Serve the Site </h5>

The site uses the [Jekyll][JEKYLL] static web site generator. To build
the environment required to serve the site, use the following
commands.

    $ sudo apt-get update
    $ sudo apt-get install ruby ruby-dev nodejs
    $ sudo gem install jekyll jekyll-coffeescript

Then clone your fork of the GitHub repository.

    $ git clone https://github.com/your_GitHub_account/chimad-phase-field.git
    $ cd chimad-phase-field
    $ jekyll serve

At this point [Jekyll][JEKYLL] should be serving the site. Go to
<a href="http://localhost:4000/chimad-phase-field/" data-proofer-ignore>
<code class="highlighter-rouge">http://localhost:4000/chimad-phase-field/</code>
</a>
or the link [Jekyll][JEKYLL] provides on the terminal, to view the
site.

<h5> Update and Build the Hexbin </h5>

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
}}/blob/nist-pages/_data/hexbin.yaml) file. The following format is
used for each entry.

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

<h5> Add a Jupyter Notebook </h5>

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

<h5> Add a New Benchmark Problem </h5>

To add a new benchmark problem include a notebook describing the new
problem and then link to it via the [`benchmarks.yaml`]({{
site.links.github }}/blob/nist-pages/_data/benchmarks.yaml) file with
the following fields.

    - title: Spinodal Decomposition
      url: "benchmarks/benchmark1.ipynb/"
      description: Test the diffusion of a solute in a matrix.
      image: http://www.comsol.com/model/image/2054/big.png

<h5> Testing </h5>

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
[GITHUB]: https://github.com
[HTMLPROOFER]: https://github.com/gjtorikian/html-proofer

<h4> Update the Community Page </h4>

An instance of this Web site is hosted at
[NIST](https://pages.nist.gov/chimad-phase-field).
The [community page](https://pages.nist.gov/chimad-phase-field/community/)
supports dynamic additions using Google
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

<h4> Pages.nist.gov </h4>

The main site is hosted on
[Pages.nist.gov](https://pages.nist.gov/pages-root/), which provides
the [build.log](https://pages.nist.gov/chimad-phase-field/build.log)
for the Jekyll build.
