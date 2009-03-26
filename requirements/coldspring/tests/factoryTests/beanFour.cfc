
<cfcomponent name="beanThree">

	<cffunction name="init" access="public" returntype="any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="sayHi" access="public" returntype="string">
		<cfreturn "I'm an inner bean!" />
	</cffunction>
	
</cfcomponent>