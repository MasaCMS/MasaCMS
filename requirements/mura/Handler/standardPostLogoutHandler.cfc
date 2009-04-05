<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cflocation url="#event.getValue('contentRenderer').getCurrentURL()#">

</cffunction>

</cfcomponent>