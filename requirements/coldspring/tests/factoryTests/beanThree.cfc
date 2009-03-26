
<cfcomponent name="beanThree">

	<cffunction name="init" access="public" returntype="any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setHelper" access="public">
		<cfargument name="helper" type="coldspring.tests.factoryTests.beanOne" required="true" />
		<cfset this.helper = arguments.helper />
	</cffunction>
	
	<cffunction name="getHelper" access="public" returntype="any">
		<cfreturn this.helper />
	</cffunction>
	
	<cffunction name="setInnerBean" access="public">
		<cfargument name="innerBean" type="coldspring.tests.factoryTests.beanFour" required="true" />
		<cfset this.innerBean = arguments.innerBean />
	</cffunction>
	
	<cffunction name="getInnerBean" access="public" returntype="any">
		<cfreturn this.innerBean />
	</cffunction>
	
</cfcomponent>