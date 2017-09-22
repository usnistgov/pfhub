---
---

code_upload_json = {{ site.data.charts.code_upload | jsonify }}
benchmark_upload_json = {{ site.data.charts.benchmark_upload | jsonify }}

run = (chart_json, div_id) ->

  build_chart = (chart_json)->
    view = new vega.View(vega.parse(chart_json))
      .initialize(div_id)
      .renderer('svg')
      .hover()
      .run()

  build_chart(chart_json)

run(code_upload_json, "#upload_code_barchart")
run(benchmark_upload_json, "#upload_benchmark_barchart")
