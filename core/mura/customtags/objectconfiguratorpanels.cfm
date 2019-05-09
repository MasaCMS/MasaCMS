<!--- todo: merge this into parent file objectconfigurator.cfm --->
<cfparam name="attributes.params.rowpaddingtop" default="">
<cfparam name="attributes.params.rowpaddingright" default="">
<cfparam name="attributes.params.rowpaddingbottom" default="">
<cfparam name="attributes.params.rowpaddingleft" default="">
<cfparam name="attributes.params.rowbackgroundcolor" default="">
<cfparam name="attributes.params.rowbackgroundimage" default="">
<cfparam name="attributes.params.rowbackgroundvideo" default="">
<cfparam name="attributes.params.rowbackgroundsize" default="">
<cfparam name="attributes.params.rowbackgroundrepeat" default="">
<cfparam name="attributes.params.rowbackgroundposition" default="">
<cfparam name="attributes.params.rowbackgroundoverlay" default="">
<cfparam name="attributes.params.rowbackgroundparallax" default="">
<cfparam name="attributes.params.isbodyobject" default="false">
<cfparam name="attributes.params.label" default="false">
<cfparam name="attributes.params.metacssstyles.textalign" default="false">

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

					<!--- padding --->
					<div class="mura-control-group">
						<!--- todo: rbkey for padding and placeholders --->
						<label>Padding</label>
						<input type="text" name="rowpaddingtop" placeholder="top" class="objectParam" value="#val(esapiEncode('html_attr',attributes.params.rowpaddingtop))#">
						<input type="text" name="rowpaddingright" placeholder="right" class="objectParam" value="#val(esapiEncode('html_attr',attributes.params.rowpaddingright))#">
						<input type="text" name="rowpaddingbottom" placeholder="bottom" class="objectParam" value="#val(esapiEncode('html_attr',attributes.params.rowpaddingbottom))#">
						<input type="text" name="rowpaddingleft" placeholder="left" class="objectParam" value="#val(esapiEncode('html_attr',attributes.params.rowpaddingleft))#">
					</div>

					<!--- background --->
					<div class="mura-control-group">
						<!--- todo: rbkey for these labels, options and placeholders--->
						<label>Background Color</label>
						<input type="text" name="rowbackgroundcolor" placeholder="Select Color" class="objectParam colorpicker" value="#esapiEncode('html_attr',attributes.params.rowbackgroundcolor)#">
					</div>

					<div class="mura-control-group">
						<label>Background Image [todo:url/existing/upload]</label>
						<input type="text" name="rowbackgroundimage" placeholder="Select Image" class="objectParam" value="#esapiEncode('html_attr',attributes.params.rowbackgroundimage)#">
					</div>

					<div class="mura-control-group">
						<label>Background Video [todo:url/existing/upload]</label>
						<input type="text" name="rowbackgroundvideo" placeholder="Select Video" class="objectParam" value="#esapiEncode('html_attr',attributes.params.rowbackgroundvideo)#">
					</div>

					<div class="mura-control-group">
						<label>Background Size</label>
						<select name="rowbackgroundsize" class="objectParam">
							<option value="auto"<cfif attributes.params.rowbackgroundsize eq 'auto'> 
							selected</cfif>>Auto</option>
							<option value="contain"<cfif attributes.params.rowbackgroundsize eq 'contain'> selected</cfif>>Contain</option>
							<option value="cover"<cfif attributes.params.rowbackgroundsize eq 'cover'> selected</cfif>>Cover</option>
						</select>
					</div>

					<div class="mura-control-group">
						<label>Background Repeat</label>
						<select name="rowbackgroundrepeat" class="objectParam">
							<option value="norepeat"<cfif attributes.params.rowbackgroundrepeat eq 'norepeat'> selected</cfif>>No-repeat</option>
							<option value="repeat"<cfif attributes.params.rowbackgroundrepeat eq 'repeat'> selected</cfif>>Repeat</option>
							<option value="repeatx"<cfif attributes.params.rowbackgroundrepeat eq 'repeatx'> selected</cfif>>Repeat-X</option>
							<option value="repeaty"<cfif attributes.params.rowbackgroundrepeat eq 'repeaty'> selected</cfif>>Repeat-Y</option>
						</select>
					</div>

					<div class="mura-control-group">
						<label>Background Position [todo: bg options]</label>
						<input type="text" name="rowbackgroundposition" placeholder="" class="objectParam" value="#esapiEncode('html_attr',attributes.params.rowbackgroundposition)#">
					</div>

					<div class="mura-control-group">
						<label>Background Overlay [todo: bg options]</label>
						<input type="text" name="rowbackgroundoverlay" placeholder="" class="objectParam" value="#esapiEncode('html_attr',attributes.params.rowbackgroundoverlay)#">
					</div>

					<div class="mura-control-group">
						<label>Background Parallax [todo: bg options]</label>
						<input type="text" name="rowbackgroundparallax" placeholder="" class="objectParam" value="#esapiEncode('html_attr',attributes.params.rowbackgroundparallax)#">
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
							<input name="label" type="text" class="objectParam" maxlength="50" value="#esapiEncode('html_attr',attributes.params.label)#"/>
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
							<input name="metacssid" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.metacssid)#" maxlength="255">
						</div>
						<div class="mura-control-group">
							<label>
								CSS Class
							</label>
							<input name="metacssclass" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.metacssclass)#" maxlength="255">
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
						<input name="contentcssid" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.contentcssid)#" maxlength="255">
					</div>
					<div class="mura-control-group">
						<label>
							CSS Class
						</label>
						<input name="contentcssclass" class="objectParam" type="text" value="#esapiEncode('html_attr',attributes.params.contentcssclass)#" maxlength="255">
					</div>

					<!--- todo: duplicate row options here --->
					<label>TODO: duplicate 'row' panel options here</label>

				</div> <!--- /end container --->
			</div> <!--- /end  mura-panel-body --->
		</div> <!--- /end  mura-panel-collapse --->
	</div> <!--- /end panel --->		
</cfoutput>