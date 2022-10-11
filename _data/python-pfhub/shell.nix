#
# $ nix-shell --pure --argstr tag 20.09
#

{
  tag ? "21.05",
}:
let
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${tag}.tar.gz") {};
  pypkgs = pkgs.python3Packages;
  pfhub = pypkgs.callPackage ./default.nix { };
  extra = with pypkgs; [ black pylint flake8 ipdb chevron ];
  nixes_src = builtins.fetchTarball "https://github.com/wd15/nixes/archive/9a757526887dfd56c6665290b902f93c422fd6b1.zip";
  jupyter_extra = pypkgs.callPackage "${nixes_src}/jupyter/default.nix" { };
in
  (pfhub.overridePythonAttrs (old: rec {

    propagatedBuildInputs = old.propagatedBuildInputs;

    nativeBuildInputs = propagatedBuildInputs ++ extra ++ [ jupyter_extra ];

    postShellHook = ''
      SOURCE_DATE_EPOCH=$(date +%s)
      export PYTHONUSERBASE=$PWD/.local
      export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
      export PYTHONPATH=$PYTHONPATH:$USER_SITE:$(pwd)
      export PATH=$PATH:$PYTHONUSERBASE/bin
      export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
    '';
  }))
