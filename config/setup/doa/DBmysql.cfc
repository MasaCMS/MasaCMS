<!--- MySQL specific DB functions (bsoylu 6/5/2010)  --->
<cfcomponent hint="implements MySQL specific database functions" extends="DBController">

	<cffunction name="fDBCreate" returntype="String"  access="package" hint="creates a blank database. return empty string if success, or error message.">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the datasource through which we will need to connect.">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the database to be created">
		<cfargument name="sOptions" type="string" default="" hint="additional optons to be passed into data base creation">
	
		<cfscript>
			var sErr = "";
			var sSQL="";
			var qDBCreate="";			
			//determine DB Creation SQL
			sSQL = "CREATE DATABASE `" & Arguments.DatabaseName & "` " & Arguments.sOptions &";";			
		</cfscript>
		<!--- run cration query and capture error if any (bsoylu 6/6/2010)  --->		
		<cftry>
		
			<cfquery name="qDBCreate" datasource="#Arguments.DatasourceName#">
				#PreserveSingleQuotes(sSQL)#
			</cfquery>
		
		
		<cfcatch type="any">
			<cfset sErr= cfcatch.Detail & "--" & cfcatch.Message>
		</cfcatch>
		</cftry>
		
		<cfreturn sErr>
	</cffunction>
	
	
	
	
	
	<cffunction name="fDSCreate" access="package" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Railo">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" type="string" hint="name of the desired datasource. will default to application name.">
		<cfargument name="DatabaseServer" required="false"  type="string" hint="name of the database server,required for oracle,mysql,mssql,postgresql">
		<cfargument name="DatabasePort" default="3306" displayname="" required="false"  type="numeric" hint="will use default port for each database if not provided">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false"  type="string" hint="name of the database to connect to, will default to application name.">
		<cfargument name="UserName" required="false"  type="string" hint="username is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Password" required="false"  type="string" hint="password is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Description" default="Mura data source" required="false"  type="string" hint="any descriptive text">
		<cfargument name="bCreateDB" default="Yes" required="false"  type="boolean" hint="should the database be created at the same time, default = Yes">
		
		<cfscript>
			var sErr = "";
			if (super.getCFServerType() IS "ColdFusion") {
				sErr = fDSCreateAdobe(argumentCollection=Arguments);
			} else if (super.getCFServerType() IS "Railo") {
				sErr = fDSCreateRailo(argumentCollection=Arguments);
			} else {
				sErr = "unknown Application server. Cannot create datasource.";
			}			
			
			return sErr;
		</cfscript>
		
	</cffunction>	
	
	
	<!--- create DS in ColdFusion for MySQL (bsoylu 6/6/2010)  --->
	<cffunction name="fDSCreateAdobe" access="private" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Railo">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" type="string" hint="name of the desired datasource. will default to application name.">
		<cfargument name="DatabaseServer" required="false"  type="string" hint="name of the database server,required for oracle,mysql,mssql,postgresql">
		<cfargument name="DatabasePort" required="false"  type="numeric" hint="will use default port for each database if not provided">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false"  type="string" hint="name of the database to connect to, will default to application name.">
		<cfargument name="UserName" required="false"  type="string" hint="username is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Password" required="false"  type="string" hint="password is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Description" required="false"  type="string" hint="any descriptive text">
		<cfargument name="bCreateDB" default="Yes" required="false"  type="boolean" hint="should the database be created at the same time, default = Yes">
		
		<cfscript>
			var sErr = "";
			var Local = StructNew();
			var oDS = CreateObject("COMPONENT","cfide.adminapi.datasource");
			var stcArgs = StructNew();	
			var stcA2 = StructNew();
			//set values for data source			
			stcArgs.name=  Arguments.DatasourceName;
			stcArgs.host = Arguments.DatabaseServer;
			stcArgs.port = Arguments.DatabasePort;
			stcArgs.database = Arguments.DatabaseName;			
			stcArgs.username = Arguments.UserName;  
			stcArgs.password = Arguments.Password;
			stcArgs.description=Arguments.Description;
			//stcArgs.url = "jdbc:mysql://" & stcArgs.host & ":" & stcArgs.port & "/" & stcArgs.database;
			//stcArgs.class= "com.mysql.jdbc.Driver";
			//stcArgs.driver="Mura MySQL Driver";
			
			//login again then create DS
			if (NOT super.fAdobeLogin(Arguments.GWPassword)) {
				sErr="Could not connect to ColdFusion. Please verify your administrator password.";					
			} else {

				try {
					if (Arguments.bCreateDB) {
						// (bsoylu 6/6/2010) we need to fist create a temporary DS to information_schema as the built in CF drivers are restrictive 
						stcArgs.database = "information_schema";
						oDS.setMySQL5(argumentCollection=stcArgs);
						// (bsoylu 6/6/2010) now call the createDB function
						stcA2.DatasourceName = Arguments.DatasourceName;
						stcA2.DataBaseName = Arguments.DatabaseName;
						sErr=fDBCreate(argumentCollection=stcA2);
						//(bsoylu 6/6/2010) reset this datasource using newly created database pointers
						if (sErr IS "") {
							stcArgs.database = Arguments.DatabaseName;
							oDS.setMySQL5(argumentCollection=stcArgs);
						}
					} else {
						//create DS
						oDS.setMySQL5(argumentCollection=stcArgs);
					};
				} catch (ANY e) {
					sErr = e.message & "--" & e.detail;	
				}
			}
			return sErr;				
		</cfscript>				
	</cffunction>	
	
	
	<!--- call DS in ColdFusion for Railo, we seperate these calls into different files (components) to avoid errors thrown by adobe coldfusion (bsoylu 6/6/2010)  --->
	<cffunction name="fDSCreateRailo" access="private" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Railo">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" type="string" hint="name of the desired datasource. will default to application name.">
		<cfargument name="DatabaseServer" required="false"  type="string" hint="name of the database server,required for oracle,mysql,mssql,postgresql">
		<cfargument name="DatabasePort" required="false"  type="numeric" hint="will use default port for each database if not provided">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false"  type="string" hint="name of the database to connect to, will default to application name.">
		<cfargument name="UserName" required="false"  type="string" hint="username is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Password" required="false"  type="string" hint="password is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Description" required="false"  type="string" hint="any descriptive text">
		<cfargument name="bCreateDB" default="Yes" required="false"  type="boolean" hint="should the database be created at the same time, default = Yes">
		
		<cfset var sErr = CreateObject("component","DBmysql_railo").fDSCreateRailoPackage(argumentCollection=arguments)>
		
		<cfreturn sErr>	
	</cffunction>	
	
</cfcomponent>