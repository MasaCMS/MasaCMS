<cfscript>
	dbUtility.setTable("tclassextend").addColumn(column="description",datatype="longtext");
	dbUtility.setTable("tsettings").addColumn(column="enforcePrimaryDomain",datatype="tinyint",default=0);
	dbUtility.setTable("tcontent").addColumn(column="displayInterval",datatype="varchar",length=20);
</cfscript>