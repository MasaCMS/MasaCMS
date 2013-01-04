
<cfscript>
	dbUtility.setTable("tclassextend").addColumn(column="description",datatype="longtext")
	.addColumn(column="availableSubTypes",datatype="longtext");

	dbUtility.setTable("tsettings")
		.addColumn(column="enforcePrimaryDomain",datatype="tinyint",default=0)
		.addColumn(column="enforceChangesets",datatype="tinyint",default=0);


	local.hasSmall=dbUtility.columnExists("smallImageHeight");

	if(not local.hasSmall){
		dbUtility.addColumn(column="smallImageHeight",datatype="varchar",length=20)
			.addColumn(column="smallImageWidth",datatype="varchar",length=20);
	}

	local.hasMedium=dbUtility.columnExists("mediumImageHeight");

	if(not local.hasMedium){
		dbUtility.addColumn(column="mediumImageHeight",datatype="varchar",length=20)
			.addColumn(column="mediumImageWidth",datatype="varchar",length=20);
	}

	
	local.hasLarge=dbUtility.columnExists("largeImageHeight");

	if(not local.hasLarge){
		dbUtility.addColumn(column="largeImageHeight",datatype="varchar",length=20)
			.addColumn(column="largeImageWidth",datatype="varchar",length=20);
	}
	
	dbUtility.setTable("tcontent").addColumn(column="displayInterval",datatype="varchar",length=20);
</cfscript>

<cfif not local.hasSmall>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		smallImageWidth=gallerySmallScale,
		smallImageHeight='AUTO'
		where gallerySmallScaleBy = 'x'
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		smallImageWidth='AUTO',
		smallImageHeight=gallerySmallScale
		where gallerySmallScaleBy = 'y'
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		smallImageWidth=gallerySmallScale,
		smallImageHeight=gallerySmallScale
		where gallerySmallScaleBy = 's'
	</cfquery>
</cfif>

<cfif not local.hasMedium>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		mediumImageWidth=galleryMediumScale,
		mediumImageHeight='AUTO'
		where galleryMediumScaleBy = 'x'
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		mediumImageWidth='AUTO',
		mediumImageHeight=galleryMediumScale
		where galleryMediumScaleBy = 'y'
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		mediumImageWidth=galleryMediumScale,
		mediumImageHeight=galleryMediumScale
		where galleryMediumScaleBy = 's'
	</cfquery>
</cfif>

<cfif not local.hasLarge>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		largeImageWidth=galleryMainScale,
		largeImageHeight='AUTO'
		where galleryMainScaleBy = 'x'
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
		update tsettings set 
		largeImageWidth='AUTO',
		largeImageHeight=galleryMainScale
		where galleryMainScaleBy = 'y'
	</cfquery>
</cfif>

<cfscript>
	dbUtility.setTable("timagesizes")
	.addColumn(column="sizeID",dataType="char",length="35",nullable=false,default='')
	.addColumn(column="siteID",dataType="varchar",length="35")
	.addColumn(column="name",dataType="varchar",length="50")
	.addColumn(column="height",dataType="varchar",length="10")
	.addColumn(column="width",dataType="varchar",length="10")
	.addPrimaryKey('sizeID')
	.addIndex('sizeID')
	.addIndex('siteID');

	dbUtility.setTable("ttrash")
	.addColumn(column="deleteid",dataType="char",length="35")
	.addColumn(column="orderno",dataType="int")
	.addIndex('deleteid');

	dbUtility.setTable("tcontentfeeds")
	.addColumn(column="viewalllink",dataType="varchar",length="255")
	.addColumn(column="viewalllabel",dataType="varchar",length="100")
	.addColumn(column="cssclass",dataType="varchar",length="255");

	dbUtility.setTable("tusers")
	.addColumn(column="password",dataType="varchar",length="100");

	dbUtility.setTable("tcontentfeeds")
	.addColumn(column="autoimport",dataType="tinyint",default=0)
	.addColumn(column="isLocked",dataType="tinyint",default=0);

	dbUtility.setTable("tcontent")
	.addColumn(column="sourceID",dataType="char",length="35");

	dbUtility.setTable("tclusterpeers")
	.addColumn(column="instanceID",dataType="char",length="35",nullable=false, default='')
	.addPrimaryKey("instanceID");

	dbUtility.setTable("tclustercommands")
	.addColumn(column="commandID",dataType="char",length="35",nullable=false, default='')
	.addColumn(column="instanceID",dataType="char",length="35")
	.addColumn(column="command",dataType="longtext")
	.addColumn(column="created",dataType="datetime")
	.addPrimaryKey("commandID")
	.addIndex("instanceID");

	dbUtility.setTable("tglobals").dropTable();

	dbUtility.setTable("tusers");
	if(dbUtility.columnMetaData('password').length neq 100){
		dbUtility.alterColumn(column="password",dataType="varchar",length="100");
	}
</cfscript>

<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
	update tclassextend set type='Folder' where type in ('Portal','LocalRepo')
</cfquery>
<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
	update tcontent set type='Folder' where type in ('Portal','LocalRepo')
</cfquery>
<cfquery datasource="#getDatasource()#" username="#getDbUsername()#" password="#getDbPassword()#">
	update tsystemobjects set
		object='folder_nav',
		name='Folder Navigation'
	where object='portal_nav'
</cfquery>

<cfscript>
	dbUtility.setTable("tdirectories")
	.addColumn(column="dirID",dataType="char",length="35",nullable=false, default='')
	.addColumn(column="siteID",dataType="varchar",length="35")
	.addColumn(column="subdir",dataType="varchar",length="255")
	.addColumn(column="editfilename",dataType="varchar",length="255")
	.addPrimaryKey("dirID")
	.addIndex("siteID");

	dbUtility.setTable("tcontentfeeds").addColumn(column="imageSize",dataType="varchar",length="50");
	dbUtility.setTable("tcontent").addColumn(column="imageSize",dataType="varchar",length="50");
</cfscript>


