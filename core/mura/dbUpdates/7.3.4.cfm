<cfquery name="rscheck">
select siteID from tsettings where siteID not in (select siteID from tsystemobjects where object='category_nav')
</cfquery>

<cfloop query="rscheck">
	<cfquery >
		INSERT INTO tsystemobjects (Object,SiteID,Name,OrderNo) 
		VALUES (
		'category_nav',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rscheck.siteID#">,
		'Category Navigation',
		24)
	</cfquery>

</cfloop>