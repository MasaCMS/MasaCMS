<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	param name="attributes.params.outerbackgroundimageurl" default="";
	param name="attributes.params.outerbackgroundimageurl" default="";
	param name="attributes.params.outerbackgroundcolorsel" default="";
	param name="attributes.params.innerbackgroundimageurl" default="";
	param name="attributes.params.innerbackgroundimageurl" default="";
	param name="attributes.params.innerbackgroundcolorsel" default="";

	param name="attributes.params.marginuom" default="";
	param name="attributes.params.paddinguom" default="";
	param name="attributes.params.outerbackgroundpositionx" default="";
	param name="attributes.params.outerbackgroundpositiony" default="";
	param name="attributes.params.innerbackgroundpositionx" default="";
	param name="attributes.params.innerbackgroundpositiony" default="";

	attributes.globalparams = [
		'backgroundcolor'
		,'backgroundimage'
		,'backgroundoverlay'
		,'backgroundparallax'
		,'backgroundposition'
		,'backgroundpositionx'
		,'backgroundpositiony'
		,'backgroundrepeat'
		,'backgroundsize'
		,'backgroundvideo'
		,'margin'
		,'margintop'
		,'marginright'
		,'marginbottom'
		,'marginleft'
		,'marginall'
		,'marginuom'
		,'padding'
		,'paddingtop'
		,'paddingright'
		,'paddingbottom'
		,'paddingleft'
		,'paddingall'
		,'paddinguom'
		,'textalign'];

	for (p in attributes.globalparams){
		param name="attributes.params.cssstyles.#p#" default="";
		if(p == 'textalign'){
			param name="attributes.params.metacssstyles.#p#" default="center";
		} else {
			param name="attributes.params.metacssstyles.#p#" default="";
		}
		param name="attributes.params.contentcssstyles.#p#" default="";
	}
</cfscript>

	<!--- outer panel --->
	<cfinclude template="objectconfigpanelstyleouter.cfm">

<cfoutput>

	<cfif request.hasmetaoptions and not (IsBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
		<!--- label --->
		<div class="mura-panel panel">
			<div class="mura-panel-heading" role="tab" id="heading-style-label">
				<h4 class="mura-panel-title">
					<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-label" aria-expanded="false" aria-controls="panel-style-label">
						Label
					</a>
				</h4>
			</div>
			<div id="panel-style-label" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-label">
				<div class="mura-panel-body">
					<div class="container" id="labelContainer">

						<!--- label text --->
						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.text')#</label>
							<input name="label" type="text" class="objectParam" maxlength="50" value="#esapiEncode('html_attr',attributes.params.label)#"/>
						</div>
						<!--- label alignment --->
						<div class="mura-control-group">
							<label>Text Alignment</label>
							<select name="textAlign" class="metaStyle">
								<option value="">--</option>
								<option value="left"<cfif attributes.params.metacssstyles.textalign eq 'left'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
								<option value="right"<cfif attributes.params.metacssstyles.textalign eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
								<option value="center"<cfif attributes.params.metacssstyles.textalign eq 'center'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
								<option value="justify"<cfif attributes.params.metacssstyles.textalign eq 'justify'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.justify')#</option>
							</select>
						</div>

						<!--- margin --->
						<div class="mura-control-group mura-ui-grid">
							<!--- todo: rbkey for margin and placeholders --->
							<label>Margin</label>

							<div class="row mura-ui-row">
								<div class="col-xs-8 center">
									<div class="mura-input-group">
										<label class="mura-serial">
											<input type="text" name="margin" id="metamarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginall))#</cfif>">
										</label>
										<select id="metamarginuom" name="marginuom" class="objectParam">
											<cfloop list="px,%,em,rem" index="u">
												<option value="#u#"<cfif attributes.params.marginuom eq u> selected</cfif>>#u#</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="col-xs-4">
									<a class="mura-ui-link" data-reveal="metamarginadvanced" href="##">Advanced</a>
								</div>
							</div>

							<div id="metamarginadvanced" class="mura-ui-inset" style="display: none;">
								<div class="row mura-ui-row">
									<div class="col-xs-3"></div>
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaMarginTop" id="metamargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.cssstyles.margintop))#</cfif>">
										</label>
										<input type="hidden" name="marginTop" id="metamargintopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.margintop)#">
									</div>
									<div class="col-xs-3"></div>
								</div>

								<div class="row mura-ui-row">
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaMarginLeft" id="metamarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginleft))#</cfif>">
										</label>
										<input type="hidden" name="marginLeft" id="metamarginleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginleft)#">
									</div>
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaMarginRight" id="metamarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginright))#</cfif>">
										</label>
										<input type="hidden" name="marginRight" id="metamarginrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginright)#">
									</div>
								</div>

								<div class="row mura-ui-row">
									<div class="col-xs-3"></div>
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaMarginBottom" id="metamarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginbottom))#</cfif>">
										</label>
										<input type="hidden" name="marginBottom" id="metamarginbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginbottom)#">
									</div>
									<div class="col-xs-3"></div>
								</div>
							</div>

						</div>

						<!--- padding --->
						<div class="mura-control-group mura-ui-grid">
							<!--- todo: rbkey for padding and placeholders --->
							<label>Padding</label>

							<div class="row mura-ui-row">
								<div class="col-xs-8 center">
									<div class="mura-input-group">
										<label class="mura-serial">
											<input type="text" name="padding" id="metapaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingall))#</cfif>">
										</label>
										<select id="metapaddinguom" name="paddinguom" class="objectParam">
											<cfloop list="px,%,em,rem" index="u">
												<option value="#u#"<cfif attributes.params.paddinguom eq u> selected</cfif>>#u#</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="col-xs-4">
									<a class="mura-ui-link" data-reveal="metapaddingadvanced" href="##">Advanced</a>
								</div>
							</div>

							<div id="metapaddingadvanced" class="mura-ui-inset" style="display: none;">
								<div class="row mura-ui-row">
									<div class="col-xs-3"></div>
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaPaddingTop" id="metapaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingtop))#</cfif>">
										</label>
										<input type="hidden" name="paddingTop" id="metapaddingtopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingtop)#">
									</div>
									<div class="col-xs-3"></div>
								</div>

								<div class="row mura-ui-row">
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaPaddingLeft" id="metapaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingleft))#</cfif>">
										</label>
										<input type="hidden" name="paddingLeft" id="metapaddingleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingleft)#">
									</div>
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaPaddingRight" id="metapaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingright))#</cfif>">
										</label>
										<input type="hidden" name="paddingRight" id="metapaddingrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingright)#">
									</div>
								</div>

								<div class="row mura-ui-row">
									<div class="col-xs-3"></div>
									<div class="col-xs-6">
										<label class="mura-serial">
											<input type="text" name="metaPaddingBottom" id="metapaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom))#</cfif>">
										</label>
										<input type="hidden" name="paddingBottom" id="metapaddingbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom)#">
									</div>
									<div class="col-xs-3"></div>
								</div>
							</div>

						</div>

						<!--- css id and class for label --->
						<div class="mura-control-group">
							<label>
								CSS ID
							</label>
							<input name="metacssid" class="metaStyle" type="text" value="#esapiEncode('html_attr',attributes.params.metacssid)#" maxlength="255">
						</div>
						<div class="mura-control-group">
							<label>
								CSS Class
							</label>
							<input name="metacssclass" class="metaStyle" type="text" value="#esapiEncode('html_attr',attributes.params.metacssclass)#" maxlength="255">
						</div>

						<!--- todo: duplicate row options here
						Not sure we should have all options -Matt
						<label>TODO: duplicate 'row' panel options here</label>
						--->

					</div> <!--- /end container --->
				</div> <!--- /end  mura-panel-body --->
			</div> <!--- /end  mura-panel-collapse --->
		</div> <!--- /end label panel --->
	</cfif>

	<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',attributes.params.class)#"/>
</cfoutput>

	<!--- inner panel --->
	<cfinclude template="objectconfigpanelstyleinner.cfm">
