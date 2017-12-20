---
---

{% include coffee/essential.coffee %}

mapping = (data) ->
  {
    first:data.metadata.author.first
    last:data.metadata.author.last
    email:data.metadata.email
  }

set_value = (item) ->
  document.getElementById(item[0]).setAttribute("value", item[1]);

SIM_NAME = new URL(window.location.href).searchParams.get("sim")
DATA={{ site.data.simulations | jsonify }}[SIM_NAME].meta

map(set_value, Object.entries(mapping(DATA)))
