<!--- make sure tsettings.domainAlias exists --->

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select domainAlias from tsettings  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tsettings ADD domainAlias #MSSQLlob# NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN domainAlias longtext
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN domainAlias text
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN domainAlias clob
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD ("DOMAINALIAS" clob)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>
