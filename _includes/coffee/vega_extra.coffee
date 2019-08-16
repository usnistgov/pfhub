###
Extra functions to build and parse Vega charts
###


to_app_url = (app_url, url) ->
  app_url + '/get/?url=' + encodeURIComponent(url)


update_vega_data = (axes_names, data) ->
  ### Update chart data depending on name of the data

  Args:
    data: the data to update

  Returns:
    the updated data
  ###
  x = copy_(data)
  axes_data = axes_names.filter((y) -> y.name is x.data[0].name)
  if axes_data.length > 0
    x.axes[0].title = axes_data[0].x_title
    x.axes[1].title = axes_data[0].y_title
    x.scales[0].type = axes_data[0].x_scale
    x.scales[1].type = axes_data[0].y_scale
    if axes_data[0].minimum?
      x.data[0].transform.push(
        {expr:'datum.x > ' + axes_data[0].minimum, type:'filter'}
      )
  x.data[0].name = 'the_data'
  x


combine_vega_data = curry(
  (chart_data, data) ->
    out = copy_(chart_data)
    out.data[0] = copy_(data)
    out
)


vegarize = (chart_data, axes_names) ->
  ### Generate function to combine a Vega plot and its data

  Args:
    chart_data: Vega data for a 1D chart

  Returns:
    a function that takes plot data
  ###
  sequence(
    map(combine_vega_data(chart_data)),
    map((x) -> update_vega_data(axes_names, x))
  )


add_vega_src = (x, appurl) ->
  ### Extract Vega chart as SVG url and set src attribute

  Args:
    x: the img selection to add the Vega src to
  ###
  urlfunc = (d) ->
    (url) -> x.filter((d_) -> d is d_).attr('src', url)

  update_url = (x) ->
    if x.url?
      x.url = to_app_url(appurl, x.url)

  update_urls = (x) -> map(do_(update_url), x.data)

  vega_promise = (d) ->
    new vega.View(vega.parse(d))
      .toImageURL('svg')
      .then(urlfunc(d))

  sequence(
    map(do_(update_urls))
    map(vega_promise)
  )(x.data())


dl_load = (app_url, url) ->
  try
    dl.load({url:to_app_url(app_url, url)})
  catch NetworkError
    []


# read vega data with a url
read_vega_url = curry(
  (app_url, data) ->
    read_vega_url_no_load(dl_load(app_url, data.url), data)
)

transform_expr = (expr) ->
  ### Remove whitespace from spec expression of the form
  "datum.['my value']"" and return as "datum.my_value"
  ####
  sequence(
    (x) -> x.match(/datum\[['|"](.*)['|"]\]/)
    (x) ->
      if x
        'datum.' + x[1].replace(/\s/g, '_')
      else
        expr
  )(expr)


vega_transform = (spec) ->
  ### Turn a vega transform spec into a function

  Args:
    spec: the vega transform spec

  Returns:
    a function that takes vega values
  ###
  underscore = (x) -> x.replace(/\s/g, '_')
  if spec.type is 'formula'
    (values) ->
      f = (datum) ->
        datum[spec.as] = evalexpr.Parser.evaluate(
          transform_expr(spec.expr)
          {datum:modify_keys(underscore, datum)}
        )
        datum
      map(f, values)
  else
    throw error


# read vega data item and apply transforms
read_vega_data_generic = (read_vega_func) ->
  sequence(
    (x) ->
      {
        transforms:map(vega_transform, if x.transform? then x.transform else [])
        values:if x.url? then read_vega_func(x) else x.values
      }
    # coffeelint: disable=no_stand_alone_at
    # coffeelint: disable=missing_fat_arrows
    (x) -> sequence.apply(@, x.transforms.concat(id))(x.values)
    # coffeelint: enable=no_stand_alone_at
    # coffeelint: enable=missing_fat_arrows
  )

read_vega_data = curry(
  (appurl, x) ->
    x.values = read_vega_data_generic(read_vega_url(appurl))(x)
    x
)

# read vega data with a url
read_vega_url_no_load = curry(
  (loaded_values, data) ->
    sequence(
      (x) -> [x.format, loaded_values]
      (x) ->
        try
          dl.read(x[1], x[0])
        catch SyntaxError
          null
    )(data)
)


read_vega_data_no_load = curry(
  (loaded_values, data) ->
    data.values = read_vega_data_generic(
      read_vega_url_no_load(loaded_values)
    )(data)
    data
)
