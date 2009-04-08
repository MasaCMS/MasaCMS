<cfcomponent extends="mura.Factory" output="false">

<cffunction name="init" output="false" returnType="any">
<cfargument name="class">
<cfargument name="siteid">
<cfargument name="genericManager">
<cfargument name="pluginManager">
	<cfset variables.class=arguments.class>
	<cfset variables.siteid=arguments.siteid>
	<cfset variables.genericManager=arguments.genericManager>
	<cfset variables.pluginManager=arguments.pluginManager>
	<cfreturn this>
</cffunction>

<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashKey = getHashKey( arguments.key ) />
		<cfset var checkKey= "__check__" & arguments.key>
		<cfset var hashCheckKey = getHashKey( checkKey ) />
		<cfset var rs="" />
		<cfset var event="" />
		
		<!--- Check if the prelook for plugins has been made --->
		<cfif NOT has( checkKey )>
			<!--- If it has not then get it--->
			<cfset rs=variables.pluginManager.getScripts(arguments.key,variables.siteid)>
			<cfset variables.collection[ hashCheckKey ] = rs.recordcount />
			<cfif rs.recordcount>
				<cfset variables.collection[ hashKey ] = variables.pluginManager.getComponent("plugins.#rs.pluginID#.#rs.scriptfile#", rs.pluginID, variables.siteID, rs.docache)>
			</cfif>
		</cfif>
		
		<cfif variables.collection[ hashCheckKey ]>
			<cfreturn variables.collection[ hashKey ]>
		<cfelse>
			<!--- return cached context --->		
			<cfreturn variables.genericManager.getFactory(variables.class).get(arguments.key) />
		
		</cfif>

</cffunction>

</cfcomponent>