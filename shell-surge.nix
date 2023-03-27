{
  tag ? "22.11"
}:
let
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${tag}.tar.gz") {};
  pypkgs = pkgs.python3Packages;
  pfhub = pypkgs.callPackage ./_data/python-pfhub/default.nix { };
in
  pkgs.mkShell rec {
    pname = "pfhub-surge";
    nativeBuildInputs = with pypkgs; [
      pkgs.rubyPackages.github-pages
      pkgs.nodePackages.surge
      pypkgs.python
      ipython
      ipykernel
      traitlets
      notebook
      widgetsnbextension
      ipywidgets
      scipy
      papermill
      jupytext
      matplotlib
      bokeh
      scikitimage
      papermill
      jupytext
      (if pkgs.stdenv.isDarwin then pypkgs.jupyter else pypkgs.jupyterlab)
      pfhub
    ];
    shellHook = ''
      # export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
      # export OMPI_MCA_plm_rsh_agent=${pkgs.openssh}/bin/ssh

      SOURCE_DATE_EPOCH=$(date +%s)
      export PYTHONUSERBASE=$PWD/.local
      export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
      export PYTHONPATH=$PYTHONPATH:$USER_SITE
      export PATH=$PATH:$PYTHONUSERBASE/bin

      jupyter serverextension enable jupytext
      jupyter nbextension install --py jupytext --user
      jupyter nbextension enable --py jupytext --user

    '';
  }
