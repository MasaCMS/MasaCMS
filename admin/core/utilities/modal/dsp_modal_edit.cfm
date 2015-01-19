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

	<cfparam name="Cookie.fetDisplay" default="">
	<cfoutput>
	<link href="#variables.$.globalConfig('adminPath')#/assets/css/dialog.min.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="#variables.$.globalConfig('adminPath')#/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#"></script>
	<script>
		if(!window.CKEDITOR){
			document.write(unescape('%3Cscript src="#variables.$.globalConfig("requirementsPath")#/ckeditor/ckeditor.js"%3E%3C/script%3E'));
			document.write(unescape('%3Cscript src="#variables.$.globalConfig("requirementsPath")#/ckeditor/adapters/jquery.js"%3E%3C/script%3E'));		
		}
		if(!window.CKFinder){
			document.write(unescape('%3Cscript src="#variables.$.globalConfig("requirementsPath")#/ckfinder/ckfinder.js"%3E%3C/script%3E'));
		}
	</script>
	<script type="text/javascript" src="#variables.$.globalConfig("adminPath")#/assets/js/frontendtools.js.cfm?siteid=#esapiEncode('url',variables.$.event('siteid'))#&contenthistid=#$.content('contenthistid')#&coreversion=#application.coreversion#&showInlineEditor=#getShowInlineEditor()#&cacheid=#createUUID()#"></script>

	<!---[if LT IE9]>
	   <style type="text/css">

	   ##frontEndToolsModalContainer {
	         background: transparent;
	          filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=##00000085,endColorstr=##00000085);
	          zoom: 1;
	       }

	    </style>
	<![endif]--->
	</cfoutput>
	<cfif getShowToolbar()>
		<cfsilent>
			<cfset variables.adminBase=variables.$.globalConfig("adminPath")/>
			<cfset variables.$.event('muraAdminBaseURL',variables.adminBase)>
			<cfset variables.targetHook=generateEditableHook()>
			
			<cfif $.siteConfig('hasLockableNodes')>
				<cfset variables.stats=$.content().getStats()>
				<cfset variables.editLink = variables.adminBase & "/?muraAction=carch.lockcheck&destAction=carch.edit">
				<cfset variables.dolockcheck=not(stats.getLockID() eq $.currentUser().getUserID())>
				<cfset variables.isLocked=variables.stats.getLockType() eq 'node'>
			<cfelse>
				<cfset variables.editLink = variables.adminBase & "/?muraAction=cArch.edit">
				<cfset variables.dolockcheck=false>
				<cfset variables.isLocked=false>
			</cfif>
			
			<cfif structKeyExists(request,"previewID") and len(request.previewID)>
				<cfset variables.editLink = variables.editLink & "&amp;contenthistid=" & request.previewID>
			<cfelse>
				<cfset variables.editLink = variables.editLink & "&amp;contenthistid=" & request.contentBean.getContentHistID()>
			</cfif>
			<cfset variables.editLink = variables.editLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.editLink = variables.editLink & "&amp;contentid=" & request.contentBean.getContentID()>
			<cfset variables.editLink = variables.editLink & "&amp;topid=00000000000000000000000000000000001">
			<cfset variables.editLink = variables.editLink & "&amp;type=" & request.contentBean.getType()>
			<cfset variables.editLink = variables.editLink & "&amp;parentid=" & request.contentBean.getParentID()>
			<cfset variables.editLink = variables.editLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
			<cfset variables.editLink = variables.editLink & "&amp;compactDisplay=true">
			
			<cfset variables.newLink = variables.adminBase & "/?muraAction=cArch.loadnewcontentmenu">
			<cfset variables.newLink = variables.newLink & "&amp;contentid=" & request.contentBean.getContentID()>
			<cfset variables.newLink = variables.newLink & "&amp;topid=00000000000000000000000000000000001">
			<cfset variables.newLink = variables.newLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.newLink = variables.newLink & "&amp;moduleid=" & "00000000000000000000000000000000000">
			<cfset variables.newLink = variables.newLink & "&amp;ptype=" & request.contentBean.getType()>
			<cfset variables.newLink = variables.newLink & "&amp;compactDisplay=true">

		
			<cfset variables.historyLink = variables.adminBase & "/?muraAction=cArch.hist">
			<cfset variables.historyLink = variables.historyLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;contentid=" & request.contentBean.getContentID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;topid=00000000000000000000000000000000001">
			<cfset variables.historyLink = variables.historyLink & "&amp;type=" & request.contentBean.getType()>
			<cfset variables.historyLink = variables.historyLink & "&amp;parentid=" & request.contentBean.getParentID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;startrow=1">
			<cfset variables.historyLink = variables.historyLink & "&amp;compactDisplay=true">
			
			<cfset variables.adminLink = variables.adminBase & "/?muraAction=cArch.list">
			<cfset variables.adminLink = variables.adminLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.adminLink = variables.adminLink & "&amp;topid=" & request.contentBean.getContentID()>
			<cfset variables.adminLink = variables.adminLink & "&amp;ptype=" & request.contentBean.getType()>
			<cfset variables.adminLink = variables.adminLink & "&amp;parentid=" & request.contentBean.getParentID()>
			<cfset variables.adminLink = variables.adminLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
			<cfset variables.adminLink = variables.adminLink & "&amp;activeTab=0">

			
			<cfset variables.deleteLink = variables.adminBase & "/?muraAction=cArch.update#variables.$.renderCSRFTokens(context=request.contentBean.getContentID() & 'deleteall',format='url')#">
			<cfset variables.deleteLink = variables.deleteLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.deleteLink = variables.deleteLink & "&amp;contentid=" & request.contentBean.getContentID()>
			<cfset variables.deleteLink = variables.deleteLink & "&amp;topid=00000000000000000000000000000000001">
			<cfset variables.deleteLink = variables.deleteLink & "&amp;type=" & request.contentBean.getType()>
			<cfset variables.deleteLink = variables.deleteLink & "&amp;parentid=" & request.contentBean.getParentID()>
			<cfset variables.deleteLink = variables.deleteLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
			<cfset variables.deleteLink = variables.deleteLink & "&amp;compactDisplay=true">
			<cfset variables.deleteLink = variables.deleteLink & "&amp;closeCompactDisplay=true">
			<cfset variables.deleteLink = variables.deleteLink & "&amp;action=deleteall">
			<cfset variables.deleteLink = variables.deleteLink & "&amp;startrow=1">


			<cfset variables.approvalrequestlink = variables.adminBase & "/?muraAction=cArch.statusmodal&compactDisplay=true&contenthistid=#$.content('contenthistid')#&siteid=#$.content('siteid')#&mode=frontend">
		
		</cfsilent>
		<cfoutput>
		<div class="mura mura-toolbar">
			<img src="#variables.$.globalConfig("adminPath")#/assets/images/logo_small_feTools.png" id="frontEndToolsHandle" onclick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','',5); } else { createCookie('FETDISPLAY','none',5); } toggleAdminToolbar();" />
			<div id="frontEndTools" style="display: #Cookie.fetDisplay#">	
				<cfif $.currentUser().isLoggedIn() and not request.contentBean.getIsNew()>
					<ul id="tools-status"<cfif variables.isLocked> class="status-locked"</cfif>>
						<li id="adminStatus">
							<cfif $.content('active') gt 0 and  $.content('approved')  gt 0>
								<cfif len($.content('approvalStatus'))>
									<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook# title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#">
										<i class="icon-ok-circle status-published"></i> 
										<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
										#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#
									</a>
								<cfelse>
									<a href="#variables.approvalrequestlink#" data-configurator="true" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#" #variables.targetHook#>
										<i class="icon-ok-circle status-published"></i> 
										<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
										#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#
									</a>
								</cfif>
								
								<!--- wildcard: approved, published --->			
							<cfelseif len($.content('approvalStatus')) and $.content().requiresApproval() >
								<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="icon-warning-sign status-req-approval"></i> 
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#$.content('approvalstatus')#")#
								</a>
							<cfelseif $.content('approved') lt 1>
								<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="icon-edit status-draft"></i> 
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#
								</a>
							<cfelse>
								<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="icon-book status-archived"></i> 
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#
								</a>
							</cfif>
						</li>
						
						<cfif listFindNoCase('editor,author',request.r.perm) or listFind(session.mura.memberships,'S2') >
							<li id="adminSave" class="dropdown" style="display:none">
								<a href="" class="dropdown-toggle" onclick="return false;">
									<i class="icon-ok-sign"></i> Save</a>
								<ul class="dropdown-menu">
									<cfif (request.r.perm  eq 'editor' or listFind(session.mura.memberships,'S2')) and not variables.$.siteConfig('EnforceChangesets')>
										<li>
											<a class="mura-inline-save" data-approved="1" data-changesetid="">
											<i class="icon-ok"></i> 
											<cfif $.content().requiresApproval()>
												#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.sendforapproval"))#
											<cfelse>
												#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#
											</cfif>
											</a>
										</li>
									</cfif>
									<cfif listFindNoCase('editor,author',request.r.perm) or listFind(session.mura.memberships,'S2') >
										<li>
											<a class="mura-inline-save" data-approved="0" data-changesetid="">
												<i class="icon-edit"></i>  
												#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#
											</a>
										</li>
									</cfif>
									<cfif variables.$.siteConfig('HasChangesets') and (request.r.perm  eq 'editor' or listFind(session.mura.memberships,'S2')) >
										<li class="dropdown-submenu">
											<a href=""><i class="icon-list"></i> 
											#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset"))#</a>			
											<cfset currentChangeset=application.changesetManager.read(variables.$.content('changesetID'))>
											<cfset changesets=application.changesetManager.getIterator(siteID=variables.$.event('siteid'),published=0,publishdate=now(),publishDateOnly=false)>
											<ul class="dropdown-menu">
												<cfif changesets.hasNext()>
												<cfloop condition="changesets.hasNext()">
													<cfset changeset=changesets.next()>
													<li>
														<a class="mura-inline-save" data-approved="0" data-changesetid="#changeset.getChangesetID()#">#esapiEncode('html',changeset.getName())#</a>
													</li>
												</cfloop>
												<cfelse>
													<li>
														<a class="mura-inline-cancel">#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.noneavailable"))#</a>
													</li>
												</cfif>
											</ul>
										</li>
									</cfif>
									<li><a class="mura-inline-cancel"><i class="icon-ban-circle"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.cancel"))#</a></li>
								</ul>
							</li>
						</cfif>
					</ul>
				</cfif>

				<cfif not request.contentBean.getIsNew()>
					<cfif ListFindNoCase('editor,author',request.r.perm)>
						<ul id="tools-version">
							<li id="adminEditPage" class="dropdown"><a class="dropdown-toggle"><i class="icon-pencil"></i><b class="caret"></b></a>
								<ul class="dropdown-menu">
									<li id="adminFullEdit">
										<a href="#variables.editLink#"<cfif variables.dolockcheck> data-configurator="true"</cfif> #variables.targetHook#><i class="icon-pencil"></i>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-full')#</a>
									</li>
									<cfif this.showInlineEditor>	
									<li id="adminQuickEdit">
										<a onclick="return muraInlineEditor.init();"><i class="icon-bolt"></i>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-quick')#</a>
									</li>
									</cfif>
								</ul>				
							</li>
									
							<li id="adminAddContent"><a href="#variables.newLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#" #variables.targethook# data-configurator="true"><i class="icon-plus"></i><!--- #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')# ---></a>
								</li>
							
							<li id="adminVersionHistory"><a href="#variables.historyLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" #variables.targethook#><i class="icon-book"></i><!--- #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')# ---></a></li>
							<li id="adminPreview"<!--- class="dropdown"--->><a href="#variables.$.getCurrentURL()#" data-modal-preview="true" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.multidevicepreview')#" #variables.targethook#><i class="icon-mobile-phone"></i><!--- <b class="caret"></b> ---></a>
							</li>
								
							<cfif (request.r.perm eq 'editor' or listFind(session.mura.memberships,'S2')) and request.contentBean.getFilename() neq "" and not request.contentBean.getIslocked()>
								<li id="adminDelete"><a href="#variables.deleteLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" onclick="return confirm('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.contentBean.getMenutitle()))#');"><i class="icon-remove-sign"></i><!--- #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')# ---></a></li>
							</cfif>
						</ul>
					</cfif>
				
					<!--- BEGIN CHANGESETS ---> 
					<cfif $.siteConfig('HasChangeSets')>
						
						<cfset customMenu=variables.$.renderEvent('onExperienceToolbarRender')>

						<cfif len(customMenu)>
							#customMenu#
						<cfelse>
							<cfif request.muraChangesetPreview>
								<cfset previewData=$.currentUser("ChangesetPreviewData")>
							</cfif>
							<cfset rsChangesets=application.changesetManager.getQuery(siteID=$.event('siteID'),published=0,sortby="PublishDate")>
							<ul id="tools-changesets">
								
								<li id="cs-title" class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown"><i>CS</i><cfif request.muraChangesetPreview>#esapiEncode('html',previewData.name)#<cfif isDate(previewData.publishDate)> (#LSDateFormat(previewData.publishDate,session.dateKeyFormat)#)</cfif><cfelse>None Selected</cfif><b class="caret"></b></a>
									<ul class="dropdown-menu">
										<li><a href="./?changesetid=">None</a></li>
										<cfloop query="rsChangesets">
										<li><a href="./?changesetid=#rschangesets.changesetid#">
												#esapiEncode('html',rsChangesets.name)#
												<cfif isDate(rsChangesets.publishDate)> (#LSDateFormat(rsChangesets.publishDate,session.dateKeyFormat)#)</cfif>
											</a>
										</li>
										</cfloop>
									</ul>							
								</li>

								<cfif request.muraChangesetPreview>
									<cfset previewData=$.currentUser("ChangesetPreviewData")>
									<cfset changesetMembers=application.changesetManager.getAssignmentsIterator(changesetID=previewData.changesetID,moduleID='00000000000000000000000000000000000')>
								</cfif>
								<li class="dropdown">
									<a class="dropdown-toggle" data-toggle="dropdown" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.assignments'))#"><i class="icon-list"></i></a>
									<cfif request.muraChangesetPreview>
										<ul class="dropdown-menu">
										<cfif changesetMembers.hasNext()>
											<cfloop condition="changesetMembers.hasNext()">
											<cfset changesetMember=changesetMembers.next()>
											<li><a href="#changesetMember.getURL()#">#esapiEncode('html',changesetMember.getMenuTitle())#</a></li>
											</cfloop>
										<cfelse>
											<li><a onclick="return false;">#application.rbFactory.getKeyValue(session.rb,'changesets.noassignedcontent')#</a></li>
										</cfif>
										
										</ul>
									</cfif>
								</li>
								
								<!--- I can't figure out how to trigger the tooltip but here are the icons for each status:
									In Selected Changeset - icon-check
									In Earlier Changeset - icon-code-fork
									Not in a Changeset - icon-ban-circle --->
								<cfif request.muraChangesetPreview and structKeyExists(previewData.previewmap,$.content("contentID")) >
									<cfif previewData.previewmap[$.content("contentID")].changesetID eq previewData.changesetID>
										<li>
											<a href="" data-toggle="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.content.in'))#">
												<i class="icon-check"></i>
												 <!---#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"changesets.previewnodemembership"),'<strong>"#esapiEncode('html_attr',previewData.previewmap[$.content("contentID")].changesetName)#"</strong>')#--->
											</a>
										</li>
									<cfelse>
										<li>
											<a href="" data-toggle="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.content.dependent'))#">
												<i class="icon-code-fork"></i>
												<!---#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"changesets.previewnodemembership"),'<strong>"#esapiEncode('html_attr',previewData.previewmap[$.content("contentID")].changesetName)#"</strong>')#--->
											</a>
										</li>
									</cfif>
								<cfelse>
									<li>
										<a href="" data-toggle="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.content.notin'))#">
											<i class="icon-ban-circle"></i>
											<!---#application.rbFactory.getKeyValue(session.rb,"changesets.previewnodenotinchangeset")#--->
										</a>
									</li>
								</cfif>
							</ul>
						</cfif>


					</cfif>
				</cfif>
				

				<cfif listFindNoCase(session.mura.memberships,'S2IsPrivate')>

					<ul id="adminSiteManager"><li><a href="#variables.adminLink#" title="#application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#" target="admin"><i class="icon-list-alt"></i> #application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#</a></li></ul>
				</cfif>
				
				<cfif $.currentUser().isLoggedIn()>
					<ul id="tools-user">
						<li id="adminLogOut"><a href="?doaction=logout" title="#application.rbFactory.getKeyValue(session.rb,'layout.logout')#"><i class="icon-signout"></i>#application.rbFactory.getKeyValue(session.rb,'layout.logout')#</a></li>
						<li id="adminWelcome"><i class="icon-user"></i> #esapiEncode("html","#session.mura.fname# #session.mura.lname#")#</li>
					</ul>
				</cfif>
	</div>
	</div>
</cfoutput>
</cfif>

<cfoutput><div class="mura" id="frontEndToolsModalTarget"></div></cfoutput>



