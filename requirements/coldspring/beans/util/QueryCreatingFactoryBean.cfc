<!---
 
  Copyright (c) 2005, David Ross, Chris Scott, Kurt Wiersma, Sean Corfield
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: QueryCreatingFactoryBean.cfc,v 1.1 2006/02/24 16:53:19 rossd Exp $

--->
 
<cfcomponent name="QueryCreatingFactoryBean" 
			displayname="QueryCreatingFactoryBean" 
			hint="Helper class for injecting queries into beans" 
			output="false">

	<cffunction name="init" access="public" returntype="coldspring.beans.util.QueryCreatingFactoryBean" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createQuery" access="public" returntype="query" output="false">
		<cfargument name="ColumnNames" type="array" required="true" />		
		<cfargument name="Data" type="array" required="true" />

		<cfset var qry = queryNew("")/>
		<cfset var row = 0/>
		<cfset var col = 0/>		
		
		<cftry>
			<cfset qry = queryNew(arrayToList(arguments.ColumnNames))/>
			<cfcatch>
				<cfthrow type="coldspring.beans.util.QueryCreatingFactoryBean.QueryCreationException" message="Unable to set up query, make sure you supply a list (array) of column names!">
			</cfcatch>
		</cftry>
		<cftry>
			<cfloop from="1" to="#arraylen(arguments.data)#" index="row">
				<cfset queryAddRow(qry)/>
				<cfloop from="1" to="#arraylen(arguments.data[row])#" index="col">
					<cfset querySetCell(qry,arguments.ColumnNames[col],arguments.data[row][col])/>
				</cfloop>			
			</cfloop>
			<cfcatch>
				<cfthrow type="coldspring.beans.util.QueryCreatingFactoryBean.QueryPopulationException" message="Unable to populate query - make sure you supply the data as nested lists (arrays)!">
			</cfcatch>
		</cftry>

		<cfreturn qry/>

	</cffunction>
	
</cfcomponent>