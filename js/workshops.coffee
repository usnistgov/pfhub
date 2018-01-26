---
title: check
---

data_json = {{ site.data.workshops | jsonify }}

add_logo = (selection) ->
  i = selection.append("i").attr("class", "circle light-green lighten-1")
  i.text((d) -> d.number)

add_header = (selection) ->
  span = selection.append("span").attr("class", "title")
  a = span.append("a").attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.append("h5").text((d) -> d.name)

add_date = (selection) ->
  p = selection.append("p").attr("class", "date")
  p.text((d) -> d.date)

add_description = (selection) ->
  p = selection.append("p").html((d) -> d.description)
  p.attr("class", "description")

add_download_attr = (data) ->
  if data.type == "file_download"
    return ""
  else
    return null

add_icon_links = (selection) ->
  subselection = selection.filter((d) -> "icon_links" of d)
  p = subselection.append("p").attr("class", "icons")
  a = p.selectAll().data((d) -> d.icon_links).enter().append("a")
  a.attr("href", (d) -> d.href)
  a.attr("target", "_blank").attr("class", "icons")
  a.attr("title", (d) -> d.name)
  a.append("i").attr("class", "material-icons").text((d) -> d.type)
  a.attr("download", add_download_attr)

add_examples = (selection, key) ->
  subselection = selection.filter((d) -> key of d)
  p = subselection.append("p").attr("class", "examples")

  set_size = (d) ->
    for k, i in d[key]
      k.last = (d[key].length - 1 == i)
    return d[key]

  span = p.selectAll().data(set_size).enter().append("span")
  a = span.append("a").attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.text((d) -> d.name + " ")
  a.attr("download", add_download_attr)

  add_separator = (d, i) ->
    if d.last
      return " "
    else
      return "&nbsp;| &nbsp;"

  span_ = span.append("span").html(add_separator)

build_function = (data) ->
  selection = d3.select("#workshops").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection = selection.sort()

  add_logo(selection)
  add_header(selection)
  add_date(selection)
  add_description(selection)
  add_icon_links(selection)
  add_examples(selection, "links")

build_function(data_json)
