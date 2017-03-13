---
---

run = (chart_name, div_id) ->

  make_chart = (chart) ->
    view = chart({el: div_id, renderer: "svg"}).update()

  build_chart = (chart_json)->
    parse = (spec_json) ->
      vg.parse.spec(spec_json, make_chart)
    parse(chart_json)

  chart_json = "{{ site.baseurl }}/data/charts/" + chart_name
  d3.json(chart_json, build_chart)

run("affiliation_barchart.json", "#affiliation_barchart")
# run("benchmark_upload.json", "#upload_benchmark_barchart")
