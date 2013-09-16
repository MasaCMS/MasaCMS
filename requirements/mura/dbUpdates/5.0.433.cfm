<!--- make sure tsettings.useDefaultSMTPServer exists --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tsettings where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"useDefaultSMTPServer")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tsettings ADD useDefaultSMTPServer tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN useDefaultSMTPServer tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tsettings ADD useDefaultSMTPServer tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tsettings ADD COLUMN useDefaultSMTPServer smallint
	</cfquery>
</cfcase>
<cfcase value="nuodb">
<cfset dbUtility.addColumn(column='useDefaultSMTPServer',datatype='tinyint',default=0,table='tsettings')>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tsettings ADD useDefaultSMTPServer NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>
</cfif>


