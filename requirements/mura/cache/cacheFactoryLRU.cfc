<cfcomponent output="false" extends="mura.Factory">

	<cfset variables.MAX_ENTRIES = 10 />

	<cffunction name="init" access="public" returntype="LRUCacheFactory" output="false">
		<cfargument name="maxEntries" type="numeric" required="true" /> 
		<cfargument name="javaLoader" type="any" required="true" />
		
		<!--- set the java loader --->
		<cfset setJavaLoader( arguments.javaLoader ) />
		
		<!--- set MAX_ENTRIES --->
		<cfset variables.MAX_ENTRIES = arguments.maxEntries />
		
		<!--- override the map and create the LRU version --->
		<cfset variables.map = getJavaLoader().create( "SimpleLRUCache" ).init( variables.MAX_ENTRIES ) />
		
		<!--- run super init --->
		<cfset super.init() />
		
		<cfreturn this />
	</cffunction>

</cfcomponent>