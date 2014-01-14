<cfquery name="rscheck">
select siteID from tsettings where siteID not in (select siteID from tsystemobjects where object='multilevel_nav')
</cfquery>

<cfloop query="rscheck">
	<cfquery >
		INSERT INTO tsystemobjects (Object,SiteID,Name,OrderNo) 
		VALUES (
		'multilevel_nav',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rscheck.siteID#">,
		'Multi-Level Navigation',
		7)
	</cfquery>

</cfloop>