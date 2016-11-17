this["mura"] = this["mura"] || {};
this["mura"]["templates"] = this["mura"]["templates"] || {};

this["mura"]["templates"]["checkbox"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : {}, alias4=helpers.helperMissing, alias5="function";

  return "				<label class=\"checkbox\">\r\n				<input source=\""
    + alias2(alias1(((stack1 = (depths[1] != null ? depths[1].dataset : depths[1])) != null ? stack1.source : stack1), depth0))
    + "\" type=\"checkbox\" name=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" id=\"field-"
    + alias2(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias2(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" id=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "-"
    + alias2(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias3,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\r\n				"
    + alias2(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\r\n";
},"4":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n		<div class=\"mura-checkbox-group\">\r\n			<div class=\"mura-group-label\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\r\n"
    + ((stack1 = (helpers.eachCheck || (depth0 && depth0.eachCheck) || alias2).call(alias1,((stack1 = (depth0 != null ? depth0.dataset : depth0)) != null ? stack1.options : stack1),(depth0 != null ? depth0.selected : depth0),{"name":"eachCheck","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\r\n	</div>\r\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["checkbox_static"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : {}, alias4=helpers.helperMissing, alias5="function";

  return "				<label class=\"checkbox\">\r\n				<input type=\"checkbox\" name=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" id=\"field-"
    + alias2(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias2(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"value","hash":{},"data":data}) : helper)))
    + "\" id=\""
    + alias2(alias1((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" "
    + ((stack1 = helpers["if"].call(alias3,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,(depth0 != null ? depth0.selected : depth0),{"name":"if","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\r\n				"
    + alias2(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias4),(typeof helper === alias5 ? helper.call(alias3,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\r\n";
},"4":function(container,depth0,helpers,partials,data) {
    return " checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n		<div class=\"mura-checkbox-group\">\r\n			<div class=\"mura-group-label\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\r\n"
    + ((stack1 = (helpers.eachStatic || (depth0 && depth0.eachStatic) || alias2).call(alias1,(depth0 != null ? depth0.dataset : depth0),{"name":"eachStatic","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\r\n	</div>\r\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["dropdown"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "					<option data-isother=\""
    + alias4(((helper = (helper = helpers.isother || (depth0 != null ? depth0.isother : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"isother","hash":{},"data":data}) : helper)))
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(4, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"4":function(container,depth0,helpers,partials,data) {
    return "selected='selected'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\n			<select "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + ">\n"
    + ((stack1 = helpers.each.call(alias1,((stack1 = (depth0 != null ? depth0.dataset : depth0)) != null ? stack1.options : stack1),{"name":"each","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			</select>\n	</div>\n";
},"useData":true});

this["mura"]["templates"]["dropdown_static"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return "			<div class=\"mura-group-label\">"
    + container.escapeExpression(((helper = (helper = helpers.summary || (depth0 != null ? depth0.summary : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"summary","hash":{},"data":data}) : helper)))
    + "</div>\n";
},"5":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<option data-isother=\""
    + alias4(((helper = (helper = helpers.isother || (depth0 != null ? depth0.isother : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"isother","hash":{},"data":data}) : helper)))
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(6, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"6":function(container,depth0,helpers,partials,data) {
    return "selected='selected'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.summary : depth0),{"name":"if","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		<select "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + ">\n"
    + ((stack1 = (helpers.eachStatic || (depth0 && depth0.eachStatic) || alias2).call(alias1,(depth0 != null ? depth0.dataset : depth0),{"name":"eachStatic","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</select>\n	</div>\n";
},"useData":true});

this["mura"]["templates"]["error"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"label","hash":{},"data":data}) : helper)))
    + ": ";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\"mura-response-error\" data-field=\""
    + alias4(((helper = (helper = helpers.field || (depth0 != null ? depth0.field : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"field","hash":{},"data":data}) : helper)))
    + "\">"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.label : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + alias4(((helper = (helper = helpers.message || (depth0 != null ? depth0.message : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"message","hash":{},"data":data}) : helper)))
    + "</div>\r\n";
},"useData":true});

this["mura"]["templates"]["file"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\r\n	<input type=\"file\" "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "/>\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["form"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<form id=\"frm"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\" class=\""
    + ((stack1 = ((helper = (helper = helpers.formClass || (depth0 != null ? depth0.formClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"formClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" novalidate=\"novalidate\" enctype=\"multipart/form-data\">\n<div class=\"error-container-"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n<div class=\"field-container-"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n<div class=\"paging-container-"
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</div>\n	<input type=\"hidden\" name=\"formid\" value=\""
    + alias4(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\n</form>\n";
},"useData":true});

this["mura"]["templates"]["hidden"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<input type=\"hidden\" name=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + " value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\" />			\n";
},"useData":true});

this["mura"]["templates"]["list"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "					<option value=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<form>\n	<div class=\"mura-control-group\">\n		<label for=\"beanList\">Choose Entity:</label>	\n		<div class=\"form-group-select\">\n			<select type=\"text\" name=\"bean\" id=\"select-bean-value\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : {},depth0,{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			</select>\n		</div>\n	</div>\n	<div class=\"mura-control-group\">\n		<button type=\"button\" id=\"select-bean\">Go</button>\n	</div>\n</form>";
},"useData":true});

this["mura"]["templates"]["nested"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class=\"field-container-"
    + container.escapeExpression(((helper = (helper = helpers.objectid || (depth0 != null ? depth0.objectid : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"objectid","hash":{},"data":data}) : helper)))
    + "\">\r\n\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["paging"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<button class=\""
    + alias4(((helper = (helper = helpers["class"] || (depth0 != null ? depth0["class"] : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"class","hash":{},"data":data}) : helper)))
    + "\" type=\"button\" data-page=\""
    + alias4(((helper = (helper = helpers.page || (depth0 != null ? depth0.page : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"page","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</button> ";
},"useData":true});

this["mura"]["templates"]["radio"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<label for=\""
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "\" class=\"radio\">\n				<input type=\"radio\" name=\""
    + alias4(container.lambda((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "id\" id=\"field-"
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\n				"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\n";
},"4":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<div class=\"mura-radio-group\">\n			<div class=\"mura-group-label\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\n"
    + ((stack1 = helpers.each.call(alias1,((stack1 = (depth0 != null ? depth0.dataset : depth0)) != null ? stack1.options : stack1),{"name":"each","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\n	</div>\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["radio_static"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<label for=\""
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "\" class=\"radio\">\n				<input type=\"radio\" name=\""
    + alias4(container.lambda((depths[1] != null ? depths[1].name : depths[1]), depth0))
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.datarecordid || (depth0 != null ? depth0.datarecordid : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"datarecordid","hash":{},"data":data}) : helper)))
    + "\" value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\"  "
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isselected : depth0),{"name":"if","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\n				"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</label>\n";
},"4":function(container,depth0,helpers,partials,data) {
    return "checked='checked'";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\n		<div class=\"mura-radio-group\">\n			<div class=\"mura-group-label\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</div>\n"
    + ((stack1 = (helpers.eachStatic || (depth0 && depth0.eachStatic) || alias2).call(alias1,(depth0 != null ? depth0.dataset : depth0),{"name":"eachStatic","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</div>\n	</div>\n";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["section"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n<div class=\"mura-section\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</div>\r\n<div class=\"mura-divide\"></div>\r\n</div>";
},"useData":true});

this["mura"]["templates"]["success"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class=\"mura-response-success\">"
    + ((stack1 = ((helper = (helper = helpers.responsemessage || (depth0 != null ? depth0.responsemessage : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"responsemessage","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</div>\n";
},"useData":true});

this["mura"]["templates"]["table"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<option value=\""
    + alias4(((helper = (helper = helpers.num || (depth0 != null ? depth0.num : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"num","hash":{},"data":data}) : helper)))
    + "\" "
    + alias4(((helper = (helper = helpers.selected || (depth0 != null ? depth0.selected : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"selected","hash":{},"data":data}) : helper)))
    + ">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</option>";
},"3":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "					<option value=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\" "
    + alias4(((helper = (helper = helpers.selected || (depth0 != null ? depth0.selected : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"selected","hash":{},"data":data}) : helper)))
    + ">"
    + alias4(((helper = (helper = helpers.displayName || (depth0 != null ? depth0.displayName : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data}) : helper)))
    + "</option>\n";
},"5":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "			<th class='data-sort' data-value='"
    + alias4(((helper = (helper = helpers.column || (depth0 != null ? depth0.column : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"column","hash":{},"data":data}) : helper)))
    + "'>"
    + alias4(((helper = (helper = helpers.displayName || (depth0 != null ? depth0.displayName : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data}) : helper)))
    + "</th>\n";
},"7":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing;

  return "			<tr class=\"even\">\n"
    + ((stack1 = (helpers.eachColRow || (depth0 && depth0.eachColRow) || alias2).call(alias1,depth0,(depths[1] != null ? depths[1].columns : depths[1]),{"name":"eachColRow","hash":{},"fn":container.program(8, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "				<td>\n"
    + ((stack1 = (helpers.eachColButton || (depth0 && depth0.eachColButton) || alias2).call(alias1,depth0,{"name":"eachColButton","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "				</td>\n			</tr>\n";
},"8":function(container,depth0,helpers,partials,data) {
    return "					<td>"
    + container.escapeExpression(container.lambda(depth0, depth0))
    + "</td>\n";
},"10":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "				<button type=\"button\" class=\""
    + alias4(((helper = (helper = helpers.type || (depth0 != null ? depth0.type : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"type","hash":{},"data":data}) : helper)))
    + "\" data-value=\""
    + alias4(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"id","hash":{},"data":data}) : helper)))
    + "\" data-pos=\""
    + alias4(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"index","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + "</button>\n";
},"12":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.first : stack1), depth0))
    + "\">First</button>\n";
},"14":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.previous : stack1), depth0))
    + "\">Prev</button>\n";
},"16":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.next : stack1), depth0))
    + "\">Next</button>\n";
},"18":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "				<button class='data-nav' data-value=\""
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.last : stack1), depth0))
    + "\">Last</button>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, alias1=container.lambda, alias2=container.escapeExpression, alias3=depth0 != null ? depth0 : {}, alias4=helpers.helperMissing;

  return "	<div class=\"mura-control-group\">\n		<div id=\"filter-results-container\">\n			<div id=\"date-filters\">\n				<div class=\"control-group\">\n				  <label>From</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date1\" name=\"date1\" validate=\"date\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.fromdate : stack1), depth0))
    + "\">\n				  	<select id=\"hour1\" name=\"hour1\" class=\"mura-date\">"
    + ((stack1 = (helpers.eachHour || (depth0 && depth0.eachHour) || alias4).call(alias3,((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.fromhour : stack1),{"name":"eachHour","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</select></select>\n					</div>\n				</div>\n			\n				<div class=\"control-group\">\n				  <label>To</label>\n				  <div class=\"controls\">\n				  	<input type=\"text\" class=\"datepicker mura-date\" id=\"date2\" name=\"date2\" validate=\"date\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.todate : stack1), depth0))
    + "\">\n				  	<select id=\"hour2\" name=\"hour2\"  class=\"mura-date\">"
    + ((stack1 = (helpers.eachHour || (depth0 && depth0.eachHour) || alias4).call(alias3,((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.tohour : stack1),{"name":"eachHour","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</select></select>\n				   </select>\n					</div>\n				</div>\n			</div>\n					\n			<div class=\"control-group\">\n				<label>Keywords</label>\n				<div class=\"controls\">\n					<select name=\"filterBy\" class=\"mura-date\" id=\"results-filterby\">\n"
    + ((stack1 = (helpers.eachKey || (depth0 && depth0.eachKey) || alias4).call(alias3,(depth0 != null ? depth0.properties : depth0),((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.filterby : stack1),{"name":"eachKey","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "					</select>\n					<input type=\"text\" class=\"mura-half\" name=\"keywords\" id=\"results-keywords\" value=\""
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.filters : depth0)) != null ? stack1.filterkey : stack1), depth0))
    + "\">\n				</div>\n			</div>\n			<div class=\"form-actions\">\n				<button type=\"button\" class=\"btn\" id=\"btn-results-search\" ><i class=\"mi-bar-chart\"></i> View Data</button>\n				<button type=\"button\" class=\"btn\"  id=\"btn-results-download\" ><i class=\"mi-download\"></i> Download</button>\n			</div>\n		</div>\n	<div>\n\n	<ul class=\"metadata\">\n		<li>Page:\n			<strong>"
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.pageindex : stack1), depth0))
    + " of "
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.totalpages : stack1), depth0))
    + "</strong>\n		</li>\n		<li>Total Records:\n			<strong>"
    + alias2(alias1(((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.totalitems : stack1), depth0))
    + "</strong>\n		</li>\n	</ul>\n\n	<table style=\"width: 100%\" class=\"table\">\n		<thead>\n		<tr>\n"
    + ((stack1 = helpers.each.call(alias3,(depth0 != null ? depth0.columns : depth0),{"name":"each","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			<th></th>\n		</tr>\n		</thead>\n		<tbody>\n"
    + ((stack1 = helpers.each.call(alias3,((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.items : stack1),{"name":"each","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "		</tbody>\n		<tfoot>\n		<tr>\n			<td>\n"
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.first : stack1),{"name":"if","hash":{},"fn":container.program(12, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.previous : stack1),{"name":"if","hash":{},"fn":container.program(14, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.next : stack1),{"name":"if","hash":{},"fn":container.program(16, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias3,((stack1 = ((stack1 = (depth0 != null ? depth0.rows : depth0)) != null ? stack1.links : stack1)) != null ? stack1.last : stack1),{"name":"if","hash":{},"fn":container.program(18, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "			</td>\n		</tfoot>\n	</table>\n</div>";
},"useData":true,"useDepths":true});

this["mura"]["templates"]["textarea"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\"  id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\r\n	<textarea "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + ">"
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "</textarea>\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["textblock"] = this.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function";

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n<div class=\"mura-form-text\">"
    + ((stack1 = ((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</div>\r\n</div>";
},"useData":true});

this["mura"]["templates"]["textfield"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return " <ins>Required</ins>";
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return " placeholder=\""
    + container.escapeExpression(((helper = (helper = helpers.placeholder || (depth0 != null ? depth0.placeholder : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"placeholder","hash":{},"data":data}) : helper)))
    + "\"";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<div class=\""
    + ((stack1 = ((helper = (helper = helpers.inputWrapperClass || (depth0 != null ? depth0.inputWrapperClass : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"inputWrapperClass","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" id=\"field-"
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "-container\">\r\n	<label for=\""
    + alias4(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"name","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"label","hash":{},"data":data}) : helper)))
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.isrequired : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</label>\r\n	<input type=\"text\" "
    + ((stack1 = ((helper = (helper = helpers.commonInputAttributes || (depth0 != null ? depth0.commonInputAttributes : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"commonInputAttributes","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + " value=\""
    + alias4(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"value","hash":{},"data":data}) : helper)))
    + "\""
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.placeholder : depth0),{"name":"if","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "/>\r\n</div>\r\n";
},"useData":true});

this["mura"]["templates"]["view"] = this.mura.Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "	<li>\n		<strong>"
    + alias4(((helper = (helper = helpers.displayName || (depth0 != null ? depth0.displayName : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayName","hash":{},"data":data}) : helper)))
    + ": </strong> "
    + alias4(((helper = (helper = helpers.displayValue || (depth0 != null ? depth0.displayValue : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"displayValue","hash":{},"data":data}) : helper)))
    + " \n	</li>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class=\"mura-control-group\">\n<ul>\n"
    + ((stack1 = (helpers.eachProp || (depth0 && depth0.eachProp) || helpers.helperMissing).call(depth0 != null ? depth0 : {},depth0,{"name":"eachProp","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "</ul>\n<button type=\"button\" class=\"nav-back\">Back</button>\n</div>";
},"useData":true});