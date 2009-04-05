<cfcomponent extends="Validator" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('contentBean').getIsNew() eq 1>
		<cfset event.getValue('HandlerFactory').get("standard404").execute(event)>
	</cfif>

</cffunction>

</cfcomponent>