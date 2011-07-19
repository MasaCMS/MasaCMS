<cfcomponent extends="controller" output="false">

<cffunction name="setPluginManager" output="false">
	<cfargument name="pluginManager">
	<cfset variables.pluginManager=arguments.pluginManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif not session.mura.isLoggedIn>
		<cfset secure(arguments.rc)>
	</cfif>
	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.pluginManager.getSitePlugins(siteID=arguments.rc.siteid, applyPermFilter=true) />
	<cfset arguments.rc.plugingroups=variables.pluginManager.getSitePluginGroups(arguments.rc.rslist) />
</cffunction>

</cfcomponent>