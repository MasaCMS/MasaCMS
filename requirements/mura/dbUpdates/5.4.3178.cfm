<cfswitch expression="#getDbType()#">

	<cfcase value="mssql">		

		<cfset variables.RUNDBUPDATE=false/>

		<cftry>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				SELECT TOP 1 changesetID AS CheckIfTableExists FROM tchangesets
			</cfquery>
			<cfcatch>
				<cfset variables.RUNDBUPDATE = true />
			</cfcatch>
		</cftry>
			
		<cfif variables.RUNDBUPDATE>
		
		<cftransaction>

			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE TABLE [dbo].[tchangesets] ( 
				  [changesetID] 	[char](35)		NOT NULL 	DEFAULT (Left(NewID(), 23) + Right(NewID(),12)),
				  [siteID] 			[nvarchar](25) 	NULL		DEFAULT NULL,
				  [name] 			[nvarchar](100) NULL		DEFAULT NULL,
				  [description] 	<cfoutput>#MSSQLlob#</cfoutput>,
				  [created] 		[datetime] 		NULL		DEFAULT NULL,
				  [publishDate] 	[datetime] 		NULL		DEFAULT NULL,
				  [published] 		[tinyint] 		NULL		DEFAULT NULL,
				  [lastUpdate] 		[datetime] 		NULL		DEFAULT NULL,
				  [lastUpdateBy] 	[nvarchar](50) 	NULL		DEFAULT NULL,
				  [lastUpdateByID] 	[char](35) 		NULL		DEFAULT NULL,
				  [remoteID] 		[nvarchar](255) NULL		DEFAULT NULL,
				  [remotePubDate] 	[datetime] 		NULL		DEFAULT NULL,
				  [remoteSourceURL] [nvarchar](255) NULL		DEFAULT NULL
			) on [PRIMARY]
			</cfquery>
			
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				ALTER TABLE [dbo].[tchangesets] 
				WITH NOCHECK 
					ADD	CONSTRAINT [PK_tchangesets_changesetID] 
					PRIMARY KEY CLUSTERED ([changesetID])
					ON [PRIMARY] 
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				CREATE INDEX [IX_tchangesets_siteid] ON [dbo].[tchangesets]([siteid]) ON [PRIMARY]
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				CREATE INDEX [IX_tchangesets_publishDate] ON [dbo].[tchangesets]([publishDate]) ON [PRIMARY]
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				CREATE INDEX [IX_tchangesets_remoteid] ON [dbo].[tchangesets]([remoteid]) ON [PRIMARY]
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				ALTER TABLE tcontent ADD changesetID [char](35) default NULL
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				CREATE INDEX [IX_tcontent_changesetID] ON [dbo].[tcontent]([changesetID]) ON [PRIMARY]
			</cfquery>
		</cftransaction>
		</cfif>
	
	</cfcase>
	<cfcase value="mysql">
		<cftransaction>
			<cfif not dbUtility.setTable('tchangesets').tableExists()>
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE TABLE `tchangesets` (
					  `changesetID` char(35),
					  `siteID` varchar(25),
					  `name` varchar(100),
					  `description` longtext,
					  `created` datetime,
					  `publishDate` datetime,
					  `published` tinyint(3),
					  `lastUpdate` datetime,
					  `lastUpdateBy` varchar(50),
					  `lastUpdateByID` char(35),
					  `remoteID` varchar(255),
					  `remotePubDate` datetime,
					  `remoteSourceURL` varchar(255),
					  PRIMARY KEY  (`changesetID`),
					  key `IX_tchangesets_siteID` (`siteID`),
					  key `IX_tchangesets_publishDate` (`publishDate`),
					  key `IX_tchangesets_remoteID` (`remoteID`)
					) 
					<cfif dbUtility.version().database_productname neq 'H2'>
						ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
					</cfif>
				</cfquery>
			</cfif>

			<cfif not dbUtility.setTable('tcontent').columnExists('changesetID')>
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					ALTER TABLE tcontent ADD COLUMN changesetID char(35) default NULL
				</cfquery>
						
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE INDEX IX_tcontent_changesetID ON tcontent (changesetID)
				</cfquery>
			</cfif>
		</cftransaction>	
	</cfcase>
	<cfcase value="nuodb">
		<cftransaction>
			<cfif not dbUtility.setTable('tchangesets').tableExists()>
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE TABLE tchangesets (
					  changesetID char(35),
					  siteID varchar(25),
					  name varchar(100),
					  description clob,
					  created timestamp,
					  publishDate timestamp,
					  published smallint,
					  lastUpdate timestamp,
					  lastUpdateBy varchar(50),
					  lastUpdateByID char(35),
					  remoteID varchar(255),
					  remotePubDate timestamp,
					  remoteSourceURL varchar(255),
					  PRIMARY KEY  (changesetID)	 
					) 
				</cfquery>

				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE INDEX IX_tchangesets_siteID on tchangesets (siteID)
				</cfquery>
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE INDEX IX_tchangesets_publishDate on tchangesets (publishDate)
				</cfquery>
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE INDEX IX_tchangesets_remoteID on tchangesets (remoteID)
				</cfquery>
				 
	  
			</cfif>

			<cfif not dbUtility.setTable('tcontent').columnExists('changesetID')>
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					ALTER TABLE tcontent ADD COLUMN changesetID char(35) default NULL
				</cfquery>
						
				<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
					CREATE INDEX IX_tcontent_changesetID ON tcontent (changesetID)
				</cfquery>
			</cfif>
		</cftransaction>	
	</cfcase>
	<cfcase value="oracle">
		<cfset variables.RUNDBUPDATE=false/>
		<cftry>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				select * from (select changesetID as CheckIfTableExists from tchangesets) where ROWNUM <=1
			</cfquery>
			<cfcatch>
				<cfset variables.RUNDBUPDATE=true/>
			</cfcatch>
		</cftry>
		
		<cfif variables.RUNDBUPDATE>
			<cftransaction>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE TABLE "TCHANGESETS" (
			  "CHANGESETID" CHAR(35) ,
			  "SITEID" varchar2(25) ,
			  "NAME" varchar2(100),
			  "DESCRIPTION" clob,
			  "CREATED" date,
			  "PUBLISHDATE" date,
			  "PUBLISHED" NUMBER(3,0),
			  "LASTUPDATE" date,
			  "LASTUPDATEBY" varchar2(50),
			  "LASTUPDATEBYID" CHAR(35) ,
			  "REMOTEID" varchar2(255),
			  "REMOTEPUBDATE" date,
			  "REMOTESOURCEURL" varchar2(255)
			) 
				lob (DESCRIPTION) STORE AS (
				TABLESPACE "#getDbTablespace()#" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
				NOCACHE LOGGING
				STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
				PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE "TCHANGESETS" ADD CONSTRAINT "TCHANGESETS_PRIMARY" PRIMARY KEY ("CHANGESETID") ENABLE
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX "IDX_TCHANGESETS_SITEID" ON "TCHANGESETS" ("SITEID") 
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX "IDX_TCHANGESETS_REMOTEID" ON "TCHANGESETS" ("REMOTEID") 
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontent ADD changesetID char(35) default NULL
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX "IDX_TCONTENT_CHANGESETID" ON tcontent (changesetID) 
			</cfquery>
			
			</cftransaction>
		</cfif>
	</cfcase>
</cfswitch>

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select moduleID from tcontent where moduleID='00000000000000000000000000000000014'
</cfquery>

<cfif not rsCheck.recordcount>
	<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	select siteID from tsettings
	</cfquery>
	
	<cfloop query="rsCheck">
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		INSERT INTO tcontent 
		(
			SiteID
			,ModuleID
			,ParentID
			,ContentID
			,ContentHistID
			,RemoteID
			,RemoteURL
			,RemotePubDate
			,RemoteSourceURL
			,RemoteSource
			,Credits
			,FileID
			,Template
			,Type
			,subType
			,Active
			,OrderNo
			,Title
			,MenuTitle
			,Summary
			,Filename
			,MetaDesc
			,MetaKeyWords
			,Body
			,lastUpdate
			,lastUpdateBy
			,lastUpdateByID
			,DisplayStart
			,DisplayStop
			,Display
			,Approved
			,IsNav
			,Restricted
			,RestrictGroups
			,Target
			,TargetParams
			,responseChart
			,responseMessage
			,responseSendTo
			,responseDisplayFields
			,moduleAssign
			,displayTitle
			,Notes
			,inheritObjects
			,isFeature
			,ReleaseDate
			,IsLocked
			,nextN
			,sortBy
			,sortDirection
			,featureStart
			,featureStop
			,forceSSL
			,audience
			,keyPoints
			,searchExclude
			,path
		) VALUES  (
			'default'
			,'00000000000000000000000000000000014'
			,'00000000000000000000000000000000END'
			,'00000000000000000000000000000000014'
			,'#createUUID()#'
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,'Module'
			,'default'
			,1
			,NULL
			,'Change Sets Manager'
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,1
			,1
			,1
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,0
			,NULL
			,NULL
			,NULL
			,NULL
		)
		</cfquery>
	</cfloop>
</cfif>


<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tsettings where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"hasChangesets")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tsettings ADD hasChangesets tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN hasChangesets tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tsettings ADD hasChangesets tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN hasChangesets smallint 
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tsettings ADD hasChangesets NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
update tsettings set hasChangesets=0
</cfquery>

</cfif>

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select urltitle from tcontentcategories  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcategories ADD urltitle [nvarchar](255) default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcategories ADD filename [nvarchar](255) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcategories ADD urltitle varchar(255) default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcategories ADD filename varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENTCATEGORIES" ADD ("URLTITLE" varchar2(255))
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENTCATEGORIES" ADD ("FILENAME" varchar2(255))
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif getDbType() eq "MSSQL">
	<cfquery name="rscheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		select * from information_schema.columns
		where table_name = 'tchangesets'
		and column_name = 'publishDate'
		and is_nullable = 'No'
	</cfquery>
	
	<cfif rscheck.recordcount>
		<cftry>
			<cftransaction>
			<!--- remove not null constrain  --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE [dbo].[tchangesets]
			ALTER COLUMN [publishDate] [datetime] NULL 
			</cfquery>
			
			<!--- Unbind previous default value --->
			<cfquery name="rscheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			SELECT name 
			FROM sysobjects so JOIN sysconstraints sc
			ON so.id = sc.constid 
			WHERE object_name(so.parent_obj) = 'tchangesets' 
			AND so.xtype = 'D'
			AND sc.colid = 
			 (SELECT colid FROM syscolumns 
			 WHERE id = object_id('dbo.tchangesets') AND 
			 name = 'publishDate')
			</cfquery>
			
			<cfif rscheck.recordcount>
				<cfquery name="rscheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
				ALTER TABLE [dbo].[tchangesets] DROP CONSTRAINT #rscheck.name#
				</cfquery>
			</cfif>
			
			</cftransaction>
		<cfcatch></cfcatch>
		</cftry>
	</cfif>
</cfif>
