{
  tag ? "22.05"
}:
let
  pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${tag}.tar.gz") {};
  pypkgs = pkgs.python3Packages;
in
  pkgs.mkShell rec {
    pname = "pfhub-surge";
    nativeBuildInputs = with pypkgs; [
      pkgs.rubyPackages.github-pages
      pkgs.nodePackages.surge
      pypkgs.python
    ];
    shellHook = ''
      # export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
      # export OMPI_MCA_plm_rsh_agent=${pkgs.openssh}/bin/ssh

      SOURCE_DATE_EPOCH=$(date +%s)
      export PYTHONUSERBASE=$PWD/.local
      export USER_SITE=`python -c "import site; print(site.USER_SITE)"`
      export PYTHONPATH=$PYTHONPATH:$USER_SITE
      export PATH=$PATH:$PYTHONUSERBASE/bin

    '';
  }
