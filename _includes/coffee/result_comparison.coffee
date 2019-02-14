###
Functions to generate the comparison pages
###

get_plotly_data = curry(
  (data, chart_item) ->
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
      get_table_data(data, chart_item)
    else
      throw new Error "chart_item has wrong type"
)


get_scatter_data = (data, chart_item) ->
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


get_table_data = (data, chart_item) ->
  {
    data:[get_table_data_(chart_item, data)]
    div:'chart_' + chart_item.name
    layout:{
      "title":chart_item.title
      font:{
        family: 'Lato'
      }
    }
  }


get_table_data_ = (chart_item, data) ->

  get_color = (x, i) ->
    if i %% 2 is 1
      'white'
    else
      '#d1d1d1'

  sequence(
    get_table_values(chart_item)
    (x) ->
      {
        header: {
          values:chart_item.column_titles
          align:"center"
          line: {width: 0, color: 'black'}
        }
        cells:{
          values: x
          align:"center"
          line: {color: "black", width: 0},
          font: {family: 'Lato', size: 12, color: 'black'}
          fill: {color:[map(get_color, x[0])]}
          format: [".4g"]
        }
        type:"table"
      }
  )(data)


get_table_values = (chart_item) ->

  get_col_value = (vegadata) ->
    sequence(
      (x) -> get_values(chart_item.data_name, x)
      (f) -> f(vegadata)
      get_last
    )

  get_row_values = (chart_item_, sim_name) ->
    sequence(
      map(read_vega_data)
      (x) -> map(get_col_value(x), chart_item.columns)
    )

  sequence(
    get_comparison_data(get_row_values, chart_item)
    transpose
  )


get_values = (name, datum) ->
  sequence(
    filter((x) -> x.name is name)
    get(0)
    (x) ->
      if x? then pluck_arr(datum, x.values) else null
  )


vega_to_plotly = (chart_item, sim_name) ->
  ### Convert a Vega data item to a Plotly data item

  Args:
    chart_item: the chart data item
    sim_name: the name of the given simulation data item

  Returns:
    a func that converts Vega to Plotly
  ###


  efficiency = (name, datum) ->
    if datum is 'x'
      (x) ->
        [get_values('run_time', 'wall_time')(x)[0] /
         get_values('run_time', 'sim_time')(x)[0]]
    else if datum is 'y'
      get_values('memory_usage', 'value')

  normed = (name, datum) ->
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

  functions = {
    get_values:get_values
    efficiency:efficiency
    normed:normed
  }

  func_select = ->
    functions[chart_item.func] or get_values

  name_select = ->
    chart_item.data_name or chart_item.name

  plotly_dict = (x) ->
    {
      x:func_select()(name_select(), chart_item.x_name or 'x')(x)
      y:func_select()(name_select(), chart_item.y_name or 'y')(x)
      type:chart_item.type
      mode:chart_item.mode
      name:sim_name.substr(0, 15)
    }

  sequence(
    map(read_vega_data)
    plotly_dict
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


build = (chart_data, benchmark_id, data) ->
  ### Build the Plotly plots for the comparison pages

  Args:
    chart_data: a list of chart data to determine charts to build
    benchmark_id: benchmark_id to filter the simulations
    data: all the simulation data

  Returns:
    a func that builds the graphs and attaches them to tagged HTML
    elements
  ###
  get_plotly_data_id = get_plotly_data(
    filter_by_id(benchmark_id)(data)
  )
  newplot = sequence(
    get_plotly_data_id
    (x) ->
      if x.data.length > 0
        Plotly.newPlot(x.div, x.data, x.layout)
  )
  -> map(newplot, chart_data)
