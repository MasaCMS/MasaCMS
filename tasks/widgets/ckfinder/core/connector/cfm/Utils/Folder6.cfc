<cfcomponent output="false">

<!---
 Recursively delete a directory.
 source: http://cflib.org/udf.cfm?ID=1239
--->
<cffunction name="deleteDirectory" returntype="boolean" output="false">
	<cfargument name="directory" type="string" required="yes" >
	<cfargument name="recurse" type="boolean" required="no" default="false">

	<cfset var myDirectory = "">
	<cfset var count = 0>

	<cfif right(arguments.directory, 1) is not "/">
		<cfset arguments.directory = arguments.directory & "/">
	</cfif>

	<cfdirectory action="list" directory="#arguments.directory#" name="myDirectory">

	<cfloop query="myDirectory">
		<cfif myDirectory.name is not "." AND myDirectory.name is not "..">
			<cfset count = count + 1><cfdump var="#myDirectory#">
			<cfswitch expression="#myDirectory.type#">

				<cfcase value="dir">
					<!--- If recurse is on, move down to next level --->
					<cfif arguments.recurse>
						<cfset deleteDirectory(
							arguments.directory & myDirectory.name,
							arguments.recurse )>
					</cfif>
				</cfcase>

				<cfcase value="file">
					<!--- delete file --->
					<cfif arguments.recurse>
						<cffile action="delete" file="#arguments.directory##myDirectory.name#">
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	<cfif count is 0 or arguments.recurse>
		<cfdirectory action="delete" directory="#arguments.directory#">
	</cfif>
	<cfreturn true>
</cffunction>

</cfcomponent>
