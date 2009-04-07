<!--- make sure tadcreatives.target exists --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tplugindisplayobjects testdisplaymethod where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"displaymethod")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD displaymethod [nvarchar](50) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tplugindisplayobjects ADD COLUMN displaymethod varchar(50) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TPLUGINDISPLAYOBJECTS" ADD "DISPLAYMETHOD" varchar2(50)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>


