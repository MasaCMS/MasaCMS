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

<cfset variables.instance.creativeID=""/>
<cfset variables.instance.userID=""/>
<cfset variables.instance.dateCreated="#now()#"/>
<cfset variables.instance.lastUpdate="#now()#"/>
<cfset variables.instance.lastUpdateBy=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.creativeType=""/>
<cfset variables.instance.fileID=""/>
<cfset variables.instance.mediaType=""/>
<cfset variables.instance.redirectURL=""/>
<cfset variables.instance.altText=""/>
<cfset variables.instance.notes=""/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.height=0/>
<cfset variables.instance.width=0/>
<cfset variables.instance.textBody=""/>
<cfset variables.instance.fileExt=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.target="_blank"/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="creative" type="any" required="true">
		
		<cfset var prop = ""/>

		<cfif isquery(arguments.creative)>
		
			<cfset setcreativeID(arguments.creative.creativeID) />
			<cfset setuserID(arguments.creative.userID) />
			<cfset setname(arguments.creative.name) />
			<cfset setdateCreated(arguments.creative.dateCreated) />
			<cfset setlastUpdate(arguments.creative.lastUpdate) />
			<cfset setlastUpdateBy(arguments.creative.lastUpdateBy) />
			<cfset setFileID(arguments.creative.fileID) />
			<cfset setmediaType(arguments.creative.mediaType) />
			<cfset setcreativeType(arguments.creative.creativeType) />
			<cfset setredirectURL(arguments.creative.redirectURL) />
			<cfset setaltText(arguments.creative.altText) />
			<cfset setnotes(arguments.creative.notes) />
			<cfset setisActive(arguments.creative.isActive) />
			<cfset setheight(arguments.creative.height) />
			<cfset setwidth(arguments.creative.width) />
			<cfset setTextBody(arguments.creative.textBody) />
			<cfset setFileExt(arguments.creative.fileExt) />
			<cfset setSiteID(arguments.creative.SiteID) />
			<cfset setTarget(arguments.creative.target) />
			
		<cfelseif isStruct(arguments.creative)>
		
			<cfloop collection="#arguments.creative#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.creative[prop])") />
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

<cffunction name="getCreativeID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.creativeID)>
		<cfset variables.instance.creativeID = createUUID() />
	</cfif>
	<cfreturn variables.instance.creativeID />
</cffunction>

<cffunction name="setCreativeID" access="public" output="false">
	<cfargument name="creativeID" type="String" />
	<cfset variables.instance.creativeID = trim(arguments.creativeID) />
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
	</cfif>
</cffunction>

<cffunction name="getLastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	</cfif>
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
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

<cffunction name="getCreativeType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.creativeType />
</cffunction>

<cffunction name="setCreativeType" access="public" output="false">
	<cfargument name="creativeType" type="String" />
	<cfset variables.instance.creativeType = trim(arguments.creativeType) />
</cffunction>

<cffunction name="getMediaType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mediaType />
</cffunction>

<cffunction name="setMediaType" access="public" output="false">
	<cfargument name="mediaType" type="String" />
	<cfset variables.instance.mediaType = trim(arguments.mediaType) />
</cffunction>

<cffunction name="getRedirectURL" returntype="String" access="public" output="false">
	<cfreturn variables.instance.redirectURL />
</cffunction>

<cffunction name="setRedirectURL" access="public" output="false">
	<cfargument name="redirectURL" type="String" />
	<cfset variables.instance.redirectURL = trim(arguments.redirectURL) />
</cffunction>

<cffunction name="getFileID" returntype="string" access="public" output="false">
	<cfreturn variables.instance.fileID />
</cffunction>

<cffunction name="setFileID" access="public" output="false">
	<cfargument name="fileID" type="string" />
	<cfset variables.instance.fileID = arguments.fileID />
</cffunction>

<cffunction name="getAltText" returntype="String" access="public" output="false">
	<cfreturn variables.instance.altText />
</cffunction>

<cffunction name="setAltText" access="public" output="false">
	<cfargument name="altText" type="String" />
	<cfset variables.instance.altText = trim(arguments.altText) />
</cffunction>

<cffunction name="getNotes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.notes />
</cffunction>

<cffunction name="setNotes" access="public" output="false">
	<cfargument name="notes" type="String" />
	<cfset variables.instance.notes = trim(arguments.notes) />
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
</cffunction>

<cffunction name="getHeight" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.height />
</cffunction>

<cffunction name="setHeight" access="public" output="false">
	<cfargument name="height" type="numeric" />
	<cfset variables.instance.height = arguments.height />
</cffunction>

<cffunction name="getWidth" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.width />
</cffunction>

<cffunction name="setWidth" access="public" output="false">
	<cfargument name="width" type="numeric" />
	<cfset variables.instance.width = arguments.width />
</cffunction>

<cffunction name="getTextBody" returntype="String" access="public" output="false">
	<cfreturn variables.instance.textBody />
</cffunction>

<cffunction name="setTextBody" access="public" output="false">
	<cfargument name="textBody" type="String" />
	<cfset variables.instance.textBody = trim(arguments.textBody) />
</cffunction>


<cffunction name="getFileExt" returntype="String" access="public" output="false">
	<cfreturn variables.instance.FileExt />
</cffunction>

<cffunction name="setFileExt" access="public" output="false">
	<cfargument name="FileExt" type="String" />
	<cfset variables.instance.FileExt = trim(arguments.FileExt) />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = trim(arguments.SiteID) />
</cffunction> 

<cffunction name="getTarget" returntype="String" access="public" output="false">
	<cfreturn variables.instance.target />
</cffunction>

<cffunction name="setTarget" access="public" output="false">
	<cfargument name="target" type="String" />
	<cfif len(arguments.target)>
	<cfset variables.instance.target = trim(arguments.target) />
	</cfif>
</cffunction>

</cfcomponent>