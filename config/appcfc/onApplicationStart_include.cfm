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
<cfparam name="application.CFVersion" default="#Left(SERVER.COLDFUSION.PRODUCTVERSION,Find(",",SERVER.COLDFUSION.PRODUCTVERSION)-1)#" />

<cfprocessingdirective pageencoding="utf-8"/>
<cfsetting requestTimeout = "1000"> 

<!--- do a settings setup check --->
<cfif NOT structKeyExists( application, "setupComplete" ) OR (not application.appInitialized or structKeyExists(url,application.appReloadKey) )>
	<cfif getProfileString( baseDir & "/config/settings.ini.cfm", "settings", "mode" ) eq "production">
		<cfif directoryExists( baseDir & "/config/setup" )>
			<cfset structDelete( application, "setupComplete") />
			<!--- check the settings --->
			<cfparam name="cookie.setupSubmitButton" default="A#hash( createUUID() )#" />
			<cfparam name="cookie.setupSubmitButtonComplete" default="A#hash( createUUID() )#" />
			
			<cfif trim( getProfileString( baseDir & "/config/settings.ini.cfm" , "production", "datasource" ) ) IS NOT ""
					AND (
						NOT isDefined( "FORM.#cookie.setupSubmitButton#" )
						AND
						NOT isDefined( "FORM.#cookie.setupSubmitButtonComplete#" )
						)
				>		
						
				<cfset application.setupComplete = true />
			<cfelse>
				<!--- check to see if the index.cfm page exists in the setup folder --->
				<cfif NOT fileExists( baseDir & "/config/setup/index.cfm" )>
					<cfthrow message="Your setup directory is incomplete. Please reset it up from the Mura source." />
				</cfif>
					
				<cfset renderSetup = true />
				<!--- go to the index.cfm page (setup) --->
				<cfinclude template="/muraWRM/config/setup/index.cfm"><cfabort>
				</cfif>	
			</cfif>
	<cfelse>		
		<cfset application.setupComplete=true>
	</cfif>
</cfif>	

<cfif (not application.appInitialized or structKeyExists(url,application.appReloadKey))>
	<cflock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200">	
		
		<cfset request.muraShowTrace=true>
		
		<cfset variables.iniPath = "#baseDir#/config/settings.ini.cfm" />
		
		<cfset variables.iniSections=getProfileSections(variables.iniPath)>
		
		<cfset variables.iniProperties=structNew()>
		<cfloop list="#variables.iniSections.settings#" index="p">
			<cfset variables.iniProperties[p]=getProfileString("#baseDir#/config/settings.ini.cfm","settings",p)>			
			<cfif left(variables.iniProperties[p],2) eq "${"
				and right(variables.iniProperties[p],1) eq "}">
				<cfset variables.iniProperties[p]=mid(variables.iniProperties[p],3,len(variables.iniProperties[p])-3)>
				<cfset variables.iniProperties[p] = evaluate(variables.iniProperties[p])>
			</cfif>		
		</cfloop>		
		
		<cfloop list="#variables.iniSections[ variables.iniProperties.mode]#" index="p">
			<cfset variables.iniProperties[p]=getProfileString("#baseDir#/config/settings.ini.cfm", variables.iniProperties.mode,p)>
			<cfif left(variables.iniProperties[p],2) eq "${"
				and right(variables.iniProperties[p],1) eq "}">
				<cfset variables.iniProperties[p]=mid(variables.iniProperties[p],3,len(variables.iniProperties[p])-3)>
				<cfset variables.iniProperties[p] = evaluate(variables.iniProperties[p])>
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
		
		<cfset tracer=createObject("component","mura.cfobject").init()>
	
		<!--- load the core services.xml --->
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating ColdSpring")> 
		<cfset variables.serviceFactory=createObject("component","mura.bean.beanFactory").init(defaultProperties=variables.iniProperties) />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Loading Coldspring XML")> 
		<cfset variables.serviceFactory.loadBeansFromXMLRaw(servicesXML,true) />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<!--- If coldspring.custom.xml.cfm exists read it in an check it it is valid xml--->
		<cfif fileExists(expandPath("/muraWRM/config/coldspring.custom.xml.cfm"))>	
			<cffile action="read" variable="customServicesXML" file="#expandPath('/muraWRM/config/coldspring.custom.xml.cfm')#">
			<cfif not findNoCase("<!-" & "--",customServicesXML)>
				<cfif not findNoCase("<beans>",customServicesXML)>
					<cfset customServicesXML= "<beans>" & customServicesXML & "</beans>">
				</cfif>
				<cfset customServicesXML=replaceNoCase(customServicesXML, "##mapdir##","mura","ALL")>
				<cfset tracePoint=tracer.initTracePoint("Loading Custom Coldspring XML")> 
				<cfset variables.serviceFactory.loadBeansFromXMLRaw(customServicesXML,true) />
				<cfset tracer.commitTracePoint(tracePoint)>
			</cfif>
		</cfif>
		
		<cfset application.serviceFactory=variables.serviceFactory>
		
		<cfobjectcache action="clear" />
		<cfset tracePoint=tracer.initTracePoint("Instantiating ConfigBean")> 
		<cfset application.configBean=application.serviceFactory.getBean("configBean") />
		<cfset application.configBean.set(variables.iniProperties)>
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<!---You can create an onGlobalConfig.cfm file that runs after the initial configBean loads, but before anything else is loaded --->
		<cfif fileExists(ExpandPath("/muraWRM/config/onGlobalConfig.cfm"))>
			<cfinclude template="/muraWRM/config/onGlobalConfig.cfm">
		</cfif>
		
		<cfif application.configBean.getValue("applyDBUpdates") or application.appAutoUpdated>
			<cfset tracePoint=tracer.initTracePoint("Checking/Applying DB updates")> 
			<cfset application.configBean.applyDbUpdates() />
			<cfset tracer.commitTracePoint(tracePoint)>
		</cfif>
		
		<cfset application.appAutoUpdated=false>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating settingsManager")> 
		<cfset application.settingsManager=application.serviceFactory.getBean("settingsManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating pluginManager")> 
		<cfset application.pluginManager=application.serviceFactory.getBean("pluginManager") />
		<cfset application.eventManager= application.pluginManager />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating contentManager")> 
		<cfset application.contentManager=application.serviceFactory.getBean("contentManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating utility")> 
		<cfset application.utility=application.serviceFactory.getBean("utility") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating permUtility")> 
		<cfset application.permUtility=application.serviceFactory.getBean("permUtility") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating contentUtility")> 
		<cfset application.contentUtility=application.serviceFactory.getBean("contentUtility") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating contentRenderer")> 
		<cfset application.contentRenderer=application.serviceFactory.getBean("contentRenderer") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating contentGateway")> 
		<cfset application.contentGateway=application.serviceFactory.getBean("contentGateway") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating emailManager")> 
		<cfset application.emailManager=application.serviceFactory.getBean("emailManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating loginManager")> 
		<cfset application.loginManager=application.serviceFactory.getBean("loginManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating mailinglistManager")> 
		<cfset application.mailinglistManager=application.serviceFactory.getBean("mailinglistManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating userManager")> 
		<cfset application.userManager=application.serviceFactory.getBean("userManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating dataCollectionManager")> 
		<cfset application.dataCollectionManager=application.serviceFactory.getBean("dataCollectionManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating categoryManager")> 
		<cfset application.advertiserManager=application.serviceFactory.getBean("advertiserManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating categoryManager")> 
		<cfset application.categoryManager=application.serviceFactory.getBean("categoryManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating feedManager")> 
		<cfset application.feedManager=application.serviceFactory.getBean("feedManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating sessionTrackingManager")> 
		<cfset application.sessionTrackingManager=application.serviceFactory.getBean("sessionTrackingManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating favoriteManager")> 
		<cfset application.favoriteManager=application.serviceFactory.getBean("favoriteManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating raterManager")> 
		<cfset application.raterManager=application.serviceFactory.getBean("raterManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfsavecontent variable="variables.temp"><cfoutput><cfinclude template="/mura/bad_words.txt"></cfoutput></cfsavecontent>
		<cfset application.badwords = ReReplaceNoCase(variables.temp, "," , "|" , "ALL")/> 
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating dashboardManager")> 
		<cfset application.dashboardManager=application.serviceFactory.getBean("dashboardManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating classExtensionManager")> 
		<cfset application.classExtensionManager=application.configBean.getClassExtensionManager() />
		<cfset application.classExtensionManager.setContentRenderer(application.contentRenderer)>
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating resourceBundleFactory")> 
		<cfset application.rbFactory=application.serviceFactory.getBean("resourceBundleFactory") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating clusterManager")> 
		<cfset application.clusterManager=application.serviceFactory.getBean("clusterManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating contentServer")> 
		<cfset application.contentServer=application.serviceFactory.getBean("contentServer") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating changesetManager")> 
		<cfset application.changesetManager=application.serviceFactory.getBean("changesetManager") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating autoUpdater")> 
		<cfset application.autoUpdater=application.serviceFactory.getBean("autoUpdater") />
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<cfset tracePoint=tracer.initTracePoint("Instantiating scriptProtectionFilter")> 
		<cfset application.scriptProtectionFilter=application.serviceFactory.getBean("scriptProtectionFilter") >
		<cfset tracer.commitTracePoint(tracePoint)>
		
		<!---settings.custom.managers.cfm reference is for backwards compatibility --->
		<cfif fileExists(ExpandPath("/muraWRM/config/settings.custom.managers.cfm"))>
			<cfinclude template="/muraWRM/config/settings.custom.managers.cfm">
		</cfif>		
					
		<cfset baseDir=expandPath("/muraWRM")/>
					
		<cfif StructKeyExists(SERVER,"bluedragon") and not findNoCase("Windows",server.os.name)>
			<cfset mapPrefix="$" />
		<cfelse>
			<cfset mapPrefix="" />
		</cfif>
		
		<cfif len(application.configBean.getValue('encryptionKey'))>
			<cfset application.encryptionKey=application.configBean.getValue('encryptionKey')>
		</cfif>
					
		<cfdirectory action="list" directory="#baseDir#/requirements/" name="rsRequirements">
	
		<cfloop query="rsRequirements">
			<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn' and not structKeyExists(this.mappings,"/#rsRequirements.name#")>
				<cfset application.serviceFactory.getBean("fileWriter").appendFile(file="#baseDir#/config/mappings.cfm", output='<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & BaseDir & "/requirements/#rsRequirements.name#">')>				
			</cfif>
		</cfloop>	

		<cfif application.configBean.getValue("autoDiscoverPlugins") and not isdefined("url.safemode")>
			<cfset application.pluginManager.discover()>
		</cfif>
		
		<cfset application.cfstatic=structNew()>			
		<cfset application.appInitialized=true/>
		<cfset application.appInitializedTime=now()>
		<cfif application.broadcastInit>
			<cfset application.clusterManager.reload()>
		</cfif>
		<cfset application.broadcastInit=true/>
		<cfset structDelete(application,"muraAdmin")>
		<cfset structDelete(application,"proxyServices")>
		<cfset structDelete(application,"CKFinderResources")>
		
		<!--- Set up scheduled tasks --->
		<cfif (len(application.configBean.getServerPort())-1) lt 1>
			<cfset port=80/>
		<cfelse>
			<cfset port=right(application.configBean.getServerPort(),len(application.configBean.getServerPort())-1) />
		</cfif>
			
		<cfif application.configBean.getCompiler() eq "Railo">
			<cfset siteMonitorTask="siteMonitor"/>
		<cfelse>
			<cfset siteMonitorTask="#application.configBean.getWebRoot()#/tasks/siteMonitor.cfm"/>
		</cfif>
			
		<cftry>
			<cfif variables.iniProperties.ping eq 1>
				<cfschedule action = "update"
					task = "#siteMonitorTask#"
					operation = "HTTPRequest"
					url = "http://#listFirst(cgi.http_host,":")##application.configBean.getContext()#/tasks/siteMonitor.cfm"
					port="#port#"
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
		
		<cfif not fileExists(baseDir & "/robots.txt")>	
			<cfset application.serviceFactory.getBean("fileWriter").copyFile(source="#baseDir#/config/templates/robots.template.cfm", destination="#baseDir#/robots.txt")>
		</cfif>
		
		<cfset pluginEvent=createObject("component","mura.event").init()>			
		<cfset application.pluginManager.executeScripts(runat='onApplicationLoad',event= pluginEvent)>
				
		<!--- Fire local onApplicationLoad events--->
		<cfset rsSites=application.settingsManager.getList() />
		<cfloop query="rsSites">	
			<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#rsSites.siteID#/includes/eventHandler.cfc")>
				<cfset localHandler=createObject("component","#application.configBean.getWebRootMap()#.#rsSites.siteID#.includes.eventHandler").init()>
				<cfif structKeyExists(localHandler,"onApplicationLoad")>		
						<cfset pluginEvent.setValue("siteID",rsSites.siteID)>
						<cfset pluginEvent.loadSiteRelatedObjects()>
						<cfset localHandler._objectName="#application.configBean.getWebRootMap()#.#rsSites.siteID#.includes.eventHandler">
						<cfset tracePoint=application.pluginManager.initTracePoint("#localHandler._objectName#.onApplicationLoad")>
						<cfset localHandler.onApplicationLoad(event=pluginEvent,$=pluginEvent.getValue("muraScope"),mura=pluginEvent.getValue("muraScope"))>
						<cfset application.pluginManager.commitTracePoint(tracePoint)>
				</cfif>
			</cfif>
			<cfset siteBean=application.settingsManager.getSite(rsSites.siteid)>
			<cfset expandedPath=expandPath(siteBean.getThemeIncludePath()) & "/eventHandler.cfc">
			<cfif fileExists(expandedPath)>
				<cfset themeHandler=createObject("component","#siteBean.getThemeAssetMap()#.eventHandler").init()>
				<cfif structKeyExists(themeHandler,"onApplicationLoad")>		
						<cfset pluginEvent.setValue("siteID",rsSites.siteID)>
						<cfset pluginEvent.loadSiteRelatedObjects()>
						<cfset themeHandler._objectName="#siteBean.getThemeAssetMap()#.eventHandler">
						<cfset tracePoint=application.pluginManager.initTracePoint("#themeHandler._objectName#.onApplicationLoad")>
						<cfset themeHandler.onApplicationLoad(event=pluginEvent,$=pluginEvent.getValue("muraScope"),mura=pluginEvent.getValue("muraScope"))>
						<cfset application.pluginManager.commitTracePoint(tracePoint)>
				</cfif>
				<cfset application.pluginManager.addEventHandler(themeHandler,rsSites.siteID)>
			</cfif>	
		</cfloop>
		
		<cfset application.sessionTrackingThrottle=false>
	</cflock>
</cfif>		