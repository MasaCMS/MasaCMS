<cfcomponent name="helloBean">

	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.helloBean" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfreturn this />
	</cffunction>

	<cffunction name="sayHello" access="public" returntype="string">
		<cfargument name="inputString" type="string" required="true" />
		<cfreturn arguments.inputString & "<b>Hello!</b><br/>" />
	</cffunction>

	<cffunction name="sayGoodbye" access="public" returntype="void">
		<cfset variables.sys.out.println('') />
		<cfset variables.sys.out.println('Goodbye !!') />
	</cffunction>
	
</cfcomponent>