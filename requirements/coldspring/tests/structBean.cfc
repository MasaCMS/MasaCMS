
<cfcomponent name="structBean">

	<cffunction name="init" access="public" returntype="coldspring.tests.structBean">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setData" access="public">
		<cfargument name="data" type="struct" required="true" />
		<cfset this.data = arguments.data />
	</cffunction>
	
	<cffunction name="getData" access="public" returntype="struct">
		<cfreturn this.data />
	</cffunction>
	
</cfcomponent>