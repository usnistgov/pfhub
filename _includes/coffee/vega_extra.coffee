###
Extra functions to build and parse Vega charts
###


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


add_vega_src = (x) ->
  ### Extract Vega chart as SVG url and set src attribute

  Args:
    x: the img selection to add the Vega src to
  ###
  urlfunc = (d) ->
    (url) -> x.filter((d_) -> d is d_).attr('src', url)

  vega_promise = (d) ->
    new vega.View(vega.parse(d))
      .toImageURL('svg')
      .then(urlfunc(d))

  map(vega_promise, x.data())


dl_load = (url) ->
  try
    dl.load({url:url})
  catch NetworkError
    console.log('NetworkError')
    console.log('URL:', url)
    []


# read vega data with a url
read_vega_url = sequence(
  (x) -> [x.format, dl_load(x.url)]
  (x) ->
    try
      dl.read(x[1], x[0])
    catch SyntaxError
      console.log('unable to read vega data')
      console.log('data:', x)
      null
)


vega_transform = (spec) ->
  ### Turn a vega transform spec into a function

  Args:
    spec: the vega transform spec

  Returns:
    a function that takes vega values
  ###
  if spec.type is 'formula'
    (values) ->
      f = (datum) ->
        datum[spec.as] = evalexpr.Parser.evaluate(spec.expr, {datum:datum})
        datum
      map(f, values)
  else
    throw error


# read vega data item and apply transforms
read_vega_data_ = sequence(
  (x) ->
    {
      transforms:map(vega_transform, if x.transform? then x.transform else [])
      values:if x.url? then read_vega_url(x) else x.values
    }

  # coffeelint: disable=no_stand_alone_at
  # coffeelint: disable=missing_fat_arrows
  (x) -> sequence.apply(@, x.transforms.concat(id))(x.values)
  # coffeelint: enable=no_stand_alone_at
  # coffeelint: enable=missing_fat_arrows
)


read_vega_data = (x) ->
  x.values = read_vega_data_(x)
  x
