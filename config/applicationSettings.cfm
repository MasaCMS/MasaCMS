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
<cfparam name="request.muraChangesetPreviewToolbar" default="false"/>
<cfparam name="request.muraExportHtml" default="false"/>
<cfparam name="request.muraMobileRequest" default="false"/>
<cfparam name="request.muraMobileTemplate" default="false"/>
<cfparam name="request.muraHandledEvents" default="#structNew()#"/>
<cfparam name="request.altTHeme" default=""/>
<cfparam name="request.customMuraScopeKeys" default="#structNew()#"/>
<cfparam name="request.muraTraceRoute" default="#arrayNew(1)#"/>
<cfparam name="request.muraRequestStart" default="#getTickCount()#"/>
<cfparam name="request.muraShowTrace" default="true"/>
<cfparam name="request.muraValidateDomain" default="true"/>
<cfparam name="request.muraAppreloaded" default="false"/>
<cfparam name="request.muratransaction" default="0"/>
<cfparam name="request.muraDynamicContentError" default="false">
<cfparam name="request.muraPreviewDomain" default="">
<cfparam name="request.muraOutputCacheOffset" default="">
<cfparam name="request.muraMostRecentPluginModuleID" default="">
<cfparam name="request.muraAPIRequest" default="false">
<cfparam name="request.muraAdminRequest" default="false">
<cfparam name="request.returnFormat" default="html">

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
<cfset variables.iniPath=getDirectoryFromPath(getCurrentTemplatePath()) & "/settings.ini.cfm">
<cfset initINI(variables.iniPath)>

<cfset commitTracePoint(variables.tracePoint)>

<!--- define custom coldfusion mappings. Keys are mapping names, values are full paths  --->
<!--- This is here for older mappings.cfm files --->
<cfset mapPrefix="" />
<cfset this.mapPrefix=mapPrefix>
<cfset variables.mapPrefix=mapPrefix>

<cfset this.mappings = structNew()>
<cfset this.mappings["/plugins"] = variables.baseDir & "/plugins">
<cfset this.mappings["/muraWRM"] = variables.baseDir>
<cfset this.mappings["/savaWRM"] = variables.baseDir>
<cfset this.mappings["/config"] = variables.baseDir & "/config">

<cfset variables.context=evalSetting(getINIProperty("context",""))>

<cftry>
	<cfinclude template="#variables.context#/config/mappings.cfm">
	<cfset hasMainMappings=true>
	<cfcatch>
		<cfset hasMainMappings=false>
	</cfcatch>
</cftry>

<cftry>
	<cfinclude template="#variables.context#/plugins/mappings.cfm">
	<cfset hasPluginMappings=true>
	<cfcatch>
		<cfset hasPluginMappings=false>
	</cfcatch>
</cftry>

<cfset this.mappings["/cfformprotect"] = variables.baseDir & "/requirements/cfformprotect">
<cfset this.mappings["/murawrm/tasks/widgets/cfformprotect"] = variables.baseDir & "/requirements/cfformprotect">

<cfset request.userAgent = LCase( CGI.http_user_agent ) />

<!--- Should we even use sessions? --->
<cfset request.trackSession = len(request.userAgent) 
 and not (
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
 Find( "java", request.userAgent ) OR 
 Find( "cfschedule", request.userAgent ) OR
 Find( "reeder", request.userAgent ) OR
 Find( "python", request.userAgent ) OR
 Find( "synapse", request.userAgent ) OR
 Find( "facebookexternalhit", request.userAgent ) OR
 Find( "tencenttraveler", request.userAgent ) OR
 Find( "bluedragon", request.userAgent ) OR
 Find( "binarycanary", request.userAgent ) OR
 Find( "siteexplorer", request.userAgent ) OR
 Find( "spider", request.userAgent ) OR
 Find( "80legs", request.userAgent ) OR
 Find( "googlebot", request.userAgent ) OR
 Find( "microsoft office protocol", request.userAgent ) OR
 Find( "railo", request.userAgent ) OR
 Find( "lucee", request.userAgent )
 )>

<cfif request.tracksession>
	<cfset checklist=evalSetting(getINIProperty("donottrackagents",""))>
	<cfif len(checklist)>
		<cfloop list="#checklist#" index="i">
			<cfif FindNoCase( i, request.userAgent )>
				<cfset request.tracksession=false>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<!--- How long do session vars persist? --->
<cfif request.trackSession>
	<cfset this.sessionTimeout = (evalSetting(getINIProperty("sessionTimeout","180")) / 24) / 60>
<cfelse>
	<cfset this.sessionTimeout = createTimeSpan(0,0,0,2)>
</cfif>

<cfset this.timeout =  getINIProperty("requesttimeout","1000")>

<!--- define a list of custom tag paths. --->
<cfset this.customtagpaths =  evalSetting(getINIProperty("customtagpaths","")) />
<cfset this.customtagpaths = listAppend(this.customtagpaths,variables.baseDir  &  "/requirements/mura/customtags/")>
<cfset this.clientManagement = evalSetting(getINIProperty("clientManagement","false")) />

<cfset variables.clientStorageCheck=evalSetting(getINIProperty("clientStorage",""))>

<cfif len(variables.clientStorageCheck)>
	<cfset this.clientStorage = variables.clientStorageCheck />
</cfif>

<cfset this.ormenabled =  evalSetting(getINIProperty("ormenabled","true")) />
<cfset this.ormSettings={}>
<cfset this.ormSettings.cfclocation=[]>

<cftry>
	<cfinclude template="#variables.context#/config/cfapplication.cfm">
	<cfset request.hasCFApplicationCFM=true>
	<cfcatch>
		<cfset request.hasCFApplicationCFM=false>
	</cfcatch>
</cftry>

<cfif len(getINIProperty("datasource",""))>

	<!--- You can't depend on 9 supporting datasource as struct --->
	<cfif listFirst(SERVER.COLDFUSION.PRODUCTVERSION) gt 9 
		or listGetAt(SERVER.COLDFUSION.PRODUCTVERSION,3) gt 0>
		<cfset this.datasource = structNew()>
		<cfset this.datasource.name = evalSetting(getINIProperty("datasource","")) />
		<cfset this.datasource.username = evalSetting(getINIProperty("dbusername",""))>
		<cfset this.datasource.password = evalSetting(getINIProperty("dbpassword",""))>
	<cfelse>
		<cfset this.datasource = evalSetting(getINIProperty("datasource","")) >			
	</cfif>
<cfelse>
	<cfset this.ormenabled=false>
</cfif>

<cfif this.ormenabled>
	<cfswitch expression="#evalSetting(getINIProperty('dbtype',''))#">
		<cfcase value="mssql">
			<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />
		</cfcase>
		<cfcase value="mysql">
			<cfset this.ormSettings.dialect = "MySQL" />
		</cfcase>
		<cfcase value="postgresql">
			<cfset this.ormSettings.dialect = "PostgreSQL" />
		</cfcase>
		<cfcase value="oracle">
			<cfset this.ormSettings.dialect = "Oracle10g" />
		</cfcase>
		<cfcase value="nuodb">
			<cfset this.ormSettings.dialect = "nuodb" />
		</cfcase>
	</cfswitch>
	<cfset this.ormSettings.dbcreate =evalSetting(getINIProperty("ormdbcreate","update")) />
	<cfif len(getINIProperty("ormcfclocation",""))>
		<cfset arrayAppend(this.ormSettings.cfclocation,evalSetting(getINIProperty("ormcfclocation"))) />
	</cfif>
	<cfif len(getINIProperty("ormdatasource",""))>
			<cfset this.ormSettings.datasource = evalSetting(getINIProperty("ormdatasource","")) />
	</cfif>
	<cfset this.ormSettings.flushAtRequestEnd = evalSetting(getINIProperty("ormflushAtRequestEnd","false")) />
	<cfset this.ormsettings.eventhandling = evalSetting(getINIProperty("ormeventhandling","true")) />
	<cfset this.ormSettings.automanageSession =evalSetting( getINIProperty("ormautomanageSession","false")) />
	<cfset this.ormSettings.savemapping= evalSetting(getINIProperty("ormsavemapping","false")) />
	<cfset this.ormSettings.skipCFCwitherror= evalSetting(getINIProperty("ormskipCFCwitherror","false")) />
	<cfset this.ormSettings.useDBforMapping= evalSetting(getINIProperty("ormuseDBforMapping","true")) />
	<cfset this.ormSettings.autogenmap= evalSetting(getINIProperty("ormautogenmap","true")) />
	<cfset this.ormSettings.logsql= evalSetting(getINIProperty("ormlogsql","false")) />
</cfif>

<cftry>
	<cfinclude template="#variables.context#/plugins/cfapplication.cfm">
	<cfset hasPluginCFApplication=true>
	<cfcatch>
		<cfset hasPluginCFApplication=false>
	</cfcatch>
</cftry>

<cfif not (isSimpleValue(this.ormSettings.cfclocation) and len(this.ormSettings.cfclocation))
	and not (isArray(this.ormSettings.cfclocation) and arrayLen(this.ormSettings.cfclocation))>
	<cfset this.ormenabled=false>
</cfif>

<cfscript>
	// if true, CF converts form fields as an array instead of a list (not recommended)
	this.sameformfieldsasarray=evalSetting(getINIProperty('sameformfieldsasarray',false));

	// Custom Java library paths with dynamic loading
	try {
		variables.loadPaths = ListToArray(getINIProperty('javaSettingsLoadPaths','#variables.context#/requirements/lib'));
	} catch(any e) {
		variables.loadPaths = ['#variables.context#/requirements/lib'];
	}

	this.javaSettings = {
		loadPaths=variables.loadPaths
		, loadColdFusionClassPath = evalSetting(getINIProperty('javaSettingsLoadColdFusionClassPath',true))
		, reloadOnChange=evalSetting(getINIProperty('javaSettingsReloadOnChange',false))
		, watchInterval=evalSetting(getINIProperty('javaSettingsWatchInterval',60))
		, watchExtensions=evalSetting(getINIProperty('javaSettingsWatchExtensions','jar,class'))
	};

	// Amazon S3 Credentials
	try {
		this.s3.accessKeyId=evalSetting(getINIProperty('s3accessKeyId',''));
		this.s3.awsSecretKey=evalSetting(getINIProperty('s3awsSecretKey',''));
	} catch(any e) {
		// not supported
	}
</cfscript>

<cffunction name="initINI" output="false">
	<cfargument name="iniPath" type="string" required="true" hint="Mapped Path to an ini file." />

	<cfset var file = "" />
	<cfset var line = "" />
	<cfset var currentSection = "" />
	<cfset var entry = "" />
	<cfset var value = "" />

	
	<cfset variables.iniPath = arguments.iniPath />
	<cfset variables.ini = structNew() />

	<cffile variable="file" action="read" file="#variables.iniPath#"  />
	
	<cfloop list="#file#" index="line" delimiters="#chr(10)##chr(13)#">
		<cfset line = trim( line ) />
		<cfif NOT ( startsWith( line, ";" ) OR startsWith( line, "##" ) OR startsWith( line, "<" ) )>
			<cfif startsWith( line, "[" ) AND find( "]", line, 2 ) GT 2>
				<cfset currentSection = mid( line, 2, find( "]", line, 2 ) - 2 ) />
				<cfset setINISection( currentSection ) />
			<cfelseif find( "=", line ) GT 1 AND len( currentSection )>
				<cfset entry = trim( listFirst( line, "=" ) ) />
				<cfset value = "" />
				<cfif listLen( line, "=" ) GT 1>
					<cfset value = trim( listRest( line, "=" ) ) />
				</cfif>
				<cfset setINIProperty(entry, value , currentSection) />
			</cfif>
		</cfif>
	</cfloop>

	<cfreturn variables.ini />
</cffunction>

<cffunction name="getINISections" returntype="struct" output="false" hint="Returns a struct with section names and values set to list of section entry names. This behaves much like the CF built-in function getProfileSections().">
	<cfset var sections = structNew() />
	<cfset var sectionName = "" />

	<cfloop list="#structKeyList( variables.ini )#" index="sectionName">
		<cfset sections[ sectionName ] = structKeyList( variables.ini[ sectionName ] ) />
	</cfloop>

	<cfreturn sections />
</cffunction>

<cffunction name="evalSetting" output="false">
	<cfargument name="value">
	<cfif left(arguments.value,2) eq "${"
		and right(arguments.value,1) eq "}">
		<cfset arguments.value=mid(arguments.value,3,len(arguments.value)-3)>
		<cfreturn evaluate(arguments.value)>
	<cfelseif left(arguments.value,2) eq "{{"
		and right(arguments.value,2) eq "}}">
		<cfset arguments.value=mid(arguments.value,3,len(arguments.value)-4)>
		<cfreturn evaluate(arguments.value)>
	<cfelse>
		<cfreturn arguments.value>
	</cfif>	
</cffunction>

<cffunction name="setINIProperty" output="false">
	<cfargument name="entry" type="string" required="true" hint="Entry name." />
	<cfargument name="value" type="any" required="false" default="" hint="Property value" />
	<cfargument name="section" type="string" required="true" hint="Section name." default="#variables.ini.settings.mode#"/>

	<cfset setINISection( arguments.section ) />

	<cfset variables.ini[ arguments.section ][ arguments.entry ] =  arguments.value />

	<cfreturn this />
</cffunction>

<cffunction name="getINIProperty" output="false" hint="Get all INI data (no arguments); a section's data, as a struct (one argument, section name); or an entry's value (section and entry name arguments). Optionally pass a third argument to set/get a default value if requested entry doesn't exist.">
	<cfargument name="entry" type="string" required="false" hint="Entry name." />
	<cfargument name="default" type="string" required="false" />
	<cfargument name="section" type="string" required="false" hint="Section name." default="#variables.ini.settings.mode#"/>

	<cfif NOT structKeyExists( arguments, "entry" )>
		<cfreturn variables.ini[ arguments.section ] />
	</cfif>

	<cfif structKeyExists( variables.ini[ arguments.section ], arguments.entry )>
		<cfreturn variables.ini[ arguments.section ][ arguments.entry ] />
	<cfelseif ( structKeyExists( arguments, "default" ) )>
		<cfset setINIProperty(arguments.entry, arguments.default ,arguments.section) />
		<cfreturn arguments.default />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>

<cffunction name="setINISection" returntype="void" output="false">
	<cfargument name="section" type="string" required="true" hint="Section name." />

	<cfif NOT structKeyExists( variables.ini, arguments.section )>
		<cfset variables.ini[ arguments.section ] = structNew() />
	</cfif>
</cffunction>

<cffunction name="startsWith" returntype="boolean" access="private" output="false">
	<cfargument name="str" type="string" required="true" hint="String to check." />
	<cfargument name="char" type="string" required="true" hint="Character to check for." />

	<cfreturn left( arguments.str, 1 ) EQ arguments.char />
</cffunction>

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

