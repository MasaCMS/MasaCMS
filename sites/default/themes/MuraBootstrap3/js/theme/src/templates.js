this["mura"] = this["mura"] || {};
this["mura"]["templates"] = this["mura"]["templates"] || {};

this["mura"]["templates"]["example"] = window.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<h1>"
    + container.escapeExpression(((helper = (helper = helpers.exampleVar || (depth0 != null ? depth0.exampleVar : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"exampleVar","hash":{},"data":data}) : helper)))
    + "</h1>\n";
},"useData":true});