###
Functions to generate the comparison pages
###

get_plotly_data = curry(
  (appurl, data, chart_item) ->
    ### Given a set of simulations, extract a Plotly plot for each set
    of chart data

    Args:
      data: the simulation data
      chart_item: an element of the chart data

    Returns:
      the Plotly data for the given chart item
    ###
    if chart_item.type is 'scatter'
      get_scatter_data(data, chart_item)
    else if chart_item.type is 'table'
      get_table_data(appurl, data, chart_item)
    else
      throw new Error('chart_item has wrong type')
)


get_scatter_data = (data, chart_item) ->
  ### Construct Plotly YAML for a scatter chart

  Args:
    data: the simulation data
    chart_item: an element of the chart data

  Returns:
    the Plotly YAML for a scatter chart
  ###
  {
    data:get_comparison_data(vega_to_plotly, chart_item, data)
    div:'chart_' + chart_item.name
    layout:
      {
        title:chart_item.title
        showlegend:true
        autosize:true
        xaxis:
          {
            title:chart_item.x_title
            type:chart_item.x_scale
            domain:chart_item.x_domain
            range:chart_item.x_range
            scaleanchor:chart_item.x_scaleanchor
            exponentformat:'E'
            dtick:chart_item.x_dtick
          }
        yaxis:
          {
            scaleanchor:chart_item.y_scaleanchor
            title:chart_item.y_title
            type:chart_item.y_scale
            domain:chart_item.y_domain
            exponentformat:'E'
            dtick:chart_item.y_dtick
          }
      }
  }


get_table_data = (appurl, data, chart_item) ->
  ### Construct the Plotly YAML for a table

  Args:
    data: the simulation data
    chart_item: an element of the chart data

  Returns:
    the Plotly YAML for a table

  ###
  {
    data:[get_table_data_(appurl, chart_item, data)]
    div:'chart_' + chart_item.name
    layout:{
      title:chart_item.title
      font:{
        family:'Lato'
      }
    }
  }


get_table_data_ = (appurl, chart_item, data) ->
  ### Construct the Plotly YAML for the data key in the Plotly YAML
  for a table

  Args:
    chart_item: an element of the chart data
    data: the simulation data

  Returns:

  ###
  get_color = (x, i) ->
    if i %% 2 is 1
      'white'
    else
      '#d1d1d1'

  get_align = (x, i) ->
    if i is 0
      'left'
    else
      'center'

  sequence(
    get_table_values(appurl, chart_item)
    (x) ->
      {
        header:{
          values:chart_item.column_titles
          align:'center'
          line:{width:0, color:'black'}
        }
        cells:{
          values:x
          align:map(get_align, chart_item.column_titles)
          line:{color:'black', width:0},
          font:{family:'Lato', size:12, color:'black'}
          fill:{color:[map(get_color, x[0])]}
          format:chart_item.column_format
        }
        type:'table'
      }
  )(data)


get_table_values = (appurl, chart_item) ->
  ### Return a function to extract the data for a Plotly table

  Args:
    chart_item: an element of the chart data

  Returns:
    a function that takes the simulation data and returns formatted
    data for a Plotly table
  ###
  get_col_value = curry(
    (vegadata, sim_name, col) ->
      if col is 'sim_name'
        sim_name
      else
        sequence(
          (x) -> get_values(chart_item.data_name, x)
          (f) -> f(vegadata)
          get_last
        )(col)
  )

  get_row_values = (chart_item_, sim_name) ->
    sequence(
      map(read_vega_data(appurl))
      (x) -> map(get_col_value(x, sim_name), chart_item.columns)
    )

  sequence(
    get_comparison_data(get_row_values, chart_item)
    transpose
  )



get_values = curry(
  (name, datum) ->
    ### Extracts values from Vega formatted data in a simulation data
    field

    Args:
      name: the name to match with the name field in the list of data
        items (e.g 'free_energy')
      datum: the subfied of data to extract (e.g. 'x')

    Returns:
      the extracted array of values

    ###
    mod = map(modify_keys((x) -> x.replace(/\s/g, '_').toLowerCase()))
    sequence(
      filter((x) -> x.name is name)
      get(0)
      (x) ->
        if x?
          sequence(
            make_array
            (y) -> pluck_arr_list(y, mod(x.values))
            (y) -> if y? then y else []
          )(datum)
        else
          []
    )
)


func_xy = (func) ->
  ### Change a function that takes one datum (either x or y) to a
  function that takes both x and y datums.
  ###
  (name, datum_x, datum_y) ->
    juxt(map(func(name), [datum_x, datum_y]))


reorder = curry(
  (center, name, datum_x, datum_y, values) ->
    ### Reorder a set of of data points based on the polar angle.

    Args:
      center: offset the center value for defining the angle
      name: the name to match with the name field in the list of data
        items (e.g 'free_energy')
      datum_x: the subfield of x data to extract (e.g. 'x')
      datum_y: the subfield of y data to extract (e.g. 'y')
      values: all the data values

    Returns:
      the calculated values as [x_values, y_values]

    ###
    calc_theta = sequence(
      (data) -> {x:data[0] - center[0], y:data[1] - center[1]},
      (data) -> {x:data.x, y:data.y, r:Math.sqrt(data.x ** 2 + data.y ** 2)}
      (data) -> {y:data.y, theta:Math.acos(data.x / data.r)}
      (data) -> data.theta + (data.y < 0.0) * (Math.PI - data.theta) * 2.0
    )

    sort_by_theta = sequence(
      (x) -> zip(x[0], x[1])
      sortBy(calc_theta)
      unzip
    )

    sequence(
      func_xy(get_values)(name, datum_x, datum_y)
      if values.length > 0 then sort_by_theta else id
    )(values)
)


vega_to_plotly = (chart_item, sim_name) ->
  ### Convert a Vega data item to a Plotly data item

  Args:
    chart_item: the chart data item
    sim_name: the name of the given simulation data item

  Returns:
    a func that converts Vega to Plotly
  ###

  efficiency = curry(
    (name, datum) ->
      if datum is 'x'
        (x) ->
          [get_values('run_time', 'wall_time')(x)[0] /
           get_values('run_time', 'sim_time')(x)[0]]
      else if datum is 'y'
        get_values('memory_usage', 'value')
  )

  normed = curry(
    (name, datum) ->
      if datum is 'time'
        get_values(name, datum)
      else
        sequence(
          (x) ->
            [get_values(name, datum)(x),
             get_values(name, 'precipitate_area')(x)]
          (x) -> zip(x[0], x[1])
          map((x) -> x[0] / x[1] * 400 ** 2)
        )
  )

  functions = {
    get_values:func_xy(get_values)
    efficiency:func_xy(efficiency)
    normed:func_xy(normed)
    reorder:reorder([0, 0])
    reorder_offset:reorder([-10000, -10000])
  }

  func_select = ->
    functions[chart_item.func] or func_xy(get_values)

  name_select_filter = (x) ->
    if chart_item.func is 'efficiency'
      x.name in ['run_time', 'memory_usage']
    else
      x.name is name_select()

  name_select = ->
    chart_item.data_name or chart_item.name

  plotly_dict = (x) ->
    {
      x:[]
      y:[]
      type:chart_item.type
      mode:chart_item.mode
      name:sim_name.substr(0, 15)
      data:x
      xy_func:func_select()(
        name_select()
        chart_item.x_name or 'x'
        chart_item.y_name or 'y'
      )
    }

  sequence(
    filter(name_select_filter)
    plotly_dict
  )


vega_to_plotly_no_load = curry(
  (data, loaded_values) ->
    sequence(
      map(read_vega_data_no_load(loaded_values))
      data.xy_func
      (x) ->
        {
          x:x[0]
          y:x[1]
          type:data.type
          mode:data.mode
          name:data.name
        }
    )(data.data)
)


get_comparison_data = curry(
  (func, chart_item, data) ->
    ### Convert Vega data to Plotly data

    Args:
      data_name: the name of the data to extract
      data: array of simulation data

    Returns:
      an array of all the named data extracted from each simulation
    ###
    map_undef(
      (x) -> func(chart_item, x.name)(x.meta.data)
      data
    )
)


filter_by_id = (benchmark_id) ->
  ### Filter all the simulation data by benchmark_id

  Args:
    benchmark_id: the benchmark_id to use

  Returns:
    a func that filters simulation data
  ###
  sequence(
    to_list('name')
    filter(
      (x) ->
        x.meta.benchmark.id + '.' + x.meta.benchmark.version is benchmark_id
    )
  )


build = (chart_data, benchmark_id, data, appurl) ->
  ### Build the Plotly plots for the comparison pages

  Args:
    chart_data: a list of chart data to determine charts to build
    benchmark_id: benchmark_id to filter the simulations
    data: all the simulation data
    appurl: the URL of the app

  Returns:
    a func that builds the graphs and attaches them to tagged HTML
    elements
  ###
  get_plotly_data_id = get_plotly_data(
    appurl
    filter_by_id(benchmark_id)(data)
  )

  callback = curry(
    (x, index, err, loaded_values) ->
      if err
        console.log(err)
        console.log('failed to load data')
      else
        x.data[index] = vega_to_plotly_no_load(x.data[index], loaded_values)
        Plotly.update(x.div, x.data, x.layout)
  )

  newplot = sequence(
    get_plotly_data_id
    (x) ->
      if x.data.length > 0
        Plotly.newPlot(x.div, x.data, x.layout)
        if x.data[0].data?
          map(
            (index) ->
              if x.data[index].data.length > 0
                url = x.data[index].data[0].url
              else
                url = null
              if url?
                dl.load({url:to_app_url(appurl, url)}, callback(x, index))
              else
                callback(x, index, null, null)

            [0..(x.data.length - 1)]
          )
  )
  -> map(newplot, chart_data)
