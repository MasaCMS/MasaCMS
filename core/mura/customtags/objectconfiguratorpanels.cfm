<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfscript>
	param name="attributes.params.backgroundimageurl" default="";
	
	attributes.globalparams = [
		'backgroundcolor'
		,'backgroundimage'
		,'backgroundoverlay'
		,'backgroundparallax'
		,'backgroundposition'
		,'backgroundrepeat'
		,'backgroundsize'
		,'backgroundvideo'
		,'paddingtop'
		,'paddingright'
		,'paddingbottom'
		,'paddingleft'
		,'paddingall'
		,'textalign'];

	for (p in attributes.globalparams){
		param name="attributes.params.cssstyles.#p#" default="";
		param name="attributes.params.metcssstyles.#p#" default="";
		param name="attributes.params.contentcssstyles.#p#" default="";
	}
</cfscript>

<cfoutput>
	<!--- row --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-row">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-row" aria-expanded="false" aria-controls="panel-row">
					Row
				</a>
			</h4>
		</div>
		<div id="panel-row" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-row">
			<div class="mura-panel-body">
				<div class="container">

					<!--- css id and class for row --->
					<cfif request.haspositionoptions>
						<div class="mura-control-group">
							<label>
								CSS ID
							</label>
							<input name="cssid" class="objectStyle" type="text" value="#esapiEncode('html_attr',attributes.params.cssid)#" maxlength="255">
						</div>
						<div class="mura-control-group">
							<label>
								CSS Class
							</label>
							<input name="cssclass" class="objectStyle" type="text" value="#esapiEncode('html_attr',attributes.params.cssclass)#" maxlength="255">
							<input name="class" type="hidden" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.class)#"/>
						</div>
					</cfif>	

					<!--- padding --->
					<div class="mura-control-group mura-ui-grid">
						<!--- todo: rbkey for padding and placeholders --->
						<label>Padding</label>
						
						<div class="row mura-ui-row">
							<div class="col-xs-3"></div>
							<div class="col-xs-6">
								<label class="px">
									<input type="text" name="padding" id="rowpaddingall" placeholder="All" class="objectStyle" value="#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingall))#"> <span>px</span>
								</label>
							</div>
							<div class="col-xs-3"></div>
						</div>

						<div class="row mura-ui-row">
							<div class="col-xs-3"></div>
							<div class="col-xs-6">
								<label class="px">
									<input type="text" name="paddingTop" id="rowpaddingtop" placeholder="Top" class="objectStyle" value="#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingtop))#"> <span>px</span>
								</label>
							</div>
							<div class="col-xs-3"></div>
						</div>
							
						<div class="row mura-ui-row">
							<div class="col-xs-6">
								<label class="px">
									<input type="text" name="paddingLeft" id="rowpaddingleft" placeholder="Left" class="objectStyle" value="#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingleft))#"> <span>px</span>
								</label>
							</div>
							<div class="col-xs-6">
								<label class="px">
									<input type="text" name="paddingRight" id="rowpaddingright" placeholder="Right" class="objectStyle" value="#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingright))#"> <span>px</span>
								</label>
							</div>
						</div>

						<div class="row mura-ui-row">
							<div class="col-xs-3"></div>
							<div class="col-xs-6">
								<label class="px">
									<input type="text" name="paddingBottom" id="rowpaddingbottom" placeholder="Bottom" class="objectStyle" value="#val(esapiEncode('html_attr',attributes.params.cssstyles.paddingbottom))#"> <span>px</span>
								</label>
							</div>
							<div class="col-xs-3"></div>
						</div>
	
					</div>

					<!--- background --->
					<div class="mura-control-group">
						<!--- todo: rbkey for these labels, options and placeholders--->
						<label>Background Color</label>
						<div class="input-group mura-colorpicker">
							<span class="input-group-addon"><i></i></span>
							<input type="text" id="rowbackgroundcolor" name="backgroundColor" placeholder="Select Color" class="objectStyle" autocomplete="off" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundcolor)#">
						</div>
					</div>

					<div class="mura-control-group">
						<label>Background Image</label>
						<input type="hidden" id="rowbackgroundimage" name="rowBackgroundImage" class="objectParam" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundimage)#">
						<input type="text" id="rowbackgroundimageurl" name="backgroundImageURL" placeholder="Select Image" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.backgroundimageurl)#">
						<button type="button" class="btn mura-ckfinder" data-target="backgroundimageurl" data-completepath="false">Select File</button>

<!--- todo: are we using bigui? --->
<!---	<a class="bigui__launch" data-rel="bigui__rowbgrdimg" href="##">Select Image</a> --->					

					</div>

					<div class="mura-control-group">
						<label>Background Video [todo:url/existing/upload]</label>
						<input type="text" id="rowbackgroundvideo" name="backgroundVideo" placeholder="Select Video" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundvideo)#">
					</div>

					<div class="mura-control-group">
						<label>Background Size</label>
						<select id="rowbackgroundsize" name="backgroundSize" class="objectStyle">
							<option value="auto"<cfif attributes.params.cssstyles.backgroundsize eq 'auto'> 
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.cssstyles.backgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.cssstyles.backgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group">
						<label>Background Repeat</label>
						<select id="rowbackgroundrepeat" name="backgroundRepeat" class="objectStyle">
							<option value="no-repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeat-x"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeat-y"<cfif attributes.params.cssstyles.backgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group">
						<label>Background Position [todo: bg options]</label>
						<input type="text" id="rowbackgroundposition" name="backgroundPosition" placeholder="" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundposition)#">
					</div>

					<div class="mura-control-group">
						<label>Background Overlay [todo: bg options]</label>
						<input type="text" id="rowbackgroundoverlay" name="backgroundOverlay" placeholder="" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundoverlay)#">
					</div>

					<div class="mura-control-group">
						<label>Background Parallax [todo: bg options]</label>
						<input type="text" id="rowbackgroundparallax" name="backgroundParallax" placeholder="" class="objectStyle" value="#esapiEncode('html_attr',attributes.params.cssstyles.backgroundparallax)#">
					</div>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end panel --->

	<cfif request.hasmetaoptions and not (IsBoolean(attributes.params.isbodyobject) and attributes.params.isbodyobject)>
		<!--- label --->
		<div class="mura-panel panel">
			<div class="mura-panel-heading" role="tab" id="heading-label">
				<h4 class="mura-panel-title">
					<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-label" aria-expanded="false" aria-controls="panel-label">
						Label
					</a>
				</h4>
			</div>
			<div id="panel-label" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-label">
				<div class="mura-panel-body">
					<div class="container" id="labelContainer">

						<!--- label text --->
						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.text')#</label>
							<input name="label" type="text" class="objectStyle" maxlength="50" value="#esapiEncode('html_attr',attributes.params.label)#"/>
						</div>
						<!--- label alignment --->
						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.alignment')#</label>
							<select name="textAlign" class="metaStyle">
								<option value="">--</option>
								<option value="left"<cfif attributes.params.metacssstyles.textalign eq 'left'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
								<option value="right"<cfif attributes.params.metacssstyles.textalign eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
								<option value="center"<cfif attributes.params.metacssstyles.textalign eq 'center'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
								<option value="justify"<cfif attributes.params.metacssstyles.textalign eq 'justify'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.justify')#</option>
							</select>
						</div>
						<!--- css id and class for label --->
						<div class="mura-control-group">
							<label>
								CSS ID
							</label>
							<input name="metacssid" class="objectStyle" type="text" value="#esapiEncode('html_attr',attributes.params.metacssid)#" maxlength="255">
						</div>
						<div class="mura-control-group">
							<label>
								CSS Class
							</label>
							<input name="metacssclass" class="objectStyle" type="text" value="#esapiEncode('html_attr',attributes.params.metacssclass)#" maxlength="255">
						</div>

						<!--- todo: duplicate row options here --->
						<label>TODO: duplicate 'row' panel options here</label>

					</div> <!--- /end container --->
				</div> <!--- /end  mura-panel-body --->
			</div> <!--- /end  mura-panel-collapse --->
		</div> <!--- /end panel --->
	</cfif>
	<!--- content --->
	<div class="mura-panel panel">
		<div class="mura-panel-heading" role="tab" id="heading-content">
			<h4 class="mura-panel-title">
				<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-content" aria-expanded="false" aria-controls="panel-content">
					Content
				</a>
			</h4>
		</div>
		<div id="panel-content" class="panel-collapse collapse" role="tabpanel" aria-contentledby="heading-content">
			<div class="mura-panel-body">
				<div class="container">

					<div class="mura-control-group">
						<label>
							CSS ID
						</label>
						<input name="contentcssid" class="objectStyle" type="text" value="#esapiEncode('html_attr',attributes.params.contentcssid)#" maxlength="255">
					</div>
					<div class="mura-control-group">
						<label>
							CSS Class
						</label>
						<input name="contentcssclass" class="objectStyle" type="text" value="#esapiEncode('html_attr',attributes.params.contentcssclass)#" maxlength="255">
					</div>

					<!--- todo: duplicate row options here --->
					<label>TODO: duplicate 'row' panel options here</label>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end panel --->		
</cfoutput>