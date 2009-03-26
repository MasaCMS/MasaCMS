
<cfcomponent name="stringBean">

	<cffunction name="init" access="public" returntype="coldspring.tests.stringBean">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setMessage" access="public">
		<cfargument name="message" type="string" required="true" />
		<cfset this.message = arguments.message />
	</cffunction>
	
	<cffunction name="getMessage" access="public" returntype="string">
		<cfreturn this.message />
	</cffunction>
	
</cfcomponent>