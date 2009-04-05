<cfcomponent extends="Validator" output="false">
	
<cffunction name="validate" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('isOnDisplay') and event.getValue('r').restrict 
			and not event.getValue('r').loggedIn 
			and (event.getValue('display') neq 'login' and event.getValue('display') neq 'editProfile')>
			<cfset event.getValue('HandlerFactory').get("standardRequireLogin").handle(event)>
	</cfif>
</cffunction>

</cfcomponent>