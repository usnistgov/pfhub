###
Functions to generate the comparison pages
###


# filter_by_name = (data_name, simulation_data) ->



add_plotly_chart = (simulation_data) ->
  sequence(
    (x) ->
      {
        data:
          [{x:[1, 2, 3, 4], y:[10, 15, 13, 17], type:'scatter'}
           {x:[1, 2, 3, 4], y:[16, 5, 11, 9], type:'scatter'}]
        name:x.name
      }
    (x) -> Plotly.newPlot('chart_' + x.name, x.data)
  )

debug = (x) ->
  console.log(x[0])
  console.log(x[0].data)
  console.log(x[0].data.values)
  console.log(pluck_arr('x', x[0].data.values))
  x


get_vega_data = (benchmark_id, data_name) ->
  sequence(
    to_list('name')
    (x) ->
      x.filter(
        (y) ->
          y.meta.benchmark.id + '.' + y.meta.benchmark.version is benchmark_id
      )
    map((x) ->
      {
        name:x.name
        data:x.meta.data.filter((y) -> y.name is data_name)[0]
      }
    )
    map((x) ->
      {
        name:x.name
        data:read_vega_data(x.data)
      }
    )
    debug
    map((x) ->
      {
        name:x.name
        x:pluck_arr('x', x.data.values)
        y:pluck_arr('y', x.data.values)
      }
    )
  )


build = (chart_data, benchmark_id, simulation_data) ->
  the_data = get_data(benchmark_id, 'free_energy')(simulation_data)
  console.log(the_data)

  -> map(add_plotly_chart(simulation_data), chart_data)
