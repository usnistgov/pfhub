---
# use this file to scrape the important parts of the collections api
---
/** Extract pieces of the Jekyll Collection API 
  variables are loaded in as window.sitecontent
  **/
  // automatically happens because it is in the source
  // after jekyll parses it
  
var sitecontent = [];

{% for content in site.content %}
sitecontent[ {{forloop.index}} ] = {
  title: "{{content.title}}",
  path: "{{content.relative_path}}",
  url: "{{site.baseurl}}{{content.url}}",
  type: "{{content.type}}",
  layout: "{{content.layout}}"
};
{% endfor %}
