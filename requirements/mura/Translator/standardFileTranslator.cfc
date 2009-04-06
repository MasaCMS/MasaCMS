<cfcomponent extends="Translator" output="false">
	
<cffunction name="translate" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset event.getValue('contentRenderer').renderFile(event.getValue('contentBean').getFileID()) />
</cffunction>

</cfcomponent>