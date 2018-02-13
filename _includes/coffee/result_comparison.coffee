###
Functions to generate the comparison pages
###


add_plotly_chart = (simulation_data, benchmark_id) ->
  sequence(
    (x) ->
      {
        data:get_comparison_data(benchmark_id, x.name)(simulation_data)
        div:'chart_' + x.name
        layout:{title:x.title, showlegend: true}
      }
    (x) -> Plotly.newPlot(x.div, x.data, x.layout)
  )


vega_to_plotly = (data_name, sim_name) ->
  sequence(
    filter((x) -> x.name is data_name)
    get(0)
    read_vega_data
    (x) -> {
      x:pluck_arr('x', x.values)
      y:pluck_arr('y', x.values)
      mode:'lines'
      name:sim_name
    }
  )


get_comparison_data = (benchmark_id, data_name) ->
  sequence(
    to_list('name')
    filter(
      (x) ->
        x.meta.benchmark.id + '.' + x.meta.benchmark.version is benchmark_id
    )
    map((x) -> vega_to_plotly(data_name, x.name)(x.meta.data))
  )


build = (chart_data, benchmark_id, simulation_data) ->
  -> map(add_plotly_chart(simulation_data, benchmark_id), chart_data)
