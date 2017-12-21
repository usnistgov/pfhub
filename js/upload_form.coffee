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
