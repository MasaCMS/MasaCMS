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

<cfparam name="application.appInitializedTime" default="" />
<cfparam name="application.appInitialized" default="false" />
<cfparam name="application.appReloadKey" default="appreload" />
<cfparam name="application.broadcastInit" default="true" />

<cfparam name="session.setupSubmitButton" default="A#hash( createUUID() )#" />
<cfparam name="session.setupSubmitButtonComplete" default="A#hash( createUUID() )#" />
<!--- do a settings setup check --->
<cfif NOT structKeyExists( application, "setupComplete" ) OR (not application.appInitialized or structKeyExists(url,application.appReloadKey) )>
	<cfif directoryExists( "#getDirectoryFromPath( getCurrentTemplatePath() )#setup" )>
		<cfset structDelete( application, "setupComplete") />
		<!--- check the settings --->
		<cfif trim( getProfileString( getDirectoryFromPath( getCurrentTemplatePath() ) & "settings.ini.cfm", "production", "datasource" ) ) IS NOT ""
			AND (
				NOT isDefined( "FORM.#session.setupSubmitButton#" )
				AND
				NOT isDefined( "FORM.#session.setupSubmitButtonComplete#" )
				)
			>						
			<cfset application.setupComplete = true />
		<cfelse>
			<!--- check to see if the index.cfm page exists in the setup folder --->
			<cfif NOT fileExists( "#getDirectoryFromPath( getCurrentTemplatePath() )#setup/index.cfm" )>
				<cfthrow message="Your setup directory is incomplete. Please reset it up from the Mura source." />
			</cfif>
			
			<cfset renderSetup = true />
			<!--- go to the index.cfm page (setup) --->
			<cfinclude template="setup/index.cfm"><cfabort>
		</cfif>
		
	</cfif>
</cfif>	

<cfsilent>
<cfprocessingdirective pageencoding="utf-8"/>
<cfsetting requestTimeout = "1000">
<cfset server.enable21=true>

<cfparam name="session.rememberMe" type="numeric" default="0" />
<cfparam name="session.loginAttempts" type="numeric" default="0" />
<cfparam name="session.blockLoginUntil" type="string" default="" />

<cfif not StructKeyExists(cookie, 'userid')>
   <cfcookie name="userid" expires="never" value="">
</cfif>

<cfif not StructKeyExists(cookie, 'userHash')>
   <cfcookie name="userHash" expires="never" value="">
</cfif>


<cfif not IsDefined("Cookie.CFID") AND IsDefined("Session.CFID")>
	<cfcookie name="CFID" value="#Session.CFID#">
	<cfcookie name="CFTOKEN" value="#Session.CFTOKEN#">
</cfif>

<cfif (not application.appInitialized or structKeyExists(url,application.appReloadKey))>

	<cfset variables.iniPath="#getDirectoryFromPath(getCurrentTemplatePath())#settings.ini.cfm" />
	<cfset application.appReloadKey=GetProfileString("#getDirectoryFromPath(getCurrentTemplatePath())#settings.ini.cfm", "settings", "appReloadKey") />
	<cfset variables.mode=GetProfileString("#variables.iniPath#", "settings", "mode") />
	<cfset variables.mapdir=GetProfileString("#variables.iniPath#", mode, "mapdir") />
	<cfset variables.webroot= getDirectoryFromPath(getCurrentTemplatePath()) />
	<cfset variables.webroot=left(variables.webroot,len(variables.webroot)-8)>
	
	<cfinclude template="coldspring.xml.cfm">
	
	<cfset application.serviceFactory=createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset application.serviceFactory.loadBeansFromXMLRaw(servicesXML,true) />

	<cflock name="appInitBlock" type="exclusive" timeout="200">
			
			<cfobjectcache action="clear" />
			<cfset application.configBean=application.serviceFactory.getBean("configBean") />
			<cfset application.settingsManager=application.serviceFactory.getBean("settingsManager") />
			<cfset application.pluginManager=application.serviceFactory.getBean("pluginManager") />
			<cfset application.contentManager=application.serviceFactory.getBean("contentManager") />
			<cfset application.utility=application.serviceFactory.getBean("utility") />
			<cfset application.permUtility=application.serviceFactory.getBean("permUtility") />
			<cfset application.contentUtility=application.serviceFactory.getBean("contentUtility") />
			<cfset application.contentRenderer=application.serviceFactory.getBean("contentRenderer") />
			<cfset application.contentGateway=application.serviceFactory.getBean("contentGateway") />
			<cfset application.emailManager=application.serviceFactory.getBean("emailManager") />
			<cfset application.loginManager=application.serviceFactory.getBean("loginManager") />
			<cfset application.mailinglistManager=application.serviceFactory.getBean("mailinglistManager") />
			<cfset application.userManager=application.serviceFactory.getBean("userManager") />
			<cfset application.dataCollectionManager=application.serviceFactory.getBean("dataCollectionManager") />
			<cfset application.advertiserManager=application.serviceFactory.getBean("advertiserManager") />
			<cfset application.categoryManager=application.serviceFactory.getBean("categoryManager") />
			<cfset application.feedManager=application.serviceFactory.getBean("feedManager") />
			<cfset application.sessionTrackingManager=application.serviceFactory.getBean("sessionTrackingManager") />
			<cfset application.favoriteManager=application.serviceFactory.getBean("favoriteManager") />
			<cfset application.raterManager=application.serviceFactory.getBean("raterManager") />
			<cfsavecontent variable="variables.temp"><cfoutput><cfinclude template="/mura/bad_words.txt"></cfoutput></cfsavecontent>
			<cfset application.badwords = ReReplaceNoCase(variables.temp, "," , "|" , "ALL")/> 
			<cfset application.dashboardManager=application.serviceFactory.getBean("dashboardManager") />
			<cfset application.classExtensionManager=application.configBean.getClassExtensionManager() />
			<cfset application.classExtensionManager.setContentRenderer(application.contentRenderer)>
			<cfset application.rbFactory=application.serviceFactory.getBean("resourceBundleFactory") />
			<cfset application.clusterManager=application.serviceFactory.getBean("clusterManager") />
			<cfset application.contentServer=application.serviceFactory.getBean("contentServer") />
			
			<cfinclude template="settings.custom.managers.cfm">
	 	
			<cfset application.appInitialized=true/>
			
			<cfif application.broadcastInit>
				<cfset application.clusterManager.reload()>
			</cfif>
			<cfset application.broadcastInit=true/>
	</cflock>

	<!--- Set up scheduled tasks --->
	<cfif not len(application.configBean.getServerPort())>
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
	<cfif GetProfileString("#variables.iniPath#", mode, "ping") eq 1>	
	<cfschedule action = "update"
  		task = "#siteMonitorTask#"
 		operation = "HTTPRequest"
 		url = "http://#cgi.server_name##application.configBean.getContext()#/tasks/siteMonitor.cfm"
		port="#port#"
    		startDate = "#dateFormat(now(),'mm/dd/yyyy')#"
  		startTime = "#createTime(0,15,0)#"
  		publish = "No"
  		interval = "900"
 		requestTimeOut = "600">
	</cfif>
	<cfcatch></cfcatch>
	</cftry>

	<cfset application.pluginManager.executeScripts('onApplicationLoad')>

</cfif>

<cftry>
<cfif cookie.userid eq '' and structKeyExists(session,"rememberMe") and session.rememberMe eq 1 and getAuthUser() neq ''>
<cfcookie name="userid" value="#listFirst(getAuthUser(),'^')#" expires="never" />
<cfcookie name="userHash" value="#application.userManager.readUserHash(listFirst(getAuthUser(),'^')).userHash#" expires="never" />
</cfif>

<cfif cookie.userid neq '' and getAuthUser() eq ''>
<cfset application.loginManager.rememberMe(cookie.userid,cookie.userHash) />
</cfif>

<cfif cookie.userid neq '' and structKeyExists(session,"rememberMe") and session.rememberMe eq 0 and getAuthUser() neq ''>
<cfcookie name="userid" value="" expires="never" />
<cfcookie name="userHash" value="" expires="never" />
</cfif>

<cfif not structKeyExists(cookie,"originalURLToken")>
<cfparam name="session.trackingID" default="#application.utility.getUUID()#">
<cfcookie name="originalURLToken" value="#session.trackingID#" expires="never" />
</cfif>
<cfcatch></cfcatch>
</cftry>

<cfif application.configBean.getDebuggingEnabled() eq "false">
	<cferror 
		template="error.html"
		mailto="#application.configBean.getMailserverusername()#"
		type="Exception">
</cfif>


<cfinclude template="settings.custom.vars.cfm">
<cfset application.pluginManager.executeScripts('onGlobalRequestStart')>
</cfsilent>