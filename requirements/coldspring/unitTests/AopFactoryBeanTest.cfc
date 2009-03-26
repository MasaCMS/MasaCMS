<cfcomponent name="AopFactoryBeanTest" 
			displayname="AopFactoryBeanTest" 
			hint="test factory bean methods" 
			extends="org.cfcunit.framework.TestCase">

	<cffunction name="setUp" access="private" returntype="void" output="false">
		<!--- first make some advisors --->
		<cfset variables.advOne = CreateObject('component','coldspring.tests.aopTests.bfAdvOne').init() />
		<cfset variables.advTwo = CreateObject('component','coldspring.tests.aopTests.aftAdvOne').init() />
		<cfset variables.advThree = CreateObject('component','coldspring.tests.aopTests.interceptOne').init() />
		<cfset variables.target = CreateObject('component','coldspring.tests.aopTests.helloBean').init() />
		<cfset variables.sys = CreateObject('java','java.lang.System') />
	</cffunction>
	
	<cffunction name="testNamedPointcutAdvisor" access="public" returntype="void" output="false">
		<cfset var npa = CreateObject('component','coldspring.aop.support.NamedMethodPointcutAdvisor').init() />
		<cfset npa.setAdvice(variables.advOne) />
		<!--- test mapped name '*' --->
		<cfset npa.setMappedName('*') />
		<cfset assertTrue(npa.matches('testMethod')) />
		<!--- test a couple of names --->
		<cfset npa.setMappedNames('test*,*Test') />
		<cfset assertTrue(npa.matches('testMethod')) />
		<cfset assertTrue(npa.matches('methodTest')) />
		<!--- make sure we get back the advice we set --->
		<cfset assertSameComponent(npa.getAdvice(), variables.advOne) />
	</cffunction>
	
	<cffunction name="testDefaultPointcutAdvisor" access="public" returntype="void" output="false">
		<cfset var npa = CreateObject('component','coldspring.aop.support.DefaultPointcutAdvisor').init() />
		<cfset npa.setAdvice(variables.advOne) />
		<!--- test any method, should match --->
		<cfset assertTrue(npa.matches('testMethod')) />
		<!--- make sure we get back the advice we set --->
		<cfset assertSameComponent(npa.getAdvice(), variables.advOne) />
	</cffunction>
	
	<cffunction name="testProxyCreation" access="public" returntype="void" output="false">
		<!--- here's the big one, the proxyFactory! --->
		<cfset var factory = CreateObject('component','coldspring.aop.framework.ProxyFactoryBean').init() />
		<cfset var npa = CreateObject('component','coldspring.aop.support.NamedMethodPointcutAdvisor').init() />
		<cfset var proxy = 0 />
		<cfset var debug = 0 />
		
		<!--- todo: note the usage here of the 'addAdviceWithDefaultAdvisor' method! Please depreciate! --->
		<cfset factory.setTarget(variables.target) />
		
		<cfset factory.addAdvisor(npa) />
		<cfset npa.setAdvice(variables.advOne) />
		<cfset npa.setMappedNames('*Hello') />
		
		<cfset factory.addAdviceWithDefaultAdvisor(variables.advThree) />
		
		<!--- OK, let's try a proxy object --->
		<cfset proxy = factory.getObject() />
		
		<cfset variables.sys.out.println(proxy.sayHello('')) />
		<cfset proxy.sayGoodBye() />
		
		<!--- make sure there really are advice chains created
		<cfset assertFalse(StructIsEmpty(proxy.getAdviceChains())) /> --->

	</cffunction>
	
	<cffunction name="testNothing" access="public" returntype="void" output="false">
		<cfset assertTrue(true) />
	</cffunction>
	
</cfcomponent>