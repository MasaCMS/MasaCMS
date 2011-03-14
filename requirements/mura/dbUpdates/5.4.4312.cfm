<cfquery name="rscheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select siteID from tsettings where siteID not in (select siteID from tsystemobjects where object='multilevel_nav')
</cfquery>

<cfloop query="rscheck">
	<cfquery  datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		INSERT INTO tsystemobjects (Object,SiteID,Name,OrderNo) 
		VALUES (
		'multilevel_nav',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rscheck.siteID#">,
		'Multi-Level Navigation',
		7)
	</cfquery>

</cfloop>