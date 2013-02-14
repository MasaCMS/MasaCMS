<!--- make sure tadcreatives.target exists --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tadcreatives testTarget where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"target")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadcreatives ADD target [nvarchar](10) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadcreatives ADD COLUMN target varchar(10) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tadcreatives ADD COLUMN target varchar(10) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE "TADCREATIVES" ADD "TARGET" varchar2(10)
	</cfquery>
</cfcase>
</cfswitch>

<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
update tadcreatives set target='_blank'
</cfquery>
</cfif>

<!--- make sure tcontentcomment.subscribe exists --->

<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontentcomments testSubscribe where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"subscribe")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentcomments ADD subscribe tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcomments ADD COLUMN subscribe tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontentcomments ADD subscribe tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontentcomments ADD COLUMN subscribe smallint 
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontentcomments ADD subscribe NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset dbUtility.setTable("tcontentfeeds").addColumn(column="altname",dataType="varchar",length="250")>

<!--- make sure tcontentcomment.cacheItem exists --->
<cfquery name="rsCheck" datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
select * from tcontent testDoCache where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"doCache")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontent ADD doCache tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN doCache tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
			ALTER TABLE tcontent ADD doCache tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="nuodb">
	<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
	ALTER TABLE tcontent ADD COLUMN doCache smallint
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery datasource="#getDatasource()#" username="#getDBUsername()#" password="#getDbPassword()#">
ALTER TABLE tcontent ADD doCache NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>
</cfif>


