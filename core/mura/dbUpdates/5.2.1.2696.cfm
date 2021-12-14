<cfset variables.DOUPDATE=false>
<cftry>
	<cfquery name="rsCheck">
	select remoteID from tclassextenddatauseractivity  where 0=1
	</cfquery>
<cfcatch>
	<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
	<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery>
		ALTER TABLE [dbo].[tclassextenddatauseractivity] ADD remoteID [nvarchar](35) NULL
		</cfquery>
		
		<cfquery>
		CREATE INDEX [IX_extend_remotID2] ON [dbo].[tclassextenddatauseractivity]([remoteID]) ON [PRIMARY]
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cftry>
		<cfquery>
		ALTER TABLE tclassextenddatauseractivity ADD COLUMN remoteID varchar(35) default NULL
		</cfquery>
		
		<cfquery>
		CREATE INDEX IX_extend_remote2 ON tclassextenddatauseractivity (remoteID)
		</cfquery>
		<cfcatch>
				<!--- H2 --->
				<cfquery>
				ALTER TABLE tclassextenddatauseractivity ADD COLUMN remoteID varchar(35) default NULL
				</cfquery>
				
				<cfquery>
				CREATE INDEX IX_extend_remoteID2 ON tclassextenddatauseractivity (remoteID)
				</cfquery>
			</cfcatch>
		</cftry>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery>
		ALTER TABLE tclassextenddatauseractivity ADD COLUMN remoteID varchar(35) NULL
		</cfquery>

		<cfquery>
		CREATE INDEX IX_extend_remotID2 ON tclassextenddatauseractivity(remoteID)
		</cfquery>
	</cfcase>
	<cfcase value="nuodb">
		<cfquery>
		ALTER TABLE tclassextenddatauseractivity ADD Column remoteID varchar(35) NULL
		</cfquery>

		<cfquery>
		CREATE INDEX IX_extend_remotID2 ON tclassextenddatauseractivity (remoteID)
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery>
		ALTER TABLE tclassextenddatauseractivity ADD remoteID varchar2(35)
		</cfquery>
		
		<cfquery>
		CREATE INDEX "IDX_EXTEND_REMOTEID2" ON tclassextenddatauseractivity (remoteID) 
		</cfquery>
	</cfcase>

	</cfswitch>
</cfif>

<cfset variables.DOUPDATE=false>
<cftry>
	<cfquery name="rsCheck">
	select remoteID from tclassextenddata where 0=1
	</cfquery>
<cfcatch>
	<cfset variables.DOUPDATE=true>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>
	<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery>
		ALTER TABLE [dbo].[tclassextenddata] ADD remoteID [nvarchar](35) NULL
		</cfquery>
		<cfquery>
		CREATE INDEX [IX_extend_remotID1] ON [dbo].[tclassextenddata]([remoteID]) ON [PRIMARY]
		</cfquery>	
		<cfquery>
		CREATE INDEX [IX_extend_attr_name] ON [dbo].[tclassextendattributes]([name]) ON [PRIMARY]
		</cfquery>
		<cfquery>
		CREATE INDEX [IX_extend_type] ON [dbo].[tclassextend]([type],[subtype]) ON [PRIMARY]
		</cfquery>
		<cfquery>
		CREATE INDEX [IX_extend_siteID] ON [dbo].[tclassextend]([siteID]) ON [PRIMARY]
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cftry>
		<cfquery>
		ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
		</cfquery>
		<cfcatch>
				<!--- H2 --->
				<cfquery>
				ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
				</cfquery>
				<cfquery>
				CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
				</cfquery>
				<cfquery>
				CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
				</cfquery>
				<cfquery>
				CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
				</cfquery>
				<cfquery>
				CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
				</cfquery>
			</cfcatch>
		</cftry>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery>
		ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
		</cfquery>
	</cfcase>
	<cfcase value="nuodb">
		<cfquery>
		ALTER TABLE tclassextenddata ADD COLUMN remoteID varchar(35) default NULL
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_remoteID1 ON tclassextenddata (remoteID)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_attr_name ON tclassextendattributes (name)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_type ON tclassextend (type,subtype)
		</cfquery>
		<cfquery>
		CREATE INDEX IX_extend_siteID ON tclassextend (siteID)
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery>
		ALTER TABLE tclassextenddata ADD remoteID varchar2(35)
		</cfquery>	
		<cfquery>
		CREATE INDEX "IDX_EXTEND_REMOTEID1" ON tclassextenddata (remoteID) 
		</cfquery>
		<cfquery>
		CREATE INDEX "IDX_EXTEND_ATTR_NAME" ON tclassextendattributes (name) 
		</cfquery>
		<cfquery>
		CREATE INDEX "IDX_EXTEND_TYPE" ON tclassextend (type,subtype) 
		</cfquery>
		<cfquery>
		CREATE INDEX "IDX_EXTEND_SITEID" ON tclassextend (siteID) 
		</cfquery>
	</cfcase>

	</cfswitch>
</cfif>