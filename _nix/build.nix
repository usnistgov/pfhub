{ nixpkgs ? import ./nixpkgs_version.nix }:
let
  pkgs = nixpkgs.pkgs;
  jekyll_env = nixpkgs.bundlerEnv rec {
    name = "jekyll_env";
    ruby = nixpkgs.ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
  python36Packages = nixpkgs.python36Packages;
  pypi2nix = import ./requirements.nix { inherit pkgs; };
  nbval = import ./nbval.nix { inherit pkgs; };
  node = import ./node.nix { inherit pkgs; };
in
  [
    jekyll_env
    nbval
    pkgs.python36
    python36Packages.jupyter
    python36Packages.pillow
    python36Packages.numpy
    python36Packages.toolz
    python36Packages.bokeh
    python36Packages.matplotlib
    python36Packages.flake8
    python36Packages.pylint
    pypi2nix.packages."pykwalify"
    pypi2nix.packages."vega"
    pypi2nix.packages."progressbar2"
    python36Packages.pytest
    pkgs.nodejs
    node.mocha
    node.coffeelint
    node."assert"
    node.surge
    node.execjs
  ]
