<!--- make sure tadcreatives.target exists --->

<cfquery name="rsCheck">
select * from tplugindisplayobjects  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"displaymethod")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD displaymethod [nvarchar](100) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD COLUMN displaymethod varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD COLUMN displaymethod varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD COLUMN displaymethod varchar(100) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TPLUGINDISPLAYOBJECTS" ADD "DISPLAYMETHOD" varchar2(100)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfquery name="rsCheck">
select * from tplugindisplayobjects where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"docache")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD docache [nvarchar](5) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD COLUMN docache varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD COLUMN docache varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tplugindisplayobjects ADD COLUMN docache varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TPLUGINDISPLAYOBJECTS" ADD "DOCACHE" varchar2(5)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tplugindisplayobjects set docache='false'
</cfquery>
</cfif>

<cfquery name="rsCheck">
select * from tpluginscripts  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"docache")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tpluginscripts ADD docache [nvarchar](5) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tpluginscripts ADD COLUMN docache varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tpluginscripts ADD COLUMN docache varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tpluginscripts ADD COLUMN docache varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TPLUGINSCRIPTS" ADD "DOCACHE" varchar2(5)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery>
	update tpluginscripts set docache='false'
</cfquery>
</cfif>

<cfquery name="rsCheck">
select * from tcontent  where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"created")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tcontent ADD created [datetime] NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN created datetime default NULL
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery>
			ALTER TABLE tcontent ADD  created datetime default NULL
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN created timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN created timestamp default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TCONTENT" ADD "CREATED" DATE default null
	</cfquery>
</cfcase>

</cfswitch>

<cfquery>
	update tcontent set created=lastupdate
</cfquery>
</cfif>


