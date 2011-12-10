<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
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