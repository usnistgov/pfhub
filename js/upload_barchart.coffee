---
---

{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}


vega_chart = (chart_json, div_id) ->
  view = new vega.View(vega.parse(chart_json))
    .initialize(div_id)
    .renderer('svg')
    .hover()
    .run()


make_chart = (chart_json, div_id, values) ->
  vega_chart(
    extend(
      chart_json
      {
        data:[
          {
            name:'code_uploads',
            values:values
          }
        ]
      }
    )
    div_id
  )


DATA = {{ site.data.simulations | jsonify }}


make_chart(
  {{ site.data.charts.benchmark_upload | jsonify }}
  "#upload_benchmark_barchart"
  count_uploads_per_id(DATA)
)


make_chart(
  {{ site.data.charts.code_upload | jsonify }}
  "#upload_code_barchart"
  count_uploads_per_code(DATA)
)


$('#total_uploads').html('Total Uploads: ' + total_uploads(DATA))
