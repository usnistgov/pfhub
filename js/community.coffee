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

add_icon_links = (selection) ->
  subselection = selection.filter((d) -> "icon_links" of d)
  p = subselection.append("p").attr("style", "padding-top: 10px")
  a = p.selectAll().data((d) -> d.icon_links).enter().append("a")
  a.attr("href", (d) -> d.href)
  a.attr("target", "_blank").attr("style", "padding-right: 10px")
  a.attr("title", (d) -> d.name)
  i = a.append("i")
  i.attr("class", "small material-icons")

  i_filter = i.filter((d) -> d.type == 'email')
  i_filter.text((d) -> d.type)

  i_filter = i.filter((d) -> d.type == 'github')
  img = i_filter.append('img')
  img.attr("style", "width: 28px; height: 28px")
  img.attr("src": "{{ site.baseurl}}/images/github-blue.svg")
  img.attr("alt": "GitHub")

  i_filter = i.filter((d) -> d.type == 'twitter')
  img = i_filter.append('img')
  img.attr("style", "width: 28px; height: 28px")
  img.attr("src", "{{ site.baseurl}}/images/twitter-blue.svg")
  img.attr("alt", "Twitter")


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
  add_icon_links(selection)

d3.text(data_file, build_function)
