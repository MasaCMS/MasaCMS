jQuery(document).ready(function($) {

	//	Append a caret to any submenu in the navigation with children
	$('#navPrimary:first-child > li.dropdown > a.dropdown-toggle').each(function(index, element) {
		$(this).append('<b class="caret"></b>');
	});
});