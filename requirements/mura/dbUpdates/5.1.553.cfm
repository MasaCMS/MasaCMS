<!--- make sure tcontent.urltitle and tcontent.htmltitle exists --->

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select urltitle from tcontent  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD urltitle nvarchar(255) NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD htmltitle nvarchar(255) NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN urltitle varchar(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN htmltitle longtext
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN urltitle varchar(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN htmltitle text
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN urltitle varchar(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN htmltitle clob
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENT" ADD "URLTITLE" varchar2(255)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TCONTENT" ADD "HTMLTITLE" varchar2(255)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	update tcontent set
	urltitle=menutitle,
	htmltitle=title
</cfquery>

</cfif>
