---
layout: wiki
title: Phase Field Lectures
published: true
---

## Overview

Global Initiative of Academic Networks (GIAN) course on Phase Field
Modelling by Peter Voorhees at IITB in March 2018.

{% assign ids = "3Nt5hS8S2qY, W02PH1fZJgw, CQwhvEn5VNI, xj4p8q_5j-k, b3ktTywqIwM, K_2XYkT-qV4, H7E5cWksKi4, frLcPnWdDlE, Oqg_9tU_DRY" | split: ", " %}

{% assign counter = 0 %}

{% for id in ids %}
  {% assign counter = counter | plus: 1 %}

  <h2> Lecture {{ counter }} </h2>

  <iframe width="620"
          height="315"
          src="https://www.youtube.com/embed/{{ id }}">
  </iframe>
{% endfor %}
