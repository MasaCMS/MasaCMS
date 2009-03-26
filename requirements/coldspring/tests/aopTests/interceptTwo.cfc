<cfcomponent name="interceptTwo" extends="coldspring.aop.MethodInterceptor">
	
	<cfset variables.someData = 999 />
	
	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.interceptTwo" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="invokeMethod" access="public" returntype="any">
		<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" />
		<cfset var args = methodInvocation.getArguments() />
		<cfset var rtn = '' />
		
		<cfset args['inputString'] = args['inputString'] & '<br>Begin intercept Two<br>' />
		
		<cfset rtn = methodInvocation.proceed() />
		
		<cfif isDefined('rtn')>
			<cfset rtn = rtn & '<br>End intercept Two<br>' />
			
			<cfreturn rtn />
		</cfif>
	</cffunction>
	
</cfcomponent>