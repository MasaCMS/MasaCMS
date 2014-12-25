<cfscript>
	dbUtility.setTable('tsettings')
		.addColumn(column='reCAPTCHASiteKey', datatype='varchar', length=50)
		.addColumn(column='reCAPTCHASecret', datatype='varchar', length=50)
		.addColumn(column='reCAPTCHALanguage', datatype='varchar', length=25)
		.addColumn(column='JSONApi', datatype='int', default=0)
		.addColumn(column='useSSL', datatype='int', default=0);
</cfscript>
