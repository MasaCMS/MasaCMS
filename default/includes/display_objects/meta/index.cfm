<cfparam name="objectParams.layout" default="default">
<cfparam name="objectParams.addlabel" default="false">
<cfparam name="objectParams.label" default="Placeholder">
<cfset objectParams.async=true>
<cfif objectParams.addlabel>
	<cfoutput><h2>#esapiEncode('html',objectParams.label)#</h2></cfoutput>
</cfif>