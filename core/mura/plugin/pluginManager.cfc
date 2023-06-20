<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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

In addition, as a special exception, "the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides plugin service level logic functionality">

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.standardEventFactories=structNew()>
<cfset variables.standardEventsHandler="">
<cfset variables.cacheFactories=structNew()>
<cfset variables.siteListeners=structNew()>
<cfset variables.globalListeners=structNew()>
<cfset variables.pluginConfigs=structNew()>
<cfset variables.eventHandlers=arrayNew(1)>
<cfset variables.eventHandlersLoaded = false>
<cfset variables.zipTool="">

<cffunction name="init" output="false">
	<cfargument name="configBean" required="true">
	<cfargument name="settingsManager" required="true">
	<cfargument name="utility" required="true">
	<cfargument name="standardEventsHandler" required="true">
	<cfargument name="fileWriter" required="true">

	<cfset var sessionData=getSession()>

	<cfset variables.configBean=arguments.configBean>
	<cfset variables.settingsManager=arguments.settingsManager>
	<cfset variables.utility=arguments.utility>
	<cfset variables.standardEventsHandler=arguments.standardEventsHandler>
	<cfset variables.fileWriter=arguments.fileWriter>

	<cfif variables.configBean.getJavaEnabled()>
		<cfset variables.zipTool=createObject("component","mura.Zip")>
	</cfif>

	<cfif isdefined("url.safemode") and isDefined("sessionData.mura.memberships") and listFindNoCase(sessionData.mura.memberships,"S2")>
		<cfset loadPlugins(safeMode=true)>
	<cfelse>
		<cfset loadPlugins(safeMode=false)>
	</cfif>

	<cfreturn this />
</cffunction>

<cffunction name="loadPlugins" output="false">
<cfargument name="safeMode" default="false">
<cfset var rsScripts1="">
<cfset var rsScripts2="">
<cfset var siteIDadjusted="">
<cfset var handlerData="">

<cflock name="loadPluginsBlock#application.instanceID#" type="exclusive" timeout="200">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='variables.rsplugins')#">
	select * from tplugins
	<cfif arguments.safeMode>
		where 0=1
	</cfif>
	</cfquery>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='variables.rsPluginSiteAsignments')#">
	select moduleID, siteid from tcontent where type='Plugin'
	<cfif arguments.safeMode>
		and 0=1
	</cfif>
	</cfquery>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='variables.rsSettings')#">
	select * from tpluginsettings
	<cfif arguments.safeMode>
		where 0=1
	</cfif>
	</cfquery>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsScripts1')#">
	select tplugins.name, tplugins.package, tplugins.directory, tpluginscripts.moduleID, tplugins.pluginID, tpluginscripts.runat, tpluginscripts.scriptfile,
	tcontent.siteID, tpluginscripts.docache, tplugins.loadPriority from tpluginscripts
	inner join tplugins on (tpluginscripts.moduleID=tplugins.moduleID)
	inner join tcontent on (tplugins.moduleID=tcontent.moduleID)
	where tpluginscripts.runat not in ('onGlobalLogin','onGlobalRequestStart','onApplicationLoad','onGlobalError','onGlobalSessionStart','onGlobalSessionEnd')
	and tplugins.deployed=1
	<cfif arguments.safeMode>
		and 0=1
	</cfif>
	</cfquery>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsScripts2')#">
	select tplugins.name, tplugins.package, tplugins.directory, tpluginscripts.moduleID, tplugins.pluginID, tpluginscripts.runat, tpluginscripts.scriptfile,
	<cfif variables.configBean.getDbType() eq 'postgresql'>
		cast('' as varchar(25))
	<cfelse>
		''
	</cfif> as siteID, tpluginscripts.docache,tplugins.loadPriority from tpluginscripts
	inner join tplugins on (tpluginscripts.moduleID=tplugins.moduleID)
	where tpluginscripts.runat in ('onGlobalLogin','onGlobalRequestStart','onApplicationLoad','onGlobalError','onGlobalSessionStart','onGlobalSessionEnd')
	and tplugins.deployed=1
	<cfif arguments.safeMode>
		and 0=1
	</cfif>
	</cfquery>

	<cfquery name="variables.rsScripts" dbtype="query">
	select * from rsScripts1
	union
	select * from rsScripts2
	</cfquery>

	<cfquery name="variables.rsScripts" dbtype="query">
	select * from rsScripts order by loadPriority
	</cfquery>

	<cfif not variables.eventHandlersLoaded>
		<cfloop query="variables.rsScripts">
			<cfset arrayAppend(variables.eventHandlers,variables.rsScripts.currentrow)>
			<cfset handlerData=structNew()>
			<cfset handlerData.index=arrayLen(variables.eventHandlers)>
			<cfset handlerData.pluginName=variables.rsScripts.name>

			<cfif left(variables.rsScripts.runat,8) neq "onGlobal" and variables.rsScripts.runat neq "onApplicationLoad">
				<cfset siteIDadjusted=adjustSiteID(variables.rsScripts.siteID)>
				<cfif not StructKeyExists(variables.siteListeners,siteIDadjusted)>
					<cfset variables.siteListeners[siteIDadjusted]=structNew()>
				</cfif>
				<cfif not structKeyExists(variables.siteListeners[siteIDadjusted],variables.rsScripts.runat)>
					<cfset variables.siteListeners[siteIDadjusted][variables.rsScripts.runat]=arrayNew(1)>
				</cfif>
				<cfset arrayAppend( variables.siteListeners[siteIDadjusted][variables.rsScripts.runat] , handlerData)>
			<cfelse>
				<cfif not structKeyExists(variables.globalListeners,variables.rsScripts.runat)>
					<cfset variables.globalListeners[variables.rsScripts.runat]=arrayNew(1)>
				</cfif>
				<cfset arrayAppend( variables.globalListeners[variables.rsScripts.runat], handlerData)>
			</cfif>
		</cfloop>
		<cfset variables.eventHandlersLoaded=true>
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='variables.rsDisplayObjects')#">
	select tplugindisplayobjects.objectID, tplugindisplayobjects.moduleID, tplugindisplayobjects.name,
	tplugindisplayobjects.displayObjectfile, tplugins.pluginID, tplugins.package, tplugins.directory, tcontent.siteID, tplugins.name title, tplugins.package, tplugins.directory,
	tplugindisplayobjects.location, tplugindisplayobjects.displaymethod, tplugindisplayobjects.docache,tplugindisplayobjects.configuratorInit, tplugindisplayobjects.configuratorJS
	from tplugindisplayobjects inner join tplugins on (tplugindisplayobjects.moduleID=tplugins.moduleID)
	inner join tcontent on (tplugins.moduleID=tcontent.moduleID)
	<cfif arguments.safeMode>
		where 0=1
	</cfif>
	</cfquery>

	<cfset purgeStandardEventFactories()/>
	<cfset purgeCacheFactories()/>
	<cfset purgePluginConfigs()/>
</cflock>
</cffunction>

<cffunction name="getLocation" output="false">
<cfargument name="directory">

	<cfreturn "#variables.configBean.getPluginDir()#/#arguments.directory#/">
</cffunction>

<cffunction name="getAllPlugins" output="false">
<cfargument name="orderby" default="name" required="true">
<cfset var rsAllPlugins="">
<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsAllPlugins')#">
select * from tplugins order by #arguments.orderby#
</cfquery>
<cfreturn rsAllPlugins/>
</cffunction>

<cffunction name="deploy" output="false" hint="This method is primarily used internally by Masa CMS. See deployPlugin." >
<cfargument name="moduleID" required="true" default="">
<cfargument name="id" required="true" default="" hint="Either ModuleID, PluginID or Package. Can be used instead of moduleID argument.">
<cfargument name="useDefaultSettings" required="true" default="false" hint="Deploy default config.xml settings values, not applicable for bundles">
<cfargument name="siteID" default="" hint="List of siteIDs to assign the plugin. Only applicable when useDefaultSettings is set to true.">
<cfargument name="pluginFile" required="true" default="">
<cfargument name="pluginDir" required="true" default="">
<cfargument name="autoDeploy" required="true" default="true">

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
<cfset var errors=structNew()>
<cfset var rsZipFiles="">
<cfset var zipTrim="">
<cfset var deployArgs=structNew()>
<cfset var settingsLen=0>
<cfset var settingsBean="">
<cfset var serverFile="">
<cfset var cffileData=structNew()>
<cfset var isPostedFile=false>
<cfset var settingBean="">

<cflock name="addPlugin#application.instanceID#" timeout="200">
	<!--- <cftry> --->

	<cfif not len(modID) and len(arguments.id)>
		<cfset modID=getPlugin(id,'',false).moduleID>
	</cfif>

	<!--- check to see if you want me to download something --->
	<cfif isValid("url", arguments.pluginFile)>
		<cfset serverfile=getLocalFileFromURL(arguments.pluginURL)>

	<!--- Check if a path to a file was submitted--->
	<cfelseif len(arguments.pluginFile)>
		<cfset serverFile=arguments.pluginFile>

	<cfelseif isDefined("form.NewPlugin")>
		<cfif isValid("url", form.NewPlugin)>
			<cfset serverfile=getLocalFileFromURL(form.NewPlugin)>

		<!--- Check if a file from a form was submitted --->
		<cfelseif getBean("fileManager").isPostedFile(form.NewPlugin)>
			<cffile action="upload" result="cffileData" filefield="NewPlugin" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#" >
			<cfset serverFile="#variables.configBean.getTempDir()#/#cffileData.serverFile#">

		</cfif>
	</cfif>

	<!--- Check to see if this is an Bundled plugin --->
	<cfif len(serverFile) and variables.settingsManager.isBundle(serverfile)>

		<cfif len(modID)>
			<cfset errors=variables.settingsManager.restoreBundle(BundleFile=serverfile,siteID=arguments.siteID,keyMode="publish",contentMode="none", renderingMode="none",pluginMode="all", moduleID=modID)>
			<cfif not structIsEmpty(errors)>
				<cfset getCurrentUser().setValue("errors",errors)>
				<cfreturn "">
			</cfif>
		<cfelse>
			<cfset errors=variables.settingsManager.restoreBundle(BundleFile=serverfile,siteID=arguments.siteID,keyMode="copy", contentMode="none", renderingMode="none",pluginMode="all", moduleID="")>
			<cfif not structIsEmpty(errors)>
				<cfset getCurrentUser().setValue("errors",errors)>
				<cfreturn "">
			</cfif>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPlugin')#">
			select pluginID,moduleID from tplugins order by pluginID desc
			</cfquery>
			<cfset modID=rsPlugin.moduleID>
		</cfif>

		<cfset loadPlugins() />

		<cfreturn modID>

	<cfelse>

		<cfif not len(modID)>
			<cfset isNew=true/>
			<cfset modID=createUUID()/>
		<cfelse>
			<cfset deleteScripts(modID) />
		</cfif>

		<cfif isNew>
			<cfquery>
			insert into tplugins (moduleID,name,provider,providerURL,version,deployed,
			category,created,loadPriority,directory) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#modID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="An error occurred.">,
			null,
			null,
			null,
			0,
			null,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			5,
			<cfif len(arguments.pluginDir)>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pluginDir#">
			<cfelse>
				null
			</cfif>
			)
			</cfquery>
		<cfelse>
			<cfquery>
			update tplugins set deployed=2 where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#modID#">
			</cfquery>
		</cfif>

		<cfset rsPlugin=getPlugin(modID,'',false) />

		<!--- Set the directory to the newly installed pluginID--->
		<cfif isNew and not len(arguments.pluginDir)>
			<cfquery>
			update tplugins set
			directory=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPlugin.pluginID#">
			where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPlugin.moduleID#">
			</cfquery>
			<cfset rsPlugin=getPlugin(modID,'',false) />
		</cfif>

		<cfset location=getLocation(rsPlugin.directory) />

		<!--- if new the location will be the newly created pluginID --->
		<cfif not directoryExists(location)>
			<cfset variables.fileWriter.createDir(directory=location)>
		</cfif>

		<cfif len(serverFile)>
			<cfset zipTrim=getZipTrim(serverFile)>

			<cfif len(zipTrim)>
				<cfset variables.zipTool.extract(zipFilePath=serverfile,extractPath=location, overwriteFiles=true, extractDirs=zipTrim, extractDirsToTop=true)>
			<cfelse>
				<cfset variables.zipTool.extract(zipFilePath=serverfile,extractPath=location, overwriteFiles=true)>
			</cfif>

			<cfif not structIsEmpty(cffileData)>
				<cffile action="delete" file="#serverfile#">
			</cfif>
		<!---<cfelseif getLocation(arguments.pluginDir) neq location>
			<cfset variables.fileWriter.copyDir(baseDir=getLocation(arguments.pluginDir),destDir=location,excludeHiddenFiles=false)>
		--->
		</cfif>

		<cfset savePluginXML(modID=modID) />
		<cfset loadPlugins() />

		<cfif arguments.useDefaultSettings>

			<cfset pluginXML=getPluginXML(modID)>
			<cfset rsPlugin=getPlugin(modID)>

			<!---
			<cfset deployArgs.location="global">
			--->
			<cfset deployArgs.overwrite="false">

			<cfif structKeyExists(pluginXML.plugin,"package") and len(pluginXML.plugin.package.xmlText)>
				<cfset deployArgs.package=pluginXML.plugin.package.xmlText>
			<cfelse>
				<cfset deployArgs.package="">
			</cfif>

			<cfif structKeyExists(pluginXML.plugin,"autoDeploy") and isBoolean(pluginXML.plugin.autoDeploy.xmlText)>
				<cfset deployArgs.autoDeploy=pluginXML.plugin.autoDeploy.xmlText>
			<cfelse>
				<cfset deployArgs.autoDeploy=arguments.autoDeploy>
			</cfif>

			<cfif structKeyExists(pluginXML.plugin,"siteid") and len(pluginXML.plugin.siteid.xmlText)>
				<cfset deployArgs.siteAssignID=pluginXML.plugin.siteID.xmlText>
			<cfelse>
				<cfset deployArgs.siteAssignID=arguments.siteID>
			</cfif>

			<cfif isDefined("pluginXML.plugin.settings.xmlChildren") and isArray(pluginXML.plugin.settings.xmlChildren)>
				<cfset settingsLen=arraylen(pluginXML.plugin.settings.xmlChildren)/>
			<cfelse>
				<cfset settingsLen=0>
			</cfif>

			<cfset deployArgs.pluginAlias=rsPlugin.name>
			<cfset deployArgs.loadPriority= rsPlugin.loadPriority>
			<cfset deployArgs.moduleID=modID>

			<cfloop from="1" to="#settingsLen#" index="i">
				<cfset settingBean=getAttributeBean(pluginXML.plugin.settings.setting[i],modID)/>
				<cfif not len(settingBean.getSettingValue())
						and not rsPlugin.deployed>
					<cfif structKeyExists(pluginXML.plugin.settings.setting[i],'defaultValue')>
						<cfset settingBean.setSettingValue(pluginXML.plugin.settings.setting[i].defaultValue.xmlText)>
					<cfelseif structKeyExists(pluginXML.plugin.settings.setting[i].xmlAttributes,'defaultValue')>
						<cfset settingBean.setSettingValue(pluginXML.plugin.settings.setting[i].xmlAttributes.defaultValue)>
					</cfif>
				</cfif>
				<cfset deployArgs["#settingBean.getname()#"]=getBean('contentRenderer').setDynamicContent(settingBean.getSettingValue())>
			</cfloop>

			<cfset updateSettings(deployArgs)>

		</cfif>

		<cfreturn modID/>

	</cfif>

	</cflock>



</cffunction>

<cffunction name="savePluginXML" output="false">
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
	<cfset var pluginXML=getPluginXML(modID)>


	<cfquery>
	update tplugins set
	provider=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.provider.xmlText#">,
	providerURL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.providerURL.xmlText#">,
	version=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.version.xmlText#">,
	category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.category.xmlText#">,
	created=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">

	<cfif not rsPlugin.deployed>,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.name.xmlText#">,

		<cfif structKeyExists(pluginXML.plugin,"loadPriority") and isNumeric(pluginXML.plugin.loadPriority.xmlText)>
			loadPriority=<cfqueryparam cfsqltype="cf_sql_numeric" value="#pluginXML.plugin.loadPriority.xmlText#">,
		<cfelse>
			loadPriority=5,
		</cfif>

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

	<cfif structKeyExists(pluginXML.plugin,"displayobjects") and structKeyExists(pluginXML.plugin.displayobjects,"displayobject")>
	<cfset objectsLen=arraylen(pluginXML.plugin.displayobjects.displayobject)/>
		<cfif objectsLen>
			<cfloop from="1" to="#objectsLen#" index="i">
				<cfset displayObject=getDisplayObjectBean() />
				<cfset displayObject.setModuleID(modID) />
				<cfset displayObject.setName(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.name) />
				<cfset displayObject.loadByName() />
				<!---
				<cfif structKeyExists(pluginXML.plugin.displayobjects.xmlAttributes,"location")>
					<cfset displayObject.setLocation(pluginXML.plugin.displayobjects.xmlAttributes.location) />
				<cfelse>
				--->
					<cfset displayObject.setLocation("global") />
				<!---
				</cfif>
				--->
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
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"configuratorInit")>
					<cfset displayObject.setConfiguratorInit(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.configuratorInit) />
				<cfelse>
					<cfset displayObject.setConfiguratorInit("") />
				</cfif>
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"configuratorJS")>
					<cfset displayObject.setconfiguratorJS(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.configuratorJS) />
				<cfelse>
					<cfset displayObject.setconfiguratorJS("") />
				</cfif>
				<cfset displayObject.save() />
			</cfloop>

		</cfif>
	</cfif>

</cffunction>

<cffunction name="createAppCFCIncludes" output="false">
	<cfset var done=structNew()>
	<cfset var mHash="">
	<cfset var m="">
	<cfset var baseDir=variables.configBean.getPluginDir()>
	<cfset var rsRequirements="">
	<cfset var currentConfig="">
	<cfset var currentDir="">
	<cfset var p="">
	<cfset var currentPath="">
	<cfset var pluginmapping="">
	<cfset var pluginCfapplicationFilePathName = "#baseDir#/cfapplication.cfm" />
	<cfset var pluginCfapplicationTempFilePathName = "#baseDir#/cfapplication.tmp.cfm" />
	<cfset var pluginMappingsFilePathName = "#baseDir#/mappings.cfm" />
	<cfset var pluginMappingsTempFilePathName = "#baseDir#/mappings.tmp.cfm" />

	<cflock name="createAppCFCIncludes#application.instanceID#" type="exclusive" timeout="200">
	<!--- Similar functionality is found elsewhere; be sure to use those named locks, too --->
	<cflock name="buildPluginCFApplication" type="exclusive" throwontimeout="true" timeout="5" >
	<cflock name="buildPluginMappings" type="exclusive" throwontimeout="true" timeout="5" >

	<cfif fileExists(pluginMappingsTempFilePathName) >
		<cffile action="delete" file="#pluginMappingsTempFilePathName#">
	</cfif>
	<cfset variables.fileWriter.writeFile(file="#pluginMappingsTempFilePathName#", output="<!--- Do Not Edit --->", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output="<cfif not isDefined('this.name')>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output="<cfoutput>Access Restricted.</cfoutput>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output="<cfabort>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output="</cfif>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output="<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output='<cfset this.mappings["/plugins"] = pluginDir>')>

	<cfif fileExists(pluginCfapplicationTempFilePathName) >
		<cffile action="delete" file="#pluginCfapplicationTempFilePathName#">
	</cfif>
	<cfset variables.fileWriter.writeFile(file="#pluginCfapplicationTempFilePathName#", output="<!--- Do Not Edit --->", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output="<cfif not isDefined('this.name')>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output="<cfoutput>Access Restricted.</cfoutput>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output="<cfabort>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output="</cfif>", addnewline="true")>
	<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output="<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>", addnewline="true")>

	<cfdirectory action="list" directory="#baseDir#" name="rsRequirements">
	<cfloop query="rsRequirements">
		<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
			<cftry>
				<cfset m=listFirst(rsRequirements.name,"_")>
				<cfset mHash=hash(m)>
				<cfset currentConfig=getPluginXML(listLast(rsRequirements.name,"_"))>

				<cfif not isDefined("currentConfig.plugin.createmapping.xmlText")
					or yesNoFormat(currentConfig.plugin.createmapping.xmlText)>
					<cfif not isNumeric(m) and not structKeyExists(done,mHash)>
						<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output='<cfset this.mappings["/#m#"] = pluginDir & "#rsRequirements.name#">')>
						<cfset done[mHash]=true>
					</cfif>
				</cfif>

				<cfset currentDir="#baseDir#/#rsRequirements.name#">

				<cfif isDefined("currentConfig.plugin.mappings.mapping") and arrayLen(currentConfig.plugin.mappings.mapping)>
					<cfloop from="1" to="#arrayLen(currentConfig.plugin.mappings.mapping)#" index="m">
						<cfif structkeyExists(currentConfig.plugin.mappings.mapping[m].xmlAttributes,"directory")
						and len(currentConfig.plugin.mappings.mapping[m].xmlAttributes.directory)
						and structkeyExists(currentConfig.plugin.mappings.mapping[m].xmlAttributes,"name")
						and len(currentConfig.plugin.mappings.mapping[m].xmlAttributes.name)>
							<cfset p=currentConfig.plugin.mappings.mapping[m].xmlAttributes.directory>
							<cfif listFind("/,\",left(p,1))>
								<cfif len(p) gt 1>
									<cfset p=right(p,len(p)-1)>
								<cfelse>
									<cfset p="">
								</cfif>
							</cfif>
							<cfset currentPath=currentDir & "/" & p>
							<cfif len(p) and directoryExists(currentPath)>
								<cfset pluginmapping=currentConfig.plugin.mappings.mapping[m].xmlAttributes.name>
								<cfset variables.fileWriter.appendFile(file="#pluginMappingsTempFilePathName#", output='<cfif not structKeyExists(this.mappings,"/#pluginmapping#")><cfset this.mappings["/#pluginmapping#"] = pluginDir & "#rsRequirements.name#/#p#"></cfif>')>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				<cfif isDefined("currentConfig.plugin.customtagpaths.xmlText") and len(currentConfig.plugin.customtagpaths.xmlText)>
					<cfloop list="#currentConfig.plugin.customtagpaths.xmlText#" index="p">
						<cfif listFind("/,\",left(p,1))>
							<cfif len(p) gt 1>
								<cfset p=right(p,len(p)-1)>
							<cfelse>
								<cfset p="">
							</cfif>
						</cfif>
						<cfset currentPath=currentDir & "/" & p>
						<cfif len(p) and directoryExists(currentPath)>
							<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output='<cfset this.customtagpaths = listAppend(this.customtagpaths, pluginDir & "#rsRequirements.name#/#p#" )>')>
						</cfif>
					</cfloop>
				</cfif>
				<cfif isDefined("currentConfig.plugin.ormcfclocation.xmlText") and len(currentConfig.plugin.ormcfclocation.xmlText)>
					<cfloop list="#currentConfig.plugin.ormcfclocation.xmlText#" index="p">
						<cfif listFind("/,\",left(p,1))>
							<cfif len(p) gt 1>
								<cfset p=right(p,len(p)-1)>
							<cfelse>
								<cfset p="">
							</cfif>
						</cfif>
						<cfset currentPath=currentDir & "/" & p>
						<cfdump var="#currentpath#">
						<cfif len(p) and directoryExists(currentPath)>
							<cfset variables.fileWriter.appendFile(file="#pluginCfapplicationTempFilePathName#", output='<cfset arrayAppend(this.ormsettings.cfclocation, pluginDir & "#rsRequirements.name#/#p#")>')>
						</cfif>
					</cfloop>
				</cfif>
			<cfcatch></cfcatch>
			</cftry>
		</cfif>
	</cfloop>

	<!--- Swap out the real file with the temporary file. --->
	<cffile action="rename" source="#pluginMappingsTempFilePathName#" destination="#pluginMappingsFilePathName#" />
	<cffile action="rename" source="#pluginCfapplicationTempFilePathName#" destination="#pluginCfapplicationFilePathName#" />

	</cflock>
	</cflock>
	</cflock>
</cffunction>


<cffunction name="discover" output="false">
	<cfset var baseDir=variables.configBean.getPluginDir()>
	<cfset var rsRequirements="">
	<cfset var configXML="">
	<cfset var item="">
	<cfset var rsCheckDiscoveredPlugin="">
	<cfset var tempDir="">
	<cfset var currentPlugin="">

	<cflock name="pluginDiscovery#application.instanceID#" type="exclusive" timeout="200">
		<cfdirectory action="list" directory="#baseDir#" name="rsRequirements">
		<cfloop query="rsRequirements">

			<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>

				<cfset configXML="">
				<cftry>
					<cfset configXML=getPluginXML(moduleID="",pluginDir=rsRequirements.name)>
					<cfcatch></cfcatch>
				</cftry>

				<cfif isXml(configXML)>
					<cfif not hasPlugin(listLast(rsRequirements.name,"_"),"",false)>
						<cfset var siteids=''>
						<cfif structKeyExists(configXML.plugin,"defaultsiteids")
							and len(configXML.plugin.defaultsiteids.xmlText)>
							<cfset siteids=configXML.plugin.defaultsiteids.xmlText>
						</cfif>
						<cfset deployDirectory(directory=rsRequirements.name,autoDeploy=false,siteid=siteids)>
					<cfelseif structKeyExists(configXML.plugin,"autoUpdate")
							and isBoolean(configXML.plugin.autoUpdate.xmlText)
							and isBoolean(configXML.plugin.autoUpdate.xmlText)
							and configXML.plugin.autoUpdate.xmlText EQ true
							and structKeyExists(configXML.plugin,"version")>
							<!--- If Plugin.xml contains "autoupdate=true" and version doesn't match deployed version, then redeploy plugin --->
							<cfset currentPlugin = getPlugin(listLast(rsRequirements.name,"_"),"",false) >
							<cfif currentPlugin.version NEQ configXML.plugin.version>
								<cfset reDeploy(id:currentPlugin.pluginID)>
							</cfif>
					</cfif>
				</cfif>
			<cfelseif listLast(rsRequirements.name,".") eq 'zip'>
				<cfset item="#baseDir#/#rsRequirements.name#">
				<cfif variables.settingsManager.isBundle(item)>
					<cfset deployBundle(siteID="", bundleFile=item)>
					<cfset fileDelete(item)>
				<cfelse>
					<cfset item="#baseDir#/#rsRequirements.name#">
					<cfset rsCheckDiscoveredPlugin=createObject("component","mura.Zip").list(item)>

					<cfquery name="rsCheckDiscoveredPlugin" dbtype="query">
						select * from rsCheckDiscoveredPlugin
						where entry like '%plugin#variables.configBean.getFileDelim()#config.xml'
						or entry like '%plugin#variables.configBean.getFileDelim()#config.xml.cfm'
					</cfquery>
					<cfif rsCheckDiscoveredPlugin.recordcount>
						<cfset deployPlugin(siteID="",pluginFile=item,useDefaultSettings=true,autoDeploy=false)>
						<cfset fileDelete(item)>
					</cfif>
				</cfif>
			</cfif>

		</cfloop>
	</cflock>
</cffunction>

<cffunction name="hasPlugin" output="false">
<cfargument name="ID">
<cfargument name="siteID" required="true" default="">
<cfargument name="cache" required="true" default="true">

	<cfreturn getPlugin(arguments.ID, arguments.siteID, arguments.cache).recordcount>
</cffunction>

<cffunction name="getPlugin" output="false">
<cfargument name="ID">
<cfargument name="siteID" required="true" default="">
<cfargument name="cache" required="true" default="true">
	<cfset var rsPlugin=""/>
	<cfset var rsModuleCheck=""/>
	<cfif arguments.cache>

		<cfif len(arguments.siteID)>
			<cfquery name="rsModuleCheck" dbtype="query">
			select moduleID from variables.rsPluginSiteAsignments
			where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
			</cfquery>
		</cfif>

		<cfquery name="rsPlugin" dbtype="query">
		select * from variables.rsPlugins where
		<cfif isNumeric(arguments.ID)>
			pluginID=#arguments.ID#
		<cfelseif isValid("UUID",arguments.ID)>
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
		<cfelse>
			(
				name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
				or
				package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
			)
		</cfif>

		<cfif len(arguments.siteID)>
		and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsModuleCheck.moduleID)#">)
		</cfif>
		</cfquery>
	<cfelse>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPlugin')#">
		select * from tplugins where
		<cfif isNumeric(arguments.ID)>
			pluginID=#arguments.ID#
		<cfelseif isValid("UUID",arguments.ID)>
			moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
		<cfelse>
			(
				name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
				or
				package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
			)
		</cfif>

		<cfif len(arguments.siteID)>
		and moduleID in (select moduleID from tcontent
						where type='Plugin'
						and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
		</cfif>
		</cfquery>
	</cfif>

	<cfreturn rsPlugin>
</cffunction>

<cffunction name="getPluginXML" returntype="xml" output="false">
<cfargument name="moduleID">
<cfargument name="pluginDir" default="">
	<cfset var theXML="">
	<cfset var rsPlugin="">

	<cfif not len(arguments.pluginDir)>
		<cfset rsPlugin=getPlugin(arguments.moduleID,'',false)>
		<cfset arguments.pluginDir=rsPlugin.directory>
	</cfif>

	<cfif fileExists("#getLocation(arguments.pluginDir)#plugin/config.xml")>
		<cffile action="read" file="#getLocation(arguments.pluginDir)#plugin/config.xml" variable="theXML">
	<cfelse>
		<cfsavecontent variable="theXML"><cfoutput><cfinclude template="/plugins/#arguments.pluginDir#/plugin/config.xml.cfm"></cfoutput></cfsavecontent>
	</cfif>
	<cfreturn parseXML(theXML)/>
</cffunction>

<cffunction name="getAttributeBean" output="false">
<cfargument name="theXML">
<cfargument name="moduleID">
	<cfset var bean=getBean("pluginSettingBean")>
	<cfset bean.set(arguments.theXML,arguments.moduleID)/>

	<cfreturn bean/>
</cffunction>

<cffunction name="getConfig" output="false">
<cfargument name="ID">
<cfargument name="siteID" required="true" default="">
<cfargument name="cache" required="true" default="true">


	<cfset var pluginConfig="">
	<cfset var rs="">
	<cfset var pluginID=0>
	<cfset var settingStr=structNew()>
	<cfset rs=getPlugin(arguments.ID,arguments.siteID,arguments.cache)>
	<cfset pluginID=rs.pluginID>

	<cfif not arguments.cache or not structKeyExists(variables.pluginConfigs,"p#rs.pluginID#")>
		<cfset pluginConfig=createObject("component","mura.plugin.pluginConfig")>
		<cfset pluginConfig.setVersion(rs.version) />
		<cfset pluginConfig.setName(rs.name) />
		<cfset pluginConfig.setProvider(rs.provider) />
		<cfset pluginConfig.setProviderURL(rs.providerURL) />
		<cfset pluginConfig.setPluginID(rs.pluginID) />
		<cfset pluginConfig.setloadPriority(rs.loadPriority) />
		<cfset pluginConfig.setModuleID(rs.moduleID) />
		<cfset pluginConfig.setDeployed(rs.deployed) />
		<cfset pluginConfig.setCategory(rs.category) />
		<cfset pluginConfig.setCreated(rs.created) />
		<cfset pluginConfig.setPackage(rs.package) />
		<cfset pluginConfig.setDirectory(rs.directory) />

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select * from tpluginsettings where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.moduleID#">
		</cfquery>

		<cfloop query="rs">
			<cfset settingStr["#rs.name#"]=rs.settingValue />
		</cfloop>

		<cfset pluginConfig.initSettings(settingStr)/>
		<cfset variables.pluginConfigs["p#pluginID#"]=pluginConfig>
	</cfif>

	<cfset request.muraMostRecentPluginModuleID=variables.pluginConfigs["p#pluginID#"].getModuleID()>

	<cfreturn variables.pluginConfigs["p#pluginID#"]/>
</cffunction>

<cffunction name="getAssignedSites" output="false">
<cfargument name="moduleID">
	<cfset var rsAssignedSites=""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsAssignedSites')#">
	select siteID,moduleID from tcontent where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
	<cfreturn rsAssignedSites>
</cffunction>

<cffunction name="deleteAssignedSites" output="false">
<cfargument name="moduleID">
	<cfquery>
	delete from tcontent where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="updateSettings" output="false">
<cfargument name="args">

	<cfset var pluginXML=getPluginXML(arguments.args.moduleID) />
	<cfset var settingsLen=0/>
	<cfset var i=1 />
	<cfset var pluginConfig="" />
	<cfset var pluginCFC= ""/>
	<cfset var adminDir="">
	<cfset var siteDir="">() >
	<cfset var distroList="" />
	<cfset var dopID=""/>
	<cfset var rsObjects="">
	<cfset var directory="">
	<cfset var rsCheck="">

	<cfif len(arguments.args.package)>
		<cfquery name="rsCheck">
				select moduleID from tplugins
				where package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.package#"/>
				and moduleID<><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#"/>
		</cfquery>

		<cfif rsCheck.recordcount>
				<cfthrow message="A plugin with the package value '#arguments.args.package#' is already being used by another plugin.">
		</cfif>
	</cfif>

	<cfset deleteSettings(arguments.args.moduleID) />

	<cfif isDefined("pluginXML.plugin.settings.xmlChildren") and isArray(pluginXML.plugin.settings.xmlChildren)>
		<cfset settingsLen=arraylen(pluginXML.plugin.settings.xmlChildren)/>
	<cfelse>
		<cfset settingsLen=0>
	</cfif>

	<cfif len(settingsLen)>
		<cfloop from="1" to="#settingsLen#" index="i">
			<cfif structKeyExists(pluginXML.plugin.settings.setting[i],'name')>
				<cfset local.settingName=pluginXML.plugin.settings.setting[i].name.xmlText>
				<cfset local.settingValue=arguments.args['#pluginXML.plugin.settings.setting[i].name.xmlText#']>
			<cfelseif structKeyExists(pluginXML.plugin.settings.setting[i].xmlAttributes,'name')>
				<cfset local.settingName=pluginXML.plugin.settings.setting[i].xmlAttributes.name>
				<cfset local.settingValue=arguments.args['#pluginXML.plugin.settings.setting[i].xmlAttributes.name#']>
			</cfif>
			<cfquery>
			insert into tpluginsettings (moduleID,name,settingValue) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.settingName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.settingValue#">
			)
			</cfquery>
		</cfloop>
	</cfif>

	<cfset deleteScripts(arguments.args.moduleID) />

	<cfset savePluginXML(arguments.args.moduleID) />
	<cfset pluginConfig=getConfig(arguments.args.moduleID,'',false) />


	<!--- save the submitted name --->
	<cfquery>
	update tplugins set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.pluginalias#">,
	loadPriority=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.args.loadPriority#">,
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
		<cfset directory=arguments.args.package>
	<cfelse>
		<cfset directory=pluginConfig.getPluginID()>
	</cfif>

	<cfif directory neq pluginConfig.getDirectory()>

		<cfset i=0>
		<cfloop condition="directoryExists('#variables.configBean.getPluginDir()#/#directory#')">
			<cfset i=i+1>
			<cfset directory=directory & i>
		</cfloop>

		<cfset variables.fileWriter.renameDir(directory = "#variables.configBean.getPluginDir()#/#pluginConfig.getDirectory()#", newDirectory = "#directory#")>

		<cfquery>
		update tplugins set directory=<cfqueryparam cfsqltype="cf_sql_varchar" value="#directory#">
		,package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.package#">
		where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
		</cfquery>

		<cfset pluginConfig=getConfig(arguments.args.moduleID,'',false) />
	</cfif>

	<cfset createAppCFCIncludes()/>

	<cfset deleteAssignedSites(arguments.args.moduleID) />

	<cfif structKeyExists(arguments.args,"siteAssignID") and len(arguments.args.siteAssignID)>

		<cfloop list="#arguments.args.siteAssignID#" index="i">

			<cfset variables.configBean.getClassExtensionManager().loadConfigXML(pluginXML,i)>

			<cfquery>
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


	<cfquery>
	update tplugindisplayobjects
	set location='global'
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
	</cfquery>

	<cfset loadPlugins() />

	<cfif not isDefined("arguments.args.autoDeploy") or arguments.args.autoDeploy>
		<cfset pluginConfig=getConfig(arguments.args.moduleID,'',false) />

		<!--- check to see is the plugin.cfc exists --->
		<cfif fileExists(variables.configBean.getPluginDir() & "/" & pluginConfig.getDirectory() & "/plugin/plugin.cfc")>
			<cfset pluginCFC= createObject("component","plugins.#pluginConfig.getDirectory()#.plugin.plugin") />

			<!--- only call the methods if they have been defined --->
			<cfif structKeyExists(pluginCFC,"init")>
				<cfset pluginCFC.init(pluginConfig,variables.configBean)>
			</cfif>

			<cfif pluginConfig.getDeployed()>
				<cfif structKeyExists(pluginCFC,"update")>
					<cfset pluginCFC.update() />
				</cfif>
			<cfelse>
				<cfif structKeyExists(pluginCFC,"install")>
					<cfset pluginCFC.install() />
				</cfif>
			</cfif>
		</cfif>

		<cfquery>
		update tplugins
		set deployed=1
		where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
		</cfquery>
		<cfset application.appInitialized=false>
		<cfset getBean('clusterManager').reload() />
		<cfset loadPlugins() />
	</cfif>
</cffunction>

<cffunction name="deleteSettings" output="false">
<cfargument name="moduleID">
	<cfquery>
	delete from tpluginsettings where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="deleteScripts" output="false">
<cfargument name="moduleID">
	<cfquery>
	delete from tpluginscripts where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="deleteDisplayObjects" output="false">
<cfargument name="moduleID">
	<cfquery>
	delete from tcontentobjects where
	objectID in (select objectID from tplugindisplayobjects where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">)
	</cfquery>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugindisplayobjects where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="getSitePlugins" output="false">
<cfargument name="siteID">
<cfargument name="orderby" default="name" required="true">
<cfargument name="applyPermFilter" default="false" required="true">
	<cfset var rs="">
	<cfset var moduleList="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select tplugins.pluginID,tplugins.moduleID, tplugins.package, tplugins.directory, tplugins.name,tplugins.version,
	tplugins.provider, tplugins.providerURL,tplugins.category,tplugins.created from tplugins inner join tcontent
	on (tplugins.moduleID=tcontent.moduleID and tcontent.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
	order by tplugins.#arguments.orderby#
	</cfquery>

	<cfif arguments.applyPermFilter>
		<cfset var sessionData=getSession()>
		<cfloop query="rs">
			<cfif application.permUtility.getModulePerm(rs.moduleID,sessionData.siteid)>
				<cfset moduleList=listAppend(moduleList,rs.moduleID)>
			</cfif>
		</cfloop>
		<cfquery dbtype="query" name="rs">
			select * from rs where
			<cfif len(moduleList)>
			moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#moduleList#">)
			<cfelse>
			0=1
			</cfif>
		</cfquery>
	</cfif>

	<cfreturn rs>
</cffunction>

<cffunction name="getSitePluginGroups" returntype="struct" output="false">
<cfargument name="rsplugins" type="query">

	<cfset var str=StructNew()>
	<cfset var rs="">
	<cfset var rssub="">

	<cfset str['Application'] = querynew('null') />
	<cfset str['Utility'] = querynew('null') />

	<cfquery name="rs" dbtype="query">
		select distinct category
		from arguments.rsplugins
	</cfquery>

	<cfloop query="rs">
		<cfif not StructKeyExists(str,rs.category)>
			<cfset str[rs.category] = structNew() />
		</cfif>
		<cfquery name="rssub" dbtype="query">
			select *
			from arguments.rsplugins
			where category = '#rs.category#'
		</cfquery>

		<cfif rssub.recordcount>
			<cfset str[rs.category] = rssub />
		<cfelse>
			<cfset str[rs.category] = querynew('null') />
		</cfif>
	</cfloop>

	<cfreturn str>
</cffunction>

<cffunction name="deletePlugin" output="false">
<cfargument name="moduleID">

	<cfset var rsPlugin=getPlugin(arguments.moduleID) />
	<cfset var location=getLocation(rsPlugin.directory) />
	<cfset var pluginConfig=getConfig(arguments.moduleID) />
	<cfset var pluginCFC="/">

	<!--- check to see is the plugin.cfc exists --->
	<cfif fileExists(variables.configBean.getPluginDir() & "/" & pluginConfig.getDirectory() & "/plugin/plugin.cfc")>
		<cfset pluginCFC=createObject("component","plugins.#pluginConfig.getDirectory()#.plugin.plugin") />

		<!--- only call the methods if they have been defined --->
		<cfif structKeyExists(pluginCFC,"init")>
			<cfset pluginCFC.init(pluginConfig,variables.configBean)>
		</cfif>

		<cfif structKeyExists(pluginCFC,"delete")>
			<cfset pluginCFC.delete() />
		</cfif>
	</cfif>

	<cfif len(rsPlugin.directory) and directoryExists(location)>
		<cfdirectory action="delete" directory="#location#" recurse="true">
	</cfif>

	<cfset createAppCFCIncludes() />

	<cfset deleteSettings(arguments.moduleID)>
	<cfset deleteAssignedSites(arguments.moduleID)>
	<cfset deleteScripts(arguments.moduleID)>
	<cfset deleteDisplayObjects(arguments.moduleID)>

	<cfquery>
	delete from tplugins where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>

	<cfset application.appInitialized=false>
	<cfset loadPlugins() />
	<!---<cfset createLookupTXT()/>--->

</cffunction>

<cffunction name="announceEvent" output="false">
<cfargument name="eventToAnnounce" required="true" default="" type="any">
<cfargument name="currentEventObject" required="true" default="" type="any">
<cfargument name="rsHandlers" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
<cfargument name="index" required="true" default="0" type="any">
<cfargument name="objectid" required="true" default="" type="any">
	<cfset var siteID="">
	<!--- Don't fire unless pluginManager has been initted--->
	<cfif isDefined('variables.utility')>
		<cfif variables.utility.checkForInstanceOf(arguments.currentEventObject,"mura.MuraScope")>
			<cfset siteID=arguments.currentEventObject.event('siteID')>
		<cfelse>
			<cfset siteID=arguments.currentEventObject.getValue('siteID')>
		</cfif>
		<cfif arguments.index>
			<cfset executeScript(runat=arguments.eventToAnnounce,siteid=siteid,event=arguments.currentEventObject,index=arguments.index,objectid=arguments.objectid)>
		<cfelse>
			<cfset executeScripts(runat=arguments.eventToAnnounce,siteid=siteid,event=arguments.currentEventObject,rsHandlers=arguments.rsHandlers,moduleID=arguments.moduleID,objectid=arguments.objectid)>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="renderEvent" output="false">
<cfargument name="eventToRender" required="true" default="" type="any">
<cfargument name="currentEventObject" required="true" default="" type="any">
<cfargument name="rsHandlers" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
<cfargument name="index" required="true" default="0" type="any">
<cfargument name="objectid" required="true" default="" type="any">
	<cfif isDefined('variables.utility')>
		<cfset var siteID="">
		<cfif variables.utility.checkForInstanceOf(arguments.currentEventObject,"mura.MuraScope")>
			<cfset siteID=arguments.currentEventObject.event('siteID')>
		<cfelse>
			<cfset siteID=arguments.currentEventObject.getValue('siteID')>
		</cfif>
		<cfif arguments.index>
			<cfreturn renderScript(runat=arguments.eventToRender,siteid=siteid,event=arguments.currentEventObject,index=arguments.index,objectid=arguments.objectid)>
		<cfelse>
			<cfreturn renderScripts(runat=arguments.eventToRender,siteid=siteid,event=arguments.currentEventObject,rsHandlers=arguments.rsHandlers,moduleID=arguments.moduleID,objectid=arguments.objectid)>
		</cfif>
	<cfelse>
		<cfreturn "">
	</cfif>

</cffunction>

<cffunction name="getEventMappings" output="false">
<cfargument name="eventName">
<cfargument name="siteID" required="true" default="">

	<cfset var isGlobalEvent=findNoCase('global',arguments.eventName) or arguments.eventName eq "onApplicationLoad">
	<cfset var isValidEvent=false>
	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var listenerArray=[]>

	<cfset arguments.eventName=REReplace(arguments.eventName, "[^a-zA-Z0-9_]", "", "ALL")>

	<cfset isValidEvent=variables.utility.isValidCFVariableName(arguments.eventName)>

	<cfif not left(arguments.eventName,2) eq "on" or left(arguments.eventName,7) eq "standard">
		<cfset arguments.eventName="on" & arguments.eventName>
	</cfif>

	<cfif isValidEvent>
		<cfif not isGlobalEvent and len(arguments.siteID)>
			<cfif isDefined("variables.siteListeners.#siteIDadjusted#.#arguments.eventName#")>
				<cfset listenerArray=variables.siteListeners[siteIDadjusted]>
				<cfset listenerArray=listenerArray[arguments.eventName]>
			</cfif>
		<cfelseif isGlobalEvent>
			<cfif isDefined("variables.globalListeners.#arguments.eventName#")>
				<cfset listenerArray=variables.globalListeners[arguments.eventName]>
			</cfif>
		</cfif>
	</cfif>

	<cfreturn listenerArray>

</cffunction>

<cffunction name="executeScript" output="false">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="index" required="true" default="1" type="any">
<cfargument name="objectid" required="true" default="" type="any">

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
	<cfset var isGlobalEvent=findNoCase('global',arguments.runat) or arguments.runat eq "onApplicationLoad">
	<cfset var isValidEvent=false>
	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var muraScope="">
	<cfset var currentModuleID="">
	<cfset var tracePoint=0>
	<cfset var scriptIndex=0>

	<cfset arguments.runat=REReplace(arguments.runat, "[^a-zA-Z0-9_]", "", "ALL")>

	<cfset isValidEvent=variables.utility.isValidCFVariableName(arguments.runat)>

	<cfif not left(arguments.runat,2) eq "on" or left(arguments.runat,7) eq "standard">
		<cfset arguments.runat="on" & arguments.runat>
	</cfif>

	<cfif isValidEvent>

		<cftry>
			<cfif not isObject(arguments.event)>
				<cfif isStruct(arguments.event)>
					<cfset arguments.event=createObject("component","mura.event").init(arguments.event)/>
				<cfelse>
					<cfif structKeyExists(request,"servletEvent")>
						<cfset arguments.event=request.servletEvent />
					<cfelse>
						<cfset arguments.event=createObject("component","mura.event").init()/>
					</cfif>
				</cfif>
			</cfif>

			<cfif variables.utility.checkForInstanceOf(arguments.event,"mura.MuraScope")>
				<cfset muraScope=arguments.event>
				<cfset arguments.event=arguments.event.event()>
			<cfelse>
				<cfset muraScope=arguments.event.getValue("muraScope")>
			</cfif>

			<cfif not isGlobalEvent and len(arguments.siteID)>
				<cfif len(arguments.objectid)
						and isDefined('variables.siteListeners.#siteIDadjusted#.objects')
						and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects,'#arguments.objectid#')
						and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'],arguments.runat)>

						<cfset listenerArray=variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'][arguments.runat]>

						<cfif arrayLen(listenerArray)>
							<cfset eventHandlerIndex=listenerArray[argument.index].index>
							<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
							<cfif isNumeric(eventHandler)>
								<cfset scriptIndex=eventHandler>
								<cfset event.setValue("siteid",arguments.siteID)>
								<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
								<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
									<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
									<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
									<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
									<cfinvoke component="#eventHandler#" method="#arguments.runat#">
										<cfinvokeargument name="event" value="#arguments.event#">
										<cfinvokeargument name="$" value="#muraScope#">
										<cfinvokeargument name="mura" value="#muraScope#">
										<cfinvokeargument name="m" value="#muraScope#">
									</cfinvoke>
									<cfset commitTracePoint(tracePoint)>
								<cfelse>
									<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
								</cfif>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							<cfelse>
								<cfif not isObject(eventHandler)>
									<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
								</cfif>
								<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							</cfif>
						</cfif>
				</cfif>
				<cfif isDefined("variables.siteListeners.#siteIDadjusted#.#arguments.runat#")>
					<cfset listenerArray=variables.siteListeners[siteIDadjusted]>
					<cfset listenerArray=listenerArray[arguments.runat]>
					<cfif arrayLen(listenerArray)>
						<cfset eventHandlerIndex=listenerArray[argument.index].index>
						<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
						<cfif isNumeric(eventHandler)>
							<cfset scriptIndex=eventHandler>
							<cfset event.setValue("siteid",arguments.siteID)>
							<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
							<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
								<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
								<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
								<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
							<cfelse>
								<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
							</cfif>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						<cfelse>
							<cfif not isObject(eventHandler)>
								<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
							</cfif>
							<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
							<cfinvoke component="#eventHandler#" method="#arguments.runat#">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			<cfif len(arguments.objectid)
					and isDefined('variables.globalListeners.objects')
					and structKeyExists(variables.globalListeners.objects,'#arguments.objectid#')
					and structKeyExists(variables.globalListeners.objects['#arguments.objectid#'],arguments.runat)>

				<cfset listenerArray=variables.globalListeners.objects['#arguments.objectid#'][arguments.runat]>

					<cfif arrayLen(listenerArray)>
						<cfset eventHandlerIndex=listenerArray[arguments.index].index>
						<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
						<cfif isNumeric(eventHandler)>
							<cfset scriptIndex=eventHandler>
							<cfset event.setValue("siteid",arguments.siteID)>
							<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
							<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
								<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
								<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
								<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
							<cfelse>
								<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
							</cfif>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						<cfelse>
							<cfif not isObject(eventHandler)>
								<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
							</cfif>
							<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
							<cfinvoke component="#eventHandler#" method="#arguments.runat#">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						</cfif>
					</cfif>
			</cfif>
			<cfif isDefined("variables.globalListeners.#arguments.runat#")>
				<cfset listenerArray=variables.globalListeners[arguments.runat]>
				<cfif arrayLen(listenerArray)>
					<cfset eventHandlerIndex=listenerArray[arguments.index].index>
					<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
					<cfif isNumeric(eventHandler)>
						<cfset scriptIndex=eventHandler>
						<cfset event.setValue("siteid",arguments.siteID)>
						<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
						<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
							<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
							<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
							<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
							<cfinvoke component="#eventHandler#" method="#arguments.runat#">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							<cfset commitTracePoint(tracePoint)>
						<cfelse>
							<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
						</cfif>
						<cfset request.muraHandledEvents["#arguments.runat#"]=true>
					<cfelse>
						<cfif not isObject(eventHandler)>
							<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
						</cfif>
						<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
						<cfinvoke component="#eventHandler#" method="#arguments.runat#">
							<cfinvokeargument name="event" value="#arguments.event#">
							<cfinvokeargument name="$" value="#muraScope#">
							<cfinvokeargument name="mura" value="#muraScope#">
							<cfinvokeargument name="m" value="#muraScope#">
						</cfinvoke>
						<cfset commitTracePoint(tracePoint)>
						<cfset request.muraHandledEvents["#arguments.runat#"]=true>
					</cfif>
				</cfif>
			</cfif>

			<cfcatch>
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cfif>

</cffunction>

<cffunction name="executeScripts" output="false">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scripts" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
<cfargument name="objectid" required="true" default="" type="any">
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
	<cfset var isGlobalEvent=findNoCase('global',arguments.runat) or arguments.runat eq "onApplicationLoad">
	<cfset var isValidEvent=false>
	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var muraScope="">
	<cfset var currentModuleID="">
	<cfset var tracePoint=0>
	<cfset var scriptIndex=0>

	<cfset arguments.runat=REReplace(arguments.runat, "[^a-zA-Z0-9_]", "", "ALL")>

	<cfset isValidEvent=arguments.runat eq "onApplicationLoad" or variables.utility.isValidCFVariableName(arguments.runat)>

	<cfif not left(arguments.runat,2) eq "on" or left(arguments.runat,7) eq "standard">
		<cfset arguments.runat="on" & arguments.runat>
	</cfif>

	<cfif isValidEvent>

	<cftry>

		<cfif not isObject(arguments.event)>
			<cfif isStruct(arguments.event)>
				<cfset arguments.event=createObject("component","mura.event").init(arguments.event)/>
			<cfelse>
				<cfif structKeyExists(request,"servletEvent")>
					<cfset arguments.event=request.servletEvent />
				<cfelse>
					<cfset arguments.event=createObject("component","mura.event").init()/>
				</cfif>
			</cfif>
		</cfif>

		<cfif variables.utility.checkForInstanceOf(arguments.event,"mura.MuraScope")>
			<cfset muraScope=arguments.event>
			<cfset arguments.event=arguments.event.event()>
		<cfelse>
			<cfset muraScope=arguments.event.getValue("muraScope")>
		</cfif>

		<cfif not isQuery(arguments.scripts) and not len(arguments.moduleID)>
			<cfif isObject(arguments.event.getValue("localHandler"))>
				<cfset localHandler=arguments.event.getValue("localHandler")>
				<cfif structKeyExists(localHandler,arguments.runat)>
					<cfset tracePoint=initTracePoint("#localHandler.getValue('_objectName')#.#arguments.runat#")>
					<cfinvoke component="#localHandler#" method="#arguments.runat#">
						<cfinvokeargument name="event" value="#arguments.event#">
						<cfinvokeargument name="$" value="#muraScope#">
						<cfinvokeargument name="mura" value="#muraScope#">
						<cfinvokeargument name="m" value="#muraScope#">
					</cfinvoke>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				</cfif>
			</cfif>

			<cfif not isGlobalEvent and len(arguments.siteID)>
				<!--- Look for object bound events --->
				<cfif len(arguments.objectid)
						and isDefined('variables.siteListeners.#siteIDadjusted#.objects')
						and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects,'#arguments.objectid#')
						and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'],arguments.runat)>

					<cfset listenerArray=variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'][arguments.runat]>

					<cfif arrayLen(listenerArray)>
						<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
							<cfset eventHandlerIndex=listenerArray[i].index>
							<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
							<cfif isNumeric(eventHandler)>
								<cfset scriptIndex=eventHandler>
								<cfset event.setValue("siteid",arguments.siteID)>
								<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
								<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
									<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
									<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
									<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
									<cfinvoke component="#eventHandler#" method="#arguments.runat#">
										<cfinvokeargument name="event" value="#arguments.event#">
										<cfinvokeargument name="$" value="#muraScope#">
										<cfinvokeargument name="mura" value="#muraScope#">
										<cfinvokeargument name="m" value="#muraScope#">
									</cfinvoke>
									<cfset commitTracePoint(tracePoint)>
								<cfelse>
									<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
								</cfif>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							<cfelse>
								<cfif not isObject(eventHandler)>
									<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
								</cfif>
								<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				<!--- Look for non object bound events --->
				<cfif isDefined("variables.siteListeners.#siteIDadjusted#.#arguments.runat#")>

					<cfset listenerArray=variables.siteListeners[siteIDadjusted]>
					<cfset listenerArray=listenerArray[arguments.runat]>

					<cfif arrayLen(listenerArray)>
						<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
							<cfset eventHandlerIndex=listenerArray[i].index>
							<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
							<cfif isNumeric(eventHandler)>
								<cfset scriptIndex=eventHandler>
								<cfset event.setValue("siteid",arguments.siteID)>
								<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
								<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
									<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
									<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
									<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
									<cfinvoke component="#eventHandler#" method="#arguments.runat#">
										<cfinvokeargument name="event" value="#arguments.event#">
										<cfinvokeargument name="$" value="#muraScope#">
										<cfinvokeargument name="mura" value="#muraScope#">
										<cfinvokeargument name="m" value="#muraScope#">
									</cfinvoke>
									<cfset commitTracePoint(tracePoint)>
								<cfelse>
									<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
								</cfif>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							<cfelse>
								<cfif not isObject(eventHandler)>
									<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
								</cfif>
								<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>

			<cfif len(arguments.objectid)
					and isDefined('variables.globalListeners.objects')
					and structKeyExists(variables.globalListeners.objects,'#arguments.objectid#')
					and structKeyExists(variables.globalListeners.objects['#arguments.objectid#'],arguments.runat)>

				<cfset listenerArray=variables.globalListeners.objects['#arguments.objectid#'][arguments.runat]>

				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandlerIndex=listenerArray[i].index>
						<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
						<cfif isNumeric(eventHandler)>
							<cfset scriptIndex=eventHandler>
							<cfset event.setValue("siteid",arguments.siteID)>
							<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
							<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
								<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
								<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
								<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
							<cfelse>
								<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
							</cfif>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						<cfelse>
							<cfif not isObject(eventHandler)>
								<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
							</cfif>
							<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
							<cfinvoke component="#eventHandler#" method="#arguments.runat#">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>

			<cfif isDefined("variables.globalListeners.#arguments.runat#")>
				<cfset listenerArray=variables.globalListeners[arguments.runat]>
				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandlerIndex=listenerArray[i].index>
						<cfset eventHandler=variables.eventHandlers[eventHandlerIndex]>
						<cfif isNumeric(eventHandler)>
							<cfset scriptIndex=eventHandler>
							<cfset event.setValue("siteid",arguments.siteID)>
							<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
							<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
								<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
								<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
								<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
								<cfinvoke component="#eventHandler#" method="#arguments.runat#">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								<cfset commitTracePoint(tracePoint)>
							<cfelse>
								<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)>
							</cfif>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						<cfelse>
							<cfif not isObject(eventHandler)>
								<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
							</cfif>
							<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
							<cfinvoke component="#eventHandler#" method="#arguments.runat#">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>

		<cfif isQuery(arguments.scripts) or len(arguments.moduleID)>
			<cfif isQuery(arguments.scripts)>
				<cfset rs=arguments.scripts />
			<cfelse>
				<cfset rs=getScripts(arguments.runat,arguments.siteid,arguments.moduleID) />
			</cfif>

			<cfloop query="rs">
				<cfset event.setValue("siteid",arguments.siteID)>
				<cfset currentModuleID=rs.moduleID>
				<cfif listLast(rs.scriptfile,".") neq "cfm">
					<cfset componentPath="plugins.#rs.directory#.#rs.scriptfile#">
					<cfset eventHandler=getComponent(componentPath, rs.pluginID, arguments.siteID, rs.docache)>
					<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
					<cfinvoke component="#eventHandler#" method="#arguments.runat#">
						<cfinvokeargument name="event" value="#arguments.event#">
						<cfinvokeargument name="$" value="#muraScope#">
						<cfinvokeargument name="mura" value="#muraScope#">
						<cfinvokeargument name="m" value="#muraScope#">
					</cfinvoke>
					<cfset commitTracePoint(tracePoint)>
				<cfelse>
					<cfset getExecutor().executeScript(event=event,scriptfile="/plugins/#rs.directory#/#rs.scriptfile#",pluginConfig=getConfig(rs.pluginID), $=muraScope, mura=muraScope)>
				</cfif>
				<cfset request.muraHandledEvents["#arguments.runat#"]=true>
			</cfloop>
		</cfif>

		<cfcatch>
				<cfif len(currentModuleID)>
					<cfset rsOnError=getScripts("onError",arguments.siteid,currentModuleID) />
					<cfif arguments.runat neq "onError" and rsOnError.recordcount>
						<cfset arguments.event.setValue("errorType","event")>
						<cfset arguments.event.setValue("errorEvent",arguments.runat)>
						<cfset arguments.event.setValue("error",cfcatch)>
						<cfset arguments.event.setValue("exception",cfcatch)>
						<cfset executeScripts("onError",arguments.siteid,arguments.event,rsOnError)>
						<cfif not yesNoFormat(arguments.event.getValue("errorIsHandled"))>
							<cfrethrow>
						</cfif>
					<cfelse>
						<cfrethrow>
					</cfif>
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>
	</cfif>

</cffunction>

<cffunction name="renderScript" output="false">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="index" required="true" default="1" type="any">
	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var testStr=""/>
	<cfset var pluginConfig="">
	<cfset var componentPath="">
	<cfset var scriptPath="">
	<cfset var local=structNew()>
	<cfset var rsOnError="">
	<!--- this is for non plugin bound event that are set in the local eventHandler--->
	<cfset var localHandler="">
	<cfset var i="">
	<cfset var eventHandler="">
	<cfset var listenerArray="">
	<cfset var isGlobalEvent=findNoCase('global',arguments.runat) or arguments.runat eq "onApplicationLoad">
	<cfset var isValidEvent=false>
	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var muraScope="">
	<cfset var currentModuleID="">
	<cfset var tracePoint=0>
	<cfset var scriptIndex=0>
	<cfset var listenerStruct={}>

	<cfset arguments.runat=REReplace(arguments.runat, "[^a-zA-Z0-9_]", "", "ALL")>

	<cfset isValidEvent=variables.utility.isValidCFVariableName(arguments.runat)>

	<cfif not left(arguments.runat,2) eq "on" or left(arguments.runat,7) eq "standard">
		<cfset arguments.runat="on" & arguments.runat>
	</cfif>

	<cfif not isObject(arguments.event)>
		<cfif isStruct(arguments.event)>
			<cfset arguments.event=createObject("component","mura.event").init(arguments.event)/>
		<cfelse>
			<cfif structKeyExists(request,"servletEvent")>
				<cfset arguments.event=request.servletEvent />
			<cfelse>
				<cfset arguments.event=createObject("component","mura.event").init()/>
			</cfif>
		</cfif>
	</cfif>

	<cfif variables.utility.checkForInstanceOf(arguments.event,"mura.MuraScope")>
		<cfset muraScope=arguments.event>
		<cfset arguments.event=arguments.event.event()>
	<cfelse>
		<cfset muraScope=arguments.event.getValue("muraScope")>
	</cfif>

	<cfif isValidEvent>
		<cftry>
		<cfif not isGlobalEvent and len(arguments.siteID)>

			<cfif isObject(arguments.event.getValue("localHandler"))>
				<cfset localHandler=arguments.event.getValue("localHandler")>
				<cfif structKeyExists(localHandler,arguments.runat)>
					<cfset tracePoint=initTracePoint("#localHandler.getValue('_objectName')#.#arguments.runat#")>
					<cfsavecontent variable="local.theDisplay1">
						<cfinvoke component="#localHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
							<cfinvokeargument name="event" value="#arguments.event#">
							<cfinvokeargument name="$" value="#muraScope#">
							<cfinvokeargument name="mura" value="#muraScope#">
							<cfinvokeargument name="m" value="#muraScope#">
						</cfinvoke>
					</cfsavecontent>

					<cfif isDefined("local.theDisplay2")>
						<cfset str=str & local.theDisplay2>
					<cfelse>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				</cfif>
			</cfif>

			<cfif len(arguments.objectid)
					and isDefined('variables.siteListeners.#siteIDadjusted#.objects')
					and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects,'#arguments.objectid#')
					and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'],arguments.runat)>

					<cfset listenerArray=variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'][arguments.runat]>

					<cfif arrayLen(listenerArray)>

									<cfset eventHandler=variables.eventHandlers[listenerArray[arguments.index].index]>
									<cfif isNumeric(eventHandler)>
										<cfset scriptIndex=eventHandler>
										<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
										<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
											<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
											<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
											<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
											<cfsavecontent variable="local.theDisplay1">
												<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
													<cfinvokeargument name="event" value="#arguments.event#">
													<cfinvokeargument name="$" value="#muraScope#">
													<cfinvokeargument name="mura" value="#muraScope#">
													<cfinvokeargument name="m" value="#muraScope#">
												</cfinvoke>
											</cfsavecontent>

											<cfif isDefined("local.theDisplay2")>
												<cfset str=str & local.theDisplay2>
											<cfelse>
												<cfset str=str & local.theDisplay1>
											</cfif>

										<cfelse>
											<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
											<cfsavecontent variable="local.theDisplay1">
												<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
											</cfsavecontent>
											<cfset str=str & local.theDisplay1>
										</cfif>
										<cfset commitTracePoint(tracePoint)>
										<cfset request.muraHandledEvents["#arguments.runat#"]=true>
									<cfelse>
										<cfif not isObject(eventHandler)>
											<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
										</cfif>
										<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
										<cfsavecontent variable="local.theDisplay1">
										<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
											<cfinvokeargument name="event" value="#arguments.event#">
											<cfinvokeargument name="$" value="#muraScope#">
											<cfinvokeargument name="mura" value="#muraScope#">
											<cfinvokeargument name="m" value="#muraScope#">
										</cfinvoke>
										</cfsavecontent>
										<cfif isDefined("local.theDisplay2")>
											<cfset str=str & local.theDisplay2>
										<cfelse>
											<cfset str=str & local.theDisplay1>
										</cfif>
										<cfset commitTracePoint(tracePoint)>
										<cfset request.muraHandledEvents["#arguments.runat#"]=true>
									</cfif>

					</cfif>
			</cfif>
			<cfif arguments.index and isDefined("variables.siteListeners.#siteIDadjusted#.#arguments.runat#")>

					<cfset listenerStruct = variables.siteListeners[siteIDadjusted] />
					<cfset listenerArray=listenerStruct[arguments.runat] />

					<cfif arrayLen(listenerArray) and arrayLen(listenerArray) gte arguments.index>

									<cfset eventHandler=variables.eventHandlers[listenerArray[arguments.index].index]>
									<cfif isNumeric(eventHandler)>
										<cfset scriptIndex=eventHandler>
										<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
										<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
											<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
											<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
											<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
											<cfsavecontent variable="local.theDisplay1">
												<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
													<cfinvokeargument name="event" value="#arguments.event#">
													<cfinvokeargument name="$" value="#muraScope#">
													<cfinvokeargument name="mura" value="#muraScope#">
													<cfinvokeargument name="m" value="#muraScope#">
												</cfinvoke>
											</cfsavecontent>

											<cfif isDefined("local.theDisplay2")>
												<cfset str=str & local.theDisplay2>
											<cfelse>
												<cfset str=str & local.theDisplay1>
											</cfif>

										<cfelse>
											<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
											<cfsavecontent variable="local.theDisplay1">
												<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
											</cfsavecontent>
											<cfset str=str & local.theDisplay1>
										</cfif>
										<cfset commitTracePoint(tracePoint)>
										<cfset request.muraHandledEvents["#arguments.runat#"]=true>
									<cfelse>
										<cfif not isObject(eventHandler)>
											<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
										</cfif>
										<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
										<cfsavecontent variable="local.theDisplay1">
										<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
											<cfinvokeargument name="event" value="#arguments.event#">
											<cfinvokeargument name="$" value="#muraScope#">
											<cfinvokeargument name="mura" value="#muraScope#">
											<cfinvokeargument name="m" value="#muraScope#">
										</cfinvoke>
										</cfsavecontent>
										<cfif isDefined("local.theDisplay2")>
											<cfset str=str & local.theDisplay2>
										<cfelse>
											<cfset str=str & local.theDisplay1>
										</cfif>
										<cfset commitTracePoint(tracePoint)>
										<cfset request.muraHandledEvents["#arguments.runat#"]=true>
									</cfif>

					</cfif>
				</cfif>
		</cfif>
		<cfif len(arguments.objectid)
				and isDefined('variables.globalListeners.objects')
				and structKeyExists(variables.globalListeners.objects,'#arguments.objectid#')
				and structKeyExists(variables.globalListeners.objects['#arguments.objectid#'],arguments.runat)>

			<cfset listenerArray=variables.globalListeners.objects['#arguments.objectid#'][arguments.runat]>
			<cfif arrayLen(listenerArray)>
				<cfset eventHandler=variables.eventHandlers[listenerArray[arguments.index].index]>
				<cfif isNumeric(eventHandler)>
					<cfset scriptIndex=eventHandler>
					<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
					<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
						<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
						<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
						<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
						<cfsavecontent variable="local.theDisplay1">
						<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
							<cfinvokeargument name="event" value="#arguments.event#">
							<cfinvokeargument name="$" value="#muraScope#">
							<cfinvokeargument name="mura" value="#muraScope#">
							<cfinvokeargument name="m" value="#muraScope#">
						</cfinvoke>
						</cfsavecontent>

						<cfif isDefined("local.theDisplay2")>
							<cfset str=str & local.theDisplay2>
						<cfelse>
							<cfset str=str & local.theDisplay1>
						</cfif>

					<cfelse>
						<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
						<cfsavecontent variable="local.theDisplay1">
						<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
						</cfsavecontent>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				<cfelse>
					<cfif not isObject(eventHandler)>
						<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
					</cfif>
					<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
					<cfsavecontent variable="local.theDisplay1">
					<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
						<cfinvokeargument name="event" value="#arguments.event#">
						<cfinvokeargument name="$" value="#muraScope#">
						<cfinvokeargument name="mura" value="#muraScope#">
						<cfinvokeargument name="m" value="#muraScope#">
					</cfinvoke>
					</cfsavecontent>
					<cfif isDefined("local.theDisplay2")>
						<cfset str=str & local.theDisplay2>
					<cfelse>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				</cfif>
			</cfif>
		</cfif>
		<cfif arguments.index and isDefined("variables.globalListeners.#arguments.runat#")>
			<cfset listenerArray=variables.globalListeners[arguments.runat]>
			<cfif arrayLen(listenerArray) and arrayLen(listenerArray) gte arguments.index>
				<cfset eventHandler=variables.eventHandlers[listenerArray[arguments.index].index]>
				<cfif isNumeric(eventHandler)>
					<cfset scriptIndex=eventHandler>
					<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
					<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
						<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
						<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
						<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
						<cfsavecontent variable="local.theDisplay1">
						<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
							<cfinvokeargument name="event" value="#arguments.event#">
							<cfinvokeargument name="$" value="#muraScope#">
							<cfinvokeargument name="mura" value="#muraScope#">
							<cfinvokeargument name="m" value="#muraScope#">
						</cfinvoke>
						</cfsavecontent>

						<cfif isDefined("local.theDisplay2")>
							<cfset str=str & local.theDisplay2>
						<cfelse>
							<cfset str=str & local.theDisplay1>
						</cfif>

					<cfelse>
						<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
						<cfsavecontent variable="local.theDisplay1">
						<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
						</cfsavecontent>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				<cfelse>
					<cfif not isObject(eventHandler)>
						<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
					</cfif>
					<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
					<cfsavecontent variable="local.theDisplay1">
					<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
						<cfinvokeargument name="event" value="#arguments.event#">
						<cfinvokeargument name="$" value="#muraScope#">
						<cfinvokeargument name="mura" value="#muraScope#">
						<cfinvokeargument name="m" value="#muraScope#">
					</cfinvoke>
					</cfsavecontent>
					<cfif isDefined("local.theDisplay2")>
						<cfset str=str & local.theDisplay2>
					<cfelse>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				</cfif>
			</cfif>
		</cfif>

		<cfcatch>
			<cfif yesNoFormat(variables.configBean.getValue("debuggingenabled"))>
				<cfset request.muraDynamicContentError=true>
                <cfset str=str & getBean('utility').formatError(cfcatch)>
			<cfelse>
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>

	</cfif>

	<cfreturn trim(str)>
</cffunction>

<cffunction name="renderScripts" output="false">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scripts" required="true" default="" type="any">
<cfargument name="moduleID" required="true" default="" type="any">
<cfargument name="objectid" required="true" default="" type="any">
	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var testStr=""/>
	<cfset var pluginConfig="">
	<cfset var componentPath="">
	<cfset var scriptPath="">
	<cfset var local=structNew()>
	<cfset var rsOnError="">
	<!--- this is for non plugin bound event that are set in the local eventHandler--->
	<cfset var localHandler="">
	<cfset var i="">
	<cfset var eventHandler="">
	<cfset var listenerArray="">
	<cfset var isGlobalEvent=findNoCase('global',arguments.runat) or arguments.runat eq "onApplicationLoad">
	<cfset var isValidEvent=false>
	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var muraScope="">
	<cfset var currentModuleID="">
	<cfset var tracePoint=0>
	<cfset var scriptIndex=0>

	<cfset arguments.runat=REReplace(arguments.runat, "[^a-zA-Z0-9_]", "", "ALL")>

	<cfset isValidEvent=variables.utility.isValidCFVariableName(arguments.runat)>

	<cfif not left(arguments.runat,2) eq "on" or left(arguments.runat,7) eq "standard">
		<cfset arguments.runat="on" & arguments.runat>
	</cfif>

	<cfif not isObject(arguments.event)>
		<cfif isStruct(arguments.event)>
			<cfset arguments.event=createObject("component","mura.event").init(arguments.event)/>
		<cfelse>
			<cfif structKeyExists(request,"servletEvent")>
				<cfset arguments.event=request.servletEvent />
			<cfelse>
				<cfset arguments.event=createObject("component","mura.event").init()/>
			</cfif>
		</cfif>
	</cfif>

	<cfif variables.utility.checkForInstanceOf(arguments.event,"mura.MuraScope")>
		<cfset muraScope=arguments.event>
		<cfset arguments.event=arguments.event.event()>
	<cfelse>
		<cfset muraScope=arguments.event.getValue("muraScope")>
	</cfif>

	<cfif isValidEvent>

	<cftry>
		<cfif not isQuery(arguments.scripts) and not len(arguments.moduleID)>
			<cfif isObject(arguments.event.getValue("localHandler"))>
				<cfset localHandler=arguments.event.getValue("localHandler")>
				<cfif structKeyExists(localHandler,arguments.runat)>
					<cfset tracePoint=initTracePoint("#localHandler.getValue('_objectName')#.#arguments.runat#")>
					<cfsavecontent variable="local.theDisplay1">
					<cfinvoke component="#localHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
						<cfinvokeargument name="event" value="#arguments.event#">
						<cfinvokeargument name="$" value="#muraScope#">
						<cfinvokeargument name="mura" value="#muraScope#">
						<cfinvokeargument name="m" value="#muraScope#">
					</cfinvoke>
					</cfsavecontent>
					<cfif isDefined("local.theDisplay2")>
						<cfset str=str & local.theDisplay2>
					<cfelse>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				</cfif>
			</cfif>

			<cfif not isGlobalEvent and len(arguments.siteID)>
				<cfif len(arguments.objectid)
						and isDefined('variables.siteListeners.#siteIDadjusted#.objects')
						and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects,'#arguments.objectid#')
						and structKeyExists(variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'],arguments.runat)>

						<cfset listenerArray=variables.siteListeners['#siteIDadjusted#'].objects['#arguments.objectid#'][arguments.runat]>

						<cfif arrayLen(listenerArray)>
							<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
								<cfset eventHandler=variables.eventHandlers[listenerArray[i].index]>
								<cfif isNumeric(eventHandler)>
									<cfset scriptIndex=eventHandler>
									<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
									<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
										<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
										<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
										<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
										<cfsavecontent variable="local.theDisplay1">
										<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
											<cfinvokeargument name="event" value="#arguments.event#">
											<cfinvokeargument name="$" value="#muraScope#">
											<cfinvokeargument name="mura" value="#muraScope#">
											<cfinvokeargument name="m" value="#muraScope#">
										</cfinvoke>
										</cfsavecontent>

										<cfif isDefined("local.theDisplay2")>
											<cfset str=str & local.theDisplay2>
										<cfelse>
											<cfset str=str & local.theDisplay1>
										</cfif>

									<cfelse>
										<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
										<cfsavecontent variable="local.theDisplay1">
										<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
										</cfsavecontent>
										<cfset str=str & local.theDisplay1>
									</cfif>
									<cfset commitTracePoint(tracePoint)>
									<cfset request.muraHandledEvents["#arguments.runat#"]=true>
								<cfelse>
									<cfif not isObject(eventHandler)>
										<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
									</cfif>
									<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
									<cfsavecontent variable="local.theDisplay1">
									<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
										<cfinvokeargument name="event" value="#arguments.event#">
										<cfinvokeargument name="$" value="#muraScope#">
										<cfinvokeargument name="mura" value="#muraScope#">
										<cfinvokeargument name="m" value="#muraScope#">
									</cfinvoke>
									</cfsavecontent>
									<cfif isDefined("local.theDisplay2")>
										<cfset str=str & local.theDisplay2>
									<cfelse>
										<cfset str=str & local.theDisplay1>
									</cfif>
									<cfset commitTracePoint(tracePoint)>
									<cfset request.muraHandledEvents["#arguments.runat#"]=true>
								</cfif>
							</cfloop>
						</cfif>
				</cfif>
				<cfif isDefined("variables.siteListeners.#siteIDadjusted#.#arguments.runat#")>
					<cfset listenerArray=variables.siteListeners[siteIDadjusted]>
					<cfset listenerArray=listenerArray[arguments.runat]>
					<cfif arrayLen(listenerArray)>
						<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
							<cfset eventHandler=variables.eventHandlers[listenerArray[i].index]>
							<cfif isNumeric(eventHandler)>
								<cfset scriptIndex=eventHandler>
								<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
								<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
									<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
									<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
									<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
									<cfsavecontent variable="local.theDisplay1">
									<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
										<cfinvokeargument name="event" value="#arguments.event#">
										<cfinvokeargument name="$" value="#muraScope#">
										<cfinvokeargument name="mura" value="#muraScope#">
										<cfinvokeargument name="m" value="#muraScope#">
									</cfinvoke>
									</cfsavecontent>

									<cfif isDefined("local.theDisplay2")>
										<cfset str=str & local.theDisplay2>
									<cfelse>
										<cfset str=str & local.theDisplay1>
									</cfif>

								<cfelse>
									<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
									<cfsavecontent variable="local.theDisplay1">
									<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
									</cfsavecontent>
									<cfset str=str & local.theDisplay1>
								</cfif>
								<cfset commitTracePoint(tracePoint)>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							<cfelse>
								<cfif not isObject(eventHandler)>
									<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
								</cfif>
								<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
								<cfsavecontent variable="local.theDisplay1">
								<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								</cfsavecontent>
								<cfif isDefined("local.theDisplay2")>
									<cfset str=str & local.theDisplay2>
								<cfelse>
									<cfset str=str & local.theDisplay1>
								</cfif>
								<cfset commitTracePoint(tracePoint)>
								<cfset request.muraHandledEvents["#arguments.runat#"]=true>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
			<cfif len(arguments.objectid)
					and isDefined('variables.globalListeners.objects')
					and structKeyExists(variables.globalListeners.objects,'#arguments.objectid#')
					and structKeyExists(variables.globalListeners.objects['#arguments.objectid#'],arguments.runat)>

				<cfset listenerArray=variables.globalListeners.objects['#arguments.objectid#'][arguments.runat]>

				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandler=variables.eventHandlers[listenerArray[i].index]>
						<cfif isNumeric(eventHandler)>
							<cfset scriptIndex=eventHandler>
							<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
							<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
								<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
								<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
								<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
								<cfsavecontent variable="local.theDisplay1">
								<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								</cfsavecontent>

								<cfif isDefined("local.theDisplay2")>
									<cfset str=str & local.theDisplay2>
								<cfelse>
									<cfset str=str & local.theDisplay1>
								</cfif>

							<cfelse>
								<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
								<cfsavecontent variable="local.theDisplay1">
								<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
								</cfsavecontent>
								<cfset str=str & local.theDisplay1>
							</cfif>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						<cfelse>
							<cfif not isObject(eventHandler)>
								<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
							</cfif>
							<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
							<cfsavecontent variable="local.theDisplay1">
							<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							</cfsavecontent>
							<cfif isDefined("local.theDisplay2")>
								<cfset str=str & local.theDisplay2>
							<cfelse>
								<cfset str=str & local.theDisplay1>
							</cfif>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfif isDefined("variables.globalListeners.#arguments.runat#")>
				<cfset listenerArray=variables.globalListeners[arguments.runat]>
				<cfif arrayLen(listenerArray)>
					<cfloop from="1" to="#arrayLen(listenerArray)#" index="i">
						<cfset eventHandler=variables.eventHandlers[listenerArray[i].index]>
						<cfif isNumeric(eventHandler)>
							<cfset scriptIndex=eventHandler>
							<cfset currentModuleID=variables.rsScripts.moduleID[scriptIndex]>
							<cfif listLast(variables.rsScripts.scriptfile[scriptIndex],".") neq "cfm">
								<cfset componentPath="plugins.#variables.rsScripts.directory[scriptIndex]#.#variables.rsScripts.scriptfile[scriptIndex]#">
								<cfset eventHandler=getComponent(componentPath, variables.rsScripts.pluginID[scriptIndex], arguments.siteID, variables.rsScripts.docache[scriptIndex])>
								<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
								<cfsavecontent variable="local.theDisplay1">
								<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
									<cfinvokeargument name="event" value="#arguments.event#">
									<cfinvokeargument name="$" value="#muraScope#">
									<cfinvokeargument name="mura" value="#muraScope#">
									<cfinvokeargument name="m" value="#muraScope#">
								</cfinvoke>
								</cfsavecontent>

								<cfif isDefined("local.theDisplay2")>
									<cfset str=str & local.theDisplay2>
								<cfelse>
									<cfset str=str & local.theDisplay1>
								</cfif>

							<cfelse>
								<cfset tracePoint=initTracePoint("/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#")>
								<cfsavecontent variable="local.theDisplay1">
								<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#variables.rsScripts.directory[scriptIndex]#/#variables.rsScripts.scriptfile[scriptIndex]#",pluginConfig=getConfig(variables.rsScripts.pluginID[scriptIndex]), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
								</cfsavecontent>
								<cfset str=str & local.theDisplay1>
							</cfif>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						<cfelse>
							<cfif not isObject(eventHandler)>
								<cfset eventHandler=getEventHandlerFromPath(eventHandler)>
							</cfif>
							<cfset tracePoint=initTracePoint("#eventHandler.getValue('_objectName')#.#arguments.runat#")>
							<cfsavecontent variable="local.theDisplay1">
							<cfinvoke component="#eventHandler#"method="#arguments.runat#" returnVariable="local.theDisplay2">
								<cfinvokeargument name="event" value="#arguments.event#">
								<cfinvokeargument name="$" value="#muraScope#">
								<cfinvokeargument name="mura" value="#muraScope#">
								<cfinvokeargument name="m" value="#muraScope#">
							</cfinvoke>
							</cfsavecontent>
							<cfif isDefined("local.theDisplay2")>
								<cfset str=str & local.theDisplay2>
							<cfelse>
								<cfset str=str & local.theDisplay1>
							</cfif>
							<cfset commitTracePoint(tracePoint)>
							<cfset request.muraHandledEvents["#arguments.runat#"]=true>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>

		<cfif isQuery(arguments.scripts) or len(arguments.moduleID)>
			<cfif isQuery(arguments.scripts)>
				<cfset rs=arguments.scripts />
			<cfelse>
				<cfset rs=getScripts(arguments.runat,arguments.siteid,arguments.moduleID) />
			</cfif>

			<cfif rs.recordcount>

				<cfloop query="rs">
					<cfset currentModuleID=rs.moduleID>
					<cfif listLast(rs.scriptfile,".") neq "cfm">
						<cfset componentPath="plugins.#rs.directory#.#rs.scriptfile#">
						<cfset eventHandler=getComponent(componentPath, rs.pluginID, arguments.siteID, rs.docache)>
						<cfset tracePoint=initTracePoint("#componentPath#.#arguments.runat#")>
						<cfsavecontent variable="local.theDisplay1">
						<cfinvoke component="#eventHandler#" method="#arguments.runat#" returnVariable="local.theDisplay2">
							<cfinvokeargument name="event" value="#arguments.event#">
							<cfinvokeargument name="$" value="#muraScope#">
							<cfinvokeargument name="mura" value="#muraScope#">
							<cfinvokeargument name="m" value="#muraScope#">
						</cfinvoke>
						</cfsavecontent>

						<cfif isDefined("local.theDisplay2")>
							<cfset str=str & local.theDisplay2>
						<cfelse>
							<cfset str=str & local.theDisplay1>
						</cfif>

					<cfelse>
						<cfset tracePoint=initTracePoint("/plugins/#rs.directory#/#rs.scriptfile#")>
						<cfsavecontent variable="local.theDisplay1">
						<cfoutput>#getExecutor().renderScript(event=event,scriptfile="/plugins/#rs.directory#/#rs.scriptfile#",pluginConfig=getConfig(rs.pluginID), $=muraScope, mura=muraScope,m=muraScope)#</cfoutput>
						</cfsavecontent>
						<cfset str=str & local.theDisplay1>
					</cfif>
					<cfset commitTracePoint(tracePoint)>
					<cfset request.muraHandledEvents["#arguments.runat#"]=true>
				</cfloop>
			</cfif>
		</cfif>

	<cfcatch>
			<cfif len(currentModuleID)>
				<cfset rsOnError=getScripts("onError",arguments.siteid,currentModuleID) />
				<cfif arguments.runat neq "onError" and rsOnError.recordcount>
					<cfset arguments.event.setValue("errorType","render")>
					<cfset arguments.event.setValue("errorEvent",arguments.runat)>
					<cfset arguments.event.setValue("error",cfcatch)>
					<cfset arguments.event.setValue("exception",cfcatch)>
					<cfset testStr=renderScripts("onError",arguments.siteid,arguments.event,rsOnError)>
					<cfif len(testStr) or yesNoFormat(arguments.event.getValue("errorIsHandled"))>
						<cfset str=str & testStr>
					<cfelseif yesNoFormat(variables.configBean.getValue("debuggingenabled"))>
						<cfset request.muraDynamicContentError=true>
						<cfset str=str & getBean('utility').formatError(cfcatch)>
					<cfelse>
						<cfrethrow>
					</cfif>
				<cfelseif yesNoFormat(variables.configBean.getValue("debuggingenabled"))>
					<cfset request.muraDynamicContentError=true>
					<cfset str=str & getBean('utility').formatError(cfcatch)>
				<cfelse>
					<cfrethrow>
				</cfif>
			<cfelseif yesNoFormat(variables.configBean.getValue("debuggingenabled"))>
				<cfset request.muraDynamicContentError=true>
				<cfset str=str & getBean('utility').formatError(cfcatch)>
			<cfelse>
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>
	</cfif>

	<cfreturn trim(str)>
</cffunction>

<cffunction name="getHandlersQuery" output="false">
<cfargument name="eventToHandle">
<cfargument name="siteID" required="true" default="">
<cfargument name="moduleID" required="true" default="">
	<cfreturn getScripts(arguments.eventToHandle,arguments.siteID,arguments.moduleID)>
</cffunction>

<cffunction name="getScripts" output="false">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="moduleID" required="true" default="">
<cfset var rsScripts="">

	<cfquery name="rsScripts" dbtype="query">
	select pluginID, package, directory, scriptfile,name, docache, moduleID from variables.rsScripts
	where runat=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.runat#">
	<cfif len(arguments.siteID)>
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfif>
	<cfif len(arguments.moduleID)>
	and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfif>
	order by loadPriority
	</cfquery>
<cfreturn rsScripts/>

</cffunction>

<cffunction name="getDisplayObjectsBySiteID" output="false">
<cfargument name="siteID" required="true" default="">
<cfargument name="modulesOnly" required="true" default="false">
<cfargument name="moduleID" required="true" default="">
<cfargument name="configuratorsOnly" required="true" default="false">

	<cfset var rs="">

	<cfquery name="rs" dbtype="query">
		<cfif arguments.modulesOnly>
			select moduleID, siteID, title from variables.rsDisplayObjects
			where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
			<cfif len(arguments.moduleID)>
				and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
			</cfif>
			group by moduleID, title, siteID
			order by moduleID, title
		<cfelse>
			select pluginID, objectID, moduleID, siteID, name, title, displayObjectfile, docache, directory, displayMethod, configuratorInit, configuratorJS from variables.rsDisplayObjects
			where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
			<cfif len(arguments.moduleID)>
				and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
			</cfif>
			<cfif arguments.configuratorsOnly>
				and configuratorInit > ''
			</cfif>
			group by pluginID, objectID, moduleID, siteID, name, title, displayObjectfile, docache, directory, displayMethod, configuratorInit, configuratorJS
			order by moduleID, title, name
		</cfif>
	</cfquery>

<cfreturn rs/>

</cffunction>

<cffunction name="displayObject" output="false">
<cfargument name="object">
<cfargument name="event" required="true" default="">
<cfargument name="moduleID" required="true" default="">
<cfargument name="params" required="true" default="">

	<cfset var rsDisplayObject="">
	<cfset var key="">
	<cfset var componentPath="">
	<cfset var pluginConfig="">
	<cfset var eventHandler="">
	<cfset var theDisplay1="">
	<cfset var theDisplay2="">
	<cfset var rsOnError="">
	<cfset var muraScope="">
	<cfset var tracePoint=0>

	<cfif variables.utility.checkForInstanceOf(arguments.event,"mura.MuraScope")>
		<cfset muraScope=arguments.event>
		<cfset arguments.event=arguments.event.event()>
	<cfelse>
		<cfset muraScope=arguments.event.getValue("muraScope")>
	</cfif>

	<cfset arguments.event.setValue("objectID",arguments.object)>
	<cfset arguments.event.setValue("params",arguments.params)>

	<cfif isJSON(arguments.params)>
		<cfset event.setValue("objectparams",deserializeJSON(arguments.params))>
	<cfelseif isStruct(arguments.params)>
		<cfset event.setValue("objectparams",arguments.params)>
	<cfelse>
		<cfset event.setValue("objectparams",structNew())>
	</cfif>

	<cfquery name="rsDisplayObject" dbtype="query">
	select pluginID, displayObjectFile,location,displaymethod, docache, objectID, directory, moduleID, configuratorInit, configuratorJS from variables.rsDisplayObjects
	where
	siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#event.getValue('siteID')#">
	<cfif isvalid("UUID",event.getValue('objectID'))>
	and objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#event.getValue('objectID')#">
	<cfelse>
	and name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#event.getValue('objectID')#">
	</cfif>
	<cfif len(arguments.moduleID)>
	and moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfif>
	group by pluginID, displayObjectFile, location, displaymethod, docache, objectID, directory, moduleID, configuratorInit, configuratorJS
	</cfquery>

		<cfif rsDisplayObject.recordcount>
		<cftry>
		<cfif listLast(rsDisplayObject.displayobjectfile,".") neq "cfm">
			<!---<cfif rsDisplayObject.location neq "local">--->
				<cfset componentPath="plugins.#rsDisplayObject.directory#.#rsDisplayObject.displayobjectfile#">
			<!---<cfelse>
				<cfset componentPath="#variables.configBean.getWebRootMap()#.#event.getSite().getDisplayPoolID()#.includes.plugins.#rsDisplayObject.directory#.#rsDisplayObject.displayobjectfile#">
			</cfif>--->
			<cfset eventHandler=getComponent(componentPath, rsDisplayObject.pluginID, event.getValue('siteID'),rsDisplayObject.docache)>
			<cfset tracePoint=initTracePoint("#getMetaData(eventHandler).name#.#rsDisplayObject.displaymethod#")>
			<cfsavecontent variable="theDisplay1">
			<cfinvoke component="#eventHandler#" method="#rsDisplayObject.displaymethod#" returnvariable="theDisplay2">
				<cfinvokeargument name="event" value="#arguments.event#">
				<cfinvokeargument name="$" value="#muraScope#">
				<cfinvokeargument name="mura" value="#muraScope#">
				<cfinvokeargument name="m" value="#muraScope#">
			</cfinvoke>
			</cfsavecontent>
			<cfset commitTracePoint(tracePoint)>
			<cfif isdefined("theDisplay2")>
				<cfif isSimpleValue(theDisplay2)>
					<cfreturn trim(theDisplay2)>
				<cfelse>
					<cfreturn theDisplay2>
				</cfif>
			<cfelse>
				<cfreturn trim(theDisplay1)>
			</cfif>
		<cfelse>
			<cfreturn getExecutor().displayObject(objectID=rsDisplayObject.objectID, event=arguments.event, rsDisplayObject=rsDisplayObject, $=muraScope, mura=muraScope) />
		</cfif>
		<cfcatch>
			<cfset rsOnError=getScripts("onError",event.getValue('siteID'),rsDisplayObject.moduleID) />
			<cfif rsOnError.recordcount>
				<cfset arguments.event.setValue("errorType","render")>
				<cfset arguments.event.setValue("error",cfcatch)>
				<cfset arguments.event.setValue("exception",cfcatch)>
				<cfreturn renderScripts("onError",event.getValue('siteID'),arguments.event,rsOnError)>
			<cfelseif variables.configBean.getDebuggingEnabled()>
				<cfset request.muraDynamicContentError=true>
				<cfreturn getBean('utility').formatError(cfcatch)>
			 <cfelse>
			 	<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>
		</cfif>

		<cfreturn "">
</cffunction>

<cffunction name="getDirectoryFromQuery" output="false">
<cfargument name="rs">
	<cfif len(rs.package)>
		<cfreturn "#rs.package#.#rs.pluginID#">
	<cfelse>
		<cfreturn "#rs.pluginID#">
	</cfif>
</cffunction>

<cffunction name="getComponent" output="false">
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

<cffunction name="getExecutor" output="false">
<cfset var executor=createObject("component","pluginExecutor").init(variables.configBean,variables.settingsManager,this) />
<cfreturn executor />
</cffunction>

<cffunction name="getDisplayObjectBean" output="false">
<cfreturn getBean("pluginDisplayObjectBean") />
</cffunction>

<cffunction name="getScriptBean" output="false">
<cfreturn getBean("pluginScriptBean") />
</cffunction>

<cffunction name="purgeStandardEventFactories" output="false">
<cfset variables.standardEventFactories=structNew()/>
</cffunction>

<cffunction name="getStandardEventFactory" output="false">
<cfargument name="siteid" required="true" default="">


	<cfif not structKeyExists(variables.standardEventFactories,arguments.siteid)>
		<cfset variables.standardEventFactories[arguments.siteid]=createObject("component","pluginStandardEventFactory").init(arguments.siteID,variables.standardEventsHandler,this)>
	</cfif>

	<cfreturn variables.standardEventFactories[arguments.siteid]>
</cffunction>

<cffunction name="getCacheFactory" output="false">
<cfargument name="siteid" required="true" default="">


	<cfif not structKeyExists(variables.cacheFactories,arguments.siteid)>
		<cfset variables.cacheFactories[arguments.siteid]=createObject("component","mura.cache.cacheFactory").init(isSoft=false)>
	</cfif>

	<cfreturn variables.cacheFactories[arguments.siteid]>
</cffunction>

<cffunction name="purgeCacheFactories" output="false">
<cfset variables.cacheFactories=structNew()/>
</cffunction>

<cffunction name="purgePluginConfigs" output="false">
<cfset variables.pluginConfigs=structNew()/>
</cffunction>

<cffunction name="renderAdminTemplate" output="false">
<cfargument name="body">
<cfargument name="pageTitle" default="">
<cfargument name="jsLib" required="true" default="jquery">
<cfargument name="jsLibLoaded" required="true" default="true">
<cfargument name="compactDisplay" required="false" default="false" />
<cfargument name="moduleid" required="false" default="#request.muraMostRecentPluginModuleID#" />
<cfset var sessionData=getSession()>
<cfif not (isDefined('sessionData.siteid') and isDefined('sessionData.siteArray'))>
	<cflocation url="#variables.configBean.getContext()##variables.configBean.getAdminDir()#/" addtoken="false">
</cfif>

<cfset var rc=structNew()>
<cfset var returnStr="">
<cfset var moduleTitle=arguments.pageTitle>
<cfset var layoutTemplate="template" />
<cfset var sessionData=getSession()>

<cfset rc.layout =arguments.body>
<cfset rc.ajax ="">
<cfset rc.originalcircuit="cPlugins">
<cfset rc.originalfuseaction="">
<cfset rc.moduleID=arguments.moduleid>
<cfset rc.jsLib=arguments.jsLib>
<cfset rc.jsLibLoaded=arguments.jsLibLoaded>
<cfset rc.renderMuraAlerts=false>
<cfset rc.$=getBean('$').init(sessionData.siteid)>
<cfset var $=rc.$>

<cfif arguments.compactDisplay>
	<cfset layoutTemplate = "compact" />
</cfif>

<cfsavecontent variable="returnStr">
	<cfinclude template="/#variables.configBean.getWebrootMap()##variables.configBean.getAdminDir()#/common/layouts/#layoutTemplate#.cfm">
</cfsavecontent>

<cfreturn returnStr/>
</cffunction>

<cffunction name="renderAdminToolbar" output="false">
<cfargument name="jsLib" required="true" default="prototype">
<cfargument name="jsLibLoaded" required="true" default="false">
<cfset var returnStr="">

<cfsavecontent variable="returnStr">
<cfinclude template="/#variables.configBean.getWebrootMap()##variables.configBean.getAdminDir()#/common/layouts/includes/pluginHeader.cfm">
</cfsavecontent>

<cfreturn returnStr/>
</cffunction>

<cffunction name="createLookupTXT" output="false">
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

<cffunction name="getIDFromPath" output="false">
<cfargument name="path">
	<cfreturn listLast(listGetat(getDirectoryFromPath(arguments.path),listLen(replace(getDirectoryFromPath(arguments.path),'\','/','all'),'/')-1,'/'),"_")>
</cffunction>

<cffunction name="addEventHandler" output="false">
<cfargument name="component">
<cfargument name="siteID" required="true">
<cfargument name="persist" required="true" default="true">
<cfargument name="applyglobal" required="true" default="true">
<cfargument name="objectid" required="true" default="">

<cflock name="addEventHandler#application.instanceID#" type="exclusive" timeout="200">
	<cfset var i = "">
	<cfset var handlerData=structNew()>
	<cfset var eventhandler=arguments.component>
	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var _persist=false>

	<cfif len(siteIDadjusted) and not StructKeyExists(variables.siteListeners,siteIDadjusted)>
		<cfset variables.siteListeners[siteIDadjusted]=structNew()>
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

	<cfif not isDefined('arguments.component.injectMethod')>
		<cfset arguments.component.injectMethod=injectMethod>
	</cfif>

	<cfif not isDefined('eventhandler.getValue')>
		<cfset eventHandler.injectMethod('getValue',getValue)>
	</cfif>

	<cfif not isDefined('eventhandler.setValue')>
		<cfset eventHandler.injectMethod('setValue',setValue)>
	</cfif>

	<cfset eventhandler.setValue('_objectName',getMetaData(eventhandler).name)>

	<!---
	<cfset var appcfcLookup={
		'onRequestStart'='onGlobalRequestStart',
		'onRequestEnd'='onGlobalRequestEnd',
		'onApplicationStart'='onApplicationLoad',
		'onError'='onGlobalError',
		'onMissingTemplate'='onGlobalMissingTemplate',
		'onSessionStart'='onGlobalSessionStart',
		'onSessionEnd'='onGlobalSessionEnd'
	}>
	--->

	<cfloop collection="#eventhandler#" item="i">
		<!---
		<cfif structKeyExists(appcfcLookup,i) and not structKeyExists(eventhandler,appcfcLookup[i])>
			<cfset i=appcfcLookup[i]>
		</cfif>
		--->

		<cfif left(i,2) eq "on" or left(i,8) eq "standard">
			<cfset handlerData=structNew()>
			<cfset handlerData.index=arrayLen(variables.eventHandlers)>
			<cfif isDefined("eventHandler.pluginName")>
				<cfset handlerData.pluginName=eventHandler.pluginName>
			<cfelseif isDefined("eventHandler.getPluginName")>
				<cfset handlerData.pluginName=eventHandler.getPluginName()>
			<cfelseif len(eventHandler.getValue('pluginName'))>
				<cfset handlerData.pluginName=eventHandler.getValue('pluginName')>
			<cfelseif isDefined("eventHandler.moduleName")>
				<cfset handlerData.pluginName=eventHandler.moduleName>
			<cfelseif isDefined("eventHandler.getModuleName")>
				<cfset handlerData.pluginName=eventHandler.getModuleName()>
			<cfelseif len(eventHandler.getValue('moduleName'))>
				<cfset handlerData.pluginName=eventHandler.getValue('moduleName')>
			<cfelse>
				<cfset handlerData.pluginName='undefined'>
			</cfif>

			<cfif len(arguments.objectid)>
				<cfif len(siteIDadjusted)>
					<cfif not structKeyExists(variables.siteListeners[siteIDadjusted],'objects')>
						<cfset variables.siteListeners[siteIDadjusted].objects={}>
					</cfif>
					<cfif not structKeyExists(variables.siteListeners[siteIDadjusted].objects,'#arguments.objectid#')>
						<cfset variables.siteListeners[siteIDadjusted].objects['#arguments.objectid#']={}>
					</cfif>
					<cfif not structKeyExists(variables.siteListeners[siteIDadjusted].objects['#arguments.objectid#'],i)>
						<cfset variables.siteListeners[siteIDadjusted].objects['#arguments.objectid#'][i]=arrayNew(1)>
					</cfif>
					<cfset arrayAppend( variables.siteListeners[siteIDadjusted].objects['#arguments.objectid#'][i] , handlerData)>
				<cfelse>
					<cfif not structKeyExists(variables.globalListeners,'objects')>
						<cfset variables.globalListeners.objects={}>
					</cfif>
					<cfif not structKeyExists(variables.globalListeners.objects,'#arguments.objectid#')>
						<cfset variables.globalListeners.objects['#arguments.objectid#']={}>
					</cfif>
					<cfif not structKeyExists(variables.globalListeners.objects['#arguments.objectid#'],i)>
						<cfset variables.globalListeners.objects['#arguments.objectid#'][i]=arrayNew(1)>
					</cfif>
					<cfset arrayAppend( variables.globalListeners.objects['#arguments.objectid#'][i] , handlerData)>
				</cfif>
			<cfelseif len(arguments.siteid) and not findNoCase('global',i)>
				<cfif not structKeyExists(variables.siteListeners[siteIDadjusted],i)>
					<cfset variables.siteListeners[siteIDadjusted][i]=arrayNew(1)>
				</cfif>
				<cfset arrayAppend( variables.siteListeners[siteIDadjusted][i] , handlerData)>
			<cfelseif arguments.applyglobal>
				<cfif not structKeyExists(variables.globalListeners,i)>
					<cfset variables.globalListeners[i]=arrayNew(1)>
				</cfif>
				<cfset arrayAppend( variables.globalListeners[i] , handlerData)>
			</cfif>
		</cfif>
	</cfloop>
</cflock>
</cffunction>

<cffunction name="getEventHandlerFromPath" output="false">
<cfargument name="component">
	<cfset var eventhandler=createObject("component",arguments.component)>
	<cfif structKeyExists(eventHandler,"init")>
		<cfset eventHandler.init()>
	</cfif>
	<cfreturn eventHandler>
</cffunction>

<cffunction name="getSiteListener" ouput="false">
<cfargument name="siteID">
<cfargument name="runat">

	<cfset var siteIDadjusted=adjustSiteID(arguments.siteID)>
	<cfset var listenerArray="">

	<cfif isDefined("variables.siteListeners.#siteIDadjusted#.#arguments.runat#")>
		<cfset variables.listeners[siteIDadjusted]=structNew()>
		<cfset listenerArray=variables.siteListeners["#siteIDadjusted#"]["#arguments.runat#"]>
		<cfreturn variables.eventHandlers[listenerArray[1].index]>
	<cfelse>
		<cfreturn "">
	</cfif>

</cffunction>

<cffunction name="getGlobalListener" ouput="false">
<cfargument name="runat">
	<cfset var listenerArray="">

	<cfif isDefined("variables.globalListeners.#arguments.runat#")>
		<cfset variables.listeners[siteIDadjusted]=structNew()>
		<cfset listenerArray=variables.globalListeners["#arguments.runat#"]>
		<cfreturn variables.eventHandlers[listenerArray[1].index]>
	<cfelse>
		<cfreturn "">
	</cfif>

</cffunction>

<cffunction name="adjustSiteID" output="false">
<cfargument name="siteID">
<cfreturn "_" & rereplace(arguments.siteID,"[^a-zA-Z0-9]","","ALL")>
</cffunction>

<cffunction name="deployBundle" output="false" hint="I return a struct of any errors that occurred.">
	<cfargument name="siteID" hint="List of siteIDs to assign the plugin">
	<cfargument name="bundleFile" hint="Complete path to bundle zip file">
	<cfset var errors=structNew()>

	<cfif not variables.settingsManager.isBundle(arguments.pluginFile)>
		<cfreturn deployPlugin(siteID=arguments.siteID, pluginFile=arguments.pluginFile)>
	</cfif>

	<cfset errors=application.settingsManager.restoreBundle(
			BundleFile=arguments.bundleFile,
			siteID=arguments.siteID,
			keyMode="publish",
			contentMode="none",
			renderingMode="none",
			pluginMode="all",
			moduleID="")>

	<cfset loadPlugins()>

	<cfreturn errors>
</cffunction>

<cffunction name="deployPlugin" output="false">
	<cfargument name="siteID" hint="List of siteIDs to assign the plugin">
	<cfargument name="pluginFile" hint="Complete path to plugin zip file">
	<cfargument name="useDefaultSettings" required="true" default="true">
	<cfargument name="autoDeploy" required="true" default="true">

	<cfset var zipTrim=getZipTrim(arguments.pluginFile)>
	<cfset var errors=structNew()>
	<cfset var tempDir=createUUID()>
	<cfset var result="">
	<cfset var pluginXml="">
	<cfset var rsSites="">
	<cfset var id="">
	<cfset var deleteFile=false>

	<cfif isValid('url',arguments.pluginFile)>
		<cfset arguments.pluginFile=getLocalFileFromURL(arguments.pluginFile)>
		<cfset deleteFile=true>
	</cfif>

	<cfif variables.settingsManager.isBundle(arguments.pluginFile)>
		<cfreturn deployBundle(siteID=arguments.siteID, bundleFile=arguments.pluginFile)>
	</cfif>

	<cfset variables.fileWriter.createDir(directory=getLocation(tempDir))>

	<cfif len(zipTrim)>
		<cfset variables.zipTool.extract(zipFilePath=arguments.pluginFile,extractPath=getLocation(tempDir), overwriteFiles=true, extractDirs=zipTrim, extractDirsToTop=true)>
	<cfelse>
		<cfset variables.zipTool.extract(zipFilePath=arguments.pluginFile,extractPath=getLocation(tempDir), overwriteFiles=true)>
	</cfif>

	<cfset pluginXml=getPluginXML(moduleID="",pluginDir=tempDir)>

	<cfif structKeyExists(pluginXML.plugin,"package") and len(pluginXML.plugin.package.xmlText)>
		<cfset id=pluginXML.plugin.package.xmlText>
	<cfelse>
		<cfset id=pluginXML.plugin.name.xmlText>
	</cfif>

	<cfset result=deploy(id=id, pluginDir=tempDir, useDefaultSettings=arguments.useDefaultSettings, siteID=arguments.siteID,autoDeploy=arguments.autoDeploy)>

	<cfset variables.fileWriter.deleteDir(directory=getLocation(tempDir))>

	<cfif deleteFile>
		<cfset fileDelete(arguments.pluginFile)>
	</cfif>

	<cfreturn result>

</cffunction>

<cffunction name="deployDirectory" output="false">
	<cfargument name="siteID" hint="List of siteIDs to assign the plugin. If not defined, will default to existing assignment.">
  <cfargument name="directory" hint="Complete path to external plugin directory if external, otherwise the name og the directory in /plugins">
	<cfargument name="useDefaultSettings" required="true" default="true">
	<cfargument name="autoDeploy" required="true" default="true">

	<cfset var errors=structNew()>
	<cfset var tempDir="">
	<cfset var id="">
	<cfset var result="">
	<cfset var pluginXml="">
	<cfset var rsSites="">
	<cfset var external=true>

	<cfset arguments.deployDirectory=replace(arguments.directory,"\","/","all")>

	<!--- Remove Trailing Slash --->
	<cfif right(arguments.deployDirectory,1) eq "/">
		<cfset arguments.deployDirectory=left(arguments.deployDirectory,len(arguments.deployDirectory)-1)>
	</cfif>

	<cfif find("/",arguments.deployDirectory)>
		<cfset tempDir=createUUID()>
		<cfset variables.fileWriter.createDir(directory=getLocation(tempDir))>
		<cfset variables.fileWriter.copyDir(baseDir=arguments.directory,destDir=getLocation(tempDir),excludeHiddenFiles=false)>
		<cfset arguments.directory=tempDir>
	</cfif>

	<cfset pluginXml=getPluginXML(moduleID="",pluginDir=arguments.directory)>

	<cfif structKeyExists(pluginXML.plugin,"package") and len(pluginXML.plugin.package.xmlText)>
		<cfset id=pluginXML.plugin.package.xmlText>
	<cfelse>
		<cfset id=pluginXML.plugin.name.xmlText>
	</cfif>

	<cfif not structKeyExists(arguments,"siteID")>
		<cfset rsSites=getConfig(id).getAssignedSites()>
		<cfset arguments.siteID=valueList(rsSites.siteID)>
	</cfif>

	<cfset result=deploy(id=id, pluginDir=arguments.directory, useDefaultSettings=arguments.useDefaultSettings, siteID=arguments.siteID, autoDeploy=arguments.autoDeploy)>

	<cfreturn result>

</cffunction>

<cffunction name="reDeploy" output="false">
	<cfargument name="siteID" hint="List of siteIDs to assign the plugin. If not defined will defiend to existing assignment.">
	<cfargument name="ID" hint="The moduleID, pluginID, package or name of plugin to redeploy">

	<cfset var errors=structNew()>s
	<cfset var rsSites="">
	<cfset var pluginConfig=getConfig(arguments.id)>
	<cfset var result="">

	<cfif not len(pluginConfig.getDirectory())>
		<cfthrow message="A plugin with the package, pluginID or moduleID with a value '#arguments.id#' does not exist.">
	</cfif>

	<cfif not structKeyExists(arguments,"siteID")>
		<cfset rsSites=pluginConfig.getAssignedSites()>
		<cfset arguments.siteID=valueList(rsSites.siteID)>
	</cfif>

	<cfset result=deploy(moduleid=pluginConfig.getModuleID(), pluginDir=pluginConfig.getDirectory(), useDefaultSettings=true, siteID=arguments.siteID)>

	<cfreturn result>

</cffunction>

<cffunction name="createBundle" output="false" hint="I bundle a plugin and return it's filename">
	<cfargument name="id" hint="ModuleID or pluginID or Package">
	<cfargument name="directory" hint="Server directory to save the bundle">
	<cfset var pluginConfig=getConfig(arguments.id)>

	<cfreturn getBean("Bundle").Bundle(
			siteID="",
			moduleID=pluginConfig.getModuleID(),
			BundleName=getBean('contentUtility').formatFilename(pluginConfig.getName()),
			includeVersionHistory=false,
			includeTrash=false,
			includeMetaData=false,
			includeMailingListMembers=false,
			includeUsers=false,
			includeFormData=false,
			saveFile=true,
			saveFileDir=arguments.directory) />
</cffunction>

<cffunction name="getZipTrim" output="false">
	<cfargument name="pluginFile">
	<cfset var i="">
	<cfset var zipTrim="">
	<cfset var delim=variables.configBean.getFileDelim() />
	<cfset var rsZipFiles=variables.zipTool.list(zipFilePath=arguments.pluginFile)>

	<cfquery name="rsZipFiles" dbtype="query">
		select * from rsZipFiles
		where entry like '%#delim#plugin#delim#%'
		or entry like 'plugin#delim#%'
	</cfquery>

	<cfloop list="#rsZipFiles.entry#" delimiters="#delim#" index="i">
		<cfif i eq "plugin">
			<cfbreak>
		<cfelse>
			<cfset zipTrim=listAppend(zipTrim,i,delim)>
		</cfif>
	</cfloop>

	<cfreturn zipTrim>
</cffunction>

<cffunction name="getLocalFileFromURL" output="false">
	<cfargument name="pluginURL">

	<cfset var myResult="">

	<cfhttp attributeCollection='#getHTTPAttrs(
		url="#arguments.pluginUrl#",
		method="get",
		getasbinary="yes",
		result="myResult")#'>

	<cfset var pluginFileName = CreateUUID() & ".zip">
	<cfset var pluginFileLocation = variables.configBean.getTempDir() & pluginFileName>
	<cfset fileWrite(pluginFileLocation, myResult.filecontent)>
	<cfreturn pluginFileLocation>
</cffunction>

<cffunction name="discoverBeans" output="false">
	<cfset var rs="">
	<cfquery name="rs">
		select moduleid from tplugins where deployed >=1 order by loadPriority desc
	</cfquery>
	<cfloop query="rs">
		<cfset getConfig(id=rs.moduleid,cache=false).discoverBeans()>
	</cfloop>
	<cfreturn this>
</cffunction>

</cfcomponent>
