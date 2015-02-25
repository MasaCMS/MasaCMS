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

	<cfproperty name="entityName" type="string" default="" />
	<cfproperty name="table" type="string" default="" />
	<cfproperty name="keyField" type="string" default="" />
	<cfproperty name="nextN" type="numeric" default="0" required="true" />
	<cfproperty name="maxItems" type="numeric" default="0" required="true" />
	<cfproperty name="siteID" type="string" default="" />
	<cfproperty name="sortBy" type="string" default="" />
	<cfproperty name="sortDirection" type="string" default="asc" required="true" />
	<cfproperty name="additionalColumns" type="string" default="" />
	<cfproperty name="sortTable" type="string" default="" />
	
<cffunction name="init" output="false">
	
	<cfset variables.instance={}>
	<cfset variables.instance.isNew=1>
	<cfset variables.instance.errors={}>
	<cfset variables.instance.fromMuraCache = false>
	<cfif not structKeyExists(variables.instance,"instanceID")>
		<cfset variables.instance.instanceID=createUUID()>
	</cfif>
	<cfset variables.instance.addObjects=[]>
	<cfset variables.instance.removeObjects=[]>
	<cfset variables.instance.siteID="">
	<cfset variables.instance.entityName=""/>
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
	<cfset variables.instance.orderby=""/>
	
	<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfset variables.instance.joins=arrayNew(1)  />
	<cfreturn this/>
</cffunction>

<cffunction name="getEntityName" output="false">
	<cfreturn variables.instance.entityName>
</cffunction>

<cffunction name="setEntityName" output="false">
	<cfargument name="entityName">
	<cfset variables.instance.entityName=arguments.entityName>
	<cfreturn this>
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

	<cfif not structKeyExists(application.objectMappings, variables.instance.entityName)>
		<cfset application.objectMappings[variables.instance.entityName] = structNew()>
	</cfif>
	<cfif not structKeyExists(application.objectMappings[variables.instance.entityName], "columns")>
		<cfset application.objectMappings[variables.instance.entityName].columns = getBean('dbUtility').columns(table=variables.instance.table)>
	</cfif>
	<cfif not structKeyExists(application.objectMappings[variables.instance.entityName], "columnlist")>
		<cfset application.objectMappings[variables.instance.entityName].columnlist = structKeyList(application.objectMappings[variables.instance.entityName].columns)>
	</cfif>
</cffunction>

<cffunction name="getTableFieldList" output="false">
	<cfset loadTableMetaData()>
	<cfreturn application.objectMappings[variables.instance.entityName].columnlist>
</cffunction>

<cffunction name="formatField" output="false">
	<cfargument name="field">

	<cfset loadTableMetaData()>

	<cfif structKeyExists(application.objectMappings[variables.instance.entityName].columns,arguments.field)>
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
						listFirst(arguments.params['paramField#i#'],'^'),
						arguments.params['paramRelationship#i#'],
						arguments.params['paramCriteria#i#'],
						arguments.params['paramCondition#i#'],
						listLast(arguments.params['params.paramField#i#'],'^')
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
	<cfargument name="datatype" type="string"  default="" required="true">
		<cfset var rows=1/>

		<cfif structKeyExists(arguments,'column')>
			<cfset arguments.field=arguments.column>
		</cfif>
		
		<cfif not len(arguments.dataType)>
			<cfset loadTableMetaData()>
			<cfif not structKeyExists(variables, "dbUtility")>
				<cfset variables.dbUtility = getBean('dbUtility')>
			</cfif>
			<cfset var tempField=listLast(arguments.field,'.')>
			<cfif structKeyExists(application.objectMappings[variables.instance.entityName].columns,tempField)>
				<cfset arguments.dataType=variables.dbUtility.transformParamType(application.objectMappings[variables.instance.entityName].columns[tempField].dataType)>
			<cfelse>
				<cfset arguments.dataType="varchar">
			</cfif>
		</cfif>

		<cfset queryAddRow(variables.instance.params,1)/>
		<cfset rows = variables.instance.params.recordcount />
		<cfset querysetcell(variables.instance.params,"param",rows,rows)/>
		<cfset querysetcell(variables.instance.params,"field",formatField(arguments.field),rows)/>
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
	<cfargument name="datatype" type="string"  default="" required="true">
		
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
	
	<cfif not hasJoin(arguments.table)>
		<cfset arrayAppend(variables.instance.joins, arguments)>
	</cfif>
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
	
	<cfloop array="#getJoins()#" index="join">
		<cfif arguments.table eq join.table>
			<cfreturn true>
		</cfif>
	</cfloop>
	
	<cfreturn false>
</cffunction>

<cffunction name="getDbType" output="false">
	<cfif structKeyExists(application.objectMappings,variables.instance.entityName) and structKeyExists(application.objectMappings[variables.instance.entityName],'dbtype')>
		<cfreturn application.objectMappings[variables.instance.entityName].dbtype>
	<cfelse>
		<cfreturn variables.configBean.getDbType()>
	</cfif>
</cffunction>

<cffunction name="hasColumn" output="false">
	<cfargument name="column">
	<cfreturn isDefined("application.objectMappings.#getValue('entityName')#.columns.#arguments.column#")>
</cffunction>

<cffunction name="hasDiscriminatorColumn" output="false">
	<cfreturn isDefined("application.objectMappings.#getValue('entityName')#.discriminatorColumn") and len(application.objectMappings[getValue('entityName')].discriminatorColumn)>
</cffunction>

<cffunction name="getDiscriminatorColumn" output="false">
	<cfreturn application.objectMappings[getValue('entityName')].discriminatorColumn>
</cffunction>

<cffunction name="getDiscriminatorValue" output="false">
	<cfreturn application.objectMappings[getValue('entityName')].discriminatorValue>
</cffunction>

<cffunction name="hasCustomDatasource" output="false">
	<cfreturn structKeyExists(application.objectMappings,variables.instance.entityName) and structKeyExists(application.objectMappings[variables.instance.entityName],'datasource')>
</cffunction>

<cffunction name="getCustomDatasource" output="false">
	<cfreturn application.objectMappings[variables.instance.entityName].datasource>
</cffunction>

<cffunction name="getQueryAttrs" output="false">
	<cfif hasCustomDatasource()>
		<cfset structAppend(arguments,
			{datasource=getCustomDatasource(),
			username='',
			password=''},
			false)>
		<cfreturn arguments>
	<cfelse>
		<cfreturn variables.configBean.getReadOnlyQRYAttrs(argumentCollection=arguments)>
	</cfif>
</cffunction>

<cffunction name="getQueryService" output="false">
	<cfreturn new Query(argumentCollection=getQueryAttrs(argumentCollection=arguments))>
</cffunction>


<cffunction name="getQuery" returntype="query" output="false">
	<cfargument name="countOnly" default="false">

	<cfset var rs="">
	<cfset var isListParam=false>
	<cfset var param="">
	<cfset var started=false>
	<cfset var openGrouping=false>
	<cfset var jointable="">
	<cfset var jointableS="">
	<cfset var dbType=getDbType()>

	<cfif hasDiscriminatorColumn()>
		<cfset addParam(column=hasDiscriminatorColumn(),criteria=hasDiscriminatorValue())>
	</cfif>
 
	<cfloop query="variables.instance.params">
		<cfif listLen(variables.instance.params.field,".") eq 2>
			<cfset jointable=listFirst(variables.instance.params.field,".") >
			<cfif jointable neq variables.instance.table and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery attributeCollection="#getQueryAttrs(name='rs')#">
		<cfif not arguments.countOnly and dbType eq "oracle" and variables.instance.maxItems>select * from (</cfif>
		select <cfif not arguments.countOnly and dbtype eq "mssql" and variables.instance.maxItems>top #val(variables.instance.maxItems)#</cfif>
		
		<cfif not arguments.countOnly>
			#getTableFieldList()# 
		<cfelse>
			count(*) as count
		</cfif>
		
		from #variables.instance.table#
		
		<cfloop list="#jointables#" index="jointable">
			<cfset started=false>
			<cfif arrayLen(variables.instance.jointables)>
				<cfloop from="1" to="#arrayLen(variables.instance.jointables)#" index="local.i">
					<cfif variables.instance.jointables[local.i].table eq jointable>
						<cfset started=true>
						#variables.instance.jointables[local.i].jointype# join #jointable# #tableModifier# on (#variables.instance.jointables[local.i].clause#)
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfif not started>
				inner join #jointable# on (#variables.instance.table#.#variables.instance.keyField#=#jointable#.#variables.instance.keyField#)
			</cfif>
		</cfloop>

		where

		<cfif 
			(not isDefined('application.objectMappings.#getValue('entityName')#.columns') and len(variables.instance.siteID))
			or 
			 (hasColumn('siteid') and len(variables.instance.siteID))>
			siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#"/>
		<cfelse>
			1=1
		</cfif>

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
					<cfset openGrouping=true />	
					and (
				</cfif>
				<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
					<cfif not openGrouping>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
					<cfif not openGrouping>or</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
					<cfif not openGrouping>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
					)
					<cfset openGrouping=false />
				<cfelseif not openGrouping>
					#param.getRelationship()#
				</cfif>
				
				<cfset started = true />

				<cfset isListParam=listFindNoCase("IN,NOT IN",param.getCondition())>					
				<cfif len(param.getField())>
					#param.getFieldStatement()# 
					<cfif param.getCriteria() eq 'null'>
						IS NULL
					<cfelse>
						#param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>  	
					</cfif>
					<cfset openGrouping=false />
				</cfif>
			</cfif>						
		</cfloop>
		<cfif started>)</cfif>
	</cfif> 

	<cfif not arguments.countOnly>
		<cfif len(variables.instance.orderby)>
			order by #REReplace(variables.instance.orderby,"[^0-9A-Za-z\._,\- ]","","all")#
			<cfif listFindNoCase("oracle,postgresql", dbType)>
				<cfif lcase(listLast(variables.instance.orderby, " ")) eq "asc">
					NULLS FIRST
				<cfelse>
					NULLS LAST
				</cfif>
			</cfif>
		<cfelseif len(variables.instance.sortBy)>
			order by #variables.instance.table#.#REReplace(variables.instance.sortby,"[^0-9A-Za-z\._,\- ]","","all")#  #variables.instance.sortDirection#
			<cfif listFindNoCase("oracle,postgresql", dbType)>
				<cfif variables.instance.sortDirection eq "asc">
					NULLS FIRST
				<cfelse>
					NULLS LAST
				</cfif>
			</cfif>
		</cfif>

		<cfif listFindNoCase("mysql,postgresql", dbType) and variables.instance.maxItems>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /> </cfif>
		<cfif dbType eq "nuodb" and variables.instance.maxItems>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /></cfif>
		<cfif dbType eq "oracle" and variables.instance.maxItems>) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.maxItems#" /> </cfif>
	</cfif>

	</cfquery>

	<cfreturn rs>
</cffunction>

<cffunction name="getIterator" returntype="any" output="false">
	<cfset var rs=getQuery()>
	<cfset var it=''>

	<cfif getServiceFactory().containsBean("#variables.instance.entityName#Iterator")>
		<cfset it=getBean("#variables.instance.entityName#Iterator")>
	<cfelse>
		<cfset it=getBean("beanIterator")>
	</cfif>

	<cfset it.setEntityName(getValue('entityName'))>

	<cfset it.setQuery(rs,variables.instance.nextN)>
	<cfreturn it>
</cffunction>

<cffunction name="setSortDirection" access="public" output="false">
	<cfargument name="sortDirection" type="any" />
	<cfif listFindNoCase('desc,asc',arguments.sortDirection)>
	<cfset variables.instance.sortDirection = arguments.sortDirection />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAvailableCount" output="false">
	<cfreturn getQuery(countOnly=true).count>
</cffunction>

</cfcomponent>
