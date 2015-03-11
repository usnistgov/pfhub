data_file = "data/codes.json"

template = Handlebars.templates.codes

add_logo = (selection) ->
        selection = selection.append("div").attr(class, "logo")
        selection.append("img").attr(src, (d) -> d.url.logo)
        


build_function = (data) ->
        selection = d3.select("#codes").selectAll()
        .data(data).enter()
        .append("div").attr("class", "col-md-4")
        .append("div").attr("class", "card")

        selection.append("div").attr("class", "test")
        
        selection.append("div").attr("class", "test1").html((d) -> template(d))

d3.json(data_file, build_function)

