# Generating the Hexbin

In order to generate the hexbin, you need to run

    $ python hexbin.py

This loads `hexbin.yaml` with the images and links and builds the a
10x10 grid of thumbnail images (`../images/hexbin.jpg`) that can be
used in the display. The `phase_field_hexbin.js` assumes a 10x10 grid
and that code is pretty much taken straight from
http://d3js.org/. `hexbin.py` also dumps `../json/hexbin.json` which
should be read by `phase_field_hexbin.js`, but currently it is just
pasted into the Javascript.