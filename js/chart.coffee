---
---

build_chart = (chart_json)->
  view = new vega.View(vega.parse(chart_json))
    .initialize(div_id)
    .renderer('svg')
    .hover()
    .run()

build_chart(chart_json)
