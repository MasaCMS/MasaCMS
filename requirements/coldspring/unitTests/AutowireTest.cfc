<cfcomponent extends="coldspring.cfcunit.AbstractAutowireTransactionalTests">

	<cffunction name="getConfigLocations" access="public" returntype="string" output="false">
		<cfset var path = GetDirectoryFromPath(getMetaData(this).path) />
		<cfreturn path & "/testBeans.xml" />
	</cffunction>
	
	<cffunction name="onSetUp" access="public" returntype="void" output="false">
		<!--- this is where my setup would be... --->
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfset variables.sys.out.println("onSetUp executed!") />
	</cffunction>
	
	<cffunction name="onTearDown" access="public" returntype="void" output="false">
		<!--- this is where my teardown would be... --->
		<cfset variables.sys.out.println("onTearDown executed!") />
	</cffunction>
	
	<cffunction name="setStructBean" access="public" returntype="void" output="false">
		<cfargument name="structBean" type="coldspring.tests.structBean" required="true" />
		<cfset variables.structBean = arguments.structBean />
	</cffunction>
	
	<cffunction name="testBeanData" access="public" returntype="void" output="false">
		<cfset variables.sys.out.println("some structBean data: " & variables.structBean.getData().intOne) />
		<cfset AssertNotNull(variables.structBean) />
	</cffunction>
	
	<cffunction name="testNothing" access="public" returntype="void" output="false">
		<cfset AssertTrue(true) />
	</cffunction>

</cfcomponent>