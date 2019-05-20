---
---

{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}


$("h4, h5, h6").each(
  () ->
    heading = $(this).text()
    $(this).text("")
    $(this).append(
      make_anchor_html(
        "{{ site.baseurl}}"
        heading
      )
    )
    $(this).attr("class", "anchor")
)
