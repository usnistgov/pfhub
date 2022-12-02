# Install PFHub using Nix

A nix expression to host this website. Follow these [Nix
notes](https://github.com/wd15/nixes/blob/master/NIX-NOTES.md) for
installing Nix.

## Usage

After installing Nix and cloning this repository, run

    $ nix-shell

in the base directory. At that point, you should be able to run all
the functionality as outlined in the [PFHub `travis.yml`
file](https://github.com/usnistgov/pfhub/blob/master/.travis.yml)
including

    $ jekyll serve

to view the website locally.

## Usage for OS X

If using OS X run

    $ nix-shell shell-osx.nix

instead. This install does not install Jupyter or Bokeh which are not
essential for running the website. Both of these packages have proved
problematic when installing with Nix on OS X.

## Update Packages

The dependencies are all fixed in the above installation. To update
the Python, Ruby and Javascript dependencies use the following. First
change directory to the `_nix` directory.

### Ruby

Using [Bundix](https://github.com/manveru/bundix).

Update the `Gemfile` if necessary and then

    $ nix-shell -p bundler
    [nix-shell]$ bundler package --no-install --path vendor
    [nix-shell]$ rm -rf .bundler vendor
    [nix-shell]$ exit
    $ $(nix-build '<nixpkgs>' -A bundix)/bin/bundix
    $ rm result

This updates the installed gems.

### Python

Instlal [pypi2nix](https://github.com/garbas/pypi2nix) and then,

    $ pypi2nix -V "3.6" -r requirements.txt

### Javascript

Install [node2nix](https://github.com/svanderburg/node2nix).

    $ nix-env -f '<nixpkgs>' -iA nodePackages.node2nix

Then run

    $ node2nix --input node-packages.json --output node-packages.nix --composition node.nix

Edit `node.nix` and replace `nodejs-4_x` with `nodejs` in the 5th
line.

### Upload Surge to Cachix

    $ nix-env -iA cachix -f https://cachix.org/api/v1/install
    $ cachix authtoken <TOKEN>
    $ nix_build -E '(import ./shell-surge.nix {}).nativeBuildInputs' | cachix push pfhub-surge
