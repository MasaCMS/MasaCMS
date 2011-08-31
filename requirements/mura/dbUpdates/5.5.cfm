<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontentfeeds where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"imageSize")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageSize [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageSize varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENTFEEDS" ADD "imageSize" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"imageHeight")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageHeight [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageHeight varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENTFEEDS" ADD "IMAGEHEIGHT" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"imageWidth")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD imageWidth [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN imageWidth varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENTFEEDS" ADD "IMAGEWIDTH" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfif not listFindNoCase(rsCheck.columnlist,"displaySummaries")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentfeeds ADD displaySummaries tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentfeeds ADD COLUMN displaySummaries tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontentfeeds ADD displaySummaries tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentfeeds ADD displaySummaries NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>
</cfif>