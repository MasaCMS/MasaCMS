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
		<cfparam name="request.hasbasicoptions" default="false">
	 	<cfparam name="attributes.basictab" default="true">
		<cfparam name="request.hasmetaoptions" default="false">
		<cfparam name="attributes.params.class" default="">
		<cfparam name="attributes.params.cssclass" default="">
		<cfparam name="attributes.params.metacssclass" default="">
		<cfparam name="attributes.params.metacssid" default="">
		<cfparam name="attributes.params.contentcssclass" default="">
		<cfparam name="attributes.params.contentcssid" default="">
		<cfparam name="attributes.params.cssid" default="">
		<cfparam name="attributes.params.label" default="">
		<cfparam name="attributes.params.object" default="">

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

	</cfsilent>

	<cfif $.getContentRenderer().useLayoutManager()>
	<cfoutput>
	<cfset request.muraconfiguratortag=true>
	<div id="availableObjectContainer"<cfif not attributes.configurable> style="display:none"</cfif>>

		<div class="mura-panel-group" id="configurator-panels" role="tablist" aria-multiselectable="true">
		<!--- panel basic --->
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
<cfelseif thisTag.ExecutionMode eq 'end'>
	<cfset $=application.serviceFactory.getBean("muraScope").init(session.siteid)>

	<cfif $.getContentRenderer().useLayoutManager()>

	<cfoutput>

		<cfif request.hasmetaoptions or request.hasbasicoptions>
				</div> <!--- /end  mura-panel-collapse --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end panel --->
		</cfif>
		<cfif not listFindNoCase('folder,gallery,calendar',attributes.params.object) and not (IsBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
		<!--- Postioning--->
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
							<!---<option value="mura-center"<cfif listFind(attributes.params.class,'mura-center',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>--->
							<option value="mura-right"<cfif listFind(attributes.params.class,'mura-right',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
							</select>
					</div>
					<!---
					<div id="offsetcontainer" class="mura-control-group" style="display:none">
		      	<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.offset')#</label>
						<select name="offset">
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
					--->
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
						</select>
					</div>
				</div> <!--- /end  mura-panel-collapse --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end panel --->
		</cfif>
		<div class="mura-panel panel">
			<div class="mura-panel-heading" role="tab" id="heading-style">
				<h4 class="mura-panel-title">
					<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style" aria-expanded="false" aria-controls="panel-style">
						Style
					</a>
				</h4>
			</div>
			<div id="panel-style" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-style">
				<div class="mura-panel-body">
						<div class="container">
							<div class="mura-control-group">
								<div class="panel-gds-box" id="panel-gds-outer" data-gdsel="panel-style-outer"><span>Outer</span>
									<cfif request.hasmetaoptions>
										<div class="panel-gds-box" id="panel-gds-meta" data-gdsel="panel-style-meta"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.label')#</span></div>
									</cfif>
									<div class="panel-gds-box" id="panel-gds-inner" data-gdsel="panel-style-content"><span>Content</span></div>
								</div>
								<div class="mura-panel-group" id="style-panels" role="tablist" aria-multiselectable="true">
									<div class="mura-panel panel">
										<div id="heading-style-outer" class="mura-panel-heading" role="tab">
											<h4 class="mura-panel-title">
												<a class="collapsed" role="button" data-toggle="collapse" data-parent="##style-panels" href="##panel-style-outer" aria-expanded="false" aria-controls="panel-style-outer">
													Outer
												</a>
											</h4>
										</div>
										<div id="panel-style-outer" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-style-outer">
											<div class="mura-panel-body">
												<div class="mura-control-group">
													<label>
														CSS ID
													</label>
													<input name="cssid" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.cssid)#" maxlength="255">
												</div>
												<div class="mura-control-group">
													<label>
														CSS Class
													</label>
													<input name="cssclass" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.cssclass)#" maxlength="255">
													<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
												</div>
											</div>
										</div>
									</div>
									<cfif request.hasmetaoptions>
										<div class="mura-panel panel">
											<div id="heading-style-meta" class="mura-panel-heading" role="tab">
											<h4 class="mura-panel-title">
												<a class="collapsed" role="button" data-toggle="collapse" data-parent="##style-panels" href="##panel-style-meta" aria-expanded="false" aria-controls="panel-style-meta">
													Inner Meta
												</a>
											</h4>
											</div>
											<div id="panel-style-meta" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-style-meta">
												<div class="mura-panel-body">
													<div class="mura-control-group">
														<label>
															CSS ID
														</label>
														<input name="metacssid" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.metacssid)#" maxlength="255">
													</div>
													<div class="mura-control-group">
														<label>
															CSS Class
														</label>
														<input name="metacssclass" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.metacssclass)#" maxlength="255">
													</div>
												</div>
											</div>
										</div>
									</cfif>
									<div class="mura-panel panel">
										<div id="heading-style-content" class="mura-panel-heading" role="tab">
											<h4 class="mura-panel-title">
												<a class="collapsed" role="button" data-toggle="collapse" data-parent="##style-panels" href="##panel-style-content" aria-expanded="false" aria-controls="panel-style-content">
													Inner Content
												</a>
											</h4>
										</div>
										<div id="panel-style-content" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-style-content">
											<div class="mura-panel-body">
												<div class="mura-control-group">
													<label>
														CSS ID
													</label>
													<input name="contentcssid" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.contentcssid)#" maxlength="255">
												</div>
												<div class="mura-control-group">
													<label>
														CSS Class
													</label>
													<input name="contentcssclass" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.contentcssclass)#" maxlength="255">
												</div>
											</div>
										</div>
									</div> <!--- /end panel --->
								</div> <!--- /end panel group --->
							</div> <!--- /end mura control group --->
						</div> <!--- /end container --->
						<!---
						<div class="mura-control-group">
							<label>
								#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.backgroundcolor')#
							</label>
							<input name="backgroundColor" class="objectStyle colorpicker" type="text" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundColor)#" maxlength="255">
						</div>
						<div class="mura-control-group">
							<label>
								#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.backgroundimage')#
							</label>
							<div class="btn-group" role="group">
								<button type="button" class="btn mura-ckfinder" data-target="backgroundImageRaw" data-type="image" data-completepath=false>Select</button>
								<button type="button" id="backgroundImageClear" class="btn">Clear</button>
							</div>
							<input name="backgroundImageRaw" type="hidden" id="backgroundImageRaw">
							<input name="backgroundImage" id="backgroundImage" class="objectStyle" type="hidden" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundImage)#" maxlength="255">
						</div>
							--->
				</div> <!--- /end  mura-panel-body --->
			</div> <!--- /end  mura-panel-collapse --->
		</div> <!--- /end panel --->
	</div><!--- /end panels --->
	</cfoutput>
</div> <!--- /end availableObjectContainer --->
	<script>
		$(function(){

			var inited=false;
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
			$('input[name="cssclass"],select[name="alignment"],select[name="width"],select[name="offset"]').on('change', function() {
				setPlacementVisibility();
			});

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

	  				if(inited && typeof updateDraft == 'function'){
	  					updateDraft();
	  				}
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
		  		var cssclassInput=$('input[name="cssclass"]');

		  		if(cssclassInput.val()){
	  				if(classInput.val() ){
	  					classInput.val(classInput.val() + ' ' + cssclassInput.val());
	  				} else {
	  					classInput.val(cssclassInput.val());
	  				}

						classInput.val($.trim(classInput.val()));
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
