<cfscript>
	getBean('userDevice').checkSchema();
	dbUtility.setTable("tsettings").addColumn(column="sendAuthCodeScript",dataType="longtext");
</cfscript>