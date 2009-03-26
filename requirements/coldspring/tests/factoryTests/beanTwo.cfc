
<cfcomponent name="beanThree">

	<cffunction name="init" access="public" returntype="any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setHelper" access="public">
		<cfargument name="helper" type="coldspring.tests.factoryTests.beanOne" required="true" />
		<cfset this.helper = arguments.helper />
	</cffunction>
	
</cfcomponent>