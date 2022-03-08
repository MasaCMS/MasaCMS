<cfscript>
if ( request.muraInDocker) {
	// MySQL, MSSQL
	application.dbmaintenance = getINIProperty('dbmaintenance') == "true";
	if (application.dbmaintenance) {
		if (Len(getINIProperty('dbmaintenancetemplate'))) {
			include getINIProperty('dbmaintenancetemplate');
		} else {
			include getINIProperty('errortemplate');
		}
		abort;
	}
	
	application.dbconnectionerror = false;
	if(isDefined('this.datasources.nodatabase') && len(getSystemEnvironmentSetting('MURA_DATABASE'))){
		// Attempt to connect to database
		try {
			cfdbinfo(datasource="nodatabase",type='dbnames',name="rsdbnames");
		} catch(any e) {
			application.dbconnectionerror = true;
			if (Len(getINIProperty('dbconnectionerrortemplate'))) {
				include getINIProperty('dbconnectionerrortemplate');
			} else {
				include getINIProperty('errortemplate');
			}
			abort;
		}

		if ( !ListFindNoCase(ValueList(rsdbnames.DATABASE_NAME), request.muraSysEnv.MURA_DATABASE) ) {
			databaseName = request.muraSysEnv.MURA_DATABASE;
			if (request.muraSysEnv.MURA_DBTYPE == 'mysql' && request.muraSysEnv.MURA_DATABASE contains '-') {
				databaseName = "`#databaseName#`";
			}
			q = new Query(datasource="nodatabase");

			try {
					q.execute(sql='CREATE DATABASE #databaseName#');
					FORM['#application.setupSubmitButton#']=true;
					FORM['#application.setupSubmitButtonComplete#']=true;
					FORM['setupSubmitButton']=true;
					FORM['action']='doSetup';
			} catch(any e) {
					writeLog(type="Error", file="exception", text="Error trying to create DB, it may already exist");
			}
		}
	}
	if( request.muraSysEnv.MURA_DBTYPE == 'postgresql'){
		qs=new Query();

		if(!qs.execute(sql="select table_name from information_schema.tables where table_schema = current_schema() and lower(table_name)='tcontent'").getResult().recordcount){
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

	} else if(request.muraSysEnv.MURA_DBTYPE == 'oracle'){
		qs=new Query();

		if(!qs.execute(sql="select TABLE_NAME from user_tables where lower(table_name)='tcontent'").getResult().recordcount){
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

	} else {

		cfdbinfo(type='tables',name="rsdbtables");

		if ( !ListFindNoCase(ValueList(rsdbtables.TABLE_NAME), 'tcontent') ) {
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}
	}
}
</cfscript>
