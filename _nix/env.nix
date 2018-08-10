{ nixpkgs, extra ? []}:
nixpkgs.stdenv.mkDerivation rec {
  name = "pfhub";
  env = nixpkgs.buildEnv { name=name; paths=buildInputs; };
  buildInputs = ( import ./build.nix { inherit nixpkgs; }) ++ extra;
  src = ./..;
}
