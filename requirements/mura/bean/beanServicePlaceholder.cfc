<cfcomponent output="false">

	<cfset variables.object="">

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

        <cfif not isObject(variables.object)>
        	<cfset variables.object=application.serviceFactory.getBean(variables.serviceName)>
      		<cfset application[variables.serviceName]=variables.object>
      	</cfif>

        <cfsavecontent variable="local.thevalue2">
			<cfif not structIsEmpty(MissingMethodArguments)>
				<cfinvoke component="#variables.object#" method="#MissingMethodName#" argumentcollection="#MissingMethodArguments#" returnvariable="local.theValue1">
			<cfelse>
				<cfinvoke component="#variables.object#" method="#MissingMethodName#" returnvariable="local.theValue1">
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
