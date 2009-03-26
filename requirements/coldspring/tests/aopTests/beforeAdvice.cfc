<cfcomponent name="beforeAdvice" extends="coldspring.aop.BeforeAdvice">

	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.beforeAdvice" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="before" access="public" returntype="any">
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		
		<cfset variables.sys.out.println('') />
		<cfset variables.sys.out.println("I'm called before " & method.getMethodName()) />
	</cffunction>
	
</cfcomponent>