<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cftransaction>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tplugins]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tplugins] ( 
	  [pluginID] [int] IDENTITY (1, 1) NOT NULL,
	  [moduleID] [char](35) default NULL,
	  [name] [nvarchar](50) default NULL,
	  [created] [datetime] NOT NULL ,
	  [provider] [nvarchar](100) default NULL,
	  [providerURL] [nvarchar](100) default NULL,
	  [category] [nvarchar](50) default NULL,
	  [version] [nvarchar](50) default NULL,
	  [deployed] [tinyint] default NULL
) on [PRIMARY]
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT 1
				FROM sysindexes
				WHERE id = object_id(N'[dbo].[tplugins]') 
				AND status & 2048 = 2048 )
ALTER TABLE [dbo].[tplugins] WITH NOCHECK ADD 
	CONSTRAINT [PK_tplugins_pluginID] PRIMARY KEY  CLUSTERED 
	(
		[pluginID]
	)  ON [PRIMARY] 
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tplugindisplayobjects]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tplugindisplayobjects] (
	  [objectID] [char](35) NOT NULL default '',
	  [moduleID] [char](35) default NULL,
	  [name] [nvarchar](50) default NULL,
	  [location] [nvarchar](50) default NULL,
	  [displayObjectFile] [nvarchar](200) default NULL
	) on [PRIMARY]
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT 1
				FROM sysindexes
				WHERE id = object_id(N'[dbo].[tplugindisplayobjects]') 
				AND status & 2048 = 2048 )
ALTER TABLE [dbo].[tplugindisplayobjects] WITH NOCHECK ADD 
	CONSTRAINT [PK_tplugindisplayobjects_objectID] PRIMARY KEY  CLUSTERED 
	(
		[objectID]
	)  ON [PRIMARY] 
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tpluginscripts]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tpluginscripts] (
	  [scriptID] [char](35) NOT NULL default '',
	  [moduleID] [char](35) default NULL,
	  [runat] [nvarchar](50) default NULL,
	  [scriptfile] [nvarchar](200) default NULL
	) on [PRIMARY]
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT 1
				FROM sysindexes
				WHERE id = object_id(N'[dbo].[tpluginscripts]') 
				AND status & 2048 = 2048 )
ALTER TABLE [dbo].[tpluginscripts] WITH NOCHECK ADD 
	CONSTRAINT [PK_tpluginscripts_scriptID] PRIMARY KEY  CLUSTERED 
	(
		[scriptID]
	)  ON [PRIMARY] 
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tpluginsettings]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tpluginsettings] (
	  [moduleID] [char](35) NOT NULL default '',
	  [name] [nvarchar](100) NOT NULL default '',
	  [settingValue] #MSSQLlob#
	) on [PRIMARY]
</cfquery>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
IF NOT EXISTS (SELECT 1
				FROM sysindexes
				WHERE id = object_id(N'[dbo].[tpluginsettings]') 
				AND status & 2048 = 2048 )
ALTER TABLE [dbo].[tpluginsettings] WITH NOCHECK ADD 
	CONSTRAINT [PK_tpluginsettings_ID] PRIMARY KEY  CLUSTERED 
	(
		[moduleID],
		[name]
	)  ON [PRIMARY] 
</cfquery>
</cftransaction>
</cfcase>
<cfcase value="mysql">
	<cfset variables.RUNDBUPDATE=false/>
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	select pluginID as CheckIfTableExists from tplugins limit 1
	</cfquery>
	<cfcatch>
	<cfset variables.RUNDBUPDATE=true/>
	</cfcatch>
	</cftry>
	
	<cfif variables.RUNDBUPDATE>
	<cftry>
	<cftransaction>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE TABLE IF NOT EXISTS  `tplugins` (
	  `pluginID` int(11) NOT NULL auto_increment,
	  `moduleID` char(35) default NULL,
	  `name` varchar(50) default NULL,
	  `created` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	  `provider` varchar(100) default NULL,
	  `providerURL` varchar(100) default NULL,
	  `category` varchar(50) default NULL,
	  `version` varchar(50) default NULL,
	  `deployed` tinyint(3) default NULL,
	  PRIMARY KEY  (`pluginID`)
	) ENGINE=#variables.instance.MYSQLEngine# AUTO_INCREMENT=16 DEFAULT CHARSET=utf8
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS `tplugindisplayobjects` (
	  `objectID` char(35) NOT NULL default '',
	  `moduleID` char(35) default NULL,
	  `name` varchar(50) default NULL,
	  `location` varchar(50) default NULL,
	  `displayObjectFile` varchar(200) default NULL,
	  PRIMARY KEY  (`objectID`)
	) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS `tpluginscripts` (
	  `scriptID` char(35) NOT NULL default '',
	  `moduleID` char(35) default NULL,
	  `runat` varchar(50) default NULL,
	  `scriptfile` varchar(200) default NULL,
	  PRIMARY KEY  (`scriptID`)
	) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS `tpluginsettings` (
	  `moduleID` char(35) NOT NULL default '',
	  `name` varchar(100) NOT NULL default '',
	  `settingValue` longtext,
	  PRIMARY KEY  (`moduleID`,`name`)
	) ENGINE=#variables.instance.MYSQLEngine# DEFAULT CHARSET=utf8
	</cfquery>
	</cftransaction>
	<cfcatch>
		<cftransaction>
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS  `tplugins` (
		  `pluginID` INTEGER NOT NULL AUTO_INCREMENT,
		  `moduleID` char(35) default NULL,
		  `name` varchar(50) default NULL,
		  `created` datetime default NULL,
		  `provider` varchar(100) default NULL,
		  `providerURL` varchar(100) default NULL,
		  `category` varchar(50) default NULL,
		  `version` varchar(50) default NULL,
		  `deployed` tinyint(3) default NULL,
		  PRIMARY KEY  (`pluginID`)
		) 
		</cfquery>
	
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE TABLE IF NOT EXISTS `tplugindisplayobjects` (
		  `objectID` char(35) NOT NULL default '',
		  `moduleID` char(35) default NULL,
		  `name` varchar(50) default NULL,
		  `location` varchar(50) default NULL,
		  `displayObjectFile` varchar(200) default NULL,
		  PRIMARY KEY  (`objectID`)
		) 
		</cfquery>
	
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE TABLE IF NOT EXISTS `tpluginscripts` (
		  `scriptID` char(35) NOT NULL default '',
		  `moduleID` char(35) default NULL,
		  `runat` varchar(50) default NULL,
		  `scriptfile` varchar(200) default NULL,
		  PRIMARY KEY  (`scriptID`)
		) 
		</cfquery>
	
		<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			CREATE TABLE IF NOT EXISTS `tpluginsettings` (
		  `moduleID` char(35) NOT NULL default '',
		  `name` varchar(100) NOT NULL default '',
		  `settingValue` longtext,
		  PRIMARY KEY  (`moduleID`,`name`)
		) 
		</cfquery>
		</cftransaction>
	</cfcatch>
	</cftry>
	</cfif>
</cfcase>

<cfcase value="postgresql">
	<cftransaction>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS tplugins (
			pluginID SERIAL,
			moduleID char(35),
			name varchar(50),
			created timestamp NOT NULL ,
			provider varchar(100),
			providerURL varchar(100),
			category varchar(50),
			version varchar(50),
			deployed smallint,
			CONSTRAINT PK_tplugins_pluginID PRIMARY KEY (pluginID)
		)
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS tplugindisplayobjects (
			objectID char(35) NOT NULL default '',
			moduleID char(35),
			name varchar(50),
			location varchar(50),
			displayObjectFile varchar(200),
			CONSTRAINT PK_tplugindisplayobjects_objectID PRIMARY KEY (objectID)
		)
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS tpluginscripts (
			scriptID char(35) NOT NULL default '',
			moduleID char(35),
			runat varchar(50),
			scriptfile varchar(200),
			CONSTRAINT PK_tpluginscripts_scriptID PRIMARY KEY (scriptID)
		)
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE IF NOT EXISTS tpluginsettings (
			moduleID char(35) NOT NULL default '',
			name varchar(100) NOT NULL default '',
			settingValue text,
			CONSTRAINT PK_tpluginsettings_ID PRIMARY KEY (moduleID, name)
		)
	</cfquery>

	</cftransaction>
</cfcase>

<cfcase value="nuodb">
	<cftransaction>
	<cfif not dbUtility.tableExists('tplugins')>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE TABLE tplugins (
	  pluginID integer generated always as identity (seq_tplugins),
	  moduleID char(35) default NULL,
	  name varchar(50) default NULL,
	  created timestamp NOT NULL default ('now'),
	  provider varchar(100) default NULL,
	  providerURL varchar(100) default NULL,
	  category varchar(50) default NULL,
	  version varchar(50) default NULL,
	  deployed smallint default NULL,
	  PRIMARY KEY  (pluginID)
	)
	</cfquery>
	</cfif>
	
	<cfif not dbUtility.tableExists('tplugindisplayobjects')>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE  tplugindisplayobjects (
	  objectID char(35) NOT NULL default '',
	  moduleID char(35) default NULL,
	  name varchar(50) default NULL,
	  location varchar(50) default NULL,
	  displayObjectFile varchar(200) default NULL,
	  PRIMARY KEY  (objectID)
	) 
	</cfquery>
	</cfif>
	
	<cfif not dbUtility.tableExists('tpluginscripts')>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE tpluginscripts (
	  scriptID char(35) NOT NULL default '',
	  moduleID char(35) default NULL,
	  runat varchar(50) default NULL,
	  scriptfile varchar(200) default NULL,
	  PRIMARY KEY  (scriptID)
	) 
	</cfquery>
	</cfif>

	<cfif not dbUtility.tableExists('tpluginsettings')>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE tpluginsettings (
	  moduleID char(35) NOT NULL default '',
	  name varchar(100) NOT NULL default '',
	  settingValue clob,
	  PRIMARY KEY  (moduleID,name)
	) 
	</cfquery>
	</cfif>
	</cftransaction>
</cfcase>
<cfcase value="oracle">
<cfset variables.RUNDBUPDATE=false/>
<cftry>
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from (select pluginID as CheckIfTableExists from tplugins) where ROWNUM <=1
</cfquery>
<cfcatch>
<cfset variables.RUNDBUPDATE=true/>
</cfcatch>
</cftry>

<cfif variables.RUNDBUPDATE>
	<cftransaction>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	CREATE TABLE "TPLUGINS" (
	  "PLUGINID" NUMBER(10,0),
	  "MODULEID" CHAR(35) ,
	  "NAME" varchar2(50),
	  "CREATED" date,
	  "PROVIDER" varchar2(100),
	  "PROVIDERURL" varchar2(100),
	  "CATEGORY" varchar2(50),
	  "VERSION" varchar2(50),
	  "DEPLOYED" NUMBER(3,0)
	) 
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	 CREATE SEQUENCE  "TPLUGINS_PLUGINID_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 221 CACHE 20 NOORDER  NOCYCLE
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TPLUGINS" ADD CONSTRAINT "TPLUGINS_PRIMARY" PRIMARY KEY ("PLUGINID") ENABLE
	</cfquery>

	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	create or replace TRIGGER "TPLUGINS_PLUGINID_TRG" BEFORE INSERT ON tplugins
	FOR EACH ROW
	BEGIN
	    SELECT  tplugins_pluginID_SEQ.NEXTVAL INTO :new.pluginID FROM DUAL;
	END;
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TRIGGER "TPLUGINS_PLUGINID_TRG" ENABLE
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE "TPLUGINDISPLAYOBJECTS" (
	  "OBJECTID" CHAR(35),
	  "MODULEID" CHAR(35),
	  "NAME" varchar2(50),
	  "LOCATION" varchar2(50),
	  "DISPLAYOBJECTFILE" varchar2(200)
	) 
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TPLUGINDISPLAYOBJECTS" ADD CONSTRAINT "TPLUGINDISPLAYOBJECTS_PRIMARY" PRIMARY KEY ("OBJECTID") ENABLE
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE "TPLUGINSCRIPTS" (
	  "SCRIPTID" CHAR(35),
	  "MODULEID" CHAR(35),
	  "RUNAT" varchar2(50),
	  "SCRIPTFILE" varchar2(200)
	) 
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TPLUGINSCRIPTS" ADD CONSTRAINT "TPLUGINSCRIPTS_PRIMARY" PRIMARY KEY ("SCRIPTID") ENABLE
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
		CREATE TABLE "TPLUGINSETTINGS" (
	  "MODULEID" CHAR(35),
	  "NAME" varchar2(100),
	  "SETTINGVALUE" clob
	) 
		lob (SETTINGVALUE) STORE AS (
		TABLESPACE "#getDbTablespace()#" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
		NOCACHE LOGGING
		STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
		PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
	</cfquery>
	
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TPLUGINSETTINGS" ADD CONSTRAINT "TPLUGINSETTINGS_PRIMARY" PRIMARY KEY ("NAME","MODULEID") ENABLE
	</cfquery>
	</cftransaction>
</cfif>
</cfcase>
</cfswitch>

