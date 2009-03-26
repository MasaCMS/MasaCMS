
<cfcomponent name="beanThree">

	<cffunction name="init" access="public" returntype="any">
		<cfargument name="helper" type="coldspring.tests.beanFive" required="true" />
		<cfset this.con_arg_helper = arguments.helper />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setHelper" access="public">
		<cfargument name="helper" type="coldspring.tests.beanOne" required="true" />
		<cfset this.helper = arguments.helper />
	</cffunction>
	
	<cffunction name="sayHiWithInnerBean" access="public">
		<cfreturn this.con_arg_helper.sayHi() />
	</cffunction>
</cfcomponent>