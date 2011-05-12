<cfcomponent output="false">
<cffunction name="init" output="false">
<cfargument name="location">
<cfargument name="addToken" required="true" default="false">
<cflocation url="#arguments.location#" addtoken="#arguments.addToken#">
</cffunction>
</cfcomponent>
