<cfsilent>
	<!--- first make some advisors --->
	<cfset bfAdvOne = CreateObject('component','coldspring.tests.aopTests.bfAdvOne').init() />
	<cfset beforeAdvisor = CreateObject('component','coldspring.aop.support.NamedMethodPointcutAdvisor').init() />
	<cfset beforeAdvisor.setAdvice(bfAdvOne) />
	<cfset beforeAdvisor.setMappedName('say*,*oops') />
	
	<cfset aftAdvOne = CreateObject('component','coldspring.tests.aopTests.aftAdvOne').init() />
	<cfset afterAdvisor = CreateObject('component','coldspring.aop.support.NamedMethodPointcutAdvisor').init() />
	<cfset afterAdvisor.setAdvice(aftAdvOne) />
	<cfset afterAdvisor.setMappedName('sayHello') />
	
	<!--- now a target --->
	<cfset myTarget = CreateObject('component','coldspring.tests.aopTests.helloBean').init() />
	
	<!--- here's the big one, the proxyFactory! --->
	<cfset myFactory = CreateObject('component','coldspring.aop.framework.ProxyFactoryBean').init() />
	<cfset myFactory.setTarget(myTarget) />
	<cfset myFactory.addAdvisor(beforeAdvisor) />
	<cfset myFactory.addAdvisor(afterAdvisor) />
	
	<!--- OK, let's try a proxy object --->
	<cfset myProxy = myFactory.getObject() />
	
</cfsilent>

<!--- we'll test so far --->
<html>
	<body>
	
	<cfoutput>
	<!--- where's the factorybean located? --->
	FATORY BEAN LOC: #GetDirectoryFromPath(getMetaData(myFactory).path)#
	<br><br>
	<!--- OK, let's call a proxy method and look for the advice !!! --->
	TEST SAYHELLO():<br>
	#myProxy.sayHello(ArrayNew(1),0)#
	<br><br>
	TEST SAY GOODBYE():<br><br>
	#myProxy.sayGoodbye(ArrayNew(1),0)#
	<br><br>
	<!--- dump metadata
	TARGET METADATA<br>
	<cfdump var="#getMetaData(myTarget)#" />
	<br><br> --->
	<!--- dump metadata
	PROXY BEAN METADATA<br>
	<cfset Exists = StructFindValue(getMetaData(myFactory),"coldspring.beans.factory.FactoryBean","ALL") />
	<cfdump var="#ArrayLen(Exists)#" />
	<cfdump var="#Exists#" />
	<cfdump var="#getMetaData(myFactory)#" /> --->
	</cfoutput>
	
	<!--- 
	<cfif myAdvisor.matches('sayHello')>
		<cfset myAdvisor.getAdvice().before(CreateObject('component','coldspring.aop.Method'), StructNew(), 0) />
	<cfelse>
		Not advisor for 'sayHello()'!
	</cfif>
	<br><br>
	<cfif myAdvisor.matches('groups')>
		<cfset myAdvisor.getAdvice().before(CreateObject('component','coldspring.aop.Method'), StructNew(), 0) />
	<cfelse>
		Not advisor for 'groups()'!
	</cfif>
	
	<cfdump var="#myProxy#" />
	--->
	</body>
</html>