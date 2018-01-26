---
---

data_json = {{ site.data.hexbin | jsonify }}

add_logo = (selection) ->
  subselection = selection.filter((d) -> "image" of d)
  subselection = subselection.append("img").attr("src", (d) -> d.image)
  subselection.attr("alt", "").attr("class", "circle logo")

add_header = (selection) ->
  subselection = selection.filter((d) -> "title" of d)
  subselection = subselection.append("span").attr("class", "title")
  subselection = subselection.append("a").attr("href", (d) -> d.url)
  subselection.attr("target", "_blank")
  subselection.append("h5").text((d) -> d.title)

add_description = (selection) ->
  subselection = selection.filter((d) -> "description" of d)
  p = subselection.append("p").text((d) -> d.description)
  p.attr("class", "description")

build_function = (data) ->
  selection = d3.select("#links").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection = selection.sort()
  add_logo(selection)
  add_header(selection)
  add_description(selection)

build_function(data_json)
