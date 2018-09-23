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

<!--- run save process --->

<cfif isDefined( "FORM.setupSubmitButton" )>
  <!--- save settings --->
  <cfset validSections = "production,settings" />
  <!--- ************************ --->
  <!--- STEP 1 --->
  <!--- ************************ --->

  <!--- check datasource --->
  <cfset errorType = "" />
  <cfset dbCreated = false />

  <!--- remove datasource for now entered if we are supposed to create one (bsoylu 6/7/2010)  --->
  <!--- <cfif Form.production_datasource NEQ "" AND IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND not Form.auto_create>
    <cfset FORM.production_datasource="">
  </cfif> --->

  <cfset queryAttrs={
    datasource="#FORM.production_datasource#",
    username="#FORM.production_dbusername#",
    password="#FORM.production_dbpassword#",
    name="rs"
  }>
  <cfif not len(FORM.production_dbusername)>
    <cfset structDelete(queryAttrs,'username')>
    <cfset structDelete(queryAttrs,'password')>
  </cfif>
  <cftry>
    <!--- do not run if we do not have a datasource (bsoylu 6/6/2010)  --->
    <cfif Form.production_datasource NEQ "" and IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND not Form.auto_create>
      <!--- try to run a basic query --->
      <cfquery attributeCollection="#queryAttrs#">
        SELECT COUNT( contentid )
        FROM tcontent
      </cfquery>
      <!--- state that the db is already created --->
      <cfset dbCreated = true />
    <cfelseif Form.production_datasource EQ "" AND IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND Form.auto_create>
      <!--- set this to create DB (bsoylu 6/6/2010)  --->
      <cfset errorType = "database" />
    <cfelseif Form.production_datasource EQ "" AND IsDefined("Form.auto_create") AND IsBoolean(Form.auto_create) AND NOT Form.auto_create>
      <!--- no datasource has been specified (bsoylu 6/6/2010)  --->
      <cfset errorType = "datasource" />
    <cfelse>
      <!--- If we need to create a database & datasource --->
      <cfset errorType = "database" />
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

						if(isDefined('FORM.production_datasource') && len(FORM.production_datasource)){
							sArgs.DatasourceName = FORM.production_datasource;
							sArgs.DatabaseName = FORM.production_datasource;
						} else {
							sArgs.DatasourceName = Form.production_databasename;
							sArgs.DatabaseName = FORM.production_databasename;
						}

            //call ds creation, will automatically create corresponding DB with the same name as the DS
            sReturn=objDOA.fDSCreate(argumentCollection=sArgs);
            // (bsoylu 6/6/2010) display error message
            if (sReturn NEQ "") {
              message = "<strong>Error:</strong> Error during database creation (1):" & sReturn;
              bProcessWithMessage = false;
            } else {
              // (bsoylu 6/7/2010) the default ds name is the App name, so we reset here
							if(isDefined('FORM.production_datasource') && len(FORM.production_datasource)){
								FORM.production_datasource = FORM.production_datasource;
								queryAttrs.datasource = FORM.production_datasource;
							} else {
								FORM.production_datasource = FORM.production_databasename;
								queryAttrs.datasource = FORM.production_databasename;
							}
            };
          </cfscript>

            <cfif form.production_dbtype eq 'Oracle'>
            <cfset form.production_dbtablespace=ucase(form.production_dbtablespace)>

            <cfquery attributeCollection="#queryAttrs#">
                select * from user_ts_quotas
                where tablespace_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.production_dbtablespace#">
            </cfquery>

            <cfif not rs.recordcount>
                <cfset message = "<strong>Error:</strong> The Oracle tablespace named '#form.production_dbtablespace#' is not available">
                <cfset bProcessWithMessage = false>
            </cfif>
          </cfif>

        </cfif>
        <cfif bProcessWithMessage>
          <!--- try to create the database --->
          <!--- <cftry> --->

          <!--- get selected DB type --->
          <cfif len(FORM.production_dbusername)>
            <cfdbinfo
              name="rsCheck"
              datasource="#FORM.production_datasource#"
              username="#FORM.production_dbusername#"
              password="#FORM.production_dbpassword#"
              type="version">
          <cfelse>
            <cfdbinfo
              name="rsCheck"
              datasource="#FORM.production_datasource#"
              type="version">
          </cfif>

          <cfif rsCheck.database_productname eq 'H2'>
            <cfsavecontent variable="sql">
              <cfinclude template="../db/h2.sql">
            </cfsavecontent>
          <cfelse>
            <cfparam name="form.production_mysqlengine" default="InnoDB">
            <cfset storageEngine="ENGINE=#form.production_mysqlengine# DEFAULT CHARSET=utf8">

            <cfsavecontent variable="sql">
              <cfinclude template="../db/#FORM.production_dbtype#.sql">
            </cfsavecontent>
          </cfif>

          <!---
          <cfsavecontent variable="sql">
            <cfinclude template="../db/#FORM.production_dbtype#.sql">
          </cfsavecontent>
          --->
          <!--- we adjust the sql to work with a certain parser for later use to help build out an array --->
          <!--- wrap around try catch (bsoylu 12/4/2010) --->
          <cftry>
            <cfswitch expression="#FORM.production_dbtype#">
              <cfcase value="mssql">
                <!--- if we are working with a SQL db we go ahead and delimit with GO so we can loop over each sql even --->
                <cfquery attributeCollection="#queryAttrs#">
                  SELECT CONVERT(varchar(100), SERVERPROPERTY('ProductVersion')) as version
                </cfquery>
                <cfset MSSQLversion=listFirst(rs.version,".")>

                <cfset sql = REReplaceNoCase( sql, "\nGO", ";", "ALL") />
                <cfset aSql = ListToArray(sql, ';')>
                <!--- loop over items --->
                <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
                  <!--- we placed a small check here to skip empty rows --->
                  <cfif len( trim( aSql[x] ) )>
                    <cfquery attributeCollection="#queryAttrs#">
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
                    <cfquery attributeCollection="#queryAttrs#">
                      #keepSingleQuotes(s)#
                    </cfquery>
                  </cfif>
                </cfloop>
              </cfcase>
              <cfcase value="mysql">

                <cfset aSql = ListToArray(sql, ';')>
                <!--- loop over items --->
                <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
                  <!--- we placed a small check here to skip empty rows --->
                  <cfif len( trim( aSql[x] ) )>
                    <cfquery attributeCollection="#queryAttrs#">
                      #keepSingleQuotes(aSql[x])#
                    </cfquery>
                  </cfif>
                </cfloop>
              </cfcase>
				<cfcase value="postgresql,nuodb">
				  <cfset aSql = ListToArray(sql, ';')>
				  <!--- loop over items --->
				  <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
					<!--- we placed a small check here to skip empty rows --->
					<cfif len( trim( aSql[x] ) )>
					  <cfquery attributeCollection="#queryAttrs#">
						#keepSingleQuotes(aSql[x])#
					  </cfquery>
					</cfif>
				  </cfloop>
				</cfcase>
            </cfswitch>
            <!--- update the domain to be local to the domain the server is being installed on --->
            <cfset domain=listFirst(cgi.http_host,":")>
            <cfif domain eq '127.0.0.1'>
                <cfset domain='localhost'>
            </cfif>
            <cfquery attributeCollection="#queryAttrs#">
              UPDATE tsettings
              SET domain = '#domain#',
                theme = 'default',
                gallerySmallScaleBy='s',
                gallerySmallScale=80,
                galleryMediumScaleBy='s',
                galleryMediumScale=180,
                galleryMainScaleBy='y',
                galleryMainScale=600
            </cfquery>
             <cfquery attributeCollection="#queryAttrs#">
              UPDATE tusers
              SET username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.admin_username#">,
                password=<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.admin_password)#">,
                email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.production_adminemail#">
              where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#adminUserID#">
            </cfquery>

            <cfset dbCreated=true />
            <!--- reset the error --->
            <cfset errorType = "" />
            <!--- set a message --->
            <cfset message = "" />
            <cfcatch type="any">
              <cfrethrow>
              <cfset message = "<strong>Error:</strong> Error during database creation (2). Please ensure you have updated drivers or contact support:" & cfcatch.message & " - " & cfcatch.Detail>
              <cfset bProcessWithMessage = false>
            </cfcatch>
          </cftry>
            <!---<cfcatch>
              <cfset message = "<strong>Error:</strong> There was an issue with creating the database. Check to make sure you are using the right database. If this continues to occur you may just have to run the associated database script manually. You can find it within the /core/setup/db folder of Mura." />
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
      <cfset message = "<strong>Error:</strong> An unknown error has occurred." />
    </cfcase>
  </cfswitch>

  <!--- if errorFile variable is present then let's append it to the message so the error file can be found --->
  <cfif isDefined( "errorFile" )>
    <cfset message = message & " <a href='#context#/core/setup/errors/#listLast( errorFile, '/')#'>Review the error log</a>." />
  </cfif>
  <!--- if mail server username is not supplied then use the admin mail value --->
  <!---
  <cfif NOT len( FORM.production_mailserverusername )>
      <cfset FORM.production_mailserverusername = FORM.production_adminemail />
    </cfif> --->


  <!--- ************************ --->
  <!--- STEP 3 --->
  <!--- ************************ --->

  <!--- save settings --->
  <cfif NOT len( errorType )>
    <cfloop list="#structKeyList(FORM)#" index="ele">
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
  </cfif>

  <!--- ************************ --->
  <!--- STEP 6 --->
  <!--- ************************ --->

  <!--- custom settings --->

  <!--- usedefaultsmtpserver --->
 <!---
  <cfif FORM.production_mailserverip IS NOT "" AND FORM.production_mailserverusername IS NOT "">
     <cfset usedefaultsmtpserver = 0 />
     <cfelse>
     <cfset usedefaultsmtpserver = 1 />
   </cfif> --->
   <cfset usedefaultsmtpserver = 1 />


  <!--- update setting --->
  <cfset settingsIni.set( "production", "usedefaultsmtpserver", usedefaultsmtpserver ) />
  <!--- only update the database if there are no errors --->
  <!--- this also assumes that the db exists --->
  <cfif dbCreated AND NOT len( errorType )>
    <!--- update the domain to be local to the domain the server is being installed on --->
    <cfquery attributeCollection="#queryAttrs#">
      UPDATE tsettings
      SET MailServerIP = '',
        MailServerUsername = '',
        MailServerPassword = '',
        MailServerSMTPPort = '',
        MailServerPOPPort = '',
        useDefaultSMTPServer = 1,
        MailServerTLS = '',
        MailServerSSL = '',
        Contact = '#FORM.production_adminemail#'
    </cfquery>
  </cfif>

  <!--- ************************ --->
  <!--- STEP 5 --->
  <!--- ************************ --->

  <!--- clean ini since it removes cf tags --->
  <cfset cleanIni( settingsPath ) />

	<!--- ************************ --->
	<!--- STEP 6 - Success?                   --->
	<!--- ************************ --->
	<cfset variables.setupProcessComplete = !len(trim(errorType)) />

</cfif>
