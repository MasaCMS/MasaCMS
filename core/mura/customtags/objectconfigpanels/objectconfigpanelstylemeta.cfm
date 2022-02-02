<cfoutput>
<div class="mura-panel-group" id="panels-style-meta">

		<!--- panel 1: label --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-meta" href="##panel-style-meta-1">Position
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-meta-1" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<!--- label position --->
							<div class="mura-control-group">
								<label>Label Position</label>
								<select name="labelposition" class="classtoggle">
								<option value="">--</option>
								<option value="mura-object-label-left"<cfif listFind(attributes.params.class,'mura-object-label-left',' ')> selected</cfif>>Left</option>
								<option value="mura-object-label-top"<cfif listFind(attributes.params.class,'mura-object-label-top',' ')> selected</cfif>>Top</option>
								<option value="mura-object-label-right"<cfif listFind(attributes.params.class,'mura-object-label-right',' ')> selected</cfif>>Right</option>
								</select>
							</div>

							<!--- label alignment --->
							<div class="mura-control-group">
								<label>Text Alignment</label>
								<select name="float" class="metaStyle">
									<option value="">--</option>
									<option value="left"<cfif attributes.params.stylesupport.metastyles.float eq 'left'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
									<option value="none"<cfif attributes.params.stylesupport.metastyles.float eq 'none'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
									<option value="right"<cfif attributes.params.stylesupport.metastyles.float eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
								</select>
							</div>            
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 2: layout --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-meta" href="##panel-style-meta-2">Layout
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-meta-2" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
								<!--- margin --->
								<div class="mura-control-group mura-ui-grid">
									<!--- todo: rbkey for margin and placeholders --->
									<label>Margin</label>

									<div class="row mura-ui-row">
										<div class="col-xs-8 center">
											<div class="mura-input-group">
												<label class="mura-serial">
													<input type="text" name="margin" id="metamarginall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.marginall))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginall))#</cfif>">
												</label>
												<select id="metamarginuom" name="metamarginuom" class="styleSupport">
													<cfloop list="px,%,em,rem" index="u">
														<option value="#u#"<cfif attributes.params.styleSupport.metamarginuom eq u> selected</cfif>>#u#</option>
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
													<input type="text" name="metaMarginTop" id="metamargintop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.margintop))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.margintop))#</cfif>">
												</label>
												<input type="hidden" name="marginTop" id="metamargintopval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.margintop)#">
											</div>
											<div class="col-xs-3"></div>
										</div>

										<div class="row mura-ui-row">
											<div class="col-xs-6">
												<label class="mura-serial">
													<input type="text" name="metaMarginLeft" id="metamarginleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.marginleft))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginleft))#</cfif>">
												</label>
												<input type="hidden" name="marginLeft" id="metamarginleftval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginleft)#">
											</div>
											<div class="col-xs-6">
												<label class="mura-serial">
													<input type="text" name="metaMarginRight" id="metamarginright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.marginright))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginright))#</cfif>">
												</label>
												<input type="hidden" name="marginRight" id="metamarginrightval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginright)#">
											</div>
										</div>

										<div class="row mura-ui-row">
											<div class="col-xs-3"></div>
											<div class="col-xs-6">
												<label class="mura-serial">
													<input type="text" name="metaMarginBottom" id="metamarginbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.marginbottom))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginbottom))#</cfif>">
												</label>
												<input type="hidden" name="marginBottom" id="metamarginbottomval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.marginbottom)#">
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
													<input type="text" name="padding" id="metapaddingall" placeholder="All" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.paddingall))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingall))#</cfif>">
												</label>
												<select id="metapaddinguom" name="metapaddinguom" class="styleSupport">
													<cfloop list="px,%,em,rem" index="u">
														<option value="#u#"<cfif attributes.params.styleSupport.metapaddinguom eq u> selected</cfif>>#u#</option>
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
													<input type="text" name="metaPaddingTop" id="metapaddingtop" placeholder="Top" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.paddingtop))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingtop))#</cfif>">
												</label>
												<input type="hidden" name="paddingTop" id="metapaddingtopval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingtop)#">
											</div>
											<div class="col-xs-3"></div>
										</div>

										<div class="row mura-ui-row">
											<div class="col-xs-6">
												<label class="mura-serial">
													<input type="text" name="metaPaddingLeft" id="metapaddingleft" placeholder="Left" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.paddingleft))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingleft))#</cfif>">
												</label>
												<input type="hidden" name="paddingLeft" id="metapaddingleftval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingleft)#">
											</div>
											<div class="col-xs-6">
												<label class="mura-serial">
													<input type="text" name="metaPaddingRight" id="metapaddingright" placeholder="Right" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.paddingright))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingright))#</cfif>">
												</label>
												<input type="hidden" name="paddingRight" id="metapaddingrightval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingright)#">
											</div>
										</div>

										<div class="row mura-ui-row">
											<div class="col-xs-3"></div>
											<div class="col-xs-6">
												<label class="mura-serial">
													<input type="text" name="metaPaddingBottom" id="metapaddingbottom" placeholder="Bottom" class="numeric serial" value="<cfif len(trim(attributes.params.stylesupport.metastyles.paddingbottom))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingbottom))#</cfif>">
												</label>
												<input type="hidden" name="paddingBottom" id="metapaddingbottomval" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.paddingbottom)#">
											</div>
											<div class="col-xs-3"></div>
										</div>
									</div>

								</div>
            
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 3: layout --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-meta" href="##panel-style-meta-3">Theme
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-meta-3" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<!--- text color --->
							<div class="mura-control-group">
								<label>Text Color</label>
								<div class="input-group mura-colorpicker">
									<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
									<input type="text" id="metatextcolor" name="color" class="metaStyle" placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.color)#">
								</div>
							</div>
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 4: background --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-meta" href="##panel-style-meta-4">Background
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-meta-4" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<!--- background --->
							<div class="mura-control-group">
								<label>Background Color</label>
								<div class="input-group mura-colorpicker" id="metabackgroundcustom">
									<span class="input-group-addon"><i class="mura-colorpicker-swatch"></i></span>
									<input type="text" id="metabackgroundcolor" name="backgroundColor" class="metaStyle"  placeholder="Select Color" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundcolor)#">
								</div>
							</div>

							<div class="mura-control-group">
								<label>Background Image</label>
								<input type="hidden" id="metabackgroundimage" name="backgroundImage" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundimage)#">
								<input type="text" id="metabackgroundimageurl" name="metabackgroundimageurl" placeholder="URL" class="styleSupport" value="#esapiEncode('html_attr',attributes.params.styleSupport.metabackgroundimageurl)#">
								<button type="button" class="btn" data-target="metabackgroundimageurl" data-completepath="false"><i class="mi-image"></i> Select Image</button>
							</div>

							<div class="mura-control-group meta-css-bg-option" style="display:none;">
								<label>Background Size</label>
								<select id="metabackgroundsize" name="backgroundSize" class="metaStyle">
									<option value="auto"<cfif attributes.params.stylesupport.metastyles.backgroundsize eq 'auto'>
									selected</cfif>>Auto</option>
									<option value="contain"<cfif attributes.params.stylesupport.metastyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
									<option value="cover"<cfif attributes.params.stylesupport.metastyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
								</select>
							</div>

							<div class="mura-control-group meta-css-bg-option" style="display:none;">
								<label>Background Repeat</label>
								<select id="metabackgroundrepeat" name="backgroundRepeat" class="metaStyle">
									<option value="no-repeat"<cfif attributes.params.stylesupport.metastyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
									<option value="repeat"<cfif attributes.params.stylesupport.metastyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
									<option value="repeat-x"<cfif attributes.params.stylesupport.metastyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
									<option value="repeat-y"<cfif attributes.params.stylesupport.metastyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
								</select>
							</div>

							<div class="mura-control-group meta-css-bg-option" style="display:none;">
								<label>Background Attachment</label>
								<select name="backgroundAttachment" class="metaStyle">
									<option value="scroll"<cfif attributes.params.stylesupport.metastyles.backgroundAttachment eq 'scroll'>
									selected</cfif>>Scroll</option>
									<option value="Fixed"<cfif attributes.params.stylesupport.metastyles.backgroundAttachment eq 'fixed'> selected</cfif>>Fixed</option>
								</select>
							</div>

							<div class="mura-control-group mura-ui-grid meta-css-bg-option" style="display:none;">
								<label>Background Position</label>

								<div class="mura-ui-row">
									<div class="col-xs-4"><label class="right ui-nested">Vertical</label></div>
									<div class="col-xs-8">
										<div class="mura-input-group">
											<label>
												<input type="text" id="metabackgroundpositionynum" name="metaBackgroundPositionyNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundpositiony))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundpositiony))#</cfif>" style="display: none;">
											</label>

											<select id="metabackgroundpositiony" name="metaBackgroundPositionY" class="styleSupport" data-numfield="metabackgroundpositionynum">
												<cfloop list="Top,Center,Bottom,%,px" index="p">
													<option value="#lcase(p)#"<cfif attributes.params.stylesupport.metastyles.backgroundpositiony contains p> selected</cfif>>#p#</option>
												</cfloop>
											</select>

											<input type="hidden" id="metabackgroundpositionyval" name="backgroundPositionY" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundpositiony)#">

										</div>
									</div>
								</div>

								<div class="row mura-ui-row">
									<div class="col-xs-4"><label class="right ui-nested">Horizontal</label></div>
									<div class="col-xs-8">
										<div class="mura-input-group">
											<label>
												<input type="text" id="metabackgroundpositionxnum" name="metaBackgroundPositionxNum" class="numeric" placeholder="" value="<cfif val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundpositionx))>#val(esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundpositionx))#</cfif>" style="display: none;">
											</label>

											<select id="metabackgroundpositionx" name="metaBackgroundPositionX" class="styleSupport" data-numfield="metabackgroundpositionxnum">
												<cfloop list="Left,Center,Right,%,px" index="p">
													<option value="#lcase(p)#"<cfif attributes.params.stylesupport.metastyles.backgroundpositionx contains p> selected</cfif>>#p#</option>
												</cfloop>
											</select>

											<input type="hidden" id="metabackgroundpositionxval" name="backgroundPositionX" class="metaStyle" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.backgroundpositionx)#">

										</div>
									</div>
								</div>
							</div>
            
            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

		<!--- panel 5: custom --->
    <div class="panel mura-panel">
        <div class="mura-panel-heading">
            <h4 class="mura-panel-title">
                <a class="collapse collapsed" data-toggle="collapse" data-parent="##panels-style-meta" href="##panel-style-meta-5">Custom
                </a>
            </h4>
        </div> <!--- /.mura-panel-heading --->
        <div id="panel-style-meta-5" class="panel-collapse collapse in">
            <div class="mura-panel-body">
            <!--- panel contents --->
							<div class="mura-control-group">
								<label>
								Z-Index
								</label>
								<input name="zIndex" class="metaStyle numeric" type="text" value="#esapiEncode('html_attr',attributes.params.stylesupport.metastyles.zindex)#" maxlength="5">
							</div>
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

            <!--- /end panel contents --->      
            </div> <!--- /.mura-panel-body --->
        </div> <!--- /.panel-collapse --->
    </div> <!--- /.mura-panel --->

</div> <!--- /.mura-panel-group --->
	
</cfoutput>