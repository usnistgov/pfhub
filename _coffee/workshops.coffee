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
  p = selection.append("p").html((d) -> d.description)
  p.attr("style", "font-size: 20px; padding-top: 10px")

add_download_attr = (data) ->
  if data.type == "file_download"
    return ""
  else
    return null

add_icon_links = (selection) ->
  subselection = selection.filter((d) -> "icon_links" of d)
  p = subselection.append("p").attr("style", "padding-top: 10px")
  a = p.selectAll().data((d) -> d.icon_links).enter().append("a")
  a.attr("href", (d) -> d.href)
  a.attr("target", "_blank").attr("style", "padding-right: 10px")
  a.attr("title", (d) -> d.name)
  a.append("i").attr("class", "material-icons").text((d) -> d.type)
  a.attr("download", add_download_attr)

add_examples = (selection, key) ->
  subselection = selection.filter((d) -> key of d)
  # h5 = subselection.append("h5")
  # h5.attr("style", "padding-top: 5px; font-size: 18px")
  # h5.text("Examples")
  p = subselection.append("p")
  p.attr("style", "font-size: 15px; padding-top: 10px;")

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
  add_icon_links(selection)
  add_examples(selection, "links")

d3.text(data_file, build_function)
