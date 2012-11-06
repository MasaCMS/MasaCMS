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
<cfsilent>
	<cfif isValid("UUID",arguments.objectID)>
		<cfset bean = variables.$.getBean("content").loadBy(contentID=arguments.objectID,siteID=arguments.siteID)>
	<cfelse>
		<cfset bean = variables.$.getBean("content").loadBy(title=arguments.objectID,siteID=arguments.siteID,type='Component')>
	</cfif>
	
	<cfset variables.rsTemplate=bean.getAllValues()>
	<cfset variables.event.setValue("component",variables.rsTemplate)>
	
	<!---<cfset variables._component=variables.$.event("component")>
	
	<cfif isStruct(variables._component)>
		<cfset structAppend(variables._component,variables.rsTemplate,true)>
	<cfelse>
		<cfset event.setValue("component",variables.rsTemplate)>
	</cfif>--->
	
	<cfset variables.rsTemplate.isOnDisplay=variables.rsTemplate.display eq 1 or 
			(
				variables.rsTemplate.display eq 2 and variables.rsTemplate.DisplayStart lte now()
				AND (variables.rsTemplate.DisplayStop gte now() or variables.rsTemplate.DisplayStop eq "")
			)
			and listFind(variables.rsTemplate.moduleAssign,'00000000000000000000000000000000000')>

	
	<cfset editableControl.editLink = "">
	<!---
	<cfset editableControl.historyLink = "">
	--->
	<cfset editableControl.innerHTML = "">

	<cfif not bean.getIsNew() and this.showEditableObjects  and arguments.objectPerm eq 'editor'>
		<cfset variables.$.loadShadowBoxJS()>
		<cfset variables.$.addToHTMLHeadQueue('editableObjects.cfm')>
		<cfif len(application.configBean.getAdminDomain())>
			<cfif application.configBean.getAdminSSL()>
				<cfset variables.adminBase="https://#application.configBean.getAdminDomain()#"/>
			<cfelse>
				<cfset variables.adminBase="http://#application.configBean.getAdminDomain()#"/>
			</cfif>
		<cfelse>
			<cfset variables.adminBase=""/>
		</cfif>
		
		<cfset editableControl.editLink = variables.adminBase & "#variables.$.globalConfig('context')#/admin/index.cfm?fuseaction=cArch.edit">
		<cfif len(variables.$.event('previewID'))>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & variables.$.event('previewID')>
		<cfelse>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & bean.getContentHistID()>
		</cfif>
		
		<cfset editableControl.editLink = editableControl.editLink & "&amp;siteid=" & bean.getSiteID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;contentid=" & bean.getContentID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;topid=00000000000000000000000000000000001">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;type=" & bean.getType()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;parentid=" & bean.getParentID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;moduleid=" & bean.getModuleID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;compactDisplay=true">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;homeid=" & variables.$.content('contentID')>
		<!---
		<cfset editableControl.historyLink = adminBase & "#variables.$.globalConfig('context')#/admin/index.cfm?fuseaction=cArch.hist">
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;siteid=" & bean.getSiteID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;contentid=" & bean.getContentID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;topid=00000000000000000000000000000000001">
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;type=" & bean.getType()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;parentid=" & bean.getParentID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;moduleid=" & bean.getModuleID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;startrow=1">
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;compactDisplay=true">
		--->
		<cfset editableControl.innerHTML = variables.$.generateEditableObjectControl(editableControl.editLink)>
	</cfif>
</cfsilent>


<cfif editableControl.innerHTML neq "">
	<cfoutput>#variables.$.renderEditableObjectHeader("editableComponent")#</cfoutput>
</cfif>
<cfif variables.rsTemplate.isOnDisplay>
	<cfset variables.componentOutput=application.pluginManager.renderEvent("onComponent#bean.getSubType()#BodyRender",variables.event)>
	<cfif len(variables.componentOutput)>
		<cfoutput>#variables.componentOutput#</cfoutput>
		<cfelse>
		<cfif len(variables.rsTemplate.template) and fileExists("#getSite().getTemplateIncludeDir()#/components/#variables.rsTemplate.template#")>
			<cfset variables.componentBody=variables.rsTemplate.body>
			<cfinclude template="#getSite().getTemplateIncludePath()#/components/#variables.rsTemplate.template#">
		<cfelse>
			<cfoutput>#variables.$.setDynamicContent(variables.rsTemplate.body)#</cfoutput>
		</cfif>
	</cfif>
</cfif>
<cfif editableControl.innerHTML neq "">
	<cfoutput>#variables.$.renderEditableObjectFooter(editableControl.innerHTML)#</cfoutput>
</cfif>
<cfif not variables.rsTemplate.doCache>
	<cfset request.cacheItem=variables.rsTemplate.doCache/>
</cfif>
