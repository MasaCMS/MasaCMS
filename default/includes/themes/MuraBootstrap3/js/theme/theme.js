this["mura"] = this["mura"] || {};
this["mura"]["templates"] = this["mura"]["templates"] || {};

this["mura"]["templates"]["example"] = window.mura.Handlebars.template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<h1>"
    + container.escapeExpression(((helper = (helper = helpers.exampleVar || (depth0 != null ? depth0.exampleVar : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : {},{"name":"exampleVar","hash":{},"data":data}) : helper)))
    + "</h1>\n";
},"useData":true});;jQuery(document).ready(function($) {

	//	Append a caret to any submenu in the navigation with children
	$('#navPrimary:first-child > li.dropdown > a.dropdown-toggle').each(function(index, element) {
		$(this).append('<b class="caret"></b>');
	});
	$('#myTooltip').tooltip();

	// Example of how to append a lock icon to a restricted primary nav item
	//$('#navProtectedArea a').append('&nbsp;<i class="fa fa-lock"></i>');

	$('.back-to-top').on('click', function(e) {
		$('body,html').animate({
			scrollTop:0
		}, 800);
		return false;
	});

});