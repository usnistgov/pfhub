with import <nixpkgs> { };

let nbval = import ./nbval.nix;
in stdenv.mkDerivation rec {
  name = "env";
  buildInputs = [
    nbval
    python36Packages.pytest
  ];
}
