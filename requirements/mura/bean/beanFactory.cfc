<cfcomponent extends="coldspring.beans.DefaultXMLBeanFactory" output="false">

<cffunction name="init" output="false">
	<cfset var i="">
	
	<cfset super.init(argumentCollection=arguments)>
	<cfset variables.transients=structNew()>
	<cfset variables.transientmap=structNew()>

	<cfloop index="i" list="feed,content,user,group,category,mailingList,member,creative,placement,adzone,campaign,changeset,stat,site,siteSettings">
		<cfset variables.transientmap["#i#"]=true>
		<cfset variables.transientmap["#i#Bean"]=true>
		<cfset variables.transientmap["#i#Iterator"]=true>
	</cfloop>
	
	<cfreturn this>
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfset var bean="">
	
	<!--- Code to help avoid using coldspring for non singleton beans --->
	<cfif structKeyExists(variables.transientmap,arguments.beanName)>
		<cfif not structKeyExists(variables.transients,arguments.beanName)>
			<cfset bean=super.getBean(arguments.beanName)>
			<cfif application.configBean.getValue("duplicateTransients")>
				<cfset variables.transients["#arguments.beanName#"]=bean>
			<cfelse>
				<cfset variables.transients["#arguments.beanName#"]=getMetaData(bean).fullname>
			</cfif>
		<cfelse>
			<cfif application.configBean.getValue("duplicateTransients")>
				<cfset bean=duplicate(variables.transients["#arguments.beanName#"])>
			<cfelse>
				<cfset bean=createObject("component",variables.transients["#arguments.beanName#"])>
			</cfif>
			<cfset bean.init()>
		</cfif>	
	<cfelse>
		<cfset bean=super.getBean(arguments.beanName) />
	</cfif>
	
	<cfreturn bean>
	
</cffunction>
	
</cfcomponent>