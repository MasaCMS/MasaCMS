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
		<cfargument name="property" required="true">
    <cfargument name="propertyValue">
    
    <cfif not isDefined('arguments.reminder')>
      <cfif isSimpleValue(arguments.property)>
        <cfreturn getValue(argumentCollection=arguments)>
      </cfif>

      <cfset arguments.reminder=arguments.property>
    </cfif>
    
		<cfset var prop = "" />
    <cfset var tempFunc="">
		
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
					<cfset tempFunc=this["set#prop#"]>
          <cfset tempFunc(arguments.reminder['#prop#'])>
				</cfif>
			</cfloop>
			
		</cfif>
		
	 </cffunction>
	
	<cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
  	</cffunction>
		
	<cffunction name="validate" access="public" output="false" returntype="void">
		<cfset variables.instance.errors=structnew() /> 
		
		<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}",variables.instance.email) neq 0>
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