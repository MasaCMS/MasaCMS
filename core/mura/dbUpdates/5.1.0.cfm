<cfquery name="rsCheck">
select count(*) counter from tcontent where path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%'%">
</cfquery>

<cfif rsCheck.counter>
	<cfswitch expression="#getDbType()#">
		<cfcase value="mssql">
			<cfquery>
				update tcontent set path=replace(Cast(path as varchar(1000)),<cfqueryparam cfsqltype="cf_sql_varchar" value="'">,'')
			</cfquery>
			<cfquery>
				update tcontentcategories set path=replace(Cast(path as varchar(1000)),<cfqueryparam cfsqltype="cf_sql_varchar" value="'">,'')
			</cfquery>
		</cfcase>
		<cfcase value="mysql,oracle,postgresql">
			<cfquery>
				update tcontent set path=replace(path,<cfqueryparam cfsqltype="cf_sql_varchar" value="'">,'')
			</cfquery>
			<cfquery>
				update tcontentcategories set path=replace(path,<cfqueryparam cfsqltype="cf_sql_varchar" value="'">,'')
			</cfquery>
		</cfcase>
	</cfswitch>
	
</cfif>
