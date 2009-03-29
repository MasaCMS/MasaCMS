<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select count(*) counter from tcontent where path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%'%">
</cfquery>

<cfif rsCheck.counter>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		update tcontent set path=replace(path,<cfqueryparam cfsqltype="cf_sql_varchar" value="'">,'')
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		update tcontentcategories set path=replace(path,<cfqueryparam cfsqltype="cf_sql_varchar" value="'">,'')
	</cfquery>
</cfif>