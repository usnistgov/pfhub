### General functions that don't update the DOM

Functions in this file should be used in multiple places
###


fake = ->
  ['example', 'example_minimal', 'test_lander']


count_uploads = (filter_func) ->
  ### Return function to count the number of uploads

  Args:
    filter_func: function to filter the benchmarks

  Returns:
    function to filter the benchmarks
  ###
  sequence(
    (x) -> (v for k, v of x when k not in fake())
    (x) -> x.filter(filter_func)
    (x) -> x.length
  )


count_uploads_num = (benchmark_num, data) ->
  ### Count the number of uploads per benchmark number

  Args:
    benchmark_num: the benchmark number (1, 2, ...)
    data: all the benchmark data

  Returns:
    the number of uploads
  ###
  count_uploads((x) -> x.meta.benchmark.id[0] is "#{benchmark_num}")(data)


count_uploads_id = (benchmark_id, data) ->
  ### Count the number of uploads per benchmark ID

  Args:
    benchmark_num: the benchmark id (1a.1, 1a.0, ...)
    data: all the benchmark data

  Returns:
    the number of uploads
  ###
  build_id = (x) ->
    x.meta.benchmark.id + '.' + x.meta.benchmark.version
  count_uploads((x) -> build_id(x) is "#{benchmark_id}")(data)


make_http = (link) ->
  ### Make full http if local link

  Args:
    link: the link with or without full http

  Returns
    link with full http
  ###
  if 'http' is link.substr(0, 4) then link else "{{ site.baseurl }}/#{link}"


link_html = (link, data) ->
  ### Build an a element for the site

  Args:
    link: the link string
    data: the data string

  Returns
    the HTML
  ###
  target = (link) ->
    if 'http' is link.substr(0, 4) then '_blank' else '_self'
  """
  <a href="#{make_http(link)}" target="#{target(link)}">
  #{data}
  </a>
  """

github_to_raw = (data) ->
  ### Convert a GitHub URL to raw format

  Args:
    data: URL of renderable data on github.com

  Returns:
    URL of raw/downloadable data on githubuserdata.com
  ###
  pattern = ->
    ///
    https?:\/\/              # https or http
    (?:www\.)?github\.com\/  # www.github.com, www optional
    ([a-z0-9_-]{3,39})\/     # capture user name / org
    ([a-z0-9_.-]+)\/         # capture repository
    blob\/
    (.+)                     # capture path
    $///i                    # case insensitive

  sequence(
    (x) -> pattern().exec(x)
    (x) ->
      if x?
        "https://raw.githubusercontent.com/#{x[1]}/#{x[2]}/#{x[3]}"
      else
        data
  )(data)
