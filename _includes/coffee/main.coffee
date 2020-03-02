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


count_uploads_per = (f) ->
  sequence(
    Object.entries
    filter((x) -> x[1].meta.benchmark.id isnt 'fake')
    groupBy((x) -> f(x[1]))
    Object.entries
    map(
      (x) ->
        {
          count:x[1].length
          name:x[0]
        }
    )
    sortBy((x) -> x.count)
    (x) -> x.reverse()
  )


count_uploads_per_id = count_uploads_per(
  (x) -> x.meta.benchmark.id
)


count_uploads_per_code = count_uploads_per(
  (x) -> x.meta.metadata.implementation.name.toLowerCase()
)


total_uploads = (data) ->
  count_uploads_per((x) -> null)(data)[0].count


make_table_data = sequence(
  Object.entries
  map((x) -> [x[0], x[1].meta])
  filter((x) -> x[1].benchmark.id isnt 'fake')
  map(
    (x) ->
      {
        name:x[0]
        author:
          {
            email:x[1].metadata.author.email
            name:x[1].metadata.author.first + ' ' + x[1].metadata.author.last
          }
        code:
          {
            name:x[1].metadata.implementation.name
            url:x[1].metadata.implementation.repo.url
          }
        cores:x[1].metadata.hardware.cores
        id_:x[1].benchmark.id + '.' + x[1].benchmark.version
        timestamp:to_iso(x[1].metadata.timestamp)
      }
  )
)


to_iso = (x) ->
  (new Date(x)).toISOString().substring(0, 19)


make_anchor_html = (baseurl, heading) ->
  sequence(
    (x) -> heading.trim().replace(/\s+/g, '-').toLowerCase()
    (x) -> """
        <div>
          <a href="#{baseurl}/ABOUT/##{x}"
             class="hoveranchor">
             <i class="material-icons tiny">link</i>
          </a>
        </div>
        <a name=#{x}>
          #{heading}
        </a>
      """
  )


make_form_data = (name, file) ->
  ### Generate form data
  ###
  x = new FormData()
  x.append(name, file)
  x


@send_to_box = (tag, thiss, boxtag) ->
  ### Send file from input element to box and then add link to
  Staticman input value

  Args:
    tag: the tag with the input element with the named value to upload
      to Staticman
    thiss: the file input element
    boxtag: the tag to the box UID input element
  ###
  $('#upload-form-submit').prop('disabled', true)

  fetch(
    '{{ site.links.box_app }}' + '/upload/'
    {
      method:'POST'
      body:make_form_data('fileb', thiss.files[0])
    }
  )
  .then(
    (response) ->
      response.json()
  ).then(
    (data) ->
      $(tag).val(data['download_link'])
      $(boxtag).val(data['folder_name'])
      $('#upload-form-submit').prop('disabled', false)
  ).catch(
    (error) ->
      console.log(error)
      $('#upload-form-submit').prop('disabled', false)
  )


switch_ = (tag1, tag2, attr) ->
  $(tag1).attr(attr, '')
  $(tag2).removeAttr(attr)


@swap = map((x) -> switch_(x[0], x[1], x[2]))
