# Nix
Use Cachix

    $ cachix use pfhub

Run with

    $ export NIX_VERSION=21.05
    $ nix-shell \
        -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/${NIX_VERSION}.tar.gz \
        -I pfhub=./ \
        -E 'with (import <nixpkgs> {}); mkShell { buildInputs = [ (python3Packages.callPackage <pfhub> { }) ]; }'


# Upload to cachix

    $ export NIX_VERSION=21.05
    $ nix-build \
        -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/${NIX_VERSION}.tar.gz \
        -I pfhub=./ \
        -E 'with (import <nixpkgs> {}); python3Packages.callPackage <pfhub> { }' \
        | cachix push pfhub
