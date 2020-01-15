---
---

{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}

mapping = (data, sim_name) ->
  {
    first:data.metadata.author.first
    last:data.metadata.author.last
    email:data.metadata.author.email
    github_id:data.metadata.author.github_id
    simulation_name:sim_name + '_update'
    timestamp:data.metadata.timestamp
    code_name:data.metadata.implementation.name
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


data_file_html = () ->
  """{% include data_input.html %}"""

media_file_html = () ->
  """{% include media_input.html %}"""

add_data_file_section = () ->
  counter = $('#data-files').children().size() + 2
  $('#data-files').append(
    Handlebars.compile(data_file_html())(
      {
        counter:counter
        fields:[['x', '',       'required', ''],
                ['y', '',       'required', ''],
                ['z', 'hidden', '',         'disabled']]
      }
    )
  )
  $('.tooltipped').tooltip({delay:50})
  counter

add_media_file_section = () ->
  counter = $('#media-files').children().size() + 10
  $('#media-files').append(
    Handlebars.compile(media_file_html())(
      {
        counter:counter
      }
    )
  )
  $('.tooltipped').tooltip({delay:50})
  counter

$("#data-add").click(add_data_file_section)

$("#media-add").click(add_media_file_section)

$("#data-files").on('click', '.data-remove',
  () ->
     $("#data-block-" + this.id.split('-')[2]).remove()
)

$("#media-files").on('click', '.media-remove',
  () ->
     $("#media-block-" + this.id.split('-')[2]).remove()
)

parse_field_ = (counter, field) ->
  f = (tag) ->
    $(tag).attr(
      'name'
      $(tag).attr('name') + '[' + $(tag).val() + ']'
    )
    $(tag).val('number')
  f('#data-' + field + '-parse-' + counter)

expr_field_ = (counter, field) ->
  f = (expr_tag, data_tag) ->
    $(expr_tag).val(
      $(expr_tag).val() + $(data_tag).val()
    )
  f('#expr-' + field + '-' + counter, '#data-' + field + '-parse-' + counter)

field_ = (func) ->
  (field) ->
    map(
      (x) ->
        func(x, field)
      map((x) ->
            x.id.split('-')[2]
          $('#data-files').children())
    )

$('#my_form').submit(
  () ->
    map(
      (x) ->
        field_(expr_field_)(x)
        field_(parse_field_)(x)
      ['x', 'y', 'z']
    )
)

##############################
## 2D versus 3D data selection
# ############################

get_tags = (thiss) ->
  f = (x) ->
    ['#input-field-z-' + x,
     '#data-z-parse-' + x,
     '.field-input-z-' + x]
  f(thiss.id.split('-')[2])


$('#data-files').on('click', '.dim-line',
  () ->
    console.log('wow')
    [div_tag, input_tag, field_class] = get_tags(this)
    $(div_tag).attr('hidden', '')
    $(input_tag).removeAttr('required')
    $(field_class).attr('disabled', '')
)

add_contour = (thiss) ->
  [div_tag, input_tag, field_class] = get_tags(thiss)
  $(div_tag).removeAttr('hidden')
  $(input_tag).attr('required', '')
  $(field_class).removeAttr('disabled')

$('#data-files').on('click', '.dim-contour',
  () ->
    add_contour(this)
)


get_field_name = (datum, field) ->
  if datum.transform?
    filtered = datum.transform.filter((x) -> x.as == field)
    if filtered.length > 0
      filtered[0].expr.split('.')[1]
    else
      field
  else
    field

populate_media = (datum) ->
  counter = add_media_file_section()
  $('#media-name-' + counter).val(datum.name)
  $('#media-link-input-' + counter).val(datum.url)
  $('#media-desc-' + counter).val(datum.description)
  if datum.type == 'image'
    $('#image-' + counter).attr('checked', '')
    $('#youtube-' + counter).removeAttr('checked')

populate_data = (datum) ->
  counter = add_data_file_section()
  $('#data-name-' + counter).val(datum.name)
  $('#data-link-input-' + counter).val(datum.url)
  $('#data-desc-' + counter).val(datum.description)
  if datum.format? and datum.format.type == 'json'
    $('#json-' + counter).attr('checked', '')
    $('#csv-' + counter).removeAttr('checked')
  $('#data-x-parse-' + counter).val(get_field_name(datum, 'x'))
  $('#data-y-parse-' + counter).val(get_field_name(datum, 'y'))
  if datum.type == 'contour'
    add_contour($('#dim-contour-' + counter)[0])
    $('#data-z-parse-' + counter).val(get_field_name(datum, 'z'))
    $('#dim-contour-' + counter).attr('checked', '')
    $('#line-contour-' + counter).removeAttr('checked')

populate_data_section = (data) ->
  map(
    populate_data
    data.data.filter(
      (d) -> (d.type == 'contour' or d.type == 'line') and d.url?
    )
  )

populate_media_section = (data) ->
  map(
    populate_media
    data.data.filter(
      (d) -> (d.type == 'youtube' or d.type == 'image') and d.url?
    )
  )

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
  populate_data_section(DATA)
  populate_media_section(DATA)

@update_url = (data) ->
  data.value = github_to_raw(data.value)

calc_benchmark_version = (benchmark_data, benchmark_id) ->
  sequence(
    (x) -> x.slice(0, -1) - 1
    (x) -> benchmark_data[x].revisions[0].version
  )(benchmark_id)

set_benchmark_version = () ->
  $('#version_input').val(
    calc_benchmark_version(
      {{ site.data.benchmarks | jsonify }}
      $('#benchmark_id').children("option:selected").val()
    )
  )

set_benchmark_version()
$('#benchmark_id').change(set_benchmark_version)
