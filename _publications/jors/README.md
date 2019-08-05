# Build

Run

    $ make

to build the paper and then view `build/paper.pdf`.

## Build the Dependency Tree

This is actually quite difficult without a Nix expression that can be
instantiated. The Nix expression for PFHub only works with nix-shell,
so, to get the deriviation use (run in the base PFHub directory, not
this one),

    $ nix-shell -vv --pure --command exit 2>&1 | grep pfhub.drv

This returns the path to two derivations. Try them both. One
derivation has the full dependencies, the other is just a single
node. Choose one and use it in.

    $ nix-store -q --graph \
      $(nix-store --realise \
      /nix/store/bhlckaq06arbwij8i45wr7i96qz5yhss-user-environment.drv) \
      | sed '2 i\ratio=1;margin=0;' \
      | dot -T svg -o out.svg

    $ nix-store -q --graph $(nix-store --realise /nix/store/bhlckaq06arbwij8i45wr7i96qz5yhss-user-environment.drv) | dot -T svg -o out.svg

The only way I can view the SVG is in the browser. Currently this
can't be used in the paper has I can't figure out how to modifiy it to
just have the first level of dependencies.
