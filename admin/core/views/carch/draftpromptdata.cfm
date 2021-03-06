 <!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

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
			<div class="help-block">
				<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.nodeLockedby"),"#esapiEncode('html_attr',lockedBy.getFName())# #esapiEncode('html',lockedBy.getLName())#")#.</p>
				<p><a tabindex="-1" href="mailto:#esapiEncode('html',lockedBy.getEmail())#?subject=#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.nodeunlockrequest'))#"><i class="mi-envelope"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.requestnoderelease')#</a></p>
			</div>
		</cfif>

		<cfif not $.siteConfig('hasLockableNodes') or draftprompdata.lockavailable or poweruser or $.currentUser().getUserID() eq  draftprompdata.lockid>

			<cfif draftprompdata.hasmultiple and not rc.targetversion>
				<div class="help-block">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.dialog')#</div>
			</cfif>

			<cfif listFindNoCase("author,editor",draftprompdata.verdict)>

			<cfif $.siteConfig('hasLockableNodes') and (draftprompdata.lockavailable) and  draftprompdata.lockid neq session.mura.userid>
				<div class="help-block"><input id="locknodetoggle" type="checkbox"/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.locknode')#</div>
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
										<i class="mi-check"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.published'))#
									<cfelse>
										<i class="mi-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.latest'))#
									</cfif>
								<cfelse>
									<i class="mi-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.editversion'))#
								</cfif>
							</th>
						</tr>
					</thead>
					<tbody>
						<td><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.publishedHistoryID#"><i class="mi-pencil"></i></a></td>
						<td class="var-width"><a href="##" tabindex="-1" class="draft-prompt-option var-width" data-contenthistid="#draftprompdata.publishedHistoryID#">#esapiEncode('html',publishedVersion.getMenuTitle())#</a></td>
						<td>#LSDateFormat(publishedVersion.getlastupdate(),session.dateKeyFormat)# #LSTimeFormat(publishedVersion.getLastUpdate(),"medium")#</td>
						<td>#esapiEncode('html',publishedVersion.getLastUpdateBy())#</td>
					</tbody>
				</table>
			</cfif>

			<cfif draftprompdata.hasdraft and not rc.targetversion>

				<cfset draftVersion=$.getBean('content').loadBy(contenthistid=draftprompdata.historyid)>
				<table class="mura-table-grid">
					<thead>
						<tr>
							<th colspan="4"><i class="mi-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.latest'))#</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.historyid#"><i class="mi-pencil"></i></a></td>
							<td class="var-width"><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.historyid#">#esapiEncode('html',draftVersion.getMenuTitle())#</a></td>
							<td>#LSDateFormat(draftVersion.getlastupdate(),session.dateKeyFormat)# #LSTimeFormat(draftVersion.getLastUpdate(),"medium")#</td>
							<td>#esapiEncode('html',draftVersion.getLastUpdateBy())#</td>
						</tr>
					</tbody>
				</table>
			</cfif>

			<cfif draftprompdata.pendingchangesets.recordcount and not rc.targetversion>
				<table class="mura-table-grid">
					<thead>
						<tr>
							<th colspan="4"><i class="mi-clone"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.changesets'))#</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="draftprompdata.pendingchangesets">
						<tr>
							<td><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#"><i class="mi-pencil"></i></a></td>
							<td class="var-width"><a href="##" tabindex="-1" class="draft-prompt-option" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#">#esapiEncode('html',draftprompdata.pendingchangesets.changesetName)#</a></td>
							<td>#LSDateFormat(draftprompdata.pendingchangesets.lastupdate,session.dateKeyFormat)# #LSTimeFormat(draftprompdata.pendingchangesets.lastupdate,"medium")#</td>
							<td>#esapiEncode('html',draftprompdata.pendingchangesets.lastupdateby)#</td>
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
							<th colspan="4"><i class="mi-clock-o"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.awaitingapproval'))#</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="draftprompdata.yourapprovals">
							<tr>
								<cfif listFindNoCase("author,editor",draftprompdata.verdict)>
									<td><a href="##" data-contenthistid="#draftprompdata.yourapprovals.contenthistid#" tabindex="-1" class="draft-prompt-option"><i class="mi-pencil"></i></a></td>
									<td class="var-width"><a href="##" data-contenthistid="#draftprompdata.yourapprovals.contenthistid#"  tabindex="-1" class="draft-prompt-option">#esapiEncode('html',draftprompdata.yourapprovals.menutitle)#</a></td>
									<td>#LSDateFormat(draftprompdata.yourapprovals.lastupdate,session.dateKeyFormat)# #LSTimeFormat(draftprompdata.yourapprovals.lastupdate,"medium")#</td>
									<td>#esapiEncode('html',draftprompdata.yourapprovals.lastupdateby)#</td>
								<cfelse>
									<td><a href="#content.getURL(querystring="previewid=#draftprompdata.yourapprovals.contenthistid#")#" tabindex="-1" class="draft-prompt-approval"><i class="mi-pencil"></i></a></td>
									<td class="var-width"><a href="#content.getURL(querystring="previewid=#draftprompdata.yourapprovals.contenthistid#")#" tabindex="-1" class="draft-prompt-approval">#esapiEncode('html',draftprompdata.yourapprovals.menutitle)#</a></td>
									<td>#LSDateFormat(draftprompdata.yourapprovals.lastupdate,session.dateKeyFormat)# #LSTimeFormat(draftprompdata.yourapprovals.lastupdate,"medium")#</td>
									<td>#esapiEncode('html',draftprompdata.yourapprovals.lastupdateby)#</td>

								</cfif>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</cfif>

		</cfif>

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
