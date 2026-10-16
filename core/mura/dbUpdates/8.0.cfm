<cfscript>
  dbUtility.dropTable(table="trazunasettings");
</cfscript>

<cfset variables.dbUtility=getBean("dbUtility")>

<cfset getBean("rememberMeToken").checkSchema()>

<cfset variables.dbUtility.purgeCache()>

<cfset variables.rememberMeIndexNames="">
<cfloop array="#variables.dbUtility.indexes('tremembertokens')#" index="variables.rememberMeIndex">
	<cfset variables.rememberMeIndexNames=listAppend(variables.rememberMeIndexNames,variables.rememberMeIndex.name)>
</cfloop>

<cfif not listFindNoCase(variables.rememberMeIndexNames,"UQ_tremembertokens_selector")>
	<cfquery>
		CREATE UNIQUE INDEX UQ_tremembertokens_selector ON tremembertokens (selector)
	</cfquery>
</cfif>

<cfif not listFindNoCase(variables.rememberMeIndexNames,"IX_tremembertokens_user_site")>
	<cfquery>
		CREATE INDEX IX_tremembertokens_user_site ON tremembertokens (userID, siteID)
	</cfquery>
</cfif>

<cfif not listFindNoCase(variables.rememberMeIndexNames,"IX_tremembertokens_expiry")>
	<cfquery>
		CREATE INDEX IX_tremembertokens_expiry ON tremembertokens (expires, lastused)
	</cfquery>
</cfif>

<cfset variables.dbUtility.purgeCache()>