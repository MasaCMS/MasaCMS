<cfcomponent extends="mura.Factory" output="false">

<cffunction name="init" output="false" returnType="any">
<cfargument name="class">
	<cfset variables.class=arguments.class>
	<cfreturn this>
</cffunction>

<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashKey = getHashKey( arguments.key ) />
		
		<!--- if the key cannot be found and context is passed then push it in --->
		<cfif NOT has( arguments.key )>
			<!--- create object --->
			<cfset variables.collection[ hashKey ] = createObject("component",getComponentPath(arguments.key)).init() />
		</cfif>
		
		<!--- if the key cannot be found then throw an error --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="Component not found for '#getComponentPath(arguments.key)#'" />
		</cfif>

		<!--- return cached context --->		
		<cfreturn variables.collection[ hashKey ] />

</cffunction>

<cffunction name="getComponentPath" output="false" returnType="string">
	<cfargument name="key">
	<cfreturn "mura.#variables.class#.#arguments.key##variables.class#"/>
</cffunction>
</cfcomponent>