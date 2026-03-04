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
		var activateSetup = false;

		if(this.datasources.KeyExists('nodatabase') && len(getSystemEnvironmentSetting('MURA_DATABASE'))){
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

				try {
						queryExecute(
							sql = "CREATE DATABASE #databaseName#"
							, options = { datasource="nodatabase" }
						);

						activateSetup = true;
				} catch(any e) {
						writeLog(type="Error", file="exception", text="Error trying to create DB, it may already exist");
				}
			}
		}

		if (request.muraSysEnv.MURA_DBTYPE == 'postgresql') {
			if(!queryExecute(sql="select table_name from information_schema.tables where table_schema = current_schema() and lower(table_name)='tcontent'").recordcount){
				activateSetup = true;
			}

		} else if (request.muraSysEnv.MURA_DBTYPE == 'oracle') {
			if(!queryExecute(sql="select TABLE_NAME from user_tables where lower(table_name)='tcontent'").recordcount){
				activateSetup = true;
			}

		} else if(request.muraSysEnv.MURA_DBTYPE == 'mysql') { 
			if(!queryExecute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'masadb' AND lower(table_name)='tcontent'",[],{datasource:getSystemEnvironmentSetting('MURA_DATASOURCE')}).recordcount) {
				activateSetup = true;
			}
		} else {
			cfdbinfo(type='tables',name="rsdbtables");

			if ( !ListFindNoCase(ValueList(rsdbtables.TABLE_NAME), 'tcontent') ) {
				activateSetup = true;
			}
		}

		if (activateSetup){
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}
	}
</cfscript>
