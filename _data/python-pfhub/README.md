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
