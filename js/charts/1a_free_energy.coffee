---
---

build_chart = (chart_yaml)->
  chart_json = jsyaml.load(chart_yaml)
  console.log(chart_json)
  parse = (spec_json) ->
    vg.parse.spec(spec_json, (chart) -> chart({el: "#chartxyz", renderer: "svg"}).update())
  parse(chart_json)

d3.text("{{ site.baseurl }}/js/charts/1a_free_energy.yaml", build_chart)
