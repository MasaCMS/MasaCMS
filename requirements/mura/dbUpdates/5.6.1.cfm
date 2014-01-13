<cfset rsCheck=dbTableColumns("tsettings")>

<cfquery name="rsCheck" dbtype="query">
	select * from rsCheck where lower(rsCheck.column_name) like 'baseid'
</cfquery>

<cfif not rsCheck.recordcount>
<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery>
		ALTER TABLE tsettings ADD baseID [char](35) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cfquery>
		ALTER TABLE tsettings ADD COLUMN baseID char(35) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery>
		ALTER TABLE tsettings ADD COLUMN baseID char(35) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="nuodb">
		<cfquery>
		ALTER TABLE tsettings ADD COLUMN baseID char(35) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery>
		ALTER TABLE tsettings ADD baseID char(35)
		</cfquery>
	</cfcase>
	</cfswitch>

	<cfquery name="rsCheck">
		select siteID from tsettings
	</cfquery>

	<cfloop query="rsCheck">
		<cfquery>
		update tsettings set 
			baseID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">
		where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCheck.siteID#">
	</cfquery>
	</cfloop>
</cfif>

<cfscript>
	dbUtility.setTable("tclassextend");
	dbUtility.addColumn(column="hasSummary",datatype="tinyint",default=1);
	dbUtility.addColumn(column="hasBody",datatype="tinyint",default=1);
</cfscript>
