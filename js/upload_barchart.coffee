---
---

run = (chart_name, div_id) ->

  build_chart = (chart_json)->
    view = new vega.View(vega.parse(chart_json))
      .initialize(div_id)
      .renderer('svg')
      .hover()
      .run()

  chart_json = "{{ site.baseurl }}/data/charts/" + chart_name
  d3.json(chart_json, build_chart)

run("code_upload.json", "#upload_code_barchart")
run("benchmark_upload.json", "#upload_benchmark_barchart")
