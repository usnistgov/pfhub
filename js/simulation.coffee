---
---

###
Build the individual simulation landing pages

Used by _include/simulation.html

Required variables:
  SIM_NAME: the directory name for the simulations from
    _data/simulations/SIM_NAME/meta.yaml
  DATA: the simulation data from the meta.yaml

Required tags:
  #summary
  #author
  #header
  #github_id
  #code
  #table
  #results_table
  #logo_image
  #youtube
  #images
###


select_tag = (data, tag) ->
  ### Select based on tag and bind the data

  Args:
    data: the data to add to the selection
    tag: the tag to select
  ###
  d3.select(tag).selectAll().data(data).enter()


header = (sim_name) ->
  ### Add the header data

  Args:
    sim_name: the name of the simulation
  ###
  select_tag([sim_name], "#header")
    .append("a")
    .attr("href", (d) -> "{{ site.links.simmeta }}" + "/" + d + "/meta.yaml")
    .attr("target", "_blank")
    .text((d) -> d)


author = (data, sim_name) ->
  ### Add the author data

  Args:
    data: the simulation data
    sim_name: the name of the simulation
  ###
  select_tag([[data.metadata, sim_name]], "#author")
    .append("a")
    .attr("href", (d) -> "mailto:" + d[0].email + "?Subject=" + d[1])
    .attr("target", "_top")
    .text((d) -> d[0].author)


summary = (data) ->
  ### Add the summary data

  Args:
    data: the simulation data
  ###
  select_tag([data.metadata.summary], "#summary").append("p").text((d) -> d)


github_icon = () ->
  ### Add the Github badge
  ###
  select_tag(['x'], "#github_id")
    .append("i")
    .attr("class", "material-icons prefix")
    .attr("style", "vertical-align: top; padding-left: 20px; padding-right: 3px")
    .append("img")
    .attr("style", "width: 22px; height: 22px; padding-bottom: 2px")
    .attr("src", "{{ site.baseurl }}" + "/images/github-black.svg")
    .attr("alt", "github")


github_id = (data) ->
  ### Add the Github user name

  Args:
    data: the simulation data
  ###
  select_tag([data.metadata.github_id], "#github_id")
    .append("a")
    .attr("href", (d) -> "https://github.com/" + d)
    .attr("target", "_blank")
    .text((d) -> d)


github = (data) ->
  ### Add the Github badge and user name

  Args:
    data: the simualtion data
  ###
  if data.metadata.github_id isnt ""
    github_icon()
    github_id(data)


user_repo = (url) ->
  ### Construct the username/repo string from a Github URL

  Args:
    url: the Github URL

  Returns:
    the "user/repo" string
  ###
  /https:\/\/.*?\/(.*?)\/(.*?)\/.*/i
    .exec(url + "/a")[1..2]
    .join("/")


code = (data) ->
  ### Add the link to the code repository

  Args:
    data: the simulation data
  ###
  select_tag([data.metadata.implementation.repo.url], "#code")
    .append("a")
    .attr("href", (d) -> d)
    .attr("target", (d) -> "_blank")
    .text((d) -> user_repo(d))


benchmark = (data) ->
  ### Add the benchmark ID

  Args:
    data: the simulation data
  ###
  select_tag([data.benchmark], "#benchmark")
    .append("a")
    .attr("href", (d) -> "{{ site.baseurl }}" + "/benchmarks/benchmark" + d.id[0] + ".ipynb")
    .attr("target", "_blank")
    .text((d) -> d.id + "." + d.version)




to_date = (x) ->
  ### Change a time stamp into a date

  Args:
    x: timestamp with format "Tue Jan 31 21:01:55 EST 2017"

  Returns:
    date with format "Jan 31, 2017"
  ###
  format = (s) ->
    s[4..9] + ", " + s[11..14]
  format(new Date(Date.parse(x)).toString())



date = (data) ->
  ### Add the simulation date

  Args:
    data: the simulation date
  ###
  select_tag([data.metadata.timestamp], "#date")
    .append("span")
    .text((d) -> to_date(d))


get_software = (x) ->
  ### Get the software data that matches x

  Args:
    x: the name of the software to match

  Returns:
    the software data corresponding to x
  ###
  {{ site.data.codes | jsonify }}.filter((y) -> y.name.toLowerCase() is x)[0]


software = (data) ->
  ### Add the software name and link

  Args:
    data: the simulation date
  ###
  select_tag([data.metadata.software.name], "#software")
    .append("a")
    .attr("href", (d) -> get_software(d).home_page)
    .attr("target", "_blank")
    .text((d) -> d)


get_data = (data, name) ->
  ### Get the named data from the simulation data

  Args:
    data: the simulation data
    name: the name of the data

  Returns:
    the named data
  ###
  data.data.filter((x) -> x.name is name)[0]


memory_usage = (data) ->
  ### Get the memory usage for the simulation

  Args:
    data: the simulation data

  Returns:
    the memory usage string
  ###
  format = (x) ->
    x.value + " " + x.unit
  format(get_data(data, "memory_usage").values)


wall_time = (data) ->
  ### Get the simulation wall time

  Args:
    data: the simulation data

  Returns:
    the simulation wall time as a string
  ###
  get_data(data, "run_time").values[..].pop().wall_time + " s"


sim_time = (data) ->
  ### Get the simulation time

  Args:
    data: the simulation data

  Returns:
    the simulation time as a string
  ###
  get_data(data, "run_time").values[..].pop().sim_time + " s"


get_table_data = (data) ->
  ### The data for the results table

  Args:
    data: the simualation data

  Returns:
    data for the results table as a nested array
  ###
  out = [
    ["Memory Usage", memory_usage(data)]
    ["Wall Time", wall_time(data)]
    ["Sim Time", sim_time(data)]
    ["Cores", "53"]
  ]


results_table = (data) ->
  ### Create the results table

  Args:
    data: the simulation data
  ###
  select_tag(get_table_data(data), "#results_table")
    .append("tr")
    .append("td")
    .text((d) -> d[0])
    .select(() -> this.parentNode)
    .append("td")
    .text((d) -> d[1])


get_data_by_type = (data, type) ->
  data.data.filter((x) -> x.type is type)


# card_image_ = (selection) ->
#   selection.append("img")
#     .attr("class", "materialboxed responsive-img")
#     .attr("src", (d) -> d.url)

# card = (selection, f) ->
#   div1 = selection.append("div")
#   div1.attr("class", "card small")
#   div2 = div1.append("div")
#   div2.attr("class", "card-image")
#   div2.attr("style", "max-height: 70%")
#   img = div2.append("img")
#   img.attr("class", "materialboxed responsive-img")
#   img.attr("src", (d) -> d.url)
#   div3 = div1.append("span")
#   div3.attr("class", "card-content")
#   p = div3.append("p")
#   p.text((d) -> d.description)

logo_image = (data) ->
  card_image(select_tag([get_data_by_type(data, "image")[0]], "#logo_image"))


  # images = [get_data_by_type(data, "image")[0]]
  # selection = d3.select("#logo_image").selectAll().data(images).enter()
  # card_image(selection)


card_image = (selection) ->
  div1 = selection.append("div")
  div1.attr("class", "card small")
  div2 = div1.append("div")
  div2.attr("class", "card-image")
  div2.attr("style", "max-height: 70%")
  img = div2.append("img")
  img.attr("class", "materialboxed responsive-img")
  img.attr("src", (d) -> d.url)
  div3 = div1.append("span")
  div3.attr("class", "card-content")
  p = div3.append("p")
  p.text((d) -> d.description)


youtube_card = (data) ->
  data_ = get_data_by_type(data, "youtube")[0]
  selection = d3.select("#youtube").selectAll().data([data_]).enter()

  div0 = selection.append("div")
  div0.attr("class", "card small")

  div1 = div0.append("div")
  div1.attr("class", "card-image")
  div1.attr("style", "max-height: 70%")

  div2 = div1.append("div")
  div2.attr("class", "video-container")

  iframe = div2.append("iframe")
  iframe.attr("frameborder", 0)
  iframe.attr("allowfullscreen")
  iframe.attr("src", (d) -> d.url)

  span = div0.append("span")
  span.attr("class", "card-content")
  p = span.append("p")
  p.text((d) -> d.description)


card_images = (data) ->
  images = get_data_by_type(data, "image")
  selection = d3.select("#images").selectAll().data(images).enter()
  div0 = selection.append("div")
  div0.attr("class", "col s4")
  card_image(div0)


add_data_to_chart = (data, chart_json) ->
  if data.name = "free_energy"
    chart_json.axes[1].title = "Free Energy"
    chart_json.axes[0].title = "Time"
    chart_json.scales[0].type = "log"
    chart_json.scales[1].type = "log"
  chart_json['data'].push(data)
  chart_json['data'][0]['name'] = "the_data"
  delete chart_json['data'][0].type
  return chart_json


add_chart = (chart_json) ->
  selection = d3.select("#images").selectAll().data([chart_json]).enter()

  div = selection.append("div")
  div.attr("class", "col s4")

  div1 = div.append("div")
  div1.attr("class", "card small")

  div2 = div1.append("div")
  div2.attr("class", "card-image")
  div2.attr("style", "max-height: 70%")
  img = div2.append("img")
  img.attr("class", "materialboxed responsive-img")
  img.attr("id", "chart")
  img.attr("style", "background-color: white;")

  div3 = div1.append("span")
  div3.attr("class", "card-content")

  p = div3.append("p")
  p.text((d) -> "My Graph")

  width = img.node().getBoundingClientRect().width
  height = img.node().getBoundingClientRect().width

  view = new vega.View(vega.parse(chart_json))
  prom = view.toImageURL('svg')
  prom.then((url) -> img.attr("src", url))


header(SIM_NAME)
author(DATA, SIM_NAME)
summary(DATA)
github(DATA)
code(DATA)
benchmark(DATA)
date(DATA)
software(DATA)
results_table(DATA)

logo_image(DATA)
youtube_card(DATA)
card_images(DATA)

line_data = (d for d in DATA.data when d.type == "line")
for datum in line_data
  chart_json = {{ site.data.charts | jsonify }}['plot1d']
  chart_json = add_data_to_chart(datum, chart_json)
  add_chart(chart_json)
