<cfcomponent name="InterceptorTestsTwo" 
			displayname="InterceptorTestsTwo" 
			hint="test interceptor methods" 
			extends="org.cfcunit.framework.TestCase">

	<cffunction name="setUp" access="private" returntype="void" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
	</cffunction>
	
	<cffunction name="testAdviceChain" access="public" returntype="void" output="false">
		<cfset var invocation = 0 />
		
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var adviceChain = CreateObject('component', 'coldspring.aop.AdviceChain').init() />
		
		<cfset var args = StructNew() />
		<cfset var rtn = 0 />
		<cfset var ix = 0 />
		
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.aroundAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.afterAdvice').init()) />
		<cfset adviceChain.addAdvice(
			    CreateObject('component','coldspring.aop.AfterReturningAdviceInterceptor').init(
				CreateObject('component','coldspring.tests.aopTests.afterAdvice').init()) ) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init()) />
		<cfset adviceChain.addAdvice(
			    CreateObject('component','coldspring.aop.BeforeAdviceInterceptor').init(
				CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init()) ) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.throwAdvice').init()) />
		<cfset adviceChain.addAdvice(
			    CreateObject('component','coldspring.aop.ThrowsAdviceInterceptor').init(
				CreateObject('component','coldspring.tests.aopTests.throwAdvice').init())) />
		
		<cftry>
			<!---  args, return --->
			<cfset args.argOne = "Hi!" />
			<cfset args.shouldReturn = true />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<!--- <cfloop from="1" to="2" index="ix">
			</cfloop> --->
				<cfset invocation = adviceChain.getMethodInvocation(method, args, testObj) />
				<cfset rtn = invocation.proceed() />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>
	
	
	<cffunction name="testErrorChain" access="public" returntype="void" output="false">
		<cfset var invocation = 0 />
		
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var adviceChain = CreateObject('component', 'coldspring.aop.AdviceChain').init() />
		
		<cfset var args = StructNew() />
		<cfset var rtn = 0 />
		<cfset var ix = 0 />

		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.throwAdvice').init()) />
		<cfset adviceChain.addAdvice(
			    CreateObject('component','coldspring.aop.ThrowsAdviceInterceptor').init(
				CreateObject('component','coldspring.tests.aopTests.throwAdvice').init())) />
		
		<cftry>
			<!---  args, return --->
			<cfset args.argOne = "Hi!" />
			<cfset args.shouldReturn = true />
			<cfset method.init(testObj, 'doBadMethod', args) />
			<!--- <cfloop from="1" to="2" index="ix">
			</cfloop> --->
				<cfset invocation = adviceChain.getMethodInvocation(method, args, testObj) />
				<cfset rtn = invocation.proceed() />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="testRawMethodSpeed" access="public" returntype="void" output="false">

		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var before1 = CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init() />
		<cfset var before2 = CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init() />
		<cfset var after1 = CreateObject('component','coldspring.tests.aopTests.afterAdvice').init() />
		<cfset var after2 = CreateObject('component','coldspring.tests.aopTests.afterAdvice').init() />

		
		<cfset var args = StructNew() />
		<cfset var ix = 0 />
		<cfset var rtn = 0 />

		<!---  args, return --->
		<cfset args.argOne = "Hi!" />
		<cfset args.shouldReturn = true />
		
		<cftry>
			<!--- <cfloop from="1" to="50" index="ix">
			</cfloop> --->
				<cfset rtn = testObj.doGoodMethod(argumentCollection=args) />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>

</cfcomponent>