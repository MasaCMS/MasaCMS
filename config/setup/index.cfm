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

<!--- if renderSetup is not found or is false then do not render --->
<cfif NOT isDefined( "renderSetup" ) OR NOT renderSetup>
  <cfabort />
</cfif>
<!--- settings --->
<cfset message = "" />
<!--- get settings path --->
<cfset settingsPath = variables.baseDir & "/config/settings.ini.cfm" />
<!--- load settings into iniFile instance --->
<cfset settingsini=createobject("component","mura.IniFile").init(settingsPath)>
<!--- get current file --->
<cfset currentFile = getFileFromPath( getBaseTemplatePath() ) />
<cfset webRoot = replaceNoCase( CGI.script_name, currentFile, "" ) />
<!--- take out setup folder from webroot --->
<cfset webRoot = replaceNoCase( webRoot, "default/", "" ) />
<!--- clean up the web root and remove the last / --->
<cfset webRoot = mid( webRoot, 1, len( webRoot )-1 ) />
<cfparam name="FORM.fieldnames" default="" />
<cfparam name="FORM.production_dbtype" default="#settingsIni.get( "production", "dbtype" )#" />
<cfparam name="FORM.production_port" default="#cgi.server_port#" />
<cfparam name="FORM.production_datasource" default="#settingsIni.get( "production", "datasource" )#" />
<cfparam name="FORM.production_dbusername" default="#settingsIni.get( "production", "dbusername" )#" />
<cfparam name="FORM.production_dbpassword" default="#settingsIni.get( "production", "dbpassword" )#" />
<cfparam name="FORM.production_dbtablespace" default="#settingsIni.get( "production", "dbtablespace" )#" />
<cfparam name="FORM.production_adminemail" default="#settingsIni.get( "production", "adminemail" )#" />
<cfparam name="FORM.production_mailserverip" default="#settingsIni.get( "production", "mailserverip" )#" />
<cfparam name="FORM.production_mailserverpopport" default="#settingsIni.get( "production", "mailserverpopport" )#" />
<cfparam name="FORM.production_mailserverusername" default="#settingsIni.get( "production", "mailserverusername" )#" />
<cfparam name="FORM.production_mailserverpassword" default="#settingsIni.get( "production", "mailserverpassword" )#" />
<cfparam name="FORM.production_mailserversmtpport" default="#settingsIni.get( "production", "mailserversmtpport" )#" />
<cfparam name="FORM.production_mailservertls" default="#settingsIni.get( "production", "mailservertls" )#" />
<cfparam name="FORM.production_mailserverssl" default="#settingsIni.get( "production", "mailserverssl" )#" />
<cfparam name="FORM.production_siteidinurls" default="#settingsIni.get( "production", "siteidinurls" )#" />
<cfparam name="FORM.production_indexfileinurls" default="#settingsIni.get( "production", "indexfileinurls" )#" />
<!--- this is a checkbox so we need to review what has been passed in and work accordingly --->
<cfif isDefined( "FORM.production_usedefaultsmtpserver" ) AND FORM.production_usedefaultsmtpserver AND settingsIni.get( "production", "usedefaultsmtpserver" )>
  <cfparam name="FORM.production_usedefaultsmtpserver" default="#settingsIni.get( "production", "usedefaultsmtpserver" )#" />
<cfelse>
  <cfparam name="FORM.production_usedefaultsmtpserver" default="0" />
</cfif>
<!--- db create params (bsoylu 6/6/2010)  --->
<cfparam name="FORM.production_cfpassword" default="" />
<cfparam name="FORM.production_databaseserver" default="localhost" />
<cfparam name="FORM.production_databasename" default="#Application.ApplicationName#" />
<cfparam name="FORM.auto_create" default="No" />
<cfparam name="FORM.admin_username" default="admin" />
<cfparam name="FORM.admin_password" default="admin" />

<!--- this is a list of optional form elements that may not show up in the FORM.fieldnames list. to ensure they are there we simple ammend them in --->
<cfset optionalFormElements = "production_usedefaultsmtpserver" />
<cfloop list="#optionalFormElements#" index="optionalFormElement">
  <cfif NOT listFindNoCase( FORM.fieldnames, optionalFormElement )>
    <cfset FORM.fieldnames = listAppend( FORM.fieldnames, optionalFormElement ) />
  </cfif>
</cfloop>
<cfset assetpath = settingsIni.get( "production", "assetpath" ) />
<cfif len( webRoot ) AND left( trim( assetpath ), len( webRoot ) ) IS NOT webRoot>
  <cfset assetpath = "#webRoot##assetpath#" />
</cfif>
<cfparam name="FORM.production_assetpath" default="#assetpath#" />
<cfset context = settingsIni.get( "production", "context" ) />
<cfif len( webRoot ) AND left( trim( context ), len( webRoot ) ) IS NOT webRoot>
  <cfset context = "#webRoot##context#" />
</cfif>
<cfparam name="FORM.production_context" default="#context#" />
<!--- state we are done --->
<cfif isDefined( "FORM.#application.setupSubmitButtonComplete#" )>
  <!--- state we are done --->
  <!---
  <cfset settingsIni.set( "settings", "installed", 1 ) />
  <!--- clean ini since it removes cf tags --->
  <cfset cleanIni( settingsPath ) />
  --->
  <!--- cflocate to the admin --->
  <cflocation url="#context#/admin/index.cfm?appreload" addtoken="false" />
</cfif>
<!--- run save process --->
<cfif isDefined( "FORM.#application.setupSubmitButton#" )>
  <!--- save settings --->
  <cfset validSections = "production,settings" />
  <!--- ************************ --->
  <!--- STEP 1 --->
  <!--- ************************ --->
  
  <!--- check datasource --->
  <cfset errorType = "" />
  <cfset dbCreated = false />

  <!--- remove datasource for now entered if we are supposed to create one (bsoylu 6/7/2010)  --->
  <cfif Form.production_datasource NEQ "" AND IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND Form.auto_create>
    <cfset FORM.production_datasource="">
  </cfif>
  <cftry>
    <!--- do not run if we do not have a datasource (bsoylu 6/6/2010)  --->
    <cfif Form.production_datasource NEQ "">
      <!--- try to run a basic query --->
      <cfquery name="qry" datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
        SELECT COUNT( contentid )
        FROM tcontent
      </cfquery>
      <!--- state that the db is already created --->
      <cfset dbCreated = true />
    <cfelseif Form.production_datasource EQ "" AND IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND Form.auto_create>  
      <!--- set this to create DB (bsoylu 6/6/2010)  --->
      <cfset errorType = "database" />
    <cfelse>    
      <!--- no datasource has been specified (bsoylu 6/6/2010)  --->
      <cfset errorType = "datasource" />
    </cfif>
    <!--- purposly pose an error since the user decided to try and build the database --->
    <!---
    <cfif isDefined( "FORM.createDatabase" )>
      <cfset errorType = "database" />
    </cfif>
    --->
    <cfcatch type="database">
      <!--- combine the message and detail so we can check against the both as the CFML engines do not contain similar structures of information --->
      <cfset msg = cfcatch.message & cfcatch.detail />
      <!--- check to see if the db is there --->
      <cfif FindNoCase( "tcontent", msg ) or FindNoCase( "00942", msg )>
        <cfset errorType = "database" />
      </cfif>
      <!--- check to see if it's a datasource error --->
      <cfif REFindNoCase( "datasource (.*?) doesn't exist", msg )
        OR REFindNoCase( "can't connect to datasource (.*?)", msg )
        OR FindNoCase( "Login failed", msg )
        OR FindNoCase( "Access denied", msg )>
        <cfset errorType = "datasource" />
      </cfif>   
      <!--- check to see if it's a broken pipe error --->
      <cfif FindNoCase( "broken pipe", msg )>
        <cfset errorType = "brokenpipe" />
      </cfif>
      <!--- if an error is not caught then catch it anyways and log it to a file for review --->
      <cfif not len(errorType)>
        <cfset errorType = "unknown" />
        <cfset errorFile = recordError( cfcatch ) />
      </cfif>
    </cfcatch>
    <cfcatch type="any">
      <!--- if an error is not caught then catch it anyways and log it to a file for review --->
      <cfset errorType = "unknown" />
      <cfset errorFile = recordError( cfcatch ) />
    </cfcatch>
  </cftry>
  <!--- check to make sure the dbtype is not blank --->
  <cfif FORM.production_dbtype IS "">
    <cfset errorType = "dbtype" />
  </cfif>
  <!--- check to make sure the admin email is entered --->
  <cfif FORM.production_adminemail IS "">
    <cfset errorType = "adminEmail" />
  </cfif>

  <!--- ************************ --->
  <!--- STEP 2 --->
  <!--- MESSAGE STEPS --->
  <!--- CREATE DATABASE STEPS --->
  <!--- ************************ --->
  <cfset adminUserID=createUUID()>
  <!--- generate message --->
  <cfswitch expression="#errorType#">
    <!--- datasource --->
    <cfcase value="datasource">
      <cfset message = "<strong>Error:</strong> Either the datasource was not provided, its username/password was incorrect, database permissions were denied for the provided username or the database does not exist" />
    </cfcase>
    <!--- database --->
    <cfcase value="database">
      <cfset message = "<strong>Error:</strong> There was an issue connecting to the database. The database or database tables might not exist." />
      <cfset bProcessWithMessage = true>
      <!--- if it is asked to create the database then do so --->
      <cfif NOT dbCreated AND FORM.production_dbtype IS NOT "">
        <!--- create DataSource and blank Database (bsoylu 6/6/2010)  --->
        <cfif IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND Form.auto_create>
          <!--- need to set datasource name: production_datasource (bsoylu 6/6/2010)  --->
          <cfscript>
            // (bsoylu 6/7/2010) reset the error message and attempt to create the db, ds, etc
            message="";
            objDOA=CreateObject("component","doa.DBController");
            //set db type to use
            objDOA.setDBType(FORM.production_dbtype);
            //set arguments
            sArgs = StructNew();
            sArgs.GWPassword=FORM.production_cfpassword; //is not saved by design
            sArgs.DatabaseServer=Form.production_databaseserver; //TODO: need to add form field
            sArgs.UserName=Form.production_dbusername;
            sArgs.Password=Form.production_dbpassword;
            sArgs.DatasourceName=Form.production_databasename;
            //call ds creation, will automatically create corresponding DB with the same name as the DS
            sReturn=objDOA.fDSCreate(argumentCollection=sArgs);
            // (bsoylu 6/6/2010) display error message
            if (sReturn NEQ "") {
              message = "<strong>Error:</strong> Error during database creation (1):" & sReturn;
              bProcessWithMessage = false;
            } else {
              // (bsoylu 6/7/2010) the default ds name is the App name, so we reset here
              FORM.production_datasource = Form.production_databasename;       
            };
          </cfscript>
        </cfif>
        <cfif bProcessWithMessage>
          <!--- check if we need to process even though there is a message (bsoylu 6/7/2010)  --->
          <!--- try to create the database --->
          <!--- <cftry> --->
            <!--- get selected DB type --->
            <!---
            <cfif server.coldfusion.productname eq "BlueDragon">
              <cffile action="read" file="#ExpandPath('.')#/config/setup/db/#FORM.production_dbtype#.sql" variable="sql" />
            <cfelse>
              <cffile action="read" file="#getDirectoryFromPath( getCurrentTemplatePath() )#/db/#FORM.production_dbtype#.sql" variable="sql" />
            </cfif>
            --->
          <cfset form.production_dbtablespace=ucase(form.production_dbtablespace)>
          <cfsavecontent variable="sql">
            <cfinclude template="db/#FORM.production_dbtype#.sql">
          </cfsavecontent>
          <!---
          <cfsavecontent variable="sql">
            <cfinclude template="db/#FORM.production_dbtype#.sql">
          </cfsavecontent>
          --->
          <!--- we adjust the sql to work with a certain parser for later use to help build out an array --->
          <!--- wrap around try catch (bsoylu 12/4/2010) --->
          <cftry>
            <cfswitch expression="#FORM.production_dbtype#">
              <cfcase value="mssql">
                <!--- if we are working with a SQL db we go ahead and delimit with GO so we can loop over each sql even --->  
                <cfquery name="MSSQLversion" datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
                  SELECT CONVERT(varchar(100), SERVERPROPERTY('ProductVersion')) as version
                </cfquery>
                <cfset MSSQLversion=listFirst(MSSQLversion.version,".")>

                <cfset sql = REReplaceNoCase( sql, "\nGO", ";", "ALL") />
                <cfset aSql = ListToArray(sql, ';')>
                <!--- loop over items --->
                <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
                  <!--- we placed a small check here to skip empty rows --->
                  <cfif len( trim( aSql[x] ) )>
                    <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
                      #mssqlFormat(aSql[x],MSSQLversion)#
                    </cfquery>
                  </cfif>
                </cfloop>
              </cfcase>
              <cfcase value="oracle">
                <!--- if we are working with a ORACLE db we delimit with  --/  so we can loop over each sql even ---> 
                <cfset sql = replace( sql, "--", "", "ALL") />
                <cfset aSql = ListToArray(sql, '|')>
                <!--- loop over items --->
                <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
                  <!--- we placed a small check here to skip empty rows --->
                  <cfif len( trim( aSql[x] ) )>
                    <cfset s=aSql[x]>
                    <!--- <cfset s=replace(s,"/","","ALL")> --->  
                    <cfif not findNocase("/",aSql[x])>
                      <cfset s=replace(s,";","","ALL")>
                    <cfelse>
                      <cfset s=replace(s,"/","","ALL")>
                      <cfset s=replace(s,chr(13)," ","ALL")>
                    </cfif>
                    <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
                      #keepSingleQuotes(s)#
                    </cfquery>
                  </cfif>
                </cfloop>
              </cfcase>
              <cfcase value="mysql" delimiters=",">
                <cfset aSql = ListToArray(sql, ';')>
                <!--- loop over items --->
                <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
                  <!--- we placed a small check here to skip empty rows --->
                  <cfif len( trim( aSql[x] ) )>
                    <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
                      #keepSingleQuotes(aSql[x])#
                    </cfquery>
                  </cfif>
                </cfloop>
              </cfcase>
            </cfswitch>
            <!--- update the domain to be local to the domain the server is being installed on --->
            <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
              UPDATE tsettings
              SET domain = '#listFirst(cgi.http_host,":")#',
                theme = 'MuraBootstrap',
                gallerySmallScaleBy='s',
                gallerySmallScale=80,
                galleryMediumScaleBy='s',
                galleryMediumScale=180,
                galleryMainScaleBy='y',
                galleryMainScale=600
            </cfquery>
             <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
              UPDATE tusers
              SET username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.admin_username#">,
                password=<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.admin_password)#">
              where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#adminUserID#">
            </cfquery>

            <cfset dbCreated=true />
            <!--- reset the error --->
            <cfset errorType = "" />
            <!--- set a message --->
            <cfset message = "" />
            <cfcatch type="any">
              <cfset message = "<strong>Error:</strong> Error during database creation (2). Please ensure you have updated drivers or contact support:" & cfcatch.message & " - " & cfcatch.Detail>
              <cfset bProcessWithMessage = false>
            </cfcatch>
          </cftry>
            <!---<cfcatch>
              <cfset message = "<strong>Error:</strong> There was an issue with creating the database. Check to make sure you are using the right database. If this continues to occur you may just have to run the associated database script manually. You can find it within the /config/setup/db folder of Mura." />
            </cfcatch>
          </cftry> --->
        </cfif>
        <!--- message condition process (bsoylu 6/7/2010)  --->
      </cfif>
      <!--- throw a message if the database already exists --->
      <cfif isDefined( "FORM.createDatabase" ) AND dbCreated>
        <cfset message = "<strong>Error:</strong> Database was not created since it already exists" />
      </cfif>
    </cfcase>
    <!--- broken pipe --->
    <cfcase value="brokenpipe">
      <cfset message = "<strong>Error:</strong> Looks like the database pipe broke, try again." />
    </cfcase>
    <!--- no dbtype --->
    <cfcase value="dbtype">
      <cfset message = "<strong>Error:</strong> A Database type is required. Please select the database you are using." />
    </cfcase>
    <!--- admin email --->
    <cfcase value="adminEmail">
      <cfset message = "<strong>Error:</strong> An Admin Email is required." />
    </cfcase>
    <!--- unknown --->
    <cfcase value="unknown">
      <cfset message = "<strong>Error:</strong> An unknown error has occured." />
    </cfcase>
  </cfswitch>
  
  <!--- if errorFile variable is present then let's append it to the message so the error file can be found --->
  <cfif isDefined( "errorFile" )>
    <cfset message = message & " <a href='#context#/config/setup/errors/#listLast( errorFile, '/')#'>Review the error log</a>." />
  </cfif>
  <!--- if mail server username is not supplied then use the admin mail value --->
  <cfif NOT len( FORM.production_mailserverusername )>
    <cfset FORM.production_mailserverusername = FORM.production_adminemail />
  </cfif>
  
  <!--- ************************ --->
  <!--- STEP 3 --->
  <!--- ************************ --->
  
  <!--- save settings --->
  <cfloop list="#FORM.fieldnames#" index="ele">
    <!--- check to see if we are in one of the proper profiles --->
    <cfif listFindNoCase( validSections, listGetAt( ele, 1, "_" ) )>
      <cfset section = listGetAt( ele, 1, "_" ) />
      <cfset entry = mid( ele, len( section )+2 , len( ele )-len( section ) ) />
      <cfif not listFindNoCase("cfpassword,databaseserver",entry)>
        <!--- set the profile string --->
        <cfset settingsIni.set( section, entry, FORM[ele] ) />
      </cfif>
    </cfif>
  </cfloop>
  
  <!--- ************************ --->
  <!--- STEP 6 --->
  <!--- ************************ --->
  
  <!--- custom settings --->
  
  <!--- usedefaultsmtpserver --->
  <cfif FORM.production_mailserverip IS NOT "" AND FORM.production_mailserverusername IS NOT "">
    <cfset usedefaultsmtpserver = 0 />
    <cfelse>
    <cfset usedefaultsmtpserver = 1 />
  </cfif>
  
  <!--- update setting --->
  <cfset settingsIni.set( "production", "usedefaultsmtpserver", usedefaultsmtpserver ) />
  <!--- only update the database if there are no errors --->
  <!--- this also assumes that the db exists --->
  <cfif dbCreated AND NOT len( errorType )>
    <!--- update the domain to be local to the domain the server is being installed on --->
    <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
      UPDATE tsettings
      SET MailServerIP = '#FORM.production_mailserverip#',
        MailServerUsername = '#FORM.production_mailserverusername#',
        MailServerPassword = '#FORM.production_mailserverpassword#',
        MailServerSMTPPort = '#FORM.production_mailserversmtpport#',
        MailServerPOPPort = '#FORM.production_mailserverpopport#',
        useDefaultSMTPServer = #usedefaultsmtpserver#,
        MailServerTLS = '#FORM.production_mailservertls#',
        MailServerSSL = '#FORM.production_mailserverssl#',
        Contact = '#FORM.production_adminemail#'
    </cfquery>
  </cfif>
  
  <!--- ************************ --->
  <!--- STEP 5 --->
  <!--- ************************ --->
  
  <!--- clean ini since it removes cf tags --->
  <cfset cleanIni( settingsPath ) />
</cfif>

<!--- few minor functions --->
<cffunction name="cleanIni" returntype="void" output="false">
  <cfargument name="iniPath" type="string" required="true" />
  <cfset var abort = "" />
  <cfset var settingsFileContent = "" />
  <cfset var newSettingsFileContent = "" />
  <!--- read ini --->
  <cffile action="read" file="#arguments.iniPath#" variable="settingsFileContent" />
  <!--- rewrite the settings file if necessary --->
  <cfset abort = "<cf" & "abort/>" />
  <!--- check to see if cfabort is in the file --->
  <cfif left( trim( settingsFileContent ), len( abort ) ) IS NOT "<cfabort/>">
    <!--- prepend content --->
    <cfsavecontent variable="newSettingsFileContent">
      <cfoutput>#abort##chr(10)##settingsFileContent#</cfoutput>
    </cfsavecontent>
    <!--- write the settings file back --->
    <cffile action="write" file="#arguments.iniPath#" output="#trim( newSettingsFileContent )#">
  </cfif>
</cffunction>
<cffunction name="keepSingleQuotes" returntype="string" output="false">
  <cfargument name="str">
  <cfreturn preserveSingleQuotes(arguments.str)>
</cffunction>
<cffunction name="mssqlFormat" returntype="string" output="false">
  <cfargument name="str">
  <cfargument name="version">
  <cfif arguments.version eq 8>
    
    <!--- mssql 2000 does not support nvarchar(max) or varbinary(max)--->
    
    <cfset arguments.str=replaceNoCase(arguments.str,"[nvarchar] (max)","[ntext]","ALL")>
    <cfset arguments.str=replaceNoCase(arguments.str,"[varbinary] (max) null","[image] null","ALL")>
  </cfif>
  <cfreturn preserveSingleQuotes(arguments.str)>
</cffunction>
<cffunction name="recordError" returntype="string" output="false">
  <cfargument name="data" type="any" required="true" />
  <cfset var str = "" />
  <cfset var errorFile = "" />
  <cfset var dir = "" />
  <cfif server.coldfusion.productname eq "BlueDragon">
    <cfset errorFile = "#ExpandPath('.')#/config/setup/errors/#createUUID()#_error.html" />
    <cfelse>
    <cfset errorFile = "#getDirectoryFromPath( getCurrentTemplatePath() )#errors/#createUUID()#_error.html" />
  </cfif>
  <!--- make sure the error directory exists --->
  <cfset dir = getDirectoryFromPath(errorFile) />
  <cfif not directoryExists(dir)>
    <cfdirectory action="create" directory="#dir#" />
  </cfif>
  <!--- dump the error into a variable --->
  <cfsavecontent variable="str">
    <cfdump var="#arguments.data#">
  </cfsavecontent>
  <!--- write the file --->
  <cffile action="write" file="#errorFile#" output="#str#" />
  <!--- send back the location --->
  <cfreturn errorFile />
</cffunction>

<cfoutput>
<!doctype html>
<html lang="en" class="mura">
<head>
<title>Mura CMS - Set Up</title>
<meta charset="utf-8">
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />
<meta name="robots" content="noindex, nofollow, noarchive" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="author" content="Blue River Interactive Group">
<meta name="robots" content="noindex, nofollow, noarchive" />
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />

<!-- Le fav and touch icons -->
<link rel="shortcut icon" href="#context#/admin/assets/ico/favicon.ico">
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="#context#/admin/assets/ico/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#context#/admin/assets/ico/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#context#/admin/assets/ico/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="#context#/admin/assets/ico/apple-touch-icon-57-precomposed.png">
<link rel="icon" href="#context#/admin/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="#context#/admin/images/favicon.ico" type="image/x-icon" />

<!-- CSS -->
<link href="#context#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />

<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->

<!-- Spinner JS -->
<script src="#context#/admin/assets/js/spin.min.js" type="text/javascript" language="Javascript"></script>

<!-- Mura Admin JS -->
<script src="#context#/admin/assets/js/admin.js" type="text/javascript" language="Javascript"></script>

<!-- jQuery -->
<script src="#context#/admin/assets/js/jquery/jquery.js" type="text/javascript"></script>
<script src="#context#/admin/assets/js/jquery/jquery.spin.js" type="text/javascript" language="Javascript"></script>
<script src="#context#/admin/assets/js/jquery/jquery.collapsibleCheckboxTree.js" type="text/javascript"></script>
<script src="#context#/admin/assets/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="#context#/admin/assets/js/jquery/jquery-ui-i18n.min.js" type="text/javascript"></script>
<link href="#context#/admin/assets/css/jquery/default/jquery.ui.all.css" rel="stylesheet" type="text/css" />

<!-- JSON -->
<script src="#context#/admin/assets/js/json2.js" type="text/javascript" language="Javascript"></script>

<!--- added script (bsoylu 5/23/2010)  --->
<script src="#context#/admin/assets/js/SetupUtilities.js?=1" type="text/javascript" language="Javascript"></script>
<link rel="icon" href="#context#/admin/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="#context#/admin/images/favicon.ico" type="image/x-icon" />
<!---
<cfif cgi.http_user_agent contains 'msie'>
<!--[if IE 7]>
<link href="#context#/admin/assets/css/ie.min.css" rel="stylesheet" type="text/css" />
<![endif]-->
</cfif>
--->
</head>

<body id="cSetUp">
<header>
  <div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container">
        <a class="brand" href="http://www.getmura.com" title="Mura CMS">Mura CMS</a>
	      <div class="brand-credit">by Blue River</div>	
      </div>
    </div>
  </div>
</header>
<div class="main">
  <div class="main-inner"> 
    <!---  <div class="container"> --->
    <h1>Mura Set Up</h1>
    <cfif len( trim( message ) )>
      <p class="alert alert-error">#message#</p>
    </cfif>
    
    <!--- need to pass on form object to JS to avoid exception, also added try/catch in admin js (bsoylu 6/7/2010) --->
    <script>
      function processInstallFrm(frm){
        if(validateForm(frm)){
          actionModal(function(){});
          return true;
        } else {
          return false;
        }
      }

    </script>
    <form id="frm" class="form-horizontal<cfif isDefined( "FORM.#application.setupSubmitButton#" ) AND errorType IS ""> install-complete<cfelse> setup-form</cfif>" name="frm" action="index.cfm" method="post" onsubmit="return processInstallFrm(this);" onclick="return validateForm(this);">
   
      <cfif isDefined( "FORM.#application.setupSubmitButton#" ) AND errorType IS "">
        <div id="installationComplete" class="alert alert-success">
          <p>Mura is now set up and ready to use.</p>
        </div>
       
        <div class="alert alert-error">
          <p>When you are done with setup, it is recommended you remove the "/config/setup" directory to maintain security. Once deleted, all settings can be edited in "/config/settings.ini.cfm" directly.</p></div>
         
        <div id="finishSetUp" class="form-actions">
        	<input type="submit" class="btn" name="#application.setupSubmitButtonComplete#" value="Login to Mura" />
        </div>
 
      
      <cfelse>
      <h3>Required Settings</h3>
      <cfscript>
        //determine server type
        //determine db and then show automatic vs manal options
        //either "ColdFusion Server" OR "Railo"
        //attempted to use : application.configBean.getCompiler() eq "Railo" without success
        theCFServer = "unknown";
        if (server.ColdFusion.ProductName CONTAINS "Railo"){
          theCFServer = "Railo";
        } else if (server.ColdFusion.ProductName CONTAINS "BlueDragon") {
          theCFServer = "BlueDragon"; 
        } else if (server.ColdFusion.ProductName CONTAINS "ColdFusion") {
          theCFServer = "ColdFusion";
        };
      </cfscript>
      <fieldset class="alert">
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="Please select a database from the list of supported databases">Database <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <select class="span2" name="production_dbtype" id="production_dbtype" onChange="javascript:fHandleAutoCreateChange()">
              <option value="">-- Select your Database Type --</option>
              <option value="mysql" <cfif FORM.production_dbtype IS "mysql">selected</cfif>>MySQL</option>
              <option value="mssql" <cfif FORM.production_dbtype IS "mssql">selected</cfif>>MSSQL</option>
              <option value="oracle" <cfif FORM.production_dbtype IS "oracle">selected</cfif>>Oracle</option>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="For MySQL and MS SQL Server, Mura can create the database and DSNs. You can create a database and use your own DSNs by setting this option to No." onClick="fHandleAutoCreateChange()">Auto Create Database <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <label class="inline radio">
              <input type="radio" name="auto_create" value="Yes" id="auto_create_on"  onclick="javascript:fHandleAutoCreateChange()">
              Yes</label>
            <label class="inline radio">
              <input type="radio" name="auto_create" value="No" id="auto_create_off" checked onClick="javascript:fHandleAutoCreateChange()">
              No </label>
          </div>
        </div>
        
        <!--- changes below (bsoylu 6/7/2010)  ---> 
        <span id="ac_dsn_span" >
          <div class="control-group">
            <label class="control-label"><a href="" rel="tooltip" data-original-title="The Data Source Name (DSN) created for Mura. This is usually done in the ColdFusion or Railo administrator, or in the control panel of your host if you are installing Mura in a shared environment. Please note that if you are installing Mura in a shared environment, this will likely need to be changed to something other than "muradb" to make sure it is unique to the server.">Datasource (DSN) <i class="icon-question-sign"></i></a></label>
            <div class="controls">
              <input type="text" name="production_datasource" value="#FORM.production_datasource#">
            </div>
          </div>
        </span>
        <span id="ac_cfpass_span" style="display:none;">
          <div class="control-group">
            <label class="control-label"><a href="" rel="tooltip" data-original-title="The #theCFServer# password is needed to create a datasource for you. You can create a datasource yourself by selecting No to the Auto Create option.">#theCFServer# password <i class="icon-question-sign"></i></a></label>
            <div class="controls">
              <input type="password" name="production_cfpassword" value="">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label"><a href="" rel="tooltip" data-original-title="The Server on which to create a datasource for you. If this is located on the same server as #theCFServer# you can use localhost.">Database Server <i class="icon-question-sign"></i></a></label>
            <div class="controls">
              <input type="text" name="production_databaseserver" value="#FORM.production_databaseserver#" maxlength="75">
            </div>
          </div>
        </span>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="Only required on shared hosting. This is the same Username supplied to your DSN to allow Mura to connect to your database.">Database Username <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_dbusername" value="#FORM.production_dbusername#">
          </div>
        </div>
      
          <div class="control-group">
            <label class="control-label"><a href="" rel="tooltip" data-original-title="Only required on shared hosting. This is the same Password supplied to your DSN to allow Mura to connect to your database.">Database Password <i class="icon-question-sign"></i></a></label>
            <div class="controls">
              <input type="password" name="production_dbpassword" value="#FORM.production_dbpassword#">
            </div>
          </div>
          <span id="oracle-only" style="display:none;">
          <div class="control-group">
            <label class="control-label"><a href="" rel="tooltip" data-original-title="Only required if you are using Oracle.">Oracle TableSpace <i class="icon-question-sign"></i></a></label>
            <div class="controls">
              <input type="text" name="production_dbtablespace" value="#FORM.production_dbtablespace#">
            </div>
          </div>
        </span>
        <input type="hidden" name="production_assetpath" value="#FORM.production_assetpath#">
        <input type="hidden" name="production_context" value="#FORM.production_context#">
        
        <!--- port --->
        
        <input type="hidden" name="production_port" value="<cfif cgi.server_port IS "" AND FORM.production_port IS "">80<cfelse>#FORM.production_port#</cfif>">
       
         <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="This is the username of the Mura super user account that will be created">Super Admin Username <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="admin_username" value="#FORM.admin_username#">
          </div>
        </div>
      
         <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="This is the password of the Mura super user account that will be created">Super Admin Password <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="admin_password" value="#FORM.admin_password#">
          </div>
        </div>

         <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="The email address used by Mura to send global system emails. Example: user@domain.com.">Admin Email Address <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_adminemail" value="#FORM.production_adminemail#">
          </div>
        </div>
      </fieldset>
      <h3>Optional Settings</h3>
      <p>By default, Mura is set to use the mail server specified in your application server. If you would like to override this setting to use a specific mail server and mail account, complete the settings below.</p>
      <div class="fieldset">
        <!---
<div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="The Mail Server used by Mura to send global system emails. Example: mail.domain.com, 278.23.45.697.">Mail Server <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_mailserverip" value="#FORM.production_mailserverip#">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="This is the username used to log into and send emails from the Admin Email account. This may or may not be the same as Admin Email Address.">Mail Server Username <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_mailserverusername" value="#FORM.production_mailserverusername#">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="The password used to log into the Admin Email account.">Mail Server Password <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_mailserverpassword" value="#FORM.production_mailserverpassword#">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="Edit this value to override the default, port 25.">Mail Server SMTP Port <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_mailserversmtpport" value="#FORM.production_mailserversmtpport#">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="Edit this value to override the default, port 110.">Mail Server POP Port <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <input type="text" name="production_mailserverpopport" value="#FORM.production_mailserverpopport#">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="Transport Layer Security: Used by some mail providers (Google, for example) to securely send/receive email.">Use TLS <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <select name="production_mailservertls">
              <option value="false" <cfif not form.production_mailservertls>selected</cfif>>No</option>
              <option value="true" <cfif form.production_mailservertls>selected</cfif>>Yes</option>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="Secure Socket Layer: Another method used to securely send/receive email.">Use SSL <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <select name="production_mailserverssl">
              <option value="false" <cfif not form.production_mailserverssl>selected</cfif>>No</option>
              <option value="true" <cfif form.production_mailserverssl>selected</cfif>>Yes</option>
            </select>
          </div>
        </div>
--->
        
        <!--- <cfdump var="#form.production_siteidinurls#"> --->
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="SiteID's are shown as sub-directories for each site in your Mura install. When SiteIDs are not in URLs you must ensure that each site has it's own unique domain.">Use SiteIDs in URLs <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <label class="inline radio">
              <input type="radio" name="production_siteidinurls" value="1" id="siteidinurls_on"<cfif yesNoFormat(form.production_siteidinurls)> checked</cfif>>
              Yes</label>
            <label class="inline radio">
              <input type="radio" name="production_siteidinurls" value="0" id="siteidinurls_off"<cfif not yesNoFormat(form.production_siteidinurls)> checked</cfif>>
              No</label>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"><a href="" rel="tooltip" data-original-title="If set to 'No' you must ensure that you have properly configured your webserver's URL rewriting. Toggling this alone will not remove index.cfm from yoru URLs.">Use "index.cfm" in URLS <i class="icon-question-sign"></i></a></label>
          <div class="controls">
            <label class="inline radio">
              <input type="radio" name="production_indexfileinurls" value="1" id="indexfileinurls_on"<cfif yesNoFormat(form.production_indexfileinurls)> checked</cfif>>
              Yes</label>
            <label class="inline radio">
              <input type="radio" name="production_indexfileinurls" value="0" id="indexfileinurls_off"<cfif not yesNoFormat(form.production_indexfileinurls)> checked</cfif>>
              No </label>
          </div>
        </div>
      </div>
      <div class="form-actions">
        <input class="btn" type="submit" name="#application.setupSubmitButton#" value="Save Settings" />
      </div>
      </cfif>
    </form>
  
</div>
<script type="text/javascript" language="javascript">
jQuery(document).ready(function(){
  $('form:not(.filter) :input:visible:first').focus();
  $('[rel=tooltip]').tooltip();
});
</script>
<cfif cgi.http_user_agent contains 'msie'>
<!--[if IE 6]>
<script type="text/javascript" src="#context#/admin/assets/js/ie6notice.js"></script>
<![endif]-->
</cfif>
<!-- Le javascript
================================================== --> 
<!-- Placed at the end of the document so the pages load faster --> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-transition.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-alert.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-modal.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-dropdown.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-scrollspy.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-tab.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-tooltip.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-popover.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-button.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-collapse.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-carousel.js"></script> 
<script src="#context#/admin/assets/bootstrap/js/bootstrap-typeahead.js"></script>
</body>
</html>
</cfoutput>