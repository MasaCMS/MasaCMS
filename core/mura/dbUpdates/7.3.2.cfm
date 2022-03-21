<cfscript>
    dbUtility.setTable('tsettings')
		.alterColumn(column='MailServerUsername',dataType='varchar',length='255');
    dbUtility.setTable('tsettings')
		.alterColumn(column='MailServerPassword',dataType='varchar',length='255');
</cfscript>
