<!--- todo: document nested configurator panel syntax --->
<!--- 
<div class="mura-panel-group" id="panels-style-object">

		<!--- panel 1: layout --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-object" href="##panel-style-object-1">Layout
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-object-1" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
            
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

</div> <!--- /.mura-panel-group --->
--->

<cfoutput>

<div class="mura-panel-group" id="panels-style-object">

		<!--- panel 1: layout --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-object" href="##panel-style-object-1">Layout
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-object-1" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            	<!--- panel contents --->	

							<cfif request.haspositionoptions>
								<div class="mura-control-group">
									<label>Target Device</label>
									<select name="breakpoint" class="classtoggle">
									<option value="">--</option>
									<option value="mura-sm"<cfif listFind(attributes.params.class,'mura-sm',' ')> selected</cfif>>Tablet (768px+)</option>
									<option value="mura-md"<cfif listFind(attributes.params.class,'mura-md',' ')> selected</cfif>>Laptop (992px+)</option>
									<option value="mura-lg"<cfif listFind(attributes.params.class,'mura-lg',' ')> selected</cfif>> Desktop (1200px+)</option>
									</select>
								</div>

								<div class="mura-control-group">
									<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.alignment')#</label>
									<select name="alignment" class="classtoggle">
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
									<select name="width" id="objectwidthsel" class="classtoggle">
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
											<select name="constraincontent" class="classtoggle">
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
												<input type="text" name="objectminheight" id="objectminheightnum" placeholder="0" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.minheight))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.minheight))#</cfif>">
											</label>
											<select id="objectminheightuom" name="objectminheightuom" class="styleSupport">
												<cfloop list="px,%,em,rem" index="u">
													<option value="#u#"<cfif attributes.params.stylesupport.objectminheightuom eq u> selected</cfif>>#u#</option>
												</cfloop>
											</select>
										</div>
										<input type="hidden" name="minHeight" id="objectminheightuomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.minheight)#">
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
												<input type="text" name="margin" id="objectmarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginall))#</cfif>">
											</label>
											<select id="objectmarginuom" name="objectmarginuom" class="styleSupport">
												<cfloop list="px,%,em,rem" index="u">
													<option value="#u#"<cfif attributes.params.stylesupport.objectmarginuom eq u> selected</cfif>>#u#</option>
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
												<input type="text" name="objectMarginTop" id="objectmargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.margintop))#</cfif>">
											</label>
											<input type="hidden" name="marginTop" id="objectmargintopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.margintop)#">
										</div>
										<div class="col-xs-3"></div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="objectMarginLeft" id="objectmarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginleft))#</cfif>">
											</label>
											<input type="hidden" name="marginLeft" id="objectmarginleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginleft)#">
										</div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="objectMarginRight" id="objectmarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginright))#</cfif>">
											</label>
											<input type="hidden" name="marginRight" id="objectmarginrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginright)#">
										</div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-3"></div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="objectMarginBottom" id="objectmarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginbottom))#</cfif>">
											</label>
											<input type="hidden" name="marginBottom" id="objectmarginbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.marginbottom)#">
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
												<input type="text" name="padding" id="objectpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingall))#</cfif>">
											</label>
											<select id="objectpaddinguom" name="objectpaddinguom" class="styleSupport">
												<cfloop list="px,%,em,rem" index="u">
													<option value="#u#"<cfif attributes.params.styleSupport.objectpaddinguom eq u> selected</cfif>>#u#</option>
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
												<input type="text" name="objectPaddingTop" id="objectpaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingtop))#</cfif>">
											</label>
											<input type="hidden" name="paddingTop" id="objectpaddingtopval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingtop)#">
										</div>
										<div class="col-xs-3"></div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="objectPaddingLeft" id="objectpaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingleft))#</cfif>">
											</label>
											<input type="hidden" name="paddingLeft" id="objectpaddingleftval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingleft)#">
										</div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="objectPaddingRight" id="objectpaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingright))#</cfif>">
											</label>
											<input type="hidden" name="paddingRight" id="objectpaddingrightval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingright)#">
										</div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-3"></div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="objectPaddingBottom" id="objectpaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.objectstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingbottom))#</cfif>">
											</label>
											<input type="hidden" name="paddingBottom" id="objectpaddingbottomval" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.paddingbottom)#">
										</div>
										<div class="col-xs-3"></div>
									</div>
								</div>

							</div>

            	<!--- /panel contents --->
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 2: theme --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-object" href="##panel-style-object-2">Theme
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-object-2" class="panel-collapse collapse in">
            <div class="mura-panel-body">
         		<!--- panel contents --->	

         				<!--- theme --->
								<cfif arrayLen(request.modulethemeoptions)>
								<div class="mura-control-group">
									<label>Theme</label>
									<select name="moduletheme" class="classtoggle">
										<option value="">--</option>
										<cfloop array="#request.modulethemeoptions#" index="theme">
											<option value="#theme.value#"<cfif  listFind(attributes.params.class,theme.value,' ')> selected</cfif>>#esapiEncode('html',theme.name)#</option>
										</cfloop>
									</select>
								</div>
								</cfif>

								<!--- text color --->
								<div class="mura-control-group">
									<!--- todo: rbkey for these labels, options and placeholders--->
									<label>Text Color</label>
									<div class="input-group mura-colorpicker">
										<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
										<input type="text" id="objecttextcolor" name="color" class="objectStyle" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.color)#">
									</div>
								</div>

         		<!--- /end panel contents --->
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 3: background --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-object" href="##panel-style-object-3">Background
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-object-3" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
						<!--- background --->
						<div class="mura-control-group">
							<!--- todo: rbkey for these labels, options and placeholders--->
							<label>Background Color</label>
							<div class="input-group mura-colorpicker" id="objectbackgroundcustom">
								<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
								<input type="text" id="objectbackgroundcolor" name="backgroundColor" class="objectStyle" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundcolor)#">
							</div>
						</div>

						<div class="mura-control-group">
							<label>Background Image</label>
							<input type="hidden" id="objectbackgroundimage" name="backgroundImage" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundimage)#">
							<input type="text" id="objectbackgroundimageurl" name="objectbackgroundimageurl" placeholder="URL" class="styleSupport" value="#esapiEncode('html_attr',attributes.params.styleSupport.objectbackgroundimageurl)#">
							<button type="button" class="btn mura-finder" data-resourcetype="root" data-target="objectbackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
						</div>

						<div class="mura-control-group object-css-bg-option" style="display:none;">
							<label>Background Size</label>
							<select id="objectbackgroundsize" name="backgroundSize" class="objectStyle">
								<option value="auto"<cfif attributes.params.stylesupport.objectstyles.backgroundsize eq 'auto'>
								selected</cfif>>Auto</option>
								<option value="contain"<cfif attributes.params.stylesupport.objectstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
								<option value="cover"<cfif attributes.params.stylesupport.objectstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
							</select>
						</div>

						<div class="mura-control-group object-css-bg-option" style="display:none;">
							<label>Background Repeat</label>
							<select id="objectbackgroundrepeat" name="backgroundRepeat" class="objectStyle">
								<option value="no-repeat"<cfif attributes.params.stylesupport.objectstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
								<option value="repeat"<cfif attributes.params.stylesupport.objectstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
								<option value="repeat-x"<cfif attributes.params.stylesupport.objectstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
								<option value="repeat-y"<cfif attributes.params.stylesupport.objectstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
							</select>
						</div>

						<div class="mura-control-group object-css-bg-option" style="display:none;">
							<label>Background Attachment</label>
							<select name="backgroundAttachment" class="objectStyle">
								<option value="scroll"<cfif attributes.params.stylesupport.objectstyles.backgroundAttachment eq 'scroll'>
								selected</cfif>>Scroll</option>
								<option value="Fixed"<cfif attributes.params.stylesupport.objectstyles.backgroundAttachment eq 'fixed'> selected</cfif>>Fixed</option>
							</select>
						</div>

						<div class="mura-control-group mura-ui-grid object-css-bg-option" style="display:none;">
							<label>Background Position</label>

							<div class="mura-ui-row">
								<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
								<div class="col-xs-8">
									<div class="mura-input-group">
										<label>
											<input type="text" id="objectbackgroundpositionynum" name="objectBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundpositiony))#</cfif>" style="display: none;">
										</label>

										<select id="objectbackgroundpositiony" name="objectBackgroundPositionY" class="styleSupport" data-numfield="objectbackgroundpositionynum">
											<cfloop list="Top,Center,Bottom,%,px" index="p">
												<option value="#lcase(p)#"<cfif attributes.params.stylesupport.objectstyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
											</cfloop>
										</select>

										<input type="hidden" id="objectbackgroundpositionyval" name="backgroundPositionY" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundpositiony)#">

									</div>
								</div>
							</div>

							<div class="row mura-ui-row">
								<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
								<div class="col-xs-8">
									<div class="mura-input-group">
										<label>
											<input type="text" id="objectbackgroundpositionxnum" name="objectBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundpositionx))#</cfif>" style="display: none;">
										</label>

										<select id="objectbackgroundpositionx" name="objectBackgroundPositionX" class="styleSupport" data-numfield="objectbackgroundpositionxnum">
											<cfloop list="Left,Center,Right,%,px" index="p">
												<option value="#lcase(p)#"<cfif attributes.params.stylesupport.objectstyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
											</cfloop>
										</select>

										<input type="hidden" id="objectbackgroundpositionxval" name="backgroundPositionX" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.backgroundpositionx)#">

									</div>
								</div>
							</div>
						</div>            
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 4: custom --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-object" href="##panel-style-object-4">Custom
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-object-4" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
						            
							<div class="mura-control-group">
								<label>
								Z-Index
								</label>
								<input name="zIndex" class="objectStyle numeric" type="text" value="#esapiEncode('html_attr',attributes.params.stylesupport.objectstyles.zindex)#" maxlength="5">
							</div>
							<div class="mura-control-group">
								<label>
									CSS Class
								</label>
								<input name="cssclass" class="objectParam classtoggle" type="text" value="#esapiEncode('html_attr',attributes.params.cssclass)#" maxlength="255">
							</div>
							<div class="mura-control-group">
								<label>
									Custom CSS Styles
								</label>
								<cfoutput>
								<textarea id="customstylesedit" style="min-height: 250px">#esapiEncode('html',attributes.params.stylesupport.css)#</textarea>
								</cfoutput>
								<button class="btn" id="applystyles">Apply</button>
								<script>
									Mura('##applystyles').click(function(){
										jQuery('##csscustom').val(Mura('##customstylesedit').val()).trigger('change');
									})
								</script>
							</div>
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

</div> <!--- /.mura-panel-group --->
</cfoutput>