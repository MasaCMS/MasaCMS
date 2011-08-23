<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.categoryID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.dateCreated="#now()#"/>
<cfset variables.instance.lastUpdate="#now()#"/>
<cfset variables.instance.lastUpdateBy=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.isInterestGroup=1 />
<cfset variables.instance.parentID="" />
<cfset variables.instance.isActive=1 />
<cfset variables.instance.isOpen=1 />
<cfset variables.instance.notes=""/>
<cfset variables.instance.sortBy = "orderno" />
<cfset variables.instance.sortDirection = "asc" />
<cfset variables.instance.RestrictGroups = "" />
<cfset variables.instance.Path = "" />
<cfset variables.instance.remoteID = "" />
<cfset variables.instance.remoteSourceURL = "" />
<cfset variables.instance.remotePubDate = "">
<cfset variables.instance.URLTitle = "">
<cfset variables.instance.filename = "">
<cfset variables.categoryManager = "" />
<cfset variables.instance.isNew=1 />
<cfset variables.instance.errors=structnew() />

<cfset variables.kids = arrayNew(1) />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="categoryManager" type="any" required="yes"/>
	<cfset variables.categoryManager=arguments.categoryManager>
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="any" output="false" access="public">
		<cfargument name="category" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.category)>
		
			<cfset setcategoryID(arguments.category.categoryID) />
			<cfset setsiteID(arguments.category.siteID) />
			<cfset setdateCreated(arguments.category.dateCreated) />
			<cfset setlastUpdate(arguments.category.lastUpdate) />
			<cfset setlastUpdateby(arguments.category.lastUpdateBy) />
			<cfset setname(arguments.category.name) />
			<cfset setIsInterestGroup(arguments.category.isInterestGroup)/>
			<cfset setParentID(arguments.category.parentID) />
			<cfset setisActive(arguments.category.isActive)/>
			<cfset setisOpen(arguments.category.isOpen)/>
			<cfset setnotes(arguments.category.notes) />
			<cfset setSortBy(arguments.category.sortBy) />
			<cfset setSortDirection(arguments.category.sortDirection) />
			<cfset setRestrictGroups(arguments.category.RestrictGroups) />
			<cfset setPath(arguments.category.Path) />
			<cfset setRemoteID(arguments.category.remoteID) />
			<cfset setRemoteSourceURL(arguments.category.remoteSourceURL) />
			<cfset setRemotePubDate(arguments.category.remotePubDate) />
			<cfset setURLTitle(arguments.category.URLTitle) />
			<cfset setFilename(arguments.category.filename) />
	
		<cfelseif isStruct(arguments.category)>
		
			<cfloop collection="#arguments.category#" item="prop">
				<cfset setValue(prop,arguments.category[prop])>
			</cfloop>
			
		</cfif>
		
		<cfset structDelete(variables.instance,"errors")>
			
		<cfreturn this />
</cffunction>
 
<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" access="public" output="false" returntype="struct">
	<cfreturn variables.instance  />
</cffunction>

<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returntype="any" output="false">
  	<cfif not structKeyExists(variables.instance,"errors")>
		<cfset validate()>  	
	</cfif>
	<cfreturn variables.instance.errors>
</cffunction>

<cffunction name="getCategoryID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.categoryID />
</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfset variables.instance.categoryID = trim(arguments.categoryID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getDateCreated" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dateCreated />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfif isDate(arguments.dateCreated)>
	<cfset variables.instance.dateCreated = parseDateTime(arguments.dateCreated) />
	<cfelse>
	<cfset variables.instance.dateCreated = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getLastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsInterestGroup" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isInterestGroup />
</cffunction>

<cffunction name="setIsInterestGroup" access="public" output="false">
	<cfargument name="isInterestGroup" type="numeric" />
	<cfset variables.instance.isInterestGroup = arguments.isInterestGroup />
	<cfreturn this>
</cffunction>

<cffunction name="getParentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.parentID />
</cffunction>

<cffunction name="setParentID" access="public" output="false">
	<cfargument name="ParentID" type="String" />
	<cfset variables.instance.ParentID = trim(arguments.ParentID) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
	<cfreturn this>
</cffunction>

<cffunction name="getIsOpen" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isOpen />
</cffunction>

<cffunction name="setIsOpen" access="public" output="false">
	<cfargument name="isOpen" type="numeric" />
	<cfset variables.instance.isOpen = arguments.isOpen />
	<cfreturn this>
</cffunction>

<cffunction name="getNotes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Notes />
</cffunction>

<cffunction name="setNotes" access="public" output="false">
	<cfargument name="Notes" type="String" />
	<cfset variables.instance.Notes = trim(arguments.Notes) />
	<cfreturn this>
</cffunction>

 <cffunction name="setSortBy" output="false" access="public">
    <cfargument name="SortBy" type="string" required="true">
    <cfset variables.instance.SortBy = trim(arguments.SortBy) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getSortBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortBy />
  </cffunction>
  
   <cffunction name="setSortDirection" output="false" access="public">
    <cfargument name="SortDirection" type="string" required="true">
    <cfset variables.instance.SortDirection = trim(arguments.SortDirection) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getSortDirection" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortDirection />
  </cffunction>
  
    <cffunction name="setRestrictGroups" output="false" access="public">
    <cfargument name="RestrictGroups" type="string" required="true">
    <cfset variables.instance.RestrictGroups = trim(arguments.RestrictGroups) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getRestrictGroups" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RestrictGroups />
  </cffunction>
  
    <cffunction name="setPath" output="false" access="public">
    <cfargument name="Path" type="string" required="true">
    <cfset variables.instance.Path = trim(arguments.Path) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getPath" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Path />
  </cffunction>

	<cffunction name="save" returnType="any" output="false" access="public">
	<cfset var kid="">
	<cfset var i="">
	<cfset setAllValues(variables.categoryManager.save(this).getAllValues())>
		
	<cfif arrayLen(variables.kids)>
		<cfloop from="1" to="#arrayLen(variables.kids)#" index="i">
			<cfset kid=variables.kids[i]>
			<cfset kid.save()>
		</cfloop>
	</cfif>
	
	<cfset variables.kids=arrayNew(1)>
	
	<cfreturn this />
	</cffunction>
	
	<cffunction name="addChild" output="false">
		<cfargument name="child" hint="Instance of a categoryBean">
		<cfset arguments.child.setSiteID(getSiteID())>
		<cfset arguments.child.setParentID(getContentID())>
		<cfset arrayAppend(variables.kids,arguments.child)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="delete" output="false" access="public">
		<cfset variables.categoryManager.delete(getCategoryID()) />
	</cffunction>
	
	<cffunction name="getKidsQuery" returntype="any" output="false">
		<cfargument name="activeOnly" type="boolean" required="true" default="true">
		<cfargument name="InterestsOnly" type="boolean" required="true" default="false">
		
		<cfreturn variables.categoryManager.getCategories(getSiteID(),getCategoryID(),"", arguments.activeOnly, arguments.InterestsOnly) />
	</cffunction>
	
	<cffunction name="getKidsIterator" returntype="any" output="false">
		<cfargument name="activeOnly" type="boolean" required="true" default="true">
		<cfargument name="InterestsOnly" type="boolean" required="true" default="false">
		<cfset var it=getServiceFactory().getBean("categoryIterator").init()>
		<cfset it.setQuery(getKidsQuery(arguments.activeOnly, arguments.InterestsOnly))>
		<cfreturn it />
	</cffunction>

	<cffunction name="loadBy" returnType="any" output="false" access="public">
		<cfset var response="">
		
		<cfif not structKeyExists(arguments,"siteID")>
			<cfset arguments.siteID=getSiteID()>
		</cfif>
		
		<cfset response=variables.categoryManager.read(argumentCollection=arguments)>

		<cfif isArray(response)>
			<cfset setAllValues(response[1].getAllValues())>
			<cfreturn response>
		<cfelse>
			<cfset setAllValues(response.getAllValues())>
			<cfreturn this>
		</cfif>
	</cffunction>
	
   <cffunction name="setIsNew" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
  </cffunction>

  <cffunction name="getIsNew" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNew />
  </cffunction>

	<cffunction name="setRemoteID" output="false" access="public">
	    <cfargument name="RemoteID" type="string" required="true">
	    <cfset variables.instance.RemoteID = trim(arguments.RemoteID) />
	    <cfreturn this>
	</cffunction>
	
	<cffunction name="getRemoteID" returnType="string" output="false" access="public">
	    <cfreturn variables.instance.RemoteID />
	</cffunction>
	  
	<cffunction name="setRemoteSourceURL" output="false" access="public">
	    <cfargument name="remoteSourceURL" type="string" required="true">
	    <cfset variables.instance.remoteSourceURL = trim(arguments.remoteSourceURL) />
	    <cfreturn this>
	</cffunction>
	
	<cffunction name="getRemoteSourceURL" returnType="string" output="false" access="public">
	    <cfreturn variables.instance.remoteSourceURL />
	 </cffunction>
	 
	<cffunction name="setRemotePubDate" output="false" access="public">
    <cfargument name="RemotePubDate" type="string" required="true">
	<cfif lsisDate(arguments.RemotePubDate)>
		<cftry>
		<cfset variables.instance.RemotePubDate = lsparseDateTime(arguments.RemotePubDate) />
		<cfcatch>
			<cfset variables.instance.RemotePubDate = arguments.RemotePubDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.RemotePubDate = ""/>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getRemotePubDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemotePubDate />
  </cffunction>

	<cffunction name="setURLTitle" output="false" access="public">
	    <cfargument name="URLTitle" type="string" required="true">
	    <cfif arguments.URLTitle neq variables.instance.URLTitle>
	   		<cfset variables.instance.URLTitle = getBean("contentUtility").formatFilename(arguments.URLTitle) />
	    </cfif>
	    <cfreturn this>
	</cffunction>
	
	<cffunction name="getURLTitle" returnType="string" output="false" access="public">
	    <cfreturn variables.instance.URLTitle />
	 </cffunction>
	 
	<cffunction name="setFilename" output="false" access="public">
	    <cfargument name="filename" type="string" required="true">
	    <cfset variables.instance.filename = left(trim(arguments.filename),255) />
	    <cfreturn this>
	</cffunction>
	
	<cffunction name="getFilename" returnType="string" output="false" access="public">
	    <cfreturn variables.instance.filename />
	 </cffunction>

	<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
		
		<cfif isDefined("this.set#arguments.property#")>
			<cfset evaluate("set#property#(arguments.propertyValue)") />
		<cfelse>
			<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
		
		<cfif structKeyExists(this,"get#property#")>
			<cfreturn evaluate("get#property#()") />
		<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
			<cfreturn variables.instance["#arguments.property#"] />
		<cfelse>
			<cfreturn "" />
		</cfif>
	
	</cffunction>
	
	<cffunction name="getParent" output="false" returntype="any">
		<cfif len(getParentID())>
			<cfreturn getBean('category').loadBy(categoryID=getParentID(), siteid=getSiteID() )>
		<cfelse>
			<cfthrow message="Parent category does not exist.">
		</cfif>
	</cffunction>
	
	<cffunction name="getCrumbQuery" output="false" returntype="any">
		<cfargument name="sort" required="true" default="asc">
		<cfreturn variables.categoryManager.getCrumbQuery( getPath(), getSiteID(), arguments.sort) >
	</cffunction>
	
	<cffunction name="getCrumbIterator" output="false" returntype="any">
		<cfargument name="sort" required="true" default="asc">
		<cfset var rs=getCrumbQuery(arguments.sort)>
		<cfset var it=getBean("categoryIterator").init()>
		<cfset it.setQuery(rs)>
		<cfreturn it>
	</cffunction>
	
	<cffunction name="getEditUrl" access="public" returntype="string" output="false">
	<cfargument name="compactDisplay" type="any" required="true" default="false"/>
	<cfset var returnStr="">
	
	<cfset returnStr= "#variables.configBean.getContext()#/admin/?fuseaction=cCategory.edit&categoryID=#getCategoryID()#&parentID=#getParentID()#&siteid=#getSiteID()#&compactDisplay=#arguments.compactdisplay#" >
	
	<cfreturn returnStr>
</cffunction> 

	<cffunction name="hasParent" output="false">
	<cfreturn listLen(getPath()) gt 1>
	</cffunction>
	
	<cffunction name="clone" output="false">
	<cfreturn getBean("category").setAllValues(structCopy(getAllValues()))>
	</cffunction>
</cfcomponent>


