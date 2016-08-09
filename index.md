---
title: "Overview"
layout: default
---

{% capture main_content %}
<p>
In January 2015 a group of phase field theorists and code developers
met at Northwestern University to discuss ways for the community to
improve code collaboration efforts. Everyone agreed that the community
needs to become more open and work in a more collaborative manner.
</p>
<p>
A key factor to improving community code collaboration is to develop
resources to compare and contrast phase field codes and
libraries. This site aims to provide some of these resources and
become a useful web service for phase field practitioners.
</p>
{% endcapture %}

{% capture benchmark-description %}
Benchmark problems vetted by the community to test, validate and
verify phase field codes (read an
<a href="{{ site.baseurl }}/benchmarks"
target="_blank">
extended overview
</a>).
{% endcapture %}

{% include title.html header="CHiMaD Phase Field" comment="Integrating the phase field community"%}
{% include hexbin.html %}
{% include textblock.html content=main_content %}
{% include collection.html header="Benchmarks" tag="benchmarks" js="benchmarks" description=benchmark-description %}
{% include collection.html header="Codes" tag="codes" js="codes" %}
