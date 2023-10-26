# Python-PFHub

A Python module for rendering PFHub phase field data in Jupyter
notebooks using Pandas and Plotly.

## Installation

### Using Nix

Install Nix and use

    $ nix develop

or try

    $ cachix use pfhub
    $ nix develop

if Cachix is installed.

To open up an example notebook use

    $ jupyter notebook

from within the nix development environment and navigate to
`notebooks/test.ipynb`.

### Push to Cachix

If Using Cachix

    $ nix-env -iA cachix -f https://cachix.org/api/v1/install
    $ cachix authtoken <TOKEN>
    $ cachix use pfhub
    $ nix develop --profile pfhub-profile -c true
    $ cachix push pfhub pfhub-profile

## Make a release

The following explains how to release the PFHub package in
`_data/python-pfhub`.

### Test with Mamba

Test with a build system outside of Nix as others are more likely to
use this.

    $ mamba remove -n test-pfhub --all
    $ mamba create -n test-pfhub python=3
    $ mamba activate test-pfhub
    $ python setup.py install

Test the CLI

    $ pfhub

Outside of the working directory

    $ python -c "import pfhub; pfhub.test()"

In the working directory

    $ py.test --nbval-lax --cov-fail-under=100
    $ py.test --nbval-lax ../../results/benchmark*.ipynb

### Update to PyPI test

Upload to the PyPI test repository. Check that the working copy is
clean and tag as a new alpha release.

    $ export VERSION=1.2.3a1
    $ git tag v${VERSION}
    $ git push origin v{VERSION}

and then

    $ nix develop
    $ rm -r dist
    $ python setup.py sdist
    $ twine upload --repository testpypi dist/*
    $ exit

### Test the release

Use mamba to test (or something different from Nix).

Test outside the repository. The version is required to get the new
alpha version.

    $ cd ~
    $ export VERSION=1.2.3a1
    $ mamba remove -n test-pfhub --all
    $ mamba create -n test-pfhub python=3
    $ mamba activate test-pfhub
    $ python3 -m pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ pfhub==${VERSION}

Check the version is correct

    $ python3 -c "import pfhub; print(pfhub.__version__)"

Test the CLI

    $ pfhub

Run the test

    $ python3 -c "import pfhub; pfhub.test()"

### Make a full release

Check that the working copy is clean and then tag

    $ git tag v1.2.3
    $ git push origin v1.2.3

and then

    $ nix develop
    $ rm -r dist
    $ python setup.py sdist
    $ twine upload dist/*
