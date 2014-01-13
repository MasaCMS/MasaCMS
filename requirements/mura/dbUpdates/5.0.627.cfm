<cfif getDbType() eq "mysql">
<cfset variables.DOUPDATE=false/>
<cftransaction>
<cftry>
<cfquery name="rsCheck">
	SELECT DATA_TYPE
			FROM information_schema.COLUMNS
			WHERE TABLE_SCHEMA = Database() AND TABLE_NAME = 'tsessiontracking'
			and COLUMN_NAME='referer'
      ORDER BY ORDINAL_POSITION
</cfquery>

<cfif rsCheck.DATA_TYPE eq "mediumtext">
	<cfset variables.DOUPDATE=true/>
</cfif>

<cfcatch>
<cfquery name="rsCheck">
explain tsessiontracking
</cfquery>
<cfquery name="rsCheck" dbType="query">
select type from rsCheck where Field='referer'
</cfquery>

<cfif rsCheck.type eq "mediumtext">
	<cfset variables.DOUPDATE=true/>
</cfif>
</cfcatch>
</cftry>

<cfif variables.DOUPDATE>


	<cfquery>
	ALTER TABLE tsessiontracking ADD COLUMN referer2 varchar(255) character set utf8 default NULL
	</cfquery>
	
	<cfquery>
	UPDATE tsessiontracking SET referer2=left(referer,255)
	</cfquery>
	
	<cfquery>
	ALTER TABLE tsessiontracking DROP Column referer
	</cfquery>
	
	<cfquery>
	ALTER TABLE tsessiontracking ADD COLUMN referer varchar(255) character set utf8 default NULL
	</cfquery>
	
	<cfquery>
	UPDATE tsessiontracking SET referer=referer2
	</cfquery>
	
	<cfquery>
	ALTER TABLE tsessiontracking DROP Column referer2
	</cfquery>
	
</cfif>

</cftransaction>

</cfif>