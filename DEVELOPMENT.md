---
title: "Development Guide"
layout: essay
comment: How to modify this site (beyond adding new simulations)
---

<p align="center">
<a href="https://travis-ci.org/{{ site.links.repo }}" target="_blank">
<img src="https://api.travis-ci.org/{{ site.links.repo }}.svg"
     alt="Travis CI badge">
</a>
</p>

<h4> Overview </h4>

The following guide is an overview on how to update the site for each
particular element. Each page on this site is given by a combination of
markdown files, .yaml files, and Jupyter notebooks. These files are converted
to HTML using Jekyll, a static web page generator. The site is tested on
[Travis CI](https://travis-ci.org/{{ site.links.repo }}) using
[HTMLProofer][HTMLPROOFER], which automatically checks the site for
errors. The [`.travis.yml`][TRAVISYML] file contains everything
required to build the site. Note that if the instructions below and
the [`.travis.yml`][TRAVISYML] are not synced then the build outlined
in the [`travis.yml`][TRAVISYML] should be used. The main site is hosted on
[pages.nist.gov](https://pages.nist.gov/pages-root/), which provides
the [build.log]({{ site.links.live_url }}/build.log)
for the Jekyll build.

Different aspects of this site can be edited using Google Forms, GitHub, or
on your local machine. The list below gives which method should be used
for various types of changes. Many of these tasks require that you have an
account on [GitHub][GITHUB].

***Update directly on GitHub***

- [Add yourself to the community page](#comm_page)
- [Add a new phase field code](#new_code)
- [Add a new workshop](#new_workshop)
- [Add a new page](#new_page)

***Update on your local machine***

- [How to build and view the site locally](#build_site)
- [Update and build the Hexbin (hexagonal tiles of images on the homepage)](#build_hexbin)
- [Add a Jupyter notebook](#new_notebook)
- [Add a new benchmark problem](#new_problem)
- [Test the HTML output](#test_html)

Detailed instructions for each of aspects of the site are given in the
following sections.

<h4> Update Directly on GitHub </h4>

Several common tasks can be accomplished on [GitHub][GITHUB] by
editing files <a
href="https://help.github.com/articles/creating-a-pull-request"
data-proofer-ignore>in-place</a>.  Doing so will automatically fork
the repository to your [GitHub][GITHUB] account and submit a pull
request to update the [master GitHub repository]({{ site.links.github
}}) with your content.

<h5> <a name="comm_page"></a>Update the Community Page </h5>

To add a new entry to the communtiy page edit the
[`community.yaml`]({{ site.links.github
}}/blob/nist-pages/_data/community.yaml) file. The following fields
need to be included for each entry.

    - name: Your name
      text: A biographical sketch
      email: Your email
      home: Link to your home page
      github_id: Your Github ID
      twitter: Your Twitter handle
      avatar: Link to your image

Please also add other social media links beyond GitHub and Twitter
that you'd like to include as well.

<h5> <a name="new_code"></a>Add a New Phase Field Code </h5>

To add a new phase field code to the list of codes on the front page,
follow the [submission instructions]({{ site.baseurl
}}/submit_a_new_code) on the main site. [Jekyll][JEKYLL] will
automatically rebuild the site after `codes.yaml` is edited.

<h5> <a name="new_workshop"></a>Add a New Workshop </h5>

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
[Materialize icon](http://materializecss.com/icons.html).

<h5> <a name="new_page"></a>Add a New Page </h5>

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
page will appear under `.../{{ site.links.raw_name }}/my-page` after the
pull-request is merged.

<h4> Update on Your Local Machine </h4>

Some tasks involve adding new files or rebuilding existing ones. These
are best done on your local machine, on a <a
href="https://docs.github.com/en/get-started/quickstart/contributing-to-projects"
data-proofer-ignore>clone of your fork </a>of the [master GitHub
repository]({{ site.links.github }}).  You are encouraged to serve as
local version of the site for testing before <a
href="https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository"
data-proofer-ignore>pushing your commits</a>and issuing a <a
href="https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request"
data-proofer-ignore>pull request</a>.

<h5> <a name="build_site"></a>Build and Serve the Site </h5>

The site uses the [Jekyll][JEKYLL] static web site generator. To build
the environment required to serve the site, use the following
commands.

    $ sudo apt-get update
    $ sudo apt-get install ruby nodejs
    $ sudo gem install jekyll jekyll-coffeescript

Then clone your fork of the GitHub repository.

    $ git clone https://github.com/your_GitHub_account/{{ site.links.raw_name }}.git
    $ cd {{ site.links.raw_name }}
    $ jekyll serve

At this point [Jekyll][JEKYLL] should be serving the site. Go to
<a href="http://localhost:4000/{{ site.links.raw_name }}/" data-proofer-ignore>
<code class="highlighter-rouge">http://localhost:4000/{{ site.links.raw_name }}/</code>
</a>
or the link [Jekyll][JEKYLL] provides on the terminal, to view the
site.

<h5> <a name="build_hexbin"></a>Update and Build the Hexbin </h5>

To build the Hexbin, the tiled hexagonal images on the homepage, a Python environment is required. To setup the
environment use [Conda][CONDA].

    $ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    $ bash miniconda.sh -b -p $HOME/miniconda
    $ export PATH="$HOME/miniconda/bin:$PATH"
    $ conda update conda
    $ conda create -n test-environment python=3

Create an environment with the required packages

    $ source activate test-environment
    $ conda install -n test-environment pillow numpy

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

<h5> <a name="new_notebook"></a>Add a Jupyter Notebook </h5>

The benchmark specifications are built using Jupyter Notebooks. To render the
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
`http://localhost:4000/{{ site.links.raw_name }}/my_notebook.ipynb`.

<h5> <a name="new_problem"></a>Add a New Benchmark Problem </h5>

To add a new benchmark problem include a notebook describing the new
problem and then link to it via the [`benchmarks.yaml`]({{
site.links.github }}/blob/nist-pages/_data/benchmarks.yaml) file with
the following fields.

    - title: Spinodal Decomposition
      url: "benchmarks/benchmark1.ipynb/"
      description: Test the diffusion of a solute in a matrix.
      image: http://www.comsol.com/model/image/2054/big.png

<h5> <a name="test_html"></a>Testing </h5>

The site can be tested at the command line using
[HTMLProofer][HTMLPROOFER]. This validates the generated HTML
output. First install [HTMLProofer][HTMLPROOFER].

    $ sudo gem install html-proofer

Make fresh builds of all the notebooks to check that they can be built.

    $ find . -name "*.ipynb" -type f -not -path "*/.ipynb_checkpoints/*" -exec touch {} \;
    $ make notebooks

Make a fresh Hexbin to check its build process.

    $ touch _data/hexbin.yaml
    $ make hexbin

Use [HTMLProofer][HTMLPROOFER] to check the site.

    $ jekyll build -d ./_site/{{ site.links.raw_name }} && htmlproofer --allow-hash-href --empty-alt-ignore --checks-to-ignore ImageCheck ./_site

Note that the images are not checked for valid HTML and for links as
the images that are auto-generated by Jupyter which seems to break
HTML guidelines (no alt tag for example). Also note that the rendered
HTML needs to be written to `./_site/{{ site.links.raw_name }}` rather than
`/_site` for [HTMLProofer][HTMLProofer] to check the internal links
correctly.

[TRAVISYML]: {{ site.links.github }}/blob/nist-pages/.travis.yml
[CONDA]: http://conda.pydata.org/docs/index.html
[JEKYLL]: https://jekyllrb.com
[GITHUB]: https://github.com
[HTMLPROOFER]: https://github.com/gjtorikian/html-proofer
