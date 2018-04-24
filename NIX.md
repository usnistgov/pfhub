# Install PFHub using Nix

A nix expression to host this website.

## Usage

Follow these [Nix notes](https://github.com/wd15/nixes/NIX-NOTES.md)
for installing Nix. After installing Nix and cloning this repository,
run

    $ nix-shell

in the base directory. At that point, you should be able to run all
the functionality as outlined in the [PFHub `travis.yml`
file](https://github.com/usnistgov/pfhub/blob/master/.travis.yml)
including

    $ jekyll serve

to view the website locally.

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