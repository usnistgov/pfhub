let
  nixpkgs = import ./_nix/nixpkgs_version.nix;
in
  import _nix/build.nix { inherit nixpkgs; }
