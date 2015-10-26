<cfparam name="objectParams.label" default="Placeholder">
<cfset objectParams.async=true>
<cfif len(objectParams.label)>
	<cfoutput><h2>#esapiEncode('html',objectParams.label)#</h2></cfoutput>
</cfif>