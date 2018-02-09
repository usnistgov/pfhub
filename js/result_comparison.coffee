---
---

{% include coffee/essential.coffee %}

add_chart_name = (item) ->
  $('#chart_' + item.name).html('Chart is' + item.title )

map(add_chart_name, CHART_DATA)
