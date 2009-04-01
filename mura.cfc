<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="purgeSiteCache" access="remote" output="false">
<cfargument name="siteid" required="true" default="">

<cfif IsInCluster()>
	<cfif len(arguments.siteid)>
		<cfset application.settingsManager.getSite("site").getCacheFactory().purgeAll()>	
	<cfelse>
		<cfset application.settingsManager.purgeAllCache()>
	</cfif>
</cfif>
</cffunction>

<cffunction name="isInCluster" access="remote" output="false">
	<cfif len(application.configBean.getClusterIPList())>
	<cfreturn listFind(application.configBean.getClusterIPList(),cgi.remote_addr)>
	<cfelse>
	<cfreturn false/>
	</cfif>
</cffunction>

<cffunction name="reload" access="remote" output="false">
<cfif IsInCluster()>
	<cfset application.appInitialized=false/>
	<cfset application.broadcastInit=false />
</cfif>
</cffunction>

</cfcomponent>