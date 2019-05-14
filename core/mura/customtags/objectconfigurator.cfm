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

		<cfparam name="attributes.params.cssstyles.backgroundImage" default="">
		<cfparam name="attributes.params.cssstyles.backgroundColor" default="rgba(255,0,0,0)">
		<cfparam name="attributes.params.isbodyobject" default="false">

		<cfif not request.hasbasicoptions>
		<cfset request.hasbasicoptions=attributes.basictab>
		</cfif>

		<cfif not listFindNoCase('folder,gallery,calendar',attributes.params.object) and not (isBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
			<cfset request.haspositionoptions = true>
		</cfif>

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
							<select name="width">
								<option value="">--</option>
								<option value="mura-one"<cfif listFind(attributes.params.class,'mura-one',' ')> selected</cfif>>One Twelfth</option>
								<option value="mura-two"<cfif listFind(attributes.params.class,'mura-two',' ')> selected</cfif>>One Sixth</option>
								<option value="mura-three"<cfif listFind(attributes.params.class,'mura-three',' ')> selected</cfif>>One Fourth</option>
								<option value="mura-four"<cfif listFind(attributes.params.class,'mura-four',' ')> selected</cfif>>One Third</option>
								<option value="mura-five"<cfif listFind(attributes.params.class,'mura-five',' ')> selected</cfif>>Five Twelfths</option>
								<option value="mura-six"<cfif listFind(attributes.params.class,'mura-six',' ')> selected</cfif>>One Half</option>
								<option value="mura-seven"<cfif listFind(attributes.params.class,'mura-seven',' ')> selected</cfif>>Seven Twelfths</option>
								<option value="mura-eight"<cfif listFind(attributes.params.class,'mura-eight',' ')> selected</cfif>>Two Thirds</option>
								<option value="mura-nine"<cfif listFind(attributes.params.class,'mura-nine',' ')> selected</cfif>>Three Fourths</option>
								<option value="mura-ten"<cfif listFind(attributes.params.class,'mura-ten',' ')> selected</cfif>>Five Sixths</option>
								<option value="mura-eleven"<cfif listFind(attributes.params.class,'mura-eleven',' ')> selected</cfif>>Eleven Twelfths</option>
								<option value="mura-twelve"<cfif listFind(attributes.params.class,'mura-twelve',' ')> selected</cfif>>Full</option>
								<option value="mura-expanded"<cfif listFind(attributes.params.class,'mura-expanded',' ')> selected</cfif>>Expanded</option>
							</select>
						</div>
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
			<!--- todo: remove this if not used --->
			/*
			$('#backgroundImageRaw').on('change',function(){
					$('#backgroundImage').val('url(' + $(this).val() + ')').trigger('change');
			})

			$('#backgroundImage').on('change',function(){
				if($(this).val()){
					$('#backgroundImageClear').hide();
				} else {
					$('#backgroundImageClear').show();
				}
			});

			$('#backgroundImageClear').on('click',function(){
					$('#backgroundImage').val('').trigger('change');
			})
			*/
			$('input[name="cssclass"],select[name="alignment"],select[name="width"],select[name="offset"],select[name="constraincontent"]').on('change', function() {
				setPlacementVisibility();
			});

			function restrictNumeric(el){
				var v = $(el).val();
				$(el).val = v.replace(/[^0-9]/g,'');
			}

			$('input.numeric').on('keyup', function(){
				restrictNumeric($(this));
			});

			$('#rowpaddingall').on('keyup', function(){
				var v = $('#rowpaddingall').val().replace(/[^0-9]/g,'');
				$('#rowpaddingtop').val(v);
				$('#rowpaddingleft').val(v);
				$('#rowpaddingright').val(v);
				$('#rowpaddingbottom').val(v);
			})
	
			function setPlacementVisibility(){
				var classInput=$('input[name="class"]');

				classInput.val('');

	  			var alignment=$('select[name="alignment"]');

	  			classInput.val(alignment.val());
					/*
	  			if(alignment.val()=='mura-left'){
	  				$('#offsetcontainer').show();
	  			} else {
	  				$('#offsetcontainer').hide();
	  			}
					*/

	  			var width=$('select[name="width"]');

	  			//if(width.val()){
	  				if(classInput.val() ){
	  					classInput.val(classInput.val() + ' ' + width.val());
	  				} else {
	  					classInput.val(width.val());
	  				}

						classInput.val($.trim(classInput.val()));

				<!--- todo: remove if not used --->
					/*
	  			if(alignment.val()=='mura-left'){
		  			var offset=$('select[name="offset"]');

		  			if(offset.val()){
		  				if(classInput.val() ){
		  					classInput.val(classInput.val() + ' ' + offset.val());
		  				} else {
		  					classInput.val(offset.val());
		  				}

		  				if(inited && typeof updateDraft == 'function'){
		  					updateDraft();
		  				}

		  			}
		  		}
					*/
					//}
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

			inited=true;
		});
	</script>
	</cfif>
</cfif>