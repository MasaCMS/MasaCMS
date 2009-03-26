
<cfcomponent name="beanEight">

	<cffunction name="init" access="public" returntype="coldspring.tests.beanEight">

		<cfreturn this />
	</cffunction>
	
	<cffunction name="sayHi" access="public" returntype="string">
		<cfreturn this.message />
	</cffunction>
	
	<cffunction name="setMessage" access="public">
		<cfargument name="message" type="string" required="true" />
		<cfset this.message = arguments.message />
	</cffunction>
	
	<cffunction name="getMessage" access="public" returntype="string">
		<cfreturn this.message />
	</cffunction>
	
	<cffunction name="setMoreStuff" access="public">
		<cfargument name="MoreStuff" type="struct" required="true" />
		<cfset this.MoreStuff = arguments.MoreStuff />
	</cffunction>
	
	<cffunction name="getMoreStuff" access="public" returntype="struct">
		<cfreturn this.MoreStuff />
	</cffunction>
		
</cfcomponent>