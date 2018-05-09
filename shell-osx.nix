let
  nixpkgs = import ./_nix/nixpkgs_version.nix;
in
  import ./_nix/env.nix { inherit nixpkgs; }
