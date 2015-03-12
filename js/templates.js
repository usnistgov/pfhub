(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['codes'] = template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
    var stack1, alias1=this.lambda, alias2=this.escapeExpression;

  return "  <div class=\"icons\">\n    <a href=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.urls : depth0)) != null ? stack1.home : stack1), depth0))
    + "\" title=\"Home Page\">\n      <i class=\"fa fa-home fa-2x\"></i>\n    </a>\n    <a href=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.urls : depth0)) != null ? stack1.github : stack1), depth0))
    + "\" title=\"GitHub\">\n      <i class=\"fa fa-github fa-2x\"></i>\n    </a>\n    <a href=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.url : depth0)) != null ? stack1.openhub : stack1), depth0))
    + "\" title=\"OpenHub\">\n      <img src=\"images/OH_logo-24x24.png\" class=\"icon\">\n    </a>\n    <a href=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.url : depth0)) != null ? stack1.test : stack1), depth0))
    + "\" title=\"Test Suite\">\n      <i class=\"fa fa-tasks fa-2x\"></i>\n    </a>\n  </div>\n\n\n";
},"useData":true});
})();