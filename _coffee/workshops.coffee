data_file = "data/workshops.yaml"

add_logo = (selection) ->
  i = selection.append("i").attr("class", "circle light-green lighen-1")
  i.attr("style", "font-style: normal; font-weight: bold; margin-top: 5px;")
  i.text((d) -> d.number)

add_header = (selection) ->
  span = selection.append("span").attr("class", "title")
  a = span.append("a").attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.append("h5").text((d) -> d.name)

add_date = (selection) ->
  p = selection.append("p").attr("style", "font-size: 20px")
  p.text((d) -> d.date)

add_description = (selection) ->
  p = selection.append("p").text((d) -> d.description)
  p.attr("style", "font-size: 20px; padding-top: 10px")

add_links = (selection) ->
  subselection = selection.filter((d) -> "links" of d)
  p = subselection.append("p").attr("style", "padding-top: 10px")
  a = p.selectAll().data((d) -> d.links).enter().append("a")
  a.attr("href", (d) -> d.href)
  a.attr("target", "_blank").attr("style", "padding-right: 10px")
  a.attr("title", "download pdf")
  i = a.append("i").attr("class", "material-icons").text("file_download")

build_function = (data_text) ->
  data = jsyaml.load(data_text)
  selection = d3.select("#workshops").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection.attr("style", "border-color: transparent;
  border-bottom-style: none; margin-bottom: 5px;")
  selection = selection.sort()

  add_logo(selection)
  add_header(selection)
  add_date(selection)
  add_description(selection)
  add_links(selection)

d3.text(data_file, build_function)
