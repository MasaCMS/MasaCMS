<cfcomponent name="InitMethodTests" 
			displayname="ExceptionTests" 
			hint="test exception methods" 
			extends="org.cfcunit.framework.TestCase">

	<cffunction name="setUp" access="private" returntype="void" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
	</cffunction>
	
	<cffunction name="testRemoteFactory" access="public" returntype="void" output="false">
		<cfset var path = GetDirectoryFromPath(getMetaData(this).path) />
		<cfset var bf = 0 />
		<cfset var bean = 0 />
		<!--- create a new bean factory --->
		<cfset bf = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
		<!--- load the bean defs --->
		<cfset bf.loadBeansFromXmlFile(path&'/testBeans.xml')/>
		
		<!--- get each initMethod bean, assert initMethod was called --->
		<cfset bean = bf.getBean("initSingletonBean")/>
		<cfset assertTrue(bean.initMethodCalled)>
		
		<cfset bean = bf.getBean("initNonSingletonBean")/>
		<cfset assertTrue(bean.initMethodCalled)>

	</cffunction>
	
	<cffunction name="testInheritedInit" access="public" returntype="void" output="false" hint="">
		<cfset var local = StructNew() />
		<cfset var path = GetDirectoryFromPath(getMetaData(this).path) />
		<cfset var bf = 0 />
		<cfset var bean = 0 />
		
		<!--- create a new bean factory --->
		<cfset bf = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
		<!--- load the bean defs --->
		<cfset bf.loadBeansFromXmlFile(path&'/testBeans.xml')/>
		
		<cfset bean = bf.getBean('subclassBean') />
		<cfset assertTrue(bean.getSuperclassArg() eq 'This argument should be set in the superclass.') />
	</cffunction>
	
</cfcomponent>