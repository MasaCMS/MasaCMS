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
<cfcomponent extends="mura.bean.bean" output="false">

	<cfproperty name="bean" type="string" default="" required="true" />
	<cfproperty name="table" type="string" default="" required="true" />
	<cfproperty name="keyField" type="string" default="" required="true" />
	<cfproperty name="nextN" type="numeric" default="0" required="true" />
	<cfproperty name="maxItems" type="numeric" default="0" required="true" />
	<cfproperty name="siteID" type="string" default="" required="true" />
	<cfproperty name="sortBy" type="string" default="" required="true" />
	<cfproperty name="sortDirection" type="string" default="asc" required="true" />
	<cfproperty name="additionalColumns" type="string" default="" required="true" />
	<cfproperty name="sortTable" type="string" default="" required="true" />
	
<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.siteID="">
	<cfset variables.instance.table="">
	<cfset variables.instance.keyField="">
	<cfset variables.instance.sortBy="" />
	<cfset variables.instance.sortDirection="asc" />
	<cfset variables.instance.tableFieldLookUp=structNew()/>
	<cfset variables.instance.tableFieldlist=""/>
	<cfset variables.instance.nextN=0>
	<cfset variables.instance.maxItems=0>
	<cfset variables.instance.additionalColumns=""/>
	<cfset variables.instance.sortTable=""/>

	
	<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfset variables.instance.joins=arrayNew(1)  />
	<cfreturn this/>
</cffunction>

<cffunction name="setNextN" access="public" output="false">
	<cfargument name="NextN" type="any" />
	<cfif isNumeric(arguments.nextN)>
	<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMaxItems" access="public" output="false">
	<cfargument name="maxItems" type="any" />
	<cfif isNumeric(arguments.maxItems)>
	<cfset variables.instance.maxItems = arguments.maxItems />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="loadTableMetaData" output="false">
	<cfset var rs="">
	<cfset var temp="">
	<cfset var i="">

	<cfif not len(variables.instance.tableFieldList)>
		<cfset variables.instance.tableFieldLookUp=variables.configBean.getValue("#variables.instance.bean#FieldLookUp")>
		<cfset variables.instance.tableFieldList=variables.configBean.getValue("#variables.instance.bean#FieldList
			")>
		<cfif not len(variables.instance.tableFieldList)>
			<cfset variables.instance.tableFieldLookUp=structNew()>
			<cfset rs=variables.configBean.dbTableColumns(variables.instance.table)>
			<cfset variables.instance.tableFieldlist=valueList(rs.column_name)>
			<cfloop list="#variables.instance.tableFieldlist#" index="i">
				<cfset variables.instance.tableFieldLookUp["#i#"]=true>
			</cfloop>
			<cfset variables.configBean.setValue("#variables.instance.bean#FieldLookUp",variables.instance.tableFieldLookUp)>
			<cfset variables.configBean.setValue("#variables.instance.bean#FieldList",variables.instance.tableFieldlist)>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getTableFieldList" output="false">
	<cfset loadTableMetaData()>
	<cfreturn variables.instance.tableFieldList>
</cffunction>

<cffunction name="formatField" output="false">
	<cfargument name="field">

	<cfset loadTableMetaData()>

	<cfif structKeyExists(variables.instance.tableFieldLookUp,arguments.field)>
		<cfset arguments.field="#variables.instance.table#.#arguments.field#">
	</cfif>

	<cfreturn arguments.field>

</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setAdvancedParams" access="public" output="false">
	<cfargument name="params" type="any" required="true">
	<cfreturn setParams(argumentCollection=arguments)>
</cffunction>

<cffunction name="setParams" access="public" output="false">
	<cfargument name="params" type="any" required="true">
		
		<cfset var rows=0/>
		<cfset var I = 0 />
		
		<cfif isquery(arguments.params)>
			
		<cfset variables.instance.params=arguments.params />
			
		<cfelseif isdefined('arguments.params.param')>
		
			<cfset clearparams() />
			<cfloop from="1" to="#listLen(arguments.params.param)#" index="i">
				
				<cfset addParam(
						listFirst(evaluate('arguments.params.paramField#i#'),'^'),
						evaluate('arguments.params.paramRelationship#i#'),
						evaluate('arguments.params.paramCriteria#i#'),
						evaluate('arguments.params.paramCondition#i#'),
						listLast(evaluate('arguments.params.paramField#i#'),'^')
						) />
	
			</cfloop>
			
		<cfelseif isdefined('arguments.params.paramarray') and isArray(arguments.params.paramarray)>
		
			<cfset clearparams() />
			<cfloop from="1" to="#arrayLen(arguments.params.paramarray)#" index="i">
				
				<cfset addParam(
						listFirst(arguments.params.paramarray[i].field,'^'),
						arguments.params.paramarray[i].relationship,
						arguments.params.paramarray[i].criteria,
						arguments.params.paramarray[i].condition,
						listLast(arguments.params.paramarray[i].field,'^')
						) />
	
			</cfloop>
					
		</cfif>
		
		<cfif isStruct(arguments.params)>
			<cfif structKeyExists(arguments.params,"siteid")>
				<cfset setSiteID(arguments.params.siteid)>
			</cfif>	
		</cfif>

		<cfreturn this>
</cffunction>

<cffunction name="addParam" access="public" output="false">
	<cfargument name="field" hint="You can use 'Column' as an alias to field" type="string" required="true" default="">
	<cfargument name="relationship" type="string" default="and" required="true">
	<cfargument name="criteria" type="string" required="true" default="">
	<cfargument name="condition" type="string" default="EQUALS" required="true">
	<cfargument name="datatype" type="string"  default="varchar" required="true">
		<cfset var rows=1/>
		
		<cfset queryAddRow(variables.instance.params,1)/>
		<cfset rows = variables.instance.params.recordcount />
		<cfset querysetcell(variables.instance.params,"param",rows,rows)/>
		<cfif structKeyExists(arguments,"column")>
			<cfset querysetcell(variables.instance.params,"field",formatField(arguments.column),rows)/>
		<cfelse>
			<cfset querysetcell(variables.instance.params,"field",formatField(arguments.field),rows)/>
		</cfif>
		<cfset querysetcell(variables.instance.params,"relationship",arguments.relationship,rows)/>
		<cfset querysetcell(variables.instance.params,"criteria",arguments.criteria,rows)/>
		<cfset querysetcell(variables.instance.params,"condition",arguments.condition,rows)/>
		<cfset querysetcell(variables.instance.params,"dataType",arguments.datatype,rows)/>
	<cfreturn this>
</cffunction>

<cffunction name="addAdvancedParam" access="public" output="false">
	<cfargument name="field" type="string" required="true" default="">
	<cfargument name="relationship" type="string" default="and" required="true">
	<cfargument name="criteria" type="string" required="true" default="">
	<cfargument name="condition" type="string" default="EQUALS" required="true">
	<cfargument name="datatype" type="string"  default="varchar" required="true">
		
	<cfreturn addParam(argumentCollection=arguments)>
</cffunction>

<cffunction name="getAdvancedParams">
	<cfreturn getParams()>
</cffunction>

<cffunction name="getParams">
	<cfreturn variables.instance.params>
</cffunction>

<cffunction name="clearAdvancedParams">
	<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfreturn this>
</cffunction>

<cffunction name="clearParams">
	<cfreturn clearAdvancedParams()>
</cffunction>

<cffunction name="addJoin" access="public" output="false">
	<cfargument name="joinType" type="string" required="true" default="inner">
	<cfargument name="table" type="string" required="true" default="">
	<cfargument name="clause" type="string" required="true" default="">
	
	<cfset arrayAppend(variables.instance.joins, arguments)>
	<cfreturn this>
</cffunction>

<cffunction name="getJoins">
	<cfreturn variables.instance.joins>
</cffunction>

<cffunction name="clearJoins">
	<cfset variables.instance.joins=arrayNew(1)  />
	<cfreturn this>
</cffunction>

<cffunction name="hasJoin">
	<cfargument name="table">
	<cfset var join = "">
	<cfset var returnVar = false>
	
	<cfloop array="#getJoins()#" index="join">
		<cfif arguments.table eq join.table>
			<cfset returnVar = true>
		</cfif>
	</cfloop>
	
	<cfreturn returnVar>
</cffunction>

<cffunction name="getQuery" returntype="query" output="false">
	<cfset var rs="">
	<cfset var param="">
	<cfset var started=false>
	<cfset var openGrouping=false>
	<cfset var jointable="">
	<cfset var jointableS="">
	<cfset var dbType=variables.configBean.getDBType()>

	<cfif not len(variables.instance.siteID)>
		<cfthrow message="The 'SITEID' value must be set in order to search users.">
	</cfif>

	<cfloop query="variables.instance.params">
		<cfif listLen(variables.instance.params.field,".") eq 2>
			<cfset jointable=listFirst(variables.instance.params.field,".") >
			<cfif jointable neq variables.instance.table and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
		<cfif dbType eq "oracle" and variables.instance.maxItems>select * from (</cfif>
		select <cfif dbtype eq "mssql" and variables.instance.maxItems>top #variables.instance.maxItems#</cfif>
		#getTableFieldList()# from #variables.instance.table#
		
		<cfloop list="#jointables#" index="jointable">
			inner join #jointable# on (#variables.instance.table#.#variables.instance.keyField#=#jointable#.#variables.instance.keyField#)
		</cfloop>

		where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#"/>

		<cfif variables.instance.params.recordcount>
		<cfset started = false />
		<cfloop query="variables.instance.params">
			<cfset param=createObject("component","mura.queryParam").init(variables.instance.params.relationship,
					variables.instance.params.field,
					variables.instance.params.dataType,
					variables.instance.params.condition,
					variables.instance.params.criteria
				) />
								 
			<cfif param.getIsValid()>	
				<cfif not started >
					and (
				</cfif>
				<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
					(
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
					<cfif started>or</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
					<cfif started>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
					)
				<cfelse>
					<cfif not openGrouping and started>
						#param.getRelationship()#
					<cfelse>
						<cfset openGrouping=false />
					</cfif>
				</cfif>
				
				<cfset started = true />
				<cfset isListParam=listFindNoCase("IN,NOT IN",param.getCondition())>					
				#param.getField()# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>  	
				
			</cfif>						
		</cfloop>
		<cfif started>)</cfif>
	</cfif> 

	order by
		
	#variables.instance.table#.#variables.instance.sortBy# #variables.instance.sortDirection#
	
	<cfif dbType eq "mysql" and variables.instance.maxItems>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /> </cfif>
	<cfif dbType eq "oracle" and variables.instance.maxItems>) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /> </cfif>

	</cfquery>

	<cfreturn rs>
</cffunction>

<cffunction name="getIterator" returntype="any" output="false">
	<cfset var rs=getQuery()>
	<cfset var it=getBean("#variables.instance.bean#Iterator")>
	<cfset it.setQuery(rs,variables.instance.nextN)>
	<cfreturn it>
</cffunction>


  

 
</cfcomponent>