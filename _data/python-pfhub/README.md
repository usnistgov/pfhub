# Python-PFHub

A Python module for rendering PFHub phase field data in Jupyter
notebooks using Pandas and Plotly.

## Installation

### Using Nix

If Using Cachix

    $ cachix use pfhub

and then fire up a Nix shell with

    $ export NIX_VERSION=21.05
    $ nix-shell \
        -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/${NIX_VERSION}.tar.gz \
        -I pfhub=./ \
        -E 'with (import <nixpkgs> {}); mkShell { buildInputs = [ (python3Packages.callPackage <pfhub> { }) ]; }'

#### Upload to cachix

    $ export NIX_VERSION=21.05
    $ nix-build \
        -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/${NIX_VERSION}.tar.gz \
        -I pfhub=./ \
        -E 'with (import <nixpkgs> {}); python3Packages.callPackage <pfhub> { }' \
        | cachix push pfhub
