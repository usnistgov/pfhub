# Generate a Nix environment for running PFHub.
#
# Consult `NIX.md` for detailed usage
#
# To run use
#
#     $ nix develop
#
# To update use
#
#     $ nix flake lock --update-input pfhub
#     $ nix flake update
#

{
  description = "A website for hosting the phase field benchmarks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs_old.url = "github:nixos/nixpkgs/nixos-22.11";
    utils.url = "github:numtide/flake-utils";
    pfhub.url = "path:./_data/python-pfhub";
  };

  outputs = { self, nixpkgs, nixpkgs_old, utils, pfhub, ... }: (utils.lib.eachSystem ["x86_64-linux" ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs_old = nixpkgs_old.legacyPackages.${system};
      pypkgs = pkgs.python3Packages;
      pfhub_ = pfhub.packages.${system}.pfhub;
      USER = "main";
      REPOPATH = "https://github.com/usnistgov/pfhub";

      pythonEnv = pkgs.python3.buildEnv.override {
        extraLibs = with pypkgs; [
          pfhub_
          jupytext
          papermill
          pypkgs.python
          jupyterlab
          ipython
          notebook
          ipykernel
          pykwalify
        ];
      };

      rubyEnv = pkgs_old.ruby.withPackages (ps: with ps; [pkgs_old.rubyPackages.github-pages ]);

      env = pkgs.mkShell rec {

        packages = [
          pythonEnv
          rubyEnv
          pkgs.nodePackages.surge
        ];

        shellHook = ''

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
      };

      dockerImage = pkgs.dockerTools.buildImage {
        name = "wd15/pfhub";
        tag = "latest";

        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = [
            pythonEnv
            rubyEnv
            pkgs.bash
            pkgs.coreutils
            pkgs.openssh
            pkgs.bashInteractive
            pkgs.git
            pkgs.cacert
            pkgs.nodejs
          ];
          pathsToLink = [ "/bin" ];
        };

        runAsRoot = ''
          #!${pkgs.stdenv.shell}
          ${pkgs.dockerTools.shadowSetup}
          groupadd --system --gid 65543 ${USER}
          useradd --system --uid 65543 --gid 65543 -d / -s /sbin/nologin ${USER}
        '';

        extraCommands = ''
          mkdir -m 1777 ./tmp
          mkdir -m 777 -p ./home/${USER}
        '';

        config = {
          Cmd = [
            "bash"
            "-c"
            "git clone ${REPOPATH}; bash"
          ];
          User = USER;
          Env = [
            "OMPI_MCA_plm_rsh_agent=${pkgs.openssh}/bin/ssh"
            "HOME=/home/${USER}"
            "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          ];
          WorkingDir = "/home/${USER}";
          Expose = {
            "8888/tcp" = {};
          };
        };
      };

    in
      {
        devShells.default = env;
        packages.pfhub = env;
        packages.default = self.packages.${system}.pfhub;
        packages.docker = dockerImage;
      }
  ));
}
