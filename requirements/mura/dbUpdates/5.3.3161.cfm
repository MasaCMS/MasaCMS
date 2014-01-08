<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontent where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"mobileExclude")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontent ADD mobileExclude tinyint 
</cfquery>
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
CREATE INDEX [IX_tcontent_mobileExclude] ON [dbo].[tcontent]([mobileExclude]) ON [PRIMARY]
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN mobileExclude tinyint(3) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_tcontent_mobileExclude ON tcontent (mobileExclude)
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontent ADD mobileExclude tinyint(3)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE IX_tcontent_mobileExclude ON tcontent (mobileExclude)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD mobileExclude smallint
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_tcontent_mobileExclude ON tcontent(mobileExclude)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN mobileExclude smallint
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_tcontent_mobileExclude ON tcontent (mobileExclude)
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontent ADD mobileExclude NUMBER(3,0)
</cfquery>
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
CREATE INDEX "IDX_TCONTENT_MOBILEEXCLUDE" ON tcontent (mobileExclude) 
</cfquery>
</cfcase>
</cfswitch>
<!---
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
update tcontent set mobileExclude=0
where mobileExclude is null
</cfquery>
--->
</cfif>
