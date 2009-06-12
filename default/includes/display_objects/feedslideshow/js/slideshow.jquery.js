$(document).ready(function(){

			// redefine Cycle's updateActivePagerLink function 
			$.fn.cycle.updateActivePagerLink = function(pager, currSlideIndex) { 
			    $(pager).find('li').removeClass('activeLI') 
			        .filter('li:eq('+currSlideIndex+')').addClass('activeLI'); 
			};

			$('.svSlideshow > div').each(function(){						// Loop through each slideshow individually
				//$(this).parent().attr({id: $(this).attr('id') + 'SS'});			// take ID of the index, append 'SS', and apply new ID to wrapping DIV.svSlideshow
				$(this).after('<ol class="svPager"></ol>').cycle({				// create pager nav after index DIV. Then start Cycle 
					slideExpr: 'dl',												// target only DL elements as slides (to avoid the H3)
					pager: $('.svPager', this.parentNode),							// tell Cycle about the pager nav
					pagerAnchorBuilder: function(idx, slide) {						// populate pager nav
						return '<li><a href="#">' + (idx+1) + '</a></li>';				// 'idx' is the zero-indexed array position, so we add 1 to it
					}
				});
			})
		
		
		});