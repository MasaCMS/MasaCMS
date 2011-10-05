<!--- H2 database specific DB functions (bsoylu 6/5/2010)  --->
<cfcomponent hint="implements MySQL specific database functions" extends="DBController">

	<cffunction name="fDBCreate" returntype="String"  access="package" hint="creates a blank database. return empty string if success, or error message.">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the datasource through which we will need to connect.">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the database to be created">
		<cfargument name="sOptions" type="string" default="" hint="additional optons to be passed into data base creation">
	
		<cfscript>
			// (bsoylu 6/5/2010) for H2 database their is no creation step required. 
			// Database will be created if it does not exist by server based on datasource.

			var sErr = "";			
			
			return sErr;
		</cfscript>		
	</cffunction>
	
	
	<cffunction name="fDSCreate" access="package" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Railo">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" type="string" hint="name of the desired datasource. will default to application name.">
		<cfargument name="DatabaseServer" required="false"  type="string" hint="name of the database server,required for oracle,mysql,mssql">
		<cfargument name="DatabasePort" default="3306" displayname="" required="false"  type="numeric" hint="will use default port for each database if not provided">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false"  type="string" hint="name of the database to connect to, will default to application name.">
		<cfargument name="UserName" required="false"  type="string" hint="username is needed for mysql,oracle,mssql">
		<cfargument name="Password" required="false"  type="string" hint="password is needed for mysql,oracle,mssql">
		<cfargument name="Description" default="Mura data source" required="false"  type="string" hint="any descriptive text">
		<cfargument name="bCreateDB" default="Yes" required="false"  type="boolean" hint="should the database be created at the same time, default = Yes">
		
		<cfscript>
			var sErr = "";
			if (super.getCFServerType() IS "ColdFusion") {
				sErr = "H2 database creation is not supported for Adobde ColdFusion. Either change to Railo Application Server or manually create datasource and proceed.";
			} else if (super.getCFServerType() IS "Railo") {
				sErr = fDSCreateRailo(argumentCollection=Arguments);
			} else {
				sErr = "unknown Application server. Cannot create datasource.";
			}			
			
			return sErr;
		</cfscript>
		
	</cffunction>		
	
	<cffunction name="fDSCreateRailo" access="package" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Railo">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" type="string" hint="name of the desired datasource. will default to application name.">
		<cfargument name="DatabaseServer" required="false"  type="string" hint="name of the database server,required for oracle,mysql,mssql">
		<cfargument name="DatabasePort" required="false"  type="numeric" hint="will use default port for each database if not provided">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false"  type="string" hint="name of the database to connect to, will default to application name.">
		<cfargument name="UserName" required="false"  type="string" hint="username is needed for mysql,oracle,mssql">
		<cfargument name="Password" required="false"  type="string" hint="password is needed for mysql,oracle,mssql">
		<cfargument name="Description" required="false"  type="string" hint="any descriptive text">
		<cfargument name="bCreateDB" default="Yes" required="false"  type="boolean" hint="should the database be created at the same time, default = Yes">
		<cfscript>
			var sErr = "";
			var sDir = GetTempDirectory() & Arguments.DatasourceName;
			var sDSN = "jdbc:h2:#sDir#;MODE=MySQL";  //for H2 we assume MySQL mode
		</cfscript>
		
		<cfif NOT DirectoryExists(sDir)>
			<cfdirectory action="create" directory="#sDir#">
		</cfif>
		
		<cftry>
			<cfadmin
			    action="updateDatasource"
			    type="web"
			    password="#Arguments.GWPassword#"
			    classname="org.h2.Driver"
			    dsn="#sDSN#"
			    name="#Arguments.DatabaseName#"
			    newName="#Arguments.DatabaseName#"    
			    dbusername="#Arguments.UserName#"
			    dbpassword="#Arguments.Password#"        
			    >	
		
			<cfcatch type="any">
				<cfset sErr="Error during creation of H2 datbase: #cfcatch.message# - #cfcatch.detail#">
			
			</cfcatch>
		
		</cftry>
		
		<cfreturn sErr>		
	</cffunction>	
</cfcomponent>