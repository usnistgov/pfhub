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
  }

set_attr = (id_, attr, value) ->
  document.getElementById(id_).setAttribute(attr, value)

set_value = (item) ->
  set_attr(item[0], 'value', item[1])

SIM_NAME = new URL(window.location.href).searchParams.get("sim")
DATA={{ site.data.simulations | jsonify }}[SIM_NAME].meta

map(set_value, Object.entries(mapping(DATA, SIM_NAME)))
document.getElementById('summary').innerHTML = DATA.metadata.summary
set_attr('option_' + DATA.benchmark.id, 'selected', '')
set_attr('arch_' + DATA.metadata.hardware.architecture, 'selected', '')
set_attr('par_' + DATA.metadata.hardware.parallel_model, 'selected', '')
