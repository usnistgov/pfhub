---
---

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
  console.log(chart_json)
  parse = (spec_json) ->
    vg.parse.spec(spec_json, make_chart)
  parse(chart_json)

free_energy_json = "{{ site.baseurl }}/data/charts/" + chart_name

d3.json(free_energy_json, build_chart)
