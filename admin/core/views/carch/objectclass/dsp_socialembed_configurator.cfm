
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset objectParams=deserializeJSON(form.params)>
<cfelse>
	<cfset objectParams={}>
</cfif>

<cfset data=structNew()>
<cfsavecontent variable="data.html">
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
<div id="availableObjectParams"
	data-object="socialembed" 
	data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.socialembed')#')#" 
	data-objectid="none">

</div>
</cfoutput>
</cf_objectconfigurator>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>