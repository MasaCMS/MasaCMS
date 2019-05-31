<cfif thisTag.ExecutionMode eq 'start'>
	<cfsilent>
		<cfscript>
			if(server.coldfusion.productname != 'ColdFusion Server'){
				backportdir='';
				include "/mura/backport/backport.cfm";
			} else {
				backportdir='/mura/backport/';
				include "#backportdir#backport.cfm";
			}
		</cfscript>

		<cfset $=application.serviceFactory.getBean("muraScope").init(session.siteid)>

		<cfif not isdefined('attributes.params')>
			<cfif isDefined("form.params") and isJSON(form.params)>
				<cfset attributes.params=deserializeJSON(form.params)>
			<cfelse>
				<cfset attributes.params={}>
			</cfif>
		</cfif>

		<cfparam name="attributes.configurable" default="true">
	 	<cfparam name="attributes.basictab" default="true">
		<cfparam name="attributes.params.class" default="">
		<cfparam name="attributes.params.cssclass" default="">
		<cfparam name="attributes.params.metacssclass" default="">
		<cfparam name="attributes.params.metacssid" default="">
		<cfparam name="attributes.params.contentcssclass" default="">
		<cfparam name="attributes.params.contentcssid" default="">
		<cfparam name="attributes.params.cssid" default="">
		<cfparam name="attributes.params.label" default="">
		<cfparam name="attributes.params.object" default="">

		<cfparam name="request.hasbasicoptions" default="false">
		<cfparam name="request.hasmetaoptions" default="false">
		<cfparam name="request.haspositionoptions" default="false">
		<cfparam name="attributes.params.isbodyobject" default="false">

		<cfparam name="request.textcoloroptions" default="">
		<cfparam name="request.backgroundcoloroptions" default="">
		<cfif structKeyExists($.getContentRenderer(),'textColorOptions')>
			<cfset request.textColorOptions = $.getContentRenderer().textColorOptions>
		</cfif>
		<cfif structKeyExists($.getContentRenderer(),'backgroundColorOptions')>
			<cfset request.backgroundColorOptions = $.getContentRenderer().backgroundColorOptions>
		</cfif>

		<cfset contentcontainerclass=esapiEncode("javascript",$.getContentRenderer().expandedContentContainerClass)>

		<cfif not (isDefined("attributes.params.cssstyles") and isStruct(attributes.params.cssstyles))>
			<cfif isDefined("attributes.params.cssstyles") and isJSON(attributes.params.cssstyles)>
				<cfset attributes.params.cssstyles=deserializeJSON(attributes.params.cssstyles)>
			<cfelse>
				<cfset attributes.params.cssstyles={}>
			</cfif>
		</cfif>

		<cfif not (isDefined("attributes.params.metacssstyles") and isStruct(attributes.params.metacssstyles))>
			<cfif isDefined("attributes.params.metacssstyles") and isJSON(attributes.params.metacssstyles)>
				<cfset attributes.params.metacssstyles=deserializeJSON(attributes.params.metacssstyles)>
			<cfelse>
				<cfset attributes.params.metacssstyles={}>
			</cfif>
		</cfif>
		<cfif not (isDefined("attributes.params.contentcssstyles") and isStruct(attributes.params.contentcssstyles))>
			<cfif isDefined("objectParams.contentcssstyles") and isJSON(attributes.params.contentcssstyles)>
				<cfset attributes.params.contentcssstyles=deserializeJSON(attributes.params.contentcssstyles)>
			<cfelse>
				<cfset attributes.params.contentcssstyles={}>
			</cfif>
		</cfif>

		<cfif not request.hasbasicoptions>
		<cfset request.hasbasicoptions=attributes.basictab>
		</cfif>

		<cfif not listFindNoCase('folder,gallery,calendar',attributes.params.object) and not (isBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
			<cfset request.haspositionoptions = true>
		</cfif>

		<cfscript>
			attributes.positionoptions = [
					{value='',label='Auto'}
					,{value='mura-one', label='One Twelfth'}
					,{value='mura-two', label='One Sixth'}
					,{value='mura-three', label='One Fourth'}
					,{value='mura-four', label='One Third'}
					,{value='mura-five', label='Five Twelfths'}
					,{value='mura-six', label='One Half'}
					,{value='mura-seven', label='Seven Twelfths'}
					,{value='mura-eight', label='Two Thirds'}
					,{value='mura-nine', label='Three Fourths'}
					,{value='mura-ten', label='Five Sixths'}
					,{value='mura-eleven', label='Eleven Twelfths'}
					,{value='mura-twelve', label='Full'}
					,{value='mura-expanded', label='Expanded'}
				];

		</cfscript>

	</cfsilent>

	<cfif $.getContentRenderer().useLayoutManager()>
		<cfoutput>
		<cfset request.muraconfiguratortag=true>
		<div id="availableObjectContainer"<cfif not attributes.configurable> style="display:none"</cfif>>
			<div class="mura-panel-group" id="configurator-panels" role="tablist" aria-multiselectable="true">
			<!--- Basic panel --->
			<cfif request.hasbasicoptions>
			<div class="mura-panel panel">
				<div class="mura-panel-heading" role="tab" id="heading-basic">
					<h4 class="mura-panel-title">
						<a class="collapse" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-basic" aria-expanded="true" aria-controls="panel-basic">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.basic')#
						</a>
					</h4>
				</div>
				<div id="panel-basic" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading-basic">
					<div class="mura-panel-body">
			</cfif>
		</cfoutput>
	</cfif>
<!--- /end start mode --->
<cfelseif thisTag.ExecutionMode eq 'end'>
	<cfset $=application.serviceFactory.getBean("muraScope").init(session.siteid)>

	<cfif $.getContentRenderer().useLayoutManager()>

	<cfoutput>

		<!--- close the basic or style panel --->
		<cfif request.hasbasicoptions>
				</div> <!--- /end  mura-panel-collapse --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end panel --->
		</cfif>

		<!--- style --->
		<div class="mura-panel panel">
			<div class="mura-panel-heading" role="tab" id="heading-style">
				<h4 class="mura-panel-title">
					<!--- todo: rbkey for style --->
					<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style" aria-expanded="false" aria-controls="panel-style">
						Style
					</a>
				</h4>
			</div>
			<div id="panel-style" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-style">
				<div class="mura-panel-body">
					<div class="container">
							<!--- nested panels --->
							<div class="mura-control-group">
								<!--- todo: rbkeys for box labels --->
								<div class="panel-gds-box" id="panel-gds-outer" data-gdsel="panel-style-outer"><span>Module</span>
									<cfif request.hasmetaoptions>
										<div class="panel-gds-box" id="panel-gds-meta" data-gdsel="panel-style-label"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.label')#</span></div>
									</cfif>
									<div class="panel-gds-box" id="panel-gds-inner" data-gdsel="panel-style-inner"><span>Content</span></div>
								</div>
								<div class="mura-panel-group" id="style-panels" role="tablist" aria-multiselectable="true">
									<!--- todo: merge this included content back to this file --->
									<cfinclude template="objectconfiguratorpanels.cfm">
								</div> <!--- /end panel group --->
							</div> <!--- /end mura control group --->
					</div> <!--- /end container --->
				</div> <!--- /end  mura-panel-body --->
			</div> <!--- /end  mura-panel-collapse --->
		</div> <!--- /end style panel --->
	</div><!--- /end panels --->
	</cfoutput>
</div> <!--- /end availableObjectContainer --->

	<script>
		$(function(){

			var inited=false;

			$('.panel-gds-box').on('click',function(){
				var gdspanel = $(this).attr('data-gdsel');
				var gdstarget = $('#' + gdspanel);
				$('.panel-gds-box').removeClass('active');
				$(this).addClass('active');
				$('#style-panels').find('.panel-collapse.in').removeClass('in');
				$(gdstarget).addClass('in');
				return false;
			})
			$('#style-panels').addClass('no-header');
			$('#panel-gds-outer').trigger('click');

			function setPlacementVisibility(){
				var classInput=$('input[name="class"]');
				classInput.val('');

	  			var alignment=$('select[name="alignment"]');
	  			classInput.val(alignment.val());

	  			var width=$('select[name="width"]');
  				if(classInput.val() ){
  					classInput.val(classInput.val() + ' ' + width.val());
  				} else {
  					classInput.val(width.val());
  				}
					classInput.val($.trim(classInput.val()));

		  		var contentcssclass=$('input[name="contentcssclass"]');
					var expandedContentContainerClass='<cfoutput>#contentcontainerclass#</cfoutput>';
					var contentcssclassArray=contentcssclass.val().split(' ');
					var constraincontent=$('select[name="constraincontent"]');

					if(constraincontent.length){
						if(width.val()=='mura-expanded'){
							$('.constraincontentcontainer').show();
							if(constraincontent.val()=='constrain'){
								if(contentcssclassArray.indexOf(expandedContentContainerClass)==-1){
									if(contentcssclassArray.length){
										contentcssclass.val(contentcssclass.val() + ' ' + expandedContentContainerClass);
									} else {
										contentcssclass.val(expandedContentContainerClass);
									}
								}
							} else {
								if(contentcssclassArray.indexOf(expandedContentContainerClass) > -1){
									for( var i = 0; i < contentcssclassArray.length; i++){
										if ( contentcssclassArray[i] === expandedContentContainerClass) {
											contentcssclassArray.splice(i, 1);
										}
									}
								}
								contentcssclass.val(contentcssclassArray.join(' '));

							}
						} else {
							$('.constraincontentcontainer').hide();
							if(contentcssclassArray.indexOf(expandedContentContainerClass) > -1){
								for( var i = 0; i < contentcssclassArray.length; i++){
									if ( contentcssclassArray[i] === expandedContentContainerClass) {
										contentcssclassArray.splice(i, 1);
									}
								}
							}
							contentcssclass.val(contentcssclassArray.join(' '));
						}

						contentcssclass.val($.trim(contentcssclass.val()));
					}

					var cssclassInput=$('input[name="cssclass"]');

		  		if(cssclassInput.val()){
	  				if(classInput.val() ){
	  					classInput.val(classInput.val() + ' ' + cssclassInput.val());
	  				} else {
	  					classInput.val(cssclassInput.val());
	  				}

						classInput.val($.trim(classInput.val()));
		  		}

					if(inited && typeof updateDraft == 'function'){
						updateDraft();
					}
			}

			setPlacementVisibility();

			$('#globalSettingsBtn').click(function(){
				$('#availableObjectContainer').hide();
				$('#objectSettingsBtn').show();
				$('#globalObjectParams').fadeIn();
				$('#globalSettingsBtn').hide();
			});

			$('#objectSettingsBtn').click(function(){
				$('#availableObjectContainer').fadeIn();
				$('#objectSettingsBtn').hide();
				$('#globalObjectParams').hide();
				$('#globalSettingsBtn').show();
			});

			$('.mura-ui-link').on('click',function(){
				var targetEl = $(this).attr('data-reveal');
				if (targetEl.length > 0){
					$('#' + targetEl).toggle();
				}
				return false;
			})

			$('input[name="cssclass"],select[name="alignment"],select[name="width"],select[name="offset"],select[name="constraincontent"]').on('change', function() {
				setPlacementVisibility();
			});

			// padding
			function updateOuterPadding(){
				var t = $('#outerpaddingtop').val().replace(/[^0-9]/g,'');
				var r = $('#outerpaddingright').val().replace(/[^0-9]/g,'');
				var b = $('#outerpaddingbottom').val().replace(/[^0-9]/g,'');
				var l =$('#outerpaddingleft').val().replace(/[^0-9]/g,'');
				var u = $('#outerpaddinguom').val();
				if (t.length){ $('#outerpaddingtopval').val(t + u); } else { $('#outerpaddingtopval').val(''); }
				if (r.length){ $('#outerpaddingrightval').val(r + u); } else { $('#outerpaddingrightval').val(''); }
				if (b.length){ $('#outerpaddingbottomval').val(b + u); } else { $('#outerpaddingbottomval').val(''); }
				if (l.length){ $('#outerpaddingleftval').val(l + u); } else { $('#outerpaddingleftval').val(''); }
				if (t == r && r == b & b == l){
					$('#outerpaddingall').val(t);
				} else {
					$('#outerpaddingall').val('');
					$('#outerpaddingadvanced').show();
				}
				if(inited){
					$('#outerpaddingtopval').trigger('change');
				}
			}

			$('#outerpaddingall').on('keyup', function(){
				var v = $('#outerpaddingall').val().replace(/[^0-9]/g,'');
				$('#outerpaddingadvanced').hide();
				$('#outerpaddingtop').val(v);
				$('#outerpaddingleft').val(v);
				$('#outerpaddingright').val(v);
				$('#outerpaddingbottom').val(v);
			})

			$('#outerpaddingtop,#outerpaddingright,#outerpaddingbottom,#outerpaddingleft,#outerpaddingall').on('keyup', function(){
				updateOuterPadding();
			})

			$('#outerpaddinguom').on('change',function(){
				updateOuterPadding();
			});

			updateOuterPadding();

			$('#outerpaddingtop,#outerpaddingright,#outerpaddingbottom,#outerpaddingleft,#outerpaddingall').on('keyup', function(){
				updateOuterPadding();
			})

			$('#outerpaddinguom').on('change',function(){
				updateOuterPadding();
			});

			updateOuterPadding();

			// margin
			function updateOuterMargin(){
				var t = $('#outermargintop').val().replace(/[^0-9]/g,'');
				var r = $('#outermarginright').val().replace(/[^0-9]/g,'');
				var b = $('#outermarginbottom').val().replace(/[^0-9]/g,'');
				var l =$('#outermarginleft').val().replace(/[^0-9]/g,'');
				var u = $('#outermarginuom').val();
				if (t.length){ $('#outermargintopval').val(t + u); } else { $('#outermargintopval').val(''); }
				if (r.length){ $('#outermarginrightval').val(r + u); } else { $('#outermarginrightval').val(''); }
				if (b.length){ $('#outermarginbottomval').val(b + u); } else { $('#outermarginbottomval').val(''); }
				if (l.length){ $('#outermarginleftval').val(l + u); } else { $('#outermarginleftval').val(''); }
				if (t == r && r == b & b == l){
					$('#outermarginall').val(t);
				} else {
					$('#outermarginall').val('');
					$('#outermarginadvanced').show();

				}
				if(inited){
					$('#outermargintopval').trigger('change');
				}
			}

			$('#outermarginall').on('keyup', function(){
				var v = $('#outermarginall').val().replace(/[^0-9]/g,'');
				$('#outermarginadvanced').hide();
				$('#outermargintop').val(v);
				$('#outermarginleft').val(v);
				$('#outermarginright').val(v);
				$('#outermarginbottom').val(v);
			})

			$('#outermargintop,#outermarginright,#outermarginbottom,#outermarginleft,#outermarginall').on('keyup', function(){
				updateOuterMargin();
			});

			$('#outermarginuom').on('change',function(){
				updateOuterMargin();
			});

			updateOuterMargin();
			
			function updateInnerPadding(){
				var t = $('#innerpaddingtop').val().replace(/[^0-9]/g,'');
				var r = $('#innerpaddingright').val().replace(/[^0-9]/g,'');
				var b = $('#innerpaddingbottom').val().replace(/[^0-9]/g,'');
				var l =$('#innerpaddingleft').val().replace(/[^0-9]/g,'');
				var u = $('#innerpaddinguom').val();
				if (t.length){ $('#innerpaddingtopval').val(t + u); } else { $('#innerpaddingtopval').val(''); }
				if (r.length){ $('#innerpaddingrightval').val(r + u); } else { $('#innerpaddingrightval').val(''); }
				if (b.length){ $('#innerpaddingbottomval').val(b + u); } else { $('#innerpaddingbottomval').val(''); }
				if (l.length){ $('#innerpaddingleftval').val(l + u); } else { $('#innerpaddingleftval').val(''); }
				if (t == r && r == b & b == l){
					$('#innerpaddingall').val(t);
				} else {
					$('#innerpaddingall').val('');
					$('#innerpaddingadvanced').show();
				}
				if(inited){
					$('#innerpaddingtopval').trigger('change');
				}
			}

			$('#innerpaddingall').on('keyup', function(){
				var v = $('#innerpaddingall').val().replace(/[^0-9]/g,'');
				$('#innerpaddingadvanced').hide();
				$('#innerpaddingtop').val(v);
				$('#innerpaddingleft').val(v);
				$('#innerpaddingright').val(v);
				$('#innerpaddingbottom').val(v);
			})

			$('#innerpaddingtop,#innerpaddingright,#innerpaddingbottom,#innerpaddingleft,#innerpaddingall').on('keyup', function(){
				updateInnerPadding();
			})

			$('#innerpaddinguom').on('change',function(){
				updateInnerPadding();
			});

			updateInnerPadding();

 			// margin
			function updateInnerMargin(){
				var t = $('#innermargintop').val().replace(/[^0-9]/g,'');
				var r = $('#innermarginright').val().replace(/[^0-9]/g,'');
				var b = $('#innermarginbottom').val().replace(/[^0-9]/g,'');
				var l =$('#innermarginleft').val().replace(/[^0-9]/g,'');
				var u = $('#innermarginuom').val();
				if (t.length){ $('#innermargintopval').val(t + u); } else { $('#innermargintopval').val(''); }
				if (r.length){ $('#innermarginrightval').val(r + u); } else { $('#innermarginrightval').val(''); }
				if (b.length){ $('#innermarginbottomval').val(b + u); } else { $('#innermarginbottomval').val(''); }
				if (l.length){ $('#innermarginleftval').val(l + u); } else { $('#innermarginleftval').val(''); }
				if (t == r && r == b & b == l){
					$('#innermarginall').val(t);
				} else {
					$('#innermarginall').val('');
					$('#innermarginadvanced').show();

				}
				if(inited){
					$('#innermargintopval').trigger('change');
				}
			}

			$('#innermarginall').on('keyup', function(){
				var v = $('#innermarginall').val().replace(/[^0-9]/g,'');
				$('#innermarginadvanced').hide();
				$('#innermargintop').val(v);
				$('#innermarginleft').val(v);
				$('#innermarginright').val(v);
				$('#innermarginbottom').val(v);
			})

			$('#innermargintop,#innermarginright,#innermarginbottom,#innermarginleft,#innermarginall').on('keyup', function(){
				updateInnerMargin();
			});

			$('#innermarginuom').on('change',function(){
				updateInnerMargin();
			});

			updateInnerMargin();

			// background color
			function updateOuterBgColor(v){
				var swatchColor = v;
				var swatchEl = $('#outerbackgroundcustom').find('i.mura-colorpicker-swatch');
				if (v == 'custom' <cfif not(isArray(request.backgroundcoloroptions) and arrayLen(request.backgroundcoloroptions))> || true</cfif>){
					$('#outerbackgroundcustom').show();
				} else if (v == 'none'){
					swatchColor = 'transparent'
					$('#outerbackgroundcustom').hide();
					$('#outerbackgroundcolor').val('');
				} else {
					$('#outerbackgroundcustom').hide();
					$('#outerbackgroundcolor').val(v);
				}
				swatchEl.css('background-color',swatchColor);
			}

			$('#outerbackgroundcolorsel').on('change',function(){
				var v = $(this).val();
				updateOuterBgColor(v);
			});

			updateOuterBgColor($('#outerbackgroundcolorsel').val());

			// background image
			$('#outerbackgroundimageurl').on('change',function(){
				var v = $(this).val();
				var str = "";
				if (v.length > 3){
					str = "url('" + v + "')";
					$('.css-bg-option').show();
				} else {
					$('.css-bg-option').hide();
				}
				if(inited){
					$('#outerbackgroundimage').val(str).trigger('change');
				}
			});

			var v = $('#outerbackgroundimageurl').val();
			var str = "";
			if (v.length > 3){
				str = "url('" + v + "')";
				$('.css-bg-option').show();
			} else {
				$('.css-bg-option').hide();
			}

			//commented out to not intially trigger reseting of rendered object
			//$('#outerbackgroundimageurl').trigger('change');

			// background position x/y
			function updatePositionSelection(sel){
				var v = $(sel).val();
				var el = $(sel).attr('data-numfield');
				if (v == 'px' || v == '%'){
					$('#' + el).show();
				} else {
					$('#' + el).hide();
				}
			}

			$('#outerbackgroundpositiony,#outerbackgroundpositionynum').on('change',function(){
				var el = $('#outerbackgroundpositionyval');
				var str = $('#outerbackgroundpositiony').val();
				var num = $('#outerbackgroundpositionynum').val();
				if (num.length > 0){
					str = num + str;
				}
				$(el).val(str).trigger('change');
			});

			$('#outerbackgroundpositionx,#outerbackgroundpositionxnum').on('change',function(){
				var el = $('#outerbackgroundpositionxval');
				var str = $('#outerbackgroundpositionx').val();
				var num = $('#outerbackgroundpositionxnum').val();
				if (num.length > 0){
					str = num + str;
				}
				$(el).val(str).trigger('change');
			});

			$('#outerbackgroundpositionx,#outerbackgroundpositiony').on('change',function(){
				updatePositionSelection($(this));
			});

			$('#outerbackgroundpositionx,#outerbackgroundpositiony').each(function(){
				updatePositionSelection($(this));
			});

			// numeric input - select on focus
			$('#configuratorContainer input.numeric').on('click', function(){
				$(this).select();
			});
			// numeric input - restrict value
			$('#configuratorContainer input.numeric').on('keyup', function(){
				var v = $(this).val().replace(/[^0-9]/g,'');
				$(this).val(v);
			});

			// range sliders
			<!--- todo: this or jquery-ui range slider --->
			<!---
			var rangeSlider = $("input.mura-rangeslider").bootstrapSlider();
			$(rangeSlider).on('change',function(){
				var v = rangeSlider.bootstrapSlider('getValue');
				var targetEl = $(this).attr('data-slider-valuefield');
				$(targetEl).val(v).hide();
			});
			--->

			// colorpicker
			$('.mura-colorpicker input[type=text]').on('keyup',function(){
				if ($(this).val().length == 0){
					$(this).parents('.mura-colorpicker').find('.mura-colorpicker-swatch').css('background-color','transparent');
				}
			})

			inited=true;
		});
	</script>
	</cfif>
</cfif>
