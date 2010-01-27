<cftry>
	<cffile action="write" file="#baseDir#/config/mappings.cfm" output="<!--- Add Custom Mappings Here --->" addnewline="true" mode="775">
	<cfcatch>
		<cfset canWriteMode="false">
		<cftry>
			<cffile action="write" file="#baseDir#/config/mappings.cfm" output="<!--- Add Custom Mappings Here --->" addnewline="true">
			<cfcatch>
				<cfset canWriteMappings=false>
			</cfcatch>
		</cftry>
	</cfcatch>
</cftry>
			
<cfdirectory action="list" directory="#baseDir#/requirements/" name="rsRequirements">
				
<cfloop query="rsRequirements">
	<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
		<cfif canWriteMappings>
			<cffile action="append" file="#baseDir#/config/mappings.cfm" output='<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & BaseDir & "/requirements/#rsRequirements.name#">' mode="775">	
		<cfelseif canWriteMappings>
			<cffile action="append" file="#baseDir#/config/mappings.cfm" output='<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & BaseDir & "/requirements/#rsRequirements.name#">'>	
		</cfif>
		<cfset this.mappings["/#rsRequirements.name#"] = mapPrefix & rsRequirements.directory & "/" & rsRequirements.name>
	</cfif>
</cfloop>	