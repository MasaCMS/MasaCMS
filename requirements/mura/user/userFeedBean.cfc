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
<cfcomponent extends="mura.bean.beanFeed" output="false">

	<cfproperty name="inActive" type="numeric" default="0" required="true" />
	<cfproperty name="isPublic" type="numeric" default="1" required="true" />
	<cfproperty name="groupID" type="string" default="" required="true" />
	<cfproperty name="type" type="numeric" default="2" required="true" />
	<cfproperty name="categoryID" type="string" default="" required="true" />
	<cfproperty name="siteID" type="string" default="" required="true" />
	<cfproperty name="sortBy" type="string" default="lname" required="true" />
	<cfproperty name="sortDirection" type="string" default="asc" required="true" />
	<cfproperty name="bean" type="string" default="user" required="true" />
	
<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.inactive="">
	<cfset variables.instance.isPublic=1>
	<cfset variables.instance.groupID="">
	<cfset variables.instance.type=2>
	<cfset variables.instance.categoryID="">
	<cfset variables.instance.siteID="">
	<cfset variables.instance.bean="user">
	<cfset variables.instance.sortBy="lname" />
	<cfset variables.instance.sortDirection="asc" />
	<cfset variables.instance.table="tusers">
	
	<cfset variables.instance.params=queryNew("param,relationship,field,condition,criteria,dataType","integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfreturn this/>
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

			<cfif structKeyExists(arguments.params,"type")>
				<cfset setType(arguments.params.type)>
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

<cffunction name="getQuery" returntype="query" output="false">
	<cfif not len(variables.instance.siteID)>
		<cfthrow message="The 'SITEID' value must be set in order to search users.">
	</cfif>
	<cfreturn getBean('userManager').getAdvancedSearchQuery(this)>
</cffunction>

<cffunction name="getIterator" returntype="any" output="false">
	<cfset var rs=getQuery()>
	<cfset var it=getBean("userIterator")>
	<cfset it.setQuery(rs,variables.instance.nextN)>
	<cfreturn it>
</cffunction>

<cffunction name="setInActive" output="false">
	<cfargument name="inactive">
	<cfif isNumeric(arguments.inactive)>
		<cfset variables.instance.inactive=arguments.inactive>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setIsPublic" output="false">
	<cfargument name="isPublic">
	<cfif isNumeric(arguments.isPublic)>
		<cfset variables.instance.isPublic=arguments.isPublic>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setType" output="false">
	<cfargument name="type">
	<cfif isNumeric(arguments.type)>
		<cfset variables.instance.type=arguments.type>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setGroupID" access="public" output="false">
<cfargument name="groupID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.instance.groupID = trim(arguments.groupID) />
	<cfelse>
		<cfloop list="#arguments.groupID#" index="i">
		<cfif not listFindNoCase(variables.instance.groupID,trim(i))>
	    	<cfset variables.instance.groupID = listAppend(variables.instance.groupID,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
</cffunction>
  
<cffunction name="setCategoryID" access="public" output="false">
<cfargument name="categoryID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
    <cfif not arguments.append>
		<cfset variables.instance.categoryID = trim(arguments.categoryID) />
	<cfelse>
		<cfloop list="#arguments.categoryID#" index="i">
		<cfif not listFindNoCase(variables.instance.categoryID,trim(i))>
	    	<cfset variables.instance.categoryID = listAppend(variables.instance.categoryID,trim(i)) />
	    </cfif>
	    </cfloop> 
	</cfif>
	<cfreturn this>
</cffunction>
 
</cfcomponent>