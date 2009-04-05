<cfcomponent extends="Handler" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename("404",event.getValue('siteid'),true)) />
	<cfheader statuscode="404" statustext="Content Not Found" /> 

</cffunction>

</cfcomponent>