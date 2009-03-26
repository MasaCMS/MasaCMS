<cfcomponent name="badBean">

	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.badBean" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfreturn this />
	</cffunction>

	<cffunction name="doBadMethod" access="public" returntype="void">
		<cfargument name="argOne" type="any" required="false" />
		<cfargument name="argTwo" type="any" required="false" />
		<cfset var result = 0 />
		<cfset variables.sys.out.println('') />
		<cfset variables.sys.out.println("I'm gonna devide by 0!") />
		<cfthrow type="Error.MyType.NotGonnaBeFound.Exception">
		<cfset result = 10 / 0 />
	</cffunction>

	<cffunction name="doGoodMethod" access="public" returntype="any">
		<cfargument name="shouldReturn" type="boolean" required="false" default="false" />
		<cfargument name="argOne" type="any" required="false" default="" />
		
		<cfset var result = 0 />
		<cfset variables.sys.out.println('') />
		<cfset variables.sys.out.println("Recieved args: (" & shouldReturn & "," & argOne & ")") />
		<cfset variables.sys.out.println("I'm gonna devide by 2!") />
		<cfset result = 10 / 2 />
		
		<cfif shouldReturn>
			<cfreturn result />
		</cfif>
	</cffunction>
	
</cfcomponent>