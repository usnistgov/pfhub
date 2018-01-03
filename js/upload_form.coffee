---
---

{% include coffee/essential.coffee %}

mapping = (data, sim_name) ->
  {
    first:data.metadata.author.first
    last:data.metadata.author.last
    email:data.metadata.email
    github_id:data.metadata.github_id
    simulation_name:sim_name
    timestamp:data.metadata.timestamp
    code_name:data.metadata.software.name
    sim_url:data.metadata.implementation.repo.url
    sim_sha:data.metadata.implementation.repo.version
    container_url:data.metadata.implementation.container_url
    clock_rate:data.metadata.hardware.clock_rate
    cores:data.metadata.hardware.cores
    nodes:data.metadata.hardware.nodes
    wall_time:run_time(data).wall_time
    sim_time:run_time(data).sim_time
    memory_usage:memory_usage(data)
  }


set_value = (item) ->
  $('#' + item[0]).attr('value', item[1])

run_time = (data) ->
  data.data.filter((d) -> d.name == 'run_time')[0].values[0]

memory_usage = (data) ->
  data.data.filter((d) -> d.name == 'memory_usage')[0].values[0].value

SIM_NAME = new URL(window.location.href).searchParams.get("sim")

if SIM_NAME?
  DATA={{ site.data.simulations | jsonify }}[SIM_NAME].meta
  map(
    (x) -> $('#' + x[0]).attr('value', x[1])
    Object.entries(mapping(DATA, SIM_NAME))
  )
  $('#summary').html(DATA.metadata.summary)
  $('#option_' + DATA.benchmark.id).attr('selected', '')
  $('#arch_' + DATA.metadata.hardware.cpu_architecture).attr('selected', '')
  $('#acc_' + DATA.metadata.hardware.acc_architecture).attr('selected', '')
  $('#par_' + DATA.metadata.hardware.parallel_model).attr('selected', '')

data_file_html = () ->
  """{% include data_input.html %}"""

$("#data-add").click(
  () ->
    $('#data-files').append(
      Handlebars.compile(data_file_html())(
        {
          counter:$('#data-files').children().size() + 2
        }
      )
    )
)

parse_field_ = (tag) ->
  $(tag).attr(
    'name'
     $(tag).attr('name') + '[' + $(tag).val() + ']'
  )
  $(tag).val('number')

parse_field = (tag) ->
  map(
    (x) -> parse_field_(tag + '-' + x)
    [2...($('#data-files').children().size() + 2)]
  )


$('#my_form').submit(
  () ->
    parse_field('#data-x-parse')
    parse_field('#data-y-parse')
)
