---
---

build_chart = (chart_json)->
  console.log(chart_json)
  parse = (spec_json) ->
    vg.parse.spec(spec_json, (chart) -> chart({el: "#free_energy_chart", renderer: "svg"}).update())
  parse(chart_json)

free_energy_json = "{{ site.baseurl }}/data/charts/" + benchmark_id + "_free_energy.json"

d3.json(free_energy_json, build_chart)
