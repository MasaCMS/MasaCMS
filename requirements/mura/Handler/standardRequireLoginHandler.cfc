<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfif event.getValue('isOnDisplay') and event.getValue('r').restrict and not event.getValue('r').loggedIn and (event.getValue('display') neq 'login' and event.getValue('display') neq 'editProfile')>
		<cflocation addtoken="no" url="#application.settingsManager.getSite(request.siteid).getLoginURL()#&returnURL=#URLEncodedFormat(event.getValue('contentRenderer').getCurrentURL())#">
	</cfif>

</cffunction>

</cfcomponent>