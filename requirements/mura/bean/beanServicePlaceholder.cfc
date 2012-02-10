<cfcomponent output="false">

	<cffunction name="init" output="false">
		<cfreturn this>
	</cffunction>

	<cffunction name="setServiceName">
		<cfargument name="serviceName">

		<cfset variables.serviceName=arguments.serviceName>
	
		<cfreturn this>
	</cffunction>

    <cffunction name="onMissingMethod" output="false">
        <cfargument name="missingMethodName" type="string"/>
        <cfargument name="missingMethodArguments" type="struct"/>

        <cfset var object=application.serviceFactory.getBean(variables.serviceName)>
      	<cfset application[variables.serviceName]=object>

        <cfsavecontent variable="local.thevalue2">
			<cfif not structIsEmpty(MissingMethodArguments)>
				<cfinvoke component="#object#" method="#MissingMethodName#" argumentcollection="#MissingMethodArguments#" returnvariable="local.theValue1">
			<cfelse>
				<cfinvoke component="#object#" method="#MissingMethodName#" returnvariable="local.theValue1">
			</cfif>
		</cfsavecontent>

		<cfif isDefined("local.theValue1")>
			<cfreturn local.theValue1>
		<cfelseif isDefined("local.theValue2")>
			<cfreturn trim(local.theValue2)>
		<cfelse>
			<cfreturn "">
		</cfif>
    </cffunction>

</cfcomponent>
