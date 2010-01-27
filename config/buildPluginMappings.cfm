<cftry>
		<cffile action="write" file="#baseDir#/plugins/mappings.cfm" output="<!--- Do Not Edit --->" addnewline="true" mode="775">
		<cfcatch>
			<cfset canWriteMode=false>
			<cftry>
				<cffile action="write" file="#baseDir#/plugins/mappings.cfm" output="<!--- Do Not Edit --->" addnewline="true">
				<cfcatch>
					<cfset canWriteMappings=false>
				</cfcatch>
			</cftry>
		</cfcatch>
</cftry>
				
<cfdirectory action="list" directory="#baseDir#/plugins/" name="rsRequirements">
				
<cfloop query="rsRequirements">
	<cfif rsRequirements.type eq "dir" and rsRequirements.name neq '.svn'>
		<cfset m=listFirst(rsRequirements.name,"_")>
		<cfif not isNumeric(m) and not structKeyExists(this.mappings,m)>
			<cfif canWriteMode>
				<cffile action="append" file="#baseDir#/plugins/mappings.cfm" output='<cfset this.mappings["/#m#"] = mapPrefix & BaseDir & "/plugins/#rsRequirements.name#">' mode="775">
			<cfelseif canWriteMappings>
				<cffile action="append" file="#baseDir#/plugins/mappings.cfm" output='<cfset this.mappings["/#m#"] = mapPrefix & BaseDir & "/plugins/#rsRequirements.name#">'>		
			</cfif>
			<cfset this.mappings["/#m#"] = mapPrefix & rsRequirements.directory & "/" & rsRequirements.name>
		</cfif>
	</cfif>
</cfloop>
</cfif>