<cfset rsCheck=dbTableColumns("tcontent")>
<cfset dbversion=dbUtility.version().database_productname>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'majorversion'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontent ADD majorVersion int default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN majorVersion int(11) NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN majorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN majorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontent ADD majorVersion NUMBER(10,0)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tcontent set majorVersion=0
</cfquery>
	
</cfif>

<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'minorversion'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontent ADD minorVersion int default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN minorVersion int(11) NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN minorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN minorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontent ADD minorVersion NUMBER(10,0)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tcontent set minorVersion=0
</cfquery>
	
</cfif>

<cfset rsCheck=dbTableColumns("tcontentstats")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'majorversion'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentstats ADD majorVersion int default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN majorVersion int(11) NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN majorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN majorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontentstats ADD majorVersion NUMBER(10,0)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tcontentstats set majorVersion=0
</cfquery>
	
</cfif>

<cfset rsCheck=dbTableColumns("tcontentstats")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'minorversion'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentstats ADD minorVersion int default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN minorVersion int(11) NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN minorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN minorVersion integer NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontentstats ADD minorVersion NUMBER(10,0)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tcontentstats set minorVersion=0
</cfquery>
	
</cfif>

<cfset rsCheck=dbTableColumns("tcontentstats")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'lockid'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentstats ADD lockID [char](35) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN lockID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN lockID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentstats ADD COLUMN lockID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontentstats ADD lockID char(35)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontentassignments")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'type'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentassignments ADD type [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentassignments ADD COLUMN type varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentassignments ADD COLUMN type varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentassignments ADD COLUMN type varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontentassignments ADD type varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	Update tcontentassignments set type='draft'
</cfquery>
</cfif>


<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'expires'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontent ADD expires [datetime] default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN expires datetime default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN expires timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN expires timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontent ADD expires date
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontentcomments")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'remoteid'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD remoteID [char](35) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN remoteID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN remoteID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN remoteID char(35) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontentcomments ADD remoteID char(35)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset dbCreateIndex(table="tcontentcomments",column="remoteid")>

<cfset rsCheck=dbTableColumns("tcontentcomments")>
	
<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'url'
</cfquery>

<cfif rsCheck.COLUMN_SIZE eq 50>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cftry>
		<cfquery>
		ALTER TABLE tcontentcomments ALTER COLUMN url nvarchar(255) 
		</cfquery>
		<cfcatch></cfcatch>
	</cftry>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tcontentcomments 
	<cfif dbversion eq 'H2'>
		ALTER
	<cfelse>
		MODIFY
	</cfif>
	 column url varchar(255)
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcomments ALTER COLUMN url TYPE varchar(255)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfset dbUtility.alterColumn(table='tcontentcomments',column='url',datatype='varchar',length=255)>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE tcontentcomments rename column url to url2
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcomments ADD url varchar2(255)
	</cfquery>
	<cfquery>
	UPDATE tcontentcomments set url=url2
	</cfquery>
	<cfquery>
	ALTER TABLE tcontentcomments drop column url2
	</cfquery>
</cfcase>
</cfswitch>	
</cfif>
