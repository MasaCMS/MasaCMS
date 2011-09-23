<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontentfeeds"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'imagesize'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageSize varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontentfeeds"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'imageheight'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageHeight varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontentfeeds"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'imagewidth'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageWidth varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontentfeeds"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'displaylist'
</cfquery>

<cfif not rsCheck.recordcount>
	
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	
<cfquery name="MSSQLversion" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	EXEC sp_MSgetversion
</cfquery>
	
<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>

<cfif MSSQLversion neq 8>
	<cfset MSSQLlob="[nvarchar](max) NULL">
<cfelse>
	<cfset MSSQLlob="[ntext]">
</cfif>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentfeeds ADD displayList #MSSQLlob# 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN displayList longtext 
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentfeeds ADD displayList clob
</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontent"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'imagesize'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageSize varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontent"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'imageheight'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageHeight varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontent"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'imagewidth'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD imageWidth varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontent"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'childtemplate'
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
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD childTemplate varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontent"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'urltitle'
</cfquery>

<cfif not listFindNoCase("varchar,nvarchar,varchar2",rsCheck.type_name)>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ALTER COLUMN urltitle nvarchar(255) 
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent MODIFY column urltitle varchar(255)
	</cfquery>
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

<cfdbinfo 
	name="rsCheck"
	datasource="#application.configBean.getDatasource()#"
	username="#application.configBean.getDbUsername()#"
	password="#application.configBean.getDbPassword()#"
	table="tcontent"
	type="columns">

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) = 'htmltitle'
</cfquery>

<cfif not listFindNoCase("varchar,nvarchar,varchar2",rsCheck.type_name)>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ALTER COLUMN htmltitle nvarchar(255) 
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent MODIFY column htmltitle varchar(255)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent rename column htmltitle to htmltitle2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD htmltitle varchar2(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	UPDATE tcontent set htmltitle=htmltitle2
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent drop column htmltitle2
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