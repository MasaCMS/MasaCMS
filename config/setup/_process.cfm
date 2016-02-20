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


        <cfif form.production_dbtype eq 'Oracle'>
           <cfset form.production_dbtablespace=ucase(form.production_dbtablespace)>

           <cfquery name="rsTableSpaces" datasource="#form.production_datasource#" username="#form.production_dbusername#" password="#form.production_dbpassword#">
              select * from user_ts_quotas
              where tablespace_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.production_dbtablespace#">
           </cfquery>

           <cfif not rsTableSpaces.recordcount>
              <cfset message = "<strong>Error:</strong> The Oracle tablespace named '#form.production_dbtablespace#' is not available">
              <cfset bProcessWithMessage = false>
           </cfif>
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

          <cfdbinfo
                name="rsCheck"
                datasource="#FORM.production_datasource#"
                username="#FORM.production_dbusername#"
                password="#FORM.production_dbpassword#"
                type="version">

          <cfif rsCheck.database_productname eq 'H2'>
            <cfsavecontent variable="sql">
              <cfinclude template="db/h2.sql">
            </cfsavecontent>
          <cfelse>
            <cfparam name="form.production_mysqlengine" default="InnoDB">
            <cfset storageEngine="ENGINE=#form.production_mysqlengine# DEFAULT CHARSET=utf8">
            <cfsavecontent variable="sql">
              <cfinclude template="db/#FORM.production_dbtype#.sql">
            </cfsavecontent>
          </cfif>

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
              <cfcase value="mysql">

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
				<cfcase value="postgresql,nuodb">
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
                theme = 'MuraBootstrap3',
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
      <cfset message = "<strong>Error:</strong> An unknown error has occurred." />
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
  <cfif NOT len( errorType )>
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
  </cfif>

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

	<!--- ************************ --->
	<!--- STEP 6 - Success?                   --->
	<!--- ************************ --->
	<cfset variables.setupProcessComplete = !len(trim(errorType)) />

</cfif>