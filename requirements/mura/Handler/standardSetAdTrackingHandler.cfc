<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('trackSession')>
		<cfset event.setValue('track',1)>
	<cfelse>
		<cfset event.setValue('track',0)>
	</cfif>
	
</cffunction>

</cfcomponent>