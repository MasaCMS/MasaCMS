<cfcomponent output="false" displayname="LoggingAdvice" hint="I advise service layer methods and apply logging." extends="coldspring.aop.MethodInterceptor">

	<cffunction name="init" returntype="any" output="false" access="public" hint="Constructor">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="invokeMethod" returntype="any" access="public" output="false" hint="">
		<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" hint="" />
		<cfset var local =  StructNew() />

		<!--- Capture the arguments and method name being invoked. --->
		<cfset local.logData = StructNew() />
		<cfset local.logData.arguments = StructCopy(arguments.methodInvocation.getArguments()) />
		<cfset local.logData.method = arguments.methodInvocation.getMethod().getMethodName() />
		<cfset request.logData = local.logData />
		
		<!--- Proceed with the method call to the underlying CFC. --->
		<cfset local.result = arguments.methodInvocation.proceed() />
		
		<!--- Return the result of the method call. --->
		<cfreturn local.result />
	</cffunction>
	
</cfcomponent>