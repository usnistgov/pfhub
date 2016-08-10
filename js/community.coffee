---
---

data_file = "../data/community.yaml"

converter = new showdown.Converter()

console.log showdown

add_logo = (selection) ->
  subselection = selection.filter((d) -> "image" of d)
  subselection = subselection.append("img").attr("src", (d) -> d.image)
  subselection = subselection.attr("style", "margin-top: 5px;")
  subselection.attr("alt", "").attr("class", "circle")

add_header = (selection) ->
  subselection = selection.filter((d) -> "name" of d)
  subselection = subselection.append("span").attr("class", "name")
  subselection = subselection.append("a").attr("href", (d) -> d.url)
  subselection.attr("target", "_blank")
  subselection.append("h5").text((d) -> d.name)

convert = (text) ->
  converter.makeHtml(text)

add_description = (selection) ->
  subselection = selection.filter((d) -> "description" of d)
  p = subselection.append("p").html((d) -> convert(d.description))
  p.attr("style", "font-size: 20px")

build_function = (data_file) ->
  data = jsyaml.load(data_file)
  selection = d3.select("#community").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection.attr("style", "border-color: transparent;
  border-bottom-style: none; margin-bottom: 5px;")
  selection = selection.sort()
  add_logo(selection)
  add_header(selection)
  add_description(selection)

d3.text(data_file, build_function)
