---
---

data_json = {{ site.data.codes | jsonify }}

add_logo = (selection) ->
  subselection = selection.filter((d) -> "logo" of d)
  subselection = subselection.append("img").attr("src", (d) -> d.logo)
  subselection.attr("alt", "").attr("class", "circle logo")

add_fake_logo = (selection) ->
  subselection = selection.filter((d) -> not ("logo" of d))
  subselection = subselection.append("i").attr("class",
    "material-icons circle light-green lighten-1")
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
  p.attr("class", "date")

add_badges = (selection) ->
  subselection = selection.filter((d) -> "badges" of d)
  p = subselection.append("p").attr("class", "badge")
  a = p.selectAll().data((d) -> d.badges).enter().append("a")
  a = a.attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.append("img").attr("src", (d) -> d.src).attr("class", "badge")

add_examples = (selection, key) ->
  subselection = selection.filter((d) -> key of d)
  p = subselection.append("p")
  p.attr("class", "examples")

  set_size = (d) ->
    for k, i in d[key]
      k.last = (d[key].length - 1 == i)
    return d[key]

  span = p.selectAll().data(set_size).enter().append("span")
  a = span.append("a").attr("href", (d) -> d.href)
  a.attr("target", "_blank")
  a.text((d) -> d.name + " ")

  add_separator = (d, i) ->
    if d.last
      return " "
    else
      return "&nbsp;| &nbsp;"

  span_ = span.append("span").html(add_separator)

build_function = (data) ->
  selection = d3.select("#codes").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection = selection.sort()

  add_logo(selection)
  add_fake_logo(selection)
  add_header(selection)
  add_description(selection)
  add_badges(selection)
  add_examples(selection, "examples")
  add_examples(selection, "hackathon")

build_function(data_json)
