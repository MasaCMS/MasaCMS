<!--- make sure tcontentfeeds.remoteID exists --->

<cfset variables.DOUPDATE=false>

<cftry>
<cfquery name="rsCheck">
select tablist from tusers  where 0=1
</cfquery>
<cfcatch>
<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tusers ADD tablist [nvarchar](255) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tusers ADD tablist varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tusers ADD tablist varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tusers ADD tablist varchar(255) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TUSERS" ADD "TABLIST" varchar2(255)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

