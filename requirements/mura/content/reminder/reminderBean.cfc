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

<cfset variables.instance=structNew() />
<cfset variables.instance.contentid=""/>
<cfset variables.instance.email=""/>
<cfset variables.instance.isSent=0/>
<cfset variables.instance.remindHour=0 />
<cfset variables.instance.remindMinute=0 />
<cfset variables.instance.siteID="" />
<cfset variables.instance.errors=structnew() />
<cfset variables.instance.isNew=1/>
<cfset variables.instance.RemindInterval=0/>

<cffunction name="init" returntype="any" output="false" access="public">
	<cfreturn this />
	</cffunction>

 	<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="reminder" type="any" required="true">

		<cfset var prop = "" />
		
		<cfif isquery(arguments.reminder)>
		
			<cfset setcontentID(arguments.reminder.contentid) />
			<cfset setEmail(arguments.reminder.email) />
			<cfset setIsSent(arguments.reminder.isSent) />
			<cfset setRemindHour(arguments.reminder.remindHour) />
			<cfset setRemindMinute(arguments.reminder.remindMinute) />
			<cfset setSiteID(arguments.reminder.siteID) />
			<cfset setRemindInterval(arguments.reminder.RemindInterval) />
			
		<cfelseif isStruct(arguments.reminder)>
		
			<cfloop collection="#arguments.reminder#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.reminder[prop])") />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset validate() />
	 </cffunction>
	
	<cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
  	</cffunction>
		
	<cffunction name="validate" access="public" output="false" returntype="void">
		<cfset variables.instance.errors=structnew() /> 
		
		<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{2,255}\.[^@%*<>' ]{2,5}",variables.instance.email) neq 0>
		<cfset variables.instance.errors.email="The 'email' address that you provided mus be in a valid format."/>
		</cfif>
		
     </cffunction>

	<cffunction name="setcontentId" returnType="void" output="false" access="public">
    <cfargument name="ContentId" type="string" required="true">
    <cfset variables.instance.ContentId = trim(arguments.ContentId) />
  	</cffunction>

  	<cffunction name="getcontentId" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContentId />
  	</cffunction>
	
	<cffunction name="setEmail" returnType="void" output="false" access="public">
    <cfargument name="Email" type="string" required="true">
    <cfset variables.instance.Email = trim(arguments.Email) />
  	</cffunction>

  	<cffunction name="getEmail" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Email />
  	</cffunction>

	<cffunction name="setIsSent" returnType="void" output="false" access="public">
    <cfargument name="IsSent" type="numeric" required="true">
    <cfset variables.instance.IsSent =arguments.IsSent />
  	</cffunction>

  	<cffunction name="getIsSent" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsSent />
  	</cffunction>
	
	<cffunction name="setRemindDate" returnType="void" output="false" access="public">
    <cfargument name="RemindDat" type="string" required="true">
    <cfset variables.instance.RemindDat = trim(arguments.RemindDat) />
  	</cffunction>

  	<cffunction name="getRemindDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemindDat />
  	</cffunction>
	
	<cffunction name="setRemindHour" returnType="void" output="false" access="public">
    <cfargument name="RemindHour" type="numeric" required="true">
    <cfset variables.instance.RemindHour =arguments.RemindHour />
  	</cffunction>

  	<cffunction name="getRemindHour" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.RemindHour />
  	</cffunction>
	
	<cffunction name="setRemindMinute" returnType="void" output="false" access="public">
    <cfargument name="RemindMinute" type="numeric" required="true">
    <cfset variables.instance.RemindMinute =arguments.RemindMinute />
  	</cffunction>

  	<cffunction name="getRemindMinute" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.RemindMinute />
  	</cffunction>
	
		<cffunction name="setSiteID" returnType="void" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
  	</cffunction>

  	<cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
  	</cffunction>
	
	     <cffunction name="setIsNew" returnType="void" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
  </cffunction>

  <cffunction name="getIsNew" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNew />
  </cffunction>
  
  	     <cffunction name="setRemindInterval" returnType="void" output="false" access="public">
    <cfargument name="RemindInterval" type="numeric" required="true">
    <cfset variables.instance.RemindInterval = arguments.RemindInterval />
  </cffunction>

  <cffunction name="getRemindInterval" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.RemindInterval />
  </cffunction>
	
</cfcomponent>