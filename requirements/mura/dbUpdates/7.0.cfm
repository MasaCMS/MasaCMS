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
    getBean('remoteContentPointer').checkSchema();
    getBean('oauthClient').checkSchema();
    getBean('oauthToken').checkSchema();
    dbUtility.setTable("tsettings")
        .addColumn(column="contentPendingScript",dataType="longtext")
        .addColumn(column="contentCanceledScript",dataType="longtext")
        .addColumn(column="showDashboard",dataType="integer",default=0)
        .addColumn(column="placeholderImgID",dataType="varchar",length=35)
        .addColumn(column="placeholderImgExt",dataType="varchar",length=10);;
</cfscript>
