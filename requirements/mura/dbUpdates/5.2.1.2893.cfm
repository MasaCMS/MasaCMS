<cfswitch expression="#getDbType()#">
<cfcase value="mssql">

<cfquery>
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[ttrash]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[ttrash] ( 
	  [objectID] [char](35) NOT NULL,
	  [parentID] [char](35) NOT NULL,
	  [siteID] [varchar](25) NOT NULL,
	  [objectLabel] [nvarchar](255) NOT NULL,
	  [objectClass] [nvarchar](50) NOT NULL,
	  [objectType] [nvarchar](50) NOT NULL,
	  [objectSubType] [nvarchar](50) NOT NULL,
	  [objectstring] #MSSQLlob#,
	  [deletedDate] [datetime] default NULL,
	  [deletedBy] [nvarchar](50) NOT NULL
) on [PRIMARY]
</cfquery>

<cfquery>	
IF NOT EXISTS (SELECT 1
				FROM sysindexes
				WHERE id = object_id(N'[dbo].[ttrash]') 
				AND status & 2048 = 2048 )
ALTER TABLE [dbo].[ttrash] WITH NOCHECK ADD 
	CONSTRAINT [PK_ttrash] PRIMARY KEY  CLUSTERED 
	(
		[objectID]
	)  ON [PRIMARY] 
</cfquery>

<cfquery>	
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_ttrash_deleteddate')
CREATE INDEX IX_ttrash_deleteddate ON ttrash (deleteddate)
</cfquery>
<cfquery>	
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_ttrash_siteid')
CREATE INDEX IX_ttrash_siteid ON ttrash (siteid)
</cfquery>
<cfquery>	
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_ttrash_objectclass')
CREATE INDEX IX_ttrash_objectclass ON ttrash (objectclass)
</cfquery>
<cfquery>	
IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_ttrash_parentid')
CREATE INDEX IX_ttrash_parentid ON ttrash (parentid)
</cfquery>

</cfcase>
<cfcase value="mysql">
	<cftry>
	
	<cfquery>
	CREATE TABLE IF NOT EXISTS  `ttrash` (
	  objectID char(35) NOT NULL,
	  parentID char(35) NOT NULL,
	  siteID varchar(25) NOT NULL,
	  objectClass varchar(50) NOT NULL,
	  objectType varchar(50) NOT NULL,
	  objectSubType varchar(50) NOT NULL,
	  objectLabel varchar(255) NOT NULL,
	  objectstring longtext,
	  deletedDate datetime default NULL,
	  deletedBy varchar(50) NOT NULL,
	  PRIMARY KEY  (`objectID`),
	  KEY IX_ttrash_deleteddate (`deleteddate`),
	  KEY IX_ttrash_siteid (`siteID`),
	  KEY IX_ttrash_objecttype (`objectclass`),
	  KEY IX_ttrash_parentid (`parentID`)
	) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
	</cfquery>
	
	<cfcatch>
		<cftry>
		<cfquery>
		CREATE TABLE IF NOT EXISTS  `ttrash` (
		  objectID char(35) NOT NULL,
		  parentID char(35) NOT NULL,
		  siteID varchar(25) NOT NULL,
		  objectClass varchar(50) NOT NULL,
		  objectType varchar(50) NOT NULL,
		  objectSubType varchar(50) NOT NULL,
		  objectLabel varchar(255) NOT NULL,
		  objectstring longtext,
		  deletedDate datetime default NULL,
		  deletedBy varchar(50) NOT NULL,
		  PRIMARY KEY  (`objectID`)
		) 
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfif not dbUtility.tableExists('ttrash')>
		<cfquery>
		CREATE TABLE ttrash (
			objectID char(35) NOT NULL,
			parentID char(35) NOT NULL,
			siteID varchar(25) NOT NULL,
			objectLabel varchar(255) NOT NULL,
			objectClass varchar(50) NOT NULL,
			objectType varchar(50) NOT NULL,
			objectSubType varchar(50) NOT NULL,
			objectstring text,
			deletedDate timestamp default NULL,
			deletedBy varchar(50) NOT NULL,
			CONSTRAINT PK_ttrash PRIMARY KEY (objectID)
		)
		</cfquery>

		<cfquery>
		CREATE INDEX IX_ttrash_deleteddate ON ttrash (deleteddate)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_ttrash_siteid ON ttrash (siteid)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_ttrash_objectclass ON ttrash (objectclass)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_ttrash_parentid ON ttrash (parentid)
		</cfquery>
	</cfif>
</cfcase>
<cfcase value="nuodb">

	<cfif not dbUtility.tableExists('ttrash')>
	<cfquery>
	CREATE TABLE ttrash (
	  objectID char(35) NOT NULL,
	  parentID char(35) NOT NULL,
	  siteID varchar(25) NOT NULL,
	  objectClass varchar(50) NOT NULL,
	  objectType varchar(50) NOT NULL,
	  objectSubType varchar(50) NOT NULL,
	  objectLabel varchar(255) NOT NULL,
	  objectstring clob,
	  deletedDate timestamp default NULL,
	  deletedBy varchar(50) NOT NULL,
	  PRIMARY KEY  (objectID)
	) 
	</cfquery>

	<cfquery>
		CREATE INDEX IX_ttrash_deleteddate on ttrash (deleteddate);
	</cfquery>
	<cfquery>
		CREATE INDEX IX_ttrash_siteid on ttrash (siteID);
	</cfquery>
	<cfquery>
		CREATE INDEX IX_ttrash_objecttype on ttrash (objectclass);
	</cfquery>
	<cfquery>
		CREATE INDEX IX_ttrash_parentid on ttrash (parentID);
	</cfquery>
	</cfif>

</cfcase>
<cfcase value="oracle">
<cfset variables.RUNDBUPDATE=false/>
<cftry>
<cfquery>
select * from ttrash where 0=1
</cfquery>
<cfcatch>
<cfset variables.RUNDBUPDATE=true/>
</cfcatch>
</cftry>

<cfif variables.RUNDBUPDATE>
	<cftransaction>
	<cfquery>
	CREATE TABLE "TTRASH" (
	"OBJECTID" CHAR(35),
	"PARENTID" CHAR(35),
	"SITEID" VARCHAR2(25), 
	"OBJECTCLASS" VARCHAR2(50),
	"OBJECTTYPE" VARCHAR2(50),
	"OBJECTSUBTYPE" VARCHAR2(50),
	"OBJECTLABEL" VARCHAR2(255), 
	"OBJECTSTRING" CLOB, 
	"DELETEDDATE" DATE,
	"DELETEDBY" VARCHAR2(50)
   ) 
	lob (OBJECTSTRING) STORE AS (
	TABLESPACE "#getDbTablespace()#" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
	NOCACHE LOGGING
	STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
	PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
	</cfquery>

	<cfquery>
	ALTER TABLE "TTRASH" ADD CONSTRAINT "PK_TTRASH" PRIMARY KEY ("OBJECTID") ENABLE
	</cfquery>
	<cfquery>
	CREATE INDEX "IX_TTRASH_DELETEDDATE" ON "TTRASH" ("DELETEDDATE")
	</cfquery>
	<cfquery>
	CREATE INDEX "IX_TTRASH_SITEID" ON "TTRASH" ("SITEID")
	</cfquery>
	<cfquery>
	CREATE INDEX "IX_TTRASH_OBJECTCLASS" ON "TTRASH" ("OBJECTCLASS")
	</cfquery>
	<cfquery>
	CREATE INDEX "IX_TTRASH_PARENTID" ON "TTRASH" ("PARENTID")
	</cfquery>
	</cftransaction>
</cfif>
</cfcase>
</cfswitch>


<!--- make sure tcontentcomment.cacheItem exists --->
<cfquery name="rsCheck">
select * from tfiles where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"deleted")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery>
ALTER TABLE tfiles ADD deleted tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery>
	ALTER TABLE tfiles ADD COLUMN deleted tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery>
			ALTER TABLE tfiles ADD deleted tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tfiles ADD deleted smallint
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tfiles ADD COLUMN deleted smallint
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery>
ALTER TABLE tfiles ADD deleted NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>

<cfquery>
update tfiles set deleted=0
</cfquery>
</cfif>


