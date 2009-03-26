<cfcomponent name="Config Bean" hint="I contain application configuration info such as datasource name.">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfargument name="datasourceName" type="string" required="false" default="fakeDSN" />
		<cfset setDatasourceName(arguments.datasourceName) />
		<cfreturn this />
	</cffunction>

	<cffunction name="getDatasourceName" access="public" returntype="string" output="false" hint="I return the DatasourceName.">
		<cfreturn variables.instance['datasourceName'] />
	</cffunction>
		
	<cffunction name="setDatasourceName" access="public" returntype="void" output="false" hint="I set the DatasourceName.">
		<cfargument name="datasourceName" type="string" required="true" hint="DatasourceName" />
		<cfset variables.instance['datasourceName'] = arguments.datasourceName />
	</cffunction>

</cfcomponent>