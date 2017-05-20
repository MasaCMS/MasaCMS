<cfcomponent output="false">

<cffunction name="deleteDirectory" returntype="boolean" output="false">
	<cfargument name="directory" type="string" required="yes" >
	<cfargument name="recurse" type="boolean" required="no" default="false">

	<cftry>
	<cfdirectory action="delete" directory="#ARGUMENTS.directory#" recurse="#ARGUMENTS.recurse#" />
	<cfcatch type="any">
		<cfreturn false>
	</cfcatch>
	</cftry>

	<cfreturn true>
</cffunction>

</cfcomponent>
