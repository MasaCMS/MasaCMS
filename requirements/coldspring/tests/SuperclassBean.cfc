<cfcomponent name="Superclass Bean" hint="">
	
	<cffunction name="init" access="public" returntype="SuperclassBean" hint="Constructor.">
		<cfargument name="superclassArg" type="string" required="true" />
		<cfset setSuperclassArg(arguments.superclassArg) />
		<cfreturn this />
	</cffunction>

	<cffunction name="getSuperclassArg" access="public" returntype="string" output="false" hint="I return the SuperclassArg.">
		<cfreturn variables.instance['superclassArg'] />
	</cffunction>
		
	<cffunction name="setSuperclassArg" access="public" returntype="void" output="false" hint="I set the SuperclassArg.">
		<cfargument name="superclassArg" type="string" required="true" hint="SuperclassArg" />
		<cfset variables.instance['superclassArg'] = arguments.superclassArg />
	</cffunction>
	
	<cffunction name="getStringBean" access="public" returntype="any" output="false" hint="I return the StringBean.">
		<cfreturn variables.instance['stringBean'] />
	</cffunction>
		
	<cffunction name="setStringBean" access="public" returntype="void" output="false" hint="I set the StringBean.">
		<cfargument name="stringBean" type="any" required="true" hint="StringBean" />
		<cfset variables.instance['stringBean'] = arguments.stringBean />
	</cffunction>
	
</cfcomponent>