<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="purgeSiteCache" access="public" output="false">
<cfargument name="siteid" required="true" default="">

<cfif IsInCluster()>
	<cfif len(arguments.siteid)>
		<cfset application.settingsManager.getSite("site").getCacheFactory().purgeAll()>	
	<cfelse>
		<cfset application.settingsManager.purgeAllCache()>
	</cfif>
</cfif>
</cffunction>

<cffunction name="isInCluster" access="public" output="false">
	<cfif len(application.configBean.getClusterIPList())>
	<cfreturn listFind(application.configBean.getClusterIPList(),cgi.public_addr)>
	<cfelse>
	<cfreturn false/>
	</cfif>
</cffunction>

<cffunction name="reload" access="public" output="false">
<cfif IsInCluster()>
	<cfset application.appInitialized=false/>
	<cfset application.broadcastInit=false />
</cfif>
</cffunction>

<cffunction name="doRequest" output="false" returntype="any">
<cfargument name="event">
	<cfset var response=""/>
	<cfset var servlet = createObject("component","#application.configBean.getWebRootMap()#.#event.getValue('siteid')#.includes.servlet").init(event) />
	
	<cfset application.pluginManager.executeScripts('onSiteRequestStart',event.getValue('siteid'),event)/>
	<cfset servlet.onRequestStart() />
	<cfset response=servlet.doRequest()>
	<cfset servlet.onRequestEnd() />
	<cfset application.pluginManager.executeScripts('onSiteRequestEnd',event.getValue('siteid'),event)/>
	
	<cfreturn response>
</cffunction>


</cfcomponent>