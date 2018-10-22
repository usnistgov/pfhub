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
    {
      data:get_comparison_data(chart_item, data)
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
)


vega_to_plotly = (chart_item, sim_name) ->
  ### Convert a Vega data item to a Plotly data item

  Args:
    chart_item: the chart data item
    sim_name: the name of the given simulation data item

  Returns:
    a func that converts Vega to Plotly
  ###

  get_values = (name, datum) ->
    sequence(
      filter((x) -> x.name is name)
      get(0)
      (x) ->
        if x? then pluck_arr(datum, x.values) else null
    )

  efficiency = (name, datum) ->
    if datum is 'x'
      (x) ->
        [get_values('run_time', 'wall_time')(x)[0] /
         get_values('run_time', 'sim_time')(x)[0]]
    else if datum is 'y'
      get_values('memory_usage', 'value')

  functions = {
    get_values:get_values
    efficiency:efficiency
  }

  plotly_dict = (x) ->
    {
      x:functions[chart_item.func](chart_item.name, 'x')(x)
      y:functions[chart_item.func](chart_item.name, 'y')(x)
      type:'scatter'
      mode:chart_item.mode
      name:sim_name.substr(0, 15)
    }

  sequence(
    map(read_vega_data)
    plotly_dict
  )


get_comparison_data = curry(
  (chart_item, data) ->
    ### Convert Vega data to Plotly data

    Args:
      data_name: the name of the data to extract
      data: array of simulation data

    Returns:
      an array of all the named data extracted from each simulation
    ###
    map_undef(
      (x) -> vega_to_plotly(chart_item, x.name)(x.meta.data)
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
