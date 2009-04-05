<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset application.sessionTrackingManager.trackRequest(event.getValue('siteID'),event.getValue('path'),event.getValue('keywords'),event.getValue('contentBean').getcontentID()) />

</cffunction>

</cfcomponent>