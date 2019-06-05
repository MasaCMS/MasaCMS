<cfoutput>
	<!--- object --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-style-object">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-style-object" aria-expanded="false" aria-controls="panel-style-object">
					Module
				</a>
			</h4>
		</div>
		<div id="panel-style-object" class="panel-collapse collapse" role="tabpanel" aria-labeledby="heading-style-object">
			<div class="mura-panel-body">
				<div class="container">
					<cfif arrayLen(request.modulethemeoptions)>
					<div class="mura-control-group">
						<label>Theme</label>
						<select name="moduletheme">
							<option value="">--</option>
							<cfloop array="#request.modulethemeoptions#" index="theme">
								<option value="#theme.value#"<cfif  listFind(attributes.params.class,theme.value,' ')> selected</cfif>>#esapiEncode('html',theme.name)#</option>
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
							<option value="mura-center"<cfif listFind(attributes.params.class,'mura-center',' ')> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
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
										<input type="text" name="objectminheight" id="objectminheightnum" placeholder="" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.minheight))>#val(esapiEncode('html_attr',attributes.params.cssstyles.minheight))#</cfif>">
									</label>
									<select id="objectminheightuom" name="objectminheightuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.objectminheightuom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
								<input type="hidden" name="minHeight" id="objectminheightuomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.minheight)#">
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
										<input type="text" name="margin" id="objectmarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginall))#</cfif>">
									</label>
									<select id="objectmarginuom" name="objectmarginuom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.objectmarginuom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="objectmarginadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="objectmarginadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectMarginTop" id="objectmargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.cssstyles.margintop))#</cfif>">
									</label>
									<input type="hidden" name="marginTop" id="objectmargintopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.margintop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectMarginLeft" id="objectmarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginleft))#</cfif>">
									</label>
									<input type="hidden" name="marginLeft" id="objectmarginleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectMarginRight" id="objectmarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginright))#</cfif>">
									</label>
									<input type="hidden" name="marginRight" id="objectmarginrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectMarginBottom" id="objectmarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.cssstyles.marginbottom))#</cfif>">
									</label>
									<input type="hidden" name="marginBottom" id="objectmarginbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.marginbottom)#">
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
										<input type="text" name="padding" id="objectpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingall))#</cfif>">
									</label>
									<select id="objectpaddinguom" name="objectpaddinguom" class="objectParam">
										<cfloop list="px,%,em,rem" index="u">
											<option value="#u#"<cfif attributes.params.objectpaddinguom eq u> selected</cfif>>#u#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col-xs-4">
								<a class="mura-ui-link" data-reveal="objectpaddingadvanced" href="##">Advanced</a>
							</div>
						</div>

						<div id="objectpaddingadvanced" class="mura-ui-inset" style="display: none;">
							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectPaddingTop" id="objectpaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingtop))#</cfif>">
									</label>
									<input type="hidden" name="paddingTop" id="objectpaddingtopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingtop)#">
								</div>
								<div class="col-xs-3"></div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectPaddingLeft" id="objectpaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingleft))#</cfif>">
									</label>
									<input type="hidden" name="paddingLeft" id="objectpaddingleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingleft)#">
								</div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectPaddingRight" id="objectpaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingright))#</cfif>">
									</label>
									<input type="hidden" name="paddingRight" id="objectpaddingrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingright)#">
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-3"></div>
								<div class="col-xs-6">
									<label class="mura-serial">
										<input type="text" name="objectPaddingBottom" id="objectpaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.cssstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom))#</cfif>">
									</label>
									<input type="hidden" name="paddingBottom" id="objectpaddingbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom)#">
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
							<select id="objectbackgroundcolorsel" name="backgroundColorSel" class="objectParam">
								<option value=""<cfif attributes.params.objectbackgroundcolorsel eq ''>
							selected</cfif>>None</option>
								<cfloop from="1" to="#arrayLen(request.colorOptions)#" index="i">
									<cfset c = request.colorOptions[i]>
									<option value="#c['value']#"<cfif attributes.params.objectbackgroundcolorsel eq c['value']>
							selected</cfif> style="background-color:#c['value']#;">#c['name']#</option>
								</cfloop>
								<option value="custom"<cfif attributes.params.objectbackgroundcolorsel eq 'custom'>
							selected</cfif>>Custom</option>
							</select>
						</cfif>
						<div class="input-group mura-colorpicker" id="objectbackgroundcustom" style="<cfif isArray(request.colorOptions) and arrayLen(request.colorOptions)>display: none;</cfif>">
							<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
							<input type="text" id="objectbackgroundcolor" name="backgroundColor" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundcolor)#">
						</div>
					</div>

					<div class="mura-control-group">
						<label>Background Image</label>
						<input type="hidden" id="objectbackgroundimage" name="backgroundImage" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundimage)#">
						<input type="text" id="objectbackgroundimageurl" name="objectbackgroundimageurl" placeholder="URL" class="objectParam" value="#esapiEncode('html_attr',attributes.params.objectbackgroundimageurl)#">
						<button type="button" class="btn mura-ckfinder" data-target="objectbackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
					</div>

					<div class="mura-control-group object-css-bg-option" style="display:none;">
						<label>Background Size</label>
						<select id="objectbackgroundsize" name="backgroundSize" class="objectStyle">
							<option value="auto"<cfif attributes.params.cssstyles.backgroundsize eq 'auto'>
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.cssstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.cssstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group object-css-bg-option" style="display:none;">
						<label>Background Repeat</label>
						<select id="objectbackgroundrepeat" name="backgroundRepeat" class="objectStyle">
							<option value="no-repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeat-x"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeat-y"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group object-css-bg-option" style="display:none;">
						<label>Background Attachment</label>
						<select name="backgroundAttachment" class="objectStyle">
							<option value="scroll"<cfif attributes.params.cssstyles.backgroundAttachment eq 'scroll'>
							selected</cfif>>Scroll</option>
							<option value="Fixed"<cfif attributes.params.cssstyles.backgroundAttachment eq 'fixed'> selected</cfif>>Fixed</option>
						</select>
					</div>

					<div class="mura-control-group mura-ui-grid object-css-bg-option" style="display:none;">
						<label>Background Position</label>

						<div class="mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="objectbackgroundpositionynum" name="objectBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositiony))#</cfif>" style="display: none;">
									</label>

									<select id="objectbackgroundpositiony" name="objectBackgroundPositionY" class="objectParam" data-numfield="objectbackgroundpositionynum">
										<cfloop list="Top,Center,Bottom,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.cssstyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="objectbackgroundpositionyval" name="backgroundPositionY" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositiony)#">

								</div>
							</div>
						</div>

						<div class="row mura-ui-row">
							<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
							<div class="col-xs-8">
								<div class="mura-input-group">
									<label>
										<input type="text" id="objectbackgroundpositionxnum" name="objectBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositionx))#</cfif>" style="display: none;">
									</label>

									<select id="objectbackgroundpositionx" name="objectBackgroundPositionX" class="objectParam" data-numfield="objectbackgroundpositionxnum">
										<cfloop list="Left,Center,Right,%,px" index="p">
											<option value="#lcase(p)#"<cfif attributes.params.cssstyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
										</cfloop>
									</select>

									<input type="hidden" id="objectbackgroundpositionxval" name="backgroundPositionX" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundpositionx)#">

								</div>
							</div>
						</div>
					</div>

					<div class="mura-control-group css-bg-option" style="display:none;">
						<label>Background Overlay</label>
						<input type="text" id="objectbackgroundoverlay" name="backgroundOverlay" placeholder="" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundoverlay)#">
					</div>

					<!--- css id and class for object --->
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
	</div> <!--- /end object panel --->
</cfoutput>
