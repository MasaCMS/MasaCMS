<cfcomponent extends="Validator" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif  (
				(event.getValue('forceSSL') or (event.getValue('r').restrict and application.settingsManager.getSite(event.getValue('siteID')).getExtranetSSL() eq 1)) and listFindNoCase('Off,False',cgi.https)
					)
			or	(
				not (event.getValue('r').restrict or event.getValue('forceSSL')) and listFindNoCase('On,True',cgi.https)		
			)>
		<cfset event.getValue('HandlerFactory').get("standardForceSSL").execute(event)>
	</cfif>
</cffunction>

</cfcomponent>