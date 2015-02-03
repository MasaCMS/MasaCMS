<!--- If using MSSQL 2005 or greater switch from ntext to nvarchar(max) --->
<cfif getDbType() eq "MSSQL">
	
	<cfif MSSQLversion neq 8>
		
		<cfset tableList="tclassextend,tclassextendattributes,tclassextenddata,tclassextenddatauseractivity,tclassextendsets,tcontent,tcontentcategories,tcontentcomments,tcontentfeeds,temails,tformresponsepackets,tformresponsequestions,tmailinglist,tsettings,tuseraddresses,tusers">

		<!---
		<cfif variables.instance.adManager>
			<cfset tableList=tableList & ",tadcampaigns,tadcreatives,tadplacements,tadzones">
		</cfif>	
		--->
		
		<cfquery name="rsCheck">
		SELECT OBJECT_NAME(c.OBJECT_ID) TableName, c.name ColumnName
		FROM sys.columns AS c
		JOIN sys.types AS t ON c.user_type_id=t.user_type_id
		WHERE t.name = 'ntext'
		AND OBJECT_NAME(c.OBJECT_ID) IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#tablelist#">)
		ORDER BY c.OBJECT_ID;
		</cfquery>
		
		<cfif rsCheck.recordcount>
			
			<cfloop list="#tablelist#" index="t">
				<cfquery name="rsFields" dbType="query">
				SELECT * from rscheck 
				where tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#t#">
				</cfquery>
				
				<cfif rsFields.recordcount>
					<cftry>
					<cfloop query="rsFields">
						<cfquery>
							ALTER TABLE #t# ALTER COLUMN #rsFields.ColumnName# NVARCHAR(MAX) null 			
						</cfquery>
					</cfloop>
					<cfquery>
					UPDATE #t# set 
						<cfloop query="rsFields">
							#rsFields.ColumnName# = #rsFields.ColumnName# <cfif rsFields.currentrow lt rsFields.recordcount>,</cfif>
						</cfloop>
					</cfquery>
					<cfcatch></cfcatch>
					</cftry>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>


<!--- add userID to the tcontentcomments --->
<cfquery name="rsCheck">
select * from tcontentcomments  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"userID")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD userID [char](35) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN userID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN userID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN userID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTCOMMENTS" ADD "USERID" char(35)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cftransaction>
	<cfquery>
	IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tuserremotesessions]')
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	CREATE TABLE [dbo].[tuserremotesessions] ( 
		  [userID] [char](35) not null,
		  [authToken] [char](32) default NULL,
		  [data] [nvarchar](4000) default NULL,
		  [created] [datetime] NOT NULL ,
		  [lastAccessed] [datetime] NOT NULL
	) on [PRIMARY]
	</cfquery>
	
	<cfquery>
	IF NOT EXISTS (SELECT 1
					FROM sysindexes
					WHERE id = object_id(N'[dbo].[tuserremotesessions]') 
					AND status & 2048 = 2048 )
	ALTER TABLE [dbo].[tuserremotesessions] WITH NOCHECK ADD 
		CONSTRAINT [PK_tuserremotesessions_userID] PRIMARY KEY  CLUSTERED 
		(
			[userID]
		)  ON [PRIMARY] 
	</cfquery>
	<cfquery>
	IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'tuserremotesessions_authToken')
	 CREATE  INDEX [tuserremotesessions_authToken] ON [dbo].[tuserremotesessions]([authToken]) ON [PRIMARY]
	</cfquery>
	</cftransaction>
</cfcase>
<cfcase value="mysql">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery>
	select userID as CheckIfTableExists from tuserremotesessions limit 1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
	<cftry>
		<cfquery>
		CREATE TABLE IF NOT EXISTS  `tuserremotesessions` (
		  `userID` char(35) default NULL,
		  `authToken` char(32) default NULL,
		  `data` text,
		  `created` datetime default NULL,
		  `lastAccessed` datetime NOT NULL,
		  PRIMARY KEY  (`userID`),
		  KEY `tuserremotesessions_authtoken` (`authToken`)
		) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
		</cfquery>
		<cfcatch>
			<cfquery>
			CREATE TABLE IF NOT EXISTS  `tuserremotesessions` (
			  `userID` char(35) default NULL,
			  `authToken` char(32) default NULL,
			  `data` text,
			  `created` datetime default NULL,
			  `lastAccessed` datetime default NULL,
			  PRIMARY KEY  (`userID`)
			) 
			</cfquery>
			<cfquery>
			CREATE INDEX tuserremotesessions_authtoken ON tuserremotesessions(authToken)
			</cfquery>
		</cfcatch>
	</cftry>	
	</cfif>
</cfcase>
<cfcase value="postgresql">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
		<cfquery>
		select userID as CheckIfTableExists from tuserremotesessions where 0=1
		</cfquery>
		<cfcatch>
			<cfset variables.RUNDBUPDATE=true/>
		</cfcatch>
	</cftry>

	<cfif variables.RUNDBUPDATE>
		<cfquery>
		CREATE TABLE IF NOT EXISTS tuserremotesessions (
			userID char(35) not null,
			authToken char(32) default NULL,
			data varchar(4000) default NULL,
			created timestamp NOT NULL ,
			lastAccessed timestamp NOT NULL ,
			CONSTRAINT PK_tuserremotesessions_userID PRIMARY KEY (userID)
		)
		</cfquery>

		<cfquery>
		CREATE INDEX tuserremotesessions_authToken ON tuserremotesessions(authToken)
		</cfquery>
	</cfif>
</cfcase>
<cfcase value="nuodb">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery>
	select userID as CheckIfTableExists from tuserremotesessions where 0=1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
	
		<cfquery>
		CREATE TABLE tuserremotesessions (
		  userID char(35) default NULL,
		  authToken char(32) default NULL,
		  data clob,
		  created timestamp default NULL,
		  lastAccessed timestamp NOT NULL,
		  PRIMARY KEY  (userID)
		) 
		</cfquery>

		<cfquery>
		 CREATE INDEX tuserremotesessions_authtoken on tuserremotesessions (authToken)
		</cfquery>
	</cfif>
</cfcase>
<cfcase value="oracle">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery>
	select * from (select userID as CheckIfTableExists from tuserremotesessions) where ROWNUM <=1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
		<cftransaction>
		<cfquery>
		CREATE TABLE "TUSERREMOTESESSIONS" (
		  "USERID" CHAR(35) ,
		  "AUTHTOKEN" CHAR(32) ,
		  "DATA" varchar2(4000),
		  "CREATED" date,
		  "LASTACCESSED" date
		) 
		</cfquery>
		
		<cfquery>
		ALTER TABLE "TUSERREMOTESESSIONS" ADD CONSTRAINT "TUSERREMOTESESSIONS_PRIMARY" PRIMARY KEY ("USERID") ENABLE
		</cfquery>
		
		<cfquery>
		CREATE INDEX "TUSERREMOTESESSIONS_AUTHTOKEN" ON "TUSERREMOTESESSIONS" ("AUTHTOKEN") 
		</cfquery>
		</cftransaction>
	</cfif>
</cfcase>
</cfswitch>

<!--- make sure new cache settings exists --->

<cfquery name="rsCheck">
select * from tsettings where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"cacheCapacity")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery>
ALTER TABLE tsettings ADD cacheCapacity int 
</cfquery>
<cfquery>
ALTER TABLE tsettings ADD cacheFreeMemoryThreshold int 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN cacheCapacity int(10) 
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN cacheFreeMemoryThreshold int(10) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery>
			ALTER TABLE tsettings ADD cacheCapacity int(10)
			</cfquery>
			<cfquery>
			ALTER TABLE tsettings ADD cacheFreeMemoryThreshold int(10)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN cacheCapacity integer
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN cacheFreeMemoryThreshold integer
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN cacheCapacity integer
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN cacheFreeMemoryThreshold integer
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery>
ALTER TABLE tsettings ADD cacheCapacity NUMBER(10,0)
</cfquery>
<cfquery>
ALTER TABLE tsettings ADD cacheFreeMemoryThreshold NUMBER(10,0)
</cfquery>
</cfcase>
</cfswitch>

<cfquery>update tsettings set cacheFreeMemoryThreshold = 0,cacheCapacity=0</cfquery>
</cfif>

<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cftransaction>
	<cfquery>
	IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tuserstrikes]')
	AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	CREATE TABLE [dbo].[tuserstrikes] ( 
		  [username] [nvarchar](100) NOT NULL,
		  [strikes] [int] default NULL,
		  [lastAttempt] [datetime] default NULL
	) on [PRIMARY]
	</cfquery>
	
	<cfquery>
	IF NOT EXISTS (SELECT 1
					FROM sysindexes
					WHERE id = object_id(N'[dbo].[tuserstrikes]') 
					AND status & 2048 = 2048 )
	ALTER TABLE [dbo].[tuserstrikes] WITH NOCHECK ADD 
		CONSTRAINT [PK_tuserstrikes_username] PRIMARY KEY  CLUSTERED 
		(
			[username]
		)  ON [PRIMARY] 
	</cfquery>
	</cftransaction>
</cfcase>
<cfcase value="mysql">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery>
	select username as CheckIfTableExists from tuserstrikes limit 1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
	<cftry>
		<cfquery>
		CREATE TABLE IF NOT EXISTS  `tuserstrikes` (
		  `username` varchar(100) default NULL,
		  `strikes` int(10) default NULL,
		  `lastAttempt` datetime NOT NULL,
		  PRIMARY KEY  (`username`)
		) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
		</cfquery>
		<cfcatch>
			<cfquery>
			CREATE TABLE IF NOT EXISTS  `tuserstrikes` (
			  `username` varchar(100) default NULL,
			  `strikes` int(10) default NULL,
			  `lastAttempt` datetime default NULL,
			  PRIMARY KEY  (`username`)
			) 
			</cfquery>
		</cfcatch>
	</cftry>	
	</cfif>
</cfcase>
<cfcase value="postgresql">
	<cftransaction>
	<cfquery>
	CREATE TABLE IF NOT EXISTS tuserstrikes (
		username varchar(100) NOT NULL,
		strikes integer default NULL,
		lastAttempt timestamp default NULL,
		CONSTRAINT PK_tuserstrikes_username PRIMARY KEY (username)
	)
	</cfquery>
	</cftransaction>
</cfcase>
<cfcase value="nuodb">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery>
	select username as CheckIfTableExists from tuserstrikes where 0=1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
		<cfquery>
		CREATE TABLE tuserstrikes (
		  username varchar(100) default NULL,
		  strikes integer default NULL,
		  lastAttempt datetime NOT NULL,
		  PRIMARY KEY  (username)
		) 
		</cfquery>	
	</cfif>
</cfcase>
<cfcase value="oracle">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery>
	select * from (select username as CheckIfTableExists from tuserstrikes) where ROWNUM <=1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
		<cftransaction>
		<cfquery>
		CREATE TABLE "TUSERSTRIKES" (
		  "USERNAME" VARCHAR2(100) ,
		  "STRIKES" NUMBER(10,0) ,
		  "LASTATTEMPT" date
		) 
		</cfquery>
		
		<cfquery>
		ALTER TABLE "TUSERSTRIKES" ADD CONSTRAINT "TUSERSTRIKES_PRIMARY" PRIMARY KEY ("USERNAME") ENABLE
		</cfquery>
		</cftransaction>
	</cfif>
</cfcase>
</cfswitch>


<!--- check to see if tplugins.loadPriority --->
<cfquery name="rsCheck">
select * from tplugins where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"loadPriority")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery>
ALTER TABLE tplugins ADD loadPriority int 
</cfquery>

</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN loadPriority int(10) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery>
			ALTER TABLE tplugins ADD loadPriority int(10)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN loadPriority integer
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN loadPriority integer
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery>
ALTER TABLE tplugins ADD loadPriority NUMBER(10,0)
</cfquery>
</cfcase>
</cfswitch>

<cfquery>
update tplugins set loadPriority=5
</cfquery>
</cfif>

<cfquery>
delete from tsystemobjects where object='IASiteMap'
</cfquery>