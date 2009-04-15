<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">
<cfset variables.instance=structnew() />
<cfset variables.instance.mlid="" />
<cfset variables.instance.name="" />
<cfset variables.instance.siteid="" />
<cfset variables.instance.description="" />
<cfset variables.instance.isPurge=0 />
<cfset variables.instance.isPublic=0 />
<cfset variables.instance.lastUpdate=Now() />
<cfif getAuthUser() neq ''>
<cfset variables.instance.LastUpdateBy = left(listGetAt(getAuthUser(),2,"^"),50) />
<cfset variables.instance.LastUpdateByID = listGetAt(getAuthUser(),1,"^") />
<cfelse>
<cfset variables.instance.LastUpdateBy = "" />
<cfset variables.instance.LastUpdateByID = "" />
</cfif>

<cffunction name="Init" access="public" returntype="any" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
    <cfargument name="List" type="any" required="true">

	<cfset var prop="" />
	
	<cfif isQuery(arguments.list)>
	
		<cfset setMLID(arguments.list.mlid) />
		<cfset setName(arguments.list.name) />
		<cfset setDescription(arguments.list.description) />
		<cfset setIsPurge(arguments.list.ispurge) />
		<cfset setIsPublic(arguments.list.ispublic) />
		<cfset setLastUpdate(arguments.list.lastupdate) />
		<!---<cfset variables.instance.LastUpdateBy = arguments.list.lastupdateby />
		<cfset variables.instance.LastUpdateByID = arguments.list.lastupdateID/>--->
	
	<cfelseif isStruct(arguments.list)>
	
		<cfloop collection="#arguments.list#" item="prop">
			<cfif isdefined("variables.instance.#prop#")>
				<cfset evaluate("set#prop#(arguments.list[prop])") />
			</cfif>
		</cfloop>
		
	</cfif>
 </cffunction>
 
 <cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
 </cffunction>

 <cffunction name="setSiteID" returnType="void" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
  </cffunction>

  <cffunction name="setLastUpdate" returnType="void" output="false" access="public">
    <cfargument name="LastUpdate" type="string" required="true">
	<cfif isDate(arguments.LastUpdate)>
    <cfset variables.instance.LastUpdate = parseDateTime(arguments.LastUpdate) />
	<cfelse>
	<cfset variables.instance.LastUpdate = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getLastUpdate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdate />
  </cffunction>
 
  <cffunction name="setIsPurge" returnType="void" output="false" access="public">
    <cfargument name="IsPurge" type="numeric" required="true">
    <cfset variables.instance.IsPurge = arguments.IsPurge />
  </cffunction>

  <cffunction name="getIsPurge" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsPurge />
  </cffunction>

  <cffunction name="setIsPublic" returnType="void" output="false" access="public">
    <cfargument name="IsPublic" type="numeric" required="true">
    <cfset variables.instance.IsPublic = arguments.IsPublic />
  </cffunction>

  <cffunction name="getIsPublic" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsPublic />
  </cffunction>

  <cffunction name="setDescription" returnType="void" output="false" access="public">
    <cfargument name="Description" type="string" required="true">
    <cfset variables.instance.Description = trim(arguments.Description) />
  </cffunction>

  <cffunction name="getDescription" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Description />
  </cffunction>
 
 <cffunction name="setName" returnType="void" output="false" access="public">
    <cfargument name="Name" type="string" required="true">
    <cfset variables.instance.Name = trim(arguments.Name) />
  </cffunction>

  <cffunction name="getName" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Name />
  </cffunction>
  
 <cffunction name="setMLID" returnType="void" output="false" access="public">
    <cfargument name="MLID" type="string" required="true">
    <cfset variables.instance.MLID = trim(arguments.MLID) />
  </cffunction>

  <cffunction name="getMLID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.MLID)>
		<cfset variables.instance.MLID = createUUID() />
	</cfif>
	<cfreturn variables.instance.MLID />
  </cffunction>
 

  <cffunction name="setLastUpdateBy" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateBy" type="string" required="true">
    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
  </cffunction>

  <cffunction name="getLastUpdateBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateBy />
  </cffunction>
  
  <cffunction name="setLastUpdateByID" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateByID" type="string" required="true">
    <cfset variables.instance.LastUpdateByID = trim(arguments.LastUpdateByID) />
  </cffunction>

  <cffunction name="getLastUpdateByID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateByID />
  </cffunction>

</cfcomponent>