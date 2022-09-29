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
			'F2C27B9E-6AD9-442A-BC2F04D2FFA95D4D',
			'C860E969-BF07-4224-B4B57947C7E2C98A',
			'primary_nav',
			'C860E969-BF07-4224-B4B57947C7E2C98A',
			'Primary Navigation',
			'1',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rscheck.siteID#">,
			'1',
			'{\"objecticonclass\":\"mi-cog\",\"objectname\":\"<i class=\\\"mi-align-justify\\\"></i>Primary Navigation\",\"render\":\"server\",\"object\":\"primary_nav\"}'
		)
	</cfquery>
</cfloop>
