<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select parentid from tcontentcomments  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD parentID [char](35) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcomments ADD path #MSSQLlob# default NULL
	</cfquery>
	<cfquery>
	CREATE  INDEX [IX_tcontentcomment_parentID] ON [dbo].[tcontentcomments]([parentID]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD parentID char(35) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcomments ADD path longtext default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_tcontentcomments_parentID ON tcontentcomments (parentID)
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD parentID char(35) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcomments ADD path text default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_tcontentcomments_parentID ON tcontentcomments (parentID)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentcomments ADD parentID char(35) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcomments ADD path clob default NULL
	</cfquery>
	<cfquery>
	CREATE INDEX IX_tcontentcomments_parentID ON tcontentcomments (parentID)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTCOMMENTS" ADD ("PARENTID" char(35))
	</cfquery>
	<cfquery>
	ALTER TABLE "TCONTENTCOMMENTS" ADD ("PATH" clob)
	</cfquery>
	<cfquery>
	CREATE INDEX "IDX_TCONTENTCOMMENTS_PARENTID" ON "TCONTENTCOMMENTS" ("PARENTID") 
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tcontentcomments set path=commentid
</cfquery>
</cfif>

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select tagline from tsettings  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tsettings ADD tagline [nvarchar](255) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tsettings ADD tagline varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tsettings ADD tagline varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tsettings ADD tagline varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD ("TAGLINE" varchar2(255))
	</cfquery>
</cfcase>
</cfswitch>
</cfif>


<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select params from tcontentobjects  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentobjects ADD Params #MSSQLlob# default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects DROP CONSTRAINT PK_tcontentobjects
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects ALTER COLUMN OrderNo [int] NOT NULL
	</cfquery>
	<cfquery>
	ALTER TABLE [dbo].[tcontentobjects] WITH NOCHECK ADD 
	CONSTRAINT [PK_tcontentobjects] PRIMARY KEY  CLUSTERED 
	(
		[ContentHistID],
		[ObjectID],
		[Object],
		[ColumnID],
		[OrderNo]
	)  ON [PRIMARY]
	</cfquery>

</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentobjects ADD Params longtext default NULL
	</cfquery>
	<cftry>
	<cfquery>
	ALTER TABLE tcontentobjects drop primary key
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects add primary key (`ContentHistID`,`ObjectID`,`Object`,`ColumnID`,`OrderNo`)
	</cfquery>
	<cfcatch></cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentobjects ADD Params text default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects DROP CONSTRAINT PK_tcontentobjects
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects ALTER COLUMN OrderNo TYPE integer
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects ALTER COLUMN OrderNo SET NOT NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects ADD CONSTRAINT PK_tcontentobjects PRIMARY KEY
	(
		ContentHistID,
		ObjectID,
		Object,
		ColumnID,
		OrderNo
	)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentobjects ADD Params clob
	</cfquery>
	<cftry>
	<cfquery>
	ALTER TABLE tcontentobjects drop primary key
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentobjects add primary key (`ContentHistID`,`ObjectID`,`Object`,`ColumnID`,`OrderNo`)
	</cfquery>
	<cfcatch></cfcatch>
	</cftry>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTOBJECTS" ADD ("PARAMS" clob)
	</cfquery>
	<cfquery>
	ALTER TABLE "TCONTENTOBJECTS" DROP CONSTRAINT "PRIMARY_27"
	</cfquery>
	<cfquery>
	ALTER TABLE "TCONTENTOBJECTS" ADD CONSTRAINT "PRIMARY_27" PRIMARY KEY ("CONTENTHISTID", "OBJECTID", "OBJECT", "COLUMNID", "ORDERNO") ENABLE
	</cfquery>
</cfcase>
</cfswitch>
</cfif>


<cftry>
<cfquery name="rsCheck">
select remotePubDate from tcontentcategories  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remotePubDate [datetime] default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remotePubDate datetime default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remotePubDate timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentcategories ADD remotePubDate timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTCATEGORIES" add "REMOTEPUBDATE" DATE
	</cfquery>	
</cfcase>
</cfswitch>
</cfif>

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select remotePubDate from tcontentfeeds  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remotePubDate [datetime] default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remotePubDate datetime default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remotePubDate timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentfeeds ADD remotePubDate timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENTFEEDS" add "REMOTEPUBDATE" DATE
	</cfquery>	
</cfcase>
</cfswitch>
</cfif>
