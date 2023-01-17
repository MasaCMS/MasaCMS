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

<cfquery name="rscheck">
select siteID from tsettings where siteID not in (select siteID from tsystemobjects where object='primary_nav')
</cfquery>

<cfloop query="rscheck">
	<cfquery >
		INSERT INTO tsystemobjects (Object,SiteID,Name,OrderNo) 
		VALUES (
		'primary_nav',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rscheck.siteID#">,
		'Primary Navigation',
		24)
	</cfquery>
</cfloop>

<cfquery name="rscheck">
select siteID from tsettings where siteID not in (select siteID from tcontentobjects where object='primary_nav')
</cfquery>

<cfloop query="rscheck">
	<cfquery >
		INSERT INTO tcontentobjects (ContentHistID, ObjectID, Object, ContentID, Name, OrderNo, SiteID, ColumnID, Params) 
		VALUES (
			'#createUUID()#',
			'#createUUID()#',
			'primary_nav',
			'#createUUID()#',
			'Primary Navigation',
			'1',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rscheck.siteID#">,
			'1',
			'{\"objecticonclass\":\"mi-cog\",\"objectname\":\"<i class=\\\"mi-align-justify\\\"></i>Primary Navigation\",\"render\":\"server\",\"object\":\"primary_nav\"}'
		)
	</cfquery>
</cfloop>
