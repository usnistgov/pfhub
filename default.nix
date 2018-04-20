let
  nixpkgs = import ./_nix/nixpkgs_version.nix;
in
  nixpkgs.stdenv.mkDerivation rec {
    name = "pfhub";
    env = nixpkgs.buildEnv { name=name; paths=buildInputs; };
    buildInputs = [
      ( import ./_nix/build.nix { inherit nixpkgs; })
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
    '';
  }
