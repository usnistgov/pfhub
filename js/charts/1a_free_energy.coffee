---
---

parse = (spec_json) ->
  vg.parse.spec(spec_json, (chart) -> chart({el: "#chartxyz", renderer: "svg"}).update())

parse("{{ site.baseurl }}/js/charts/1a_free_energy.json")
