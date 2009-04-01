<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

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

<cfparam name="application.appInitializedTime" default="" />
<cfparam name="application.appInitialized" default="false" />
<cfparam name="application.appReloadKey" default="appreload" />
<cfparam name="application.broadcastInit" default="true" />


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
]			<cfset application.contentManager=application.serviceFactory.getBean("contentManager") />
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
			<cfset application.rbFactory=application.serviceFactory.getBean("resourceBundleFactory") />
			<cfset application.pluginManager=application.serviceFactory.getBean("pluginManager") />
			<cfset application.clusterManager=application.serviceFactory.getBean("clusterManager") />
			
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

<!--- make sure that a locale and language resouce bundle have been set in the users session --->
<cfparam name="session.datekey" default=""/>
<cfparam name="session.datekeyformat" default=""/>
<cfparam name="session.rb" default=""/>
<cfparam name="session.locale" default=""/>

<!---  session.rb is used to tell mura what resource bundle to use for lan translations --->
<cfif not Len(session.rb)>
	<cfif application.configBean.getDefaultLocale() neq "Server">
		<cfif application.configBean.getDefaultLocale() eq "Client">
			<cfset session.rb=listFirst(cgi.HTTP_ACCEPT_LANGUAGE,';') />		
		<cfelse>
			<cfif listFind(server.coldfusion.supportedlocales,application.configBean.getDefaultLocale())>
				<cfset session.rb=application.configBean.getDefaultLocale() />
			<cfelse>
				<cfset session.rb=application.rbFactory.CF2Java(application.configBean.getDefaultLocale()) />
			</cfif>
		</cfif>
	<cfelse>

		<cfset session.rb=application.rbFactory.CF2Java(getLocale()) />
	</cfif>
</cfif>


<!--- session.locale  is the locale that mura uses for date formating --->
<cfif not len(session.locale)>
	<cfif application.configBean.getDefaultLocale() neq "Server">
		<cfif application.configBean.getDefaultLocale() eq "Client">
			<cfset session.locale=listFirst(cgi.HTTP_ACCEPT_LANGUAGE,';') />
			<cfset session.dateKey=""/>
			<cfset session.dateKeyFormat=""/>		
		<cfelse>
			<cfset session.locale=application.configBean.getDefaultLocale() />
			<cfset session.dateKey=""/>
		</cfif>
	<cfelse>

		<cfset session.locale=getLocale() />
		<cfset session.dateKey=""/>
		<cfset session.dateKeyFormat=""/>
	</cfif>
</cfif>

<!--- set locale for current page request --->
<cfset setLocale(session.locale) />

<!--- now we create a date so we can parse it and figure out the date format and then create a date validation key --->
<cfif not len(session.dateKey) or not len(session.dateKeyFormat)>
	<cfset formatTest=LSDateFormat(createDate(2012,11,10),'short')/>
	<cfif find(".",formatTest)>
		<cfset dtCh=	"."/>
	<cfelseif find("-",formatTest)>
		<cfset dtCh=	"-"/>
	<cfelse>
		<cfset dtCh=	"/"/>
	</cfif>
	<cfset dtFormat=""/>
	<cfset session.dateKeyFormat=""/>
	<cfloop list="#formatTest#" index="f" delimiters="#dtCh#">
		<cfif listFind("2012,12",f)>	
			<cfset session.dateKeyFormat=listAppend(session.dateKeyFormat,"YYYY",dtCh)>
		<cfelseif f eq 11>
			<cfset session.dateKeyFormat=listAppend(session.dateKeyFormat,"MM",dtCh)>
		<cfelse>
			<cfset session.dateKeyFormat=listAppend(session.dateKeyFormat,"DD",dtCh)>
		</cfif>
	</cfloop>
	
	<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"11",dtCh) -1) />
	<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"10",dtCh) -1) />
	<cfif listFind(formatTest,"2012",dtCh)>
		<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"2012",dtCh) -1) />
	<cfelseif listFind(formatTest,"12",dtCh)>
		<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"12",dtCh) -1) />
	</cfif>
	
	<cfset exampleDate=LSDateFormat(now(),session.dateKeyFormat)/>
<cfsavecontent variable="session.dateKey">
<cfoutput><script type="text/javascript">
var dtExample="#exampleDate#";
var dtCh="#dtCh#";
var dtFormat =[#dtFormat#];
</script></cfoutput>
</cfsavecontent>

</cfif>

<cfinclude template="settings.custom.vars.cfm">
<cfset application.pluginManager.executeScripts('onGlobalRequestStart')>
</cfsilent>