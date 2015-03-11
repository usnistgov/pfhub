(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['codes'] = template({"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
    var stack1, helper, alias1=helpers.helperMissing, alias2="function", alias3=this.escapeExpression, alias4=this.lambda;

  return "  <div class=\"logo\">\n    <img src=\""
    + alias3(((helper = (helper = helpers.logo_path || (depth0 != null ? depth0.logo_path : depth0)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"logo_path","hash":{},"data":data}) : helper)))
    + "\">\n  </div>\n  <h4 class=\"codeheader\">"
    + alias3(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"name","hash":{},"data":data}) : helper)))
    + "</h4>\n  <p>"
    + alias3(((helper = (helper = helpers.discretization || (depth0 != null ? depth0.discretization : depth0)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"discretization","hash":{},"data":data}) : helper)))
    + " code written in "
    + alias3(((helper = (helper = helpers.language || (depth0 != null ? depth0.language : depth0)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"language","hash":{},"data":data}) : helper)))
    + " and started in "
    + alias3(((helper = (helper = helpers.year_started || (depth0 != null ? depth0.year_started : depth0)) != null ? helper : alias1),(typeof helper === alias2 ? helper.call(depth0,{"name":"year_started","hash":{},"data":data}) : helper)))
    + ".</p>\n  <h5>Recent Stats</h5>\n  <table class=\"indent\">\n    <tr>\n      <td>Commits:</td>\n      <td>"
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.stats : depth0)) != null ? stack1.recent_commits : stack1), depth0))
    + "</td>\n    </tr>\n    <tr>\n      <td>Contributors:&nbsp;</td>\n      <td>"
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.stats : depth0)) != null ? stack1.recent_contributors : stack1), depth0))
    + "</td>\n    </tr>\n    <tr>\n      <td>Fixes:</td>\n      <td>"
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.stats : depth0)) != null ? stack1.recent_bugs_fixed : stack1), depth0))
    + "/"
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.stats : depth0)) != null ? stack1.recent_bugs_opened : stack1), depth0))
    + "</td>\n    </tr>\n  </table> \n  <h5>Since Inception</h5>\n  <table class=\"indent\">\n    <tr>\n      <td>Commits:</td>\n      <td>"
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.stats : depth0)) != null ? stack1.commits : stack1), depth0))
    + "</td>\n    </tr>\n    <tr>\n      <td>Contributors:&nbsp;</td>\n      <td>"
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.stats : depth0)) != null ? stack1.contributors : stack1), depth0))
    + "</td>\n    </tr>\n  </table> \n  <div class=\"icons\">\n    <a href=\""
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.urls : depth0)) != null ? stack1.home : stack1), depth0))
    + "\" title=\"Home Page\">\n      <i class=\"fa fa-home fa-2x\"></i>\n    </a>\n    <a href=\""
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.urls : depth0)) != null ? stack1.github : stack1), depth0))
    + "\" title=\"GitHub\">\n      <i class=\"fa fa-github fa-2x\"></i>\n    </a>\n    <a href=\""
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.url : depth0)) != null ? stack1.openhub : stack1), depth0))
    + "\" title=\"OpenHub\">\n      <img src=\"images/OH_logo-24x24.png\" class=\"icon\">\n    </a>\n    <a href=\""
    + alias3(alias4(((stack1 = (depth0 != null ? depth0.url : depth0)) != null ? stack1.test : stack1), depth0))
    + "\" title=\"Test Suite\">\n      <i class=\"fa fa-tasks fa-2x\"></i>\n    </a>\n  </div>\n\n\n";
},"useData":true});
})();