<!--- make sure tcontentfeeds.remoteID exists --->

<cfset doUpdate=false>

<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select tablist from tusers  where 0=1
</cfquery>tusers
<cfcatch>
<cfset doUpdate=true>
</cfcatch>
</cftry>

<cfif doUpdate>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tusers ADD tablist [nvarchar](255) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tusers ADD tablist varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TUSERS" ADD "TABLIST" varchar2(255)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

