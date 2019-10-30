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
  {% for vid in site.data.voorhees-lectures %}
  {% assign counter = counter | plus: 1 %}
  <div class="card large light-green lighten-4">
    <h2 class="card-title"> Lecture {{ counter }} </h2>
    <div class="flow-text">
      {{ vid.caption }}
    </div>
    <iframe
     width="620"
     height="315"
     src="https://www.youtube.com/embed/{{ vid.hash }}">
    </iframe>
  </div>
  {% endfor %}
</div>
