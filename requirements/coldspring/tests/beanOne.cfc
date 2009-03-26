
<cfcomponent name="beanOne">

	<cffunction name="init" access="public" returntype="any">
		<cfargument name="helperStruct" type="struct" required="true" />
		<cfset this.con_arg_helperStruct = arguments.helperStruct />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setMessage" access="public">
		<cfargument name="message" type="string" required="true" />
		<cfset this.message = arguments.message />
	</cffunction>
	
	<cffunction name="getMessage" access="public" returntype="string">
		<cfreturn this.message />
	</cffunction>
	
	<cffunction name="setMessageTwo" access="public">
		<cfargument name="messageTwo" type="string" required="true" />
		<cfset this.messageTwo = arguments.messageTwo />
	</cffunction>
	
</cfcomponent>