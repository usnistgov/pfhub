---
---

{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}


$("h4, h5, h6").each(
  () ->
    $(this).attr("class", "anchor")
    $(this).prepend(
      make_anchor_html(
        "{{ site.baseurl}}"
        $($(this).children()[0]).attr("name")
      )
    )
)
