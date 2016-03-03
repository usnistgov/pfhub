data_file = "data/codes.json"

add_logo = (selection) ->
  subselection = selection.filter((d) -> "logo" of d)
  subselection = subselection.append("img").attr("src", (d) -> d.logo)
  return subselection.attr("alt", "").attr("class", "circle")

add_fake_logo = (selection) ->
  subselection = selection.filter((d) -> not ("logo" of d))
  subselection = subselection.append("i").attr("class", "material-icons circle")
  return subselection.text("code")

add_header = (selection) ->
  subselection = selection.filter((d) -> "name" of d)
  subselection = subselection.append("span").attr("class", "title")
  return subselection.append("h5").text((d) -> d.name)

add_description = (selection) ->
  subselection = selection.filter((d) -> "description" of d)
  text = (d) ->
    d.description + " written in " + d.language + "."
  return subselection.append("p").text(text)

# add_language = (selection) ->
#   subselection = selection.filter((d) -> "language" of d)
#   return subselection.append("p").text((d) -> "Language: " + d.language)

add_stats = (selection) ->
  subselection = selection.filter((d) -> "stats" of d)
  subselection.append("h5").text("Stats:")
  table = subselection.append("table").attr("class", "indent")
  tr = table.selectAll().data((d) -> d.stats).enter().append("tr")
  tr.append("td").html((d) -> d.name + ":&nbsp;")
  tr.append("td").text((d) -> d.value)

icons =
  GitHub:
    html: '<i class="fa fa-github fa-2x chimad-icon"></i>'
  Home:
    html: '<i class="fa fa-home fa-2x chimad-icon"></i>'
  OpenHub:
    html: '<img src="images/OH_logo-24x24.png" class="icon">'

add_icon = (selection) ->
  subselection = selection.filter((d) -> d.name of icons)
  subselection.attr("href", (d) -> d.url)
  subselection.attr("title", (d) -> d.name)
  subselection.html((d) -> icons[d.name].html)

add_icons = (selection) ->
  subselection = selection.filter((d) -> "links" of d)
  div = subselection.append("div").attr("class", "icons")
  a = div.selectAll().data((d) -> d.links).enter().append("a")
  add_icon(a)

sort_func = (a, b) ->
  return d3.descending(a.stats[0].value, b.stats[0].value)

build_function = (data) ->
  data = data.sort(sort_func)
  selection = d3.select("#codes").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection.attr("style", "border-color: transparent;
  border-bottom-style: none; margin-bottom: 5px;")
  selection = selection.sort()

  add_logo(selection)
  add_fake_logo(selection)
  add_header(selection)
  # add_icons(selection)
  add_description(selection)
  # add_language(selection)
  # add_stats(selection)


d3.json(data_file, build_function)
