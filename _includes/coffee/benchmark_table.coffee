###
Functions to build the benchmark table
###


benchmark_id = (data, type, row) ->
  "#{row.num}#{row.variations}.#{row.revisions.version}"


get_columns = ->
  ### Get the column data for the table

  Returns:
    list of columns
  ###
  [
    {
      title:'ID'
      render:benchmark_id
    }
    {
      data:'num'
      title:'Num'
    }
    {
      data:'variations'
      title:'Variation'
    }
    {
      data:'revisions'
      title:'Revision'
      render:((x, ...) -> x.version)
    }
    {
      data:'title'
      title:'Title'
    }
  ]


transform_data = sequence(
  flat_key_from_list('variations')
  flat_key_from_list('revisions')
)


get_benchmark_data = (data) ->
  ### the final data for the benchmark table

  Args:
    data: the raw benchmark data

  Returns:
    data formatted for Datatable
  ###
  {
    lengthMenu:[20]
    lengthChange:false
    data:transform_data(data)
    columns:get_columns()
  }
