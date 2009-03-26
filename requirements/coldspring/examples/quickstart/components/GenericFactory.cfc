<cfcomponent name="GenericFactory" hint="I create and return Factories for Domain Objects.">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createFactory" access="public" returntype="any" output="false" hint="I get an instance the specified kind of Factory.">
		<cfargument name="factoryType" type="string" required="true" />
		<cfreturn CreateObject('component', '#arguments.factoryType#Factory').init() />
	</cffunction>

</cfcomponent>