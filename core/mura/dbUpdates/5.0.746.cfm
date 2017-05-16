<!--- make sure tadcreatives.target exists --->
<!---
<cfif variables.instance.adManager>
	<cfquery name="rsCheck">
	select * from tadcreatives testTarget where 0=1
	</cfquery>

	<cfif not listFindNoCase(rsCheck.columnlist,"target")>
	<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery>
		ALTER TABLE tadcreatives ADD target [nvarchar](10) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN target varchar(10) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN target varchar(10) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="nuodb">
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN target varchar(10) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery>
		ALTER TABLE "TADCREATIVES" ADD "TARGET" varchar2(10)
		</cfquery>
	</cfcase>
	</cfswitch>

	<cfquery>
	update tadcreatives set target='_blank'
	</cfquery>
	</cfif>
</cfif>
--->

<!--- make sure tcontentcomment.subscribe exists --->

<cfquery name="rsCheck">
select * from tcontentcomments testSubscribe where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"subscribe")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery>
ALTER TABLE tcontentcomments ADD subscribe tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN subscribe tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery>
			ALTER TABLE tcontentcomments ADD subscribe tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN subscribe smallint
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontentcomments ADD COLUMN subscribe smallint 
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery>
ALTER TABLE tcontentcomments ADD subscribe NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>
</cfif>

<cfset dbUtility.setTable("tcontentfeeds").addColumn(column="altname",dataType="varchar",length="250")>

<!--- make sure tcontentcomment.cacheItem exists --->
<cfquery name="rsCheck">
select * from tcontent testDoCache where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"doCache")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
<cfquery>
ALTER TABLE tcontent ADD doCache tinyint 
</cfquery>
</cfcase>
<cfcase value="mysql">
	<cftry>
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN doCache tinyint(3) 
	</cfquery>
	<cfcatch>
			<!--- H2 --->
			<cfquery>
			ALTER TABLE tcontent ADD doCache tinyint(3)
			</cfquery>
		</cfcatch>
	</cftry>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN doCache smallint
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tcontent ADD COLUMN doCache smallint
	</cfquery>
</cfcase>
<cfcase value="oracle">
<cfquery>
ALTER TABLE tcontent ADD doCache NUMBER(3,0)
</cfquery>
</cfcase>
</cfswitch>
</cfif>


