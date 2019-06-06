<cfoutput>
	<!--- content --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-content">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-content" aria-expanded="false" aria-controls="panel-style-content">
					Content
				</a>
			</h4>
		</div>
		<div id="panel-style-content" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-content">
			<div class="mura-panel-body">
				<div class="container">

					<!--- label alignment --->
					<div class="mura-control-group">
						<label>Text Alignment</label>
						<select name="textAlign" class="contentStyle">
							<option value="">--</option>
							<option value="left"<cfif attributes.params.contentcssstyles.textalign eq 'left'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
							<option value="right"<cfif attributes.params.contentcssstyles.textalign eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
							<option value="center"<cfif attributes.params.contentcssstyles.textalign eq 'center'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
							<option value="justify"<cfif attributes.params.contentcssstyles.textalign eq 'justify'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.justify')#</option>
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
										<input type="text" name="margin" id="contentmarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginall))#</cfif>">
									</label>
									<select id="contentmarginuom" name="contentmarginuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.contentmarginuom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="contentmarginadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="contentmarginadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentMarginTop" id="contentmargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.margintop))#</cfif>">
									</label>
									<input type="hidden" name="marginTop" id="contentmargintopval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.margintop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentMarginLeft" id="contentmarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginleft))#</cfif>">
									</label>
									<input type="hidden" name="marginLeft" id="contentmarginleftval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.marginleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentMarginRight" id="contentmarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginright))#</cfif>">
									</label>
									<input type="hidden" name="marginRight" id="contentmarginrightval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.marginright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentMarginBottom" id="contentmarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginbottom))#</cfif>">
									</label>
									<input type="hidden" name="marginBottom" id="contentmarginbottomval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.marginbottom)#">
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
										<input type="text" name="padding" id="contentpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingall))#</cfif>">
									</label>
									<select id="contentpaddinguom" name="contentpaddinguom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.contentpaddinguom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="contentpaddingadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="contentpaddingadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentPaddingTop" id="contentpaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingtop))#</cfif>">
									</label>
									<input type="hidden" name="paddingTop" id="contentpaddingtopval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingtop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentPaddingLeft" id="contentpaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingleft))#</cfif>">
									</label>
									<input type="hidden" name="paddingLeft" id="contentpaddingleftval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentPaddingRight" id="contentpaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingright))#</cfif>">
									</label>
									<input type="hidden" name="paddingRight" id="contentpaddingrightval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingright)#">
								</div>
							</div>
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="contentPaddingBottom" id="contentpaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingbottom))#</cfif>">
									</label>
									<input type="hidden" name="paddingBottom" id="contentpaddingbottomval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingbottom)#">
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
							<select id="contentbackgroundcolorsel" name="backgroundColorSel" class="objectParam">
								<option value=""<cfif attributes.params.contentbackgroundcolorsel eq ''>
							selected</cfif>>None</option>
								<cfloop from="1" to="#arrayLen(request.colorOptions)#" index="i">
									<cfset c = request.colorOptions[i]>
									<option value="#c['value']#"<cfif attributes.params.contentbackgroundcolorsel eq c['value']>
							selected</cfif> style="background-color:#c['value']#;">#c['name']#</option>
								</cfloop>
								<option value="custom"<cfif attributes.params.contentbackgroundcolorsel eq 'custom'>
							selected</cfif>>Custom</option>
							</select>
						</cfif>
						<div class="input-group mura-colorpicker" id="contentbackgroundcustom" style="<cfif isArray(request.colorOptions) and arrayLen(request.colorOptions)>display: none;</cfif>">
							<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
							<input type="text" id="contentbackgroundcolor" name="backgroundColor" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundcolor)#">
						</div>
					</div>

					<!---
					<div class="mura-control-group">
						<label>Background Image</label>
						<input type="hidden" id="contentbackgroundimage" name="backgroundImage" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundimage)#">
						<input type="text" id="contentbackgroundimageurl" name="contentbackgroundimageurl" placeholder="URL" class="objectParam" value="#esapiEncode('html_attr',attributes.params.contentbackgroundimageurl)#">
						<button type="button" class="btn mura-ckfinder" data-target="contentbackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
					</div>

					<div class="mura-control-group content-css-bg-option" style="display:none;">
						<label>Background Size</label>
						<select id="contentbackgroundsize" name="backgroundSize" class="contentStyle">
							<option value="auto"<cfif attributes.params.contentcssstyles.backgroundsize eq 'auto'>
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.contentcssstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.contentcssstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group content-css-bg-option" style="display:none;">
						<label>Background Repeat</label>
						<select id="contentbackgroundrepeat" name="backgroundRepeat" class="contentStyle">
							<option value="no-repeat"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeat-x"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeat-y"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group mura-ui-grid content-css-bg-option" style="display:none;">
						<label>Background Position</label>

						<div class="mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="contentbackgroundpositionynum" name="contentBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositiony))#</cfif>" style="display: none;">
									</label>

									<select id="contentbackgroundpositiony" name="contentBackgroundPositionY" class="objectParam" data-numfield="contentbackgroundpositionynum">
										<cfloop list="Top,Center,Bottom,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.contentcssstyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="contentbackgroundpositionyval" name="backgroundPositionY" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositiony)#">

								</div>
							</div>
						</div>

						<div class="row mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="contentbackgroundpositionxnum" name="contentBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositionx))#</cfif>" style="display: none;">
									</label>

									<select id="contentbackgroundpositionx" name="contentBackgroundPositionX" class="objectParam" data-numfield="contentbackgroundpositionxnum">
										<cfloop list="Left,Center,Right,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.contentcssstyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="contentbackgroundpositionxval" name="backgroundPositionX" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositionx)#">

								</div>
							</div>
						</div>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Overlay</label>
						<input type="text" id="contentbackgroundoverlay" name="backgroundOverlay" placeholder="" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundoverlay)#">
					</div>
					--->
					<!--- css id and class for content --->
					<cfif request.haspositionoptions>
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
					</cfif>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end content panel --->
</cfoutput>
