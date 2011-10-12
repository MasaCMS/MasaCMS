<!--- This file is part of Mura CMS.

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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.iterator.queryIterator" output="false">

<cfset variables.packageBy="active">
<cfset variables.content="">

<cffunction name="init" access="public" output="false" returntype="any">
	<cfargument name="packageBy" required="true" default="active">
	<cfset super.init(argumentCollection=arguments)>
	<cfset variables.packageBy=arguments.packageBy>
	<cfset variables.content=getBean("contentNavBean")>
	<cfreturn this />
</cffunction>
	
<cffunction name="packageRecord" access="public" output="false" returntype="any">
	<cfset var item="">
	
	<cfif isQuery(variables.records)>
		<cfset item=queryRowToStruct(variables.records,currentIndex())>
	<cfelseif isArray(variables.records)>
		<cfset item=variables.records[currentIndex()]>
	<cfelse>
		<cfthrow message="The records have not been set.">
	</cfif>
		
	<cfset variables.content.set(item,variables.packageBy) />
	
	<cfreturn variables.content>
</cffunction>

<cffunction name="setPackageBy" output="false" access="public">
	<cfargument name="packageBy">
	<cfset variables.packageBy=arguments.packageBy>
	<cfreturn this>
</cffunction>

<cffunction name="buildQueryFromList" output="false" access="public">
	<cfargument name="idList">
	<cfargument name="siteid">
	<cfargument name="idType" required="true" default="contentID">
	<cfset var i="">
	<cfset var idArray=listToArray(arguments.idList)>
	<cfset variables.records=queryNew("#arguments.idType#,siteID","VARCHAR,VARCHAR")>
	
	<cfloop from="1" to="#arrayLen(idArray)#" index="i">
		<cfset QueryAddRow(variables.records)>
		<cfset QuerySetCell(variables.records, arguments.idType, idArray[i])>
		<cfset QuerySetCell(variables.records, 'siteID',arguments.siteid)>
	</cfloop>
	
	<cfset variables.maxRecordsPerPage=variables.records.recordcount>
	<cfset variables.recordIndex = 0 />
	<cfset variables.pageIndex = 1 />
	<cfreturn this>
</cffunction>

<cffunction name="getRecordCount" access="public" output="false" returntype="numeric">
		<cfset var recordCount = 0 />
		<cfif structKeyExists(variables,"records")>
			<cfif isQuery(variables.records)>
				<cfset recordCount =records.recordCount />
			<cfelseif isArray(variables.records)>
				<cfset recordCount= arrayLen(variables.records) />
			</cfif>
		</cfif>
		<cfreturn recordCount />
</cffunction>

<cffunction name="setArray" access="public" output="false">
	<cfargument name="array" type="any" required="true">
	<cfargument name="maxRecordsPerPage" type="numeric" required="false">

	<cfset variables.records = arguments.array />
		
	<cfif structKeyExists(arguments,"maxRecordsPerPage") and isNumeric(arguments.maxRecordsPerPage)>
		<cfset variables.maxRecordsPerPage = arguments.maxRecordsPerPage />
	<cfelse>
		<cfset variables.maxRecordsPerPage = arrayLen(variables.records) />
	</cfif>
	<cfreturn this>
</cffunction>
	
<cffunction name="getArray" output="false" returntype="any">
	<cfset var array=arrayNew(1)>
	<cfset var i=1>
	
	<cfif isArray(variables.records)>
		<cfreturn variables.records>
	<cfelseif isQuery(variables.records)>
		<cfloop query="variables.records">
			<cfset arrayAppend(array,queryRowToStruct(variables.records,variables.records.currentRow))>
		</cfloop>
	<cfelse>
		<cfthrow message="The records have not been set.">
	</cfif>
</cffunction>

<cffunction name="getQuery" output="false" returntype="any">
	<cfif isQuery(variables.records)>
		<cfreturn variables.records>
	<cfelseif isArray(variables.records)>
		<cfreturn getBean("utility").arrayToQuery(variables.records)>
	<cfelse>
		<cfthrow message="The records have not been set.">
	</cfif>
</cffunction>

</cfcomponent>