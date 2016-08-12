---
---

converter = new showdown.Converter()

valid_item = (d, s) ->
  return s of d and d[s] != ""

add_logo = (selection) ->
  subselection = selection.filter((d) -> valid_item(d, "image"))
  subselection = subselection.append("img").attr("src", (d) -> d.image)
  subselection = subselection.attr("style", "margin-top: 5px;")
  subselection.attr("alt", "").attr("class", "circle")

add_fake_logo = (selection) ->
  subselection = selection.filter((d) -> not valid_item(d, "image"))
  subselection = subselection.append("i").attr("class",
    "material-icons circle light-green lighen-1")
  subselection.attr("style", "font-size: 23px;").attr("style", "margin-top: 5px")
  subselection.text("person")

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

add_icon_links = (selection) ->
  subselection = selection.filter((d) -> "icon_links" of d)
  p = subselection.append("p").attr("style", "padding-top: 10px")
  a = p.selectAll().data((d) -> d.icon_links).enter().append("a")
  a.attr("href", (d) -> d.href)
  a.attr("target", "_blank").attr("style", "padding-right: 10px")
  a.attr("title", (d) -> d.name)
  i = a.append("i")
  i.attr("class", "small material-icons")

  i_filter = i.filter((d) -> d.name == 'email')
  i_filter.text((d) -> d.name)

  i_filter = i.filter((d) -> d.name == 'github')
  img = i_filter.append('img')
  img.attr("style", "width: 28px; height: 28px")
  img.attr("src": "{{ site.baseurl}}/images/github-blue.svg")
  img.attr("alt": "GitHub")

  i_filter = i.filter((d) -> d.name == 'twitter')
  img = i_filter.append('img')
  img.attr("style", "width: 28px; height: 28px")
  img.attr("src", "{{ site.baseurl}}/images/twitter-blue.svg")
  img.attr("alt", "Twitter")

key_map = (item) ->
  raw_links =
    "email" : [item["Email"], "mailto:" + item["Email"]]
    "twitter" : [item["Twitter Handle"], "https://twitter.com/" + item["Twitter Handle"]]
    "github" : [item["GitHub Handle"], "https://github.com/" + item["GitHub Handle"]]

  icon_links = ({"name" : key, "href" : value[1]} for key, value of raw_links when value[0] != "")

  console.log(icon_links)

  mapped_item =
    "name" : item["Name"],
    "description" : item["Bio (one or two sentences)"],
    "icon_links" : icon_links
    "url" : item["Home Page"]
    "image" : item["Image URL"]

  return mapped_item

build_function = (data_in) ->
  data = (key_map(item) for item in data_in)
  selection = d3.select("#community").selectAll()
  .data(data).enter()
  .append("li").attr("class", "collection-item avatar light-green lighten-4")
  selection.attr("style", "border-color: transparent;
  border-bottom-style: none; margin-bottom: 5px;")
  selection = selection.sort()
  add_logo(selection)
  add_fake_logo(selection)
  add_header(selection)
  add_description(selection)
  add_icon_links(selection)


get_spreadsheet_data = ->
  URL = "{{ site.links.members }}"
  Tabletop.init({key: URL, callback: build_function, simpleSheet: true})

document.addEventListener("DOMContentLoaded", get_spreadsheet_data)
