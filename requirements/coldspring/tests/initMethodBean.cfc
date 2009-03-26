<cfcomponent name="initMethodBean" displayname="initMethodBean">
	
	<cfset this.initMethodCalled = false />

	<cffunction name="init" access="public" returntype="coldspring.tests.initMethodBean">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setup" access="public">
		<cfset this.initMethodCalled = true />
	</cffunction>

</cfcomponent>