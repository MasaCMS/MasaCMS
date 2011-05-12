<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.userManager="">
<cfset variables.inactive=0>
<cfset variables.isPublic=1>
<cfset variables.groupID="">
<cfset variables.categoryID="">
<cfset variables.siteID="">
<cfset variables.instance.sortBy="lname" />
<cfset variables.instance.sortDirection="asc" />

<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />

<cffunction name="setUserManager" returntype="any" output="false">
<cfargument name="userManager">
<cfset variables.userManager=arguments.userManager>
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

<cffunction name="getQuery" returntype="query" output="false">
	<cfif not len(getSiteID())>
		<cfthrow message="The 'SITEID' value must be set in order to search users.">
	</cfif>
	<cfreturn variables.userManager.getAdvancedSearchQuery(this)>
</cffunction>

<cffunction name="getIterator" returntype="any" output="false">
	<cfset var rs=getQuery()>
	<cfset var it=getServiceFactory().getBean("userIterator")>
	<cfset it.setQuery(rs)>
	<cfreturn it>
</cffunction>

<cffunction name="getInActive" returntype="any" output="false">
	<cfreturn variables.inactive>
</cffunction>

<cffunction name="setInActive" output="false">
	<cfargument name="inactive">
	<cfif isNumeric(arguments.inactive)>
		<cfset variables.inactive=arguments.inactive>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsPublic" returntype="any" output="false">
	<cfreturn variables.isPublic>
</cffunction>

<cffunction name="setIsPublic" output="false">
	<cfargument name="isPublic">
	<cfif isNumeric(arguments.isPublic)>
		<cfset variables.isPublic=arguments.isPublic>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getSiteID" returntype="any" output="false">
	<cfreturn variables.siteID>
</cffunction>

<cffunction name="setSiteID" output="false">
	<cfargument name="siteID">
	<cfset variables.siteID=arguments.siteID>
	<cfreturn this>
</cffunction>

<cffunction name="setGroupID" access="public" output="false">
<cfargument name="groupID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.groupID = trim(arguments.groupID) />
	<cfelse>
		<cfloop list="#arguments.groupID#" index="i">
		<cfif not listFindNoCase(variables.groupID,trim(i))>
	    	<cfset variables.groupID = listAppend(variables.groupID,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
</cffunction>
  
<cffunction name="getGroupID" returnType="string" output="false" access="public">
    <cfreturn variables.groupID />
</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
<cfargument name="categoryID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.categoryID = trim(arguments.categoryID) />
	<cfelse>
		<cfloop list="#arguments.categoryID#" index="i">
		<cfif not listFindNoCase(variables.categoryID,trim(i))>
	    	<cfset variables.categoryID = listAppend(variables.categoryID,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
</cffunction>
  
<cffunction name="getCategoryID" returnType="string" output="false" access="public">
    <cfreturn variables.categoryID />
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


</cfcomponent>