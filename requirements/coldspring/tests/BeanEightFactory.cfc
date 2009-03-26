<cfcomponent extends="coldspring.beans.factory.FactoryBean">

	<cffunction name="init" access="private" returntype="void" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getObject" access="public" returntype="any" output="false">
		<cfset var obj = CreateObject('component', 'coldspring.tests.beanEight').init() />
		<cfreturn obj />
	</cffunction>
	
	<cffunction name="getObjectType" access="public" returntype="string" output="false">
		<cfreturn "coldspring.tests.beanEight"/>
	</cffunction>
	
	<cffunction name="isSingleton" access="public" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>
	
</cfcomponent>