<!---
<cfif variables.instance.adManager>
	<cfquery name="rsCheck">
	select * from tadcreatives  where 0=1
	</cfquery>

	<cfif not listFindNoCase(rsCheck.columnlist,"title")>
	<cfswitch expression="#getDbType()#">
	<cfcase value="mssql">
		<cfquery>
		ALTER TABLE tadcreatives ADD title [nvarchar](200) default NULL
		</cfquery>
		<cfquery>
		ALTER TABLE tadcreatives ADD linktitle [nvarchar](100) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="mysql">
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN title varchar(200) default NULL
		</cfquery>
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN linktitle varchar(100) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="postgresql">
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN title varchar(200) default NULL
		</cfquery>
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN linktitle varchar(100) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="nuodb">
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN title varchar(200) default NULL
		</cfquery>
		<cfquery>
		ALTER TABLE tadcreatives ADD COLUMN linktitle varchar(100) default NULL
		</cfquery>
	</cfcase>
	<cfcase value="oracle">
		<cfquery>
		ALTER TABLE "TADCREATIVES" ADD "TITLE" varchar2(200)
		</cfquery>
		<cfquery>
		ALTER TABLE "TADCREATIVES" ADD "LINKTITLE" varchar2(100)
		</cfquery>
	</cfcase>
	</cfswitch>
	</cfif>
</cfif>
--->
