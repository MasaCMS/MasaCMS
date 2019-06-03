<cfoutput>
	<!--- inner --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-inner">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-inner" aria-expanded="false" aria-controls="panel-style-inner">
					Content
				</a>
			</h4>
		</div>
		<div id="panel-style-inner" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-inner">
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
										<input type="text" name="margin" id="innermarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginall))#</cfif>">
									</label>
									<select id="innermarginuom" name="marginuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.marginuom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="innermarginadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="innermarginadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerMarginTop" id="innermargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.margintop))#</cfif>">
									</label>
									<input type="hidden" name="marginTop" id="innermargintopval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.margintop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerMarginLeft" id="innermarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginleft))#</cfif>">
									</label>
									<input type="hidden" name="marginLeft" id="innermarginleftval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.marginleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerMarginRight" id="innermarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginright))#</cfif>">
									</label>
									<input type="hidden" name="marginRight" id="innermarginrightval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.marginright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerMarginBottom" id="innermarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.marginbottom))#</cfif>">
									</label>
									<input type="hidden" name="marginBottom" id="innermarginbottomval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.marginbottom)#">
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
										<input type="text" name="padding" id="innerpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingall))#</cfif>">
									</label>
									<select id="innerpaddinguom" name="paddinguom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.paddinguom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="innerpaddingadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="innerpaddingadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerPaddingTop" id="innerpaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingtop))#</cfif>">
									</label>
									<input type="hidden" name="paddingTop" id="innerpaddingtopval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingtop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerPaddingLeft" id="innerpaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingleft))#</cfif>">
									</label>
									<input type="hidden" name="paddingLeft" id="innerpaddingleftval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerPaddingRight" id="innerpaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingright))#</cfif>">
									</label>
									<input type="hidden" name="paddingRight" id="innerpaddingrightval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingright)#">
								</div>
							</div>
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="innerPaddingBottom" id="innerpaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.contentcssstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.paddingbottom))#</cfif>">
									</label>
									<input type="hidden" name="paddingBottom" id="innerpaddingbottomval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.paddingbottom)#">
								</div>
								<div class="col-xs-3"></div>
							</div>
						</div>

					</div>

					<!--- background --->
					<div class="mura-control-group">
						<!--- todo: rbkey for these labels, options and placeholders--->
						<label>Background Color</label>
						<cfif isArray(request.backgroundcoloroptions) and arrayLen(request.backgroundcoloroptions)>
							<select id="innerbackgroundcolorsel" name="backgroundColorSel" class="objectParam">
								<option value=""<cfif attributes.params.innerbackgroundcolorsel eq ''>
							selected</cfif>>None</option>
								<cfloop from="1" to="#arrayLen(request.backgroundcoloroptions)#" index="i">
									<cfset c = request.backgroundcoloroptions[i]>
									<option value="#c['value']#"<cfif attributes.params.innerbackgroundcolorsel eq c['value']>
							selected</cfif> style="background-color:#c['value']#;">#c['name']#</option>
								</cfloop>
								<option value="custom"<cfif attributes.params.innerbackgroundcolorsel eq 'custom'>
							selected</cfif>>Custom</option>
							</select>
						</cfif>
						<div class="input-group mura-colorpicker" id="innerbackgroundcustom" style="<cfif isArray(request.backgroundcoloroptions) and arrayLen(request.backgroundcoloroptions)>display: none;</cfif>">
							<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
							<input type="text" id="innerbackgroundcolor" name="innerbackgroundColor" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundcolor)#">
						</div>
					</div>

					<div class="mura-control-group">
						<label>Background Image</label>
						<input type="hidden" id="innerbackgroundimage" name="backgroundImage" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundimage)#">
						<input type="text" id="innerbackgroundimageurl" name="innerbackgroundimageurl" placeholder="URL" class="objectParam" value="#esapiEncode('html_attr',attributes.params.innerbackgroundimageurl)#">
						<button type="button" class="btn mura-ckfinder" data-target="innerbackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Size</label>
						<select id="innerbackgroundsize" name="backgroundSize" class="contentStyle">
							<option value="auto"<cfif attributes.params.contentcssstyles.backgroundsize eq 'auto'>
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.contentcssstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.contentcssstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Repeat</label>
						<select id="innerbackgroundrepeat" name="backgroundRepeat" class="contentStyle">
							<option value="no-repeat"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeat-x"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeat-y"<cfif attributes.params.contentcssstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group mura-ui-grid css-bg-option" style="display:none;">
						<label>Background Position</label>

						<div class="mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="innerbackgroundpositionynum" name="innerBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositiony))#</cfif>" style="display: none;">
									</label>

									<select id="innerbackgroundpositiony" name="innerBackgroundPositionY" class="objectParam" data-numfield="innerbackgroundpositionynum">
										<cfloop list="Top,Center,Bottom,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.contentcssstyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="innerbackgroundpositionyval" name="backgroundPositionY" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositiony)#">

								</div>
							</div>
						</div>

						<div class="row mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="innerbackgroundpositionxnum" name="innerBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositionx))#</cfif>" style="display: none;">
									</label>

									<select id="innerbackgroundpositionx" name="innerBackgroundPositionX" class="objectParam" data-numfield="innerbackgroundpositionxnum">
										<cfloop list="Left,Center,Right,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.contentcssstyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="innerbackgroundpositionxval" name="backgroundPositionX" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundpositionx)#">

								</div>
							</div>
						</div>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Overlay</label>
						<input type="text" id="innerbackgroundoverlay" name="backgroundOverlay" placeholder="" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.contentcssstyles.backgroundoverlay)#">
					</div>

					<!--- css id and class for inner --->
					<cfif request.haspositionoptions>
						<div class="mura-control-group">
							<label>
								CSS ID
							</label>
							<input name="contentcssid" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.cssid)#" maxlength="255">
						</div>
						<div class="mura-control-group">
							<label>
								CSS Class
							</label>
							<input name="contentcssclass" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.cssclass)#" maxlength="255">
						</div>
					</cfif>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end inner panel --->
</cfoutput>
