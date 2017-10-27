###
Functions to build the benchmark table
###


make_id = (row) ->
  ### Construct a Benchmark ID

  Args:
    row: all the row data

  Returns:
    ID like '1a.0'
  ###
  "#{row.num}#{row.variations}.#{row.revisions.version}"


benchmark_id = (data, type, row) ->
  ### Build the benchmark ID html for the table

  Args:
    data: unused
    type: unused
    row: all the row data

  Returns:
    the HTML string for the table
  ###
  link_html(
    row.revisions.url
    make_id(row)
  )


uploads = (sim_data) ->
  ### Make function for upload HTML link

  Args:
    sim_data: all the raw simulation data

  Returns:
    the function
  ###
  (data, type, row) ->
    link_html(
      'simulations/' + make_id(row)
      count_uploads_id(make_id(row), sim_data)
    )


event = (data, type, row) ->
  ### Make HTML for link to event in the table

  Args:
    data: unused
    type: unused
    row: all the row data

  Returns:
    the HTML string for the link in the table
  ###
  link_html(
    row.revisions.event.url
    row.revisions.event.name
  )


commit = (data, type, row) ->
  ### Make HTML for link to commit in table

  Args:
    data: unused
    type: unused
    row: all the row data

  Returns:
    the HTML string for the link to the commit
  ###
  link_html(
    "{{ site.links.github }}/blob/\
    #{row.revisions.commit.sha}/#{row.revisions.commit.url}"
    row.revisions.commit.sha.substr(0, 7)
  )


get_columns = (sim_data) ->
  ### Get the column data for the table

  Args:
    sim_data: the raw simulation data

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
    {
      title:'Uploads'
      render:uploads(sim_data)
    }
    {
      title:'Event'
      render:event
    }
    {
      title:'Commit'
      render:commit
    }
  ]


transform_data = sequence(
  flat_key_from_list('variations')
  flat_key_from_list('revisions')
)


get_benchmark_data = (benchmark_data, sim_data) ->
  ### the final data for the benchmark table

  Args:
    benchmark_data: the raw benchmark data
    sim_data: the raw simulation data

  Returns:
    data formatted for Datatable
  ###
  {
    lengthMenu:[20]
    lengthChange:false
    data:transform_data(benchmark_data)
    columns:get_columns(sim_data)
  }
