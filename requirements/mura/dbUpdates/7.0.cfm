<cfquery>
    update tcontent set Title='Components',Menutitle='Components' where contentid='00000000000000000000000000000000003'
</cfquery>
<cfquery>
    update tcontent set Title='Forms',Menutitle='Forms' where contentid='00000000000000000000000000000000004'
</cfquery>
<cfquery>
    update tcontent set Title='Remote Variations',Menutitle='Remote Variations' where contentid='00000000000000000000000000000000099'
</cfquery>
<cfquery>
    update tcontent set Title='Content Staging Manager',Menutitle='Content Staging Manager' where contentid='00000000000000000000000000000000014'
</cfquery>
<cfquery>
    update tcontent set Title='Collections Manager',Menutitle='Collections Manager' where contentid='00000000000000000000000000000000011'
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
        .addColumn(column="placeholderImgExt",dataType="varchar",length=10);

    dbUtility.setTable("tcontent").addIndex('SiteID,Active,Approved,IsNav,ModuleID,searchExclude,ContentID,Type,subType,Display,DisplayStart,DisplayStop,mobileExclude');
    dbUtility.setTable("tcontentrelated").addIndex('relatedID').addIndex('contentHistID');
    dbUtility.setTable("tclassextendrcsets").addIndex('name');
    dbUtility.setTable("tredirects")
        .addColumn(column="userid",dataType="char",length=35)
        .addIndex('userid')
        .addColumn(column="siteid",dataType="varchar",length=25)
        .addIndex('siteid');
</cfscript>

<cfquery>
    update tsystemobjects set name='Comment Form' where name='Accept Comments'
</cfquery>
