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
  '';
}
