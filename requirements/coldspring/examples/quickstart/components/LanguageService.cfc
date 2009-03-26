<cfcomponent name="Language Service" output="false">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="reverseString" access="public" returntype="string" output="false">
		<cfargument name="string" type="string" required="true" />
		<cfreturn Reverse(arguments.string) />
	</cffunction>

	<cffunction name="duplicateString" access="public" returntype="string" output="false">
		<cfargument name="string" type="string" required="true" />
		<cfargument name="numberOfDuplicates" type="numeric" required="true" />
		<cfreturn RepeatString(arguments.string, arguments.numberOfDuplicates) />
	</cffunction>
	
	<cffunction name="capitalizeString" access="public" returntype="string" output="false">
		<cfargument name="string" type="string" required="true" />
		<cfreturn Ucase(arguments.string) />
	</cffunction>

</cfcomponent>