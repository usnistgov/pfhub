---
---

{% include coffee/essential.coffee %}
{% include coffee/main.coffee %}

fname = (data, type, row) ->
  '<a href="{{ site.baseurl }}/simulations/display/?sim=' + data + '">' + data + '</a>'

fauthor = (data, type, row) ->
  if data.email
    '<a href="mailto:' + data.email + '">' + data.name + '</a>'
  else
    data.name

fcode = (data, type, row) ->
  if data.url
    '<a href="' + data.url + '" target="_blank">' + data.name + '</a>'
  else
    data.name

fbenchmark = (data, type, row) ->
  '<a href="{{ site.baseurl }}/simulations/' + data + '">' + data + '</a>'

create_table = (data_in) ->
  data_raw = data_in

  data_filter = (datum for datum in data_raw when datum['id_'] is BENCHMARK_ID)

  data_table = if BENCHMARK_ID is '' then data_raw else data_filter

  data = {
    responsive: true
    lengthMenu: [15]
    lengthChange: false
    data: data_table
    columns: [
      {
        data: "name"
        title: "Name"
        render: fname
      }
      {
        data: "code"
        title: "Code"
        render: fcode
      }
      {
        data: "id_"
        title: "Benchmark"
        render: fbenchmark
      }
      {
        data: "author"
        title: "Author"
        render: fauthor
      }
      {
        data: "timestamp"
        title: "Timestamp"
      }
      {
        data: "cores"
        title: "Cores"
      }
    ]
  }

  func = () ->
    $("#data_table").DataTable data

  $(document).ready func


create_table(
  make_table_data(
    {{ site.data.simulations | jsonify }}
  )
)
