<!--- CF11 functions for CF9+ --->

<cffunction name="QueryExecute" output="false" returntype="query"
			hint="https://wikidocs.adobe.com/wiki/display/coldfusionen/QueryExecute">
	<cfargument name="sql_statement" required="true">
	<cfargument name="queryParams"  default="#structNew()#">
	<cfargument name="queryOptions" default="#structNew()#">
	
	<cfset var parameters = []>
	
	<cfif isArray(queryParams)>
		<cfloop array="#queryParams#" index="local.param">
			<cfif isSimpleValue(param)>
				<cfset arrayAppend(parameters, {value=param})>
			<cfelse>
				<cfset arrayAppend(parameters, param)>
			</cfif>
		</cfloop>
	<cfelseif isStruct(queryParams)>
		<cfloop collection="#queryParams#" item="local.key">
			<cfif isSimpleValue(queryParams[key])>
				<cfset arrayAppend(parameters, {name=local.key, value=queryParams[key]})>
			<cfelse>
				<cfset arrayAppend(parameters, queryParams[key])>
			</cfif>
		</cfloop>
	<cfelse>
		<cfthrow message="unexpected type for queryParams">
	</cfif>
	
	<cfreturn new Query(sql=sql_statement, parameters=parameters, argumentCollection=queryOptions).execute().getResult()>
</cffunction>


<cffunction name="QueryGetRow" output="false" returntype="struct"
			hint="https://wikidocs.adobe.com/wiki/display/coldfusionen/QueryGetRow">
	<cfargument name="query" type="query" required="true">
	<cfargument name="row" type="numeric" default="1">
	
	<cfset var struct = {}>
	
	<cfloop list="#query.columnList#" index="local.col">
		<cfset struct[col] = query[col][row]>
	</cfloop>
	
	<cfreturn struct>
</cffunction>