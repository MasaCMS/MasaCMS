<cfcomponent name="afterAdvice" extends="coldspring.aop.AfterReturningAdvice">

	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.afterAdvice" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="afterReturning" access="public" returntype="any">
		<cfargument name="returnVal" type="any" required="false" />
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		
		<cfset variables.sys.out.println('') />
		<cfset variables.sys.out.println("I'm called after " & method.getMethodName()) />
		
		<cfif StructKeyExists(arguments,'returnVal')>
			<cfset variables.sys.out.println("I'm returning " & arguments.returnVal) />
			<cfreturn arguments.returnVal />
		</cfif>
		
		<cfset variables.sys.out.println("I'm returning nothing") />
	</cffunction>
	
</cfcomponent>