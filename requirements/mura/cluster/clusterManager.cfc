<cfcomponent extends="mura.cfobject">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfset variables.broadcastCachePurges=variables.configBean.getValue("broadcastCachePurges")>
<cfset variables.broadcastAppreloads=variables.configBean.getValue("broadcastAppreloads")>
<cfset variables.broadcastWithProxy=variables.configBean.getValue("broadcastWithProxy")>
<cfreturn this />
</cffunction>

<cffunction name="purgeCache" returntype="void" access="public" output="false">
	<cfargument name="siteid" required="true" default="">
	<cfargument name="name" required="true" default="both" hint="data, output or both">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif variables.broadcastCachePurges and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeSiteCache&siteID=#URLEncodedFormat(arguments.siteID)#&name=#URLEncodedFormat(arguments.name)#&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="purgeUserCache" returntype="void" access="public" output="false">
	<cfargument name="userID" required="true" default="">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif variables.broadcastCachePurges and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeUserCache&userID=#URLEncodedFormat(arguments.userID)#&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="purgeCategoryCache" returntype="void" access="public" output="false">
	<cfargument name="categoryID" required="true" default="">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif variables.broadcastCachePurges and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeCategoryCache&categoryID=#URLEncodedFormat(arguments.categoryID)#&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="purgeCategoryDescendentsCache" returntype="void" access="public" output="false">
	<cfargument name="categoryID" required="true" default="">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif variables.broadcastCachePurges and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeCategoryDescendentsCache&categoryID=#URLEncodedFormat(arguments.categoryID)#&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="purgeContentCache" returntype="void" access="public" output="false">
	<cfargument name="contentID" required="true" default="">
	<cfargument name="siteID" required="true" default="">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif variables.broadcastCachePurges and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeContentCache&contentID=#URLEncodedFormat(arguments.contentID)#&siteID=#URLEncodedFormat(arguments.siteID)#&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="purgeContentDescendentsCache" returntype="void" access="public" output="false">
	<cfargument name="contentID" required="true" default="">
	<cfargument name="siteID" required="true" default="">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif variables.broadcastCachePurges and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeContentDescendentsCache&contentID=#URLEncodedFormat(arguments.contentID)#&siteID=#URLEncodedFormat(arguments.siteID)#&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="reload" output="false" returntype="void">	
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	<cfif variables.broadcastAppreloads and len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=reload&&appreloadkey=#URLEncodedFormat(application.appreloadkey)#&instanceID=#application.instanceID#">
			<cfset doRemoteCall(remoteURL)>
		</cfloop>
	</cfif>
	
</cffunction>	

<cffunction name="getClusterList" output="false">
	<cfset var clusterList=variables.configBean.getValue("clusterList")>
	<!--- for backward compatbility look for clusterIPlist if clusterList is not set --->
	<cfif not len(clusterList)>
		<cfset  clusterList=variables.configBean.getValue("clusterIPList")>
	</cfif>
	<cfreturn clusterList>
</cffunction>

<cffunction name="doRemoteCall" output="false">
<cfargument name="remoteURL">
	<cftry>
	<cfif variables.broadcastWithProxy and len(variables.configBean.getProxyServer())>
		<cfhttp url="#remoteURL#" timeout="100"
				proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
				proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#">
	<cfelse>
		<cfhttp url="#remoteURL#" timeout="100">
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
</cffunction>

<cffunction name="formatHost" output="false">
	<cfargument name="host">
	<cfif left(arguments.host,4) neq "http">
		<cfset arguments.host="http://" & arguments.host>
	</cfif>
	<cfif listLen(host,":") neq 3>
		<cfset arguments.host = arguments.host & variables.configBean.getServerPort()>
	</cfif>
	<cfreturn arguments.host & variables.configBean.getContext()>
</cffunction>

</cfcomponent>