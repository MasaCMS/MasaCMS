<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.siteID="">
<cfset variables.configBean="">
<cfset variables.instance.type="Custom">
<cfset variables.instance.subtype="">
<cfset variables.instance.maxitems=2000>
<cfset variables.instance.nextN=0>
<cfset variables.instance.sortBy="">
<cfset variables.instance.sortDirection="asc">
<cfset variables.instance.dataTable="tclassextenddata">
<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />

<cffunction name="setConfigBean" returntype="any" output="false">
<cfargument name="configBean">
<cfset variables.configBean=arguments.configBean>
<cfreturn this>
</cffunction>

<cffunction name="getParams" returntype="query" access="public" output="false">
	<cfreturn variables.instance.params />
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
						listLast(arguments.params['paramField#i#'],'^')
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
			<cfif structKeyExists(arguments.params,"inactive")>
				<cfset setInActive(arguments.params.inactive)>
			</cfif>
			
			<cfif structKeyExists(arguments.params,"ispublic")>
				<cfset setIsPublic(arguments.params.ispublic)>
			</cfif>
			
			<cfif structKeyExists(arguments.params,"siteid")>
				<cfset setSiteID(arguments.params.siteid)>
			</cfif>
			
			<cfif structKeyExists(arguments.params,"categoryID")>
				<cfset setCategoryID(arguments.params.categoryID)>
			</cfif>
			
			<cfif structKeyExists(arguments.params,"groupID")>
				<cfset setGroupID(arguments.params.groupID)>
			</cfif>
		</cfif>
		<cfreturn this>
</cffunction>

<cffunction name="addParam" access="public" output="false">
	<cfargument name="field" type="string" required="true" default="">
	<cfargument name="relationship" type="string" default="and" required="true">
	<cfargument name="criteria" type="string" required="true" default="">
	<cfargument name="condition" type="string" default="EQUALS" required="true">
	<cfargument name="datatype" type="string"  default="varchar" required="true">
		<cfset var rows=1/>
		
		<cfset queryAddRow(variables.instance.params,1)/>
		<cfset rows = variables.instance.params.recordcount />
		<cfset querysetcell(variables.instance.params,"param",rows,rows)/>
		<cfset querysetcell(variables.instance.params,"field",arguments.field,rows)/>
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

<cffunction name="clearParams">
	<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfreturn this>
</cffunction>

<cffunction name="getIterator" returntype="any" output="false">
	<cfset var rs=getQuery()>
	<cfset var it=getBean("extendObjectIterator")>
	<cfset it.setQuery(rs)>
	<cfreturn it>
</cffunction>

<cffunction name="getSiteID" returntype="any" output="false">
	<cfreturn variables.instance.siteID>
</cffunction>

<cffunction name="setSiteID" output="false">
	<cfargument name="siteID">
	<cfset variables.instance.siteID=arguments.siteID>
	<cfreturn this>
</cffunction>

<cffunction name="getType" returntype="any" output="false">
	<cfreturn variables.instance.type>
</cffunction>

<cffunction name="setType" output="false">
	<cfargument name="type">
	<cfset variables.instance.type=arguments.type>
	<cfreturn this>
</cffunction>

<cffunction name="getSubType" returntype="any" output="false">
	<cfreturn variables.instance.subtype>
</cffunction>

<cffunction name="setSubType" output="false">
	<cfargument name="subtype">
	<cfset variables.instance.subtype=arguments.subtype>
	<cfreturn this>
</cffunction>

<cffunction name="getMaxItems" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.MaxItems />
</cffunction>

<cffunction name="setMaxItems" access="public" output="false">
	<cfargument name="MaxItems" type="numeric" />
	<cfset variables.instance.MaxItems = arguments.MaxItems />
	<cfreturn this>
</cffunction>

<cffunction name="getSortBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.sortBy />
</cffunction>

<cffunction name="setSortBy" access="public" output="false">
	<cfargument name="sortBy" type="String" />
	<cfset variables.instance.sortBy = trim(arguments.sortBy) />
	<cfreturn this>
</cffunction>

<cffunction name="getSortDirection" returntype="String" access="public" output="false">
	<cfreturn variables.instance.sortDirection />
</cffunction>

<cffunction name="setSortDirection" access="public" output="false">
	<cfargument name="sortDirection" type="String" />
	<cfset variables.instance.sortDirection = trim(arguments.sortDirection) />
	<cfreturn this>
</cffunction>

<cffunction name="getNextN" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.NextN />
</cffunction>

<cffunction name="setNextN" access="public" output="false">
	<cfargument name="NextN" type="any" />
	<cfif isNumeric(arguments.nextN)>
	<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDataTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dataTable />
</cffunction>

<cffunction name="setDataTable" access="public" output="false">
	<cfargument name="dataTable" type="String" />
	<cfset variables.instance.dataTable = trim(arguments.dataTable) />
	<cfreturn this>
</cffunction>

<cffunction name="getQuery" access="public" output="false" returntype="query">
	<cfset var c ="" />
	<cfset var rs ="" />
	<cfset var baseIDList="''">
	<cfset var rsParams=getParams() />
	<cfset var started =false />
	<cfset var param ="" />
	<cfset var openGrouping =false />
	<cfset var dbType=variables.configBean.getDbType() />
	<cfset var nowAdjusted=createDateTime(year(now()),month(now()),day(now()),hour(now()),int((minute(now())/5)*5),0)>
	<cfset var blockFactor=getNextN()>
	<cfset var rsAttribute="">
	<cfset var dataTable=getDataTable()>
	<cfset var tableModifier="">
	<cfset var hasExtendedSort= len(getSortBy()) and getSortBy() neq "random">

	<cfif variables.configBean.getDbType() eq "MSSQL">
		 <cfset tableModifier="with (nolock)">
	 </cfif>
	
	<cfif not len(getSiteID())>
		<cfthrow message="The 'SITEID' value must be set in order to search custom objects.">
	</cfif>
	
	<cfif not len(getType())>
		<cfthrow message="The 'Type' value must be set in order  to search custom objects.">
	</cfif>
	
	<cfif not len(getSubType())>
		<cfthrow message="The 'SubType' value must be set in order  to search custom objects.">
	</cfif>
	
	<cfif blockFactor gt 100>
		<cfset blockFactor=100>
	</cfif>
	
	<!--- Generate a list of baseIDs that match the criteria --->
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	<cfif dbType eq "oracle" and getMaxItems()>select * from (</cfif>
	select distinct <cfif dbtype eq "mssql" and getMaxItems()>top #getMaxItems()#</cfif> 
		tclassextenddata.baseID
		from tclassextenddata
		where siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
		and (tclassextenddata.attributeID IN
			(select tclassextendattributes.attributeID from tclassextendattributes
			INNER JOIN tclassextendsets with (nolock) on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID) 
			INNER JOIN tclassextend with (nolock) on (tclassextendsets.subtypeID=tclassextend.subtypeID) 
			where tclassextend.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
				and tclassextend.type= <cfqueryparam cfsqltype="cf_sql_varchar" value="#getType()#"> 
				and tclassextend.subtype= <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSubType()#">))

		<cfif rsParams.recordcount>	
		<cfset started = false />	
		<cfloop query="rsParams">
			<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
					rsParams.field,
					rsParams.dataType,
					rsParams.condition,
					rsParams.criteria
				) />
		
			<cfif param.getIsValid()>	
				<cfif not started >
					<cfset openGrouping=true />	
					and (
				</cfif>
				<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
					(
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

				<cfif len(param.getField())>	
					<cfif  listLen(param.getField(),".") gt 1>			
						(#param.getField()# #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>)
						<cfset openGrouping=false />
					<cfelseif len(param.getField())>
						<cfif isNumeric(param.getField())>
							(select #dataTable#.baseID from #dataTable# #tableModifier# where attributeID
							= <cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
						<cfelse>
							#dataTable#.baseID
							IN (
							select #dataTable#.baseID from #dataTable# #tableModifier# INNER JOIN tclassextendattributes #tableModifier#
								on (#dataTable#.attributeID = tclassextendattributes.attributeID)
							where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
							and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
						</cfif>
						and <cfif param.getCondition() neq "like">#variables.configBean.getClassExtensionManager().getCastString(param.getField(),getSiteID())#<cfelse>attributeValue</cfif> #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>)
						
						<cfset openGrouping=false />
					</cfif>
				</cfif>
			</cfif>						
		</cfloop>
		<cfif started>)</cfif>
		</cfif>
	</cfquery>

	<!--- convert base query to list --->
	<cfif rs.recordcount>
		<cfset baseIDList = QuotedValueList(rs.baseID)>	
	</cfif>
	
	<!--- generate a sorted (if specified) list of baseIDs with additional fields --->
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select tclassextend.type,tclassextend.subtype,tclassextend.siteID, #dataTable#.baseID as ID
	<cfif hasExtendedSort>,#variables.configBean.getClassExtensionManager().getCastString(getSortBy(),getSiteID())# as extendedSort</cfif>
	from #dataTable# #tableModifier#
	INNER JOIN tclassextendattributes #tableModifier# on (#dataTable#.attributeID=tclassextendattributes.attributeID)
	INNER JOIN tclassextendsets #tableModifier# on (tclassextendattributes.extendsetID=tclassextendsets.extendsetID)
	INNER JOIN tclassextend #tableModifier# on (tclassextendsets.subtypeID=tclassextend.subtypeID)
	where tclassextenddata.baseID IN (#PreserveSingleQuotes(baseIDList)#)
		
	<cfif len(getSortBy())>
		and tclassextendattributes.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSortBy()#">
		<cfswitch expression="#getSortBy()#">
		<cfcase value="random">
			<cfif dbType eq "mysql">
		        order by   rand()
		    <cfelseif dbType eq "mssql">
		        order by  newID()
		    <cfelseif dbType eq "oracle">
		        order by  dbms_random.value
		    </cfif>
		</cfcase>
		<cfdefaultcase>
			<cfif len(getSortBy())>
				order by extendedSort #getSortDirection()#
			</cfif>
		</cfdefaultcase>
		</cfswitch>
	</cfif>
	
	<cfif dbType eq "mysql" and getMaxItems()>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#getMaxItems()#" /> </cfif>
	<cfif dbType eq "oracle" and getMaxItems()>) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#getMaxItems()#" /> </cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

</cfcomponent>
