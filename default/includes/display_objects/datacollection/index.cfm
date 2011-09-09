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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
	<cfif isValid("UUID",arguments.objectID)>
		<cfset bean = $.getBean("content").loadBy(contentID=arguments.objectID,siteID=arguments.siteID)>
	<cfelse>
		<cfset bean = $.getBean("content").loadBy(title=arguments.objectID,siteID=arguments.siteID)>
	</cfif>
	<cfset rsForm=bean.getAllValues()>
	<cfset event.setValue("formBean",bean)>
	
	<cfset rsForm.isOnDisplay=rsForm.display eq 1 or 
			(
				rsForm.display eq 2 and rsForm.DisplayStart lte now()
				AND (rsForm.DisplayStop gte now() or rsForm.DisplayStop eq "")
			)>

	<cfset editableControl.editLink = "">
	<!---
	<cfset editableControl.historyLink = "">
	--->
	<cfset editableControl.innerHTML = "">
	
	<cfif this.showEditableObjects and objectPerm eq 'editor'>
		<cfset $.loadShadowBoxJS()>
		<cfset $.addToHTMLHeadQueue('editableObjects.cfm')>
		<cfif isValid("UUID",arguments.objectID)>
			<cfset bean = $.getBean("content").loadBy(contentID=arguments.objectID)>
		<cfelse>
			<cfset bean = $.getBean("content").loadBy(title=arguments.objectID)>
		</cfif>
		<cfif len(application.configBean.getAdminDomain())>
			<cfif application.configBean.getAdminSSL()>
				<cfset adminBase="https://#application.configBean.getAdminDomain()#"/>
			<cfelse>
				<cfset adminBase="http://#application.configBean.getAdminDomain()#"/>
			</cfif>
		<cfelse>
			<cfset adminBase=""/>
		</cfif>
		
		<cfset editableControl.editLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.edit">
		<cfif structKeyExists(request,"previewID") and len(request.previewID)>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & request.previewID>
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
		<cfset editableControl.editLink = editableControl.editLink & "&amp;homeid=" & $.content('contentID')>
		<!---
		<cfset editableControl.historyLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.hist">
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;siteid=" & bean.getSiteID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;contentid=" & bean.getContentID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;topid=00000000000000000000000000000000001">
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;type=" & bean.getType()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;parentid=" & bean.getParentID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;moduleid=" & bean.getModuleID()>
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;startrow=1">
		<cfset editableControl.historyLink = editableControl.historyLink & "&amp;compactDisplay=true">
		--->
		<cfset editableControl.innerHTML = generateEditableObjectControl(editableControl.editLink)>
	</cfif>
</cfsilent>
<cfoutput>
<cfif editableControl.innerHTML neq "">
	#$.renderEditableObjectHeader("editableForm")#
</cfif>	
<cfif rsForm.isOnDisplay>
	<cfif rsForm.displayTitle neq 0><#getHeaderTag('subHead1')#>#rsForm.title#</#getHeaderTag('subHead1')#></cfif>
	<cfif isdefined('request.formid') and request.formid eq rsform.contentid>
	<cfset acceptdata=1> 
	<cfinclude template="act_add.cfm">
	<cfinclude template="dsp_response.cfm">
	<cfelse>
	<cfset $.addToHTMLHeadQueue("htmlEditor.cfm")>
	<cfif isJSON(rsForm.body)>
		#$.setDynamicContent(
				dspObject_Include(
					thefile='formbuilder/dsp_form.cfm',
					formid=rsForm.contentid,
					siteid=rsForm.siteid,
					formJSON=rsForm.body
				)
		)#
	<cfelse>
	#$.setDynamicContent(application.dataCollectionManager.renderForm(rsForm.contentid,request.siteid,rsForm.body,rsForm.responseChart, $.content('contentID')))#		
	</cfif>
	<script type="text/javascript">
	setHTMLEditors(200,500);
	</script>
	</cfif>
</cfif>
<cfif editableControl.innerHTML neq "">
#renderEditableObjectFooter(editableControl.innerHTML)#
</cfif>
</cfoutput>
<cfif rsForm.isOnDisplay and rsForm.forceSSL eq 1>
<cfset request.forceSSL = 1>
<cfset request.cacheItem=false>
<cfelse>
<cfset request.cacheItem=rsForm.doCache>
</cfif>