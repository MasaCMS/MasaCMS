
<cfcomponent name="beanFive">

	<cffunction name="init" access="public" returntype="coldspring.tests.beanFive">
		<cfargument name="innerhelper" type="coldspring.tests.beanThree" required="true" />
		<cfset this.con_arg_helper = arguments.innerhelper />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="sayHi" access="public" returntype="string">
		<cfreturn "he says:" & this.con_arg_helper.getInnerBean().sayHi() />
	</cffunction>
	
</cfcomponent>