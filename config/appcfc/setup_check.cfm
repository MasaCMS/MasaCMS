<cfscript>
if ( request.muraInDocker && len(getSystemEnvironmentSetting('MURA_DATABASE'))) {
	if ( request.muraSysEnv.MURA_DBTYPE == 'mssql' ) {

    qs=new Query();
    qs.setDatasource('nodatabase');

		if ( !qs.execute(sql="select * from sys.databases where name = '#request.muraSysEnv.MURA_DATABASE#'").getResult().recordcount ) {
      qs=new Query();
      qs.setDatasource('nodatabase');
      qs.execute(sql="CREATE DATABASE #request.muraSysEnv.MURA_DATABASE#");

			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

    qs=new Query();

		if(!qs.execute(sql="SELECT *
         FROM INFORMATION_SCHEMA.TABLES
         WHERE TABLE_CATALOG = '#request.muraSysEnv.MURA_DATABASE#'
         AND  lower(TABLE_NAME) = 'tcontent'").getResult().recordcount){

			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

	} else if ( request.muraSysEnv.MURA_DBTYPE == 'mysql' ) {

    qs=new Query();
    qs.setDatasource('nodatabase');

		if ( !qs.execute(sql="SELECT IF('#request.muraSysEnv.MURA_DATABASE#' IN(SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA), 1, 0) AS found").getResult().found) {
      qs=new Query();
      qs.setDatasource('nodatabase');
      qs.execute(sql="CREATE DATABASE #request.muraSysEnv.MURA_DATABASE#");

			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

    qs=new Query();
    qs.setDatasource('nodatabase');

    if ( !qs.execute(sql="SELECT IF('tcontent' IN(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '#request.muraSysEnv.MURA_DATABASE#' AND TABLE_NAME = 'tcontent'), 1, 0) AS found").getResult().found) {
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

	} else if ( request.muraSysEnv.MURA_DBTYPE == 'postgresql' ) {

    qs=new Query();
    qs.setDatasource('nodatabase');

		if ( !qs.execute(sql="SELECT datname FROM pg_catalog.pg_database WHERE lower(datname) = '#lcase(request.muraSysEnv.MURA_DATABASE)#'").getResult().recordcount ) {

      qs=new Query();

      qs.execute(sql="CREATE DATABASE #request.muraSysEnv.MURA_DATABASE#");

			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}

		 qs=new Query();
		 qs.setDatasource('nodatabase');
		 
		if ( !qs.execute(sql="select * from pg_class where relname='tcontent' and relkind='r'").getResult().recordcount ) {
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}
		} else if ( request.muraSysEnv.MURA_DBTYPE == 'oracle' ) {
			/*
	    qs=new Query();

			if ( !qs.execute(sql="SELECT * FROM dba_tables where table_name = 'tcontent'").getResult().recordcount ) {
				FORM['#application.setupSubmitButton#']=true;
				FORM['#application.setupSubmitButtonComplete#']=true;
				FORM['setupSubmitButton']=true;
				FORM['action']='doSetup';
			}
			*/
		}
}
</cfscript>
