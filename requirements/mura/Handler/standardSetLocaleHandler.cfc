<cfcomponent extends="Handler" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset setLocale(application.settingsManager.getSite(event.getValue('siteid')).getJavaLocale()) />

</cffunction>

</cfcomponent>