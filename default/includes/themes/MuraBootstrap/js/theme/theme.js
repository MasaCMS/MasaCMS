$(document).ready(function() {

	//	Append a caret to any submenu in the navigation with children
	$('li.dropdown > a.dropdown-toggle').each(function(index, element) {
		$(this).append('<b class="caret"></b>');
	});

	//Add Hover effect to menus
	$('ul.nav li.dropdown').hover(function() {
		$(this).find('.dropdown-menu').stop(true, true).delay(100).fadeIn();
	}, function() {
		$(this).find('.dropdown-menu').stop(true, true).delay(100).fadeOut();
	});

	$('.submenu','#navStandard').scrollspy();

});