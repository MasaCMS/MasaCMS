<cfscript>
	dbUtility.setTable("tclassextend").addColumn(column="description",datatype="longtext");
	dbUtility.setTable("tsettings")
		.addColumn(column="enforcePrimaryDomain",datatype="tinyint",default=0);

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

	if(not local.hasMedium){
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