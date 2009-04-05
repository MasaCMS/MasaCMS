<cfcomponent extends="Handler" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.setValue('r',application.permUtility.setRestriction(event.getValue('crumbdata')))>
	
</cffunction>

</cfcomponent>