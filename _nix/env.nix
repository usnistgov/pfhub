{ nixpkgs, extra ? []}:
nixpkgs.stdenv.mkDerivation rec {
  name = "pfhub";
  env = nixpkgs.buildEnv { name=name; paths=buildInputs; };
  buildInputs = ( import ./build.nix { inherit nixpkgs; }) ++ extra;
  src = null;
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export PYTHONUSERBASE=$PWD/.local
    export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
    export PYTHONPATH=$PYTHONPATH:$USER_SITE
    export PATH=$PATH:$PYTHONUSERBASE/bin

    jupyter nbextension install --py widgetsnbextension --user > /dev/null 2>&1
    jupyter nbextension enable widgetsnbextension --user --py > /dev/null 2>&1
    pip install jupyter_contrib_nbextensions --user > /dev/null 2>&1
    jupyter contrib nbextension install --user > /dev/null 2>&1
    jupyter nbextension enable spellchecker/main > /dev/null 2>&1
    jupyter nbextension enable equation-numbering/main > /dev/null 2>&1

    # Bibliography tools
    # see https://jupyter.brynmawr.edu/services/public/dblank/jupyter.cs/Examples/Calico%20Document%20Tools%20and%20Bibtex.ipynb
    # also see
    # https://jupyter.brynmawr.edu/services/public/dblank/Jupyter%20Notebook%20Users%20Manual.ipynb#5.-Bibliographic-Support

    CURDIR=$(pwd)
    MYTMPDIR=$(mktemp -d)
    cd $MYTMPDIR
    # This is my own version as notebook-extensions needed modifications
    # Orignal repo is
    # https://github.com/Calysto/notebook-extensions

    wget https://github.com/wd15/notebook-extensions/archive/master.zip
    unzip master.zip
    # git clone https://github.com/wd15/notebook-extensions.git
    cd notebook-extensions-master

    jupyter nbextension install calysto --user
    jupyter nbextension enable calysto/document-tools/main --user
    cd $CURDIR
    rm -rf $MYTMPDIR

    export LC_ALL=en_US.UTF-8

  '';
}
