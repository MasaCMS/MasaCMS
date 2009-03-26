<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance=structnew() />
<cfset variables.instance.MLID="" />
<cfset variables.instance.SiteID="" />
<cfset variables.instance.Email="" />
<cfset variables.instance.fName="" />
<cfset variables.instance.lName="" />
<cfset variables.instance.Company="" />
<cfset variables.instance.isVerified=0 />


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

</cfcomponent>