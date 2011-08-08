<cfcomponent extends="mura.cfobject" output="false">

<cfproperty name="errors" type="struct" default="{}" required="true" />

<cfset variables.instance=structNew()>

<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.errors=structNew()>
</cffunction>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>
<cfset var bean="">

<cfif len(arguments.MissingMethodName)>
	<cfif listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>	
		<cfif prefix eq "get">
			<cfreturn getValue(prop)>
		<cfelseif prefix eq "set" and not structIsEmpty(MissingMethodArguments)>
			<cfset setValue(prop,MissingMethodArguments[1])>	
			<cfreturn this>
		</cfif>
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>
<cfelse>
	<cfreturn "">
</cfif>

</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isQuery(arguments.data) and arguments.data.recordcount>
			<cfloop list="#arguments.data.columnlist#" index="prop">
				<cfset setValue(prop,arguments.data[prop][1]) />
			</cfloop>
			
		<cfelseif isStruct(arguments.data)>
			<cfloop collection="#arguments.data#" item="prop">
				<cfset setValue(prop,arguments.data[prop]) />
			</cfloop>
				
		</cfif>
		
		<cfset validate() />
		<cfreturn this>
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfif isSimpleValue(arguments.propertyValue)>
		<cfset arguments.propertyValue=trim(arguments.propertyValue)>
	</cfif>
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue)") />
	<cfelse>
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(this,"get#property#")>
		<cfset evaluate("get#property#()") />
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.instance["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="setErrors" output="false" access="public">
  <cfargument name="errors"> 
	<cfif isStruct(arguments.errors)>
	 <cfset variables.instance.errors = arguments.errors />
	</cfif> 
	<cfreturn this>
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

</cfcomponent>