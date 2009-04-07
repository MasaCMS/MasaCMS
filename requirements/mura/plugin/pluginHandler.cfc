<cfcomponent extends="mura.Handler.Handler" output="false">

<cffunction name="init" output="false" returnType="any">
	<cfargument name="pluginConfig" required="true">
	<cfset variables.pluginConfig=arguments.pluginConfig>
	
	<cfreturn this>
</cffunction>

</cfcomponent>