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
<cfparam name="FORM.auto_create" default="No" />

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
<cfif isDefined( "FORM.#cookie.setupSubmitButtonComplete#" )>
	<!--- state we are done --->
	<!---
	<cfset settingsIni.set( "settings", "installed", 1 ) />
	
	<!--- clean ini since it removes cf tags --->
	<cfset cleanIni( settingsPath ) />
	--->
	<!--- cflocate to the admin --->
	<cflocation url="#webRoot#/admin/index.cfm?appreload" addtoken="false" />
</cfif>

<!--- run save process --->
<cfif isDefined( "FORM.#cookie.setupSubmitButton#" )>
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
				FROM
				tcontent
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
						sArgs.DatasourceName=Application.ApplicationName;
						//call ds creation, will automatically create corresponding DB with the same name as the DS
						sReturn=objDOA.fDSCreate(argumentCollection=sArgs);
						// (bsoylu 6/6/2010) display error message
						if (sReturn NEQ "")	{
							message = "<strong>Error:</strong> Error during database creation (1):" & sReturn;		
							bProcessWithMessage = false;					
						} else {
							// (bsoylu 6/7/2010) the default ds name is the App name, so we reset here
							FORM.production_datasource = Application.ApplicationName;
						}
					</cfscript>					
				</cfif>	
						
				<cfif bProcessWithMessage> <!--- check if we need to process even though there is a message (bsoylu 6/7/2010)  --->
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
								EXEC sp_MSgetversion
								</cfquery>

								<cftry>
									<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>
									<cfcatch>
										<cfset MSSQLversion=mid(MSSQLversion.COMPUTED_COLUMN_1,1,find(".",MSSQLversion.COMPUTED_COLUMN_1)-1)>
									</cfcatch>
								</cftry>								
								
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
							UPDATE 
								tsettings
							SET
								domain = '#listFirst(cgi.http_host,":")#',
								theme = 'merced',
								gallerySmallScaleBy='s',
								gallerySmallScale=80,
								galleryMediumScaleBy='s',
								galleryMediumScale=180,
								galleryMainScaleBy='y',
								galleryMainScale=600
						</cfquery>
					   
					   <cfset dbCreated=true />
						<cfset errorType = "" />
						<!--- reset the error --->
						<cfset errorType = "" />
						<!--- set a message --->
						<cfset message = "" />
						
						<cfcatch type="any">
							<cfset message = "<strong>Error:</strong> Error during database creation (2). Please ensure you have updated drivers or contact support:" & cfcatch.message & " - " & cfcatch.Detail>
							<cfset bProcessWithMessage = false>
						</cfcatch>
					</cftry>					
					<!--- <cfcatch>
						<cfset message = "<strong>Error:</strong> There was an issue with creating the database. Check to make sure you are using the right database. If this continues to occur you may just have to run the associated database script manually. You can find it within the /config/setup/db folder of Mura." />
					</cfcatch>
				</cftry> --->
				</cfif> <!--- message condition process (bsoylu 6/7/2010)  --->
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
		<cfset message = message & " <a href='#webRoot#/config/setup/errors/#listLast( errorFile, '/')#'>Review the error log</a>." />
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
			UPDATE 
				tsettings
			SET
				MailServerIP = '#FORM.production_mailserverip#',
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
			<cfoutput>
			#abort##chr(10)##settingsFileContent#
			</cfoutput>
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<cfoutput>
<head>
<title>Mura CMS - Set Up</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />
<meta name="robots" content="noindex, nofollow, noarchive" />
<script src="#webRoot#/admin/js/admin.js" type="text/javascript" language="Javascript"></script>
<!--- added script (bsoylu 5/23/2010)  --->
<script src="#webRoot#/admin/assets/js/SetupUtilities.js?=1" type="text/javascript" language="Javascript"></script>

<link href="#webRoot#/admin/css/admin.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="#webRoot#/admin/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="#webRoot#/admin/images/favicon.ico" type="image/x-icon" />
<!--[if IE]>
<link href="#webRoot#/admin/css/ie.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
<link href="#webRoot#/admin/css/ie6.css" rel="stylesheet" type="text/css" />
<![endif]-->
</head>
</cfoutput>
<body id="cSetUp" >
<div id="header"><a id="blueRiverLink" href="http://blueriver.com" target="_blank" title="mura by blueRiver"></a><p id="version">Version 5.6</p><h1>Mura CMS</h1></div>

<div id="content">
<h2>Mura Set Up</h2>
<cfoutput>
<cfif len( trim( message ) )><p class="error">#message#</p></cfif>
<!--- need to pass on form object to JS to avoid exception, also added try/catch in admin js (bsoylu 6/7/2010) --->
<form id="frm" name="frm" action="index.cfm" method="post" onclick="return validateForm(this);">


<cfif isDefined( "FORM.#cookie.setupSubmitButton#" ) AND errorType IS "">
		<div id="installationComplete" class="success">
			<p id="congrats">Mura is now set up and ready to use.</p>
			<h3>Important</h3>
			<p>When you are done with setup, it is recommended you remove the "/config/setup" directory to maintain security. Once deleted, all settings can be edited in "/config/settings.ini.cfm" directly.</p>
			<p class="error">The default <strong>Username and Password is the word "admin" for both fields</strong>. It is highly recommended that you change this immediately by editing your profile after logging into the Mura Admin.</p>
			<input type="submit" name="#cookie.setupSubmitButtonComplete#" value="Finish Set Up and Take Me to the Mura Admin" />
		</div>
</cfif>

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
}

</cfscript>
	
<dl class="twoColumn notice">
	
	<dt><a href="" class="tooltip">Database<span>Please select a database from the list of supported databases</span></a></dt>
	<dd><select name="production_dbtype" id="production_dbtype" onchange="javascript:fHandleAutoCreateChange()">
		<option value="">-- Select your Database Type --</option>
		<option value="mysql" <cfif FORM.production_dbtype IS "mysql">selected</cfif>>MySQL</option>
		<option value="mssql" <cfif FORM.production_dbtype IS "mssql">selected</cfif>>MSSQL</option>
		<option value="oracle" <cfif FORM.production_dbtype IS "oracle">selected</cfif>>Oracle</option>
	</select>
	</dd>

	<dt><a href="" class="tooltip" onclick="fHandleAutoCreateChange()">Auto Create Database<span>For MySQL and MS SQL Server, Mura can create the database and DSNs. You can create a database and use your own DSNs by setting this option to No.</span></a></dt>
	<dd><input type="radio" class="radio" name="auto_create" value="Yes" id="auto_create_on"  onclick="javascript:fHandleAutoCreateChange()"> Yes 
	    <input type="radio" class="radio" name="auto_create" value="No" id="auto_create_off" checked onclick="javascript:fHandleAutoCreateChange()"> No      
	</dd>
	<!--- changes below (bsoylu 6/7/2010)  --->
	<span id="ac_dsn_span" >	
	<dt><a href="" class="tooltip">Datasource (DSN)<span>The Data Source Name (DSN) created for Mura. This is usually done in the ColdFusion or Railo administrator, or in the control panel of your host if you are installing Mura in a shared environment. Please note that if you are installing Mura in a shared environment, this will likely need to be changed to something other than "muradb" to make sure it is unique to the server.</span></a></dt>
	<dd><input type="text" name="production_datasource" value="#FORM.production_datasource#"></dd>
	</span>

	<span id="ac_cfpass_span" style="display:none;">	
	<dt><a href="" class="tooltip">#theCFServer# password<span>The #theCFServer# password is needed to create a datasource for you. You can create a datasource yourself by selecting No to the Auto Create option.</span></a></dt>
	<dd><input type="password" name="production_cfpassword" value=""></dd>
	
	<dt><a href="" class="tooltip">Database Server<span>The Server on which to create a datasource for you. If this is located on the same server as #theCFServer# you can use localhost.</span></a></dt>
	<dd><input type="text" name="production_databaseserver" value="#FORM.production_databaseserver#" maxlength="75"></dd>	
	</span>	
	
	
	<dt><a href="" class="tooltip">Database Username<span>Only required on shared hosting. This is the same Username supplied to your DSN to allow Mura to connect to your database.</span></a></dt>
	<dd><input type="text" name="production_dbusername" value="#FORM.production_dbusername#"></dd>
	
	<dt><a href="" class="tooltip">Database Password<span>Only required on shared hosting. This is the same Password supplied to your DSN to allow Mura to connect to your database.</span></a></dt>
	<dd><input type="password" name="production_dbpassword" value="#FORM.production_dbpassword#"></dd>
	<dt><a href="" class="tooltip">Oracle TableSpace<span>Only required if you are using Oracle.</span></a></dt>
	<dd><input type="text" name="production_dbtablsspace" value="#FORM.production_dbtablespace#"></dd>
	
	<input type="hidden" name="production_assetpath" value="#FORM.production_assetpath#">
	<!---
	<dt><a href="" class="tooltip">Asset Path<span>The URL to where assets uploaded through Mura (images, files, etc) are stored. Can be a domain or root relative path.
<em>Example: http://assets.domain.com, /tasks/sites (no trailing slash)</em></span></a></dt>
	<dd><input type="text" name="production_assetpath" value="#FORM.production_assetpath#"></dd>
	--->
	
	<input type="hidden" name="production_context" value="#FORM.production_context#">
	<!---
	<dt><a href="" class="tooltip">Context<span>If you are installing Mura into a sub-directory, you will need to set the context to that directory.
<em>Example: /nameofdirectory</em> (Note there is no trailing slash)</span></a></dt>
	<dd><input type="text" name="production_context" value="#FORM.production_context#"></dd>
	--->
	
	<!--- port --->
	<input type="hidden" name="production_port" value="<cfif cgi.server_port IS "" AND FORM.production_port IS "">80<cfelse>#FORM.production_port#</cfif>">
	
	<!---
	<dt><a href="" class="tooltip">Create Tables &amp; Schema<span>If you have already set up Mura and are just updating settings here, uncheck this box</span></a></dt>
	<dd><input type="checkbox" name="createDatabase" value="Yes" <cfif isDefined( "FORM.createDatabase" ) AND FORM.createDatabase>checked</cfif>>
	--->
	
	
	<dt><a href="" class="tooltip">Admin Email Address<span>The email address used by Mura to send global system emails. Example: user@domain.com.</span></a></dt>
	<dd><input type="text" name="production_adminemail" value="#FORM.production_adminemail#"></dd>
	</dl>
	
<h3>Optional Settings</h3>
<p>By default, Mura is set to use the mail server specified in your application server. If you would like to override this setting to use a specific mail server and mail account, complete the settings below.</p>
	<dl class="twoColumn">
	<dt><a href="" class="tooltip">Mail Server<span>The Mail Server used by Mura to send global system emails. Example: mail.domain.com, 278.23.45.697.</span></a></dt>
	<dd><input type="text" name="production_mailserverip" value="#FORM.production_mailserverip#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server Username<span>This is the username used to log into and send emails from the Admin Email account. This may or may not be the same as Admin Email Address.</span></a></dt>
	<dd><input type="text" name="production_mailserverusername" value="#FORM.production_mailserverusername#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server Password<span>The password used to log into the Admin Email account.</span></a></dt>
	<dd><input type="text" name="production_mailserverpassword" value="#FORM.production_mailserverpassword#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server SMTP Port<span>Edit this value to override the default, port 25.</span></a></dt>
	<dd><input type="text" name="production_mailserversmtpport" value="#FORM.production_mailserversmtpport#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server POP Port<span>Edit this value to override the default, port 110.</span></a></dt>
	<dd><input type="text" name="production_mailserverpopport" value="#FORM.production_mailserverpopport#"></dd>
	
	<dt><a href="" class="tooltip">Use TLS<span>Transport Layer Security: Used by some mail providers (Google, for example) to securely send/receive email.</span></a></dt>
	<dd>
		<select name="production_mailservertls">				
			<option value="false" <cfif not form.production_mailservertls>selected</cfif>>No</option>
			<option value="true" <cfif form.production_mailservertls>selected</cfif>>Yes</option>
		</select>
	</dd>
	
	<dt><a href="" class="tooltip">Use SSL<span>Secure Socket Layer: Another method used to securely send/receive email.</span></a></dt>
	<dd>
	<select name="production_mailserverssl">				
		<option value="false" <cfif not form.production_mailserverssl>selected</cfif>>No</option>
		<option value="true" <cfif form.production_mailserverssl>selected</cfif>>Yes</option>
	</select>
	</dd>
	<!--- <cfdump var="#form.production_siteidinurls#"> --->
	<dt><a href="" class="tooltip">Use SiteIDs in URLs<span>When SiteIDs are not in URLs you must ensure that each site has it's own unique domain.</span></a></dt>
	<dd><input type="radio" name="production_siteidinurls" value="1" id="siteidinurls_on"<cfif yesNoFormat(form.production_siteidinurls)> checked</cfif>> Yes 
	    <input type="radio" name="production_siteidinurls" value="0" id="siteidinurls_off"<cfif not yesNoFormat(form.production_siteidinurls)> checked</cfif>> No      
	</dd>
	<dt><a href="" class="tooltip">Use "index.cfm" in URLS<span>If set to "No" you must ensure that you have properly configured your webserver's URL rewriting. Toggling this alone will not remove index.cfm from yoru URLs.</span></a></dt>
	<dd><input type="radio" class="radio" name="production_indexfileinurls" value="1" id="indexfileinurls_on"<cfif yesNoFormat(form.production_indexfileinurls)> checked</cfif>> Yes 
	    <input type="radio" class="radio" name="production_indexfileinurls" value="0" id="indexfileinurls_off"<cfif not yesNoFormat(form.production_indexfileinurls)> checked</cfif>> No      
	</dd>
	</dl>

	<input class="submit" type="submit" name="#cookie.setupSubmitButton#" value="Save Settings" />
</form>
</cfoutput>

<!--- <p>If you are setting up a Staging <em>and</em> Production type of configuration, you'll need to create the Staging set up manually in "/config/settings.ini.cfm"</p> --->

</div>
<script type="text/javascript" language="javascript">
document.forms[0].elements[0].focus();
</script>

</body>
</html>