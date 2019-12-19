let
    pkgs = import (builtins.fetchGit {
      url = "https://github.com/NixOS/nixpkgs.git";
      rev = "7f1288b6ab49ff3220dbcf22e33573c8a777b9f4";
      ref = "master";
    }) { };
    pythonPackages = pkgs.python3Packages;
in
  pkgs.mkShell {
    buildInputs = with pythonPackages; [
      starlette
      uvicorn
      pydantic
      fastapi
      ipywidgets
      jupyter
      pip
      pandas
      toolz
      black
      pylint
      flake8
      pkgs.google-cloud-sdk
      pytest
    ];

    shellHook = ''
      jupyter nbextension install --py widgetsnbextension --user
      jupyter nbextension enable widgetsnbextension --user --py

      SOURCE_DATE_EPOCH=$(date +%s)
      export PYTHONUSERBASE=$PWD/.local
      export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
      export PYTHONPATH=$PYTHONPATH:$USER_SITE
      export PATH=$PATH:$PYTHONUSERBASE/bin

      pip install --user archieml
    '';
  }
