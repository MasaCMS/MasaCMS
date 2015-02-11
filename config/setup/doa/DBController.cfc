<cfcomponent displayname="Database Controller" hint="handles interaction with databases and or app server">
	<cfscript>
		//(bsoylu 6/5/2010) constructor
		this.dbType="";
		init();
	</cfscript>
	
	<cffunction name="fDBCreate" returntype="String"  access="public" hint="creates a blank database. return empty string if success, or error message.">
		<cfargument name="DatasourceName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the datasource through which we will need to connect.">
		<cfargument name="DatabaseName" default="#Application.ApplicationName#" required="false" type="string" hint="name of the database to be created">
		<cfargument name="sOptions" type="string" default="" hint="additional optons to be passed into data base creation">
		<!--- this is stub, actual implemenation is in specific cfc for each db (bsoylu 6/5/2010)  --->
		<cfscript>
			var sErr = "";
			var sDBCFCName ="DB" & this.dbType;
			// (bsoylu 6/5/2010) verify inputs are correct
			if (this.dbType IS "") sErr="No database type specified. Use set method, or initialize application first.";
						
			
			// (bsoylu 6/5/2010) call database specific cfc
			if (sErr IS "")
				sErr = CreateObject("component",sDBCFCName).fDBCreate(argumentCollection=Arguments);
			
			return sErr;
		</cfscript>		
	</cffunction>
	
	<!--- this is a function stub, actual implemenation is in specific cfc for each db (bsoylu 6/5/2010)  --->
	<cffunction name="fDSCreate" access="public" returntype="String"  hint="creates datasource connection, returns empty string or error">
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
			var sDBCFCName ="DB" & this.dbType;
			// (bsoylu 6/5/2010) verify inputs are correct
			if (this.dbType IS "") sErr="No database type specified. Use set method, or initialize application first.";
			
			switch(this.dbType) {
	        	case "mysql":case "mssql":case "postgresql":
					if (NOT IsDefined("Arguments.DatabaseServer")) sErr=sErr & ":Database Server is required.";
					if (NOT IsDefined("Arguments.UserName")) sErr=sErr & ":Database User Name is required.";	
	               	if (NOT IsDefined("Arguments.Password")) sErr=sErr & ":Database User Password is required.";				   
	               	break;
	            case "h2":
	               //no support for h2 in adobe CF
	               if (this.CFServerType IS "ColdFusion") {
	               		sErr=sErr & ":H2 Database is supported only in manual mode. Please create a database and datasource following standard procedures.";
	               } else {
	               		//Lucee
						if (NOT IsDefined("Arguments.UserName")) sErr=sErr & ":Database User Name is required.";	
		               	if (NOT IsDefined("Arguments.Password")) sErr=sErr & ":Database User Password is required.";	               
	               }	
	               break;	           
	            case "oracle":
	               //nothing required for oracle (we do not support it in auto create mode)
	               sErr=sErr & ":Oracle Database is only supported in manual mode. Please create a database and datasource following standard procedures.";
	               break;	         	               
	        } //end switch
			
			// (bsoylu 6/5/2010) call cfc specific to each database if we do not have a verification errror

			if (sErr IS "")
				sErr = CreateObject("component",sDBCFCName).fDSCreate(argumentCollection=Arguments);
			
			return sErr;
		</cfscript>
		
	</cffunction>	
	
	<cffunction name="fDeleteDS" returntype="String"  access="public" hint="deletes existing datasource. return empty string if success, or error message.">
		<cfargument name="GWPassword" required="true" type="string" hint="Railo or Codlfusion password.">
		<cfargument name="DatasourceName" required="true" type="string" hint="name of the datasource to delete.">		
		
		<cfscript>
			var sErr = "";
			var sDBCFCName ="DB" & this.dbType;
			// (bsoylu 6/5/2010) verify inputs are correct
			if (this.dbType IS "") sErr="No database type specified. Use set method, or initialize application first.";
			//based on gateway run delete operation
			try{
				switch(this.CFServerType) {
		        	case "Lucee":
						// (bsoylu 6/6/2010) remove datasouce from Railo
						sErr=fLuceeDeleteDS(argumentCollection=Arguments);				   
		               	break;
		            case "ColdFusion":
		               // (bsoylu 6/6/2010) remove datasource from Adobe CF
					   sErr=fAdobeDeleteDS(argumentCollection=Arguments);
		               break;	           
		        } //end switch
				
			} catch (ANY e) {
					sErr = e.message & "--" & e.detail;					
			}	
			return sErr;
		</cfscript>		
	</cffunction>	
	
	<!--- setters and getters (bsoylu 6/6/2010)  --->
	<cffunction name="setDBType" access="public" hint="set the database type to one of mysql,mssql,postgresql,oracle,h2">
		<cfargument name="sDBType" required="true" type="string" hint="the new database type: one of mysql,mssql,oracle,h2">
		
		<cfscript>
			var lstValidDBs = "mysql,mssql,postgresql,oracle,h2";
			if (ListFindNoCase(lstValidDBs,Arguments.sDBType) GT 0 )
				this.dbType = Arguments.sDBType;
		
		</cfscript>
	</cffunction>
	
	<cffunction name="getCFServerType" access="public" returntype="String" hint="return which application server we are using">
		<cfreturn this.CFServerType>
	</cffunction>	
	
	
	<!--- initilialization of component (bsoylu 6/6/2010)  --->
	<cffunction name="init" access="public" hint="start the controller">
		<cfscript>
			//set baseDir: config\setup\doa\  =17 chars			
			this.baseDir = left(getDirectoryFromPath(getCurrentTemplatePath()),len(getDirectoryFromPath(getCurrentTemplatePath()))-18);
			this.settingsPath = this.baseDir & "/config/settings.ini.cfm";
			// (bsoylu 6/5/2010) get default database type from file as a starter
			this.settingsIni = createObject( "component", "mura.IniFile" ).init( this.settingsPath );
			this.dbType = this.settingsIni.get( "production", "dbtype" );	
			//determine app server
			this.CFServerType = "ColdFusion";
			if (server.ColdFusion.ProductName CONTAINS "Railo" or server.ColdFusion.ProductName CONTAINS "Lucee"){
				this.CFServerType = "Lucee";
			}					
		</cfscript>		
	</cffunction>
	
	<!--- package functions (bsoylu 6/6/2010)  --->
	<cffunction name="fAdobeLogin" hint="login to adobe Coldfusion" returntype="boolean">
		<cfargument name="cfPassword" type="string" hint="input coldfusion password string">
	
		<cfscript>
			var blnStatus=false;			
			var oAdmin = createObject("component","cfide.adminapi.administrator");
			blnStatus = oAdmin.login(cfPassword);
			return blnStatus;
		</cfscript>

	</cffunction>	
	
	<cffunction name="fAdobeDeleteDS" returntype="string" access="package" hint="deletes a CF Datasource. returns error or empty string">
		<cfargument name="GWPassword" required="yes" type="string" hint="input coldfusion password string">
		<cfargument name="DataSourceName" type="string" required="Yes" hint="the datasource name to be used">
		
		
		<cfscript>
			var objDS = CreateObject("COMPONENT","cfide.adminapi.datasource");			 
			var strErr="";
			
			
			try {
				objDS.deleteDatasource(Arguments.DSName);
			} catch (ANY e) {
				strErr = e.message & "--" & e.detail;			
			}		
			
			return strErr;
		</cfscript>
	</cffunction>		
	
	<cffunction name="fLuceeDeleteDS" access="package" returntype="string" hint="deletes a Datasource in Railo. returns error or empty string">
		<cfargument name="GWPassword" type="string" required="yes" hint="input Railo password string">
		<cfargument name="DataSourceName" type="string" required="Yes" hint="the datasource name to be used">
		
		<cfset var sErr="">
		<cfset var sLuceeAdminCall="">
		
		<cftry>
			<!--- for Railo we will use the cfadmin tag (bsoylu 12/4/2010) --->
			<!--- we need to encapsulate this into an evaluate so that abode coldfusion  does no throw error (bsoylu 12/19/2010) --->
			<cfsavecontent variable="sLuceeAdminCall">
			<cfoutput>
			#Chr(60)#cfadmin
	    		action="removeDatasource"
	    		type="server"
	    		password="#Arguments.GWPassword#"
	    		name="#Arguments.DataSourceName#"
		    #Chr(62)#
		    </cfoutput>	
		    </cfsavecontent>
		    
		    <cfset void=Evaluate(sLuceeAdminCall)>
		    
		    <cfcatch type="any">
				<cfset sErr="could not remove Lucee datasource: #cfcatch.detail#">
			</cfcatch>
		</cftry>
		<cfreturn sErr>			
		
	</cffunction>
	
</cfcomponent>