---
---

build_chart = (chart_json)->
  console.log(chart_json)
  parse = (spec_json) ->
    vg.parse.spec(spec_json, (chart) -> chart({el: div_id, renderer: "svg"}).update())
  parse(chart_json)

free_energy_json = "{{ site.baseurl }}/data/charts/" + chart_name

d3.json(free_energy_json, build_chart)
