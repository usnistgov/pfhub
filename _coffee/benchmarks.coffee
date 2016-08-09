data_file = "data/benchmarks.yaml"

add_logo = (selection) ->
  subselection = selection.filter((d) -> "image" of d)
  subselection = subselection.append("img").attr("src", (d) -> d.image)
  subselection = subselection.attr("style", "margin-top: 5px;")
  subselection.attr("alt", "").attr("class", "circle")

add_header = (selection) ->
  subselection = selection.filter((d) -> "title" of d)
  subselection = subselection.append("span").attr("class", "title")
  subselection = subselection.append("a").attr("href", (d) -> d.url)
  subselection.attr("target", "_blank")
  subselection.append("h5").text((d) -> d.title)

add_description = (selection) ->
  subselection = selection.filter((d) -> "description" of d)
  p = subselection.append("p").text((d) -> d.description)
  p.attr("style", "font-size: 20px")

build_function = (data_file) ->
  data = jsyaml.load(data_file)
  selection = d3.select("#benchmarks").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection.attr("style", "border-color: transparent;
  border-bottom-style: none; margin-bottom: 5px;")
  selection = selection.sort()
  add_logo(selection)
  add_header(selection)
  add_description(selection)

d3.text(data_file, build_function)
