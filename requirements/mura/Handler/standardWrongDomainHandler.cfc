<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cflocation addtoken="no" url="http://#application.settingsManager.getSite(request.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(event.getValue('siteID'),event.getValue('contentBean').getFilename())#">

</cffunction>

</cfcomponent>