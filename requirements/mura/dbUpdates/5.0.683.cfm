
<!--- make sure mailserver settings exists --->

<cfquery name="rsCheck">
select * from tsettings testEmail where 0=1
</cfquery>

<cfif not listFindNoCase(rsCheck.columnlist,"mailserverSMTPPort")>
<cfswitch expression="#getDbType()#">
<cfcase value="mssql">
	<cfquery>
	ALTER TABLE tsettings ADD mailserverSMTPPort [nvarchar](5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD mailserverPOPPort [nvarchar](5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD mailserverTLS [nvarchar](5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD mailserverSSL [nvarchar](5) default NULL
	</cfquery>
</cfcase>
<cfcase value="mysql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverSMTPPort varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverPOPPort varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverTLS varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverSSL varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="postgresql">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverSMTPPort varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverPOPPort varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverTLS varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverSSL varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="nuodb">
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverSMTPPort varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverPOPPort varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverTLS varchar(5) default NULL
	</cfquery>
	<cfquery>
	ALTER TABLE tsettings ADD COLUMN mailserverSSL varchar(5) default NULL
	</cfquery>
</cfcase>
<cfcase value="oracle">
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD "MAILSERVERSMTPPORT" varchar2(5)
	</cfquery>
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD "MAILSERVERPOPPORT" varchar2(5)
	</cfquery>
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD "MAILSERVERTLS" varchar2(5)
	</cfquery>
	<cfquery>
	ALTER TABLE "TSETTINGS" ADD "MAILSERVERSSL" varchar2(5)
	</cfquery>
</cfcase>
</cfswitch>
</cfif>
