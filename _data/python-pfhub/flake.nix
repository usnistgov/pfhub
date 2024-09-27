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

      pyother = import ./python-packages.nix { pkgs=pkgs; pypkgs=pypkgs; };

      pfhub = pypkgs.buildPythonPackage rec {
        pname = "pfhub";
        version = "0.1";

        src = pkgs.lib.cleanSource ./.;

        nativeBuildInputs = with pypkgs; [
          pythonRelaxDepsHook
        ];

        PIP_DISABLE_PIP_VERSION_CHECK = true;

        pythonRemoveDeps = [
          "linkml"
        ];

        propagatedBuildInputs = with pypkgs; [
          pythonRelaxDepsHook
          pyother.zenodo_client
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
          pyother.itables
          pyother.requests_mock
          chevron
          pkgs.zlib
          pkgs.zip
          pkgs.unzip
          pyother.dotwiz
          pyother.click_params
          pykwalify
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
        pyother.itables
        papermill
        jupytext
        black
        pylint
        flake8
        twine
        versioneer
        (if pkgs.stdenv.isDarwin then pypkgs.jupyter else pypkgs.jupyterlab)
      ];

      pfhubdev = (pfhub.overridePythonAttrs (old: rec {

        pythonRemoveDeps = [
          "linkml"
        ];

        propagatedBuildInputs = old.propagatedBuildInputs ++ extra ++ [ pypkgs.pythonRelaxDepsHook ];

        nativeBuildInputs = [ pypkgs.pythonRelaxDepsHook ] ++ propagatedBuildInputs;# ++ extra;

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

          pip install linkml==1.5.6 --user --ignore-installed --break-system-packages
        '';
      }));
    in
      {
        packages.pfhub = pfhubdev;
        packages.default = self.packages.${system}.pfhub;
        devShells.default = pfhubdev;
      }
    )
  );
}
