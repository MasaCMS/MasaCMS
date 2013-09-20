<!--- ORACLE specific DB functions (bsoylu 6/5/2010)  --->
<cfcomponent hint="implements MySQL specific database functions" extends="DBController">

	<cffunction name="fDBCreate" returntype="String"  access="package" hint="creates a blank database. return empty string if success, or error message.">
		<cfargument name="DatasourceName" required="true" type="string" hint="name of the datasource through which we will need to connect.">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the database to be created">
		<cfargument name="sOptions" type="string" default="" hint="additional optons to be passed into data base creation">
	
		<cfscript>
			var sErr = "automatic database creation for Oracle is not supported at this time.";		
			
			
			return sErr;
		</cfscript>		
	</cffunction>
	
	
	<cffunction name="fDSCreate" access="package" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Railo">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" type="string" hint="name of the desired datasource. will default to application name.">
		<cfargument name="DatabaseServer" required="false"  type="string" hint="name of the database server,required for oracle,mysql,mssql,postgresql">
		<cfargument name="DatabasePort" required="false"  type="numeric" hint="will use default port for each database if not provided">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false"  type="string" hint="name of the database to connect to, will default to application name.">
		<cfargument name="UserName" required="false"  type="string" hint="username is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Password" required="false"  type="string" hint="password is needed for mysql,oracle,mssql,postgresql">
		<cfargument name="Description" required="false"  type="string" hint="any descriptive text">
		
		<cfscript>
			var sErr = "automatic data source creation for Oracle is not supported at this time.";
			
			
			
			return sErr;
		</cfscript>
		
	</cffunction>	
</cfcomponent>