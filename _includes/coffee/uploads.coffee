### Update the DOM for the benchmark uploads
###


build_uploads = (benchmark_num, data, tag) ->
  ### Add the number of uploads to a tag per benchmark

  Args:
    benchmark_num: the benchmark number (1, 2, ...)
    data: all the benchmark data

  Returns:
    the number of uploads
  ###
  select_tag(tag)([count_uploads_num(benchmark_num, data)])
    .append('span')
    .text((d) -> d)
