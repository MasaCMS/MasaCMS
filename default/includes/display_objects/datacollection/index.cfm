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

<cfsilent>
	<cfset bean = application.contentManager.getActiveContent(arguments.objectID, arguments.siteID)>
	<cfset rsForm=bean.getAllValues()>
	<cfset rsForm.isOnDisplay=rsForm.display eq 1 or 
			(
				rsForm.display eq 1 and rsForm.DisplayStart lte now()
				AND (rsForm.DisplayStop gte now() or rsForm.DisplayStop eq null)
			)>
<!---	
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsForm">
select contentid,title,body,responseChart,responseMessage,responseSendTo,forceSSL,displayTitle, doCache
 from tcontent 
where siteid='#request.siteid#' and 
				    (
					(tcontent.Active = 1
					  AND tcontent.DisplayStart <= #createodbcdate(now())#
					  AND (tcontent.DisplayStop >= #createodbcdate(now())# or tcontent.DisplayStop is null)
					  AND tcontent.Display = 2
					  AND tcontent.Approved = 1
					  AND tcontent.contentid = '#arguments.objectid#')
					  or
					  
                      (tcontent.Active = 1
					  AND tcontent.Display = 1
					  AND tcontent.Approved = 1
					  AND tcontent.contentid = '#arguments.objectid#')
					  
					 ) 
					</cfquery>

--->
	
	<cfset editableControl.editLink = "">
	<!---
	<cfset editableControl.historyLink = "">
	--->
	<cfset editableControl.innerHTML = "">
	
	<cfif this.showEditableObjects and objectPerm eq 'editor'>
		<cfset loadShadowBoxJS()>
		<cfset addToHTMLHeadQueue('editableObjects.cfm')>
		<cfset bean = application.contentManager.getActiveContent(arguments.objectID, arguments.siteID)>
		
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
<cfif rsForm.isOnDisplay>
<cfset request.cacheItem=rsForm.doCache>
<cfif rsForm.forceSSL eq 1>
<cfset request.forceSSL = 1>
</cfif>
<cfoutput>
<cfif rsForm.displayTitle neq 0><#getHeaderTag('subHead1')#>#rsForm.title#</#getHeaderTag('subHead1')#></cfif>
<cfif isdefined('request.formid') and request.formid eq rsform.contentid>
<cfset acceptdata=1> 
<cfinclude template="act_add.cfm">
<cfinclude template="dsp_response.cfm">
<cfelse>
<cfset addToHTMLHeadQueue("fckeditor.cfm")>
<cfif editableControl.innerHTML neq "">
	#setDynamicContent('<div class="editableObject editableForm">' & application.dataCollectionManager.renderForm(rsForm.contentid,request.siteid,rsForm.body,rsForm.responseChart) & '#editableControl.innerHTML#</div>')#
<cfelse>
	#setDynamicContent(application.dataCollectionManager.renderForm(rsForm.contentid,request.siteid,rsForm.body,rsForm.responseChart))#
</cfif>
<script type="text/javascript">
setHTMLEditors(200,500);
</script>
</cfif>

</cfoutput>
</cfif>