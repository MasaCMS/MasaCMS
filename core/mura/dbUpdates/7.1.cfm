<cfscript>
    getBean('entity').checkSchema();
    dbUtility.setTable("tsettings")
    .addColumn(column="scaffolding",dataType="int");
</cfscript>
