{
  description = "Python environment for python-pfhub";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: (utils.lib.eachSystem ["x86_64-linux" ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pypkgs = pkgs.python3Packages;

      requests_mock = pypkgs.buildPythonPackage rec {
        version = "1.10.0";
        pname = "requests-mock";
        src = pypkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-WcnDJBmp+xroPsJC2Y6InEW9fXpl1IN1zCQ+wIRBZYs=";
        };
        doCheck = false;
        buildInputs = with pypkgs; [ pbr requests six ];
        propagatedBuildInputs = buildInputs;
      };

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

     pfhub = pypkgs.buildPythonPackage rec {
       pname = "pfhub";
       version = "0.1";

       src = pkgs.lib.cleanSource ./.;

       propagatedBuildInputs = with pypkgs; [
         numpy
         pytest
         toolz
         pyyaml
         pandas
         plotly
         pytestcov
         jupyter
         nbval
         requests-cache
         scipy
         chevron
         itables
         requests_mock
         chevron
         pkgs.zlib
         pkgs.zip
         pkgs.unzip
      ];

      checkInputs = [
        pypkgs.python
      ];

      checkPhase = ''
        ${pypkgs.python.interpreter} -c "import pfhub; pfhub.test()"
      '';

      pythonImportsCheck = ["pfhub"];

      meta = with pkgs.lib; {
        homepage = "https://github.com/usnistgov/pfhub";
        description = "The Phase Field Community Hub";
        license = licenses.mit;
        maintainers = with maintainers; [ wd15 ];
      };
    };

    extra = with pypkgs; [
      ipython
      ipykernel
      traitlets
      notebook
      widgetsnbextension
      ipywidgets
      scipy
      itables
      papermill
      jupytext
      black
      pylint
      flake8
      (if pkgs.stdenv.isDarwin then pypkgs.jupyter else pypkgs.jupyterlab)
    ];
    pfhubdev = (pfhub.overridePythonAttrs (old: rec {

      propagatedBuildInputs = old.propagatedBuildInputs ++ extra;

      nativeBuildInputs = propagatedBuildInputs;# ++ extra;

      PIP_DISABLE_PIP_VERSION_CHECK = true;

      postShellHook = ''
        SOURCE_DATE_EPOCH=$(date +%s)
        export PYTHONUSERBASE=$PWD/.local
        export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
        export PYTHONPATH=$PYTHONPATH:$USER_SITE:$(pwd)
        export PATH=$PATH:$PYTHONUSERBASE/bin
        export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

        jupyter serverextension enable jupytext
        jupyter nbextension install --py jupytext --user
        jupyter nbextension enable --py jupytext --user

      '';
    }));
  in
    {
      packages.pfhub = pfhubdev;
      packages.default = self.packages.${system}.pfhub;
      devShells.default = pfhubdev;
    }
  ));
}
