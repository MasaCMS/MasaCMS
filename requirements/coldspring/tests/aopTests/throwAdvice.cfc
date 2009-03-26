<cfcomponent name="throwAdvice" 
			displayname="throwAdvice" 
			extends="coldspring.aop.ThrowsAdvice" 
			output="false">
			
	<cfset variables.exceptionType = 'any' />
			
	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.throwAdvice" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="afterThrowingAny" access="public" returntype="void">
		<cfargument name="method" type="coldspring.aop.Method" required="false" />
		<cfargument name="exception" type="coldspring.aop.Exception" required="true" />
		
		<cfset variables.sys.out.println("Exception caught in method " & method.getMethodName() & ": " & exception.getMessage()) />
	</cffunction>
	
	<cffunction name="afterThrowingColdSpring" access="public" returntype="void">
		<cfargument name="method" type="coldspring.aop.Method" required="false" />
		<cfargument name="args" type="struct" required="false" />
		<cfargument name="target" type="any" required="false" />
		<cfargument name="exception" type="coldspring.aop.Exception" required="true" />
		
		<cfset variables.sys.out.println("coldspring Exception caught in method " & method.getMethodName() & ": " & exception.getMessage()) />
	</cffunction>
	
	<cffunction name="afterThrowingErrorMyType" access="public" returntype="void">
		<cfargument name="method" type="coldspring.aop.Method" required="false" />
		<cfargument name="args" type="struct" required="false" />
		<cfargument name="target" type="any" required="false" />
		<cfargument name="exception" type="coldspring.aop.Exception" required="true" />
		
		<cfset variables.sys.out.println("Error.MyType Exception caught in method " & method.getMethodName() & ": " & exception.getMessage()) />
	</cffunction>
	
</cfcomponent>