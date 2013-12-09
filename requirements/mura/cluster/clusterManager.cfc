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

<cfreturn this />
</cffunction>

<cffunction name="purgeCache" returntype="void" access="public" output="false">
	<cfargument name="siteid" required="true" default="">
	<cfargument name="name" required="true" default="both" hint="data, output or both">

	<cfif variables.broadcastCachePurges>
		<cfif listFindNoCase('output,data',arguments.name)>
			<cfset broadcastCommand("getBean('settingsManager').getSite('#arguments.siteID#').purgeCache(name='#arguments.name#',broadcast=false)")>
		<cfelse>
			<cfset broadcastCommand("getBean('settingsManager').getSite('#arguments.siteID#').purgeCache(name='output',broadcast=false)")>
			<cfset broadcastCommand("getBean('settingsManager').getSite('#arguments.siteID#').purgeCache(name='data',broadcast=false)")>
		</cfif>
		
	</cfif>
</cffunction>

<cffunction name="purgeUserCache" returntype="void" access="public" output="false">
	<cfargument name="userID" required="true" default="">
	
	<cfif variables.broadcastCachePurges>
		<cfset broadcastCommand("getBean('userManager').purgeUserCache(userID='#arguments.userID#',broadcast=false)")>
	</cfif>
</cffunction>

<cffunction name="purgeCategoryCache" returntype="void" access="public" output="false">
	<cfargument name="categoryID" required="true" default="">
	
	<cfif variables.broadcastCachePurges>
		<cfset broadcastCommand("getBean('categoryManager').purgeCategoryCache(categoryID='#arguments.categoryID#',broadcast=false)")>
	</cfif>
</cffunction>

<cffunction name="purgeCategoryDescendentsCache" returntype="void" access="public" output="false">
	<cfargument name="categoryID" required="true" default="">

	<cfif variables.broadcastCachePurges>
		<cfset broadcastCommand("getBean('categoryManager').purgeCategoryDescendentsCache(categoryID='#arguments.categoryID#',broadcast=false)")>
	</cfif>
</cffunction>

<cffunction name="purgeContentCache" returntype="void" access="public" output="false">
	<cfargument name="contentID" required="true" default="">
	<cfargument name="siteID" required="true" default="">
	
	<cfif variables.broadcastCachePurges>
		<cfset broadcastCommand("getBean('contentManager').purgeContentCache(contentID='#arguments.contentID#',siteID='#arguments.siteID#',broadcast=false)")>
	</cfif>
</cffunction>

<cffunction name="purgeCacheKey" returntype="void" access="public" output="false">
	<cfargument name="cacheName" required="true" default="data">
	<cfargument name="cacheKey" required="true" default="">
	<cfargument name="siteid" required="true" default="">
	
	<cfif variables.broadcastCachePurges>
		<cfset broadcastCommand("getBean('settingsManager').getSite('#arguments.siteid#').getCacheFactory(name='#arguments.cacheName#').purge(key='#arguments.cacheKey#')")>
	</cfif>
</cffunction>

<cffunction name="purgeContentDescendentsCache" returntype="void" access="public" output="false">
	<cfargument name="contentID" required="true" default="">
	<cfargument name="siteID" required="true" default="">

	<cfif variables.broadcastCachePurges>
		<cfset broadcastCommand("getBean('contentManager').purgeContentDescendentsCache(contentID='#arguments.contentID#',siteID='#arguments.siteID#',broadcast=false)")>
	</cfif>
</cffunction>

<cffunction name="runCommands" output="false">	
	<cfset var rsCommands="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCommands')#">
		select * from tclustercommands where instanceID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">
	</cfquery>

	<cfloop query="rsCommands">
		<cftry>
			<cfset evaluate("#rsCommands.command#")>
			<cfcatch>
				<cflog 
					type="error"
					file="exception"
					text="Cluster Communication Error -- Command: #rsCommands.command#">
			</cfcatch>
		</cftry>
		<cfquery>
			delete from tclustercommands where commandID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCommands.commandID#">
		</cfquery>
	</cfloop>
</cffunction>	

<cffunction name="broadcastCommand" returntype="void" access="public" output="false">
	<cfargument name="command" required="true" default="">
	<cfset var rsPeers=getPeers()>

	<cfif rsPeers.recordcount>
		<cfloop query="rsPeers">
			<cfquery>
				insert into tclustercommands (commandID,instanceID,command,created) 
					values(
					'#createUUID()#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeers.instanceID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.command#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
			</cfquery>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="reload" output="false" returntype="void">	
	<cfargument name="broadcast" default="true">

	<cfset touchInstance()>
	
	<cfif arguments.broadcast and variables.broadcastAppreloads>
		<cfset broadcastCommand("getBean('settingsManager').remoteReload()")>
		<cfquery>
			delete from tclustercommands where instanceid not in (select instanceid from tclusterpeers)
			and created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',-1,now())#">
		</cfquery>
		<cfquery>
			delete from tclusterpeers where instanceid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">
		</cfquery>	
	</cfif>

</cffunction>

<cffunction name="touchInstance" output="false">
	<cfif not hasInstance()>
		<cfquery>
			insert into tclusterpeers (instanceID) values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">)
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="purgeInstance" output="false">

	<cfquery>
		delete from tclusterpeers where instanceid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">
	</cfquery>
	<cfquery>
		delete from tclustercommands where instanceid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">
	</cfquery>
	
</cffunction>

<cffunction name="hasInstance" output="false">	
	<cfset var rsInstance="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsInstance')#">
		select instanceID from tclusterpeers where instanceID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">
	</cfquery>

	<cfreturn rsInstance.recordcount>
</cffunction>		

<cffunction name="getPeers" output="false">
	<cfset var rsPeers="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPeers')#">
		select instanceID from tclusterpeers where instanceID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#application.instanceID#">
	</cfquery>

	<cfreturn rsPeers>
</cffunction>

<cffunction name="clearOldCommands" output="false">
	<cfquery>
		delete from tclusterpeers 
		where instanceid in (select instanceid from 
							tclustercommands 
							where created <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',-1,now())#">
							)
	</cfquery>

	<cfquery>
		delete from tclustercommands 
		where created <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',-1,now())#">
	</cfquery>
</cffunction>

</cfcomponent>