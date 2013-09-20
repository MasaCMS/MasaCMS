<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tadplacementcategoryassign]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tadplacementcategoryassign] ( 
	  [placementID] [char](35) NOT NULL,
	  [categoryID] [char](35) NOT NULL
) on [PRIMARY]
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">	
IF NOT EXISTS (SELECT 1
				FROM sysindexes
				WHERE id = object_id(N'[dbo].[tadplacementcategoryassign]') 
				AND status & 2048 = 2048 )
ALTER TABLE [dbo].[tadplacementcategoryassign] WITH NOCHECK ADD 
	CONSTRAINT [PK_tadplacementcategoryassign] PRIMARY KEY  CLUSTERED 
	(
		[placementID], [categoryID]
	)  ON [PRIMARY] 
</cfquery>

</cfcase>
<cfcase value="mysql">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	select placementID as CheckIfTableExists from tadplacementcategoryassign limit 1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
	<cftry>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE TABLE IF NOT EXISTS  `tadplacementcategoryassign` (
	  `placementID` char(35) NOT NULL,
	  `categoryID` char(35) NOT NULL,
	  PRIMARY KEY  (`placementID`,`categoryID`)
	) ENGINE=#variables.instance.MYSQLEngine# AUTO_INCREMENT=16 DEFAULT CHARSET=utf8
	</cfquery>
	
	
	<cfcatch>
		<cftry>
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS  `tadplacementcategoryassign` (
		  `placementID` char(35) NOT NULL,
		  `categoryID` char(35) NOT NULL,
		  PRIMARY KEY  (`placementID`,`categoryID`)
		) 
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	</cfcatch>
	</cftry>
	</cfif>
</cfcase>
<cfcase value="postgresql">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		select placementID as CheckIfTableExists from tadplacementcategoryassign limit 1
		</cfquery>
		<cfcatch>
			<cfset variables.RUNDBUPDATE=true/>
		</cfcatch>
	</cftry>

	<cfif variables.RUNDBUPDATE>
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS  tadplacementcategoryassign (
			placementID char(35) NOT NULL,
			categoryID char(35) NOT NULL,
			CONSTRAINT PK_tadplacementcategoryassign PRIMARY KEY (placementID, categoryID)
		)
		</cfquery>
	</cfif>
</cfcase>
<cfcase value="nuodb">	
	<cfif not dbUtility.tableExists('tadplacementcategoryassign')>
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE tadplacementcategoryassign (
			  placementID char(35) NOT NULL,
			  categoryID char(35) NOT NULL,
			  PRIMARY KEY  (placementID,categoryID)
			) 
		</cfquery>
	</cfif>
</cfcase>
<cfcase value="oracle">
<cfset variables.RUNDBUPDATE=false/>
<cftry>
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from (select placementID as CheckIfTableExists from tadplacementcategoryassign) where ROWNUM <=1
</cfquery>
<cfcatch>
<cfset variables.RUNDBUPDATE=true/>
</cfcatch>
</cftry>

<cfif variables.RUNDBUPDATE>
	<cftransaction>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE TABLE tadplacementcategoryassign (
	  placementID CHAR(35),
	  categoryID CHAR(35) 
	) 
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadplacementcategoryassign ADD CONSTRAINT tadplacementcatassign_pk PRIMARY KEY (placementID, categoryID) ENABLE
	</cfquery>
	</cftransaction>
</cfif>
</cfcase>
</cfswitch>


<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tadplacements  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"hasCategories")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadplacements ADD hasCategories [int] default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_ad_hascategories] ON [dbo].[tadplacements]([hasCategories]) ON [PRIMARY]
	</cfquery>
	
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadplacements ADD COLUMN hasCategories int(11) default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_ad_hascategories ON tadplacements (hasCategories)
	</cfquery>

	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tadplacements ADD  hasCategories INTEGER default NULL
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_ad_hascategories ON tadplacements (hasCategories)
			</cfquery>
			
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadplacements ADD hasCategories integer default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_ad_hascategories ON tadplacements(hasCategories)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE tadplacements ADD COLUMN hasCategories int default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE INDEX IX_ad_hascategories ON tadplacements (hasCategories)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadplacements ADD hasCategories number(10,0) default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_AD_HASCATEGORIES" ON tadplacements (hasCategories) 
	</cfquery>
	
</cfcase>

</cfswitch>


<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	update tadplacements set hasCategories=0
	</cfquery>
</cfif>

<cfset variables.DOUPDATE=false>
<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select remoteID from tclassextenddatauseractivity  where 0=1
</cfquery>
<cfcatch>
	<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE [dbo].[tclassextenddatauseractivity] ADD remoteID [nvarchar](35) NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_remotID2] ON [dbo].[tclassextenddatauseractivity]([remoteID]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN remoteID varchar(35) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_remote2 ON tclassextenddatauseractivity (remoteID)
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddatauseractivity ADD COLUMN remoteID varchar(35) default NULL
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_remoteID2 ON tclassextenddatauseractivity (remoteID)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD remoteID varchar(35) NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_remotID2 ON tclassextenddatauseractivity(remoteID)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD remoteID varchar2(35)
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_REMOTEID2" ON tclassextenddatauseractivity (remoteID) 
	</cfquery>
</cfcase>

</cfswitch>

</cfif>

<cfset variables.DOUPDATE=false>
<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select remoteID from tclassextenddata where 0=1
</cfquery>
<cfcatch>
	<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE [dbo].[tclassextenddata] ADD remoteID [nvarchar](35) NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_remotID1] ON [dbo].[tclassextenddata]([remoteID]) ON [PRIMARY]
	</cfquery>	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_attr_name] ON [dbo].[tclassextendattributes]([name]) ON [PRIMARY]
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_type] ON [dbo].[tclassextend]([type],[subtype]) ON [PRIMARY]
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_siteID] ON [dbo].[tclassextend]([siteID]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD remoteID varchar2(35)
	</cfquery>	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_REMOTEID1" ON tclassextenddata (remoteID) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_ATTR_NAME" ON tclassextendattributes (name) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_TYPE" ON tclassextend (type,subtype) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_SITEID" ON tclassextend (siteID) 
	</cfquery>
</cfcase>

</cfswitch>

</cfif>