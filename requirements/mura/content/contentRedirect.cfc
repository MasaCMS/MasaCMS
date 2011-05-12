<cfcomponent output="false">
<cffunction name="init" output="false">
<cfargument name="location">
<cfargument name="addToken" required="true" default="false">
<cfargument name="statusCode" required="true" default="301">
<cflocation url="#arguments.location#" addtoken="#arguments.addToken#" statusCode="#arguments.statusCode#">
</cffunction>
</cfcomponent>
