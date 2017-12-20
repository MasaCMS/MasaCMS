<cfscript>
if ( request.muraCheckSetup) {
	if ( request.muraSysEnv.MURA_DBTYPE == 'oracle' ) {
		// Oracle
		qs=new Query();

		if ( !qs.execute(sql="select table_name from all_tables where lower(owner)='#lcase(request.muraSysEnv.MURA_DATABASE)#' and lower(table_name)='tcontent'").getResult().recordcount ) {
			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		}
	} else {
		// MySQL, MSSQL, + Postgres
		dbi = new dbinfo();
		rsdbnames = dbi.dbnames();

		if ( !ListFindNoCase(ValueList(rsdbnames.DATABASE_NAME), request.muraSysEnv.MURA_DATABASE) ) {
			q = new Query();
			q.execute(sql='CREATE DATABASE #request.muraSysEnv.MURA_DATABASE#');

			FORM['#application.setupSubmitButton#']=true;
			FORM['#application.setupSubmitButtonComplete#']=true;
			FORM['setupSubmitButton']=true;
			FORM['action']='doSetup';
		} else {

			rsdbtables = dbi.tables();

			if ( !ListFindNoCase(ValueList(rsdbtables.TABLE_NAME), 'tcontent') ) {
				FORM['#application.setupSubmitButton#']=true;
				FORM['#application.setupSubmitButtonComplete#']=true;
				FORM['setupSubmitButton']=true;
				FORM['action']='doSetup';
			}
		}
	}
}
</cfscript>
