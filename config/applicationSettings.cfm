<cfscript>
/*  This file is part of Mura CMS.

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
*/
param name="request.muraFrontEndRequest" default=false;
param name="request.muraChangesetPreview" default=false;
param name="request.muraChangesetPreviewToolbar" default=false;
param name="request.muraExportHtml" default=false;
param name="request.muraMobileRequest" default=false;
param name="request.muraMobileTemplate" default=false;
param name="request.muraHandledEvents" default=structNew();
param name="request.altTHeme" default="";
param name="request.customMuraScopeKeys" default=structNew();
param name="request.muraTraceRoute" default=arrayNew(1);
param name="request.muraRequestStart" default=getTickCount();
param name="request.muraShowTrace" default=true;
param name="request.muraValidateDomain" default=true;
param name="request.muraAppreloaded" default=false;
param name="request.muratransaction" default=0;
param name="request.muraDynamicContentError" default=false;
param name="request.muraPreviewDomain" default="";
param name="request.muraOutputCacheOffset" default="";
param name="request.muraCachingOutput" default=false;
param name="request.muraMostRecentPluginModuleID" default="" ;
param name="request.muraAPIRequest" default=false;
param name="request.muraAdminRequest" default=false;
param name="request.mura404" default=false;
param name="request.returnFormat" default="html";
param name="request.muraSessionManagement" default=true;
param name="request.muraPointInTime" default="";
param name="request.muraTemplateMissing" default=false;
param name="request.muraSysEnv" default="#createObject('java','java.lang.System').getenv()#";

request.muraInDocker=len(getSystemEnvironmentSetting('MURA_DATASOURCE'));
this.configPath=getDirectoryFromPath(getCurrentTemplatePath());
//  Application name, should be unique
this.name = "mura" & hash(getCurrentTemplatePath());
//  How long application vars persist
this.applicationTimeout = createTimeSpan(3,0,0,0);

//  Where should cflogin stuff persist
this.sessionManagement = !(left(cgi.path_info,11) == '/_api/rest/');

if(this.sessionManagement){
	this.loginStorage = "session";

	//  We don't set client cookies here, because they are not set secure if required. We use setSessionCookies()
	this.setClientCookies = true;
	param name="this.sessioncookies" default=structNew();
	this.sessioncookie.disableupdate = false;
}

// needed for lockdown screens
this.bufferOutput = true;

this.searchImplicitScopes=false;
/*  should cookies be domain specific, ie, *.foo.com or www.foo.com
	this.setDomainCookies = not refind('\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b',listFirst(cgi.http_host,":"))>
*/
//  should we try to block 'bad' input from users
this.scriptProtect = false;
//  should we secure our JSON calls?
this.secureJSON = false;
//  Should we use a prefix in front of JSON strings?
this.secureJSONPrefix = "";
//  Used to help CF work with missing files and dir indexes
this.welcomeFileList = "";
//  Compile cfml in all cfincluded files
this.compileextforinclude="*";
baseDir= left(this.configPath,len(this.configPath)-8);
if ( !fileExists(baseDir & "/config/settings.ini.cfm") ) {
	variables.tracePoint=initTracePoint("Writing config/settings.ini.cfm");
	fileCopy("#baseDir#/config/templates/settings.template.cfm","#baseDir#/config/settings.ini.cfm");
	try {
		fileSetAccessMode("#baseDir#/config/settings.ini.cfm","777");
	} catch (any cfcatch) {}
	commitTracePoint(variables.tracePoint);
}
this.baseDir=baseDir;
variables.baseDir=baseDir;
variables.tracePoint=initTracePoint("Reading config/settings.ini.cfm");
variables.iniPath=getDirectoryFromPath(getCurrentTemplatePath()) & "/settings.ini.cfm";
initINI(variables.iniPath);
variables.ini.settings.mode=evalSetting(variables.ini.settings.mode);
commitTracePoint(variables.tracePoint);
//  define custom coldfusion mappings. Keys are mapping names, values are full paths
//  This is here for older mappings.cfm files
mapPrefix="";
this.mapPrefix=mapPrefix;
variables.mapPrefix=mapPrefix;
this.mappings = structNew();
this.mappings["/plugins"] = variables.baseDir & "/plugins";
this.mappings["/muraWRM"] = variables.baseDir;
this.mappings["/savaWRM"] = variables.baseDir;
this.mappings["/config"] = variables.baseDir & "/config";
variables.context=evalSetting(getINIProperty("context",""));
try {
	include "#variables.context#/config/mappings.cfm";
	hasMainMappings=true;
} catch (any cfcatch) {
	hasMainMappings=false;
}
try {
	include "#variables.context#/plugins/mappings.cfm";
	hasPluginMappings=true;
} catch (any cfcatch) {
	hasPluginMappings=false;
}
this.mappings["/cfformprotect"] = variables.baseDir & "/requirements/cfformprotect";
this.mappings["/murawrm/tasks/widgets/cfformprotect"] = variables.baseDir & "/requirements/cfformprotect";
request.userAgent = LCase( CGI.http_user_agent );
if ( !this.sessionManagement ) {
	request.muraSessionManagement=false;
	request.trackSession=0;
} else {
	//  Should we even use sessions?
	request.trackSession = len(request.userAgent)
 && !(
 REFind( "bot\b", request.userAgent ) OR
 REFind( "\brss", request.userAgent ) OR
 Find( "_bot_", request.userAgent ) OR
 Find( "80legs", request.userAgent ) OR
 Find( "ahrefs", request.userAgent ) OR
 Find( "applebot", request.userAgent ) OR
 Find( "baidu", request.userAgent ) OR
 Find( "binarycanary", request.userAgent ) OR
 Find( "bing", request.userAgent ) OR
 Find( "bingbot", request.userAgent ) OR
 Find( "blog", request.userAgent ) OR
 Find( "bluedragon", request.userAgent ) OR
 Find( "cfnetwork", request.userAgent ) OR
 Find( "cfschedule", request.userAgent ) OR
 Find( "coldfusion", request.userAgent ) OR
 Find( "crawl", request.userAgent ) OR
 Find( "dotbot", request.userAgent ) OR
 Find( "duckduckbot", request.userAgent ) OR
 Find( "emonitor", request.userAgent ) OR
 Find( "exabot", request.userAgent ) OR
 Find( "facebookexternalhit", request.userAgent ) OR
 Find( "feed", request.userAgent ) OR
 Find( "go-http-client", request.userAgent ) OR
 Find( "google", request.userAgent ) OR
 Find( "googlebot", request.userAgent ) OR
 Find( "houzzbot", request.userAgent ) OR
 Find( "hotbar", request.userAgent ) OR
 Find( "java", request.userAgent ) OR
 Find( "jeeves", request.userAgent ) OR
 Find( "lucee", request.userAgent ) OR
 Find( "mediapartners", request.userAgent ) OR
 Find( "megaindex", request.userAgent ) OR
 Find( "microsoft office protocol", request.userAgent ) OR
 Find( "news", request.userAgent ) OR
 Find( "netestate", request.userAgent ) OR
 Find( "ping", request.userAgent ) OR
 Find( "python", request.userAgent ) OR
 Find( "railo", request.userAgent ) OR
 Find( "reader", request.userAgent ) OR
 Find( "reeder", request.userAgent ) OR
 Find( "safeassign", request.userAgent ) OR
 Find( "seznambot", request.userAgent ) OR
 Find( "siteimprove", request.userAgent ) OR
 Find( "slurp", request.userAgent ) OR
 Find( "spider", request.userAgent ) OR
 Find( "synapse", request.userAgent ) OR
 Find( "syndication", request.userAgent ) OR
 Find( "tencenttraveler", request.userAgent ) OR
 Find( "toolbar", request.userAgent ) OR
 Find( "wikido", request.userAgent ) OR
 Find( "yandex", request.userAgent ) OR
 Find( "zabbix", request.userAgent ) OR
 Find( "zyborg", request.userAgent )
 );

	if ( request.tracksession ) {
		checklist=evalSetting(getINIProperty("donottrackagents",""));
		if ( len(checklist) ) {
			for(i in listToArray(checklist)){
				if (FindNoCase( i, request.userAgent )){
					request.tracksession=false;
					break;
				}
			}
		}
	}

	// How long do session vars persist?
	if ( request.tracksession ) {
		iniSessionTimeout = evalSetting(getINIProperty('sessionTimeout',180));
		iniSessionTimeout = iniSessionTimeout >= 1 ? iniSessionTimeout : 180;
		this.sessionTimeout = (evalSetting(getINIProperty("sessionTimeout","180")) / 24) / 60;
	} else {
		this.sessionTimeout = CreateTimeSpan(0,0,0,2);
	}
}
this.timeout =  getINIProperty("requesttimeout","1000");
//  define a list of custom tag paths.
this.customtagpaths =  evalSetting(getINIProperty("customtagpaths",""));
this.customtagpaths = listAppend(this.customtagpaths,variables.baseDir  &  "/requirements/mura/customtags/");
this.clientManagement = evalSetting(getINIProperty("clientManagement","false"));
variables.clientStorageCheck=evalSetting(getINIProperty("clientStorage",""));
if ( len(variables.clientStorageCheck) ) {
	this.clientStorage = variables.clientStorageCheck;
}
this.ormenabled =  evalSetting(getINIProperty("ormenabled","true"));
this.ormSettings={};
this.ormSettings.cfclocation=[];
try {
	include "#variables.context#/config/cfapplication.cfm";
	request.hasCFApplicationCFM=true;
} catch (any cfcatch) {
	request.hasCFApplicationCFM=false;
}
if ( len(evalSetting(getINIProperty("cookiedomain",""))) ) {
	this.setClientCookies=false;
}
if ( len(getINIProperty("datasource","")) ) {
	//  You can't depend on 9 supporting datasource as struct
	if ( listFirst(SERVER.COLDFUSION.PRODUCTVERSION) > 9
		or listGetAt(SERVER.COLDFUSION.PRODUCTVERSION,3) > 0 ) {
		this.datasource = structNew();
		this.datasource.name = evalSetting(getINIProperty("datasource",""));
		dbUsername=evalSetting(getINIProperty("dbusername",""));
		if ( len(dbUsername) ) {
			this.datasource.username =dbUsername;
		}
		dbPassword=evalSetting(getINIProperty("dbpassword",""));
		if ( len(dbPassword) ) {
			this.datasource.password = dbPassword;
		}
	} else {
		this.datasource = evalSetting(getINIProperty("datasource",""));
	}
} else {
	this.ormenabled=false;
}
if ( this.ormenabled ) {
	switch ( evalSetting(getINIProperty('dbtype','')) ) {
		case  "mssql":
			this.ormSettings.dialect = "MicrosoftSQLServer";
			break;
		case  "mysql":
			this.ormSettings.dialect = "MySQL";
			break;
		case  "postgresql":
			this.ormSettings.dialect = "PostgreSQL";
			break;
		case  "oracle":
			this.ormSettings.dialect = "Oracle10g";
			break;
		case  "nuodb":
			this.ormSettings.dialect = "nuodb";
			break;
	}
	this.ormSettings.dbcreate =evalSetting(getINIProperty("ormdbcreate","update"));
	if ( len(getINIProperty("ormcfclocation","")) ) {
		arrayAppend(this.ormSettings.cfclocation,evalSetting(getINIProperty("ormcfclocation")));
	}
	if ( len(getINIProperty("ormdatasource","")) ) {
		this.ormSettings.datasource = evalSetting(getINIProperty("ormdatasource",""));
	}
	this.ormSettings.flushAtRequestEnd = evalSetting(getINIProperty("ormflushAtRequestEnd","false"));
	this.ormsettings.eventhandling = evalSetting(getINIProperty("ormeventhandling","true"));
	this.ormSettings.automanageSession =evalSetting( getINIProperty("ormautomanageSession","false"));
	this.ormSettings.savemapping= evalSetting(getINIProperty("ormsavemapping","false"));
	this.ormSettings.skipCFCwitherror= evalSetting(getINIProperty("ormskipCFCwitherror","false"));
	this.ormSettings.useDBforMapping= evalSetting(getINIProperty("ormuseDBforMapping","false"));
	this.ormSettings.autogenmap= evalSetting(getINIProperty("ormautogenmap","true"));
	this.ormSettings.logsql= evalSetting(getINIProperty("ormlogsql","false"));
}

if(request.muraInDocker && len(getSystemEnvironmentSetting('MURA_DATABASE'))){
		if(server.coldfusion.productname == 'lucee'){
			driverVarName='type';

			switch(getSystemEnvironmentSetting('MURA_DBTYPE')){
				case 'mysql':
					driverName='mysql';
					break;
				case 'mssql':
					driverName='mssql';
					break;
				case 'oracle':
					driverName='Oracle';
					break;
				case 'postgresql':
					driverName='PostgreSQL';
					break;
			}
		} else {
			driverVarName='driver';

			switch(getSystemEnvironmentSetting('MURA_DBTYPE')){
				case 'mysql':
					driverName='MySQL5';
					break;
				case 'mssql':
					driverName='MSSQLServer';
					break;
				case 'oracle':
					driverName='Oracle';
					break;
				case 'postgresql':
					driverName='PostgreSQL';
					break;
			}
		}

		this.datasources={
			'#getSystemEnvironmentSetting('MURA_DATASOURCE')#' =  {
						'#driverVarName#' = driverName
					 , host = getSystemEnvironmentSetting('MURA_DBHOST')
					 , database = getSystemEnvironmentSetting('MURA_DATABASE')
					 , port = getSystemEnvironmentSetting('MURA_DBPORT')
					 , username = getSystemEnvironmentSetting('MURA_DBUSERNAME')
					 , password = getSystemEnvironmentSetting('MURA_DBPASSWORD')
				},
				nodatabase=  {
						'#driverVarName#' = driverName
					 , host = getSystemEnvironmentSetting('MURA_DBHOST')
					 , database = ''
					 , port = getSystemEnvironmentSetting('MURA_DBPORT')
					 , username = getSystemEnvironmentSetting('MURA_DBUSERNAME')
					 , password = getSystemEnvironmentSetting('MURA_DBPASSWORD')
				}
		};


	}
try {
	include "#variables.context#/plugins/cfapplication.cfm";
	hasPluginCFApplication=true;
} catch (any cfcatch) {
	hasPluginCFApplication=false;
}
if ( !(isSimpleValue(this.ormSettings.cfclocation) && len(this.ormSettings.cfclocation))
	and !(isArray(this.ormSettings.cfclocation) && arrayLen(this.ormSettings.cfclocation)) ) {
	this.ormenabled=false;
}

//This is use to interact with Lucee admin settings.s
	this.webadminpassword=evalSetting(getINIProperty('webadminpassword',''));

	// if true, CF converts form fields as an array instead of a list (not recommended)
	this.sameformfieldsasarray=evalSetting(getINIProperty('sameformfieldsasarray',false));

	// Custom Java library paths with dynamic loading
	try {
		variables.loadPaths = ListToArray(getINIProperty('javaSettingsLoadPaths','#variables.baseDir#/requirements/lib'));
	} catch(any e) {
		variables.loadPaths = ['#variables.baseDir#/requirements/lib'];
	}

	this.javaSettings = {
		loadPaths=variables.loadPaths
		, loadColdFusionClassPath = evalSetting(getINIProperty('javaSettingsLoadColdFusionClassPath',true))
		, reloadOnChange=true
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

function initINI(required string iniPath) output=false {
	var file = "";
	var line = "";
	var currentSection = "";
	var entry = "";
	var value = "";
	variables.iniPath = arguments.iniPath;
	variables.ini = structNew();
	file=fileRead(variables.iniPath);

	for(line in listToArray(file,"#chr(10)##chr(13)#")){
		line=trim(line);

		if (NOT ( startsWith( line, ";" ) OR startsWith( line, "##" ) OR startsWith( line, "<" ) )){
			if (startsWith( line, "[" ) AND find( "]", line, 2 ) GT 2){
				currentSection = mid( line, 2, find( "]", line, 2 ) - 2 );
				setINISection( currentSection );
			} else if (find( "=", line ) GT 1 AND len( currentSection )){
				entry = trim( listFirst( line, "=" ) );
				value = "";
				if (listLen( line, "=" ) GT 1){
					value = trim( listRest( line, "=" ) );
				}
				setINIProperty(entry, value , currentSection);
			}
		}
	}

	return variables.ini;
}

/**
	 * Returns a struct with section names and values set to list of section entry names. This behaves much like the CF built-in function getProfileSections().
	 */
	struct function getINISections() output=false {
	var sections = structNew();
	var sectionName = "";

	for(sectionName in ListToArray(structKeyList( variables.ini ))){
		sections[ sectionName ] = structKeyList( variables.ini[ sectionName ] );
	}

	return sections;
}

function evalSetting(value) output=false {
	if ( left(arguments.value,2) == "${"
		and right(arguments.value,1) == "}" ) {
		arguments.value=mid(arguments.value,3,len(arguments.value)-3);
		return evaluate(arguments.value);
	} else if ( left(arguments.value,2) == "{{"
		and right(arguments.value,2) == "}}" ) {
		arguments.value=mid(arguments.value,3,len(arguments.value)-4);
		return evaluate(arguments.value);
	} else {
		return arguments.value;
	}
}

function setINIProperty(required string entry, any value="", required string section="#variables.ini.settings.mode#") output=false {
	setINISection( arguments.section );
	variables.ini[ arguments.section ][ arguments.entry ] =  arguments.value;
	return this;
}

/**
	 * Get all INI data (no arguments); a section's data, as a struct (one argument, section name); or an entry's value (section and entry name arguments). Optionally pass a third argument to set/get a default value if requested entry doesn't exist.
	 */
	function getINIProperty(string entry, string defaultValue, string section="#variables.ini.settings.mode#") output=false {
	var envVar='MURA_#UCASE(arguments.entry)#';
	if ( structKeyExists(request.muraSysEnv,'#envVar#') ) {
		return request.muraSysEnv['#envVar#'];
	} else {
		if ( !structKeyExists( arguments, "entry" ) ) {
			return variables.ini[ arguments.section ];
		}

		if ( structKeyExists( variables.ini[ arguments.section ], arguments.entry ) ) {
			return variables.ini[ arguments.section ][ arguments.entry ];
		} else if ( ( structKeyExists( arguments, "defaultValue" ) ) ) {
			setINIProperty(arguments.entry, arguments.defaultValue ,arguments.section);
			return arguments.defaultValue;
		} else {
			return "";
		}
	}
}

void function setINISection(required string section) output=false {
	if ( !structKeyExists( variables.ini, arguments.section ) ) {
		variables.ini[ arguments.section ] = structNew();
	}
}

private boolean function startsWith(required string str, required string char) output=false {
	return left( arguments.str, 1 ) == arguments.char;
}

function initTracePoint(detail) output=false {
	var tracePoint=structNew();
	if ( !request.muraShowTrace ) {
		return 0;
	}
	tracePoint.detail=arguments.detail;
	tracePoint.start=getTickCount();
	arrayAppend(request.muraTraceRoute,tracePoint);
	return arrayLen(request.muraTraceRoute);
}

function commitTracePoint(tracePointID) output=false {
	var tracePoint="";
	if ( arguments.tracePointID ) {
		tracePoint=request.muraTraceRoute[arguments.tracePointID];
		tracePoint.stop=getTickCount();
		tracePoint.duration=tracePoint.stop-tracePoint.start;
		tracePoint.total=tracePoint.stop-request.muraRequestStart;
	}
}

function getSystemEnvironmentSetting(required string name){
   var setting = '';

   if (structKeyExists(request.muraSysEnv, name)) {
	   setting = request.muraSysEnv[name];
   }

   return setting;
}
</cfscript>
