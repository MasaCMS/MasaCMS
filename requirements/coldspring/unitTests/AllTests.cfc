<cfcomponent name="AllTests" extends="org.cfcunit.Object" output="false" hint="Runs all unit tests in package.">

	<cffunction name="suite" returntype="org.cfcunit.framework.Test" access="public" output="false" hint="">
		<cfset var testSuite = newObject("org.cfcunit.framework.TestSuite").init("All coldspring Tests")>

		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.AopFactoryBeanTest"))>
		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.ExceptionTests"))>
		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.InterceptorTestsTwo"))>
		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.InitMethodTests"))>
		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.AbstractNoClassTests"))>
		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.FrameworkPropertiesTests"))>
		<cfset testSuite.addTestSuite(newObject("coldspring.unitTests.InheritedMethodAutowireTest"))>
		<!--- <cfset testSuite.addTestSuite(newObject("coldspring.unitTests.RemoteFactoryBeanTest"))> --->
		
		<cfreturn testSuite/>
	</cffunction>	

</cfcomponent>