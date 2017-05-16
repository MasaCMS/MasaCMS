<!--- MySQL specific DB functions using Lucee Application Server (bsoylu 6/5/2010)  --->
<!--- these need to be in seperate component to avoid Adobe ColdFusion errors (bsoylu 12/19/2010) --->
<cfcomponent hint="implements MySQL specific database functions" extends="DBmysql">

	<!--- create DS in ColdFusion for Lucee (bsoylu 6/6/2010)  --->
	<cffunction name="fDSCreateLuceePackage" access="package" returntype="String"  hint="creates datasource connection, returns empty string or error">
		<cfargument name="GWPassword" required="true"  type="string" hint="password for coldfusion or Lucee">
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
			var sDSNServer = "jdbc:mysql://#Arguments.DatabaseServer#:#Arguments.DatabasePort#/";  //build server part of jdbc string
			var stcA2 = StructNew();
			var sClass = "org.gjt.mm.mysql.Driver"; //this is the driver bundled with Railo
			var sDSNPara ="";
			var sDSN=""; //empty to start
			//example
			//jdbc:mysql://myServer:3306/myDatabase?useUnicode=true&autoReconnect=true&useOldAliasMetadataBehavior=false&zeroDateTimeBehavior=exception&characterEncoding=UTF-8&allowMultiQueries=true&jdbcCompliantTruncation=true 
				
			//set DSN rest string
			sDSNPara="?useUnicode=true&autoReconnect=true&useOldAliasMetadataBehavior=true&zeroDateTimeBehavior=exception&characterEncoding=UTF-8&allowMultiQueries=true&jdbcCompliantTruncation=true";
				
		</cfscript>
		
	
		<cftry>
			<cfif Arguments.bCreateDB>
				<!--- create datasource connection to information_schema first, create DB, then change datasource to point newly recreated database (bsoylu 12/13/2010) --->
				<cfset sDSN= sDSNServer & "information_schema" & sDSNPara>
				<cfadmin
				    action="updateDatasource"
				    type="web"
				    password="#Arguments.GWPassword#"
				    classname="#sClass#"
				    dsn="#sDSN#"
				    name="MuraIntermediate"
				    newName="MuraIntermediateDatasource"    
				    dbusername="#Arguments.UserName#"
				    dbpassword="#Arguments.Password#"        
				    >	
				<!--- create database now (bsoylu 12/13/2010) --->	
				<cfscript>
					stcA2.DatasourceName = "MuraIntermediateDatasource";
					stcA2.DataBaseName = Arguments.DatabaseName;
					sErr=super.fDBCreate(argumentCollection=stcA2);
				</cfscript>	
				<!--- delete intermediate datasource connection (bsoylu 12/18/2010) --->
				<cfadmin
				    action="removeDatasource"
				    type="web"
				    password="#Arguments.GWPassword#"
				    name="MuraIntermediateDatasource"
				    >
				
				<!--- repoint datasource to new database (bsoylu 12/13/2010) --->
				<cfif sErr IS "">
					<cfset sDSN= sDSNServer & "#Arguments.DatabaseName#" & sDSNPara>
					<cfadmin
					    action="updateDatasource"
					    type="web"
					    password="#Arguments.GWPassword#"
					    classname="#sClass#"
					    dsn="#sDSN#"
					    name="#Arguments.DatasourceName#"
					    newName="#Arguments.DatasourceName#"    
					    dbusername="#Arguments.UserName#"
					    dbpassword="#Arguments.Password#"        
					    >					
				
				</cfif>		
			
			<cfelse>
				<!--- no creation of database just the datasource (bsoylu 12/13/2010) --->
				<cfadmin
				    action="updateDatasource"
				    type="web"
				    password="#Arguments.GWPassword#"
				    classname="#sClass#"
				    dsn="#sDSN#"
				    name="#Arguments.DatabaseName#"
				    newName="#Arguments.DatabaseName#"    
				    dbusername="#Arguments.UserName#"
				    dbpassword="#Arguments.Password#"        
				    >					
			</cfif>

		
			<cfcatch type="any">
				<cfset sErr="Error during creation of MySQL datbase: #cfcatch.message# - #cfcatch.detail#">
			
			</cfcatch>
		
		</cftry>
		
		<cfreturn sErr>
		
	</cffunction>	
	
</cfcomponent>