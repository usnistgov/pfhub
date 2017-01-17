---
---

fname = (data, type, row) ->
  '<a href="{{ site.links.simmeta }}/' + data + '/meta.yaml" target="_blank">' + data + '</a>'

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


d3_func = (yaml_text) ->
  data_ = jsyaml.load(yaml_text)

  data = {
    lengthMenu: [15]
    lengthChange: false
    data: data_['data']
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

d3.text("../data/data_table.yaml", d3_func)
