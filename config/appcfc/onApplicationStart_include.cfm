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
<cfparam name="local" default="#structNew()#">
<cfparam name="application.appInitializedTime" default="" />
<cfparam name="application.appInitialized" default="false" />
<cfparam name="application.appAutoUpdated" default="false" />
<cfparam name="application.appReloadKey" default="appreload" />
<cfparam name="application.broadcastInit" default="false" />
<cfparam name="application.sessionTrackingThrottle" default="true"/>
<cfparam name="application.instanceID" default="#createUUID()#" />
<cfparam name="application.CFVersion" default="#listFirst(SERVER.COLDFUSION.PRODUCTVERSION)#" />
<cfparam name="application.setupComplete" default="false" />
<cfset request.muraAppreloaded=true>

<!--- this is here for CF8 compatibility --->
<cfset variables.baseDir=this.baseDir>
<cfprocessingdirective pageencoding="utf-8"/>
<cfsetting requestTimeout = "1000"> 

<!--- do a settings setup check --->
<cfif NOT application.setupComplete OR (not application.appInitialized or structKeyExists(url,application.appReloadKey) )>
	<cfif getProfileString( variables.basedir & "/config/settings.ini.cfm", "settings", "mode" ) eq "production">
		<cfif directoryExists( variables.basedir & "/config/setup" )>
			<cfset application.setupComplete = false />
			<!--- check the settings --->
			<cfparam name="application.setupSubmitButton" default="A#hash( createUUID() )#" />
			<cfparam name="application.setupSubmitButtonComplete" default="A#hash( createUUID() )#" />
			
			<cfif trim( getProfileString( variables.basedir & "/config/settings.ini.cfm" , "production", "datasource" ) ) IS NOT ""
					AND (
						NOT isDefined( "FORM.#application.setupSubmitButton#" )
						AND
						NOT isDefined( "FORM.#application.setupSubmitButtonComplete#" )
						)
				>		
						
				<cfset application.setupComplete = true />
			<cfelse>
				<!--- check to see if the index.cfm page exists in the setup folder --->
				<cfif NOT fileExists( variables.basedir & "/config/setup/index.cfm" )>
					<cfthrow message="Your setup directory is incomplete. Please reset it up from the Mura source." />
				</cfif>

				<cfset application.setupComplete = false />
			</cfif>	
		<cfelse>
			<cfset application.setupComplete = true />
		</cfif>
	<cfelse>		
		<cfset application.setupComplete=true>
	</cfif>
</cfif>	

<cfif application.setupComplete and (not application.appInitialized or structKeyExists(url,application.appReloadKey))>
<cflock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200">	
	<!--- Since the request may of had to wait double thak that code sitll needs to run --->
	<cfif (not application.appInitialized or structKeyExists(url,application.appReloadKey))>
		
		<cfset application.appInitialized=false>
		<cfset request.muraShowTrace=true>
		
		<cfset variables.iniPath = "#variables.basedir#/config/settings.ini.cfm" />
		
		<cfset variables.iniSections=getProfileSections(variables.iniPath)>
		
		<cfset variables.iniProperties=structNew()>
		<cfloop list="#variables.iniSections.settings#" index="variables.p">
			<cfset variables.iniProperties[variables.p]=getProfileString("#variables.basedir#/config/settings.ini.cfm","settings",variables.p)>			
			<cfif left(variables.iniProperties[variables.p],2) eq "${"
				and right(variables.iniProperties[variables.p],1) eq "}">
				<cfset variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-3)>
				<cfset variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p])>
			<cfelseif left(variables.iniProperties[variables.p],2) eq "{{"
				and right(variables.iniProperties[variables.p],2) eq "}}">
				<cfset variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-4)>
				<cfset variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p])>
			</cfif>		
		</cfloop>		
		
		<cfloop list="#variables.iniSections[ variables.iniProperties.mode]#" index="variables.p">
			<cfset variables.iniProperties[variables.p]=getProfileString("#variables.basedir#/config/settings.ini.cfm", variables.iniProperties.mode,variables.p)>
			<cfif left(variables.iniProperties[variables.p],2) eq "${"
				and right(variables.iniProperties[variables.p],1) eq "}">
				<cfset variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-3)>
				<cfset variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p])>
			<cfelseif left(variables.iniProperties[variables.p],2) eq "{{"
				and right(variables.iniProperties[variables.p],2) eq "}}">
				<cfset variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-4)>
				<cfset variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p])>
			</cfif>		
		</cfloop>
		
		<cfset variables.iniProperties.webroot = expandPath("/muraWRM") />
		
		<cfset variables.mode = variables.iniProperties.mode />
		<cfset variables.mapdir = variables.iniProperties.mapdir />
		<cfset variables.webroot = variables.iniProperties.webroot />
		
		<cfif not structKeyExists(variables.iniProperties,"useFileMode")>
			<cfset variables.iniProperties.useFileMode=true>
		</cfif>
		
		<cfset application.appReloadKey = variables.iniProperties.appreloadkey />
		
		<cfset variables.iniProperties.webroot = expandPath("/muraWRM") />
		
		<cfinclude template="/muraWRM/config/coldspring.xml.cfm" />
		
		<cfset variables.tracer=createObject("component","mura.cfobject").init()>
	
		<!--- load the core services.xml --->
		
		<cfset variables.tracepoint=variables.tracer.initTracepoint("Instantiating ColdSpring")> 
		<cfset variables.serviceFactory=createObject("component","mura.bean.beanFactory").init(defaultProperties=variables.iniProperties) />
		<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
		
		<cfset variables.tracepoint=variables.tracer.initTracepoint("Loading Coldspring XML")> 
		<cfset variables.serviceFactory.loadBeansFromXMLRaw(variables.servicesXML,true) />
		<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
		
		<!--- If coldspring.custom.xml.cfm exists read it in an check it it is valid xml--->
		<cfif fileExists(expandPath("/muraWRM/config/coldspring.custom.xml.cfm"))>	
			<cffile action="read" variable="customvariables.servicesXML" file="#expandPath('/muraWRM/config/coldspring.custom.xml.cfm')#">
			<cfif not findNoCase("<!-" & "--",customvariables.servicesXML)>
				<cfif not findNoCase("<beans>",customvariables.servicesXML)>
					<cfset customvariables.servicesXML= "<beans>" & customvariables.servicesXML & "</beans>">
				</cfif>
				<cfset customvariables.servicesXML=replaceNoCase(customvariables.servicesXML, "##mapdir##","mura","ALL")>
				<cfset variables.tracepoint=variables.tracer.initTracepoint("Loading Custom Coldspring XML")> 
				<cfset variables.serviceFactory.loadBeansFromXMLRaw(customvariables.servicesXML,true) />
				<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
			</cfif>
		</cfif>
		
		<cfset application.serviceFactory=variables.serviceFactory>
		
		<cfobjectcache action="clear" />
		<cfset variables.tracepoint=variables.tracer.initTracepoint("Instantiating ConfigBean")> 
		<cfset application.configBean=application.serviceFactory.getBean("configBean") />
		<cfset application.configBean.set(variables.iniProperties)>
		<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
		
		<!---You can create an onGlobalConfig.cfm file that runs after the initial configBean loads, but before anything else is loaded --->
		<cfif fileExists(ExpandPath("/muraWRM/config/onGlobalConfig.cfm"))>
			<cfinclude template="/muraWRM/config/onGlobalConfig.cfm">
		</cfif>
		
		<cfif application.configBean.getValue("applyDBUpdates") or application.appAutoUpdated>
			<cfset variables.tracepoint=variables.tracer.initTracepoint("Checking/Applying DB updates")> 
			<cfset application.configBean.applyDbUpdates() />
			<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
		</cfif>
		
		<cfset application.appAutoUpdated=false>
		
		<cfset variables.serviceList="settingsManager,contentManager,pluginManager,eventManager,contentRenderer,utility,contentUtility,contentGateway,categoryManager,clusterManager,contentServer,changesetManager,scriptProtectionFilter,permUtility,emailManager,loginManager,mailinglistManager,userManager,dataCollectionManager,advertiserManager,feedManager,sessionTrackingManager,favoriteManager,raterManager,dashboardManager,autoUpdater">
	
		<!--- These application level services use the beanServicePlaceHolder to lazy load the bean --->
		<cfloop list="#variables.serviceList#" index="variables.i">
			<cfset variables.tracepoint=variables.tracer.initTracepoint("Instantiating #variables.i#")> 	
			<cfset application["#variables.i#"]=application.serviceFactory.getBean("#variables.i#") />
			<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
		</cfloop>	
		
		<!--- End beanServicePlaceHolders --->

		<cfsavecontent variable="variables.temp"><cfoutput><cfinclude template="/mura/bad_words.txt"></cfoutput></cfsavecontent>
		<cfset application.badwords = ReReplaceNoCase(trim(variables.temp), "," , "|" , "ALL")/> 

		<cfset variables.tracepoint=variables.tracer.initTracepoint("Instantiating classExtensionManager")> 
		<cfset application.classExtensionManager=application.configBean.getClassExtensionManager() />
		<cfset variables.tracer.commitTracepoint(variables.tracepoint)>

		<cfset variables.tracepoint=variables.tracer.initTracepoint("Instantiating resourceBundleFactory")> 
		<cfset application.rbFactory=application.serviceFactory.getBean("resourceBundleFactory") />
		<cfset variables.tracer.commitTracepoint(variables.tracepoint)>
			
		<!---settings.custom.managers.cfm reference is for backwards compatibility --->
		<cfif fileExists(ExpandPath("/muraWRM/config/settings.custom.managers.cfm"))>
			<cfinclude template="/muraWRM/config/settings.custom.managers.cfm">
		</cfif>		
					
		<cfset variables.basedir=expandPath("/muraWRM")/>
					
		<cfif StructKeyExists(SERVER,"bluedragon") and not findNoCase("Windows",server.os.name)>
			<cfset variables.mapprefix="$" />
		<cfelse>
			<cfset variables.mapprefix="" />
		</cfif>
		
		<cfif len(application.configBean.getValue('encryptionKey'))>
			<cfset application.encryptionKey=application.configBean.getValue('encryptionKey')>
		</cfif>
					
		<cfdirectory action="list" directory="#variables.basedir#/requirements/" name="variables.rsRequirements">
	
		<cfloop query="variables.rsRequirements">
			<cfif variables.rsRequirements.type eq "dir" and variables.rsRequirements.name neq '.svn' and not structKeyExists(this.mappings,"/#variables.rsRequirements.name#")>
				<cfset application.serviceFactory.getBean("fileWriter").appendFile(file="#variables.basedir#/config/mappings.cfm", output='<cfset this.mappings["/#variables.rsRequirements.name#"] = variables.mapprefix & variables.basedir & "/requirements/#variables.rsRequirements.name#">')>				
			</cfif>
		</cfloop>	

		<cfif application.configBean.getValue("autoDiscoverPlugins") and not isdefined("url.safemode")>
			<cfset application.pluginManager.discover()>
		</cfif>
		
		<cfset application.cfstatic=structNew()>			
		<cfset application.appInitialized=true/>
		<cfset application.appInitializedTime=now()>
		<cfset application.clusterManager.reload(broadcast=application.broadcastInit)>
		<cfset application.broadcastInit=true/>
		<cfset structDelete(application,"muraAdmin")>
		<cfset structDelete(application,"proxyServices")>
		<cfset structDelete(application,"CKFinderResources")>
		
		<!--- Set up scheduled tasks --->
		<cfif (len(application.configBean.getServerPort())-1) lt 1>
			<cfset variables.port=80/>
		<cfelse>
			<cfset variables.port=right(application.configBean.getServerPort(),len(application.configBean.getServerPort())-1) />
		</cfif>
			
		<cfif application.configBean.getCompiler() eq "Railo">
			<cfset variables.siteMonitorTask="siteMonitor"/>
		<cfelse>
			<cfset variables.siteMonitorTask="#application.configBean.getWebRoot()#/tasks/siteMonitor.cfm"/>
		</cfif>
			
		<cftry>
			<cfif variables.iniProperties.ping eq 1>
				<cfschedule action = "update"
					task = "#variables.siteMonitorTask#"
					operation = "HTTPRequest"
					url = "http://#listFirst(cgi.http_host,":")##application.configBean.getContext()#/tasks/siteMonitor.cfm"
					port="#variables.port#"
					startDate = "#dateFormat(now(),'mm/dd/yyyy')#"
					startTime = "#createTime(0,15,0)#"
					publish = "No"
					interval = "900"
					requestTimeOut = "600"
				/>
			</cfif>
		<cfcatch></cfcatch>
		</cftry>
						
		<cfif application.configBean.getCreateRequiredDirectories() 
			and not directoryExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()#plugins")> 
			<cftry>
				<cfdirectory action="create" mode="777" directory="#application.configBean.getWebRoot()##application.configBean.getFileDelim()#plugins"> 
				<cfcatch>
					<cfdirectory action="create" directory="#application.configBean.getWebRoot()##application.configBean.getFileDelim()#plugins"> 
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfif not fileExists(variables.basedir & "/robots.txt")>	
			<cfset application.serviceFactory.getBean("fileWriter").copyFile(source="#variables.basedir#/config/templates/robots.template.cfm", destination="#variables.basedir#/robots.txt")>
		</cfif>

		<cfif not fileExists(variables.basedir & "/web.config")>	
			<cfset application.serviceFactory.getBean("fileWriter").copyFile(source="#variables.basedir#/config/templates/web.config.template.cfm", destination="#variables.basedir#/web.config")>
		</cfif>
		
		<cfif not structKeyExists(application,"plugins")>
			<cfset application.plugins=structNew()>
		</cfif>
		<cfset application.pluginstemp=application.plugins>
		<cfset application.plugins=structNew()>
		<cfset variables.pluginEvent=createObject("component","mura.event").init()>		

		<cftry>	
			<cfset application.pluginManager.executeScripts(runat='onApplicationLoad',event= variables.pluginEvent)>
			<cfcatch>
				<cfset structAppend(application.plugins,application.pluginstemp,false)>
				<cfset structDelete(application,"pluginstemp")>
				<cfrethrow>
			</cfcatch>
		</cftry>

		<cfset structDelete(application,"pluginstemp")>

		<!--- Fire local onApplicationLoad events--->
		<cfset variables.rsSites=application.settingsManager.getList() />
		<cfset variables.themeHash=structNew()>
		<cfloop query="variables.rsSites">
			
			<cfset variables.siteBean=application.settingsManager.getSite(variables.rsSites.siteID)>
			<cfset variables.themedir=expandPath(variables.siteBean.getThemeIncludePath())>

			<cfif fileExists(variables.themedir & '/config.xml.cfm')>
				<cfset variables.themeConfig='config.xml.cfm'>
			<cfelseif fileExists(variables.themedir & '/config.xml')>
				<cfset variables.themeConfig='config.xml'>
			<cfelse>
				<cfset variables.themeConfig="">
			</cfif>
			
			<cfif len(variables.themeConfig) and not structKeyExists(variables.themeHash,hash(variables.themedir))>
				<cfset variables.themeHash[hash(variables.themedir)]=variables.themedir>
				
				<cfif variables.themeConfig eq "config.xml.cfm">
					<cfsavecontent variable="variables.themeConfig">
						<cfinclude template="#variables.siteBean.getThemeIncludePath()#/config.xml.cfm">
					</cfsavecontent>

				<cfelse>
					<cfset variables.themeConfig=fileRead(variables.themedir & "/" & variables.themeConfig)>
				</cfif>

				<cfset variables.themeConfig=xmlParse(variables.themeConfig)>
				<cfset application.configBean.getClassExtensionManager().loadConfigXML(variables.themeConfig,variables.rsSites.siteid)>

			</cfif>

			<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#variables.rsSites.siteID#/includes/eventHandler.cfc")>
				<cfset variables.localhandler=createObject("component","#application.configBean.getWebRootMap()#.#variables.rsSites.siteID#.includes.eventHandler").init()>
				<cfif structKeyExists(variables.localhandler,"onApplicationLoad")>		
						<cfset variables.pluginEvent.setValue("siteID",variables.rsSites.siteID)>
						<cfset variables.pluginEvent.loadSiteRelatedObjects()>
						<cfset variables.localhandler._objectName="#application.configBean.getWebRootMap()#.#variables.rsSites.siteID#.includes.eventHandler">
						<cfset variables.tracepoint=application.pluginManager.initTracepoint("#variables.localhandler._objectName#.onApplicationLoad")>
						<cfset variables.localhandler.onApplicationLoad(event=variables.pluginEvent,$=variables.pluginEvent.getValue("muraScope"),mura=variables.pluginEvent.getValue("muraScope"))>
						<cfset application.pluginManager.commitTracepoint(variables.tracepoint)>
				</cfif>
			</cfif>
			<cfset variables.siteBean=application.settingsManager.getSite(variables.rsSites.siteid)>
			<cfset variables.expandedPath=expandPath(variables.siteBean.getThemeIncludePath()) & "/eventHandler.cfc">
			<cfif fileExists(variables.expandedPath)>
				<cfset variables.themeHandler=createObject("component","#variables.siteBean.getThemeAssetMap()#.eventHandler").init()>
				<cfif structKeyExists(variables.themeHandler,"onApplicationLoad")>		
						<cfset variables.pluginEvent.setValue("siteID",variables.rsSites.siteID)>
						<cfset variables.pluginEvent.loadSiteRelatedObjects()>
						<cfset variables.themeHandler._objectName="#variables.siteBean.getThemeAssetMap()#.eventHandler">
						<cfset variables.tracepoint=application.pluginManager.initTracepoint("#variables.themeHandler._objectName#.onApplicationLoad")>
						<cfset variables.themeHandler.onApplicationLoad(event=variables.pluginEvent,$=variables.pluginEvent.getValue("muraScope"),mura=variables.pluginEvent.getValue("muraScope"))>
						<cfset application.pluginManager.commitTracepoint(variables.tracepoint)>
				</cfif>
				<cfset application.pluginManager.addEventHandler(variables.themeHandler,variables.rsSites.siteID)>
			</cfif>	
		</cfloop>

		<!--- This looks for and update File and Link nodes that legacy urls --->
		<cfquery name="variables.legacyURLs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDbUserName()#" password="#application.configBean.getDbPassword()#">
			select contenthistID, contentID,parentId,siteID,filename,urlTitle,filename from tcontent where type in ('File','Link')
			and active=1
			and body is null
			and filename is not null
		</cfquery>
		
		<cfset variables.legacyURLsIterator=application.serviceFactory.getBean("contentIterator").setQuery(variables.legacyURLs)>

		<cfloop condition="variables.legacyURLsIterator.hasNext()">
			<cfset variables.item=variables.legacyURLsIterator.next()>

			<cfquery  datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDbUserName()#" password="#application.configBean.getDbPassword()#">
				update tcontent set body=filename where 
				contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.item.getContentID()#">
				and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.item.getSiteID()#">
				and body is null
			</cfquery>

			<cfset application.serviceFactory.getBean("contentUtility").setUniqueFilename(variables.item)>

			<cftry>
				<cfquery  datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDbUserName()#" password="#application.configBean.getDbPassword()#">
					update tcontent set filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.item.getFilename()#">,
					urlTitle=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.item.getURLTitle()#">  where 
					contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.item.getContentID()#">
					and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.item.getSiteID()#">
				</cfquery>
				<cfcatch>
					<cfthrow message="An error occured trying to create a filename for #variables.item.getFilename()#">
				</cfcatch>
			</cftry>
		</cfloop>

		<!--- Clean root admin directory --->
		<cfdirectory action="list" directory="#expandPath('/muraWRM/admin/')#" name="local.rs">
		<cfset local.tempDir=expandPath('/muraWRM/admin/temp/')>
		<cfset local.fileWriter=application.serviceFactory.getBean('fileWriter')>
		<cfloop query="local.rs">
			<cfif not listFind('.gitignore,Application.cfc,assets,common,core,framework.cfc,index.cfm,temp,custom',local.rs.name)>
				<cftry>
				<cfset local.fileWriter.touchDir(local.tempDir)>
				<cfif local.rs.type eq 'dir'>
					<cfset local.fileWriter.renameDir(directory=local.rs.directory & "/" & local.rs.name,newDirectory=local.rs.directory & "/temp/" & local.rs.name )>
				<cfelse>
					<cfset local.fileWriter.renameFile(source=local.rs.directory & "/" & local.rs.name,destination=local.rs.directory & "/temp/" & local.rs.name )>
				</cfif>
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
		</cfloop>

		<cfset local.bundleLoc=expandPath("/muraWRM/config/setup/deploy/bundle.zip")>
		<cfif fileExists(local.bundleLoc) and application.contentGateway.getPageCount('default').counter eq 1>
				<cfset application.settingsManager.restoreBundle(
						bundleFile=local.bundleLoc, 
						keyMode='publish',
						siteID='default',
						contentMode='all',
						pluginMode='all'
					)>
				<cfset application.serviceFactory.getBean('fileWriter').renameFile(source=local.bundleLoc,destination=expandPath("/muraWRM/config/setup/deploy/#createUUID()#.zip"))>
		</cfif>

		<cfset application.sessionTrackingThrottle=false>
	
	</cfif>	
</cflock>
</cfif>	 