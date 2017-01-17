---
---

chart_name = "benchmark_upload.json"
div_id = "#upload_benchmark_barchart"

make_chart = (chart) ->
  view = chart({el: div_id, renderer: "svg"}).update()

build_chart = (chart_json)->
  console.log(chart_json)
  parse = (spec_json) ->
    vg.parse.spec(spec_json, make_chart)
  parse(chart_json)

chart_json = "{{ site.baseurl }}/data/charts/" + chart_name

d3.json(chart_json, build_chart)
