<cfscript>
  dbUtility.dropTable(table="trazunasettings");
</cfscript>

<cfset variables.dbUtility=getBean("dbUtility")>

<cfset getBean("rememberMeToken").checkSchema()>

<cfset variables.dbUtility.purgeCache()>

<cfif not variables.dbUtility.setTable("tremembertokens").indexExists("selector")>
	<cfquery>
		CREATE UNIQUE INDEX UQ_tremembertokens_selector ON tremembertokens (selector)
	</cfquery>
</cfif>

<cfset variables.dbUtility.purgeCache()>

<cfif not variables.dbUtility.setTable("tremembertokens").indexExists("userID")>
	<cfquery>
		CREATE INDEX IX_tremembertokens_user_site ON tremembertokens (userID, siteID)
	</cfquery>
</cfif>

<cfif not variables.dbUtility.setTable("tremembertokens").indexExists("expires")>
	<cfquery>
		CREATE INDEX IX_tremembertokens_expiry ON tremembertokens (expires, lastused)
	</cfquery>
</cfif>

<cfset variables.dbUtility.purgeCache()>