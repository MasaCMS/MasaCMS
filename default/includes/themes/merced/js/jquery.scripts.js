$(document).ready(function(){


	// redefine Cycle's updateActivePagerLink function - http://www.malsup.com/jquery/cycle/pager7.html
	$.fn.cycle.updateActivePagerLink = function(pager, currSlideIndex) { 
	    $(pager).find('li').removeClass('activeLI') 
	        .filter('li:eq('+currSlideIndex+')').addClass('activeLI'); 
	};

	// activate slideshow
	$('#slideshow ul').after('<ol></ol>').cycle({ 
		timeout: 3000,
		pager: '#slideshow ol',
		pagerAnchorBuilder: function(idx, slide) {
			return '<li><a href="#">' + (idx+1) + '</a></li>'; 
		} 
	});


});