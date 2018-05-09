let
  nixpkgs = import ./_nix/nixpkgs_version.nix;
  extra = [
    nixpkgs.python36Packages.jupyter
    nixpkgs.python36Packages.bokeh
  ];
in
  import ./_nix/env.nix { inherit nixpkgs; inherit extra; }
