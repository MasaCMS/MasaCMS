<!-----------------------------------------------------------------------
	DEFAULTS
------------------------------------------------------------------------>
<cfparam name="FORM.fieldnames" 					default="" />
<!--- database tab --->
<cfparam name="FORM.production_dbtype"				default="#settingsIni.get( "production", "dbtype" )#" />
<cfparam name="FORM.production_datasource"			default="#settingsIni.get( "production", "datasource" )#" />
<cfparam name="FORM.production_dbusername"			default="#settingsIni.get( "production", "dbusername" )#" />
<cfparam name="FORM.production_dbpassword"			default="#settingsIni.get( "production", "dbpassword" )#" />
<cfparam name="FORM.production_dbtablespace"		default="#settingsIni.get( "production", "dbtablespace" )#" />
<!--- admin account tab --->
<cfparam name="FORM.production_adminemail"			default="#settingsIni.get( "production", "adminemail" )#" />
<cfparam name="FORM.admin_username"					default="admin" />
<cfparam name="FORM.admin_password"					default="admin" />
<!--- options tab --->
<cfparam name="FORM.production_siteidinurls"		default="#settingsIni.get( "production", "siteidinurls" )#" />
<cfparam name="FORM.production_indexfileinurls"		default="#settingsIni.get( "production", "indexfileinurls" )#" />
<cfparam name="FORM.production_cfpassword"			default="" />
<cfparam name="FORM.production_databaseserver"		default="localhost" />
<cfparam name="FORM.production_databasename"		default="#application.applicationName#" />
<cfparam name="FORM.auto_create"					default="" />

<cfparam name="variables.setupProcessComplete"		default="false" />
<cfparam name="FORM.production_context" default="#context#" />



<cfset assetpath = settingsIni.get( "production", "assetpath" ) />
<cfif len( webRoot ) AND left( trim( assetpath ), len( webRoot ) ) IS NOT webRoot>
  <cfset assetpath = "#webRoot##assetpath#" />
</cfif>
<cfparam name="FORM.production_assetpath" default="#assetpath#" />
<cfset context = settingsIni.get( "production", "context" ) />
<cfif len( webRoot ) AND left( trim( context ), len( webRoot ) ) IS NOT webRoot>
  <cfset context = "#webRoot##context#" />
</cfif>