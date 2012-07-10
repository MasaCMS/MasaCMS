<cfscript>
	dbUtility.setTable("tclassextend").addColumn(column="description",datatype="longtext");
	dbUtility.setTable("tsettings").addColumn(column="enforcePrimaryDomain",datatype="tinyint",default=0);
</cfscript>