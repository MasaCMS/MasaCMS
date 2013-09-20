<!--- make sure tsettings.siteLocale exists --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tsettings testLocale where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"siteLocale")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD siteLocale [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN siteLocale varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN siteLocale varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN siteLocale varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TSETTINGS" ADD "SITELOCALE" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>


