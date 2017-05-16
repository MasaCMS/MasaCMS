<!--- make sure tplugins.package exists --->

<cfquery name="rsCheck">
select * from tplugins  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"package")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tplugins ADD package [nvarchar](100) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN package varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN package varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN package varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TPLUGINS" ADD "PACKAGE" varchar2(100)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>


<cfif not listFindNoCase(rsCheck.columnlist,"directory")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tplugins ADD directory [nvarchar](100) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN directory varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN directory varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tplugins ADD COLUMN directory varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TPLUGINS" ADD "DIRECTORY" varchar2(100)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tplugins set directory=pluginID
</cfquery>

</cfif>

