<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.getTranslator('standardHTML').translate(event)/>

</cffunction>

</cfcomponent>