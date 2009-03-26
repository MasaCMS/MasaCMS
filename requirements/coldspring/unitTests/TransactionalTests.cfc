<cfcomponent extends="coldspring.cfcunit.AbstractAutowireTransactionalTests">
	
	<cffunction name="onSetUp" access="public" returntype="void" output="false">
		<!--- this is where my setup would be... --->
		<cfset variables.sys = CreateObject('java','java.lang.System') />
		<cfset variables.sys.out.println("onSetUp executed! Transaction should begin...") />
	</cffunction>
	
	<cffunction name="onTearDown" access="public" returntype="void" output="false">
		<!--- this is where my teardown would be... --->
		<cfset variables.sys.out.println("onTearDown executed! Transaction should roll back...") />
	</cffunction>
	
	<cffunction name="testInsert" access="public" returntype="void" output="false">
		
		<cfset var sys = CreateObject('java','java.lang.System') />
		<cfquery datasource="litepost">
			INSERT INTO users(fname,lname,email,username,password,role)
			VALUES ('ChrisTest','test','c@home','test','test','admin')
		</cfquery>
		<cfset sys.out.println("Insterted a user") />
	</cffunction>

</cfcomponent>