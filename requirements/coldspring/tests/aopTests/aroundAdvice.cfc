<cfcomponent name="aroundAdvice" extends="coldspring.aop.MethodInterceptor">
	
	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.aroundAdvice" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="invokeMethod" access="public" returntype="any">
		<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" />
		<cfset var method = methodInvocation.getMethod() />
		<cfset var args = methodInvocation.getArguments() />
		<cfset var rtn = '' />
		
		<cfset variables.sys.out.println('') />
		<cfset variables.sys.out.println("Around advice, calling " & method.getMethodName()) />
		
		<cfset rtn = methodInvocation.proceed() />
		
		<cfset variables.sys.out.println("Around advice, done! ") />
		
		<cfif isDefined('rtn')>
			<cfreturn rtn />
		</cfif>
	</cffunction>
	
</cfcomponent>