#
# $ nix-shell --pure --argstr tag 20.09
#

{
  tag ? "22.11",
}:
let
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${tag}.tar.gz") {};
  pypkgs = pkgs.python3Packages;
  pfhub = pypkgs.callPackage ./default.nix { };
  extra = with pypkgs; [ black pylint flake8 ipdb chevron ];
itables = pypkgs.buildPythonPackage rec {
  pname = "itables";
  version = "0.4.6";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-XiLxeYHR8a3QqiyA+azC5O157XuRGvgb+exU1h7aAck=";
  };

  doCheck = false;

  propagatedBuildInputs = [ pypkgs.ipykernel pypkgs.pandas pypkgs.requests ];
};
  jupyter_extra = with pypkgs; [
    ipython
    ipykernel
    traitlets
    notebook
    widgetsnbextension
    ipywidgets
    scipy
    itables
    papermill
    (if pkgs.stdenv.isDarwin then pypkgs.jupyter else pypkgs.jupyterlab)
  ];
in
  (pfhub.overridePythonAttrs (old: rec {

    propagatedBuildInputs = old.propagatedBuildInputs;

    nativeBuildInputs = propagatedBuildInputs ++ extra ++ jupyter_extra;

    PIP_DISABLE_PIP_VERSION_CHECK = true;

    postShellHook = ''
      SOURCE_DATE_EPOCH=$(date +%s)
      export PYTHONUSERBASE=$PWD/.local
      export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
      export PYTHONPATH=$PYTHONPATH:$USER_SITE:$(pwd)
      export PATH=$PATH:$PYTHONUSERBASE/bin
      export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
    '';
  }))
