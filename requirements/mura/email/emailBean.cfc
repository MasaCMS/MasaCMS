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
<cfset variables.instance.emailID="" />
<cfset variables.instance.siteid="" />
<cfset variables.instance.subject="" />
<cfset variables.instance.bodyhtml="" />
<cfset variables.instance.bodytext="" />
<cfset variables.instance.format="" />
<cfset variables.instance.createdDate="#now()#" />
<cfset variables.instance.deliveryDate="" />
<cfset variables.instance.status="" />
<cfset variables.instance.groupID="" />
<cfset variables.instance.LastUpdateBy = "" />
<cfset variables.instance.LastUpdateByID = "" />
<cfset variables.instance.numberSent=0 />
<cfset variables.instance.ReplyTo="" />
<cfset variables.instance.FromLabel="" />

<cffunction name="Init" access="public" returntype="any" output="false">	
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
    <cfargument name="Email" type="any" required="true" default="">
	
	<cfset var prop="" />

	<cfif isQuery(arguments.email)>
	
		<cfset setEmailID(email.emailid) />
		<cfset setSiteid(email.siteid) />
		<cfset setSubject(email.subject) />
		<cfset setBodyhtml(email.bodyhtml) />
		<cfset setBodytext(email.bodytext) />
		<cfset setCreatedDate(email.createdDate) />
		<cfset setDeliveryDate(email.DeliveryDate) />
		<cfset setStatus(email.status) />
		<cfset setgroupID(email.GroupList) />
		<cfset setLastUpdateBy(email.LastUpdateBy) />
		<cfset setLastUpdateByID(email.LastUpdateByID) />
		<cfset setNumberSent(email.numberSent) />
		<cfset setReplyTo(email.ReplyTo) />
		<cfset setFormat(email.Format) />
		<cfset setFromLabel(email.fromLabel) />
		
	<cfelseif isStruct(arguments.email)>
	
		<cfloop collection="#arguments.email#" item="prop">
			<cfif isdefined("variables.instance.#prop#")>
				<cfset evaluate("set#prop#(arguments.email[prop])") />
			</cfif>
		</cfloop>
			
	</cfif>
 </cffunction>

  <cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
  </cffunction>

  <cffunction name="setEmailID" returnType="void" output="false" access="public">
    <cfargument name="EmailID" type="string" required="true">
    <cfset variables.instance.EmailID = trim(arguments.EmailID) />
  </cffunction>

  <cffunction name="getEmailID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.EmailID)>
		<cfset variables.instance.EmailID = createUUID() />
	</cfif>
	<cfreturn variables.instance.EmailID />
  </cffunction>
  
  <cffunction name="setSiteID" returnType="void" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
  </cffunction>
 
  <cffunction name="setSubject" returnType="void" output="false" access="public">
    <cfargument name="Subject" type="string" required="true">
    <cfset variables.instance.Subject = trim(arguments.Subject) />
  </cffunction>

  <cffunction name="getSubject" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Subject />
  </cffunction>
  
   <cffunction name="setBodyHtml" returnType="void" output="false" access="public">
    <cfargument name="BodyHtml" type="string" required="true">
    <cfset variables.instance.BodyHtml = trim(arguments.BodyHtml) />
  </cffunction>

  <cffunction name="getBodyHtml" returnType="string" output="false" access="public">
    <cfreturn variables.instance.BodyHtml />
  </cffunction>
  
   <cffunction name="setBodyText" returnType="void" output="false" access="public">
    <cfargument name="BodyText" type="string" required="true">
    <cfset variables.instance.BodyText = trim(arguments.BodyText) />
  </cffunction>

  <cffunction name="getBodyText" returnType="string" output="false" access="public">
    <cfreturn variables.instance.BodyText />
  </cffunction>

   <cffunction name="setCreatedDate" returnType="void" output="false" access="public">
    <cfargument name="CreatedDate" type="string" required="true">
	<cfif isDate(arguments.CreatedDate)>
    <cfset variables.instance.CreatedDate = parseDateTime(arguments.CreatedDate) />
	<cfelse>
	<cfset variables.instance.CreatedDate = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getCreatedDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.CreatedDate />
  </cffunction>
  
   <cffunction name="setDeliveryDate" returnType="void" output="false" access="public">
    <cfargument name="DeliveryDate" type="string" required="true">
	<cfif lsisDate(arguments.DeliveryDate)>
		<cftry>
		<cfset variables.instance.DeliveryDate = lsparseDateTime(arguments.DeliveryDate) />
		<cfcatch>
			<cfset variables.instance.DeliveryDate = arguments.DeliveryDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.DeliveryDate = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getDeliveryDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.DeliveryDate />
  </cffunction>
  
   <cffunction name="setStatus" returnType="void" output="false" access="public">
    <cfargument name="Status" type="numeric" required="true">
    <cfset variables.instance.Status = arguments.Status />
  </cffunction>

  <cffunction name="getStatus" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Status />
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

   <cffunction name="setNumberSent" returnType="void" output="false" access="public">
    <cfargument name="NumberSent" type="numeric" required="true">
    <cfset variables.instance.NumberSent = arguments.NumberSent />
  </cffunction>

  <cffunction name="getNumberSent" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.NumberSent />
  </cffunction>

  <cffunction name="getReplyTo" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ReplyTo />
  </cffunction>
  
  <cffunction name="setReplyTo" returnType="void" output="false" access="public">
    <cfargument name="ReplyTo" type="string" required="true">
    <cfset variables.instance.ReplyTo = trim(arguments.ReplyTo) />
  </cffunction>

  <cffunction name="getGroupID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.GroupID />
  </cffunction>
  
  <cffunction name="setGroupID" returnType="void" output="false" access="public">
    <cfargument name="GroupList" type="string" required="true" default="">
    <cfset variables.instance.GroupID = trim(arguments.GroupList) />
  </cffunction>
  
    <cffunction name="getFormat" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Format />
  </cffunction>
  
  <cffunction name="setFormat" returnType="void" output="false" access="public">
    <cfargument name="Format" type="string" required="true">
    <cfset variables.instance.Format = trim(arguments.Format) />
  </cffunction>
    
    <cffunction name="getFromLabel" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FromLabel />
  </cffunction>
  
  <cffunction name="setFromLabel" returnType="void" output="false" access="public">
    <cfargument name="FromLabel" type="string" required="true">
    <cfset variables.instance.FromLabel = trim(arguments.FromLabel) />
  </cffunction>


</cfcomponent>