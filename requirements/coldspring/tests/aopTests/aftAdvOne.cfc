<cfcomponent name="aftAdvOne" extends="coldspring.aop.AfterReturningAdvice">
	
	<cfset variables.someData = 999 />
	
	<cffunction name="init" access="public" returntype="coldspring.tests.aopTests.aftAdvOne" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="afterReturning" access="public" returntype="any">
		<cfargument name="returnVal" type="any" required="false" />
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		
		<cfset method.proceed() />
		<cfset method.proceed() />
		
		<cfif StructKeyExists(arguments,'returnVal')>
			<cfreturn returnVal & "<br><br>Yall!!" />
		</cfif>
		
	</cffunction>
	
	<cffunction name="setSomeData" access="public" returntype="void" output="false">
		<cfargument name="someData" type="numeric" required="true" />
		<cfset variables.someData = arguments.someData />
	</cffunction>
	
	<cffunction name="getSomeData" access="public" returntype="numeric" output="false">
		<cfreturn variables.someData />
	</cffunction>
	
</cfcomponent>