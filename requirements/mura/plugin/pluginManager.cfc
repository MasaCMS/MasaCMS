<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.genericManager="">
<cfset variables.eventManagers=structNew()>
<cfset variables.cacheFactories=structNew()>
<cfset variables.siteListeners=structNew()>
<cfset variables.globalListeners=structNew()>
<cfset variables.eventHandlers=arrayNew(1)>

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="utility">
	<cfargument name="genericManager">
	
	<cfset setConfigBean(arguments.configBean)>
	<cfset setSettingsManager(arguments.settingsManager)>
	<cfset setUtility(arguments.utility)>
	<cfset setGenericManager(arguments.genericManager)>
	
<cfreturn this />
</cffunction>

<cffunction name="setConfigBean" returntype="void" access="public" output="false">
<cfargument name="configBean">
<cfset variables.configBean=arguments.configBean />

<cfset loadPlugins()>

</cffunction>

<cffunction name="setSettingsManager" returntype="void" access="public" output="false">
<cfargument name="settingsManager">
<cfset variables.settingsManager=arguments.settingsManager />
</cffunction>

<cffunction name="setGenericManager" returntype="void" access="public" output="false">
<cfargument name="genericManager">
<cfset variables.genericManager=arguments.genericManager />
</cffunction>

<cffunction name="setUtility" returntype="void" access="public" output="false">
<cfargument name="utility">
<cfset variables.utility=arguments.utility />
</cffunction>

<cffunction name="loadPlugins" returntype="void" access="public" output="false">
<cfset var rsScripts1="">
<cfset var rsScripts2="">

<cfquery name="variables.rsPlugins" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tplugins
</cfquery>

<cfquery name="variables.rsPluginSiteAsignments" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select moduleID, siteid from tcontent where type='Plugin'
</cfquery>

<cfquery name="variables.rsSettings" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tpluginsettings
</cfquery>

<cfquery name="rsScripts1" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tplugins.name, tplugins.package, tplugins.directory, tpluginscripts.moduleID, tplugins.pluginID, tpluginscripts.runat, tpluginscripts.scriptfile, 
tcontent.siteID, tpluginscripts.docache from tpluginscripts
inner join tplugins on (tpluginscripts.moduleID=tplugins.moduleID)
inner join tcontent on (tplugins.moduleID=tcontent.moduleID)
where tpluginscripts.runat not in ('onGlobalLogin','onGlobalRequestStart','onApplicationLoad')
and tplugins.deployed=1
</cfquery>

<cfquery name="rsScripts2" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tplugins.name, tplugins.package, tplugins.directory, tpluginscripts.moduleID, tplugins.pluginID, tpluginscripts.runat, tpluginscripts.scriptfile, '' siteID, tpluginscripts.docache from tpluginscripts
inner join tplugins on (tpluginscripts.moduleID=tplugins.moduleID)
where tpluginscripts.runat in ('onGlobalLogin','onGlobalRequestStart','onApplicationLoad')
and tplugins.deployed=1
</cfquery>


<cfquery name="variables.rsScripts" dbtype="query">
select * from rsScripts1
union
select * from rsScripts2
</cfquery>

<cfquery name="variables.rsDisplayObjects" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tplugindisplayobjects.objectID, tplugindisplayobjects.moduleID, tplugindisplayobjects.name, 
tplugindisplayobjects.displayObjectfile, tplugins.pluginID, tplugins.package, tplugins.directory, tcontent.siteID, tplugins.name title,
tplugindisplayobjects.location, tplugindisplayobjects.displaymethod, tplugindisplayobjects.docache
from tplugindisplayobjects inner join tplugins on (tplugindisplayobjects.moduleID=tplugins.moduleID)
inner join tcontent on (tplugins.moduleID=tcontent.moduleID)
</cfquery>

<cfset purgeEventManagers()/>
<cfset purgeCacheFactories()/>

</cffunction>

<cffunction name="getLocation" returntype="string" access="public" output="false">
<cfargument name="directory">
	<cfset var delim=variables.configBean.getFileDelim() />
	
	<cfreturn "#variables.configBean.getWebRoot()##delim#plugins#delim##arguments.directory##delim#">
</cffunction>

<cffunction name="getAllPlugins" returntype="query" access="public" output="false">
<cfargument name="orderby" default="name" required="true">
<cfset var rs="">
<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tplugins order by #arguments.orderby#
</cfquery>
<cfreturn rs/>
</cffunction>

<cffunction name="deploy" returntype="any" access="public" output="false">
<cfargument name="moduleID" required="true" default="">

<cfset var delim=variables.configBean.getFileDelim() />
<cfset var location="">
<cfset var modID=arguments.moduleID />
<cfset var rsPlugin="" />
<cfset var pluginXML="" />
<cfset var scriptsLen=0 />
<cfset var eventHandlersLen=0 />
<cfset var objectsLen=0 />
<cfset var i=1 />
<cfset var displayObject="" />
<cfset var script="" />
<cfset var eventHandler=""/>
<cfset var isNew=false />
<cfset var zipTool=createObject("component","mura.Zip")>

<cflock name="addPlugin" timeout="200">
	<!--- <cftry> --->
	<cfif not len(modID)>
		<cfset isNew=true/>
		<cfset modID=createUUID()/>	
	<cfelse>
		<cfset deleteScripts(modID) />
	</cfif>
	
	<cffile action="upload" filefield="NewPlugin" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">	
	
	<cfif isNew>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	insert into tplugins (moduleID,name,provider,providerURL,version,deployed,category,created) values (
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#modID#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="An error occurred.">,
	null,
	null,
	null,
	0,
	null,
	#createODBCDateTime(now())#
	)
	</cfquery>

	</cfif>
	
	<cfset rsPlugin=getPlugin(modID,'',false) />
	
	<!--- Set the directory to the newly installed pluginID--->
	<cfif isNew>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugins set
	directory=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPlugin.pluginID#">
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPlugin.moduleID#">			
	</cfquery>
	<cfset rsPlugin=getPlugin(modID,'',false) />
	</cfif>
	
	<cfset location=getLocation(rsPlugin.directory) />
	
	<cfif directoryExists(location)>
		<cfdirectory action="delete" directory="#location#" recurse="true">
	</cfif>
	
	<cfdirectory action="create" directory="#location#" mode="777">
	
	<cfset zipTool.extract("#variables.configBean.getTempDir()##delim##cffile.serverfile#","#location#")>
	
	<cffile action="delete" file="#variables.configBean.getTempDir()##delim##cffile.serverfile#">
	
</cflock>

<cfset savePluginXML(modID) />
<cfset loadPlugins() />
<!---<cfset createLookupTXT()/>--->

<cfreturn modID/>

</cffunction>

<cffunction name="savePluginXML" output="false" access="public">
<cfargument name="modID">

	<cfset var scriptsLen=0 />
	<cfset var eventHandlersLen=0 />
	<cfset var objectsLen=0 />
	<cfset var i=1 />
	<cfset var displayObject="" />
	<cfset var script="" />
	<cfset var eventHandler=""/>
	<cfset var rsPlugin=getPlugin(modID,'',false) />
	<cfset var location=getLocation(rsPlugin.directory) />
	<cfset var delim=variables.configBean.getFileDelim() />
	<cfset var pluginXML=getPluginXML(modID)>

	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugins set
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.name.xmlText#">,
	provider=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.provider.xmlText#">,
	providerURL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.providerURL.xmlText#">,
	version=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.version.xmlText#">,
	category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.category.xmlText#">,
	created=#createODBCDateTime(now())#
	<cfif not rsPlugin.deployed>
	,
	<cfif structKeyExists(pluginXML.plugin,"package") and len(pluginXML.plugin.package.xmlText)>
		package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.package.xmlText#">
	<cfelse>
		package=null
	</cfif>
	</cfif>
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#modID#">
	</cfquery>
	
	<cfif structKeyExists(pluginXML.plugin,"scripts")>
		<cfif structKeyExists(pluginXML.plugin.scripts,"script")>
			<cfset scriptsLen=arraylen(pluginXML.plugin.scripts.script)/>
				<cfif scriptsLen>
					<cfloop from="1" to="#scriptsLen#" index="i">
						<cfset script=getScriptBean() />
						<cfset script.setModuleID(modID) />>
						<cfif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"runat")>
							<cfset script.setRunAt(pluginXML.plugin.scripts.script[i].xmlAttributes.runat) />
						<cfelse>
							<cfset script.setRunAt(pluginXML.plugin.scripts.script[i].xmlAttributes.event) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"component")>
							<cfset script.setScriptFile(pluginXML.plugin.scripts.script[i].xmlAttributes.component) />
						<cfelse>
							<cfset script.setScriptFile(pluginXML.plugin.scripts.script[i].xmlAttributes.scriptfile) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"cache")>
							<cfset script.setDoCache(pluginXML.plugin.scripts.script[i].xmlAttributes.cache) />
						<cfelseif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"persist")>
							<cfset script.setDoCache(pluginXML.plugin.scripts.script[i].xmlAttributes.persist) />
						<cfelse>
							<cfset script.setDoCache("false") />
						</cfif>
						<cfset script.save() />
					</cfloop>
				</cfif>
		</cfif>
	</cfif>
	
	<cfif structKeyExists(pluginXML.plugin,"eventHandlers")>
		<cfif structKeyExists(pluginXML.plugin.eventHandlers,"eventHandler")>
			<cfset eventHandlersLen=arraylen(pluginXML.plugin.eventHandlers.eventHandler)/>
				<cfif eventHandlersLen>
					<cfloop from="1" to="#eventHandlersLen#" index="i">
						<cfset eventHandler=getScriptBean() />
						<cfset eventHandler.setModuleID(modID) />
						<cfif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"event")>
							<cfset eventHandler.setRunAt(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.event) />
						<cfelse>
							<cfset eventHandler.setRunAt(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.runat) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"component")>
							<cfset eventHandler.setScriptFile(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.component) />
						<cfelse>
							<cfset eventHandler.setScriptFile(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.scriptfile) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"cache")>
							<cfset eventHandler.setDoCache(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.cache) />
						<cfelseif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"persist")>
							<cfset eventHandler.setDoCache(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.persist) />
						<cfelse>
							<cfset eventHandler.setDoCache("false") />
						</cfif>
						<cfset eventHandler.save() />
					</cfloop>
				</cfif>
		</cfif>
	</cfif>
	
	<cfif structKeyExists(pluginXML.plugin.displayobjects,"displayobject")>
	<cfset objectsLen=arraylen(pluginXML.plugin.displayobjects.displayobject)/>
		<cfif objectsLen>
			<cfloop from="1" to="#objectsLen#" index="i">
				<cfset displayObject=getDisplayObjectBean() />
				<cfset displayObject.setModuleID(modID) />
				<cfset displayObject.setName(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.name) />
				<cfset displayObject.loadByName() />
				<cfset displayObject.setLocation(pluginXML.plugin.displayobjects.xmlAttributes.location) />
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"displayobjectfile")>
					<cfset displayObject.setDisplayObjectFile(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.displayobjectfile) />
				<cfelse>
					<cfset displayObject.setDisplayObjectFile(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.component) />
				</cfif>
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"displaymethod")>
					<cfset displayObject.setDisplayMethod(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.displaymethod) />
				<cfelse>
					<cfset displayObject.setDisplayMethod("") />
				</cfif>
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"cache")>
					<cfset displayObject.setDoCache(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.cache) />
				<cfelseif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"persist")>
					<cfset displayObject.setDoCache(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.persist) />
				<cfelse>
					<cfset displayObject.setDoCache("false") />
				</cfif>
				<cfset displayObject.save() />
			</cfloop>
			
		</cfif>
	</cfif>
	
	<!---<cfset createLookupTXT()/>--->
	
</cffunction>	

<cffunction name="hasPlugin" returntype="any" output="false">
<cfargument name="ID">
<cfargument name="siteID" required="true" default="">
<cfargument name="cache" required="true" default="true">

	<cfreturn getPlugin(arguments.ID, arguments.siteID, arguments.cache).recordcount>
</cffunction>

<cffunction name="getPlugin" returntype="query" output="false">
<cfargument name="ID">
<cfargument name="siteID" required="true" default="">
<cfargument name="cache" required="true" default="true">
	<cfset var rs=""/>
	<cfset var rsModuleCheck=""/>
	<cfif arguments.cache>
	
		<cfif len(arguments.siteID)>
			<cfquery name="rsModuleCheck" dbtype="query">
			select moduleID from variables.rsPluginSiteAsignments 
			where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
			</cfquery>
		</cfif>
		
		<cfquery name="rs" dbtype="query">
		select * from variables.rsPlugins where  
		<cfif isNumeric(arguments.ID)>
			pluginID=#arguments.ID#
		<cfelseif isValid("UUID",arguments.ID)>
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
		<cfelse>
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
		</cfif>
		
		<cfif len(arguments.siteID)>
		and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsModuleCheck.moduleID)#">)
		</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select * from tplugins where  
		<cfif isNumeric(arguments.ID)>
			pluginID=#arguments.ID#
		<cfelseif isValid("UUID",arguments.ID)>
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
		<cfelse>
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
		</cfif>
		
		<cfif len(arguments.siteID)>
		and moduleID in (select moduleID from tcontent 
						where type='Plugin'
						and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
		</cfif>
		</cfquery>
	</cfif>
	
	<cfreturn rs>
</cffunction>

<cffunction name="getPluginXML" returntype="xml" output="false">
<cfargument name="moduleID">
	<cfset var theXML="">
	<cfset var rsPlugin=getPlugin(arguments.moduleID,'',false)>
	<cfset var delim=variables.configBean.getFileDelim() />
	<cfif fileExists("#getLocation(rsPlugin.directory)#plugin#delim#config.xml")>
		<cffile action="read" file="#getLocation(rsPlugin.directory)#plugin#delim#config.xml" variable="theXML">
	<cfelse>
		<cffile action="read" file="#getLocation(rsPlugin.directory)#plugin#delim#config.xml.cfm" variable="theXML">
	</cfif>
	<cfreturn xmlParse(theXML)/>
</cffunction>

<cffunction name="getAttributeBean" returntype="any" output="false">
<cfargument name="theXML">
<cfargument name="moduleID">
	<cfset var bean=createObject("component","mura.plugin.pluginSettingBean").init(variables.configBean)>
	<cfset bean.set(arguments.theXML,arguments.moduleID)/>
	
	<cfreturn bean/>
</cffunction>

<cffunction name="getConfig" returntype="any" output="false">
<cfargument name="ID">
<cfargument name="siteID" required="true" default="">
<cfargument name="cache" required="true" default="true">


	<cfset var pluginConfig=createObject("component","mura.plugin.pluginConfig")>
	<cfset var rs="">
	<cfset var settingStr=structNew()>
	
	<cfset rs=getPlugin(arguments.ID,arguments.siteID,arguments.cache)>
	
	<cfset pluginConfig.setVersion(rs.version) />
	<cfset pluginConfig.setName(rs.name) />
	<cfset pluginConfig.setProvider(rs.provider) />
	<cfset pluginConfig.setProviderURL(rs.providerURL) />
	<cfset pluginConfig.setPluginID(rs.pluginID) />
	<cfset pluginConfig.setModuleID(rs.moduleID) />
	<cfset pluginConfig.setDeployed(rs.deployed) />
	<cfset pluginConfig.setCategory(rs.category) />
	<cfset pluginConfig.setCreated(rs.created) />
	<cfset pluginConfig.setPackage(rs.package) />
	<cfset pluginConfig.setDirectory(rs.directory) />
	
	<cfquery name="rs"  dbtype="query">
	select * from variables.rsSettings where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.moduleID#">
	</cfquery>
	
	<cfloop query="rs">
	<cfset settingStr["#rs.name#"]=rs.settingValue />
	</cfloop>
	
	<cfset pluginConfig.initSettings(settingStr)/>
	
	<cfreturn pluginConfig/>
</cffunction>

<cffunction name="getAssignedSites" returntype="query" output="false">
<cfargument name="moduleID">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select siteID,moduleID from tcontent where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
	<cfreturn rs>
</cffunction>

<cffunction name="deleteAssignedSites" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontent where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="updateSettings" returntype="void" output="false">
<cfargument name="args">

	<cfset var pluginXML=getPluginXML(arguments.args.moduleID) />
	<cfset var settingsLen=0/>
	<cfset var i=1 />
	<cfset var pluginConfig="" />
	<cfset var pluginCFC= ""/>
	<cfset var adminDir="">
	<cfset var siteDir="">
	<cfset var delim=variables.configBean.getFileDelim() >
	<cfset var distroList="" />
	<cfset var dopID=""/>
	<cfset var rsObjects="">
	<cfset var directory="">
	
	<cfset deleteSettings(arguments.args.moduleID) />
	
	<cfif structKeyExists(pluginXML.plugin.settings,"setting")>
		<cfset settingsLen=arraylen(pluginXML.plugin.settings.setting) />
	</cfif>
	
	<cfif len(settingsLen)>
		<cfloop from="1" to="#settingsLen#" index="i">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tpluginsettings (moduleID,name,settingValue) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.settings.setting[i].name.xmlText#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args['#pluginXML.plugin.settings.setting[i].name.xmlText#']#">
			)
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfset deleteScripts(arguments.args.moduleID) />
	
	<cfset savePluginXML(arguments.args.moduleID) />
	<cfset pluginConfig=getConfig(arguments.args.moduleID,'',false) />
	
	
	<!--- save the submitted name --->
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugins set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.pluginalias#">,
	package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.package#">
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">			
	</cfquery>
	
	
	<!--- check to see if the directory has changed --->
	<!--- <cfif len(pluginConfig.getPackage())>
		<cfset directory="#pluginConfig.getPackage()#_#pluginConfig.getPluginID()#">
	<cfelse>
		<cfset directory=pluginConfig.getPluginID()>
	</cfif> --->
	
	<!--- remove none alphnumeric characters--->
	<cfset arguments.args.package=rereplace(arguments.args.package,"[^a-zA-Z0-9\-_]","","ALL")>
	
	<cfif len(arguments.args.package)>
		<cfset directory="#arguments.args.package#_#pluginConfig.getPluginID()#">
	<cfelse>
		<cfset directory=pluginConfig.getPluginID()>
	</cfif>
	
	<cfif directory neq pluginConfig.getDirectory()>
		
		<cfdirectory action = "rename" directory = "#expandPath('/plugins')#/#pluginConfig.getDirectory()#" newDirectory = "#expandPath('/plugins')#/#directory#" >
	
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tplugins set directory=<cfqueryparam cfsqltype="cf_sql_varchar" value="#directory#">
		,package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.package#">
		where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">			
		</cfquery>
		
		<cfset pluginConfig=getConfig(arguments.args.moduleID,'',false) />
	</cfif>
	
	
	<cfset deleteAssignedSites(arguments.args.moduleID) />
	
	<cfif structKeyExists(arguments.args,"siteAssignID") and len(arguments.args.siteAssignID)>
		<cfloop list="#arguments.args.siteAssignID#" index="i">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tcontent (siteID,moduleID,contentID,contentHistID,parentID,type,subType,title,
			display,approved,isNav,active,forceSSL,searchExclude) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			'Plugin',
			'Default',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.name.xmlText#">,
			1,
			1,
			1,
			1,
			1,
			1
			)
			</cfquery>
		</cfloop>
	</cfif>
	
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugindisplayobjects 
	set location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.location#">
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
	</cfquery>
	
	<cfset loadPlugins() />
	

	<cfif arguments.args.location eq "local" and structKeyExists(arguments.args,"siteAssignID") and len(arguments.args.siteAssignID)>
		<cfquery name="rsObjects" dbType="query">
		select * from variables.rsDisplayObjects
		where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
		</cfquery>
		
		<cfif rsObjects.recordcount>
		<cfloop list="#arguments.args.siteAssignID#" index="i">
			<cfset dopID=variables.settingsManager.getSite(i).getDisplayPoolID()/>
			<cfset siteDir=variables.configBean.getWebRoot() & delim & dopID & delim & "includes" & delim & "plugins" & delim & pluginConfig.getDirectory() & delim>
			<cfset adminDir=variables.configBean.getWebRoot() & delim  & "plugins" & delim & pluginConfig.getDirectory() & delim>
			
			<cfif not listFind(distroList,dopID)>
				
				<cfif isNumeric(rsObjects.pluginID) and arguments.args.overwrite and directoryExists(siteDir)>
					<cfdirectory action="delete" directory="#siteDir#" recurse="true">
				</cfif>
				
				<cfif not directoryExists(siteDir)>			
					<cfset variables.utility.copyDir(adminDir,siteDir)>
				</cfif>
				
				<cfset distroList=listAppend(distroList,dopID)>
			</cfif>
		</cfloop>
		</cfif>
	</cfif>
	

	<cfset pluginConfig=getConfig(arguments.args.moduleID) />
	
	<!--- check to see is the plugin.cfc exists --->
	<cfif fileExists(ExpandPath("/plugins") & "/" & pluginConfig.getDirectory() & "/plugin/plugin.cfc")>	
		<cfset pluginCFC= createObject("component","plugins.#pluginConfig.getDirectory()#.plugin.plugin") />
		
		<!--- only call the methods if they have been defined --->
		<cfif structKeyExists(pluginCFC,"init")>
			<cfset pluginCFC.init(pluginConfig)>
		</cfif>

		<cfif pluginConfig.getDeployed() eq 1>
			<cfif structKeyExists(pluginCFC,"update")>
				<cfset pluginCFC.update() />
			</cfif>
		<cfelse>
			<cfif structKeyExists(pluginCFC,"install")>
				<cfset pluginCFC.install() />
			</cfif>
		</cfif>
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugins 
	set deployed=1
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
	</cfquery>
	
	<cfset loadPlugins() />
</cffunction>

<cffunction name="deleteSettings" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tpluginsettings where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="deleteScripts" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tpluginscripts where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="deleteDisplayObjects" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where 
	objectID in (select objectID from tplugindisplayobjects where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">)
	</cfquery>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugindisplayobjects where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="getSitePlugins" returntype="query" output="false">
<cfargument name="siteID">
<cfargument name="orderby" default="name" required="true">
	<cfset var rs="">
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tplugins.pluginID,tplugins.moduleID, tplugins.package, tplugins.directory, tplugins.name,tplugins.version,
	tplugins.provider, tplugins.providerURL,tplugins.category,tplugins.created from tplugins inner join tcontent
	on (tplugins.moduleID=tcontent.moduleID and tcontent.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
	order by tplugins.#arguments.orderby#
	</cfquery>
	<cfreturn rs>
</cffunction>

<cffunction name="deletePlugin" returntype="void" output="false">
<cfargument name="moduleID">

	<cfset var rsPlugin=getPlugin(arguments.moduleID) />
	<cfset var location=getLocation(rsPlugin.directory) />
	<cfset var pluginConfig=getConfig(arguments.moduleID) />
	<cfset var pluginCFC="/">
	
	<cftry>
	<!--- check to see is the plugin.cfc exists --->
	<cfif fileExists(ExpandPath("/plugins") & "/" & pluginConfig.getDirectory() & "/plugin/plugin.cfc")>	
		<cfset pluginCFC=createObject("component","plugins.#pluginConfig.getDirectory()#.plugin.plugin") />
		
		<!--- only call the methods if they have been defined --->
		<cfif structKeyExists(pluginCFC,"init")>
			<cfset pluginCFC.init(pluginConfig)>
		</cfif>
		
		<cfif structKeyExists(pluginCFC,"delete")>
			<cfset pluginCFC.delete() />
		</cfif>
	</cfif>
	<cfcatch></cfcatch>
	</cftry>

	<cfif isNumeric(rsPlugin.pluginID) and directoryExists(location)>
		<cfdirectory action="delete" directory="#location#" recurse="true">
	</cfif>
	
	<cfset deleteSettings(arguments.moduleID)>
	<cfset deleteAssignedSites(arguments.moduleID)>
	<cfset deleteScripts(arguments.moduleID)>
	<cfset deleteDisplayObjects(arguments.moduleID)>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugins where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
	
	<cfset loadPlugins() />
	<!---<cfset createLookupTXT()/>--->

</cffunction>

<cffunction name="announceEvent" output="false" returntype="void">
<cfargument name="eventToAnnounce" required="true" default="" type="any">
<cfargument name="currentEventObject" required="true" default="" type="any">
<cfargument name="rsHandlers" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
	<cfset executeScripts(arguments.eventToAnnounce,arguments.currentEventObject.getValue('siteID'),arguments.currentEventObject,arguments.rsHandlers,arguments.moduleID)>
</cffunction>

<cffunction name="renderEvent" output="false" returntype="any">
<cfargument name="eventToRender" required="true" default="" type="any">
<cfargument name="currentEventObject" required="true" default="" type="any">
<cfargument name="rsHandlers" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
	<cfreturn renderScripts(arguments.eventToRender,arguments.currentEventObject.getValue('siteID'),arguments.currentEventObject,arguments.rsHandlers,arguments.moduleID)>
</cffunction>

<cffunction name="executeScripts" output="false" returntype="any">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scripts" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
	<cfset var rs=""/>
	<cfset var pluginConfig="">
	<cfset var componentPath="">
	<cfset var scriptPath="">
	<cfset var rsOnError="">
	<!--- this is for non plugin bound event that are set in the local eventHandler--->
	<cfset var localHandler="">
	<cfset var i="">
	<cfset var eventHandlerIndex="">
	<cfset var eventHandler="">
	<cfset var listenerArray="">
	<cfset var isGlobalEvent=left(arguments.runat,8) eq "onGlobal">
	<cfset var isValidEvent=not REFind("[^A-Za-z0-9]",arguments.runat,1)>
	
	<cfif isValidEvent and not isQuery(arguments.scripts) and not len(arguments.moduleID)>
		<cfif not isObject(arguments.event)>
			<cfif isStruct(arguments.event)>
				<cfset variables.event=createObject("component","mura.event").init(arguments.event)/>
			<cfelse>				
				<cfif structKeyExists(request,"servletEvent")>
					<cfset arguments.event=request.servletEvent />
				<cfelse>
					<cfset arguments.event=createObject("component","mura.event")/>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif isObject(event.getValue("localHandler"))>
			<cfset localHandler=event.getValue("localHandler")>
			<cfif structKeyExists(localHandler,runat)>
				<cfset evaluate("localHandler.#runat#(arguments.event)") />
			</cfif>
		</cfif>
		
		<cfif not isGlobalEvent and len(arguments.siteID)>
			<cfif isDefined("variables.siteListeners.#arguments.siteID#.#arguments.runat#")>
				<cfset listenerArray=evaluate("variables.siteListeners.#arguments.siteID#.#arguments.runat#")>
				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandlerIndex=listenerArray[i].index>
						<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
						<cfif not isObject(eventHandler)>
							<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
						</cfif>
						<cfset evaluate("eventHandler.#runat#(arguments.event)") />
					</cfloop>
				</cfif>
			</cfif>
		<cfelseif isGlobalEvent>
			<cfif isDefined("variables.globalListeners.#arguments.runat#")>
				<cfset listenerArray=evaluate("variables.globalListeners.#arguments.runat#")>
				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandlerIndex=listenerArray[i].index>
						<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
						<cfif not isObject(eventHandler)>
							<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
						</cfif>
						<cfset evaluate("eventHandler.#runat#(arguments.event)") />
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isQuery(arguments.scripts)>
		<cfset rs=arguments.scripts />
	<cfelse>
		<cfset rs=getScripts(arguments.runat,arguments.siteid,arguments.moduleID) />
	</cfif>
	
	<cfloop query="rs">
		<cftry>
		<cfset event.setValue("siteid",arguments.siteID)>
		
		<cfif listLast(rs.scriptfile,".") neq "cfm">
			<cfset componentPath="plugins.#rs.directory#.#rs.scriptfile#">
			<cfset eventHandler=getComponent(componentPath, rs.pluginID, arguments.siteID, rs.docache)>
			<cfinvoke component="#eventHandler#" method="#arguments.runat#">
				<cfinvokeargument name="event" value="#arguments.event#">
			</cfinvoke>	
		<cfelse>
			<cfset getExecutor().executeScript(event,"/plugins/#rs.directory#/#rs.scriptfile#",getConfig(rs.pluginID))>
		</cfif>
		<cfcatch>
			<cfset rsOnError=getScripts("onError",arguments.siteid,rs.moduleID) />
			<cfif arguments.runat neq "onError" and rsOnError.recordcount>
				<cfset arguments.event.setValue("errorType","script")>
				<cfset arguments.event.setValue("error",cfcatch)>
				<cfset executeScripts("onError",arguments.siteid,arguments.event,rsOnError)>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
	</cftry>
	</cfloop>

</cffunction>

<cffunction name="renderScripts" output="false" returntype="any">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scripts" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var pluginConfig="">
	<cfset var componentPath="">
	<cfset var scriptPath="">
	<cfset var theDisplay1="">
	<cfset var theDisplay2="">
	<cfset var rsOnError="">
	<!--- this is for non plugin bound event that are set in the local eventHandler--->
	<cfset var localHandler="">
	<cfset var i="">
	<cfset var eventHandler="">
	<cfset var listenerArray="">
	<cfset var isGlobalEvent=left(arguments.runat,8) eq "onGlobal">
	<cfset var isValidEvent=not REFind("[^A-Za-z0-9]",arguments.runat,1)>
	
	<cfif not isObject(arguments.event)>
		<cfif isStruct(arguments.event)>
			<cfset variables.event=createObject("component","mura.event").init(arguments.event)/>
		<cfelse>				
			<cfif structKeyExists(request,"servletEvent")>
				<cfset arguments.event=request.servletEvent />
			<cfelse>
				<cfset arguments.event=createObject("component","mura.event")/>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isValidEvent and not isQuery(arguments.scripts) and not len(arguments.moduleID)>
		<cfif isObject(event.getValue("localHandler"))>
			<cfset localHandler=event.getValue("localHandler")>
			<cfif structKeyExists(localHandler,runat)>
				<cfsavecontent variable="theDisplay1">
				<cfinvoke component="#localHandler#" method="#arguments.runat#" returnVariable="theDisplay2">
					<cfinvokeargument name="event" value="#arguments.event#">
				</cfinvoke>	
				</cfsavecontent>
				<cfif isDefined("theDisplay2")>
					<cfset str=str & theDisplay2>
				<cfelse>
					<cfset str=str & theDisplay1>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif not isGlobalEvent and len(arguments.siteID)>
			<cfif isDefined("variables.siteListeners.#arguments.siteID#.#arguments.runat#")>
				<cfset listenerArray=evaluate("variables.siteListeners.#arguments.siteID#.#arguments.runat#")>
				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandler=variables.eventHandlers[listenerArray[i].index]>
						<cfif not isObject(eventHandler)>
							<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
						</cfif>
						<cfsavecontent variable="theDisplay1">
						<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="theDisplay2">
							<cfinvokeargument name="event" value="#arguments.event#">
						</cfinvoke>	
						</cfsavecontent>
						<cfif isDefined("theDisplay2")>
							<cfset str=str & theDisplay2>
						<cfelse>
							<cfset str=str & theDisplay1>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		<cfelseif isGlobalEvent>
			<cfif isDefined("variables.globalListeners.#arguments.runat#")>
				<cfset listenerArray=evaluate("variables.globalListeners.#arguments.runat#")>
				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandler=variables.eventHandlers[listenerArray[i].index]>
						<cfif not isObject(eventHandler)>
							<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
						</cfif>
						<cfsavecontent variable="theDisplay1">
						<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="theDisplay2">
							<cfinvokeargument name="event" value="#arguments.event#">
						</cfinvoke>	
						</cfsavecontent>
						<cfif isDefined("theDisplay2")>
							<cfset str=str & theDisplay2>
						<cfelse>
							<cfset str=str & theDisplay1>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfif isQuery(arguments.scripts)>
		<cfset rs=arguments.scripts />
	<cfelse>
		<cfset rs=getScripts(arguments.runat,arguments.siteid,arguments.moduleID) />
	</cfif>
	
	<cfif rs.recordcount>
	
	<cfloop query="rs">
	<cftry>
		<cfif listLast(rs.scriptfile,".") neq "cfm">		
			<cfset componentPath="plugins.#rs.directory#.#rs.scriptfile#">
			<cfset eventHandler=getComponent(componentPath, rs.pluginID, arguments.siteID, rs.docache)>
			<cfsavecontent variable="theDisplay1">
			<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="theDisplay2">
				<cfinvokeargument name="event" value="#arguments.event#">
			</cfinvoke>	
			</cfsavecontent>
			<cfif isDefined("theDisplay2")>
				<cfset str=str & theDisplay2>
			<cfelse>
				<cfset str=str & theDisplay1>
			</cfif>
		<cfelse>
			<cfsavecontent variable="theDisplay1">
			<cfoutput>#getExecutor().renderScript(event,"/plugins/#rs.directory#/#rs.scriptfile#",getConfig(rs.pluginID))#</cfoutput>
			</cfsavecontent>
			<cfset str=str & theDisplay1>
		</cfif>
		
		<cfcatch>
			<cfset rsOnError=getScripts("onError",arguments.siteid,rs.moduleID) />
			<cfif arguments.runat neq "onError" and rsOnError.recordcount>
				<cfset arguments.event.setValue("errorType","render")>
				<cfset arguments.event.setValue("error",cfcatch)>
				<cfset str=str & renderScripts("onError",arguments.siteid,arguments.event,rsOnError)>
			<cfelseif arguments.runat eq "onError">
				<cfrethrow>
			<cfelse>
			<cfsavecontent variable="theDisplay1">
			<cfdump var="#cfcatch#">
			</cfsavecontent>
			<cfset str=str & theDisplay1>
			</cfif>
		</cfcatch>
	</cftry>
	</cfloop>
	</cfif>

	<cfreturn trim(str)>
</cffunction>

<cffunction name="getHandlersQuery" output="false" returntype="query">
<cfargument name="eventToHandle">
<cfargument name="siteID" required="true" default="">
<cfargument name="moduleID" required="true" default="">
	<cfreturn getScripts(arguments.eventToHandle,argument.siteID,arguments.moduleID)>
</cffunction>

<cffunction name="getScripts" output="false" returntype="query">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="moduleID" required="true" default="">
<cfset var rs="">

	<cfquery name="rs" dbtype="query">
	select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts 
	where runat=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.runat#">
	<cfif len(arguments.siteID)>
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfif>
	<cfif len(arguments.moduleID)>
	and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfif>
	order by pluginID
	</cfquery>
<cfreturn rs/>

</cffunction>

<cffunction name="getDisplayObjectBySiteID" output="false" returntype="query">
<cfargument name="siteID" required="true" default="">

<cfset var rs="">
<cfquery name="rs" dbtype="query">
	select objectID, moduleID, siteID, name, title from variables.rsDisplayObjects 
	where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	order by moduleID, title, name
</cfquery>

<cfreturn rs/>

</cffunction>

<cffunction name="displayObject" output="true" returntype="any">
<cfargument name="object">
<cfargument name="event" required="true" default="">
<cfargument name="moduleID" required="true" default="">
	
	<cfset var rs=""/>
	<cfset var key=""/>
	<cfset var componentPath=""/>
	<cfset var pluginConfig=""/>
	<cfset var eventHandler=""/>
	<cfset var theDisplay1=""/>
	<cfset var theDisplay2=""/>
	<cfset var rsOnError="">
	
	<cfset event.setValue("objectID",arguments.object)>
	
	<cfquery name="rs" dbtype="query">
	select pluginID, displayObjectFile,location,displaymethod, docache, objectID, directory, moduleID from variables.rsDisplayObjects 
	where 
	<cfif isvalid("UUID",arguments.object)>
	objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">
	<cfelse>
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">
	</cfif>
	<cfif len(arguments.moduleID)>
	and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfif>
	group by pluginID, displayObjectFile, location, displaymethod, docache, objectID, directory, moduleID
	</cfquery>
	
		<cfif rs.recordcount>
		<cftry>
		<cfif listLast(rs.displayobjectfile,".") neq "cfm">
			<cfif rs.location neq "local">
				<cfset componentPath="plugins.#rs.directory#.#rs.displayobjectfile#">
			<cfelse>
				<cfset componentPath="#variables.configBean.getWebRootMap()#.#event.getSite().getDisplayPoolID()#.includes.plugins.#rs.directory#.#rs.displayobjectfile#">
			</cfif>
			<cfset eventHandler=getComponent(componentPath, rs.pluginID, event.getValue('siteID'),rs.docache)>
			<cfsavecontent variable="theDisplay1">
			<cfinvoke component="#eventHandler#" method="#rs.displaymethod#" returnvariable="theDisplay2">
				<cfinvokeargument name="event" value="#arguments.event#">
			</cfinvoke>
			</cfsavecontent>
			<cfif isdefined("theDisplay2")>
				<cfreturn trim(theDisplay2)>
			<cfelse>
				<cfreturn trim(theDisplay1)>
			</cfif>			
		<cfelse>
			<cfreturn getExecutor().displayObject(rs.objectID,arguments.event,rs) />
		</cfif>
		<cfcatch>
			<cfset rsOnError=getScripts("onError",event.getValue('siteID'),rs.moduleID) />
			<cfif rsOnError.recordcount>
				<cfset arguments.event.setValue("errorType","render")>
				<cfset arguments.event.setValue("error",cfcatch)>
				<cfreturn renderScripts("onError",event.getValue('siteID'),arguments.event,rsOnError)>
			<cfelse>
			 <cfsavecontent variable="theDisplay1"><cfdump var="#cfcatch#"></cfsavecontent>
			 <cfreturn theDisplay1>
			</cfif>		
		</cfcatch>
		</cftry>
		</cfif>
	
		<cfreturn "">
</cffunction>

<cffunction name="getDirectoryFromQuery" returntype="String" output="false">
<cfargument name="rs">
	<cfif len(rs.package)>
		<cfreturn "#rs.package#.#rs.pluginID#">
	<cfelse>
		<cfreturn "#rs.pluginID#">
	</cfif>
</cffunction>
	
<cffunction name="getComponent" returntype="any" output="false">
<cfargument name="componentPath">
<cfargument name="pluginID">
<cfargument name="siteID">
<cfargument name="cache" required="true" default="true">
	
	<cfset var pluginConfig="">
	<cfif isBoolean(arguments.cache) and arguments.cache>
		<cfif NOT getCacheFactory(arguments.siteid).has( componentPath ) or variables.configBean.getMode() eq "development">
			<cfif arguments.pluginID>
				<cfset pluginConfig=getConfig(arguments.pluginID)>	
				<cfreturn getCacheFactory(arguments.siteid).get( componentPath, createObject("component",componentPath).init(pluginConfig,configBean) ) />
			<cfelse>
				<cfreturn getCacheFactory(arguments.siteid).get( componentPath, createObject("component",componentPath).init(configBean) ) />
			</cfif>	
		<cfelse>
			<cfreturn getCacheFactory(arguments.siteid).get( componentPath) />
		</cfif>
	<cfelse>
		<cfset pluginConfig=getConfig(arguments.pluginID)>
		<cfreturn createObject("component",componentPath).init(pluginConfig,configBean) />
	</cfif>

</cffunction>

<cffunction name="getExecutor" returntype="any" output="false">
<cfset var executor=createObject("component","pluginExecutor").init(variables.configBean,variables.settingsManager,this) />
<cfreturn executor />
</cffunction>

<cffunction name="getDisplayObjectBean" returntype="any" output="false">
<cfreturn createObject("component","pluginDisplayObjectBean").init(variables.configBean,this) />
</cffunction>

<cffunction name="getScriptBean" returntype="any" output="false">
<cfreturn createObject("component","pluginScriptBean").init(variables.configBean) />
</cffunction>

<cffunction name="purgeEventManagers" returntype="any" output="false">
<cfset variables.eventManagers=structNew()/>
</cffunction>

<cffunction name="getEventManager" returntype="any" output="false">
<cfargument name="siteid" required="true" default="">


	<cfif not structKeyExists(variables.eventManagers,arguments.siteid)>
		<cfset variables.eventManagers[arguments.siteid]=createObject("component","pluginEventManager").init(arguments.siteID,variables.genericManager,this)>
	</cfif>
	
	<cfreturn variables.eventManagers[arguments.siteid]>
</cffunction>

<cffunction name="getCacheFactory" returntype="any" output="false">
<cfargument name="siteid" required="true" default="">


	<cfif not structKeyExists(variables.cacheFactories,arguments.siteid)>
		<cfset variables.cacheFactories[arguments.siteid]=createObject("component","mura.cache.cacheFactory").init(isSoft=false)>
	</cfif>
	
	<cfreturn variables.cacheFactories[arguments.siteid]>
</cffunction>

<cffunction name="purgeCacheFactories" returntype="any" output="false">
<cfset variables.cacheFactories=structNew()/>
</cffunction>

<cffunction name="renderAdminTemplate" returntype="any" output="false">
<cfargument name="body">
<cfargument name="pageTitle">
<cfargument name="jsLib" required="true" default="prototype">
<cfargument name="jsLibLoaded" required="true" default="false">
<cfset var fusebox=structNew()>
<cfset var myFusebox=structNew()>
<cfset var returnStr="">
<cfset var moduleTitle=arguments.pageTitle>
<cfset var attributes=structNew()>

<cfset fusebox.layout =arguments.body>
<cfset fusebox.ajax ="">
<cfset myfusebox.originalcircuit="cPlugins">
<cfset myfusebox.originalfuseaction="">
<cfset attributes.moduleID="">
<cfset attributes.jsLib=arguments.jsLib>
<cfset attributes.jsLibLoaded=arguments.jsLibLoaded>
<cfsavecontent variable="returnStr">
<cfinclude template="/#variables.configBean.getWebrootMap()#/admin/view/layouts/template.cfm">
</cfsavecontent>

<cfreturn returnStr/>
</cffunction>

<cffunction name="renderAdminToolbar" returntype="any" output="false">
<cfargument name="jsLib" required="true" default="prototype">
<cfargument name="jsLibLoaded" required="true" default="false">
<cfset var returnStr="">

<cfsavecontent variable="returnStr">
<cfinclude template="/#variables.configBean.getWebrootMap()#/admin/view/layouts/pluginHeader.cfm">
</cfsavecontent>

<cfreturn returnStr/>
</cffunction>

<cffunction name="createLookupTXT" returntype="void" output="false">
<cfset var lookUpText="">
<cfset var rs=getAllPlugins("pluginID")>
<cfsavecontent variable="lookUpText"><cfoutput query="rs">#rs.pluginID# - #rs.name#
</cfoutput></cfsavecontent>

<cffile action="write" output="#lookUpText#" file="#expandPath('/plugins')#/lookupByPluginID.txt" mode="777">

<cfquery name="rs" dbtype="query">
select * from rs order by name
</cfquery>

<cfsavecontent variable="lookUpText"><cfoutput query="rs">#rs.name# -  #rs.pluginID#
</cfoutput></cfsavecontent>

<cffile action="write" output="#lookUpText#" file="#expandPath('/plugins')#/lookupByName.txt" mode="777">


</cffunction>

<cffunction name="getIDFromPath" returntype="any" output="false">
<cfargument name="path">
	<cfreturn listLast(listGetat(getDirectoryFromPath(arguments.path),listLen(getDirectoryFromPath(arguments.path),variables.configBean.getFileDelim())-1,variables.configBean.getFileDelim()),"_")>
</cffunction>

<cffunction name="addEventHandler" output="false" returntype="void">
<cfargument name="component">
<cfargument name="siteID" required="true">
<cfargument name="persist" required="true" default="true">
<cfset var i = "">
<cfset var handlerData=structNew()>
<cfset var eventhandler=arguments.component>

	<cfif not StructKeyExists(variables.siteListeners,arguments.siteid)>
		<cfset variables.siteListeners[arguments.siteID]=structNew()>
	</cfif>
	
	<cfif isObject(eventHandler)>
		<cfset arrayAppend(variables.eventHandlers,eventhandler)>
		<cfset _persist=true>
	<cfelse>
		<cfset eventhandler=getEventHandlerFromPath(eventHandler)>
		<cfif arguments.persist>
			<cfset arrayAppend(variables.eventHandlers,eventhandler)>
		<cfelse>
			<cfset arrayAppend(variables.eventHandlers,arguments.component)>
		</cfif>
	</cfif>
		
	<cfloop collection="#eventhandler#" item="i">
		<cfif left(i,2) eq "on" or left(i,8) eq "standard">
			<cfset handlerData=structNew()>
			<cfset handlerData.index=arrayLen(variables.eventHandlers)>
			<cfif left(i,8) neq "onGlobal">
				<cfif not structKeyExists(variables.siteListeners[arguments.siteID],i)>
					<cfset variables.siteListeners[arguments.siteID][i]=arrayNew(1)>
				</cfif>
				<cfset arrayAppend( variables.siteListeners[arguments.siteID][i] , handlerData)>
			<cfelse>
				<cfset arrayAppend( variables.globalListeners[arguments.siteID][i] , handlerData)>
			</cfif>
		</cfif>
	</cfloop>

</cffunction>

<cffunction name="getEventHandlerFromPath" output="false" returntype="any">
<cfargument name="component">
	<cfset var eventhandler=createObject("component",arguments.component)>
	<cfif structKeyExists(eventHandler,"init")>
		<cfset eventHandler.init()>
	</cfif>
	<cfreturn eventHandler>
</cffunction>

<cffunction name="getSiteListener" ouput="false" returntype="any">
<cfargument name="siteID">
<cfargument name="runat">

	<cfif isDefined("variables.siteListeners.#arguments.siteID#.#arguments.runat#")>
		<cfset variables.listeners[arguments.siteID]=structNew()>
		<cfset listenerArray=evaluate("variables.siteListeners.#arguments.siteID#.#arguments.runat#")>
		<cfreturn variables.eventHandlers[listenerArray[1].index]>
	<cfelse>
		<cfreturn "">
	</cfif>
		
</cffunction>

<cffunction name="dumpAnon">
<cfdump var="#variables.eventHandlers#">
<cfdump var="#variables.siteListeners#">
</cffunction>

</cfcomponent>