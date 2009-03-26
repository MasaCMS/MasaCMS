<cfcomponent name="InterceptorTests" 
			displayname="InterceptorTests" 
			hint="test interceptor methods" 
			extends="org.cfcunit.framework.TestCase">

	<cffunction name="setUp" access="private" returntype="void" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
	</cffunction>
	
	<cffunction name="XtestBeforeInterceptor" access="public" returntype="void" output="false">
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var invocation = CreateObject('component','coldspring.aop.MethodInvocation') />
		<cfset var beforeAdvice = CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init() />
		<cfset var beforeAdviceInterceptor = CreateObject('component','coldspring.aop.BeforeAdviceInterceptor') />
		<cfset var args = StructNew() />
		<cfset var rtn = 0 />
		<cfset beforeAdviceInterceptor.init(beforeAdvice) />
		
		
		<cftry>
			<!--- test calling method with and without args, with and withoug return --->
			<!--- no args, no return --->
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset beforeAdviceInterceptor.invokeMethod(invocation) />
			<!---  args, no return
			<cfset args.argOne = "Hi!" /> --->
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset beforeAdviceInterceptor.invokeMethod(invocation) />
			<!---  args, return --->
			<cfset args.shouldReturn = true />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset rtn = beforeAdviceInterceptor.invokeMethod(invocation) />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>
	
	<cffunction name="XtestAfterInterceptor" access="public" returntype="void" output="false">
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var invocation = CreateObject('component','coldspring.aop.MethodInvocation') />
		<cfset var afterAdvice = CreateObject('component','coldspring.tests.aopTests.afterAdvice').init() />
		<cfset var afterAdviceInterceptor = CreateObject('component','coldspring.aop.AfterReturningAdviceInterceptor') />
		<cfset var args = StructNew() />
		<cfset var rtn = 0 />
		<cfset afterAdviceInterceptor.init(afterAdvice) />
		
		<cftry>
			<!--- test calling method with and without args, with and withoug return--->
			<!--- no args, no return --->
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset afterAdviceInterceptor.invokeMethod(invocation) />
			<!---  args, no return --->
			<cfset args.argOne = "Hi!" />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset afterAdviceInterceptor.invokeMethod(invocation) />
			<!---  args, return --->
			<cfset args.argOne = "Hi!" />
			<cfset args.shouldReturn = true />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset rtn = afterAdviceInterceptor.invokeMethod(invocation) />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>
	
	<cffunction name="XtestAroundInterceptor" access="public" returntype="void" output="false">
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var invocation = CreateObject('component','coldspring.aop.MethodInvocation') />
		<cfset var aroundAdviceInterceptor = CreateObject('component','coldspring.tests.aopTests.aroundAdvice').init() />
		<cfset var args = StructNew() />
		<cfset var rtn = 0 />
		
		<cftry>
			<!--- test calling method with and without args, with and withoug return--->
			<!--- no args, no return --->
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset aroundAdviceInterceptor.invokeMethod(invocation) />
			<!---  args, no return --->
			<cfset args.argOne = "Hi!" />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset aroundAdviceInterceptor.invokeMethod(invocation) />
			<!---  args, return --->
			<cfset args.argOne = "Hi!" />
			<cfset args.shouldReturn = true />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation.init(method, args, testObj) />
			<cfset rtn = aroundAdviceInterceptor.invokeMethod(invocation) />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>
	
	<cffunction name="XtestAdviceChain" access="public" returntype="void" output="false">
		<cfset var invocation = 0 />
		
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var adviceChain = CreateObject('component', 'coldspring.aop.AdviceChain').init() />
		
		<cfset var args = StructNew() />
		<cfset var rtn = 0 />
		
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.aroundAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.afterAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.throwAdvice').init()) />
		
		<cftry>
			<!--- test calling method with and without args, with and withoug return--->
			<!--- no args, no return
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation = adviceChain.getNewInterceptorChain(method, args, testObj) />
			<cfset invocation.proceed() /> --->
			<!---  args, no return
			<cfset args.argOne = "Hi!" />
			<cfset method.init(testObj, 'doGoodMethod', args) />
			<cfset invocation = adviceChain.getNewInterceptorChain(method, args, testObj) />
			<cfset invocation.proceed() /> --->
			<!---  args, return --->
			<cfset args.argOne = "Hi!" />
			<cfset args.shouldReturn = true />
			<cfset method.init(testObj, 'doBadMethod', args) />
			<cfset invocation = adviceChain.getNewInterceptorChain(method, args, testObj) />
			<cfset rtn = invocation.proceed() />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>
	
	<cffunction name="testChainMethodSpeed" access="public" returntype="void" output="false">
		<cfset var invocation = 0 />
		
		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var adviceChain = CreateObject('component', 'coldspring.aop.AdviceChain').init() />
		
		<cfset var args = StructNew() />
		<cfset var ix = 0 />
		<cfset var rtn = 0 />
		
		<!---  --->
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.aroundAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.afterAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.beforeAdvice').init()) />
		<cfset adviceChain.addAdvice(CreateObject('component','coldspring.tests.aopTests.throwAdvice').init()) />
		
		<!---  args, return --->
		<cfset args.argOne = "Hi!" />
		<cfset args.shouldReturn = true />
		<cfset method.init(testObj, 'doGoodMethod', args) />
		
		<cftry>
			<cfloop from="1" to="50" index="ix">
				<cfset invocation = adviceChain.getNewInterceptorChain(method, args, testObj) />
				<cfset rtn = invocation.proceed() />
			</cfloop>
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
				<cfdump var="#ex.getTagContext()#"><cfabort />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>
	
	<cffunction name="testRawMethodSpeed" access="public" returntype="void" output="false">

		<cfset var testObj = CreateObject('component','coldspring.tests.aopTests.badBean').init() />

		
		<cfset var args = StructNew() />
		<cfset var ix = 0 />
		<cfset var rtn = 0 />

		<!---  args, return --->
		<cfset args.argOne = "Hi!" />
		<cfset args.shouldReturn = true />
		
		<cftry>
			<cfloop from="1" to="50" index="ix">
				<cfset rtn = testObj.doGoodMethod(argumentCollection=args) />
			</cfloop>
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
				<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
				<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
			</cfcatch>
		</cftry>
		
		<cfset assertEqualsNumber(rtn,5) />
		
	</cffunction>

</cfcomponent>