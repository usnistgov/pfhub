data_file = "data/codes.yaml"

add_logo = (selection) ->
  subselection = selection.filter((d) -> "logo" of d)
  subselection = subselection.append("img").attr("src", (d) -> d.logo)
  subselection = subselection.attr("style", "margin-top: 5px;")
  subselection.attr("alt", "").attr("class", "circle")

add_fake_logo = (selection) ->
  subselection = selection.filter((d) -> not ("logo" of d))
  subselection = subselection.append("i").attr("class",
    "material-icons circle light-green lighen-1")
  subselection.attr("style", "font-size: 23px;").attr("style", "margin-top: 5px")
  subselection.text("code")

add_header = (selection) ->
  subselection = selection.filter((d) -> "name" of d)
  subselection = subselection.append("span").attr("class", "title")
  subselection = subselection.append("a").attr("href", (d) -> d.home_page)
  subselection.attr("target", "_blank")
  subselection.append("h5").text((d) -> d.name)

add_description = (selection) ->
  subselection = selection.filter((d) -> "description" of d)
  p = subselection.append("p").text((d) -> d.description)
  p.attr("style", "font-size: 20px")

add_badges = (selection) ->
  subselection = selection.filter((d) -> "badges" of d)
  p = subselection.append("p").attr("style", "padding-top: 15px")
  a = p.selectAll().data((d) -> d.badges).enter().append("a")
  a = a.attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.append("img").attr("src", (d) -> d.src).attr("style", "max-width:
  100%; padding-right: 10px")

add_examples = (selection) ->
  subselection = selection.filter((d) -> "examples" of d)
  p = subselection.append("p")
  p.attr("style", "padding-top: 10px; font-size: 15px")

  set_size = (d) ->
    for example, i in d.examples
      example.last = (d.examples.length - 1 == i)
    return d.examples

  span = p.selectAll().data(set_size).enter().append("span")
  a = span.append("a").attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.text((d) -> d.name)

  add_separator = (d, i) ->
    if d.last
      return ""
    else
      return "&nbsp;&nbsp;|&nbsp;&nbsp;"

  span_ = span.append("span").html(add_separator)

build_function = (data_text) ->
  data = jsyaml.load(data_text)
  selection = d3.select("#codes").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection.attr("style", "border-color: transparent;
  border-bottom-style: none; margin-bottom: 5px;")
  selection = selection.sort()

  add_logo(selection)
  add_fake_logo(selection)
  add_header(selection)
  add_description(selection)
  add_badges(selection)
  add_examples(selection)

d3.text(data_file, build_function)
