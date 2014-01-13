<!--- make sure tcontentfeeds.remoteID exists --->

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select remoteID from tcontentfeeds  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteID [nvarchar](255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteSourceURL [nvarchar](255) default NULL
	</cfquery>
	<cfquery>
	CREATE  INDEX [IX_feed_remoteID] ON [dbo].[tcontentfeeds]([remoteID]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteID varchar(255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteSourceURL varchar(255) default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_feed_remoteID ON tcontentfeeds (remoteID)
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteID varchar(255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteSourceURL varchar(255) default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_feed_remoteID ON tcontentfeeds (remoteID)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteID varchar(255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remoteSourceURL varchar(255) default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_feed_remoteID ON tcontentfeeds (remoteID)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTFEEDS" ADD "REMOTEID" varchar2(255)
	</cfquery>
	<cfquery>
	ALTER TABLE "TCONTENTFEEDS" ADD "REMOTESOURCEURL" varchar2(255)
	</cfquery>
	<cfquery>
	CREATE INDEX "IDX_FEED_REMOTEID" ON "TCONTENTFEEDS" ("REMOTEID") 
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset variables.DOUPDATE=false>
<cftry>
<cfquery name="rsCheck">
select remoteID from tcontentcategories  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteID [nvarchar](255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteSourceURL [nvarchar](255) default NULL
	</cfquery>
	<cfquery>
	CREATE  INDEX [IX_category_remoteID] ON [dbo].[tcontentcategories]([remoteID]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteID varchar(255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteSourceURL varchar(255) default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_category_remoteID ON tcontentcategories (remoteID)
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteID varchar(255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteSourceURL varchar(255) default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_category_remoteID ON tcontentcategories(remoteID)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteID varchar(255) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcategories ADD remoteSourceURL varchar(255) default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_category_remoteID ON tcontentcategories (remoteID)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTCATEGORIES" ADD "REMOTEID" varchar2(255)
	</cfquery>
	<cfquery>
	ALTER TABLE "TCONTENTCATEGORIES" ADD "REMOTESOURCEURL" varchar2(255)
	</cfquery>
	<cfquery>
	CREATE INDEX "IDX_CATEGORY_REMOTEID" ON "TCONTENTCATEGORIES" ("REMOTEID") 
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset variables.DOUPDATE=false>
<cftry>
<cfquery name="rsCheck">
select container from tclassextendsets  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tclassextendsets ADD container [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tclassextendsets ADD container varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tclassextendsets ADD container varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tclassextendsets ADD container varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCLASSEXTENDSETS" ADD "CONTAINER" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
<cfquery>
	update tclassextendsets set container='Default'
</cfquery>
</cfif>
