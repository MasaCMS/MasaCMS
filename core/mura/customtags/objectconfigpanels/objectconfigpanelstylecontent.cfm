<cfoutput>

<div class="mura-panel-group" id="panels-style-content">

		<!--- panel 1: layout --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-content" href="##panel-style-content-1">Layout
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-content-1" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<!--- text alignment --->
							<div class="mura-control-group">
								<label>Text Alignment</label>
								<select name="textAlign" class="contentStyle">
									<option value="">--</option>
									<option value="left"<cfif attributes.params.stylesupport.contentstyles.textalign eq 'left'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
									<option value="right"<cfif attributes.params.stylesupport.contentstyles.textalign eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
									<option value="center"<cfif attributes.params.stylesupport.contentstyles.textalign eq 'center'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
									<option value="justify"<cfif attributes.params.stylesupport.contentstyles.textalign eq 'justify'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.justify')#</option>
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
												<input type="text" name="margin" id="contentmarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.marginall))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginall))#</cfif>">
											</label>
											<select id="contentmarginuom" name="contentmarginuom" class="styleSupport">
												<cfloop list="px,%,em,rem" index="u">
													<option value="#u#"<cfif attributes.params.styleSupport.contentmarginuom eq u> selected</cfif>>#u#</option>
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
												<input type="text" name="contentMarginTop" id="contentmargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.margintop))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.margintop))#</cfif>">
											</label>
											<input type="hidden" name="marginTop" id="contentmargintopval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.margintop)#">
										</div>
										<div class="col-xs-3"></div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="contentMarginLeft" id="contentmarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginleft))#</cfif>">
											</label>
											<input type="hidden" name="marginLeft" id="contentmarginleftval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginleft)#">
										</div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="contentMarginRight" id="contentmarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.marginright))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginright))#</cfif>">
											</label>
											<input type="hidden" name="marginRight" id="contentmarginrightval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginright)#">
										</div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-3"></div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="contentMarginBottom" id="contentmarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginbottom))#</cfif>">
											</label>
											<input type="hidden" name="marginBottom" id="contentmarginbottomval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.marginbottom)#">
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
												<input type="text" name="padding" id="contentpaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingall))#</cfif>">
											</label>
											<select id="contentpaddinguom" name="contentpaddinguom" class="styleSupport">
												<cfloop list="px,%,em,rem" index="u">
													<option value="#u#"<cfif attributes.params.styleSupport.contentpaddinguom eq u> selected</cfif>>#u#</option>
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
												<input type="text" name="contentPaddingTop" id="contentpaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingtop))#</cfif>">
											</label>
											<input type="hidden" name="paddingTop" id="contentpaddingtopval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingtop)#">
										</div>
										<div class="col-xs-3"></div>
									</div>

									<div class="row mura-ui-row">
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="contentPaddingLeft" id="contentpaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingleft))#</cfif>">
											</label>
											<input type="hidden" name="paddingLeft" id="contentpaddingleftval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingleft)#">
										</div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="contentPaddingRight" id="contentpaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingright))#</cfif>">
											</label>
											<input type="hidden" name="paddingRight" id="contentpaddingrightval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingright)#">
										</div>
									</div>
									<div class="row mura-ui-row">
										<div class="col-xs-3"></div>
										<div class="col-xs-6">
											<label class="mura-serial">
												<input type="text" name="contentPaddingBottom" id="contentpaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.contentstyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingbottom))#</cfif>">
											</label>
											<input type="hidden" name="paddingBottom" id="contentpaddingbottomval" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.paddingbottom)#">
										</div>
										<div class="col-xs-3"></div>
									</div>
								</div>

							</div>

            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 2: theme --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-content" href="##panel-style-content-2">Theme
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-content-2" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<!--- text color --->
							<div class="mura-control-group">
								<!--- todo: rbkey for these labels, options and placeholders--->
								<label>Text Color</label>

								<div class="input-group mura-colorpicker">
									<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
									<input type="text" id="contenttextcolor" name="color" class="contentStyle" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.color)#">
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
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-content" href="##panel-style-content-3">Background
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-content-3" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<!--- background --->
							<div class="mura-control-group">
								<!--- todo: rbkey for these labels, options and placeholders--->
								<label>Background Color</label>
								<div class="input-group mura-colorpicker" id="contentbackgroundcustom">
									<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
									<input type="text" id="contentbackgroundcolor" name="backgroundColor" class="contentStyle" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundcolor)#">
								</div>
							</div>

							<div class="mura-control-group">
								<label>Background Image</label>
								<input type="hidden" id="contentbackgroundimage" name="backgroundImage" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundimage)#">
								<input type="text" id="contentbackgroundimageurl" name="contentbackgroundimageurl" placeholder="URL" class="styleSupport" value="#esapiEncode('html_attr',attributes.params.styleSupport.contentbackgroundimageurl)#">
								<button type="button" class="btn" data-target="contentbackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
							</div>

							<div class="mura-control-group content-css-bg-option" style="display:none;">
								<label>Background Size</label>
								<select id="contentbackgroundsize" name="backgroundSize" class="contentStyle">
									<option value="auto"<cfif attributes.params.stylesupport.contentstyles.backgroundsize eq 'auto'>
									selected</cfif>>Auto</option>
									<option value="contain"<cfif attributes.params.stylesupport.contentstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
									<option value="cover"<cfif attributes.params.stylesupport.contentstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
								</select>
							</div>

							<div class="mura-control-group content-css-bg-option" style="display:none;">
								<label>Background Repeat</label>
								<select id="contentbackgroundrepeat" name="backgroundRepeat" class="contentStyle">
									<option value="no-repeat"<cfif attributes.params.stylesupport.contentstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
									<option value="repeat"<cfif attributes.params.stylesupport.contentstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
									<option value="repeat-x"<cfif attributes.params.stylesupport.contentstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
									<option value="repeat-y"<cfif attributes.params.stylesupport.contentstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
								</select>
							</div>

							<div class="mura-control-group content-css-bg-option" style="display:none;">
								<label>Background Attachment</label>
								<select name="backgroundAttachment" class="contentStyle">
									<option value="scroll"<cfif attributes.params.stylesupport.contentstyles.backgroundAttachment eq 'scroll'>
									selected</cfif>>Scroll</option>
									<option value="Fixed"<cfif attributes.params.stylesupport.contentstyles.backgroundAttachment eq 'fixed'> selected</cfif>>Fixed</option>
								</select>
							</div>

							<div class="mura-control-group mura-ui-grid content-css-bg-option" style="display:none;">
								<label>Background Position</label>

								<div class="mura-ui-row">
									<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
									<div class="col-xs-8">
										<div class="mura-input-group">
											<label>
												<input type="text" id="contentbackgroundpositionynum" name="contentBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundpositiony))#</cfif>" style="display: none;">
											</label>

											<select id="contentbackgroundpositiony" name="contentBackgroundPositionY" class="styleSupport" data-numfield="contentbackgroundpositionynum">
												<cfloop list="Top,Center,Bottom,%,px" index="p">
													<option value="#lcase(p)#"<cfif attributes.params.stylesupport.contentstyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
												</cfloop>
											</select>

											<input type="hidden" id="contentbackgroundpositionyval" name="backgroundPositionY" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundpositiony)#">

										</div>
									</div>
								</div>

								<div class="row mura-ui-row">
									<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
									<div class="col-xs-8">
										<div class="mura-input-group">
											<label>
												<input type="text" id="contentbackgroundpositionxnum" name="contentBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundpositionx))#</cfif>" style="display: none;">
											</label>

											<select id="contentbackgroundpositionx" name="contentBackgroundPositionX" class="styleSupport" data-numfield="contentbackgroundpositionxnum">
												<cfloop list="Left,Center,Right,%,px" index="p">
													<option value="#lcase(p)#"<cfif attributes.params.stylesupport.contentstyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
												</cfloop>
											</select>

											<input type="hidden" id="contentbackgroundpositionxval" name="backgroundPositionX" class="contentStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.backgroundpositionx)#">

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
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-content" href="##panel-style-content-4">Custom
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-content-4" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<div class="mura-control-group">
								<label>
								Z-Index
								</label>
								<input name="zIndex" class="contentStyle numeric" type="text" value="#esapiEncode('html_attr',attributes.params.stylesupport.contentstyles.zindex)#" maxlength="5">
							</div>
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
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

</div> <!--- /.mura-panel-group --->

</cfoutput>