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
/core/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfscript>
muraInstallPath		= getDirectoryFromPath(getCurrentTemplatePath());
fileDelim			= findNoCase('Windows', Server.OS.Name) ? '\' : '/';
</cfscript>


<!-----------------------------------------------------------------------
	Prevent installation if under a directory called 'mura'
	- first time, using derived path information.
------------------------------------------------------------------------>
<cfif listFindNoCase(muraInstallPath, 'mura', fileDelim) >
	<cfset criticalError	= '<h1>Mura cannot be installed under a directory called &quot;<strong>mura</strong>&quot;</h1> <p>Please move or rename the install directory and try to install again.</p>' />
	<cfinclude template="_wrapperStart.cfm" />
	<cfinclude template="_error.cfm" />
	<cfinclude template="_wrapperEnd.cfm" />
	<cfabort/>
</cfif>


<!-----------------------------------------------------------------------
	Pull some basic settings we need to get Mura setup.
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

// assemble webroot and other special paths
assetpath 		= settingsIni.get( "production", "assetpath" );
if (len( webRoot ) AND left( trim( assetpath ), len( webRoot ) ) IS NOT webRoot) {
	assetpath	= "#webRoot##assetpath#";
}

context 		= settingsIni.get( "production", "context" );
if (len( webRoot ) AND left( trim( context ), len( webRoot ) ) IS NOT webRoot) {
	context		= "#webRoot##context#";
}

// determine server type
theCFServer		= ((server.ColdFusion.ProductName CONTAINS "ColdFusion") ? 'ColdFusion': 'Lucee');

// at this point we assume the installation it's setup yet and we need to show the form
variables.setupProcessComplete	= false;
</cfscript>



<!-----------------------------------------------------------------------
	Prevent installation if under a directory called 'mura'
	- second time, this time using settings.ini information
------------------------------------------------------------------------>
<cfif listFindNoCase(context, 'mura', fileDelim) >
	<cfset criticalError	= '<h1>Mura cannot be installed under a directory called &quot;<strong>mura</strong>&quot;</h1> <p>Please move or rename the install directory and try to install again.</p>' />
	<cfinclude template="_wrapperStart.cfm" />
	<cfinclude template="_error.cfm" />
	<cfinclude template="_wrapperEnd.cfm" />
	<cfabort/>
</cfif>


<!-----------------------------------------------------------------------
	DEFAULTS
------------------------------------------------------------------------>
<cfparam name="FORM.action" 						default="showForm" />
<!--- database tab --->
<cfparam name="FORM.production_dbtype"				default="#settingsIni.get( "production", "dbtype" )#" />
<cfparam name="FORM.production_datasource"			default="#settingsIni.get( "production", "datasource" )#" />
<cfparam name="FORM.production_dbusername"			default="#settingsIni.get( "production", "dbusername" )#" />
<cfparam name="FORM.production_dbpassword"			default="#settingsIni.get( "production", "dbpassword" )#" />
<cfparam name="FORM.production_dbtablespace"		default="#settingsIni.get( "production", "dbtablespace", "USERS" )#" />
<cfparam name="FORM.production_databaseserver"		default="localhost" />
<cfparam name="FORM.production_databasename"		default="#application.applicationName#" />
<cfparam name="FORM.production_context"				default="#context#" />
<cfparam name="FORM.production_assetpath"			default="#context#" />
<cfparam name="FORM.auto_create"					default="0" />
<!--- admin account tab --->
<cfparam name="FORM.production_adminemail"			default="#settingsIni.get( "production", "adminemail" )#" />
<cfparam name="FORM.admin_username"					default="#settingsIni.get( "production", "admin_username", "admin")#" />
<cfparam name="FORM.admin_password"					default="#settingsIni.get( "production", "admin_password", "admin" )#" />
<!--- options tab --->
<cfif form.action eq 'doSetup'>
	<cfparam name="FORM.production_siteidinurls"	default="false" />
	<cfparam name="FORM.production_indexfileinurls"	default="true" />
<Cfelse>
	<cfparam name="FORM.production_siteidinurls"	default="#settingsIni.get( "production", "siteidinurls", "false")#" />
	<cfparam name="FORM.production_indexfileinurls"	default="#settingsIni.get( "production", "indexfileinurls", "true")#" />
</cfif>
<cfparam name="FORM.production_cfpassword"			default="" />
<!--- EncryptionKey --->
<cfparam name="FORM.production_encryptionkey"	default="#settingsIni.get( "production", "encryptionkey" )#" />

<cfif not len(FORM.production_encryptionkey)>
	<cfset FORM.production_encryptionkey=generateSecretKey('AES')>
</cfif>
<!--- <cfdump var="#form#" abort="true"> --->
