<cfcomponent extends="Translator" output="false">
	
<cffunction name="translate" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cflocation addtoken="no" url="#event.getValue('contentRenderer').setDynamicContent(event.getValue('contentBean').getFilename())#">
</cffunction>

</cfcomponent>