<cfcomponent name="User Gateway" hint="I am an example User Gateway for interacting with a database.">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getConfigBean" access="public" returntype="any" output="false" hint="I return the ConfigBean.">
		<cfreturn variables.instance['configBean'] />
	</cffunction>
		
	<cffunction name="setConfigBean" access="public" returntype="void" output="false" hint="I set the ConfigBean.">
		<cfargument name="configBean" type="any" required="true" hint="ConfigBean" />
		<cfset variables.instance['configBean'] = arguments.configBean />
	</cffunction>

</cfcomponent>