<cfcomponent extends="Validator" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif (application.configBean.getMode() eq 'production' 
				and cgi.SERVER_NAME neq application.settingsManager.getSite(request.siteID).getDomain()) 
				and not (cgi.SERVER_NAME eq 'LOCALHOST' and cgi.HTTP_USER_AGENT eq 'vspider')>
			<cfset event.getValue('HandlerFactory').get("standardWrongDomain").execute(event)>
		</cfif>
</cffunction>

</cfcomponent>