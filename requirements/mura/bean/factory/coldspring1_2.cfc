<cfcomponent extends="coldspring.beans.DefaultXMLBeanFactory" output="false">

<cffunction name="init" output="false">	
	<cfset super.init(argumentCollection=arguments)>
	<cfset variables.transients=structNew()>
	<cfreturn this>
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfset var bean="">
	
	<!--- Code to help avoid using coldspring for non singleton beans --->
	<cfif NOT isSingleton(arguments.beanName)>
		<cfif not structKeyExists(variables.transients,arguments.beanName)>
			<cfset bean=super.getBean(arguments.beanName)>
			<cfif application.configBean.getValue("duplicateTransients")>
				<cfset variables.transients["#arguments.beanName#"]=bean>
			<cfelse>
				<cfset variables.transients["#arguments.beanName#"]=getMetaData(bean).fullname>
			</cfif>
		</cfif>
		<cfif application.configBean.getValue("duplicateTransients")>
			<cfset bean=duplicate(variables.transients["#arguments.beanName#"])>
		<cfelse>
			<cfset bean=createObject("component",variables.transients["#arguments.beanName#"]).init()>
		</cfif>
	<cfelse>
		<cfset bean=super.getBean(arguments.beanName) />
	</cfif>
	
	<cfreturn bean>
	
</cffunction>

<cffunction name="isSingleton" access="public" returntype="boolean" output="false"
	hint="returns whether the bean with the specified name is a singleton">
	<cfargument name="beanName" type="string" required="true" hint="the bean name to look for"/>
	<cfif localFactoryContainsBean(arguments.beanName)>
		<cfreturn variables.beanDefs[arguments.beanName].isSingleton() />
	<cfelseif isObject(variables.parent) AND variables.parent.localFactoryContainsBean(arguments.beanName)>
		<cfreturn variables.parent.isSingleton(arguments.beanName)>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>
	
</cfcomponent>