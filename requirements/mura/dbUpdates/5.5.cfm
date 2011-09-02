<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontentfeeds where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"imageSize")>
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
	ALTER TABLE "TCONTENTFEEDS" ADD "imageSize" varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"imageHeight")>
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
	ALTER TABLE "TCONTENTFEEDS" ADD "IMAGEHEIGHT" varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"imageWidth")>
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
	ALTER TABLE "TCONTENTFEEDS" ADD "IMAGEWIDTH" varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"displayList")>
	
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
ALTER TABLE tcontentfeeds ADD displayList MSSQLlob 
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

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontent where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"imageSize")>
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
	ALTER TABLE "TCONTENT" ADD "imageSize" varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"imageHeight")>
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
	ALTER TABLE "TCONTENT" ADD "IMAGEHEIGHT" varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"imageWidth")>
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
	ALTER TABLE "TCONTENT" ADD "IMAGEWIDTH" varchar2(15)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"childTemplate")>
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