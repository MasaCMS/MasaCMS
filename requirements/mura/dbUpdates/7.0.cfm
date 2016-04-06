<cfquery>
    update tcontent set Title='Components',Menutitle='Components' where contentid='00000000000000000000000000000000003'
</cfquery>
<cfquery>
    update tcontent set Title='Forms',Menutitle='Forms' where contentid='00000000000000000000000000000000004'
</cfquery>
<cfquery>
    update tcontent set Title='Remote Variations',Menutitle='Remote Variations' where contentid='00000000000000000000000000000000099'
</cfquery>

<cfscript>
    getBean('variationTargeting').checkSchema();
    dbUtility.setTable("tsettings").addColumn(column="contentPendingScript",dataType="longtext")
    .setTable("tsettings").addColumn(column="contentCanceledScript",dataType="longtext");
</cfscript>
