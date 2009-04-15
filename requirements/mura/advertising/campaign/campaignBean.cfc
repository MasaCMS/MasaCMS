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

<cfset variables.instance.campaignID=""/>
<cfset variables.instance.userID=""/>
<cfset variables.instance.dateCreated="#now()#"/>
<cfset variables.instance.lastUpdate="#now()#"/>
<cfset variables.instance.lastUpdateBy=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.startDate=""/>
<cfset variables.instance.endDate=""/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.notes=""/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfreturn this />
</cffunction>

 <cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="campaign" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.campaign)>
		
			<cfset setCampaignID(arguments.campaign.campaignID) />
			<cfset setUserID(arguments.campaign.userID) />
			<cfset setName(arguments.campaign.name) />
			<cfset setDateCreated(arguments.campaign.dateCreated) />
			<cfset setLastUpdate(arguments.campaign.lastUpdate) />
			<cfset setLastUpdateBy(arguments.campaign.lastUpdateBy) />
			<cfset setStartDate(arguments.campaign.startDate) />
			<cfset setEndDate(arguments.campaign.endDate) />
			<cfset setIsActive(arguments.campaign.isActive) />
			<cfset setNotes(arguments.campaign.notes) />
		
		<cfelseif isStruct(arguments.campaign)>
		
			<cfloop collection="#arguments.campaign#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.campaign[prop])") />
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
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
	<cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getCampaignID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.campaignID)>
		<cfset variables.instance.campaignID = createUUID() />
	</cfif>
	<cfreturn variables.instance.campaignID />
</cffunction>

<cffunction name="setCampaignID" access="public" output="false">
	<cfargument name="campaignID" type="String" />
	<cfset variables.instance.campaignID = trim(arguments.campaignID) />
</cffunction>

<cffunction name="getUserID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.userID />
</cffunction>

<cffunction name="setUserID" access="public" output="false">
	<cfargument name="userID" type="String" />
	<cfset variables.instance.userID = trim(arguments.userID) />
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
</cffunction>

<cffunction name="getlastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setLastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
</cffunction>

<cffunction name="getStartDate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.startDate />
</cffunction>

<cffunction name="setStartDate" access="public" output="false">
	<cfargument name="startDate" type="String" />
	<cfif lsisDate(arguments.startDate)>
		<cftry>
		<cfset variables.instance.startDate = lsparseDateTime(arguments.startDate) />
		<cfcatch>
			<cfset variables.instance.startDate = arguments.startDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.startDate = ""/>
	</cfif>
</cffunction>

<cffunction name="getEndDate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.endDate />
</cffunction>

<cffunction name="setEndDate" access="public" output="false">
	<cfargument name="endDate" type="String" />
	<cfif lsisDate(arguments.endDate)>
		<cftry>
		<cfset variables.instance.endDate = lsparseDateTime(arguments.endDate) />
		<cfcatch>
			<cfset variables.instance.endDate = arguments.endDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.endDate = ""/>
	</cfif>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
</cffunction>

<cffunction name="getNotes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Notes />
</cffunction>

<cffunction name="setNotes" access="public" output="false">
	<cfargument name="notes" type="String" />
	<cfset variables.instance.notes = trim(arguments.Notes) />
</cffunction>

</cfcomponent>