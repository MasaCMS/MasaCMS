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
<cfparam name="rc.targetversion" default="false">
<cfif not isBoolean(rc.targetversion)>
	<cfset rc.targetversion=false>
</cfif>
<cfif not len(rc.contentid) and isdefined('rc.homeid') and len(rc.homeid)>
	<cfset draftprompdata=application.contentManager.getDraftPromptData(rc.homeid,rc.siteid)>
<cfelse>
	<cfset draftprompdata=application.contentManager.getDraftPromptData(rc.contentid,rc.siteid)>
</cfif>

<cfset poweruser=$.currentUser().isSuperUser() or $.currentUser().isAdminUser()>
<cfif draftprompdata.showdialog >
	<cfset draftprompdata.showdialog='true'>
	<cfsavecontent variable="draftprompdata.message">
	<cfoutput>
	<div id="draft-prompt">	
		<cfif $.siteConfig('hasLockableNodes') and draftprompdata.islocked>
			<cfset lockedBy=$.getBean('user').loadBy(userid=draftprompdata.lockid)>
			<div class="alert alert-error alert-locked">
				<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.nodeLockedby"),"#esapiEncode('html_attr',lockedBy.getFName())# #esapiEncode('html',lockedBy.getLName())#")#.</p>
				<p><a tabindex="-1" href="mailto:#esapiEncode('html',lockedBy.getEmail())#?subject=#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.nodeunlockrequest'))#"><i class="icon-envelope"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.requestnoderelease')#</a></p>
			</div>
		</cfif>

		<cfif not $.siteConfig('hasLockableNodes') or draftprompdata.lockavailable or poweruser or $.currentUser().getUserID() eq  draftprompdata.lockid>
			
			<cfif draftprompdata.hasmultiple and not rc.targetversion>
				<p class="alert alert-info">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.dialog')#</p>
			</cfif>
			
			<cfif listFindNoCase("author,editor",draftprompdata.verdict)>

			<cfif $.siteConfig('hasLockableNodes') and (draftprompdata.lockavailable) and  draftprompdata.lockid neq session.mura.userid>
				<p class="alert"><input id="locknodetoggle" type="checkbox"/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.locknode')#</p>
			</cfif>

			<cfif rc.targetversion>
				<cfset publishedVersion=$.getBean('content').loadBy(contenthistid=rc.contenthistid)>
			<cfelse>
				<cfset publishedVersion=$.getBean('content').loadBy(contenthistid=draftprompdata.publishedHistoryID)>
			</cfif>
		
			<cfif publishedVersion.getApproved() or not draftprompdata.hasdraft or rc.targetversion>	
				<table class="mura-table-grid">
					<thead>
						<tr>
							<th colspan="4">
								<cfif not rc.targetversion>
									<cfif publishedVersion.getApproved()>
										<i class="icon-check"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.published'))#
									<cfelse>
										<i class="icon-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.latest'))#
									</cfif>
								<cfelse>
									<i class="icon-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.editversion'))#
								</cfif>
							</th>
						</tr>
					</thead>
					<tbody>
						<td class="var-width"><a href="##" tabindex="-1" class="draft-prompt-option var-width" data-contenthistid="#draftprompdata.publishedHistoryID#">#esapiEncode('html',publishedVersion.getMenuTitle())#</a></td>
						<td>#LSDateFormat(publishedVersion.getlastupdate(),session.dateKeyFormat)# #LSTimeFormat(publishedVersion.getLastUpdate(),"medium")#</td>
						<td>#esapiEncode('html',publishedVersion.getLastUpdateBy())#</td>
						<td><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.publishedHistoryID#"><i class="icon-pencil"></i></a></td>
					</tbody>
				</table>
			</cfif>

			<cfif draftprompdata.hasdraft and not rc.targetversion>

				<cfset draftVersion=$.getBean('content').loadBy(contenthistid=draftprompdata.historyid)>
				<table class="mura-table-grid">
					<thead>
						<tr>
							<th colspan="4"><i class="icon-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.latest'))#</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="var-width"><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.historyid#">#esapiEncode('html',draftVersion.getMenuTitle())#</a></td>
							<td>#LSDateFormat(draftVersion.getlastupdate(),session.dateKeyFormat)# #LSTimeFormat(draftVersion.getLastUpdate(),"medium")#</td>
							<td>#esapiEncode('html',draftVersion.getLastUpdateBy())#</td>
							<td><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.historyid#"><i class="icon-pencil"></i></a></td>
						</tr>
					</tbody>
				</table>
			</cfif>

			<cfif draftprompdata.pendingchangesets.recordcount and not rc.targetversion>
				<table class="mura-table-grid">	
					<thead>
						<tr>
							<th colspan="4"><i class="icon-list"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.changesets'))#</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="draftprompdata.pendingchangesets">
						<tr>
							<td class="var-width"><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#">#esapiEncode('html',draftprompdata.pendingchangesets.changesetName)#</a></td>
							<td>#LSDateFormat(draftprompdata.pendingchangesets.lastupdate,session.dateKeyFormat)# #LSTimeFormat(draftprompdata.pendingchangesets.lastupdate,"medium")#</td>
							<td>#esapiEncode('html',draftprompdata.pendingchangesets.lastupdateby)#</td>
							<td><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#"><i class="icon-pencil"></i></a></td>
						</tr>
						</cfloop>
					</tbody>
				</table>
			</cfif>
			</cfif>
			<cfif draftprompdata.yourapprovals.recordcount and not rc.targetversion>
				<cfset content=$.getBean('content').loadBy(contentid=rc.contentid)>
				<table class="mura-table-grid">	
					<thead>
						<tr>
							<th colspan="4"><i class="icon-time"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.awaitingapproval'))#</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="draftprompdata.yourapprovals">
							<tr>
								<cfif listFindNoCase("author,editor",draftprompdata.verdict)>
									<td class="var-width"><a href="##" data-contenthistid="#draftprompdata.yourapprovals.contenthistid#"  tabindex="-1" class="draft-prompt-option">#esapiEncode('html',draftprompdata.yourapprovals.menutitle)#</a></td>
									<td>#LSDateFormat(draftprompdata.yourapprovals.lastupdate,session.dateKeyFormat)# #LSTimeFormat(draftprompdata.yourapprovals.lastupdate,"medium")#</td>
									<td>#esapiEncode('html',draftprompdata.yourapprovals.lastupdateby)#</td>
									<td><a href="##" data-contenthistid="#draftprompdata.yourapprovals.contenthistid#" tabindex="-1" class="draft-prompt-option"><i class="icon-pencil"></i></a></td>
								<cfelse>
									<td class="var-width"><a href="#content.getURL(querystring="previewid=#draftprompdata.yourapprovals.contenthistid#")#" tabindex="-1" class="draft-prompt-approval">#esapiEncode('html',draftprompdata.yourapprovals.menutitle)#</a></td>
									<td>#LSDateFormat(draftprompdata.yourapprovals.lastupdate,session.dateKeyFormat)# #LSTimeFormat(draftprompdata.yourapprovals.lastupdate,"medium")#</td>
									<td>#esapiEncode('html',draftprompdata.yourapprovals.lastupdateby)#</td>
									<td><a href="#content.getURL(querystring="previewid=#draftprompdata.yourapprovals.contenthistid#")#" tabindex="-1" class="draft-prompt-approval"><i class="icon-pencil"></i></a></td>

								</cfif>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</cfif>

		</cfif>
					
		<!---			
		<cfif listFindNoCase('Pending,Rejected',draftprompdata.pendingchangesets.approvalStatus)>
							(#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.#draftprompdata.pendingchangesets.approvalStatus#')#)
						</cfif>
		--->
		
		
	
		</div>
	</cfoutput>
	</cfsavecontent>
<cfelse>
	<cfset draftprompdata.showdialog='false'>
	<cfset draftprompdata.message="">	
</cfif>
<cfset structDelete(draftprompdata,'yourapprovals')>
<cfset structDelete(draftprompdata,'pendingchangesets')>
<cfcontent type="application/json; charset=utf-8" reset="true">
<cfoutput>#createObject("component","mura.json").encode(draftprompdata)#</cfoutput>
<cfabort>