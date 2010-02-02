<cfcomponent extends="controller" output="false">

<cffunction name="setPluginManager" output="false">
	<cfargument name="pluginManager">
	<cfset variables.pluginManager=arguments.pluginManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not session.mura.isLoggedIn>
		<cfset secure(rc)>
	</cfif>
	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.pluginManager.getSitePlugins(rc.siteid) />
</cffunction>

</cfcomponent>