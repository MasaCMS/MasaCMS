<!--- make sure tsettings.useDefaultSMTPServer exists --->

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select theme from tsettings  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tsettings ADD theme [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN theme varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN theme varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN theme varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD "THEME" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>
