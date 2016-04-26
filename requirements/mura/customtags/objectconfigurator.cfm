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
		<cfparam name="attributes.params.class" default="">
		<cfparam name="attributes.params.cssclass" default="">
		<cfparam name="attributes.params.label" default="">
		<cfparam name="attributes.params.object" default="">
	</cfsilent>

	<cfif $.getContentRenderer().useLayoutManager() and not listFindNoCase('folder,gallery,calendar',attributes.params.object)>
	<cfoutput>
	
			
	<div id="availableObjectContainer"<cfif not attributes.configurable> style="display:none"</cfif>>
	</cfoutput>
	</cfif>
<cfelseif thisTag.ExecutionMode eq 'end'>
	<cfset $=application.serviceFactory.getBean("muraScope").init(session.siteid)>

	<cfif $.getContentRenderer().useLayoutManager()>

	</div>
	<cfoutput>
	<div class="fieldset-wrap">
		<div class="fieldset">
			<cfif not listFindNoCase('folder,gallery,calendar',attributes.params.object)>
			<div class="control-group">
		      	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.alignment')#</label>
				<div class="controls">
					 <select name="alignment" class="span12">
					 	<option value="">--</option>
						<option value="mura-left"<cfif listFind(attributes.params.class,'mura-left',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
						<!--<option value="mura-center"<cfif listFind(attributes.params.class,'mura-center',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>--->
						<option value="mura-right"<cfif listFind(attributes.params.class,'mura-right',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
					</select>
				</div>
			</div>
			<div id="offsetcontainer" class="control-group" style="display:none">
		      	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.offset')#</label>
				<div class="controls">
					<select name="offset" class="span12">
						<option value="">--</option>
						<option value="mura-offset-by-one"<cfif listFind(attributes.params.class,'mura-offset-by-one',' ')> selected</cfif>>One Twelfth</option>
						<option value="mura-offset-by-two"<cfif listFind(attributes.params.class,'mura-offset-by-two',' ')> selected</cfif>>One Sixth</option>
						<option value="mura-offset-by-three"<cfif listFind(attributes.params.class,'mura-offset-by-three',' ')> selected</cfif>>One Fourth</option>
						<option value="mura-offset-by-four"<cfif listFind(attributes.params.class,'mura-offset-by-four',' ')> selected</cfif>>One Third</option>
						<option value="mura-offset-by-five"<cfif listFind(attributes.params.class,'mura-offset-by-five',' ')> selected</cfif>>Five Twelfths</option>
						<option value="mura-offset-by-six"<cfif listFind(attributes.params.class,'mura-offset-by-six',' ')> selected</cfif>>One Half</option>
						<option value="mura-offset-by-seven"<cfif listFind(attributes.params.class,'mura-offset-by-seven',' ')> selected</cfif>>Seven Twelfths</option>
						<option value="mura-offset-by-eight"<cfif listFind(attributes.params.class,'mura-offset-by-eight',' ')> selected</cfif>>Two Thirds</option>
						<option value="mura-offset-by-nine"<cfif listFind(attributes.params.class,'mura-offset-by-nine',' ')> selected</cfif>>Three Fourths</option>
						<option value="mura-offset-by-ten"<cfif listFind(attributes.params.class,'mura-offset-by-ten',' ')> selected</cfif>>Five Sixths</option>
						<option value="mura-offset-by-eleven"<cfif listFind(attributes.params.class,'mura-offset-by-eleven',' ')> selected</cfif>>Eleven Twelfths</option>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.width')#</label>
				<div class="controls">
					<select name="width" class="span12">
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
					</select>
				</div>
			</div>
			</cfif>
			<div class="control-group">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.cssclass')#
				</label>
				<div class="controls">
					<input name="cssclass" class="objectParam span12" type="text" value="#esapiEncode('html_attr',attributes.params.cssclass)#" maxlength="255">
				</div>
			</div>
		</div>
	</div>
	<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
	</cfoutput>
	</div>
	<script>
		$(function(){
		
			var inited=false;

			$('input[name="cssclass"],select[name="alignment"],select[name="width"],select[name="offset"]').on('change', function() {
				setPlacementVisibility();
			});

			function setPlacementVisibility(){
				var classInput=$('input[name="class"]');

				classInput.val('');

	  			var alignment=$('select[name="alignment"]');

	  			classInput.val(alignment.val());

	  			if(alignment.val()=='mura-left'){
	  				$('#offsetcontainer').show();
	  			} else {
	  				$('#offsetcontainer').hide();
	  			}

	  			var width=$('select[name="width"]');
	  			
	  			if(width.val()){
	  				if(classInput.val() ){
	  					classInput.val(classInput.val() + ' ' + width.val());
	  				} else {
	  					classInput.val(width.val());
	  				}

	  				if(inited && typeof updateDraft == 'function'){
	  					updateDraft();
	  				}
	  			}

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

		  		var cssclassInput=$('input[name="cssclass"]');
		  		
		  		if(cssclassInput.val()){
	  				if(classInput.val() ){
	  					classInput.val(classInput.val() + ' ' + cssclassInput.val());
	  				} else {
	  					classInput.val(cssclassInput.val());
	  				}
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
<cfelse>

</cfif>