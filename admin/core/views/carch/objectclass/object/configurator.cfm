<cfparam name="objectParams.label" default="">
<cfparam name="objectParams.isbodyobject" default="false">
<cfif not (IsBoolean(objectParams.isbodyobject) and objectParams.isbodyobject)>
<cfoutput>
<div class="mura-layout-row">
	<div id="labelContainer" class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.label')#</label>
		<input name="label" type="text" class="objectParam" value="#esapiEncode('html_attr',objectParams.label)#"/>
	</div>
</div>
</cfoutput>
</cfif>
