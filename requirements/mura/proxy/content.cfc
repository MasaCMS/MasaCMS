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
<cfcomponent output="false" extends="service">

<cffunction name="call">
	<cfargument name="Event">
	
	<cfif application.permUtility.getModulePerm('00000000000000000000000000000000000',event.getValue('siteID'))>	
		<cfset proceed( event ) >
	<cfelse>
		<cfset event.setValue("__response__", format("access denied",event.getValue("responseFormat")))>
	</cfif>
	
</cffunction>

<cffunction name="getPerm">
	<cfargument name="Event">
	
	<cfset var result=structNew()>
	<cfset var content=event.getValue("content")>
	
	<cfif content.getIsNew()>
		<cfset result.crumbdata=application.contentManager.getCrumbList(content.getParentID(),event.getValue('siteID'))/>
	 	<cfset result.level=application.permUtility.getNodePerm(result.crumbdata) />
	 <cfelse>
		<cfset result.crumbdata=application.contentManager.getCrumbList(content.getContentID(),event.getValue('siteID'))/>
		<cfset result.level=application.permUtility.getNodePerm(result.crumbdata) />
	</cfif>
	
	<cfset result.allowAction=listFindNoCase("Author,Editor",result.level)>
	<cfset event.setValue("perm",result)>
	
	<cfreturn result>
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="event">
	
	<cfset var content="">
	
	<cfif not isBoolean(event.getValue("use404"))>
		<cfset event.setValue("use404",false)>
	</cfif>
	
	<cfif len(event.getValue("contenthistid"))>
		<cfset content=application.contentManager.getcontentVersion(event.getValue("contenthistid"),event.getValue("siteid"),event.getValue("use404"))>
	<cfelseif event.valueExists("filename")>
		<cfset content=application.contentManager.getActiveContentByFilename(event.getValue("filename"),event.getValue("siteid"),event.getValue("use404"))>
	<cfelseif len(event.getValue("remoteID"))>
		<cfset content=application.contentManager.getActiveByRemoteID(event.getValue("remoteid"),event.getValue("siteid"))>
	<cfelseif len(event.getValue("title"))>
		<cfset content=application.contentManager.getActiveByTitle(event.getValue("title"),event.getValue("siteid"))>
	<cfelseif len(event.getValue("urltitle"))>
		<cfset content=application.contentManager.getActiveByTitle(event.getValue("urltitle"),event.getValue("siteid"))>
	<cfelse>
		<cfset content=application.contentManager.getActiveContent(event.getValue("contentid"),event.getValue("siteid"),event.getValue("use404"))>
	</cfif>
	
	<cfset event.setValue('content',content)>
	
	<cfreturn content>
	
</cffunction>

<cffunction name="read" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq "deny">
		<cfset event.setValue("__response__", removeObjects(content.getAllValues()))>
	<cfelse>
		<cfset event.setValue("__response__", "access denied")>
	</cfif>
	
</cffunction>

<cffunction name="save" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		
		<cfif perm.level eq "Author">
			<cfset event.setValue("approved",0)>
		</cfif>
		
		<cfset content.set(event.getAllValues())>
		<cfset content.save()>
		<cfset event.setValue("__response__",  removeObjects(content.getAllValues()))>
	<cfelse>
		<cfset event.setValue("__response__", "false")>
	</cfif>
</cffunction>

<cffunction name="delete" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		<cfset content.delete()>
		<cfset event.setValue("__response__", "true")>
	<cfelse>
		<cfset event.setValue("__response__", "false")>
	</cfif>
</cffunction>

<cffunction name="deleteVersion" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		<cfset content.deleteVersion()>
		<cfset event.setValue("__response__", "true")>
	<cfelse>
		<cfset event.setValue("__response__", "false")>
	</cfif>

</cffunction>

<cffunction name="deleteVersionHistory" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.allowAction>
		<cfset content.deleteVersionHistory()>
	<cfelse>
		<cfset event.setValue("__response__","access denied")>
	</cfif>
</cffunction>

<cffunction name="getKids" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq 'Deny'>
		<cfif not isBoolean(event.getValue("liveOnly"))>
			<cfset event.setValue("__response__", ifOracleFixClobs(content.getKidsQuery()))>
		<cfelse>
			<cfset event.setValue("__response__", ifOracleFixClobs(content.getKidsIterator(liveOnly=event.getValue("liveOnly")).getQuery()))>
		</cfif>
	<cfelse>
		<cfset event.setValue("__response__", "access denied")>
	</cfif>
</cffunction>

<cffunction name="getCategories" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq 'Deny'>
		<cfset event.setValue("__response__", ifOracleFixClobs(content.getCategoriesQuery()))>
	<cfelse>
		<cfset event.setValue("__response__", "access denied")>
	</cfif>
</cffunction>

<cffunction name="getRelatedContent" output="false">
	<cfargument name="event">
	<cfset var content=getBean(event)>
	<cfset var perm=getPerm(event)>
	
	<cfif perm.level neq 'Deny'>
		<cfset event.setValue("__response__", ifOracleFixClobs(content.getRelateContentQuery()))>
	<cfelse>
		<cfset event.setValue("__response__", "access denied")>
	</cfif>
</cffunction>

</cfcomponent>