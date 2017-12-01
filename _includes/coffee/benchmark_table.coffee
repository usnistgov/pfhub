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
    cond = (x) ->
      if x > 0 then link_html('simulations/' + make_id(row), x) else '0'
    cond(count_uploads_id(make_id(row), sim_data))


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

title = (data, type, row) ->
  ### Build the title html for the table

  Args:
    data: unused
    type: unused
    row: all the row data

  Returns:
    the HTML string for the table
  ###
  link_html(
    row.revisions.url
    row.title
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
      title:'Title'
      render:title
    }
    {
      title:'ID'
      render:benchmark_id
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
    {
      data:'num'
      title:'Num'
    }
    {
      data:'revisions'
      title:'Revision'
      render:((x, ...) -> x.version)
    }
    {
      data:'variations'
      title:'Variation'
    }
  ]


transform_data = sequence(
  flat_key_from_list('revisions')
  map((x) -> extend(copy_(x), {variations:x.revisions.variations}))
  flat_key_from_list('variations')
)


filter_num_revision = (num = null, revision = null) ->
  ### return a filter function on num and revision

  Args:
    num: either null or a list of numbers
    revision: either null or a single revision number

  Returns:
    a function to filter benchmark data
  ###
  (x) ->
    le_ = (x0, x1) ->
      parseInt(x0, 10) <= parseInt(x1, 10)
    num_ = (y) ->
      if (num is null) then true else (y.num in num)
    revision_ = (y) ->
      if (revision is null) then true else le_(y.revisions.version, revision)
    num_(x) and revision_(x)


get_benchmark_data = (benchmark_data, sim_data, filter_func = (x) -> true) ->
  ### the final data for the benchmark table

  Args:
    benchmark_data: the raw benchmark data
    sim_data: the raw simulation data

  Returns:
    data formatted for Datatable
  ###
  {
    lengthMenu:[15]
    lengthChange:false
    data:transform_data(benchmark_data).filter(filter_func)
    columns:get_columns(sim_data)
    responsive:true
  }
