###
Functions to build the benchmark table
###


get_columns = ->
  ### Get the column data for the table

  Returns:
    list of columns
  ###
  [
    {
      data:'num'
      title:'Num'
    }
    {
      data:'title'
      title:'Title'
    }
  ]


get_benchmark_data = (raw_data) ->
  ### the final data for the benchmark table

  Args:
    the raw benchmark data

  Returns:
    data formatted for Datatable
  ###
  {
    lengthMenu:[10]
    lengthChange:false
    data:raw_data
    columns:get_columns()
  }
