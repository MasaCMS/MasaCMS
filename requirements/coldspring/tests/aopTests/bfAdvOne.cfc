<cfcomponent name="bfAdvOne" extends="coldspring.aop.BeforeAdvice">

	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.bfAdvOne" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="before" access="public" returntype="any">
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		
		<cfset args['inputString'] = 'Greetings!<br><br>' />
		
	</cffunction>
	
</cfcomponent>