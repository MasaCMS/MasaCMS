<!--- rename tcontentcomments.comment to tcontentcomments.comments --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontentcomments where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"COMMENTS")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
EXEC sp_rename 'tcontentcomments.[comment]', 'comments', 'COLUMN'
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcomments CHANGE COLUMN comment comments longtext
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontentcomments ALTER COLUMN comment RENAME TO comments 
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcomments RENAME COLUMN comment TO comments
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfset dbUtility.renameColumn(column='comment',newColumn='comments',table='tcontentcomments')>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentcomments RENAME COLUMN comment to comments
</cfquery>
</cfcase>
</cfswitch>
</cfif>


<!--- rename tclassextendaddtributes.validate to tclassextendattributes.validation --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tclassextendattributes where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"VALIDATION")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
EXEC sp_rename 'tclassextendattributes.[validate]', 'validation', 'COLUMN'
</cfquery>
</cfcase>
<cfcase value="mysql">
<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextendattributes CHANGE COLUMN validate validation varchar(50) NULL
	</cfquery>
	<cfcatch>
		<!--- H2 --->
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		ALTER TABLE tclassextendattributes ALTER COLUMN validate RENAME TO validation 
		</cfquery>
	</cfcatch>
</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextendattributes RENAME COLUMN validate TO validation
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfset dbUtility.renameColumn(column='validate',newColumn='validation',table='tclassextendattributes')>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tclassextendattributes RENAME COLUMN validate to validation
</cfquery>
</cfcase>
</cfswitch>
</cfif>