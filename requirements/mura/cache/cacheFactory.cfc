<cfcomponent output="false" extends="mura.Factory">
	
	<cfset variables.isSoft=true>
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="isSoft" type="boolean" required="true" default="true"/>
		<cfscript>
			super.init( argumentCollection:arguments );
			
			// set isSoft variable
			variables.isSoft = arguments.isSoft;
			
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="context" type="any" required="false" />
		<cfargument name="isSoft" type="boolean" required="false" default="#variables.isSoft#">
		<cfset var hashKey = getHashKey( arguments.key ) />
		
		<!--- if the key cannot be found and context is passed then push it in --->
		<cfif NOT has( arguments.key ) AND isDefined("arguments.context")>
			<!--- create object --->
			<cfset set( key, arguments.context, arguments.isSoft ) />
		</cfif>
		
		<!--- if the key cannot be found then throw an error --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="Context not found for '#arguments.key#'" />
		</cfif>

		<!--- return cached context --->		
		<cfreturn super.get( key ) />

	</cffunction>
	
</cfcomponent>