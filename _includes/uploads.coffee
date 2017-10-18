count_uploads = (benchmark_num, data) ->
  ### Count the number of uploads per benchmark number

  Args:
    benchmark_num: the benchmark number (1, 2, ...)
    data: all the benchmark data

  Returns:
    the number of uploads
  ###
  sequence(
    (x) -> (v for k, v of x when k not in ['example', 'example_minimal', 'test_lander'])
    (x) -> x.filter((y) -> y.meta.benchmark.id[0] == "#{benchmark_num}")
    (x) -> x.length
  )(data)


build_uploads = (benchmark_num, data, tag) ->
  ### Add the number of uploads to a tag per benchmark

  Args:
    benchmark_num: the benchmark number (1, 2, ...)
    data: all the benchmark data

  Returns:
    the number of uploads
  ###
  select_tag(tag)([count_uploads(benchmark_num, data)])
    .append('span')
    .text((d) -> d)
