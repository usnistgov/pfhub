{ nixpkgs }:
let
  pkgs = nixpkgs.pkgs;
  jekyll_env = nixpkgs.bundlerEnv rec {
    name = "jekyll_env";
    ruby = nixpkgs.ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
  pypkgs = nixpkgs.python36Packages;
  pypi2nix = import ./requirements.nix { inherit pkgs; };
  nbval = import ./nbval.nix { inherit pkgs; };
  node = import ./node.nix { inherit pkgs; };
  toml = import ./toml.nix { inherit pypkgs; };
  black = import ./black.nix { inherit pypkgs toml; };
in
  [
    jekyll_env
    nbval
    pkgs.python36
    pypkgs.pillow
    pypkgs.numpy
    pypkgs.toolz
    pypkgs.matplotlib
    pypkgs.flake8
    pypkgs.pylint
    pypi2nix.packages."pykwalify"
    pypi2nix.packages."vega"
    pypi2nix.packages."progressbar2"
    pypkgs.pytest
    pkgs.nodejs
    node.mocha
    node.coffeelint
    node."assert"
    node.surge
    node.execjs
    pkgs.git
    pkgs.openssh
    black
    toml
    pypkgs.appdirs
  ]
