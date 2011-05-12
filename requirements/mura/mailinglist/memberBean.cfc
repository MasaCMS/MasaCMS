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

<cfset variables.instance=structnew() />
<cfset variables.instance.MLID="" />
<cfset variables.instance.SiteID="" />
<cfset variables.instance.Email="" />
<cfset variables.instance.fName="" />
<cfset variables.instance.lName="" />
<cfset variables.instance.Company="" />
<cfset variables.instance.isVerified=0 />
<cfset variables.instance.created="" />

<cffunction name="Init" access="public" returntype="any" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
    <cfargument name="Member" type="any" required="true">

	<cfset var prop="" />
	
	<cfif isQuery(arguments.Member)>
	
		<cfset setMLID(arguments.Member.mlid) />
		<cfset setEmail(arguments.Member.email) />
		<cfset setSiteID(arguments.Member.SiteID) />
		<cfset setFName(arguments.Member.fName) />
		<cfset setLName(arguments.Member.lName) />
		<cfset setCompany(arguments.Member.company) />
		<cfset setIsVerified(arguments.Member.isVerified) />
		<cfset setCreated(arguments.Member.created) />

	
	<cfelseif isStruct(arguments.Member)>
	
		<cfloop collection="#arguments.Member#" item="prop">
			<cfif isdefined("variables.instance.#prop#")>
				<cfset evaluate("set#prop#(arguments.member[prop])") />
			</cfif>
		</cfloop>
		
	</cfif>
 </cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>


<cffunction name="getMLID" returntype="String" output="false" >
	<cfreturn variables.instance.MLID />
</cffunction>

<cffunction name="setMLID" output="false" access="public">
	<cfargument  name="MLID" type="String" />
	<cfset variables.instance.MLID = arguments.MLID />
</cffunction>

<cffunction name="getSiteID" returntype="String" output="false" access="public" >
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID">
	<cfargument  name="SiteID" type="String"  />
	<cfset variables.instance.SiteID = arguments.SiteID />
</cffunction>
  
<cffunction name="getEmail" returntype="String" output="false" access="public" >
	<cfreturn variables.instance.Email />
</cffunction>

<cffunction name="setEmail" output="false" access="public" >
	<cfargument  name="Email" type="String" />
	<cfset variables.instance.Email = arguments.Email />
</cffunction>

<cffunction name="getFName" returntype="String" output="false" access="public" >
	<cfreturn variables.instance.fName />
</cffunction>

<cffunction name="setFName" output="false" access="public" >
	<cfargument  name="fName" type="String" />
	<cfset variables.instance.fName = arguments.fName />
</cffunction>

<cffunction name="getLName" returntype="String" output="false" access="public" >
	<cfreturn variables.instance.lName />
</cffunction>

<cffunction name="setLName" output="false" access="public">
	<cfargument  name="lName" type="String" />
	<cfset variables.instance.lName = arguments.lName />
</cffunction>

<cffunction name="getCompany" returntype="String" output="false" access="public" >
	<cfreturn variables.instance.Company />
</cffunction>

<cffunction name="setCompany" output="false" access="public" >
	<cfargument  name="Company" type="String" />
	<cfset variables.instance.Company = arguments.Company />
</cffunction>

<cffunction name="getIsVerified" returntype="boolean" output="false" access="public" >
	<cfreturn variables.instance.isVerified />
</cffunction>

<cffunction name="setIsVerified" output="false" access="public" >
	<cfargument name="isVerified" type="boolean" />
	<cfset variables.instance.isVerified = arguments.isVerified />
</cffunction>

<cffunction name="setCreated" output="false" access="public">
    <cfargument name="Created" type="string" required="true">
	<cfif lsisDate(arguments.created)>
		<cftry>
		<cfset variables.instance.created = lsparseDateTime(arguments.created) />
		<cfcatch>
			<cfset variables.instance.created = arguments.created />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.created = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getCreated" returnType="string" output="false" access="public">
    <cfreturn variables.instance.created />
</cffunction>

</cfcomponent>