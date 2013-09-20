/*!
 * Tag Selector plugin for jQuery: Facilitates selecting multiple tags by extending jQuery UI Autocomplete.
 * You may use Tag Selector under the terms of either the MIT License or the GNU General Public License (GPL) Version 2.
 * https://petprojects.googlecode.com/svn/trunk/MIT-LICENSE.txt
 * https://petprojects.googlecode.com/svn/trunk/GPL-LICENSE.txt
 */
(function($) {

	$.fn.tagSelector = function(source, name) {
		return this.each(function() {
				var selector = $(this),
					input = $('input[type=text]', this);
				selector.click(function() { input.focus(); })
					.delegate('.tag a', 'click', function() {
						$(this).parent().remove();
					});
				
				input.keydown(function(e) {
						
						if (e.keyCode === $.ui.keyCode.TAB && $(this).data('autocomplete').menu.active){
							e.preventDefault();
						}

						if(e.keyCode === $.ui.keyCode.ENTER){ //&& !$(this).data('autocomplete').menu.active){
							e.preventDefault();
							input.val($.trim(input.val()));
							
							if(input.val() != ''){
								var tag = $('<span class="tag"/>')
									.text(input.val() + ' ')
									.append('<a><i class="icon-remove-sign"></i></a>')
									.append($('<input type="hidden"/>').attr('name', name).val(input.val()))
									.insertBefore(input);
							}

							input.val('');
						}
					})

					.autocomplete({
						minLength: 0,
						source: source,
						select: function(event, ui) {
							//<span class=tag>@jcarrascal <a>Ã—</a><input type=hidden name=tag value=1/></span>
							var tag = $('<span class="tag"/>')
								.text(ui.item.toString() + ' ')
								.append('<a><i class="icon-remove-sign"></i></a>')
								.append($('<input type="hidden"/>').attr('name', name).val(ui.item.id))
								.insertBefore(input);

								input.val('');
							
							return true;
						}
					});

				input.data('ui-autocomplete')._renderItem = function(ul, item) {
						return $('<li/>')
							.data('item.autocomplete', item)
							.append($('<a/>').text(item.toString()))
							.appendTo(ul);
					};

				input.data('ui-autocomplete')._resizeMenu = function(ul, item) {
						var ul = this.menu.element;
						ul.outerWidth(Math.max(
							ul.width('').outerWidth(),
							selector.outerWidth()
						));
					};
			});
	};

})(jQuery);