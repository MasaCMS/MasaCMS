<cfcomponent extends="Handler" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.setValue('track',0)>
	<cfset event.setValue('nocache',1)>
	<cfset event.setValue('contentBean',application.contentManager.getcontentVersion(event.getValue('previewID'),event.getValue('siteID'))) />
	
</cffunction>

</cfcomponent>