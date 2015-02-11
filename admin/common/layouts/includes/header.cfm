<!--- 
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
	<cfparam name="rc.originalfuseAction" default="">
	<cfparam name="rc.originalcircuit" default="">
	<cfparam name="rc.moduleid" default="">
	<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 30>
		<cfparam name="session.dashboardSpan" default="30">
	<cfelse>
		<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
	</cfif>
	<cfif not isDefined("session.mura.memberships")>
	  <cflocation url="#application.configBean.getContext()#/admin/?muraAction=cLogin.logout" addtoken="false">
	</cfif>
	<cfset rc.siteBean=application.settingsManager.getSite(session.siteID)>
	<cfset rc.currentUser=rc.$.currentUser()> 
</cfsilent>
<cfoutput>
	<header>
		<!--- Top Navbar --->
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container">
					<a class="brand" href="http://www.getmura.com" title="Mura CMS" target="_blank">Mura CMS</a>
					<div class="brand-credit">by Blue River</div>
					<cfif listFind(session.mura.memberships,'S2IsPrivate')>
						<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</a>

						<cfparam name="session.showdashboard" default="true">
						<cfif session.showdashboard>
							<cfset baseURL="#application.configBean.getContext()#/admin/?muraAction=cDashboard.main">
						<cfelse>
							<cfset baseURL="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;moduleID=00000000000000000000000000000000000&amp;topID=00000000000000000000000000000000001">
						</cfif> 

						<!--- Utility Nav --->
							<cfif session.siteid neq '' and session.mura.isLoggedIn>
								<div class="nav-collapse">
									<ul class="nav pull-right">
										<!--- Version --->
											<li id="navVersion" class="dropdown">
												<a class="dropdown-toggle" data-toggle="dropdown" href="##">
													<i class="icon-info-sign"></i> 
													#rc.$.rbKey("layout.version")#
													<b class="caret"></b>
												</a>
												<ul class="dropdown-menu">
													<li>
														<a href="##">
															<strong>#rc.$.rbKey('version.core')#</strong> 
															#application.autoUpdater.getCurrentCompleteVersion()#
														</a>
													</li>
													<li>
														<a href="##">
															<strong>#rc.$.rbKey('version.site')#</strong> 
															#application.autoUpdater.getCurrentCompleteVersion(session.siteid)#
														</a>
													</li>
													<cfif rc.currentUser.isSuperUser() >
														<li class="divider"></li>
														<li>
															<a href="##">
																<strong>#rc.$.rbKey('version.appserver')#</strong>
																#listFirst(server.coldfusion.productname,' ')#
																<cfif structKeyExists(server,'railo') and structKeyExists(server.railo,'version') >(#server.railo.version#)
																<cfelseif structKeyExists(server,'lucee') and structKeyExists(server.lucee,'version') >(#server.railo.version#)
																<cfelseif structKeyExists(server,'coldfusion') and structKeyExists(server.coldfusion,'productversion') >(#server.coldfusion.productversion#)</cfif>
															</a>
														</li>
														<cfif rc.$.globalConfig('javaEnabled')>
															<li>
																<a href="##">
																	<strong>#rc.$.rbKey('version.dbserver')#</strong>
																	#rc.$.getBean('dbUtility').version().database_productname# (#rc.$.getBean('dbUtility').version().database_version#)
																</a>
															</li>
														</cfif>
														<cfif structKeyExists(server,'java') and structKeyExists(server.java,'version') >
															<li>
																<a href="##">
																	<strong>#rc.$.rbKey('version.java')#</strong>
																	#server.java.version#
																</a>
															</li>
														</cfif>
														<cfif structKeyExists(server,'os') and structKeyExists(server.os,'name') >
															<li>
																<a href="##">
																	<strong>#rc.$.rbKey('version.os')#</strong>
																	#server.os.name# (#server.os.version#)
																</a>
															</li>
														</cfif>
													</cfif>
													<cfif application.configBean.getMode() eq 'Staging' and session.siteid neq '' and session.mura.isLoggedIn>
														<li>
															<a href="##">
																<strong>Last Deployment</strong>
																<cftry>
																	#LSDateFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),session.dateKeyFormat)# #LSTimeFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),"short")#
																	<cfcatch>
																		Never
																	</cfcatch>
																</cftry>
															</a>
														</li>
													</cfif>
												</ul>
											</li>
										<!--- /Version --->
				
										<!--- Settings --->
											<cfif listFind(session.mura.memberships,'S2')>
												<li id="navGlobalSettings" class="dropdown">
													<a class="dropdown-toggle" data-toggle="dropdown" href="##">
														<i class="icon-cogs"></i> 
														#rc.$.rbKey("layout.settings")#
														<b class="caret"></b>
													</a>
													
													<ul class="dropdown-menu">

														<!--- Global Settings --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list">
																<i class="icon-cogs"></i> 
																#rc.$.rbKey("layout.globalsettings")#
															</a>
														</li>

														<!--- Plugins --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list##tabPlugins">
																<i class="icon-puzzle-piece"></i> 
																#rc.$.rbKey("layout.globalsettings-plugins")#
															</a>
														</li>

														<!--- Add Site --->
														<li>
														  <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=">
														  	<i class="icon-plus-sign"></i> 
														  	#rc.$.rbKey("layout.addsite")#
														  </a>
														</li>

														<!--- Site Copy --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.sitecopyselect">
																<i class="icon-copy"></i> 
																#rc.$.rbKey("layout.sitecopytool")#
															</a>
														</li>

														<!--- Reload Application --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?#esapiEncode('url',application.appreloadkey)#&amp;reload=#esapiEncode('url',application.appreloadkey)#" onclick="return actionModal(this.href);">
																<i class="icon-refresh"></i> 
																#rc.$.rbKey("layout.reloadapplication")#
															</a>
														</li>
														
														<!--- Update Core --->
															<cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
																<li>
																	<a href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')});return false;">
																		<i class="icon-bolt"></i> 
																		#rc.$.rbKey('layout.updatemuracore')#
																	</a>
																</li>
															</cfif>
														<!--- /Update Core --->

													</ul>
												</li>
											</cfif>
										<!--- /Settings --->

										<!--- Help --->
											<li id="navHelp" class="dropdown">
												<a class="dropdown-toggle" data-toggle="dropdown" href="##">
													<i class="icon-question-sign"></i> 
													#rc.$.rbKey("layout.help")#
													<b class="caret"></b>
												</a>
												
												<ul class="dropdown-menu">

													<!--- Documentation --->
													<li>
														<a id="navCSS-API" href="http://docs.getmura.com/v6/" target="_blank">
															<i class="icon-bookmark"></i> 
															#rc.$.rbKey("layout.developers")#
														</a>
													</li>

													<!--- Editor/File Manager Docs --->
													<li>
														<a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank">
															<i class="icon-bookmark"></i> 
															#rc.$.rbKey("layout.editordocumentation")#
														</a>
													</li>

													<!--- Component API --->
													<li>
														<a id="navProg-API" href="http://www.getmura.com/component-api/6.1/" target="_blank">
															<i class="icon-bookmark"></i> 
															Component API
														</a>
													</li>

													<!--- Professional Support --->
													<li>
														<a id="navHelpDocs" href="http://www.getmura.com/support/professional-support/" target="_blank">
															<i class="icon-group"></i> 
															#rc.$.rbKey("layout.support")#
														</a>
													</li>

													<!--- Community Support --->
													<li class="last">
														<a id="navHelpForums" href="http://www.getmura.com/support/community-support/" target="_blank">
															<i class="icon-bullhorn"></i> 
															#rc.$.rbKey("layout.supportforum")#
														</a>
													</li>
												</ul>
											</li>
										<!--- /Help --->

										<!--- Profile --->
											<li id="navEditProfile" class="dropdown">
												<a class="dropdown-toggle" data-toggle="dropdown" href="##">
													<i class="icon-user"></i> 
													#esapiEncode("html","#session.mura.fname# #session.mura.lname#")#
													<b class="caret"></b>
												</a>
											
												<ul class="dropdown-menu">
													<!--- Edit Profile --->
													<li>
														<a href="#application.configBean.getContext()#/admin/?muraAction=cEditProfile.edit">
															<i class="icon-pencil"></i> 
															#rc.$.rbKey("layout.editprofile")#
														</a>
													</li>
													<!--- Logout --->
													<li id="navLogout">
														<a href="#application.configBean.getContext()#/admin/?muraAction=cLogin.logout">
															<i class="icon-signout"></i> 
															#rc.$.rbKey("layout.logout")#
														</a>
													</li>
												</ul>
											</li>
										<!--- /Profile --->
									</ul>
								</div><!--/.nav-collapse -->
							</cfif>
						<!--- /Utility Nav --->
					</cfif>
				</div><!-- /.container -->
			</div><!-- /.navbar-inner -->
		</div><!-- /.navbar navbar-fixed-top -->
		<!--- /Top Navbar --->

		<!--- Main Navbar --->
			<cfif rc.originalcircuit neq 'cLogin'>			
				<div class="nav-site">
					<div class="nav-site-inner">
						<div class="container">
							<cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />		
							<ul>
								<!--- Site List --->
									<li id="select-site" class="dropdown">
										<a id="select-site-btn" href="#rc.$.siteConfig().getWebPath(complete=1)#<cfif application.configBean.getSiteIDInURLS()>/#session.siteid#/</cfif>" target="_blank">
											Current Site
										</a>

										<a class="dropdown-toggle" data-toggle="dropdown" href="##">
											<div id="site-name">
												#esapiEncode('html', application.settingsManager.getSite(session.siteid).getSite())#
											</div>
											<b class="caret"></b>
										</a>
									
										<!--- Site Selector --->
											<ul id="select-site-ul" class="dropdown-menu ui-front">
												<cfif theSiteList.recordCount gt 20> 
													<div class="ui-widget">
														<input name="site-search" class="form-control input-sm" type="text" placeholder="#rc.$.rbKey("dashboard.search")#...">
													</div>
												</cfif>
												<cfloop query="theSiteList" startrow="1" endrow="100">
												  <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
													<a href="#baseURL#&amp;siteID=#theSiteList.siteID#" title="#esapiEncode('html_attr',theSiteList.site)#">
														<i class="icon-globe"></i> 
														#esapiEncode('html',theSiteList.site)#
													</a>
												  </li>
												</cfloop>
											</ul>
										<!--- /Site Selector --->
									</li>
								<!--- /Site List --->
								

								<!--- Dashboard --->
									<cfif session.showdashboard>
										<li<cfif  rc.originalcircuit eq 'cDashboard'> class="active"</cfif>>
											<a href="#application.configBean.getContext()#/admin/?muraAction=cDashboard.main&amp;siteid=#session.siteid#&amp;span=#session.dashboardSpan#"> 
												<i class="icon-dashboard"></i>
												<span>#rc.$.rbKey("layout.dashboard")#</span>
											</a>
										</li>
									</cfif>
								<!--- /Dashboard --->

								<!--- Site Manager --->
									<li <cfif rc.originalcircuit eq 'cArch' and not listFind('00000000000000000000000000000000003,00000000000000000000000000000000004',rc.moduleID) and not (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))> class="active"</cfif>>
										<a href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#session.siteid#&amp;moduleid=00000000000000000000000000000000000">
											<i class="icon-list-alt"></i> 
											<span>#rc.$.rbKey("layout.sitemanager")#</span>
										</a>	    				
									</li>
								<!--- /Site Manager --->
								
								<cfset hidelist="cLogin">

								<!--- Modules --->
									<cfif not listfindNoCase(hidelist,rc.originalcircuit)>
										<cfinclude template="dsp_module_menu.cfm" />
									</cfif>
								<!--- /Modules --->

								<!--- Users --->
									<cfif ListFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2') or (application.settingsManager.getSite(session.siteid).getextranet() and application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#"))>
										<li class="dropdown<cfif listFindNoCase('cUsers,cPrivateUsers,cPublicUsers',rc.originalcircuit) or (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))> active</cfif>">

											<a class="dropdown-toggle" data-toggle="dropdown" href="##">
												<i class="icon-group"></i> 
												<span>#rc.$.rbKey("layout.users")#</span>
												<b class="caret"></b>
											</a>
											
											<cfparam name="rc.userid" default="">
											<ul class="dropdown-menu">
												<cfif ( 
													ListFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')
													) OR ( 
														application.settingsManager.getSite(session.siteid).getextranet() and  application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#")
												)>
													<!--- View Groups --->
														<li <cfif not Len(rc.userid) and IsDefined('rc.ispublic') and rc.ispublic eq 1 and ( request.action eq 'core:cusers.list' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000008') or (rc.originalcircuit eq 'cusers' and len(rc.userid)) )>class="active"</cfif>>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cUsers.list&amp;siteid=#session.siteid#">
																<i class="icon-group"></i> 
																#rc.$.rbKey("user.viewgroups")#
															</a>
														</li>

													<!--- View Users --->
														<li <cfif not Len(rc.userid) and IsDefined('rc.ispublic') and rc.ispublic eq 1 and ( request.action eq 'core:cusers.listusers' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000008') or (rc.originalcircuit eq 'cusers' and len(rc.userid)) )>class="active"</cfif>>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cUsers.listUsers&amp;siteid=#session.siteid#">
																<i class="icon-group"></i> 
																#rc.$.rbKey("user.viewusers")#
															</a>
														</li>

													<li class="divider"></li>

													<!--- Add Group --->
														<li<cfif request.action eq "core:cusers.editgroup" and not len(rc.userID)> class="active"</cfif>>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cUsers.editgroup&amp;siteid=#esapiEncode('url',session.siteid)#&amp;userid=">
																<i class="icon-plus-sign"></i> 
																#rc.$.rbKey('user.addgroup')#
															</a>
														</li>

													<!--- Add User --->
														<li<cfif request.action eq "core:cusers.edituser" and not len(rc.userID)> class="active"</cfif>>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cUsers.edituser&amp;siteid=#esapiEncode('url',session.siteid)#&amp;userid=">
																<i class="icon-plus-sign"></i> 
														 		#rc.$.rbKey('user.adduser')#
														 	</a>
														</li>
												</cfif>
											</ul>			
										</li>
									</cfif>
								<!--- /Users --->

								<!--- Site Config --->
									<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
										<li id="site-config" class="dropdown<cfif listFindNoCase('csettings,cextend,ctrash,cchain',rc.originalcircuit) or (rc.moduleID eq '00000000000000000000000000000000000' and rc.originalcircuit eq 'cPerm')> active</cfif>">

											<a class="dropdown-toggle" data-toggle="dropdown" href="##">
												<i class="icon-wrench"></i> 
												<span>#rc.$.rbKey("layout.sitesettings")#</span>
												<b class="caret"></b>
											</a>
										
											<ul class="dropdown-menu">

												<!--- Edit Current Site --->
												<li>
													<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#session.siteid#">
														<i class="icon-pencil"></i>
														#rc.$.rbKey("layout.editcurrentsite")#
													</a>
												</li>
												<!--- Edit Current Site --->
											
												<!--- Permissions --->
												<li <cfif (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000000')>class='active'</cfif>>
													<a href="#application.configBean.getContext()#/admin/?muraAction=cPerm.module&amp;contentid=00000000000000000000000000000000000&amp;siteid=#session.siteid#&amp;moduleid=00000000000000000000000000000000000">
														<i class="icon-group"></i> 
														#rc.$.rbKey("layout.permissions")#
													</a>
												</li>
												<!--- /Permissions --->

												<!--- Approval Chains --->
												<li <cfif rc.originalcircuit eq 'cChain'>class='active'</cfif>>
													<a href="#application.configBean.getContext()#/admin/?muraAction=cChain.list&amp;siteid=#session.siteid#">
														<i class="icon-ok"></i> 
														#rc.$.rbKey("layout.approvalchains")#
													</a>
												</li>
												<!--- /Approval Chains --->
											
												<!--- Class Extension Manager --->
												<cfset rsExts=application.classExtensionManager.getSubTypes(siteID=session.siteid,activeOnly=false) />
												<li class="dropdown-submenu">
													<a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',session.siteid)#">
														<i class="icon-wrench"></i> 
														#rc.$.rbKey('layout.classextensionmanager')#
													</a>
													<ul class="dropdown-menu">
														<!--- This is here solely for autoupdates--->
														<cfif structKeyExists(application.classExtensionManager,'getIconClass')>
															<cfset exp="application.classExtensionManager.getIconClass(rsExts.type,rsExts.subtype,rsExts.siteid)">
														<cfelseif structKeyExists(application.classExtensionManager,'getCustomIconClass')>
															<cfset exp="application.classExtensionManager.getCustomIconClass(rsExts.type,rsExts.subtype,rsExts.siteid)">
														<cfelse>
															<cfset exp="">
														</cfif>

														<!--- Add Class Extension --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.editSubType&amp;subTypeID=&amp;siteid=#esapiEncode('url',session.siteid)#">
																<i class="icon-plus-sign"></i> 
																#rc.$.rbKey("layout.addclassextension")#
															</a>
														</li>
														<!--- Import Class Extension --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.importSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#">
																<i class="icon-signin"></i> 
																#rc.$.rbKey('layout.importclassextensions')#
															</a>
														</li>
														<!--- Export Class Extension --->
														<li>
															<a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.exportSubType&amp;siteid=#esapiEncode('url',rc.siteid)#">
																<i class="icon-signout"></i> 
																#rc.$.rbKey('layout.exportclassextensions')#
															</a>
														</li>

														<cfif rsExts.recordcount>
															<li class="divider"></li>
														</cfif>
														<cfloop query="rsExts">
															<li>
																<a href="#application.configBean.getContext()#/admin/?muraAction=cExtend.listSets&amp;subTypeID=#rsExts.subtypeID#&amp;siteid=#esapiEncode('url',session.siteid)#">
																	<i class=<cfif len(exp)>"#evaluate(exp)#"<cfelse>"icon-cog"</cfif>></i>				 								
																	<cfif rsExts.type eq 1>
																		#rc.$.rbKey('user.group')#
																	<cfelseif rsExts.type eq 2>
																		#rc.$.rbKey('user.user')#
																	<cfelse>
																		#esapiEncode('html',rsExts.type)#
																	</cfif>
																	/#esapiEncode('html',rsExts.subtype)#	
																</a>
															</li>
														</cfloop>
													</ul>
												</li>

												<!--- Create Site Bundle --->
												<li>
													<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.selectBundleOptions&amp;siteID=#esapiEncode('url',rc.siteBean.getSiteID())#">
														<i class="icon-gift"></i> 
														#rc.$.rbKey('layout.createsitebundle')#
													</a>
												</li>
												<!--- /Create Site Bundle --->

												<!--- Deploy Site Bundle --->
												<li>
													<a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#session.siteid###tabBundles">
														<i class="icon-download-alt"></i> 
														#rc.$.rbKey('layout.deploysitebundle')#
													</a>
												</li>
												<!--- /Trash Bin --->

												<!--- Trash Bin --->
												<li>
													<a href="#application.configBean.getContext()#/admin/?muraAction=cTrash.list&amp;siteID=#esapiEncode('url',session.siteid)#">
														<i class="icon-trash"></i> 
														#rc.$.rbKey('layout.trashbin')#
													</a>
												</li>
												<!--- /Trash Bin --->

												<!--- Update Site --->
												<cfif listFind(session.mura.memberships,'S2')>
													<cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
														<li>
															<a href="##" onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#&amp;action=updateFiles#rc.$.renderCSRFTokens(context=session.siteid & 'updatesite',format='url')#')});return false;">
																<i class="icon-bolt"></i> 
																#rc.$.rbKey('layout.updatesite')#
															</a>
														</li>
													</cfif>
												</cfif>
												<!--- /Update Site --->

												<!--- Export Static HTML --->
												<cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
													<li>
														<a href="##" onclick="confirmDialog('Export static HTML files to #esapiEncode("javascript","'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=csettings.exportHTML&amp;siteID=#rc.siteBean.getSiteID()#')});return false;">
															<i class="icon-cog"></i> 
															#rc.$.rbKey('layout.exportstatichtml')#
														</a>
													</li>
												</cfif>
												<!--- /Export Static HTML --->
											</ul>	
																	
										</li>
									</cfif>
								<!--- /Site Config --->
							</ul>
							
						</div><!-- /container -->
					</div><!-- /nav-site-inner -->
				</div><!-- /nav-site -->
			</cfif>
		<!--- /Main Navbar --->
	</header>
</cfoutput>