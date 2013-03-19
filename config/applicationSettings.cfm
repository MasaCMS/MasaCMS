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
	<cfparam name="request.muraFrontEndRequest" default="false"/>
	<cfparam name="request.muraChangesetPreview" default="false"/>
	<cfparam name="request.muraExportHtml" default="false"/>
	<cfparam name="request.muraMobileRequest" default="false"/>
	<cfparam name="request.muraHandledEvents" default="#structNew()#"/>
	<cfparam name="request.altTHeme" default=""/>
	<cfparam name="request.customMuraScopeKeys" default="#structNew()#"/>
	<cfparam name="request.muraTraceRoute" default="#arrayNew(1)#"/>
	<cfparam name="request.muraRequestStart" default="#getTickCount()#"/>
	<cfparam name="request.muraShowTrace" default="true"/>
	<cfparam name="request.muraValidateDomain" default="true"/>
	<cfparam name="request.muraAppreloaded" default="false"/>
	<cfparam name="request.muraDynamicContentError" default="false">

	<cffunction name="initTracePoint" output="false">
		<cfargument name="detail">
		<cfset var tracePoint=structNew()>
		<cfif not request.muraShowTrace>
			<cfreturn 0>
		</cfif>
		<cfset tracePoint.detail=arguments.detail>
		<cfset tracePoint.start=getTickCount()>
		<cfset arrayAppend(request.muraTraceRoute,tracePoint)> 
		<cfreturn arrayLen(request.muraTraceRoute)>
	</cffunction>

	<cffunction name="commitTracePoint" output="false">
		<cfargument name="tracePointID">
		<cfset var tracePoint="">
		<cfif arguments.tracePointID>
			<cfset tracePoint=request.muraTraceRoute[arguments.tracePointID]>
			<cfset tracePoint.stop=getTickCount()>
			<cfset tracePoint.duration=tracePoint.stop-tracePoint.start>
			<cfset tracePoint.total=tracePoint.stop-request.muraRequestStart>
		</cfif>	
	</cffunction>

	<cfset this.configPath=getDirectoryFromPath(getCurrentTemplatePath())>
	<!--- Application name, should be unique --->
	<cfset this.name = "mura" & hash(getCurrentTemplatePath()) />
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(3,0,0,0)>
	<!--- Where should cflogin stuff persist --->
	<cfset this.loginStorage = "cookie">
	
	<cfset this.sessionManagement = true>
	
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>
	
	<!--- should cookies be domain specific, ie, *.foo.com or www.foo.com 
	<cfset this.setDomainCookies = not refind('\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b',listFirst(cgi.http_host,":"))>
	--->
	<!--- should we try to block 'bad' input from users --->
	<cfset this.scriptProtect = false>
	<!--- should we secure our JSON calls? --->
	<cfset this.secureJSON = false>
	<!--- Should we use a prefix in front of JSON strings? --->
	<cfset this.secureJSONPrefix = "">
	<!--- Used to help CF work with missing files and dir indexes --->
	<cfset this.welcomeFileList = "">
	
	<cfset baseDir= left(this.configPath,len(this.configPath)-8) />
	<cfif not fileExists(baseDir & "/config/settings.ini.cfm")>
		<cfset variables.tracePoint=initTracePoint("Writing config/settings.ini.cfm")>
		<cftry>
		<cffile action="copy" source="#baseDir#/config/templates/settings.template.cfm" destination="#baseDir#/config/settings.ini.cfm" mode="777">
		<cfcatch>
			<cffile action="copy" source="#baseDir#/config/templates/settings.template.cfm" destination="#baseDir#/config/settings.ini.cfm">
		</cfcatch>
		</cftry>
		<cfset commitTracePoint(variables.tracePoint)>
	</cfif>

	<cfset this.baseDir=baseDir>
	<cfset variables.baseDir=baseDir>
		
	<cfset variables.tracePoint=initTracePoint("Reading config/settings.ini.cfm")>
	<cfset properties = createObject( 'java', 'java.util.Properties' ).init()>
	<cfset fileStream = createObject( 'java', 'java.io.FileInputStream').init( getDirectoryFromPath(getCurrentTemplatePath()) & "/settings.ini.cfm")>
	<cfset properties.load( fileStream )>
	<cfset fileStream.close()>
	<cfset commitTracePoint(variables.tracePoint)>

	<!--- define custom coldfusion mappings. Keys are mapping names, values are full paths  --->
	<cfif StructKeyExists(SERVER,"bluedragon") and not findNoCase("Windows",server.os.name)>
		<cfset mapPrefix="$" />
	<cfelse>
		<cfset mapPrefix="" />
	</cfif>

	<cfset this.mapPrefix=mapPrefix>
	<cfset variables.mapPrefix=mapPrefix>
	
	<cfset this.mappings = structNew()>
	<cfset this.mappings["/plugins"] = variables.mapPrefix & variables.baseDir & "/plugins">
	<cfset this.mappings["/muraWRM"] = variables.mapPrefix & variables.baseDir>
	<cfset this.mappings["/savaWRM"] = variables.mapPrefix & variables.baseDir>
	<cfset this.mappings["/config"] = variables.mapPrefix & variables.baseDir & "/config">
	
	<cftry>
		<cfinclude template="#properties.getProperty("context","")#/config/mappings.cfm">
		<cfset hasMainMappings=true>
		<cfcatch>
			<cfset hasMainMappings=false>
		</cfcatch>
	</cftry>
	<cftry>
		<cfinclude template="#properties.getProperty("context","")#/plugins/mappings.cfm">
		<cfset hasPluginMappings=true>
		<cfcatch>
			<cfset hasPluginMappings=false>
		</cfcatch>
	</cftry>
	
	<cfset request.userAgent = LCase( CGI.http_user_agent ) />
	<!--- Should we even use sessions? --->
	<cfset request.trackSession = not (NOT Len( request.userAgent ) OR
	 REFind( "bot\b", request.userAgent ) OR
	 Find( "_bot_", request.userAgent ) OR
	 Find( "crawl", request.userAgent ) OR
	 REFind( "\brss", request.userAgent ) OR
	 Find( "feed", request.userAgent ) OR
	 Find( "news", request.userAgent ) OR
	 Find( "blog", request.userAgent ) OR
	 Find( "reader", request.userAgent ) OR
	 Find( "syndication", request.userAgent ) OR
	 Find( "coldfusion", request.userAgent ) OR
	 Find( "slurp", request.userAgent ) OR
	 Find( "google", request.userAgent ) OR
	 Find( "zyborg", request.userAgent ) OR
	 Find( "emonitor", request.userAgent ) OR
	 Find( "jeeves", request.userAgent ) OR 
	 Find( "ping", request.userAgent ) OR 
	 FindNoCase( "java", request.userAgent ) OR 
	 FindNoCase( "cfschedule", request.userAgent ) OR
	 FindNoCase( "reeder", request.userAgent ) OR
	 FindNoCase( "Python", request.userAgent ) OR
	 FindNoCase( "Synapse", request.userAgent ) OR
	 Find( "spider", request.userAgent ))>
	 
	<!--- How long do session vars persist? --->
	<cfif request.trackSession>
		<cfset this.sessionTimeout = (properties.getProperty("sessionTimeout","180") / 24) / 60>
	<cfelse>
		<cfset this.sessionTimeout = createTimeSpan(0,0,5,0)>
	</cfif>
	
	<cfset this.timeout = properties.getProperty("requesttimeout","1000")>
	
	<!--- define a list of custom tag paths. --->
	<cfset this.customtagpaths = properties.getProperty("customtagpaths","") />
	<cfset this.customtagpaths = listAppend(this.customtagpaths,variables.mapPrefix & variables.baseDir  &  "/requirements/custom_tags/")>
	
	<cfset this.clientManagement = properties.getProperty("clientManagement","false") />
	<cfset this.clientStorage = properties.getProperty("clientStorage","registry") />
	<cfset this.ormenabled = properties.getProperty("ormenabled","true") />
	
	<!--- You can't depend on 9 supporting datasource as struct --->
	<cfif listFirst(SERVER.COLDFUSION.PRODUCTVERSION) gt 9 
		or listGetAt(SERVER.COLDFUSION.PRODUCTVERSION,3) gt 0>
		<cfset this.datasource = structNew()>
		<cfset this.datasource.name = properties.getProperty("datasource","") />
		<cfset this.datasource.username = properties.getProperty("dbusername","")>
		<cfset this.datasource.password = properties.getProperty("dbpassword","")>
	<cfelse>
		<cfset this.datasource =  properties.getProperty("datasource","") >
	</cfif>
	
	<cfset this.ormSettings=structNew()>
	<cfset this.ormSettings.cfclocation=arrayNew(1)>
	
	<cfif this.ormenabled>
		<cfswitch expression="#properties.getProperty('dbtype','')#">
			<cfcase value="mssql">
				<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />
			</cfcase>
			<cfcase value="mysql">
				<cfset this.ormSettings.dialect = "MySQL" />
			</cfcase>
			<cfcase value="oracle">
				<cfset this.ormSettings.dialect = "Oracle10g" />
			</cfcase>
			<cfcase value="nuodb">
				<cfset this.ormSettings.dialect = "nuodb" />
			</cfcase>
		</cfswitch>
		<cfset this.ormSettings.dbcreate = properties.getProperty("ormdbcreate","update") />
		<cfif len(properties.getProperty("ormcfclocation",""))>
			<cfset arrayAppend(this.ormSettings.cfclocation,properties.getProperty("ormcfclocation")) />
		</cfif>
		<cfset this.ormSettings.flushAtRequestEnd = properties.getProperty("ormflushAtRequestEnd","false") />
		<cfset this.ormsettings.eventhandling = properties.getProperty("ormeventhandling","true") />
		<cfset this.ormSettings.automanageSession = properties.getProperty("ormautomanageSession","false") />
		<cfset this.ormSettings.savemapping=properties.getProperty("ormsavemapping","false") />
		<cfset this.ormSettings.skipCFCwitherror=properties.getProperty("ormskipCFCwitherror","false") />
		<cfset this.ormSettings.useDBforMapping=properties.getProperty("ormuseDBforMapping","true") />
		<cfset this.ormSettings.autogenmap=properties.getProperty("ormautogenmap","true") />
		<cfset this.ormSettings.logsql=properties.getProperty("ormlogsql","false") />
	</cfif>

	<cftry>
		<cfinclude template="#properties.getProperty("context","")#/plugins/cfapplication.cfm">
		<cfset hasPluginCFApplication=true>
		<cfcatch>
			<cfset hasPluginCFApplication=false>
		</cfcatch>
	</cftry>
	<cftry>
		<cfinclude template="#properties.getProperty("context","")#/config/cfapplication.cfm">
		<cfset request.hasCFApplicationCFM=true>
		<cfcatch>
			<cfset request.hasCFApplicationCFM=false>
		</cfcatch>
	</cftry>
	
	<cfif not (isSimpleValue(this.ormSettings.cfclocation) and len(this.ormSettings.cfclocation))
		and not (isArray(this.ormSettings.cfclocation) and arrayLen(this.ormSettings.cfclocation))>
		<cfset this.ormenabled=false>
	</cfif>