 <!--- license goes here --->
<cfsilent>
	<cfparam name="objectParams.buttonlabel" default="">
	<cfparam name="objectParams.buttonsize" default="">
	<cfparam name="objectParams.target" default="">
	<cfparam name="objectParams.url" default="">
</cfsilent>
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
	<div>
		<div class="mura-layout-row">

			<div class="mura-control-group">
				<label class="mura-control-label">Button Label</label>
				<input type="text" placeholder="Button Label" id="buttonlabel" name="buttonlabel" class="objectParam" value="#esapiEncode('html_attr',objectparams.buttonlabel)#"/>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Button Action</label>
				<select id="target" name="target" class="objectParam" value="#esapiEncode('html_attr',objectparams.target)#">
					<option value="">-</option>
					<option value="_new">New Page</option>
				</select>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Button URL</label>
				<input type="text" placeholder="URL" id="url" name="url" class="objectParam" value="#esapiEncode('html_attr',objectparams.url)#"/>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Size</label>
				<select class="objectParam" name="buttonsize" data-param="buttonsize">
					<option>Normal</option>
					<option <cfif objectParams.buttonsize eq 'small'>selected</cfif>value="btn-sm">Small</option>
				</select>
			</div>
		</div>
		<input type="hidden" class="objectParam" name="async" value="false">
	</div>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">
</cfoutput>
</cf_objectconfigurator>
