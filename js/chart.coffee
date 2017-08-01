---
---

build_chart = (chart_json, div_id)->
  view = new vega.View(vega.parse(chart_json))
    .initialize(div_id)
    .renderer('svg')
    .hover()
    .run()

console.log(chart_json)
build_chart(chart_json, div_id)
