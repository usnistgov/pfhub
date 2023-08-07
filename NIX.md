# Install PFHub using Nix

## Installation

PFHub is developed using [Nix](https://nixos.org/) and Nix is
recommended for running and using the functionality that PFHub
provides. Nix should be easy to install, but some problems can
occur. Please raise an
[issue](https://github.com/wd15/pfhub/issues/new?assignees=&labels=&projects=&template=blank.md)
if the following isn't clear or you get stuck.

Here are some sites to help with installation.

 - [Official download](https://nixos.org/download.html)
 - [Official documentation](https://nix.dev/tutorials/install-nix)
 - [Tutorial](https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/installation.html)
 - [My own notes if paths are
   missing](https://github.com/wd15/nixes/blob/master/NIX-NOTES.md)
 - [Another tutorial](https://gricad.github.io/calcul/nix/tuto/2017/07/04/nix-tutorial.html#install-nix-single-user-mode)

Once Nix is installed try it out with:

    $ nix-env -i hello
    installing 'hello-2.12.1'
    $ ./hello
    Hello, world!


> **NOTE**
> The [PFHub Dockerfile](./Dockerfile) installs Nix on Ubuntu
> 22.04 so might be a place to consult to get paths and the like setup correctly.
> See the [PFHub Docker usage instructions](./DOCKER.md).


## Flakes

The PFHub Nix expressions use an experimental feature known as flakes,
see the [official flake documentation](https://nixos.wiki/wiki/Flakes).

To enable Nix flakes, add a one liner to either
`~/.config/nix/nix.conf` or `/etc/nix/nix.conf`. The one liner is

```
experimental-features = nix-command flakes
```

If you need more help consult [this
tutorial](https://www.tweag.io/blog/2020-05-25-flakes/).

To test that flakes are working try

    $ nix flake metadata github:usnistgov/pfhub
    Resolved URL:  github:usnistgov/pfhub
    ...
        └───systems: github:nix-systems/default/da67096a3b9bf56a91d16901293e51ba5b49a27e

## Usage

Assuming the above works adequately try

    $ nix develop

in the base of the PFHub working copy and then

    $ jekyll serve

to view the website locally.  At this point, you should be able to run
all the functionality as outlined in the [testing
workflow](.github/workflows/test-jekyll.yml).
`nix develop` drops into a new environment with all the various
packages availabe for running and using PFHub.

> **NOTE**
> The `nix develop` command fails to change the shell prompt to indicate
> that you are now in a Nix environment. To remedy this add the following
> to your `~/.bashrc`.
>
> ```
> show_nix_env() {
>   if [[ -n "$IN_NIX_SHELL" ]]; then
>     echo "(nix)"
>   fi
> }
> export -f show_nix_env
> export PS1="\[\e[1;34m\]\$(show_nix_env)\[\e[m\]"$PS1
> ```

## Using Cachix

The PFHub environment is uploaded as binaries to
[Cachix](https://www.cachix.org/). Using Cachix can speed up the
installation process when first running `nix develop`. To install
Cachix use,

    $ nix-env -iA cachix -f https://cachix.org/api/v1/install

and then

    $ cachix use pfhub
    $ nix develop

to build the environment more rapidly. Note that this only helps on
the first occasion that `nix develop` is executed. `nix develop`
should be near instantaneous on subsequent runs regardless of whether
Cachix is used.

To upload a new PFHub environment to Cachix use

    $ cachix authtoken <TOKEN>  # get from cachix.org
    $ nix develop --profile pfhub-profile -c true
    $ cachix push pfhub pfhub-profile

## Update Flakes

The flake can be updated to have new package versions using first

    $ nix flake lock --update-input pfhub

and then

    $ nix flake update
    $ nix develop

The initial command is required since the base `flake.nix` depends on
`_data/python-pfhub/flake.nix` and issues can occur if the dependency
is not also updated. See [this issue on
GitHub](https://github.com/NixOS/nix/issues/3978#issuecomment-1585001299).

When the flake is updated, a new `flake.lock` file is generated which
must be committed to the repository alongside the `flake.nix`. Note
that the flake files depend on the `nixos-23.05` branch which is only
updated with backports for bug fixes. To update to a newer version of
Nixpkgs then the `flake.nix` file requires editing to point at a later
Nixpkgs version.

> **NOTE**
> Jekyll seems to be broken in Nixpkgs 23.05 so 22.11 is used for only
> thi package. Hence why the flake depends on two versions of Nixpkgs.

## Make a release

The following explains how to release the PFHub package in
`_data/python-pfhub`.

### Test with Mamba

Test with a build system outside of Nix as others are more likely to
use this.

    $ cd _data/python-pfhub
    $ mamba remove -n test-pfhub --all
    $ mamba create -n test-pfhub python=3
    $ mamba activate test-pfhub
    $ python setup.py install

Test the CLI

    $ pfhub

Outside of the working directory

    $ python -c "import pfhub; pfhub.test()"

In the working directory

    $ py.test --nbval-lax --cov-fail-under=100
    $ py.test --nbval-lax ../../results/benchmark*.ipynb

### Update to PyPI test

Upload to the PyPI test repository

    $ nix develop
    $ rm -r dist
    $ python setup.py sdist
    $ twine upload --repository testpypi dist/*

### Test the release

Use mamba to test (or something different from Nix).

Test outside the repository.

    $ cd ~
    $ mamba remove -n test-pfhub --all
    $ mamba create -n test-pfhub python=3
    $ mamba activate test-pfhub
    $ python3 -m pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ pfhub

Test the CLI

    $ pfhub

Run the test

    $ python -c "import pfhub; pfhub.test()"

### Make a full release

    $ nix develop
    $ rm -r dist
    $ python setup.py sdist
    $ twine upload dist/*
