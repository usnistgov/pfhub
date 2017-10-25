###
Functions to build the benchmark table
###


get_columns = () ->
  ### Get the column data for the table

  Returns:
    list of columns
  ###
  [
    {
      data:"num"
      title:"Num"
    }
    {
      data:"title"
      title:"Title"
    }
  ]


# some_data =
#   [
#     {
#       name: "wow"
#       list: [{item: 1}, {item: 2}]
#     }
#     {
#       name: "cool"
#       list: [{item: 1}, {item: 2}]
#     }
#   ]

# flat_dict = (data, key) ->
#   map(extend(data), data[key])


get_benchmark_data = (raw_data) ->
  ### the final data for the benchmark table

  Args:
    the raw benchmark data

  Returns:
    data formatted for Datatable
  ###
  # console.log(extend({'a':1}, {'b':2}))
  {
    lengthMenu:[10]
    lengthChange:false
    data:raw_data
    columns:get_columns()
  }
