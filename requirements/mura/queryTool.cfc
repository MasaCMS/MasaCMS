<cfcomponent name="queryTool" hint="Transforms a query into other data types." output="false">

<!--- Public queryTool init() --->
<cffunction output="false" access="public" returnType="any" name="init">
  <cfargument name="inQuery" type="query" required="true" hint="The query to transform."/>
  <cfset variables.instance = structNew() />
  <cfset variables.instance.inQuery = arguments.inQuery>
  <cfreturn this />
</cffunction>

<!--- Public Array toArray(query inQuery) --->
<cffunction output="false" access="public" returnType="array" name="toArray" hint="Transforms a query into an array of structures.">
  <cfset var result = arrayNew(1) />
  <cfset var row = structNew() />
  <cfset var i = "" />
  
  <cfloop query="variables.instance.inQuery">
    <cfset row = structNew() />
    <cfloop list="#variables.instance.inQuery.columnList#" index="i">
      <cfset row[i] = variables.instance.inQuery[i][variables.instance.inQuery.currentRow] />
    </cfloop>
    <cfset arrayAppend(result, row) />
  </cfloop>
  
  <cfreturn result />
</cffunction>

<!--- Public Struct toStruct(query inQuery, string primaryKey) --->
<cffunction output="false" access="public" returnType="struct" name="toStruct" hint="Transforms a query into a structure, using a designated column as the key.">
  <cfargument name="primaryKey" type="string" required="true" hint="The name of the column to be used as the key for the structure.  Should be a unique identifier or rows will be lost!"/>
  
  <cfset var result = structNew() />
  <cfset var row = structNew() />
  <cfset var i = "" />
  
  <cfif not listFindNoCase(variables.instance.inQuery.columnList, arguments.primaryKey)>
    <cfthrow message="The primary key passed to toStruct() is not present in your query." />
  </cfif>
  
  <cfloop query="variables.instance.inQuery">
    <cfset row = structNew() />
    <cfloop list="#variables.instance.inQuery.columnList#" index="i">
      <cfset row[i] = variables.instance.inQuery[i][variables.instance.inQuery.currentRow] />
    </cfloop>
    <cfset result[variables.instance.inQuery[arguments.primaryKey][variables.instance.inQuery.currentRow]] = row />
  </cfloop>
  
  <cfreturn result />
</cffunction>

<!--- Public XML toXml(query inQuery) --->
<cffunction output="false" access="public" returnType="any" name="toXml" hint="Transforms a query into an XML recordset.">
  <cfset var result = "">
  <cfset var i=""/>
  <cfxml variable="result">
<recordset>
  <cfloop query="variables.instance.inQuery">
    <item>
    <cfloop list="#variables.instance.inQuery.columnList#" index="i">
      <cfoutput><#i#>#variables.instance.inQuery[i][variables.instance.inQuery.currentRow]#</#i#></cfoutput>
    </cfloop>
    </item>
  </cfloop>
</recordset>
  </cfxml>
  
  <cfreturn result>
</cffunction>

<!--- Public XML toDelimited(query inQuery) --->
<cffunction output="false" access="public" returnType="string" name="toDelimited" hint="Transforms a query into a delimited string using the given delimiter and linefeed characters.">
  <cfargument name="delimiter" type="string" default="#chr(9)#" hint="Default column delimiter (default is TAB)."/>
  <cfargument name="linefeed" type="string" default="#chr(10)#" hint="Default linefeed (default is chr(10))."/>

  <cfset var result = "">
  <cfset var i=""/>
  <cfloop list="#variables.instance.inQuery.columnList#" index="i">
    <cfset result = result & "#trim(i)#">
    <cfif i eq listGetAt(variables.instance.inQuery.columnList, listLen(variables.instance.inQuery.columnList))>
      <cfset result = result & arguments.lineFeed>
    <cfelse>
      <cfset result = result & arguments.delimiter>
    </cfif>
  </cfloop>
  <cfloop query="variables.instance.inQuery">
    <cfloop list="#variables.instance.inQuery.columnList#" index="i">
      <cfset result = result & "#variables.instance.inQuery[i][variables.instance.inQuery.currentRow]#">
      <cfif i eq listGetAt(variables.instance.inQuery.columnList, listLen(variables.instance.inQuery.columnList))>
        <cfset result = result & arguments.lineFeed>
      <cfelse>
        <cfset result = result & arguments.delimiter>
      </cfif>
    </cfloop>
  </cfloop>
  <cfreturn result>
</cffunction>


<cffunction name="QueryAppend" access="public" returntype="void" output="false"
	hint="This takes two queries and appends the second one to the first one. This actually updates the first query and does not return anything.">

	<!--- Define arguments. --->
	<cfargument name="QueryOne" type="query" required="yes" />
	<cfargument name="QueryTwo" type="query" required="yes" />
	<cfargument name="Filter" type="string" required="yes" default="page">
	
	<!--- Define the local scope. --->
	<cfset var local = StructNew() />

	<!--- Get the column list (as an array for faster access. --->
	<cfset local.Columns = ListToArray( arguments.QueryTwo.ColumnList ) />


	<!--- Loop over the second query. --->
	<cfloop query="arguments.QueryTwo">

		<!--- Add a row to the first query. --->
		<cfset QueryAddRow( arguments.QueryOne ) />

		<!--- Loop over the columns. --->
		<cfloop index="local.Column" from="1" to="#ArrayLen( local.Columns )#" step="1">

			<!--- Get the column name for easy access. --->
			<cfset local.ColumnName = local.Columns[ local.Column ] />

			<!--- Set the column value in the newly created row. --->
			<cfset arguments.QueryOne[ local.ColumnName ][ arguments.QueryOne.RecordCount ] = arguments.QueryTwo[ local.ColumnName ][ arguments.QueryTwo.CurrentRow ] />

		</cfloop>
		
	</cfloop>

	<!--- Return out. --->
	<cfreturn />
</cffunction>

</cfcomponent>

