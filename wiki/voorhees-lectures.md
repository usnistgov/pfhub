---
layout: wiki
title: Phase Field Lectures
published: true
---

## Overview

<div class="flow-text describe">
  Global Initiative of Academic Networks (GIAN) course on Phase Field
  Modelling by Peter Voorhees at IITB in March 2018.
</div>

{% assign counter = 0 %}

<div class="container">
  <div class="row small-buffer">
  {% for vid in site.data.voorhees-lectures %}
    {% assign counter = counter | plus: 1 %}

    <div class="card large light-green lighten-4">
    <h2 class="card-title"> Lecture {{ counter }} </h2>
    <iframe
     width="620"
     height="315"
     src="https://www.youtube.com/embed/{{ vid.hash }}">
    </iframe>
    <div class="flow-text">
      <b><i>Topic:</i></b> {{ vid.caption }}
    </div>
  </div>

{% endfor %}
  </div>
</div>
