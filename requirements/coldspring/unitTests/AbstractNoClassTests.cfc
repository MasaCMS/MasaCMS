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
		
	<cffunction name="testAbstractBeanWithNoClass" access="public" returntype="void" output="false">
		<cfset var child = variables.beanFactory.getBean('childBean') />
		<cfset AssertTrue(child.getMessage() eq 'I am set in the Abstract Parent.') />
	</cffunction>

</cfcomponent>