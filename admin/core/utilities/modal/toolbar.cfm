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

	<cfheader name="Cache-Control"  value="no-cache, no-store, must-revalidate">
	<cfheader name="Pragma" value="no-cache">
	<cfheader name="Expires" value="#getHttpTimeString(now())#">
	<cfparam name="Cookie.fetDisplay" default="">
	<cfset completeurls=(variables.$.content('type') eq 'Variation' or variables.$.siteConfig('isRemote'))>
	<cfif variables.$.content('type') eq 'Variation'>
		<cfoutput>
		<script>
			window.Mura=window.Mura || window.mura || {};

			Mura(function(){
				Mura.loader().loadcss('#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/css/admin-frontend.min.css');

				if(!window.CKEDITOR){
					Mura.loader().loadjs(
						'#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckeditor/ckeditor.js'
					);

					window.CKEDITOR_BASEPATH = '#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckeditor/';
				}
				<cfif not $.getContentRenderer().useLayoutManager()>
				if(!window.CKFinder){
					Mura.loader().loadjs(
						'#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckfinder/ckfinder.js');

				}
				</cfif>

				Mura.loader().loadjs(
						'#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#',
						'#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/js/frontendtools.js.cfm?siteid=#esapiEncode("url",variables.$.event("siteid"))#&contenthistid=#$.content("contenthistid")#&coreversion=#application.coreversion#&showInlineEditor=#getShowInlineEditor()#&contentType=Variation&cacheid=' + Math.random());

				Mura('.mura-toolbar').show();

			});
		</script>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<script type="text/javascript" src="#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#"></script>
		<script>
			var hasMuraLoader=(typeof Mura != 'undefined' && (typeof Mura.loader != 'undefined' || typeof window.queuedMuraCmds != 'undefined'));

			if(hasMuraLoader){
				Mura(function(){
						Mura.loader().loadcss('#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/css/admin-frontend.min.css');
				})
			} else {
				 $("head").append("<link rel='stylesheet' type='text/css' href='#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/css/admin-frontend.min.css'>");
			}
			if(!window.CKEDITOR){
				if(hasMuraLoader){
					Mura(function(){
						Mura.loader().loadjs(
							'#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckeditor/ckeditor.js'
						);
					});
				} else {
					$.getScript('#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckeditor/ckeditor.js');
				}
				window.CKEDITOR_BASEPATH = '#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckeditor/';
			}
			<cfif not $.getContentRenderer().useLayoutManager()>
			if(!window.CKFinder){
				if(hasMuraLoader){
					Mura(function(){
						Mura.loader().loadjs('#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckfinder/ckfinder.js');
					});
				} else {
					$.getScript('#variables.$.siteConfig().getCorePath(complete=completeurls)#/vendor/ckfinder/ckfinder.js');
				}
			}
			</cfif>
			if(hasMuraLoader){
				Mura(function(){
					Mura.loader().loadjs('#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/js/frontendtools.js.cfm?siteid=#esapiEncode("url",variables.$.event("siteid"))#&contenthistid=#$.content("contenthistid")#&coreversion=#application.coreversion#&showInlineEditor=#getShowInlineEditor()#&cacheid=' + Math.random());
					Mura('.mura-toolbar').show();
				});
			} else {
				$.getScript('#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/js/frontendtools.js.cfm?siteid=#esapiEncode("url",variables.$.event("siteid"))#&contenthistid=#$.content("contenthistid")#&coreversion=#application.coreversion#&showInlineEditor=#getShowInlineEditor()#&cacheid=' + Math.random());
				$('.mura-toolbar').show();
			}
		</script>
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
	</cfif>
	<cfif getShowToolbar()>
		<cfsilent>
			<cfset variables.adminBase=variables.$.siteConfig().getAdminPath(complete=completeurls)/>
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
			<cfif variables.$.content('type') eq 'Variation'>
				<cfset variables.editLink = variables.editLink & "&amp;topid=00000000000000000000000000000000099">
			<cfelse>
				<cfset variables.editLink = variables.editLink & "&amp;topid=00000000000000000000000000000000001">
			</cfif>
			<cfset variables.editLink = variables.editLink & "&amp;type=" & request.contentBean.getType()>
			<cfset variables.editLink = variables.editLink & "&amp;parentid=" & request.contentBean.getParentID()>
			<cfset variables.editLink = variables.editLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
			<cfset variables.editLink = variables.editLink & "&amp;compactDisplay=true">

			<cfset variables.newLink = variables.adminBase & "/?muraAction=cArch.loadnewcontentmenu">
			<cfset variables.newLink = variables.newLink & "&amp;contentid=" & request.contentBean.getContentID()>
			<cfset variables.newLink = variables.newLink & "&amp;contenthistid=" & request.contentBean.getContentHistID()>
			<cfset variables.newLink = variables.newLink & "&amp;topid=00000000000000000000000000000000001">
			<cfset variables.newLink = variables.newLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.newLink = variables.newLink & "&amp;moduleid=" & "00000000000000000000000000000000000">
			<cfset variables.newLink = variables.newLink & "&amp;ptype=" & request.contentBean.getType()>
			<cfset variables.newLink = variables.newLink & "&amp;compactDisplay=true">

			<cfif $.content('type') eq 'Variation'>
				<cfset variables.initJSLink = variables.adminBase & "/?muraAction=cArch.variationtargeting">
				<cfset variables.initJSLink = variables.initJSLink & "&amp;contentid=" & request.contentBean.getContentID()>
				<cfset variables.initJSLink = variables.initJSLink & "&amp;topid=00000000000000000000000000000000099">
				<cfset variables.initJSLink = variables.initJSLink & "&amp;siteid=" & request.contentBean.getSiteID()>
				<cfset variables.initJSLink = variables.initJSLink & "&amp;moduleid=" & "00000000000000000000000000000000099">
				<cfset variables.initJSLink = variables.initJSLink & "&amp;compactDisplay=true">
			</cfif>


			<cfset variables.historyLink = variables.adminBase & "/?muraAction=cArch.hist">
			<cfset variables.historyLink = variables.historyLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;contentid=" & request.contentBean.getContentID()>
			<cfif variables.$.content('type') eq 'Variation'>
				<cfset variables.historyLink = variables.historyLink & "&amp;topid=00000000000000000000000000000000099">
			<cfelse>
				<cfset variables.historyLink = variables.historyLink & "&amp;topid=00000000000000000000000000000000001">
			</cfif>
			<cfset variables.historyLink = variables.historyLink & "&amp;type=" & request.contentBean.getType()>
			<cfset variables.historyLink = variables.historyLink & "&amp;parentid=" & request.contentBean.getParentID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;moduleid=" & request.contentBean.getModuleID()>
			<cfset variables.historyLink = variables.historyLink & "&amp;startrow=1">
			<cfset variables.historyLink = variables.historyLink & "&amp;compactDisplay=true">

			<cfset variables.adminLink = variables.adminBase & "/?muraAction=cArch.list">
			<cfset variables.adminLink = variables.adminLink & "&amp;siteid=" & request.contentBean.getSiteID()>
			<cfif $.content('type') eq 'Variation' and not len($.content('filename'))>
				<cfset variables.adminLink = variables.adminLink & "&amp;topid=" & request.contentBean.getModuleID()>
			<cfelse>
				<cfset variables.adminLink = variables.adminLink & "&amp;topid=" & request.contentBean.getContentID()>
			</cfif>

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
		<div class="mura mura-toolbar" style="display:none;">
			<a id="frontEndToolsHandle" href="##" onClick="if (document.getElementById('frontEndTools').style.display == 'none') { createCookie('FETDISPLAY','block',5); document.getElementById('mura-fe-logo').src='#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/images/mura-logo-fe.svg';} else { createCookie('FETDISPLAY','none',5); document.getElementById('mura-fe-logo').src='#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/images/mura-logo-fe-icon.svg'} toggleAdminToolbar(); return false;">
				<img id="mura-fe-logo" src="#variables.$.siteConfig().getAdminPath(complete=completeurls)#/assets/images/mura-logo-fe<cfif Cookie.fetDisplay eq 'none'>-icon</cfif>.svg" />
			</a>
			<div id="frontEndTools" style="display: #Cookie.fetDisplay#">
				<cfif $.currentUser().isLoggedIn() and not request.contentBean.getIsNew()>
					<ul id="tools-status"<cfif variables.isLocked> class="status-locked"</cfif>>
						<li id="adminStatus">
							<cfif $.content('active') gt 0 and  $.content('approved')  gt 0>
								<cfif len($.content('approvalStatus'))>
									<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook# title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#">
										<i class="mi-check-circle status-published"></i>
										<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
										#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#
									</a>
								<cfelse>
									<a href="#variables.approvalrequestlink#" data-configurator="true" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#" #variables.targetHook#>
										<i class="mi-check-circle status-published"></i>
										<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
										#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#
									</a>
								</cfif>
								<!--- wildcard: approved, published --->
							<cfelseif len($.content('approvalStatus')) and $.content().requiresApproval() >
								<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="mi-warning status-req-approval"></i>
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#$.content('approvalstatus')#")#
								</a>
							<cfelseif $.content('approved') lt 1>
								<cfif len($.content('changesetid'))>
									<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="mi-check status-queued"></i>
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.queued")#
									</a>
								<cfelse>
									<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="mi-edit status-draft"></i>
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#
								</a>
								</cfif>
							<cfelse>
								<a href="#variables.approvalrequestlink#" data-configurator="true" #variables.targetHook#>
									<i class="mi-history status-archived"></i>
									<!--- #application.rbFactory.getKeyValue(session.rb,'layout.status')#: --->
									#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#
								</a>
							</cfif>
						</li>
						<cfif listFindNoCase('editor,author',request.r.perm)>
							<!---<cfset edittype=($.content('type') eq 'Variation')?'var':'inline'>--->
							<cfset edittype='inline'>
							<li id="adminSave" class="dropdown" style="display:none">
								<a href="" data-toggle="dropdown" class="dropdown-toggle btn btn-primary" onClick="return false;"><i class="mi-floppy-o"></i> Save</a>
								<ul class="dropdown-menu">
									<cfif (request.r.perm  eq 'editor' or listFind(session.mura.memberships,'S2')) and not variables.$.siteConfig('EnforceChangesets')>
										<li class="mura-edit-toolbar-content">
											<a class="mura-#edittype#-save" data-approved="1" data-changesetid="">
											<i class="mi-check"></i>
											<cfif $.content().requiresApproval()>
												#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.sendforapproval"))#
											<cfelse>
												#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#
											</cfif>
											</a>
										</li>
									</cfif>
									<cfif $.content('type') eq 'Variation' and (request.r.perm  eq 'editor' or listFind(session.mura.memberships,'S2'))>
										<li class="mura-edit-toolbar-vartargeting"><a class="mura-#edittype#-updatetargeting"><i class="mi-check"></i> Update</a></li>
									</cfif>
									<cfif listFindNoCase('editor,author',request.r.perm) or listFind(session.mura.memberships,'S2') >
										<li class="mura-edit-toolbar-content">
											<a class="mura-#edittype#-save" data-approved="0" data-changesetid="">
												<i class="mi-edit"></i>
												#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#
											</a>
										</li>
									</cfif>
									<cfif variables.$.siteConfig('HasChangesets') and (request.r.perm  eq 'editor' or listFind(session.mura.memberships,'S2')) >
										<li class="dropdown-submenu mura-edit-toolbar-content">
											<a href="##" onClick="return false;"><i class="mi-list-alt"></i>
											#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset"))#<i class="mi-caret-right"></i></a>
											<cfset currentChangeset=application.changesetManager.read(variables.$.content('changesetID'))>
											<cfset changesets=application.changesetManager.getIterator(siteID=variables.$.event('siteid'),published=0,publishdate=now(),publishDateOnly=false)>
											<ul class="dropdown-menu">
												<cfif changesets.hasNext()>
												<cfloop condition="changesets.hasNext()">
													<cfset changeset=changesets.next()>
													<li>
														<a class="mura-#edittype#-save" data-approved="0" data-changesetid="#changeset.getChangesetID()#">#esapiEncode('html',changeset.getName())#</a>
													</li>
												</cfloop>
												<cfelse>
													<li>
														<a class="mura-#edittype#-cancel">#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.noneavailable"))#</a>
													</li>
												</cfif>
											</ul>
										</li>
									</cfif>
									<cfif $.content('type') eq 'Variation'>
										<li><a class="mura-#edittype#-undo mura-edit-toolbar-content"><i class="mi-undo"></i> Undo</a></li>
									</cfif>
									<li><a class="mura-#edittype#-cancel"><i class="mi-ban"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.cancel"))#</a></li>
								</ul>
							</li>
						</cfif>
					</ul>
				</cfif>
				<cfif not request.contentBean.getIsNew()>
					<cfif ListFindNoCase('editor,author',request.r.perm)>
						<ul id="tools-version">
							<!---
							<cfif $.content('type') eq 'Variation'>
							<li id="adminEditPage" class="dropdown"><a onClick="return MuraInlineEditor.init();"><i class="mi-pencil"></i></a></li>
							<li id="adminVersionHistory"><a href="#variables.historyLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" #variables.targethook#><i class="mi-history"></i></a></li>
							<cfelse>
							--->
							<li id="adminEditPage" class="dropdown"><a class="dropdown-toggle"><i class="mi-pencil"></i><b class="caret"></b></a>
								<ul class="dropdown-menu">
								<cfif this.showInlineEditor>
									<cfif $.content('type') eq 'Variation'>
										<li id="adminQuickEdit">
											<a onClick="return MuraInlineEditor.init();"><i class="mi-pencil"></i>
												Edit Content
												<!---#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-layout')#--->
											</a>
										</li>
									<cfelseif useLayoutManager()>
										<cfset tabAssignments=$.currentUser().getContentTabAssignments()>
										<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Layout & Objects') or listFindNocase(tabAssignments,'Layout') or listFindNocase(tabAssignments,'Basic')>
										<li id="adminQuickEdit">
											<a onClick="return MuraInlineEditor.init();"><i class="mi-pencil"></i>
												#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-layout')#
											</a>
										</li>
										</cfif>
									<cfelse>
										<li id="adminQuickEdit">
											<a onClick="return MuraInlineEditor.init();"><i class="mi-pencil"></i>
												#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-quick')#
											</a>
										</li>
									</cfif>
									<li id="adminFullEdit">
										<a href="#variables.editLink#"<cfif variables.dolockcheck> data-configurator="true"</cfif> #variables.targetHook#>
											<cfif $.content('type') eq 'Variation'>
												<i class="mi-edit"></i> Edit Metadata <!--#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-full')#--->
											<cfelseif useLayoutManager()>
												<i class="mi-edit"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-content')#
											<cfelse>
												 <i class="mi-edit"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-full')#
											</cfif></a>
									</li>
									</cfif>
									<cfif request.r.perm eq 'editor' and $.content('type') eq 'Variation'>
										<li id="clientVariationTargeting"><a id="mura-edit-var-targetingjs"><i class="mi-bullseye"></i> Edit Targeting<!--#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-variationtargeting')#---></a></li>
										<li id="adminVariationTargeting"><a id="mura-edit-var-initjs" href="#variables.initJSLink#" #variables.targethook#><i class="mi-code"></i> Edit Custom JS<!---#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit-initjs')#---></a></li>
									</cfif>
									<cfif (request.r.perm eq 'editor' or listFind(session.mura.memberships,'S2')) and request.contentBean.getFilename() neq "" and not request.contentBean.getIslocked()>
										<cfif request.contentBean.getType() eq 'Variation'>
											<li id="adminDelete"><a href="#variables.deleteLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" onClick="return confirm('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletevariationconfirm'),request.contentBean.getMenutitle()))#');"><i class="mi-trash"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li>
										<cfelse>
											<li id="adminDelete"><a href="#variables.deleteLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" onClick="return confirm('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.contentBean.getMenutitle()))#');"><i class="mi-trash"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li>
										</cfif>

									</cfif>
								</ul>
							</li>
							<cfif $.content('type') neq 'Variation'>
							<li id="adminAddContent"><a href="#variables.newLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.add')#" #variables.targethook# data-configurator="true"><i class="mi-plus"></i></a></li>
							<li id="adminAddContent-suspend" class="suspend" style="display:none;"><a href="##" title="" onClick="return false;"><i class="mi-plus"></i></a></li>
							</cfif>
							<li id="adminVersionHistory"><a href="#variables.historyLink#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" #variables.targethook#><i class="mi-history"></i></a></li>
							<li id="adminVersionHistory-suspend" class="suspend" style="display:none;"><a href="##" title="" onClick="return false;"><i class="mi-history"></i></a></li>
							<cfif $.content('type') neq 'Variation'>
							<li id="adminPreview"<!--- class="dropdown"--->><a href="#esapiEncode(
								'html_attr',variables.$.getCurrentURL())#" data-modal-preview="true" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.multidevicepreview')#" #variables.targethook#><i class="mi-mobile"></i></a></li>
							<li id="adminPreview-suspend" class="suspend" style="display:none;"<!--- class="dropdown"--->><a href="##" title="" onClick="return false;"><i class="mi-mobile"></i></a></li>
							</cfif>
							<!---</cfif>--->
							<cfif $.currentUser().isPrivateUser()>
								<li><a href="#variables.adminLink#" title="#application.rbFactory.getKeyValue(session.rb,'layout.sitemanager')#" target="admin"><i class="mi-sitemap"></i></a></li>
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
								<li id="cs-title" class="dropdown"><a id="cs-title-text" class="dropdown-toggle" data-toggle="dropdown"><i>CS</i><cfif request.muraChangesetPreview>#esapiEncode('html',previewData.name)#<cfif isDate(previewData.publishDate)> (#LSDateFormat(previewData.publishDate,session.dateKeyFormat)#)</cfif><cfelse>None Selected</cfif><b class="caret"></b></a>
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
									<a class="dropdown-toggle" data-toggle="dropdown" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.assignments'))#"><i class="mi-list-alt"></i></a>
									<cfif request.muraChangesetPreview>
										<ul class="dropdown-menu">
										<cfif changesetMembers.hasNext()>
											<cfloop condition="changesetMembers.hasNext()">
											<cfset changesetMember=changesetMembers.next()>
											<li><a href="#changesetMember.getURL()#">#esapiEncode('html',changesetMember.getMenuTitle())#</a></li>
											</cfloop>
										<cfelse>
											<li><a onClick="return false;">#application.rbFactory.getKeyValue(session.rb,'changesets.noassignedcontent')#</a></li>
										</cfif>
										</ul>
									</cfif>
								</li>
								<!--- I can't figure out how to trigger the tooltip but here are the icons for each status:
									In Selected Changeset - mi-check
									In Earlier Changeset - mi-code-fork
									Not in a Changeset - mi-ban --->
								<cfif request.muraChangesetPreview and structKeyExists(previewData.previewmap,$.content("contentID")) >
									<cfif previewData.previewmap[$.content("contentID")].changesetID eq previewData.changesetID>
										<li>
											<a href="" data-toggle="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.content.in'))#">
												<i class="mi-check"></i>
											</a>
										</li>
									<cfelse>
										<li>
											<a href="" data-toggle="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.content.dependent'))#">
												<i class="mi-code-fork"></i>

											</a>
										</li>
									</cfif>
								<cfelse>
									<li>
										<a href="" data-toggle="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'changesets.content.notin'))#">
											<i class="mi-ban"></i>
										</a>
									</li>
								</cfif>
							</ul>
						</cfif>
					</cfif>
					<!--- Render additional toolbar menu items --->
					<cfset afterMenu=variables.$.renderEvent('onFEToolbarExtensionRender')>
					<cfif len(afterMenu)>
						#afterMenu#
					</cfif>
				</cfif>
				<cfif listFindNoCase(session.mura.memberships,'S2IsPrivate')>
					<cfif $.siteConfig().getValue(property='showDashboard',defaultValue=0)>
						<ul id="adminDashboard">
							<li><a href="#$.siteConfig().getAdminPath(complete=completeurls)#/?muraAction=cDashboard.main&siteid=#esapiEncode('url',$.event('siteid'))#&span=1" title="Dashboard" target="admin"><i class="mi-dashboard"></i> Dashboard</a></li>
						</ul>
					</cfif>
				</cfif>
				<cfif $.currentUser().isLoggedIn()>
					<ul id="tools-user">
						<li id="adminLogOut"><a href="?doaction=logout" title="#application.rbFactory.getKeyValue(session.rb,'layout.logout')#"><i class="mi-sign-out"></i><span>#application.rbFactory.getKeyValue(session.rb,'layout.logout')#</span></a></li>
						<li id="adminWelcome"><i class="mi-user"></i> #esapiEncode("html","#session.mura.fname# #session.mura.lname#")#</li>
					</ul>
				</cfif>
				<!---
				<cfif this.layoutmanager and $.currentUser().isLoggedIn() and not request.contentBean.getIsNew()>
					<cfinclude template="layoutmanager.cfm">
				</cfif>
				--->
		</div>
	</div>
	<cfif this.layoutmanager and $.currentUser().isLoggedIn() and not request.contentBean.getIsNew()>
		<cfinclude template="layoutmanager.cfm">
	</cfif>
</cfoutput>
</cfif>
<cfoutput><div class="mura" id="frontEndToolsModalTarget"></div></cfoutput>
