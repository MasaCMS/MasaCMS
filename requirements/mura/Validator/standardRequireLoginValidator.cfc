<cfcomponent extends="Validator" output="false">
	
<cffunction name="execute" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('isOnDisplay') and event.getValue('r').restrict 
			and not event.getValue('r').loggedIn 
			and (event.getValue('display') neq 'login' and event.getValue('display') neq 'editProfile')>
			<cfset event.getValue('HandlerFactory').get("standardRequireLogin").execute(event)>
	</cfif>
</cffunction>

</cfcomponent>