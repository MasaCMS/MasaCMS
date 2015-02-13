<cfscript>
	dbUtility.setTable('tsettings')
		.addColumn(column='reCAPTCHASiteKey', datatype='varchar', length=50)
		.addColumn(column='reCAPTCHASecret', datatype='varchar', length=50)
		.addColumn(column='reCAPTCHALanguage', datatype='varchar', length=25)
		.addColumn(column='JSONApi', datatype='int', default=0)
		.addColumn(column='useSSL', datatype='int', default=0)
		.addColumn(column='isremote', datatype='int', default=0)
		.addColumn(column='resourceSSL', datatype='int', default=0)
		.addColumn(column='resourceDomain', datatype='varchar', length=100)
		.addColumn(column='remoteport', datatype='int', default=80)
		.addColumn(column='remotecontext', datatype='varchar', length=100);

dbUtility.setTable('tcontentrelated')
		.alterColumn(column='relatedContentSetID',dataType='varchar',length='35',default='00000000000000000000000000000000000');
</cfscript>

<cfquery>
	update tcontentrelated set relatedContentSetID='00000000000000000000000000000000000' where relatedContentSetID is null
</cfquery>