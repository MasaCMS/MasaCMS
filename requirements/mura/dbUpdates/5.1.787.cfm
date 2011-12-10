<!--- make sure tsettings.domainAlias exists --->

<cfset doUpdate=false>

<cftry>
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select domainAlias from tsettings  where 0=1
</cfquery>
<cfcatch>
<cfset doUpdate=true>
</cfcatch>
</cftry>

<cfif doUpdate>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery name="MSSQLversion" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		EXEC sp_MSgetversion
	</cfquery>
	
	<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>

	<cfif MSSQLversion neq 8>
		<cfset MSSQLlob="[nvarchar](max)">
	<cfelse>
		<cfset MSSQLlob="[ntext]">
	</cfif>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD domainAlias #MSSQLlob# NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN domainAlias longtext
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TSETTINGS" ADD ("DOMAINALIAS" clob)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>
