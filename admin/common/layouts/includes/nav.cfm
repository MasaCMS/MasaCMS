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
	/core/
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
<cfparam name="rc.action" default="">
<cfset rc.currentUser=rc.$.currentUser()>
<cfset rc.siteBean=application.settingsManager.getSite(session.siteID)>
<cfparam name="session.dashboardSpan" default="30">
<cfparam name="session.keywords" default="">
<cfparam name="rc.userid" default="">
<cfset hidelist="cLogin">
<cfset rsExts=application.classExtensionManager.getSubTypes(siteID=session.siteid,activeOnly=false) />
<!--- This is here solely for autoupdates--->
<cfif structKeyExists(application.classExtensionManager,'getIconClass')>
    <cfset exp="application.classExtensionManager.getIconClass(rsExts.type,rsExts.subtype,rsExts.siteid)">
<cfelseif structKeyExists(application.classExtensionManager,'getCustomIconClass')>
    <cfset exp="application.classExtensionManager.getCustomIconClass(rsExts.type,rsExts.subtype,rsExts.siteid)">
<cfelse>
    <cfset exp="">
</cfif>
</cfsilent>
<cfoutput>
<nav id="sidebar">
    <!-- Sidebar Scroll Container -->
    <div id="sidebar-scroll">
        <!-- Sidebar Content -->
        <!-- Adding .sidebar-mini-hide to an element will hide it when the sidebar is in mini mode -->
        <div class="sidebar-content">
            <!-- Side Header -->
            <div class="side-header side-content">
                <!-- Layout API, functionality initialized in App() -> uiLayoutApi() -->
                <button id="sidebar-mobile-close" class="btn btn-link text-gray pull-right hidden-md hidden-lg" type="button" data-toggle="layout" data-action="sidebar_close">
                    <i class="mi-close"></i>
                </button>
                <!-- Themes functionality initialized in App() -> uiHandleTheme() -->
                <div class="btn-group">
                    <span id="brand-logo-lg" class="brand" target="_blank">
                        <img src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/images/mura-logo-admin@2x.png" class="mura-logo">
                    </span>
                    <span id="brand-logo-min" class="brand" target="_blank">
                        <img src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/images/mura-icon@2x.png" class="mura-logo">
                        <span class="sidebar-mini-hide">
                            <img src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/images/mura-logo-text@2x.png" class="mura-logo-text">
                        </span>
                    </span>
                </div>
            </div>
            <!-- END Side Header -->
        <!--- exclude from login view --->
        <cfif session.siteid neq '' and rc.$.currentUser().isLoggedIn() and rc.$.currentUser().isPrivateUser()>
            <!--- sidebar --->
            <div class="side-content">
                <!--- main navigation menu --->
                <ul class="nav-main">
                    <!--- dashboard --->
                    <cfif rc.$.siteConfig().getValue(property='showDashboard',defaultValue=0)>
                        <li id="admin-nav-dashboard">
                            <a<cfif rc.originalcircuit eq 'cDashboard'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cDashboard.main&amp;siteid=#esapiEncode('url',session.siteid)#&amp;span=#session.dashboardSpan#"><i class="mi-dashboard"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.dashboard")#</span></a>
                        </li>
                    </cfif>
                    <!--- Content --->
                    <li>
                      <a id="navContentAdmin" <cfif rc.originalcircuit eq 'carch' or rc.originalcircuit eq 'scaffold' or rc.originalcircuit eq 'cform' or (rc.originalcircuit eq 'cperm' and (rc.originalfuseaction eq 'main' or rc.moduleid eq '00000000000000000000000000000000016' or rc.moduleid eq '00000000000000000000000000000000000' ))> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cArch.list&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-edit"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.contentmanager")#</span></a>
                    </li>
                    <cfif structKeyExists(rc,'$')>
                        #rc.$.renderEvent('onAdminNavMainRender')#
                    </cfif>
                    <!--- /Content --->
                    <!--- Change Sets --->
                    <cfif isNumeric(application.settingsManager.getSite(session.siteid).getValue("HasChangesets"))
                      and application.settingsManager.getSite(session.siteid).getHasChangesets() and application.permUtility.getModulePerm("00000000000000000000000000000000014",session.siteid)>
                    <li>
                    <a<cfif rc.originalcircuit eq 'cChangesets' or (rc.originalcircuit eq 'cperm' and rc.moduleid eq '00000000000000000000000000000000014')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cChangesets.list&amp;siteid=#session.siteid#"><i class="mi-clone"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.changesets")#</span></a>
                    </li>
                    </cfif>
                    <!--- /Change Sets --->
                    <!--- Comments --->
                    <cfif isBoolean(application.settingsManager.getSite(session.siteid).getHasComments()) and application.settingsManager.getSite(session.siteid).getHasComments() and application.permUtility.getModulePerm("00000000000000000000000000000000015",session.siteid)>
                      <li>
                        <a<cfif rc.originalcircuit eq 'cComments' or (rc.originalcircuit eq 'cperm' and rc.moduleid eq '00000000000000000000000000000000015')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cComments.default&amp;siteid=#session.siteid#"><i class="mi-comments"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.comments')#</span></a>
                      </li>
                    </cfif>
                    <!---- /Comments --->
                    <!--- Categories --->
                    <cfif application.permUtility.getModulePerm("00000000000000000000000000000000010",session.siteid)>
                      <li><a<cfif (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000010') or rc.originalcircuit eq 'cCategory'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cCategory.list&amp;siteid=#session.siteid#"><i class="mi-th"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.categories")#</span></a>
                      </li>
                    </cfif>
                    <!--- /Categories --->
                    <!--- Content Collections --->
                    <cfif application.settingsManager.getSite(session.siteid).getHasFeedManager() and application.permUtility.getModulePerm("00000000000000000000000000000000011",session.siteid)>
                      <li>
                        <a<cfif  rc.originalcircuit eq 'cFeed' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000011')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cFeed.list&amp;siteid=#session.siteid#">
                          <i class="mi-list"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.contentcollections")#</span></a>
                      </li>
                    </cfif>
                    <!--- /Content Collections --->
                    <!--- File Manager --->
                    <li>
                    <a<cfif rc.originalcircuit eq 'cFilemanager'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cFilemanager.default&amp;siteid=#session.siteid#"><i class="mi-folder-open"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.filemanager")#</span></a>
                    </li>
                    <!--- /File Manager --->
                    <!--- Advertising, this is not only available in certain legacy situations --->
                      <cfif application.settingsManager.getSite(session.siteid).getAdManager() and  application.permUtility.getModulePerm("00000000000000000000000000000000006",session.siteid)>
                        <li><a<cfif rc.originalcircuit eq 'cAdvertising' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000006')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cAdvertising.listAdvertisers&amp;siteid=#session.siteid#&amp;moduleid=00000000000000000000000000000000006"><i class="mi-cog"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.advertising")#</span></a>
                        </li>
                      </cfif>
                    <!--- /Advertising --->
                    <!--- Email Broadcaster --->
                      <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000005",session.siteid)>
                        <li>
                          <a<cfif rc.originalcircuit eq 'cEmail' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000005')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cEmail.list&amp;siteid=#session.siteid#">
                            <i class="mi-cog"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.emailbroadcaster")#</span></a>
                        </li>
                      </cfif>
                    <!--- /Email Broadcaster --->
                    <!--- Mailing Lists --->
                      <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009",session.siteid)>
                        <li>
                          <a<cfif rc.originalcircuit eq 'cMailingList' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000009')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cMailingList.list&amp;siteid=#session.siteid#"><i class="mi-cog"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.mailinglists")#</span></a>
                        </li>
                      </cfif>
                    <!--- /Mailing Lists --->
                    <!--- users --->
                    <cfif ListFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2') or (application.settingsManager.getSite(session.siteid).getextranet() and application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#"))>
                        <li id="admin-nav-users"<cfif rc.originalcircuit eq 'cusers' or (rc.originalcircuit eq 'cperm' and rc.moduleid eq '00000000000000000000000000000000008')> class="open"</cfif>>
                            <a class="nav-submenu<cfif listFindNoCase('cUsers,cPrivateUsers,cPublicUsers',rc.originalcircuit) or (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))> active</cfif>" data-toggle="nav-submenu" href="##"><i class="mi-users"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.users")#</span></a>
                            <ul>
                                <!--- view users --->
                                <li>
                                    <a<cfif (not Len(rc.userid) and isDefined('rc.ispublic') and rc.ispublic eq 1 and ( request.action eq 'core:cusers.listusers' or (rc.originalcircuit eq 'cusers' and len(rc.userid)) )) or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000008')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cUsers.listUsers&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-user"></i><span class="sidebar-mini-hide">#rc.$.rbKey("user.viewusers")#</span></a>
                                </li>
                                <!--- view groups --->
                                <li>
                                    <a<cfif not Len(rc.userid) and IsDefined('rc.ispublic') and rc.ispublic eq 1 and ( request.action eq 'core:cusers.list' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000008') or (rc.originalcircuit eq 'cusers' and len(rc.userid)) )> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cUsers.list&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-users"></i><span class="sidebar-mini-hide">#rc.$.rbKey("user.viewgroups")#</span></a>
                                </li>
                                <li class="divider"></li>
                                <!--- add user --->
                                <li>
                                    <a<cfif request.action eq "core:cusers.edituser" and not len(rc.userID)> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cUsers.edituser&amp;siteid=#esapiEncode('url',session.siteid)#&amp;userid="><i class="mi-user-plus"></i><span class="sidebar-mini-hide">#rc.$.rbKey('user.adduser')#</span></a>
                                </li>
                                <!--- add group --->
                                <li>
                                    <a<cfif request.action eq "core:cusers.editgroup" and not len(rc.userID)> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cUsers.editgroup&amp;siteid=#esapiEncode('url',session.siteid)#&amp;userid="><i class="mi-user-plus"></i><span class="sidebar-mini-hide">#rc.$.rbKey('user.addgroup')#</span></a>
                                </li>
                            </ul>
                        </li>
                    </cfif>
                    <!--- Plugins --->
                      <cfset rc.rsplugins=application.pluginManager.getSitePlugins(siteID=session.siteid, applyPermFilter=true) />
                      <cfif rc.rsplugins.recordcount or listFind(session.mura.memberships,'S2')>
                        <li class="divider"></li>
                        <li  id="admin-plugin-manager"<cfif rc.originalcircuit eq 'cPlugins'> class="open"</cfif>>
                          <a class="nav-submenu<cfif rc.originalcircuit eq 'cPlugins'> active</cfif>" data-toggle="nav-submenu" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cPlugins.list&amp;siteid=#session.siteid#"><i class="mi-plug"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.plugins")#</span></a>
                          <ul>
                            <li>
                              <a class="<cfif rc.originalcircuit eq 'cplugins' and rc.originalfuseaction eq 'list'> active</cfif>" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cPlugins.list&amp;siteid=#session.siteid#"><i class="mi-plug"></i><span class="sidebar-mini-hide">Site Plugins</span></a>
                            </li>
                            <cfloop query="rc.rsplugins">
                               <li>
                                <a<cfif rc.moduleid eq rc.rsplugins.moduleid> class="active"</cfif> href="#application.configBean.getContext()#/plugins/#rc.rsplugins.directory#/"><i class="mi-plug"></i>#esapiEncode('html',rc.rsplugins.name)#</a>
                              </li>
                            </cfloop>
                            <!--- Add Plugin --->
                            <cfif listFind(session.mura.memberships,'S2')>
                              <cfif rc.rsplugins.recordcount>
                                <li class="divider"></li>
                              </cfif>
                              <li>
                                <a href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.list&plugins##tabPlugins"><i class="mi-plus-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.addplugin")#</span></a>
                              </li>
                            </cfif>
                            <!--- /Add Plugin --->
                          </ul>
                        </li>
                      </cfif>
                    <!--- /Plugins --->
                    <!--- site config --->
                    <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
                        <cfset isSiteConfig= (rc.originalcircuit eq 'cPerm' and rc.originalfuseaction eq 'module' and rc.moduleid eq '00000000000000000000000000000000000') or (listFindNoCase('csettings,cextend,ctrash,cchain,cwebservice',rc.originalcircuit) and not (request.action eq "core:csettings.list" or request.action eq "core:csettings.sitecopy" or isDefined('url.addsite'))) >
                        <li id="admin-nav-site-config"<cfif isSiteConfig and not rc.originalfuseaction eq 'editPlugin' and not rc.originalfuseaction eq 'updatePluginVersion' and not rc.originalfuseaction eq 'siteCopySelect'> class="open"</cfif>>
                            <a class="nav-submenu<cfif isSiteConfig and not rc.originalfuseaction eq 'editPlugin' and not rc.originalfuseaction eq 'updatePluginVersion'> active</cfif>" data-toggle="nav-submenu" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/"><i class="mi-sliders"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.sitesettings")#</span></a>
                            <ul>
                                <!--- edit site --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'editSite' and rc.action neq 'updateFiles' and not isDefined('url.addsite') and not isDefined('url.deploybundle')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-edit"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.editcurrentsite")#</span></a>
                                </li>
                                <!--- permissions --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cPerm' and rc.originalfuseaction eq 'module' and rc.moduleid eq '00000000000000000000000000000000000'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cPerm.module&amp;contentid=00000000000000000000000000000000000&amp;siteid=#esapiEncode('url',session.siteid)#&amp;moduleid=00000000000000000000000000000000000"><i class="mi-users"></i>Permissions</a>
                                </li>
                                <!--- approval chains --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cChain'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cChain.list&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-check"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.approvalchains")#</span></a>
                                </li>
                                <!--- class extensions --->
                                <li<cfif rc.originalcircuit eq 'cextend'> class="open"</cfif>>
                                    <a class="nav-submenu" data-toggle="nav-submenu" href="##"><i class="mi-wrench"></i>Class Extensions</a>
                                    <ul>
                                        <!--- class extension manager --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'listSubTypes'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-cog"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.classextensionmanager')#</span></a>
                                        </li>
                                        <!--- add class extension --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'editSubType'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cExtend.editSubType&amp;subTypeID=&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-plus-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.addclassextension")#</span></a>
                                        </li>
                                        <!--- import class extension --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'importSubTypes'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cExtend.importSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-sign-in"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.importclassextensions')#</span></a>
                                        </li>
                                        <!--- export class extension --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'exportSubType'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cExtend.exportSubType&amp;siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-sign-out"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.exportclassextensions')#</span></a>
                                        </li>
                                    </ul>
                                </li>
                                <!--- /class extensions --->
                                <!--- create site bundle --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'selectBundleOptions'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.selectBundleOptions&amp;siteID=#esapiEncode('url',rc.siteBean.getSiteID())#"><i class="mi-gift"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.createsitebundle')#</span></a>
                                </li>
                                <!--- deploy site bundle --->
                                <li>
                                    <a<cfif isDefined('url.deployBundle')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#&amp;deployBundle##tabBundles"><i class="mi-download"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.deploysitebundle')#</span></a>
                                </li>
                                <!--- export static html --->
                                <cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'exportHtml'> class="active"</cfif> href="##" onclick="confirmDialog('Export static HTML files to #esapiEncode("javascript","'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=csettings.exportHTML&amp;siteID=#rc.siteBean.getSiteID()#')},'','#rc.$.rbKey('layout.exportstatichtml')#','','','','dialog-confirm');return false;"><i class="mi-cog"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.exportstatichtml')#</span></a>
                                    </li>
                                </cfif>
                                <cfif listFind(session.mura.memberships,'S2')>
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cwebservice'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cwebservice.list&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-exchange"></i><span class="sidebar-mini-hide">Web Services (REST)</span></a>
                                    </li>
                                    <li>
                                        <a target="_blank" href="#application.configBean.getContext()#/index.cfm/_api/json/v1/#esapiEncode('url',session.siteid)#"><i class="mi-exchange"></i><span class="sidebar-mini-hide">JSON API</span></a>
                                    </li>
                                    <!---trash bin --->
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cTrash'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cTrash.list&amp;siteID=#esapiEncode('url',session.siteid)#"><i class="mi-trash"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.trashbin')#</span></a>
                                    </li>
                                </cfif>
                            </ul>
                        </li>
                     </cfif>
                    <!--- settings --->
                    <cfif listFind(session.mura.memberships,'S2')>
                        <li id="admin-nav-global">
                            <a class="nav-submenu" data-toggle="nav-submenu" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/"><i class="mi-cogs"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.globalconfig")#</span></a>
                            <ul>
                                <!--- global settings --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'list' and not isDefined('url.plugins')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.list"><i class="mi-cogs"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.globalsettings-sites")#</span></a>
                                </li>
                                <!--- add site --->
                                <li>
                                    <a<cfif isDefined('url.addsite')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.editSite&amp;siteid=&amp;addsite"><i class="mi-plus-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.addsite")#</span></a>
                                </li>
                                <!--- copy site --->
																<cfif listFirst(expandPath(rc.$.globalConfig().getFileDir()),":") neq 's3'>
	                                <li>
	                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'siteCopySelect'> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.sitecopyselect"><i class="mi-copy"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.sitecopytool")#</span></a>
	                                </li>
																</cfif>
                                <!--- global plugins --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'list' and isDefined('url.plugins')> class="active"</cfif> href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.list&plugins##tabPlugins"><i class="mi-plug"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.globalsettings-plugins")#</span></a>
                                </li>
                                <!--- update core --->
                                <cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cSettings' and rc.action eq 'updateCore'> class="active"</cfif> href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')},'','#rc.$.rbKey('layout.updatemuracore')#','','','','dialog-warning');return false;"><i class="mi-cloud-download"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.updatemuracore')#</span></a>
                                    </li>
                                </cfif>
                                <!--- reload application --->
                                <li>
                                    <a href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?#esapiEncode('url',application.appreloadkey)#&amp;reload=#esapiEncode('url',application.appreloadkey)#" onclick="return actionModal(this.href);"><i class="mi-refresh"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.reloadapplication")#</span></a>
                                </li>
                            </ul>
                        </li>
                    </cfif>
                    <!--- help --->
                    <li id="admin-nav-help">
                        <a class="nav-submenu" data-toggle="nav-submenu" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/"><i class="mi-question-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.help")#</span></a>
                        <ul>
                            <!--- docs --->
                            <li>
                                <a id="navCSS-API" href="http://docs.getmura.com/" target="_blank"><i class="mi-bookmark"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.developers")#</span></a>
                            </li>
                            <!--- editor docs --->
                            <li>
                                <a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank"><i class="mi-bookmark"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.editordocumentation")#</span></a>
                            </li>
                            <!--- component API --->
                            <li>
                                <a id="navProg-API" href="http://www.getmura.com/component-api/7.1/" target="_blank"><i class="mi-bookmark"></i>Component API</a>
                            </li>
                            <!--- professional support --->
                            <li>
                                <a id="navHelpDocs" href="http://www.getmura.com/support/professional-support/" target="_blank"><i class="mi-group"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.support")#</span></a>
                            </li>
                            <!--- community support --->
                            <li>
                                <a id="navHelpForums" href="http://www.getmura.com/support/community-support/" target="_blank"><i class="mi-bullhorn"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.supportforum")#</span></a>
                            </li>
                        </ul>
                    </li>
                    <!--- version --->
                    <li>
                        <a class="nav-submenu" data-toggle="nav-submenu" href="#application.configBean.getContext()##application.configBean.getAdminDir()#/"><i class="mi-info-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.version")#</span></a>
                        <ul class="version">
                            <li class="divider"></li>
                            <!--- core version --->
                            <li>
                                <a class="no-link" href="##">
                                 <span><strong>#rc.$.rbKey('version.core')#</strong> #application.configBean.getVersion()#</span>
                                 </a>
                             </li>
                            <!--- update core --->
                            <cfif listFind(session.mura.memberships,'S2') and (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.action eq 'updateCore'> class="active"</cfif> href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')},'','#rc.$.rbKey('layout.updatemuracore')#','','','','dialog-warning');return false;"><i class="mi-cloud-download"></i><span class="sidebar-mini-hide">#rc.$.rbKey('layout.updatemuracore')#</span></a>
                                </li>
                            </cfif>
                            <li class="divider"></li>
                            <!--- server version --->
                            <li>
                                <a class="no-link" href="##"> <span><strong>#rc.$.rbKey('version.appserver')#</strong> #listFirst(server.coldfusion.productname,' ')#
                                    <cfif structKeyExists(server,'railo') and structKeyExists(server.railo,'version') >(#server.railo.version#)
                                    <cfelseif structKeyExists(server,'lucee') and structKeyExists(server.lucee,'version') >(#server.railo.version#)
                                    <cfelseif structKeyExists(server,'coldfusion') and structKeyExists(server.coldfusion,'productversion') >(#server.coldfusion.productversion#)</cfif></span></a>
                            </li>
                            <!--- database version --->
                            <cfif rc.$.globalConfig('javaEnabled')>
                            <li>
                                <a class="no-link" href="##"> <span><strong>#rc.$.rbKey('version.dbserver')#</strong> #rc.$.getBean('dbUtility').version().database_productname# (#rc.$.getBean('dbUtility').version().database_version#)</span></a>
                            </li>
                            <!--- java version --->
                            <cfif structKeyExists(server,'java') and structKeyExists(server.java,'version') >
                                <li>
                                    <a class="no-link" href="##"> <strong>#rc.$.rbKey('version.java')#</strong> #server.java.version#</a>
                                </li>
                            </cfif>
                            </cfif>
                            <!--- server os --->
                            <cfif structKeyExists(server,'os') and structKeyExists(server.os,'name') >
                                <li>
                                    <a class="no-link" href="##"> <span><strong>#rc.$.rbKey('version.os')#</strong> #server.os.name# (#server.os.version#)</span></a>
                                </li>
                            </cfif>
                            <!--- last deployment --->
                            <cfif application.configBean.getMode() eq 'Staging' and session.siteid neq '' and session.mura.isLoggedIn>
                                <li>
                                     <a class="no-link" href="##"> <span><strong>Last Deployment</strong>
                                        <cftry>
                                            #LSDateFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),session.dateKeyFormat)# #LSTimeFormat(application.settingsManager.getSite(session.siteid).getLastDeployment(),"short")#
                                            <cfcatch>
                                                Never
                                            </cfcatch>
                                        </cftry>
                                     </span></a>
                                </li>
                            </cfif>
                            <!--- copyright --->
                             <li>
                                <a href="https://github.com/blueriver/MuraCMS/blob/develop/license.txt" target="_blank"><span><strong>Mura CMS</strong> &copy; #year(now())# blueriver <em>Licensed under GNU General Public License Version 2.0 with exceptions</em></span></a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            <!-- END Side Content -->
            </cfif>
        </div>
        <!-- Sidebar Content -->
    </div>
    <!-- END Sidebar Scroll Container -->
</nav>
</cfoutput>
