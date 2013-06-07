<cfset rsCheck=dbTableColumns("tcontentfeeds")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'imagesize'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageSize [nvarchar](15) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageSize varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageSize varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageSize varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontentfeeds")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'imageheight'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageHeight [nvarchar](15) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageHeight varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageHeight varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageHeight varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontentfeeds")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'imagewidth'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageWidth [nvarchar](15) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageWidth varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageWidth varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageWidth varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontentfeeds")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'displaylist'
</cfquery>

<cfif not rsCheck.recordcount>
	
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentfeeds ADD displayList #MSSQLlob# 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN displayList longtext 
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN displayList clob 
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentfeeds ADD displayList clob
</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'imagesize'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageSize [nvarchar](15) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN imageSize varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN imageSize varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageSize varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'imageheight'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageHeight [nvarchar](15) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN imageHeight varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN imageHeight varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageHeight varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'imagewidth'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageWidth [nvarchar](15) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN imageWidth varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN imageWidth varchar(15) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageWidth varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'childtemplate'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD childTemplate [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN childTemplate varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN childTemplate varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD childTemplate varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tcontent")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'urltitle'
</cfquery>

<cfif not listFindNoCase("varchar,nvarchar,varchar2",rsCheck.type_name)>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cftry>
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE tcontent ALTER COLUMN urltitle nvarchar(255) 
		</cfquery>
		<cfcatch></cfcatch>
	</cftry>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ALTER column urltitle varchar(255)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfset dbUtility.alterColumn(table='tcontent',column='urltitle',datatype='varchar',length=255)>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent rename column urltitle to urltitle2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD urltitle varchar2(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	UPDATE tcontent set urltitle=urltitle2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent drop column urltitle2
	</cfquery>
</cfcase>
</cfswitch>	
</cfif>


<cfif getDbType() eq "mysql">
	<cfset rsCheck=dbTableColumns("tcontent")>

	<cfloop list="targetparams,restrictgroups,moduleassign,htmltitle,remoteurl,remotesourceurl,remotesource,audience,tags,responsesendto,responsedisplayfields,notes,path,keypoints,metakeywords,metadesc" index="i">
		<cfquery name="rsSubCheck" dbtype="query">
			select * from rsCheck where lower(rsCheck.column_name) like '#i#'
		</cfquery>
		
		<cfif rsSubCheck.type_name neq "text">
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontent ALTER column #i# text
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<cfset rsCheck=dbTableColumns("tcontentfeeds")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'shownavonly'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD showNavOnly tinyint default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN showNavOnly tinyint(3) NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN showNavOnly smallint NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD showNavOnly NUMBER(3,0)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	update tcontentfeeds set showNavOnly=1
</cfquery>
	
</cfif>

<cfset rsCheck=dbTableColumns("tcontentfeeds")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'showexcludesearch'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD showExcludeSearch tinyint default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN showExcludeSearch tinyint(3) NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN showExcludeSearch smallint NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD showExcludeSearch NUMBER(3,0)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	update tcontentfeeds set showExcludeSearch=0
</cfquery>
	
</cfif>

<cfset rsCheck=dbTableColumns("tplugindisplayobjects")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'configuratorinit'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD configuratorInit [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD COLUMN configuratorInit varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD COLUMN configuratorInit varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD configuratorInit varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tplugindisplayobjects")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'configuratorjs'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD configuratorJS [nvarchar](255) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD COLUMN configuratorJS varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD COLUMN configuratorJS varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD configuratorJS varchar2(255)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset rsCheck=dbTableColumns("tsettings")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'domain'
</cfquery>

<cfif rsCheck.COLUMN_SIZE neq 255>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ALTER COLUMN [domain] nvarchar(255) 
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ALTER column domain varchar(255)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfset dbUtility.setTable('tsettings').alterColumn(column='domain',datatype='varchar',length=255)>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings rename column domain to domain2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD domain varchar2(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	UPDATE tsettings set domain=domain2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings drop column domain2
	</cfquery>
</cfcase>
</cfswitch>	
</cfif>

<cfset rsCheck=dbTableColumns("tsettings")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'columnnames'
</cfquery>

<cfif rsCheck.COLUMN_SIZE eq 255>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ALTER COLUMN [columnNames] nvarchar(max) 
	</cfquery>
	<cfcatch></cfcatch>
	</cftry>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ALTER column columnNames text
	</cfquery>
</cfcase>
<cfcase value="nuodb">	
	<cfset dbUtility.setTable('tsettings').alterColumn(column='columnNames',datatype='longtext')>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings rename column columnNames to columnNames2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD columnNames clob
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	UPDATE tsettings set columnNames=columnNames2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings drop column columnNames2
	</cfquery>
</cfcase>
</cfswitch>	
</cfif>

<cfset dbCreateIndex(table="tcontent",column="urltitle")>
<cfset dbCreateIndex(table="tcontent",column="displaystart")>
<cfset dbCreateIndex(table="tcontent",column="displaystop")>
<cfset dbCreateIndex(table="tcontent",column="approved")>
<cfset dbCreateIndex(table="tcontent",column="active")>
<cfset dbCreateIndex(table="tcontent",column="display")>
<cfset dbCreateIndex(table="tcontent",column="isfeature")>
<cfset dbCreateIndex(table="tcontent",column="type")>
<cfset dbCreateIndex(table="tcontentcategoryassign",column="isfeature")>
<cfset dbCreateIndex(table="tcontentcategoryassign",column="featurestart")>
<cfset dbCreateIndex(table="tcontentcategoryassign",column="featurestop")>
