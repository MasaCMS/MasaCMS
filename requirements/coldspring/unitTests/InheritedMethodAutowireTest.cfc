<cfcomponent extends="org.cfcunit.framework.TestCase">

	<cffunction name="getConfigLocations" access="public" returntype="string" output="false">
		<cfset var path = GetDirectoryFromPath(getMetaData(this).path) />
		<cfreturn path & "/testBeans.xml" />
	</cffunction>
	
	<cffunction name="setUp" access="public" returntype="void" output="false">
		<cfset initBeanFactory() />
	</cffunction>
	
	<cffunction name="initBeanFactory" access="private" returntype="void" output="false">
		<cfset var configLocations = getConfigLocations() />
		<cfif len(configLocations)>
			<cfset variables.beanFactory = CreateObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
			<cfset variables.beanFactory.loadBeans(configLocations) />
		</cfif>
	</cffunction>
	
	<cffunction name="testAutowireInheritedMethod" access="public" returntype="void" output="false" hint="">
		<cfset var bf = 0 />
		<cfset var bean = 0 />
		
		<!--- create a new bean factory --->
		<cfset bf = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
		<!--- load the bean defs --->
		<cfset bf.loadBeans(getConfigLocations())/>
		
		<cfset bean = bf.getBean('subclassBean') />
		<cfset assertTrue(IsInstanceOf(bean.getStringBean(), 'coldspring.tests.stringBean')) />
	</cffunction>
		
</cfcomponent>