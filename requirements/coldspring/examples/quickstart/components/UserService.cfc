<cfcomponent name="User Service" hint="I am an example User Service, which is how external things interact with my Model.">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getUserGateway" access="public" returntype="any" output="false" hint="I return the UserGateway.">
		<cfreturn variables.instance['userGateway'] />
	</cffunction>
		
	<cffunction name="setUserGateway" access="public" returntype="void" output="false" hint="I set the UserGateway.">
		<cfargument name="userGateway" type="any" required="true" hint="UserGateway" />
		<cfset variables.instance['userGateway'] = arguments.userGateway />
	</cffunction>
	
</cfcomponent>

