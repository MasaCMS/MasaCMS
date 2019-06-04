<cfoutput>
	<!--- outer --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-outer">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-outer" aria-expanded="false" aria-controls="panel-style-outer">
					Module
				</a>
			</h4>
		</div>
		<div id="panel-style-outer" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-outer">
			<div class="mura-panel-body">
				<div class="container">
					<cfif arrayLen(request.modulethemearray)>
					<div class="mura-control-group">
						<label>Theme</label>
						<select name="moduletheme">
							<option value="">--</option>
							<cfloop array="#request.modulethemearray#" index="theme">
								<option value="#theme.class#"<cfif  listFind(attributes.params.class,theme.class,' ')> selected</cfif>>#esapiEncode('html',theme.name)#</option>
							</cfloop>
						</select>
					</div>
					</cfif>
					<cfif request.haspositionoptions>

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
					</cfif>

					<div class="mura-control-group">
						<!--- todo: rbkey for margin and placeholders --->
						<label>Minimum Height</label>

						<div class="row mura-ui-row">

								<div class="mura-input-group">
									<label class="mura-serial">
										<input type="text" name="outerminheight" id="outerminheightnum" placeholder="" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.minheight))>#val(esapiEncode('html_attr',attributes.params.cssstyles.minheight))#</cfif>">
									</label>
									<select id="outerminheightuom" name="outerminheightuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.outerminheightuom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
								<input type="hidden" name="minHeight" id="outerminheightuomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.minheight)#">
						</div>
					</div>

					<!--- margin --->
					<div class="mura-control-group mura-ui-grid">
						<!--- todo: rbkey for margin and placeholders --->
						<label>Margin</label>

						<div class="row mura-ui-row">
							<div class="col-xs-8 center">
								<div class="mura-input-group">
									<label class="mura-serial">
										<input type="text" name="margin" id="outermarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginall))#</cfif>">
									</label>
									<select id="outermarginuom" name="outermarginuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.outermarginuom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="outermarginadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="outermarginadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerMarginTop" id="outermargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.cssstyles.margintop))#</cfif>">
									</label>
									<input type="hidden" name="marginTop" id="outermargintopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.margintop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerMarginLeft" id="outermarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginleft))#</cfif>">
									</label>
									<input type="hidden" name="marginLeft" id="outermarginleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerMarginRight" id="outermarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginright))#</cfif>">
									</label>
									<input type="hidden" name="marginRight" id="outermarginrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="outerMarginBottom" id="outermarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginbottom))#</cfif>">
									</label>
									<input type="hidden" name="marginBottom" id="outermarginbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginbottom)#">
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
										<input type="text" name="padding" id="outerpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingall))#</cfif>">
									</label>
									<select id="outerpaddinguom" name="outerpaddinguom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.outerpaddinguom eq u> selected</cfif>>#u#</option>
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

					<!--- background
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
							<input type="text" id="outerbackgroundcolor" name="backgroundColor" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundcolor)#">
						</div>
					</div>
					--->

					<div class="mura-control-group">
						<label>Background Image</label>
						<input type="hidden" id="outerbackgroundimage" name="backgroundImage" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundimage)#">
						<input type="text" id="outerbackgroundimageurl" name="outerbackgroundimageurl" placeholder="URL" class="objectParam" value="#esapiEncode('html_attr',attributes.params.outerbackgroundimageurl)#">
						<button type="button" class="btn mura-ckfinder" data-target="outerbackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
					</div>

					<div class="mura-control-group outer-css-bg-option" style="display:none;">
						<label>Background Size</label>
						<select id="outerbackgroundsize" name="backgroundSize" class="objectStyle">
							<option value="auto"<cfif attributes.params.cssstyles.backgroundsize eq 'auto'>
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.cssstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.cssstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group outer-css-bg-option" style="display:none;">
						<label>Background Repeat</label>
						<select id="outerbackgroundrepeat" name="backgroundRepeat" class="objectStyle">
							<option value="no-repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeat-x"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeat-y"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group outer-css-bg-option" style="display:none;">
						<label>Background Attachment</label>
						<select name="backgroundAttachment" class="objectStyle">
							<option value="scroll"<cfif attributes.params.cssstyles.backgroundAttachment eq 'scroll'>
							selected</cfif>>Scroll</option>
							<option value="Fixed"<cfif attributes.params.cssstyles.backgroundAttachment eq 'fixed'> selected</cfif>>Fixed</option>
						</select>
					</div>

					<div class="mura-control-group outer-css-bg-option" style="display:none;">
						<label>Background Opacity</label>
						<select name="outerbackgroundopacity">
							<option value="">--</option>
							<cfloop from="1" to="10" index="i">
								<option value="mura-op-#i#"<cfif listFind(attributes.params.class,'mura-op-#i#',' ')> selected</cfif>>#i#0%</option>
							</cfloop>
						</select>
					</div>

					<div class="mura-control-group mura-ui-grid outer-css-bg-option" style="display:none;">
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

					<!---
					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Overlay</label>
						<input type="text" id="outerbackgroundoverlay" name="backgroundOverlay" placeholder="" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundoverlay)#">
					</div>
					--->

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
						</div>
					</cfif>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end outer panel --->
</cfoutput>
