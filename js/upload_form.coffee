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

set_attr = (id_, attr, value) ->
  document.getElementById(id_).setAttribute(attr, value)

set_value = (item) ->
  set_attr(item[0], 'value', item[1])

run_time = (data) ->
  data.data.filter((d) -> d.name == 'run_time')[0].values[0]

memory_usage = (data) ->
  data.data.filter((d) -> d.name == 'memory_usage')[0].values[0].value

SIM_NAME = new URL(window.location.href).searchParams.get("sim")

if SIM_NAME?
  DATA={{ site.data.simulations | jsonify }}[SIM_NAME].meta
  map(set_value, Object.entries(mapping(DATA, SIM_NAME)))
  document.getElementById('summary').innerHTML = DATA.metadata.summary
  set_attr('option_' + DATA.benchmark.id, 'selected', '')
  set_attr('arch_' + DATA.metadata.hardware.cpu_architecture, 'selected', '')
  set_attr('acc_' + DATA.metadata.hardware.acc_architecture, 'selected', '')
  set_attr('par_' + DATA.metadata.hardware.parallel_model, 'selected', '')

add_data = () ->
  console.log('got here')
  document.getElementById('test').innerHTML = 'Hello!'

$("#scale-demo").click(
  () ->
    console.log('got here')
    test_ele = document.getElementById('test')
    div_ele = document.createElement('div')
    div_ele.innerHTML = "<p>Hi!</p>"
    test_ele.appendChild(div_ele)
)
