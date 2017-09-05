###
Extra functions to build and parse Vega charts
###


update_vega_data = (data) ->
  ### Update chart data depending on name of the data

  Args:
    data: the data to update

  Returns:
    the updated data
  ###
  x = copy_(data)
  if x.data[0].name is 'free_energy'
    x.axes[0].title = 'Time'
    x.axes[1].title = 'Free Energy'
    x.scales[0].type = 'log'
    x.scales[1].type = 'log'
    x.data[0].transform.push({expr: 'datum.x > 0.01', type: 'filter'})
  x.data[0].name = 'the_data'
  x


combine_vega_data = curry(
  (chart_data, data) ->
    out = copy_(chart_data)
    out.data[0] = copy_(data)
    out
)


vegarize = (chart_data) ->
  ### Generate function to combine a Vega plot and its data

  Args:
    chart_data: Vega data for a 1D chart

  Returns:
    a function that takes plot data
  ###
  sequence(
    map(combine_vega_data(chart_data)),
    map(update_vega_data)
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


# read vega data with a url
read_vega_url = sequence(
  (x) -> [x.format, dl.load({url: x.url})]
  (x) -> dl.read(x[1], x[0])
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
        datum[spec.as] = evalexpr.Parser.evaluate(spec.expr, {datum: datum})
        datum
      map(f, values)
  else
    throw error


# read vega data item and apply transforms
read_vega_data_ = sequence(
  (x) ->
    {
      transforms: map(vega_transform, if x.transform? then x.transform else [])
      values: if x.url? then read_vega_url(x) else x.values
    }

  (x) -> sequence.apply(@, x.transforms.concat(id))(x.values)
)


read_vega_data = (x) ->
  x.values = read_vega_data_(x)
  x
