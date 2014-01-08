<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tmailinglistmembers  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"created")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tmailinglistmembers ADD created [datetime] NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tmailinglistmembers ADD COLUMN created datetime default NULL
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tmailinglistmembers ADD  created datetime default NULL
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tmailinglistmembers ADD created timestamp NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tmailinglistmembers ADD COLUMN created timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TMAILINGLISTMEMBERS" ADD "CREATED" DATE default null
	</cfquery>
</cfcase>

</cfswitch>

</cfif>

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tclassextenddata  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"datetimevalue")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD datetimevalue [datetime] default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD numericvalue [float] default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD stringvalue [nvarchar](255) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_date1] ON [dbo].[tclassextenddata]([datetimevalue]) ON [PRIMARY]
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_numeric1] ON [dbo].[tclassextenddata]([numericvalue]) ON [PRIMARY]
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_string1] ON [dbo].[tclassextenddata]([stringvalue]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN datetimevalue datetime default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN numericvalue float default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN stringvalue varchar(255) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_date1 ON tclassextenddata (datetimevalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_numeric1 ON tclassextenddata (numericvalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_string1 ON tclassextenddata (stringvalue)
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddata ADD  datetimevalue datetime default NULL
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddata ADD  numericvalue real default NULL
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddata ADD COLUMN stringvalue varchar(255) default NULL
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_date1 ON tclassextenddata (datetimevalue)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_numeric1 ON tclassextenddata (numericvalue)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_string1 ON tclassextenddata (stringvalue)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN datetimevalue timestamp default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN numericvalue real default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN stringvalue varchar(255) default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_date1 ON tclassextenddata (datetimevalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_numeric1 ON tclassextenddata (numericvalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_string1 ON tclassextenddata (stringvalue)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN datetimevalue timestamp default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN numericvalue float default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD COLUMN stringvalue varchar(255) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_date1 ON tclassextenddata (datetimevalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_numeric1 ON tclassextenddata (numericvalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_string1 ON tclassextenddata (stringvalue)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD datetimevalue DATE default null
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD numericvalue NUMBER default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddata ADD stringvalue varchar2(255) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_DATE1" ON tclassextenddata (datetimevalue) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_NUMERIC1" ON tclassextenddata (numericvalue) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_STRING1" ON tclassextenddata (stringvalue) 
	</cfquery>
</cfcase>

</cfswitch>
	
	<cftry>
	<cfset getClassExtensionManager().resetTypedData("Content")>
	<cfcatch></cfcatch>
	</cftry>

</cfif>

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tclassextenddatauseractivity  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"datetimevalue")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD datetimevalue [datetime] default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD numericvalue [float] default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD stringvalue [nvarchar](255) NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_date2] ON [dbo].[tclassextenddatauseractivity]([datetimevalue]) ON [PRIMARY]
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_numeric2] ON [dbo].[tclassextenddatauseractivity]([numericvalue]) ON [PRIMARY]
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX [IX_extend_string2] ON [dbo].[tclassextenddatauseractivity]([stringvalue]) ON [PRIMARY]
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN datetimevalue datetime default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN numericvalue float default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN stringvalue varchar(255) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_date2 ON tclassextenddatauseractivity (datetimevalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_numeric2 ON tclassextenddatauseractivity (numericvalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_string2 ON tclassextenddatauseractivity (stringvalue)
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddatauseractivity ADD  datetimevalue datetime default NULL
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddatauseractivity ADD  numericvalue real default NULL
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tclassextenddatauseractivity ADD COLUMN stringvalue varchar(255) default NULL
			</cfquery>
			
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_date2 ON tclassextenddatauseractivity (datetimevalue)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_numeric2 ON tclassextenddatauseractivity (numericvalue)
			</cfquery>
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE INDEX IX_extend_string2 ON tclassextenddatauseractivity (stringvalue)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN datetimevalue timestamp default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN numericvalue real default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN stringvalue varchar(255) default NULL
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_date2 ON tclassextenddatauseractivity (datetimevalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_numeric2 ON tclassextenddatauseractivity (numericvalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_string2 ON tclassextenddatauseractivity (stringvalue)
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN datetimevalue timestamp default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN numericvalue float default NULL
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD COLUMN stringvalue varchar(255) default NULL
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_date2 ON tclassextenddatauseractivity (datetimevalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_numeric2 ON tclassextenddatauseractivity (numericvalue)
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX IX_extend_string2 ON tclassextenddatauseractivity (stringvalue)
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD datetimevalue DATE default null
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD numericvalue NUMBER default null
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tclassextenddatauseractivity ADD stringvalue varchar2(255)
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_DATE2" ON tclassextenddatauseractivity (datetimevalue) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_NUMERIC2" ON tclassextenddatauseractivity (numericvalue) 
	</cfquery>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE INDEX "IDX_EXTEND_STRING2" ON tclassextenddatauseractivity (stringvalue) 
	</cfquery>
</cfcase>

</cfswitch>

	<cftry>
	<cfset getClassExtensionManager().resetTypedData("User")>
	<cfcatch></cfcatch>
	</cftry>
</cfif>
