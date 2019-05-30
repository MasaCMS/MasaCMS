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

		<!--- todo: merge this included content back to this file --->
		<cfinclude template="objectconfiguratorpanels.cfm">

		<cfif request.haspositionoptions>
			<!--- Position panel--->
			<div class="mura-panel panel">
				<div class="mura-panel-heading" role="tab" id="heading-positioning">
					<h4 class="mura-panel-title">
						<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-positioning" aria-expanded="false" aria-controls="panel-positioning">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.position')#
						</a>
					</h4>
				</div>
				<div id="panel-positioning" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-positioning">
					<div class="mura-panel-body">
						<div class="mura-control-group">
								<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.alignment')#</label>
								<select name="alignment">
								<option value="">--</option>
								<option value="mura-left"<cfif listFind(attributes.params.class,'mura-left',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
								<!--- todo: remove if not used --->
								<!---<option value="mura-center"<cfif listFind(attributes.params.class,'mura-center',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>--->
								<option value="mura-right"<cfif listFind(attributes.params.class,'mura-right',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
								</select>
						</div>

						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.width')#</label>
							<cfset attributes.positionlabels = ''>
							<cfset attributes.positionvalues = ''>
							<select name="width" id="objectwidthsel">
								<cfloop from="1" to="#arrayLen(attributes.positionoptions)#" index="i">
									<cfset p = attributes.positionoptions[i]>
									<option value="#p['value']#"<cfif listFind(attributes.params.class,'#p['value']#',' ')> selected</cfif>>#p['label']#</option>
									<cfset l = "'#p["label"]#'">
									<cfset v = "'#p["value"]#'">
									<cfset attributes.positionLabels = listAppend(attributes.positionlabels, l)>
									<cfset attributes.positionValues = listAppend(attributes.positionvalues, v)>
								</cfloop>
							</select>
						</div>

<!--- todo: bootstrap slider --->
<!--- 						<input
							type="text"
							data-slider-id="objectwidthslider"
							name="objectwidthslider"
							class="mura-rangeslider"
							data-slider-ticks="[0,1,2,3,4,5,6,7,8,9,10,11,12,13]"
							data-slider-ticks-labels="'[#attributes.positionlabels#]'"
							data-slider-ticks-tooltip="true"
							data-slider-tooltip="hide"
							data-slider-valuefield="##objectwidthsel"
						> --->

						<cfif len(contentcontainerclass)>
							<div class="mura-control-group constraincontentcontainer" style='display:none;'>
									<label>Constrain Content</label>
									<select name="constraincontent">
									<option value=""<cfif not listFind(attributes.params.contentcssclass,contentcontainerclass,' ')> selected</cfif>>False</option>
									<option value="constrain"<cfif listFind(attributes.params.contentcssclass,contentcontainerclass,' ')> selected</cfif>>True</option>
									</select>
							</div>
						</cfif>
					</div> <!--- /end  mura-panel-collapse --->
				</div> <!--- /end  mura-panel-body --->
			</div> <!--- /end position panel --->
		</cfif>
	</div><!--- /end panels --->
	</cfoutput>
</div> <!--- /end availableObjectContainer --->

	<script>
		$(function(){

			var inited=false;

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

			<!--- todo: merge these into a global method for all directional attributes (padding, margin on all) --->
			// padding
			function updateRowPadding(){
				var t = $('#rowpaddingtop').val().replace(/[^0-9]/g,'');
				var r = $('#rowpaddingright').val().replace(/[^0-9]/g,'');
				var b = $('#rowpaddingbottom').val().replace(/[^0-9]/g,'');
				var l =$('#rowpaddingleft').val().replace(/[^0-9]/g,'');
				var u = $('#rowpaddinguom').val();
				if (t.length){ $('#rowpaddingtopval').val(t + u); } else { $('#rowpaddingtopval').val(''); }
				if (r.length){ $('#rowpaddingrightval').val(r + u); } else { $('#rowpaddingrightval').val(''); }
				if (b.length){ $('#rowpaddingbottomval').val(b + u); } else { $('#rowpaddingbottomval').val(''); }
				if (l.length){ $('#rowpaddingleftval').val(l + u); } else { $('#rowpaddingleftval').val(''); }
				if (t == r && r == b & b == l){
					$('#rowpaddingall').val(t);
				} else {
					$('#rowpaddingall').val('');
					$('#rowpaddingadvanced').show();
				}
				$('#rowpaddingtopval').trigger('change');
			}

			$('#rowpaddingall').on('keyup', function(){
				var v = $('#rowpaddingall').val().replace(/[^0-9]/g,'');
				$('#rowpaddingadvanced').hide();
				$('#rowpaddingtop').val(v);
				$('#rowpaddingleft').val(v);
				$('#rowpaddingright').val(v);
				$('#rowpaddingbottom').val(v);
			})

			$('#rowpaddingtop,#rowpaddingright,#rowpaddingbottom,#rowpaddingleft,#rowpaddingall').on('keyup', function(){
				updateRowPadding();
			})

			$('#rowpaddinguom').on('change',function(){
				updateRowPadding();
			});

			updateRowPadding();

 			// margin
			function updateRowMargin(){
				var t = $('#rowmargintop').val().replace(/[^0-9]/g,'');
				var r = $('#rowmarginright').val().replace(/[^0-9]/g,'');
				var b = $('#rowmarginbottom').val().replace(/[^0-9]/g,'');
				var l =$('#rowmarginleft').val().replace(/[^0-9]/g,'');
				var u = $('#rowmarginuom').val();
				if (t.length){ $('#rowmargintopval').val(t + u); } else { $('#rowmargintopval').val(''); }
				if (r.length){ $('#rowmarginrightval').val(r + u); } else { $('#rowmarginrightval').val(''); }
				if (b.length){ $('#rowmarginbottomval').val(b + u); } else { $('#rowmarginbottomval').val(''); }
				if (l.length){ $('#rowmarginleftval').val(l + u); } else { $('#rowmarginleftval').val(''); }
				if (t == r && r == b & b == l){
					$('#rowmarginall').val(t);
				} else {
					$('#rowmarginall').val('');
					$('#rowmarginadvanced').show();

				}
				$('#rowmargintopval').trigger('change');
			}

			$('#rowmarginall').on('keyup', function(){
				var v = $('#rowmarginall').val().replace(/[^0-9]/g,'');
				$('#rowmarginadvanced').hide();
				$('#rowmargintop').val(v);
				$('#rowmarginleft').val(v);
				$('#rowmarginright').val(v);
				$('#rowmarginbottom').val(v);
			})

			$('#rowmargintop,#rowmarginright,#rowmarginbottom,#rowmarginleft,#rowmarginall').on('keyup', function(){
				updateRowMargin();
			});

			$('#rowmarginuom').on('change',function(){
				updateRowMargin();
			});

			updateRowMargin();

			// background color
			function updateRowBgColor(v){
				var swatchColor = v;
				var swatchEl = $('#rowbackgroundcustom').find('i.mura-colorpicker-swatch');
				if (v == 'custom' <cfif not(isArray(request.backgroundcoloroptions) and arrayLen(request.backgroundcoloroptions))> || true</cfif>){
					$('#rowbackgroundcustom').show();
				} else if (v == 'none'){
					swatchColor = 'transparent'
					$('#rowbackgroundcustom').hide();
					$('#rowbackgroundcolor').val('');
				} else {
					$('#rowbackgroundcustom').hide();
					$('#rowbackgroundcolor').val(v);
				}
				swatchEl.css('background-color',swatchColor);
			}

			$('#rowbackgroundcolorsel').on('change',function(){
				var v = $(this).val();
				updateRowBgColor(v);
			});

			updateRowBgColor($('#rowbackgroundcolorsel').val());

			// background image
			$('#rowbackgroundimageurl').on('change',function(){
				var v = $(this).val();
				var str = "";
				if (v.length > 3){
					str = "url('" + v + "')";
					$('.css-bg-option').show();
				} else {
					$('.css-bg-option').hide();
				}
				$('#rowbackgroundimage').val(str).trigger('change');
			});

			$('#rowbackgroundimageurl').trigger('change');

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

			$('#rowbackgroundpositiony,#rowbackgroundpositionynum').on('change',function(){
				var el = $('#rowbackgroundpositionyval');
				var str = $('#rowbackgroundpositiony').val();
				var num = $('#rowbackgroundpositionynum').val();
				if (num.length > 0){
					str = num + str;
				}
				$(el).val(str).trigger('change');
			});

			$('#rowbackgroundpositionx,#rowbackgroundpositionxnum').on('change',function(){
				var el = $('#rowbackgroundpositionxval');
				var str = $('#rowbackgroundpositionx').val();
				var num = $('#rowbackgroundpositionxnum').val();
				if (num.length > 0){
					str = num + str;
				}
				$(el).val(str).trigger('change');
			});

			$('#rowbackgroundpositionx,#rowbackgroundpositiony').on('change',function(){
				updatePositionSelection($(this));
			});

			$('#rowbackgroundpositionx,#rowbackgroundpositiony').each(function(){
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

			<!--- todo: are we using bigui here? --->
			<!---
			$('#configuratorContainer .bigui__launch').on('click', function(e){
				var el=window.parent.$('body');
				if(el.hasClass('mura-bigui-state__pushed--right')){
					el.removeClass('mura-bigui-state__pushed--right');
				} else {
					el.addClass('mura-bigui-state__pushed--right');
				}
				e.preventDefault();
			});
			--->

			inited=true;
		});
	</script>
	</cfif>
</cfif>
