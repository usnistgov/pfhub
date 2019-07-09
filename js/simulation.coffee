---
---


{% include coffee/essential.coffee %}
{% include coffee/vega_extra.coffee %}
{% include coffee/simulation.coffee %}


if SIM_NAME of ALL_DATA
  build(
    ALL_DATA[SIM_NAME].meta
    SIM_NAME
    CODES_DATA
    CHART_DATA
    AXES_NAMES
    REPO
    BENCHMARK_DATA
    "{{ site.links.app }}"
  )
else
  window.location = "{{ site.baseurl }}/simulations/notfound/?sim=" + SIM_NAME


$('img.materialboxed').each(
  (index, element) ->
    $(element).height($(element).parent().height())
)


$('div.video-container iframe').each(
  (index, element) ->
    $(element).height($(element).parent().parent().height())
)
