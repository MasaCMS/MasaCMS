<cfcomponent name="ExceptionTests" 
			displayname="ExceptionTests" 
			hint="test exception methods" 
			extends="org.cfcunit.framework.TestCase">

	<cffunction name="setUp" access="private" returntype="void" output="false">
		<cfset variables.sys = CreateObject('java','java.lang.System') />
	</cffunction>
	
	<!--- 
	<cffunction name="testBasicException" access="public" returntype="void" output="false">
		<cfset var r = 0 />
		<cfset var ex = 0 />
		<cfset var catchStruct = StructNew() />
		<cfset var key = '' />
		<cfset var i = 0 />
		
		<cfloop from="1" to="2" index="i">
		<cftry>
			<!--- <cfset r = 10 / 0 /> --->
			<cfthrow type="coldspring.aop.TestException" message="a message">
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.SlowException") />
				<cfloop list="#StructKeyList(cfcatch)#" index="key">
					<cfset catchStruct[key] = cfcatch[key]>
				</cfloop>
				<cfset ex.init(argumentCollection=catchStruct) />
			</cfcatch>
		</cftry>
		</cfloop>
		
		<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
		<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
		<cfset variables.sys.out.println("DETAIL: " & ex.getDetail()) />
		<cfset variables.sys.out.println("NATIVE ERROR CODE: " & ex.getNativeErrorCode()) />
		<cfset variables.sys.out.println("SQL STATE: " & ex.getSqlState()) />
		<cfset variables.sys.out.println("SQL: " & ex.getSql()) />
		<cfset variables.sys.out.println("WHERE: " & ex.getWhere()) />
		<cfset variables.sys.out.println("ERROR NUMBER: " & ex.getErrNumber()) />
		<cfset variables.sys.out.println("MISSING FILENAME: " & ex.getMissingFileName()) />
		<cfset variables.sys.out.println("LOCK OPERATION: " & ex.getLockOperation()) />
		<cfset variables.sys.out.println("ERROR CODE: " & ex.getErrorCode()) />
		<cfset variables.sys.out.println("") />
		
		<cfset assertTrue(len(ex.getType()) GT 0) />
		<cfset assertTrue(isArray(ex.getTagContext())) />
	</cffunction> --->
	
	<cffunction name="testException" access="public" returntype="void" output="false">
		<cfset var r = 0 />
		<cfset var ex = 0 />
		<cfset var i = 0 />
		
		<cfloop from="1" to="2" index="i">
		<cftry>
			<cfset r = 10 / 0 />
			<cfcatch>
				<cfset ex = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
			</cfcatch>
		</cftry>
		</cfloop>
		
		<cfset variables.sys.out.println("TYPE: " & ex.getType()) />
		<cfset variables.sys.out.println("MESSAGE: " & ex.getMessage()) />
		<cfset variables.sys.out.println("DETAIL: " & ex.getDetail()) />
		<cfset variables.sys.out.println("NATIVE ERROR CODE: " & ex.getNativeErrorCode()) />
		<cfset variables.sys.out.println("SQL STATE: " & ex.getSqlState()) />
		<cfset variables.sys.out.println("SQL: " & ex.getSql()) />
		<cfset variables.sys.out.println("WHERE: " & ex.getWhere()) />
		<cfset variables.sys.out.println("ERROR NUMBER: " & ex.getErrNumber()) />
		<cfset variables.sys.out.println("MISSING FILENAME: " & ex.getMissingFileName()) />
		<cfset variables.sys.out.println("LOCK OPERATION: " & ex.getLockOperation()) />
		<cfset variables.sys.out.println("ERROR CODE: " & ex.getErrorCode()) />
		<cfset variables.sys.out.println("") />
		
		<cfset assertTrue(len(ex.getType()) GT 0) />
		<cfset assertTrue(isArray(ex.getTagContext())) />
	</cffunction>

</cfcomponent>