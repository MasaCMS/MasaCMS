(function(jQuery) {
	jQuery.fn.jsonForm = function(settings) {
		var settings		= jQuery.extend({},jQuery.fn.jsonForm.defaults,settings);
		var self			= this;
		var $form			= jQuery(this);

		this.source			= settings.source;

		// I define the type of ways in which a store can be
		// changed in a mutation event.
		self.jsonFormEventKind = {
			SELECT: "selected",
			LOADED: "loaded",
			UPDATE: "update"
		}; 

		doBind = function( frm,src ) {
			if(frm)
				$form = jQuery(frm);

			if(src)
				self.source = src;
			
			var $fieldArray = jQuery(":input",$form);
			var $field = '';
			var index = '';

			jQuery.each( 
				$fieldArray,
				function( index ) {
					$field = jQuery($fieldArray[index]);

					$field.bind('focus.jsonform',function(){
						trigger({
							type: "jsonformField",
							kind: self.jsonFormEventKind.SELECT,
							form: self,
							field: $field,
							object: this,
							data: self.source,
							value: jQuery(this).val()
						});
					});


					if( settings.bindTo == 'all' || $field.attr(settings.bindTo) ) {
						var item = $field.attr(settings.bindBy);
						
						if (( $field.attr('type') == 'text' && !$field.attr('disabled') ) || $field.is('textarea') ) {
							$field.val( self.source[item] );

							$field.unbind('keyup.jsonform');

							if(settings.createOnDataNull || self.source[item] != undefined)
								self.source[item] = jQuery(this).val();

							$field.bind('keyup.jsonform',function(){
								if( self.source[item] == jQuery(this).val() )
									return;
								
								trigger({
									type: "jsonformField",
									kind: self.jsonFormEventKind.UPDATE,
									form: self,
									field: $field,
									data: self.source,
									item: item,
									object: this,
									value: jQuery(this).val()
								});
								if (settings.autoChange) {
									if(settings.createOnNull || self.source[item] != undefined)
										self.source[item] = jQuery(this).val();
								}
							});
						}
						else if($field.attr('type') == 'hidden' || ( $field.attr('type') == 'text' && $field.attr('disabled') ) ) {
							$field.val( self.source[item] );

							$field.unbind('change.jsonform');

							if(settings.createOnDataNull || self.source[item] != undefined)
								self.source[item] = jQuery(this).val();

							$field.bind('change.jsonform',function(){
								if( self.source[item] == jQuery(this).val() )
									return;
								
								trigger({
									type: "jsonformField",
									kind: self.jsonFormEventKind.UPDATE,
									form: self,
									field: $field,
									data: self.source,
									item: item,
									object: this,
									value: jQuery(this).val()
								});
								if (settings.autoChange) {
									if(settings.createOnNull || self.source[item] != undefined)
										self.source[item] = jQuery(this).val();
								}
							});
						}
						else if ($field.attr('type') == 'checkbox') {
							$field.unbind('click.jsonform');

							if( self.source[item] == 1)
								$field.attr("CHECKED", "CHECKED");
							else
								$field.removeAttr("checked");							

							if(settings.createOnDataNull || self.source[item] != undefined)
								self.source[item] = jQuery(this).is(':checked') ? jQuery(this).val() : 0;

							$field.bind('click.jsonform',function() {
								trigger({
									type: "jsonformField",
									kind: self.jsonFormEventKind.UPDATE,
									form: self,
									field: $field,
									data: self.source,
									item: item,
									object: this,
									value: jQuery(this).val()
								});
								if(settings.autoChange) {
									if(settings.createOnNull || self.source[item] != undefined)
										self.source[item] = jQuery(this).is(':checked') ? jQuery(this).val() : 0;
								}
							});
						} else if ($field.is("select")) {
							$field.unbind('change.jsonform');
							$field.val( self.source[item] );

							if(settings.createOnDataNull || self.source[item] != undefined)
								self.source[item] = jQuery(this).val();

							$field.bind('change.jsonform',function(){
								trigger({
									type: "jsonformField",
									kind: self.jsonFormEventKind.UPDATE,
									form: self,
									field: $field,
									data: self.source,
									item: item,
									object: this,
									value: jQuery(this).val()
								});
								if (settings.autoChange) {
									if(settings.createOnNull || self.source[item] != undefined) {
										self.source[item] = jQuery(this).val();
									}
								}
							});
						} else if ($field.attr('type') == 'radio') {
							$field.unbind('click.jsonform');

							if( $field.val() == self.source[item])
								$field.attr("CHECKED","CHECKED");
							else
								$field.removeAttr("checked");							

							if(settings.createOnDataNull || self.source[item] != undefined)
								self.source[item] = jQuery(this).val();

							$field.bind('click.jsonform',function() {
								trigger({
									type: "jsonformField",
									kind: self.jsonFormEventKind.UPDATE,
									form: self,
									field: $field,
									data: self.source,
									item: item,
									object: this,
									value: jQuery(this).val()
								});
								if(settings.autoChange) {
									if(settings.createOnNull || self.source[item] != undefined)
										self.source[item] = jQuery(this).val();
								}
							});
						} else {
//							alert('not found: ' + item + " :: " + $field.attr('type'));
						}
					}
				}
			);

			trigger({
				type: "jsonformForm",
				kind: self.jsonFormEventKind.LOADED,
				form: self,
				data: self.source
			});
		}

		function trigger( options ) {
			// Pass the trigger off to the event manager.
			$form.trigger( options.type,arguments );
		} 			

		if(settings.autoBind)
			doBind();
	};

	jQuery.jsonForm = {};

	jQuery.fn.jsonForm.defaults = {
		source				: {},
		root				: '',
		autoChange			: true,
		autoBind			: true,
		bindTo				: 'all',
		bindBy				: 'name',
		bindPattern			: '',
		createOnNull		: false,
		createOnDataNull	: false
	};

	jQuery.jsonForm.setSource = function( tgt,source ) {
		doBind(tgt,source);
	};
	
})(jQuery);
