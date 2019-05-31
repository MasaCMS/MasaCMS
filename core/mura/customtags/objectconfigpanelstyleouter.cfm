<cfoutput>
	<!--- outer --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-outer">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-outer" aria-expanded="false" aria-controls="panel-style-outer">
					Outer
				</a>
			</h4>
		</div>
		<div id="panel-style-outer" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-outer">
			<div class="mura-panel-body">
				<div class="container">

					<!--- padding --->
					<div class="mura-control-group mura-ui-grid">
						<!--- todo: rbkey for padding and placeholders --->
						<label>Padding</label>

						<div class="row mura-ui-row">
							<div class="col-xs-8 center">
								<div class="mura-input-group">
									<label class="mura-serial">
										<input type="text" name="padding" id="outerpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingall))#</cfif>">
									</label>
									<select id="outerpaddinguom" name="paddinguom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.paddinguom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="outerpaddingadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="outerpaddingadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerPaddingTop" id="outerpaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingtop))#</cfif>">
									</label>
									<input type="hidden" name="paddingTop" id="outerpaddingtopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingtop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerPaddingLeft" id="outerpaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingleft))#</cfif>">
									</label>
									<input type="hidden" name="paddingLeft" id="outerpaddingleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerPaddingRight" id="outerpaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingright))#</cfif>">
									</label>
									<input type="hidden" name="paddingRight" id="outerpaddingrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerPaddingBottom" id="outerpaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom))#</cfif>">
									</label>
									<input type="hidden" name="paddingBottom" id="outerpaddingbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom)#">
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
							<select id="outerbackgroundcolorsel" name="backgroundColorSel" class="objectParam">
								<option value=""<cfif attributes.params.outerbackgroundcolorsel eq ''>
							selected</cfif>>None</option>
								<cfloop from="1" to="#arrayLen(request.backgroundcoloroptions)#" index="i">
									<cfset c = request.backgroundcoloroptions[i]>
									<option value="#c['value']#"<cfif attributes.params.outerbackgroundcolorsel eq c['value']>
							selected</cfif> style="background-color:#c['value']#;">#c['name']#</option>
								</cfloop>
								<option value="custom"<cfif attributes.params.outerbackgroundcolorsel eq 'custom'>
							selected</cfif>>Custom</option>
							</select>
						</cfif>
						<div class="input-group mura-colorpicker" id="outerbackgroundcustom" style="<cfif isArray(request.backgroundcoloroptions) and arrayLen(request.backgroundcoloroptions)>display: none;</cfif>">
							<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
							<input type="text" id="outerbackgroundcolor" name="backgroundColor" placeholder="Select Color" class="objectStyle" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundcolor)#">
						</div>
					</div>

					<div class="mura-control-group">
						<label>Background Image</label>
						<input type="hidden" id="outerbackgroundimage" name="backgroundImage" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundimage)#">
						<input type="text" id="outerbackgroundimageurl" name="backgroundImageURL" placeholder="URL" class="objectParam" value="#esapiEncode('html_attr',attributes.params.outerbackgroundimageurl)#">
						<button type="button" class="btn mura-ckfinder" data-target="backgroundImageURL" data-completepath="false"><i class="mi-image"></i> Select Image</button>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Size</label>
						<select id="outerbackgroundsize" name="backgroundSize" class="objectStyle">
							<option value="auto"<cfif attributes.params.cssstyles.backgroundsize eq 'auto'>
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.cssstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.cssstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Repeat</label>
						<select id="outerbackgroundrepeat" name="backgroundRepeat" class="objectStyle">
							<option value="no-repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeat-x"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeat-y"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group mura-ui-grid css-bg-option" style="display:none;">
						<label>Background Position</label>

						<div class="mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="outerbackgroundpositionynum" name="outerBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositiony))#</cfif>" style="display: none;">
									</label>

									<select id="outerbackgroundpositiony" name="outerBackgroundPositionY" class="objectParam" data-numfield="outerbackgroundpositionynum">
										<cfloop list="Top,Center,Bottom,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.cssstyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="outerbackgroundpositionyval" name="backgroundPositionY" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositiony)#">

								</div>
							</div>
						</div>

						<div class="row mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="outerbackgroundpositionxnum" name="outerBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositionx))#</cfif>" style="display: none;">
									</label>

									<select id="outerbackgroundpositionx" name="outerBackgroundPositionX" class="objectParam" data-numfield="outerbackgroundpositionxnum">
										<cfloop list="Left,Center,Right,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.cssstyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="outerbackgroundpositionxval" name="backgroundPositionX" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositionx)#">

								</div>
							</div>
						</div>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Overlay</label>
						<input type="text" id="outerbackgroundoverlay" name="backgroundOverlay" placeholder="" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundoverlay)#">
					</div>

					<!--- css id and class for outer --->
					<cfif request.haspositionoptions>
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
					</cfif>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end outer panel --->
</cfoutput>