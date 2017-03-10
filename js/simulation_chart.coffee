---
---

chart_name="simulations.json"
div_id="#simulation_chart"

on_click = (event, item) ->
  if not item
    return
  if ((item.mark.marktype is 'image') or (item.mark.marktype is 'rect') or (item.mark.marktype is 'text'))
    link = item.mark.group.datum.link
    window.location = "{{ site.baseurl }}/simulations/" + link

make_chart = (chart) ->
  view = chart({el: div_id, renderer: "svg"}).update()
  view.on('click', on_click)

build_chart = (chart_json)->
  parse = (spec_json) ->
    vega.parse.spec(spec_json, make_chart)
    # vega.parse(spec_json, make_chart)

  parse(chart_json)

chart_json = "{{ site.baseurl }}/data/charts/" + chart_name

d3.json(chart_json, build_chart)
