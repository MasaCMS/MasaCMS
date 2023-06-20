<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent name="queryTool" hint="This provides the ability to transforms a query into other data types." output="false">

<!--- Public queryTool init() --->
<cffunction output="false" name="init">
  <cfargument name="inQuery" type="query" required="true" hint="The query to transform."/>
  <cfset variables.instance = structNew() />
  <cfset variables.instance.inQuery = arguments.inQuery>
  <cfreturn this />
</cffunction>

<!--- Public Array toArray(query inQuery) --->
<cffunction output="false" returnType="array" name="toArray" hint="Transforms a query into an array of structures.">
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
<cffunction output="false" returnType="struct" name="toStruct" hint="Transforms a query into a structure, using a designated column as the key.">
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
<cffunction output="false" name="toXml" hint="Transforms a query into an XML recordset.">
  <cfset var result = "">
  <cfset var i=""/>
  <cfsavecontent variable="result">
<recordset>
  <cfloop query="variables.instance.inQuery">
    <item>
    <cfloop list="#variables.instance.inQuery.columnList#" index="i">
      <cfoutput><#i#>#variables.instance.inQuery[i][variables.instance.inQuery.currentRow]#</#i#></cfoutput>
    </cfloop>
    </item>
  </cfloop>
</recordset>
  </cfsavecontent>

  <cfreturn parseXML(result)>
</cffunction>

<!--- Public XML toDelimited(query inQuery) --->
<cffunction output="false" name="toDelimited" hint="Transforms a query into a delimited string using the given delimiter and linefeed characters.">
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


<cffunction name="QueryAppend" output="false"
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
