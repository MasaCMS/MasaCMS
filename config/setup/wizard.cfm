<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ?See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ?If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (?GPL?) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ?the copyright holders of Mura CMS grant you permission
to combine Mura CMS ?with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ?/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<!--- Give Mura 5 minutes for setup script to run to prevent it timing out when server configuration request timeout is too small --->
<cfsetting requesttimeout="300">

<!-----------------------------------------------------------------------
	Prevent installation if under a directory called 'mura'
------------------------------------------------------------------------>
<cfscript>
muraInstallPath		= getDirectoryFromPath(getCurrentTemplatePath());
fileDelim			= findNoCase('Windows', Server.OS.Name) ? '\' : '/';
</cfscript>

<cfif listFindNoCase(muraInstallPath, 'mura', fileDelim)>
	<h1>Mura cannot be installed under a directory called &quot;<strong>mura</strong>&quot; &hellip; please move or rename and try to install again.</h1>
	<cfabort />
</cfif>


<!-----------------------------------------------------------------------
	RenderSetup is set here to prove we got here for a legit reason:
	/config/appcfc/onRequestStart_include.cfm

	If renderSetup is not found or is false then do not render.
------------------------------------------------------------------------>
<cfif NOT isDefined( "renderSetup" ) OR NOT renderSetup>
	<cfabort />
</cfif>


<!-----------------------------------------------------------------------
	Pull some basic settings we need to get Mura setup
------------------------------------------------------------------------>
<cfscript>
// default message container
message			= "";
// grab current settings
settingsPath	= variables.baseDir & "/config/settings.ini.cfm";
settingsini		= createobject("component","mura.IniFile").init(settingsPath);
// get  and cleanup current web root
currentFile		= getFileFromPath( getBaseTemplatePath() );
webRoot			= replaceNoCase( CGI.script_name, currentFile, "" );
webRoot			= replaceNoCase( webRoot, "default/", "" ); // take out setup folder from webroot
webRoot			= mid( webRoot, 1, len( webRoot )-1 ); // remove trailing slash
// determine server type
theCFServer		= ((server.ColdFusion.ProductName CONTAINS "ColdFusion") ? 'ColdFusion': 'Lucee');
</cfscript>



<!-----------------------------------------------------------------------
	DEFAULTS
------------------------------------------------------------------------>
<cfparam name="FORM.fieldnames" 					default="" />
<cfparam name="FORM.production_dbtype"				default="#settingsIni.get( "production", "dbtype" )#" />
<cfparam name="FORM.production_datasource"			default="#settingsIni.get( "production", "datasource" )#" />
<cfparam name="FORM.production_dbusername"			default="#settingsIni.get( "production", "dbusername" )#" />
<cfparam name="FORM.production_dbpassword"			default="#settingsIni.get( "production", "dbpassword" )#" />
<cfparam name="FORM.production_dbtablespace"		default="#settingsIni.get( "production", "dbtablespace" )#" />
<cfparam name="FORM.production_adminemail"			default="#settingsIni.get( "production", "adminemail" )#" />
<cfparam name="FORM.production_mailserverip"		default="#settingsIni.get( "production", "mailserverip" )#" />
<cfparam name="FORM.production_mailserverpopport"	default="#settingsIni.get( "production", "mailserverpopport" )#" />
<cfparam name="FORM.production_mailserverusername"	default="#settingsIni.get( "production", "mailserverusername" )#" />
<cfparam name="FORM.production_mailserverpassword"	default="#settingsIni.get( "production", "mailserverpassword" )#" />
<cfparam name="FORM.production_mailserversmtpport"	default="#settingsIni.get( "production", "mailserversmtpport" )#" />
<cfparam name="FORM.production_mailservertls"		default="#settingsIni.get( "production", "mailservertls" )#" />
<cfparam name="FORM.production_mailserverssl"		default="#settingsIni.get( "production", "mailserverssl" )#" />
<cfparam name="FORM.production_siteidinurls"		default="#settingsIni.get( "production", "siteidinurls" )#" />
<cfparam name="FORM.production_indexfileinurls"		default="#settingsIni.get( "production", "indexfileinurls" )#" />
<cfparam name="FORM.production_cfpassword"			default="" />
<cfparam name="FORM.production_databaseserver"		default="localhost" />
<cfparam name="FORM.production_databasename"		default="#application.applicationName#" />
<cfparam name="FORM.auto_create"					default="" />
<cfparam name="FORM.admin_username"					default="admin" />
<cfparam name="FORM.admin_password"					default="admin" />
<cfparam name="variables.setupProcessComplete"		default="false" />




<cfset assetpath = settingsIni.get( "production", "assetpath" ) />
<cfif len( webRoot ) AND left( trim( assetpath ), len( webRoot ) ) IS NOT webRoot>
  <cfset assetpath = "#webRoot##assetpath#" />
</cfif>
<cfparam name="FORM.production_assetpath" default="#assetpath#" />
<cfset context = settingsIni.get( "production", "context" ) />
<cfif len( webRoot ) AND left( trim( context ), len( webRoot ) ) IS NOT webRoot>
  <cfset context = "#webRoot##context#" />
</cfif>


<cfif listFindNoCase(context, 'mura', fileDelim)>
	<h1>Mura cannot be installed under a directory called &quot;<strong>mura</strong>&quot; &hellip; please move or rename and try to install again.</h1>
	<cfabort />
</cfif>

<cfparam name="FORM.production_context" default="#context#" />


<cfinclude template="_process.cfm" />
<cfif variables.setupProcessComplete>
	<cfset application.appAutoUpdated = true />
	<cfinclude template="_done.cfm" />
<cfelse>
	<cfinclude template="_form.cfm" />
</cfif>
<cfinclude template="_udf.cfm" />