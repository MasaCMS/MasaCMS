this["Mura"] = this["Mura"] || {};
this["Mura"]["templates"] = this["Mura"]["templates"] || {};

this["Mura"]["templates"]["cta-container"] = window.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\"mura-cta__container\"\n	data-mura-cta-anchorx=\""
    + alias4(((helper = (helper = helpers.anchorx || (depth0 != null ? depth0.anchorx : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"anchorx","hash":{},"data":data}) : helper)))
    + "\"\n	data-mura-cta-anchory=\""
    + alias4(((helper = (helper = helpers.anchory || (depth0 != null ? depth0.anchory : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"anchory","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n";
},"useData":true});

this["Mura"]["templates"]["cta-instance"] = window.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div id=\"mura-cta-"
    + alias4(((helper = (helper = helpers.instanceid || (depth0 != null ? depth0.instanceid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"instanceid","hash":{},"data":data}) : helper)))
    + "\" class=\"mura-cta__item\"\n	data-mura-cta-animate=\""
    + alias4(((helper = (helper = helpers.animate || (depth0 != null ? depth0.animate : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"animate","hash":{},"data":data}) : helper)))
    + "\"\n	data-mura-cta-animatespeed=\""
    + alias4(((helper = (helper = helpers.animatespeed || (depth0 != null ? depth0.animatespeed : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"animatespeed","hash":{},"data":data}) : helper)))
    + "\"\n	data-mura-cta-type=\""
    + alias4(((helper = (helper = helpers.type || (depth0 != null ? depth0.type : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"type","hash":{},"data":data}) : helper)))
    + "\"\n>\n	<div class=\"mura-cta__item__wrapper\"\n		data-mura-cta-size=\""
    + alias4(((helper = (helper = helpers.width || (depth0 != null ? depth0.width : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"width","hash":{},"data":data}) : helper)))
    + "\">\n		<div class=\"mura-cta__item__content\"></div>\n		<div class=\"mura-cta__item__dismiss\"></div>\n	</div>\n</div>\n";
},"useData":true});

this["Mura"]["templates"]["cta"] = window.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class=\"mura-cta\">\n</div>\n";
},"useData":true});