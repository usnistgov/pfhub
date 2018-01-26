---
---

{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}
{% include coffee/benchmark_table.coffee %}

func = () ->
  $(TAG).DataTable(
    get_benchmark_data(
      {{ site.data.benchmarks | jsonify }}
      {{ site.data.simulations | jsonify }}
      filter_num_revision(BENCHMARK_NUM, BENCHMARK_REVISION)
    )
  )

$(document).ready(func)
