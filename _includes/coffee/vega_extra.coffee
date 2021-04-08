###
Extra functions to build and parse Vega charts
###


to_app_url = (app_url, url) ->
  app_url + '/get/?url=' + encodeURIComponent(url)


dl_load = (app_url, url) ->
  ### First try loading directly and then try using the app as the app
  is much slower.
  ###
  try
    try
      dl.load({url:url})
    catch NetworkError
      dl.load({url:to_app_url(app_url, url)})
  catch NetworkError
    console.log("NetworkError for url: #{url}")
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
      (x) ->
        if x.format.remove_whitespace?
          if x.format.remove_whitespace
            loaded_values = loaded_values.replace(/ /g, '')
        [x.format, loaded_values]
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
