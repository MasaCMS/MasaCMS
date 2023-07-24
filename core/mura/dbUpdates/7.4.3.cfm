<cfscript>
    dbUtility.setTable('tusers')
		.alterColumn(column='remoteID',dataType='varchar',length='50');
</cfscript>
