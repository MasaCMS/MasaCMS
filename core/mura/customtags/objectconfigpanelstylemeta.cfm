<cfif request.hasmetaoptions and not (IsBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
	<cfoutput>
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

					<!--- label text
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.text')#</label>
						<input name="label" type="text" class="objectParam" maxlength="50" value="#esapiEncode('html_attr',attributes.params.label)#"/>
					</div>
					--->
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
										<input type="text" name="margin" id="metamarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.marginall))#</cfif>">
									</label>
									<select id="metamarginuom" name="metamarginuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.metamarginuom eq u> selected</cfif>>#u#</option>
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
										<input type="text" name="metaMarginTop" id="metamargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.margintop))#</cfif>">
									</label>
									<input type="hidden" name="marginTop" id="metamargintopval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.margintop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="metaMarginLeft" id="metamarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.marginleft))#</cfif>">
									</label>
									<input type="hidden" name="marginLeft" id="metamarginleftval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.marginleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="metaMarginRight" id="metamarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.marginright))#</cfif>">
									</label>
									<input type="hidden" name="marginRight" id="metamarginrightval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.marginright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="metaMarginBottom" id="metamarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.marginbottom))#</cfif>">
									</label>
									<input type="hidden" name="marginBottom" id="metamarginbottomval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.marginbottom)#">
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
										<input type="text" name="padding" id="metapaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.paddingall))#</cfif>">
									</label>
									<select id="metapaddinguom" name="metapaddinguom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.metapaddinguom eq u> selected</cfif>>#u#</option>
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
										<input type="text" name="metaPaddingTop" id="metapaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.paddingtop))#</cfif>">
									</label>
									<input type="hidden" name="paddingTop" id="metapaddingtopval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.paddingtop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="metaPaddingLeft" id="metapaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.paddingleft))#</cfif>">
									</label>
									<input type="hidden" name="paddingLeft" id="metapaddingleftval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.paddingleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="metaPaddingRight" id="metapaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.paddingright))#</cfif>">
									</label>
									<input type="hidden" name="paddingRight" id="metapaddingrightval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.paddingright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="metaPaddingBottom" id="metapaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.metacssstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.metacssstyles.paddingbottom))#</cfif>">
									</label>
									<input type="hidden" name="paddingBottom" id="metapaddingbottomval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.metacssstyles.paddingbottom)#">
								</div>
								<div class="col-xs-3"></div>
							</div>
						</div>

					</div>

					<!--- background --->
					<div class="mura-control-group">
						<!--- todo: rbkey for these labels, options and placeholders--->
						<label>Background Color</label>
						<cfif isArray(request.colorOptions) and arrayLen(request.colorOptions)>
							<select id="metabackgroundcolorsel" name="backgroundColorSel" class="objectParam">
								<option value=""<cfif attributes.params.metabackgroundcolorsel eq ''>
							selected</cfif>>None</option>
								<cfloop from="1" to="#arrayLen(request.colorOptions)#" index="i">
									<cfset c = request.colorOptions[i]>
									<option value="#c['value']#"<cfif attributes.params.metabackgroundcolorsel eq c['value']>
							selected</cfif> style="background-color:#c['value']#;">#c['name']#</option>
								</cfloop>
								<option value="custom"<cfif attributes.params.metabackgroundcolorsel eq 'custom'>
							selected</cfif>>Custom</option>
							</select>
						</cfif>
						<div class="input-group mura-colorpicker" id="metabackgroundcustom" style="<cfif isArray(request.colorOptions) and arrayLen(request.colorOptions)>display: none;</cfif>">
							<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
							<input type="text" id="metabackgroundcolor" name="backgroundColor" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.metacssstyles.backgroundcolor)#">
						</div>
					</div>

					<!--- css id and class for label --->
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

					<!--- todo: duplicate row options here
					Not sure we should have all options -Matt
					<label>TODO: duplicate 'row' panel options here</label>
					--->

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end label panel --->
	</cfoutput>
</cfif>
