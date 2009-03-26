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
<cfprocessingdirective pageencoding="utf-8">
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
<cfparam name="application.appLoadList" default="" />
<cfparam name="application.appReloadKey" default="appreload" />
<cfparam name="application.appStarting" default="false" />

<cfif not IsDefined("Cookie.CFID") AND IsDefined("Session.CFID")>
	<cfcookie name="CFID" value="#Session.CFID#">
	<cfcookie name="CFTOKEN" value="#Session.CFTOKEN#">
</cfif>

<cfif isdefined('url.override')>
	<cfset application.appStarting=false/>
</cfif>

<!--- <cfif (not application.appInitialized or isdefined('url.#application.appReloadKey#')) and not application.appStarting> --->
<cfif (not application.appInitialized or isdefined('url.#application.appReloadKey#'))>
<!--- 	<cftry> --->

	<cfset variables.iniPath="#getDirectoryFromPath(getCurrentTemplatePath())#settings.ini.cfm" />

	<!--- <cflock name="startApp" timeout="500">
		<cfset application.appStarting=true />
	</cflock> --->
	
	<cfif isdefined('url.#application.appReloadKey#')>
		<cfparam name="url.loadlist" default="" />
		<cfset application.appLoadList=url.loadList />
	</cfif>

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
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"settingsManager")>
				<cfset application.settingsManager=application.serviceFactory.getBean("settingsManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"contentManager")>
				<cfset application.contentManager=application.serviceFactory.getBean("contentManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"utility")>
				<cfset application.utility=application.serviceFactory.getBean("utility") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"permUtility")>
				<cfset application.permUtility=application.serviceFactory.getBean("permUtility") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"contentUtility")>
				<cfset application.contentUtility=application.serviceFactory.getBean("contentUtility") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"contentRenderer")>
				<cfset application.contentRenderer=application.serviceFactory.getBean("contentRenderer") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"contentGateway")>
				<cfset application.contentGateway=application.serviceFactory.getBean("contentGateway") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"emailManager")>
				<cfset application.emailManager=application.serviceFactory.getBean("emailManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"loginManager")>
				<cfset application.loginManager=application.serviceFactory.getBean("loginManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"mailingListManager")>
				<cfset application.mailinglistManager=application.serviceFactory.getBean("mailinglistManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"userManager")>
				<cfset application.userManager=application.serviceFactory.getBean("userManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"dataCollectionManager")>
				<cfset application.dataCollectionManager=application.serviceFactory.getBean("dataCollectionManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"advertiserManager")>
				<cfset application.advertiserManager=application.serviceFactory.getBean("advertiserManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"categoryManager")>
				<cfset application.categoryManager=application.serviceFactory.getBean("categoryManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"feedManager")>
				<cfset application.feedManager=application.serviceFactory.getBean("feedManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"sessionTrackingManager")>
				<cfset application.sessionTrackingManager=application.serviceFactory.getBean("sessionTrackingManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"favoriteManager")>
				<cfset application.favoriteManager=application.serviceFactory.getBean("favoriteManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"raterManager")>
				<cfset application.raterManager=application.serviceFactory.getBean("raterManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"badwords")>
				<cfsavecontent variable="variables.temp"><cfoutput><cfinclude template="/mura/bad_words.txt"></cfoutput></cfsavecontent>
				<cfset application.badwords = ReReplaceNoCase(variables.temp, "," , "|" , "ALL")/> 
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"dashboardManager")>
				<cfset application.dashboardManager=application.serviceFactory.getBean("dashboardManager") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"flushCache")>
				<cfset application.utility.flushCache('')/>
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"classExtensionManager")>
				<cfset application.classExtensionManager=application.configBean.getClassExtensionManager() />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"rbFactory")>
				<cfset application.rbFactory=application.serviceFactory.getBean("resourceBundleFactory") />
			</cfif>
			
			<cfif application.appLoadList eq "" or listFindNoCase(application.appLoadList,"pluginManager")>
				<cfset application.pluginManager=application.serviceFactory.getBean("pluginManager") />
			</cfif>

			<cfinclude template="settings.custom.managers.cfm">
	 	
			<cfquery name="variables.checkMe" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" timeout="5">
			SELECT * FROM tglobals
			</cfquery>
			
			<cfif isdefined('url.#application.appReloadKey#') 
				or not isdate(variables.Checkme.appreload)
				or not isdate(application.appInitializedTime)>
				
				<cfif not isdate(variables.Checkme.appreload) or isdefined('url.#application.appReloadKey#')>
					<cfset application.appInitializedTime=now()/>
					<cfset application.utility.broadcastAppreload(application.appInitializedTime,application.appLoadList)/>
				<cfelse>
					<cfset application.appInitializedTime=variables.Checkme.appreload/>
					<cfset application.appLoadList=variables.Checkme.loadList />
				</cfif>
			<cfelse>
				<cfset application.appInitializedTime=variables.Checkme.appreload/>
				<cfset application.appLoadList=variables.Checkme.loadList />
			</cfif>
			
			<cfset application.appInitialized=true/>
			
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
	<!---<cfset structClear( session ) />--->

	<cflock name="startApp" timeout="500">
		<cfset application.appStarting=false />
	</cflock>
	
	<!--- <cfcatch>
		<cflock name="startApp" timeout="500">
			<cfset application.appStarting=false />
		</cflock>
	</cfcatch>
	</cftry> --->

<cfelseif application.appStarting>
	<cfinclude template="appStarting.html">
	<cfabort>
</cfif>


<!--- <cftry> --->
	<cfquery name="variables.checkMe" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" timeout="5">
		SELECT * FROM tglobals
	</cfquery>
	
	<cfif isdate(variables.checkMe.appreload)  and application.appInitializedTime lt variables.checkMe.appreload>
		<cfset application.appInitialized=false />
		<cfset application.appLoadList=variables.checkMe.loadList />
	</cfif>
<!--- <cfcatch>
		<cfinclude template="error.html">
		<cfabort>
	</cfcatch>
</cftry>  --->

<cfif cookie.userid eq '' and session.rememberMe eq 1 and getAuthUser() neq ''>
<cfcookie name="userid" value="#listFirst(getAuthUser(),'^')#" expires="never" />
<cfcookie name="userHash" value="#application.userManager.readUserHash(listFirst(getAuthUser(),'^')).userHash#" expires="never" />
</cfif>

<cfif cookie.userid neq '' and getAuthUser() eq ''>
<cfset application.loginManager.rememberMe(cookie.userid,cookie.userHash) />
</cfif>

<cfif cookie.userid neq '' and session.rememberMe eq 0 and getAuthUser() neq ''>
<cfcookie name="userid" value="" expires="never" />
<cfcookie name="userHash" value="" expires="never" />
</cfif>

<cfif not isDefined('cookie.originalURLToken')>
<cfparam name="session.trackingID" default="#application.utility.getUUID()#">
<cfcookie name="originalURLToken" value="#session.trackingID#" expires="never" />
</cfif>

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

<!---  session.rb is used to tell sava what resource bundle to use for lan translations --->
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


<!--- session.locale  is the locale that sava uses for date formating --->
<cfif not Len(session.locale)>
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
<!--- <cfscript>
theurl="jdbc:oracle:thin:@10.211.55.3:1521:XE";
user="muradb";
password="7uca$99";

props = CreateObject("java", "java.util.Properties").init();
props.put("user", user );
props.put("password", password);
props.put("SetBigStringTryClob", "true");

con = CreateObject("java", "java.sql.DriverManager").getConnection( theurl, props ); 

</cfscript> --->
<cfinclude template="settings.custom.vars.cfm">
<cfset application.pluginManager.executeScripts('onGlobalRequestStart')>
</cfsilent>