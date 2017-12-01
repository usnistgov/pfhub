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


select_tag = (tag) ->
  ### Select based on tag and bind the data

  Args:
    data: the data to add to the selection
    tag: the tag to select
  ###
  (x) -> d3.select(tag).selectAll().data(x).enter()


header = (sim_name) ->
  ### Add the header data

  Args:
    sim_name: the name of the simulation
  ###
  select_tag('#header')([sim_name])
    .append('a')
    .attr('href', (d) -> '{{ site.links.simmeta }}' + '/' + d + '/meta.yaml')
    .attr('target', '_blank')
    .text((d) -> d)


author = (data) ->
  ### Add the author data

  Args:
    data: the simulation data
  ###
  select_tag('#author')([data.metadata])
    .append('a')
    .attr('href', (d) -> 'mailto:' + d.email)
    .attr('target', 'blank_')
    .text((d) -> d.author.first + ' ' + d.author.last)


author_icon = (data) ->
  select_tag('#author')([data.metadata.github_id])
    .append('img')
    .attr('src', (d) -> 'https://github.com/' + d + '.png')
    .attr('alt', '')


summary = (data) ->
  ### Add the summary data

  Args:
    data: the simulation data
  ###
  select_tag('#summary')([data.metadata.summary]).append('p').text((d) -> d)


github_icon = ->
  ### Add the Github badge
  ###
  select_tag('#github_id')(['x'])
    .append('img')
    .attr('src', '{{ site.baseurl }}' + '/images/github-black.svg')
    .attr('alt', '')


github_id = (data) ->
  ### Add the Github user name

  Args:
    data: the simulation data
  ###
  select_tag('#github_id')([data.metadata.github_id])
    .append('a')
    .attr('href', (d) -> 'https://github.com/' + d)
    .attr('target', '_blank')
    .text((d) -> d)


github = (data) ->
  ### Add the Github badge and user name

  Args:
    data: the simualtion data
  ###
  if data.metadata.github_id isnt ''
    github_icon()
    github_id(data)


user_repo = (url) ->
  ### Construct the username/repo string from a Github URL

  Args:
    url: the Github URL

  Returns:
    the 'user/repo' string
  ###
  /https:\/\/.*?\/(.*?)\/(.*?)\/.*/i
    .exec(url + '/a')[1..2]
    .join('/')


code = (data) ->
  ### Add the link to the code repository

  Args:
    data: the simulation data
  ###
  select_tag('#code')([data.metadata.implementation.repo.url])
    .append('a')
    .attr('href', (d) -> d)
    .attr('target', (d) -> '_blank')
    .text((d) -> user_repo(d))


benchmark = (data) ->
  ### Add the benchmark ID

  Args:
    data: the simulation data
  ###
  select_tag('#benchmark')([data.benchmark])
    .append('a')
    .attr('href',
          (d) ->
            '{{ site.baseurl }}' + '/benchmarks/benchmark' + d.id[0] + '.ipynb')
    .text((d) -> d.id + '.' + d.version)


to_date = (x) ->
  ### Change a time stamp into a date

  Args:
    x: timestamp with format 'Tue Jan 31 21:01:55 EST 2017'

  Returns:
    date with format 'Jan 31, 2017'
  ###
  format = (s) ->
    s[4..9] + ', ' + s[11..14]
  format(new Date(Date.parse(x)).toString())


date = (data) ->
  ### Add the simulation date

  Args:
    data: the simulation date
  ###
  select_tag('#date')([data.metadata.timestamp])
    .append('span')
    .text((d) -> to_date(d))


get_software = (x, codes_data) ->
  ### Get the software data that matches x

  Args:
    x: the name of the software to match
    codes_data: data about the possible codes

  Returns:
    the software data corresponding to x
  ###
  codes_data.filter((y) -> y.name.toLowerCase().includes(x))[0]


software = (data, codes_data) ->
  ### Add the software name and link

  Args:
    data: the simulation date
    codes_data: data about the possible codes
  ###
  select_tag('#software')([data.metadata.software.name])
    .append('a')
    .attr('href', (d) -> get_software(d, codes_data).home_page)
    .attr('target', '_blank')
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

  See https://stackoverflow.com/questions/
              10420352/converting-file-size-in-bytes-to-human-readable
  ###
  to_bytes = (value, unit) ->
    Math.pow(1024, 'BKMGTPEZY'.indexOf(unit[0].toUpperCase())) * value

  make_unit = (x) -> if x is 0 then 'bytes' else ('KMGTPEZY'[x - 1] + 'B')

  to_human = sequence(
    (x) -> [x, Math.log(x) / Math.log(1024) | 0]
    (x) -> [(x[0] / Math.pow(1024, x[1])).toFixed(1), x[1]]
    (x) -> x[0] + ' ' + make_unit(x[1])
  )

  format = sequence(
    (x) -> to_bytes(x.value, x.unit)
    to_human
  )

  format(get_data(data, 'memory_usage').values[0])


to_human_time = sequence(
  (x) -> moment.duration(x * 1000)
  (x) -> moment.preciseDiff(moment(), moment().add(x))
  (x) -> x.split(' ')[..3].join(' ')
)


metric_prefix = sequence(
  (x) -> parseFloat(x) * 1e9
  (x) -> [x, Math.log(x) / Math.log(1000) | 0]
  (x) -> [(x[0] / Math.pow(1000, x[1])).toFixed(0), x[1]]
  (x) -> x[0] + 'nµm kMGTPE'[x[1]]
)


get_table_data = (data) ->
  ### The data for the results table

  Args:
    data: the simualation data

  Returns:
    data for the results table as a nested array
  ###
  get_times = (data) -> get_data(data, 'run_time').values[..].pop()
  return [
    ['Memory Usage', memory_usage(data)]
    ['Wall Clock Time', to_human_time(get_times(data).wall_time)]
    ['Simulation Time', (metric_prefix(get_times(data).sim_time) + ' seconds')]
    ['Cores', data.metadata.hardware.cores]
  ]


results_table = (data) ->
  ### Create the results table

  Args:
    data: the simulation data
  ###
  select_tag('#results_table')(get_table_data(data))
    .append('tr')
    .append('td')
    .text((d) -> d[0])
    # coffeelint: disable=missing_fat_arrows
    .select(-> @.parentNode)
    # coffeelint: enable=missing_fat_arrows
    .append('td')
    .text((d) -> d[1])


add_card_image = (x) ->
  ### Add a card-image div

  Args:
    x: the current selection

  Returns:
    the div selection
  ###
  x.append('div')
    .attr('class', 'card-image')


add_card_image_ = (x) ->
  add_card_image(x)
    .append('img')
    .attr('class', 'materialboxed responsive-img')
    .attr('data-caption', (d) -> d.description)


add_image = (x) ->
  ### Add a responsive image

  Args:
    x: the current selection

  Returns:
    the img selection
  ###
  add_card_image_(x).attr('src', (d) -> d.url)


add_youtube = (x) ->
  ### Add a youtube container

  Args:
    x: the current selection

  Returns:
    the iframe selection
  ###
  add_card_image(x)
    .append('div')
    .attr('class', 'video-container')
    .append('iframe')
    .attr('frameborder', 0)
    .attr('allowfullscreen', '')
    .attr('src', (d) -> d.url)


add_description = sequence(
  (x) ->
    x.append('div')
      .attr('class', 'card-content scroll')
  (x) ->
    x.append('p')
      .text((d) ->
        if d.description? then d.description else d.data[0].description)
)


build_card = (addf) ->
  ### Make a card given a selection

  Args:
    addf: the content of the card

  Returns:
    a function for building a card
  ###
  sequence(
    (x) ->
      x.append('div')
        .attr('class', 'card small light-green lighten-4')
    do_(addf)
    add_description
  )


add_card = (addf, tag, with_div = id) ->
  ### Constuct a data card

  Args:
    addf: the content of the card
    tag: the tag element to append to
    with_div: function to add an extra div for columns
    take_func: data preprocessing function before bind

  Returns:
    a function to build the card
  ###
  sequence(
    select_tag(tag)
    with_div
    build_card(addf)
  )


add_plotly_src = (x) ->
  ### Attach plotly chart as an svg to an img element

  Args:
    x: the img selection to add the plotly src to
  ###
  urlfunc = curry(
    (gd, data, url) ->
      x.filter((data_) -> data is data_).attr('src', url)
      Plotly.toImage(gd)
  )

  layout = {
    margin:{
      l:50,
      r:70,
      b:120,
      t:40,
      pad:5
    }
    title:false
  }

  plotly_promise = (data, div) ->
    Plotly.newPlot(div, data.plotly, layout)
      .then(
        (gd) ->
          Plotly.toImage(gd, {height:400, width:400})
            .then(urlfunc(gd, data))
      )

  x.data().forEach((d, i) ->
    plotly_promise(d, 'plotly_div_' + i)
  )

add_chart = curry(
  (add_src, x) ->
    ### Build a div for a card with a Vega chart

    Args:
      x: the selection
      add_src: function to add the src for the img tag
    ###
    add_src(add_card_image_(x))
)


add_vega = add_chart(add_vega_src)
add_plotly = add_chart(add_plotly_src)


ploterize = (data) ->
  data.plotly = [{
    x:(xx.x for xx in data.values)
    y:(xx.y for xx in data.values)
    z:(xx.z for xx in data.values)
    type:'contour'
  }]
  return data


build = (data, sim_name, codes_data, chart_data) ->
  ### Build the simulation landing page

  Args:
    data: the metadata for the simulation
    sim_name: the name of the simulation
    codes_data: data about the possible codes
    chart_data: Vega data for 1D charts
  ###
  header(sim_name)
  author_icon(data)
  author(data, sim_name)
  summary(data)
  github(data)
  code(data)
  benchmark(data)
  date(data)
  software(data, codes_data)
  results_table(data)

  result_data = groupBy(((x) -> x.type), data.data)
  vega_data = vegarize(chart_data)(result_data.line)

  if result_data.image?
    add_card(add_image, '#logo_image', with_div = id)(result_data.image[0..0])
    result_data.image = result_data.image[1..]
  else if vega_data.length > 0
    add_card(add_vega, '#logo_image', with_div = id)(vega_data[0..0])
    vega_data = vega_data[1..]

  with_div = (x) -> x.append('div').attr('class', 'col s12 m12 l6 xl4')

  if result_data.image?
    add_card(add_image, '#images', with_div = with_div)(result_data.image)
  add_card(add_vega, '#images', with_div = with_div)(vega_data)

  if result_data.youtube?
    add_card(add_youtube, '#youtube', with_div = id)(result_data.youtube[0..0])

  if result_data.contour?
    with_div = (x) -> x.append('div').attr('class', 'col s12 m12 l6 xl4')
    contour_data = map(read_vega_data, result_data.contour)
    plotly_data = map(ploterize, contour_data)
    add_card(add_plotly, '#images', with_div = with_div)(plotly_data)
