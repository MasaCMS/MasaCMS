<cfcomponent extends="Validator" output="false">
	
<cffunction name="validate" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('contentBean').getIsNew() eq 1>
		<cfset event.getValue('HandlerFactory').get("standard404").handle(event)>
	</cfif>

</cffunction>

</cfcomponent>