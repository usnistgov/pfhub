---
---


{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}
{% include coffee/vega_extra.coffee %}
{% include coffee/simulation.coffee %}
{% include coffee/uploads.coffee %}

build_uploads(BENCHMARK_NUM, DATA, TAG)

$('#total_uploads_bench').html('Total Uploads: ' + total_uploads(DATA))
