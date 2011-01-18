<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.
	
	As a special exception to the terms and conditions of version 2.0 of
	the GPL, you may redistribute this Program as described in Mura CMS'
	Plugin exception. You should have recieved a copy of the text describing
	this exception, and it is also available here:
	'http://www.getmura.com/exceptions.txt"

	 --->
<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset var renderer=event.getValue("contentRenderer")>
	<cfset var themeRenderer=event.getValue("themeRenderer")>
	
	<cfif event.valueExists('previewID')>
		<cfset event.getHandler("standardSetPreview").handle(event)>
	<cfelse>
		<cfset event.getHandler("standardSetAdTracking").handle(event)>
		
		<cfif len(event.getValue('linkServID'))>
			<cfset event.setValue('contentBean',application.contentManager.getActiveContent(event.getValue('linkServID'),event.getValue('siteid'),true)) />
		<cfelse>
			<cfset event.setValue('contentBean',application.contentManager.getActiveContentByFilename(event.getValue('currentFilenameAdjusted'),event.getValue('siteid'),true)) />
		</cfif>
	</cfif>
	
	<cfset event.getValidator("standard404").validate(event)>
	
	<cfset event.setValue('forceSSL',event.getValue('contentBean').getForceSSL())/>
	
	<cfset event.setValue('crumbdata',application.contentGateway.getCrumbList(event.getValue('contentBean').getcontentid(),event.getContentBean().getSiteID(),true,event.getValue('contentBean').getPath())) />
	
	<cfset renderer.crumbdata=event.getValue("crumbdata")>
	
	<cfif isObject(themeRenderer)>
		<cfset themeRenderer.crumbdata=event.getValue("crumbdata")>
	</cfif>
</cffunction>

</cfcomponent>