<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" output="false" returnType="any">
	<cfargument name="pluginConfig" required="true">
	<cfargument name="configBean" required="true">
	<cfset variables.pluginConfig=arguments.pluginConfig>
	<cfset variables.configBean=arguments.configBean>
	
	<cfreturn this>
</cffunction>

</cfcomponent>