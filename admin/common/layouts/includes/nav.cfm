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
<!--- M7 new for nav current states based on action value --->
<cfparam name="rc.action" default="">
<!--- /end m7 new --->
<!--- M7 duplicated here from header.cfm --->
<cfset rc.currentUser=rc.$.currentUser()>
<cfset rc.siteBean=application.settingsManager.getSite(session.siteID)>
<!--- /end m7  --->
<!--- M7 moved from markup in old header.cfm --->
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
<!--- /end m7 moved --->

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
                <button class="btn btn-link text-gray pull-right hidden-md hidden-lg" type="button" data-toggle="layout" data-action="sidebar_close">
                    <i class="mi-times"></i>
                </button>
                <!-- Themes functionality initialized in App() -> uiHandleTheme() -->
                <div class="btn-group">
                    <strong>
                    <a class="brand" href="http://www.getmura.com" title="Mura CMS" target="_blank">
                        <img src="#application.configBean.getContext()#/admin/assets/images/mura_logo.png" class="mura-logo">
                    </a>
<!---                     <span class="sidebar-mini-hide logo-credit">
                        <img src="#application.configBean.getContext()#/admin/assets/images/mura_logo_credit.png" class="mura-logo-credit">
                    </span>
 --->                </strong>
                </div>
                <!---
                <button class="btn btn-link text-gray pull-right hidden-sm hidden-xs sidebar-icon-right" type="button">
                    <i class="mi-caret-right"></i>
                </button>
                <button class="btn btn-link text-gray pull-right hidden-sm hidden-xs sidebar-icon-left" type="button">
                    <i class="mi-caret-left"></i>
                </button>
                --->
            </div>
            <!-- END Side Header -->

        <!--- exclude from login view --->
        <cfif session.siteid neq '' and session.mura.isLoggedIn>

            <!--- sidebar --->
            <div class="side-content">

                <!--- main navigation menu --->
                <ul class="nav-main">

                    <!--- dashboard --->
                    <cfif session.showdashboard>
                        <li id="admin-nav-dashboard">
                            <a<cfif  rc.originalcircuit eq 'cDashboard'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cDashboard.main&amp;siteid=#esapiEncode('url',session.siteid)#&amp;span=#session.dashboardSpan#"><i class="mi-dashboard"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.dashboard")#</span></a>
                        </li>
                    </cfif>

                    <!--- site manager --->
                    <cfset isInSiteManager=listFindNoCase('carch,cfeed,ccategory,cchangesets,cfilemanager,ccomments,cmailinglist,cemail,cadvertising',rc.originalcircuit) and not (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))>
                    <li id="admin-nav-manager"<cfif isInSiteManager> class="open"</cfif>>
                        <a data-toggle="nav-submenu" class="nav-submenu" href="./">
                            <i class="mi-list-alt"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.sitemanager")#</span>
                        </a>
						<ul>
                            <!--- Site Tree --->
                            <li>
                            <a<cfif rc.originalcircuit eq 'carch'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#esapiEncode('url',session.siteid)#">
                            <i class="mi-sitemap"></i>
                            #application.rbFactory.getKeyValue(session.rb,"layout.contentmanager")#
                            </a>
                            </li>
                            <!--- /Site Tree --->

                            <!--- Components
                            <cfif application.permUtility.getModulePerm("00000000000000000000000000000000003",session.siteid)>
                            <li>
                              <a class="site-manager-mod<cfif rc.originalcircuit eq 'carch' and rc.moduleid eq '00000000000000000000000000000000003'> active</cfif>" data-moduleid="00000000000000000000000000000000003" href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#session.siteid#&amp;topid=00000000000000000000000000000000003&amp;parentid=00000000000000000000000000000000003&amp;moduleid=00000000000000000000000000000000003">
                                <i class="mi-align-justify"></i>
                                #application.rbFactory.getKeyValue(session.rb,"layout.components")#
                              </a>
                            </li>
                            </cfif>
                            /Components --->

                            <!--- Forms
                            <cfif application.settingsManager.getSite(session.siteid).getDataCollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004",session.siteid)>
                            <li>
                            <a class="site-manager-mod<cfif rc.originalcircuit eq 'carch' and rc.moduleid eq '00000000000000000000000000000000004'> active</cfif>" data-moduleid="00000000000000000000000000000000004" href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#session.siteid#&amp;topid=00000000000000000000000000000000004&amp;parentid=00000000000000000000000000000000004&amp;moduleid=00000000000000000000000000000000004">
                             <i class="mi-toggle-on"></i>
                             #application.rbFactory.getKeyValue(session.rb,"layout.forms")#
                            </a>
                            </li>
                            </cfif>
                            /Forms --->

                            <!--- Variations
                            <cfif application.configBean.getValue(property='variations',defaultValue=false) and application.permUtility.getModulePerm("00000000000000000000000000000000099",session.siteid)>
                            <li>
                              <a class="site-manager-mod<cfif rc.originalcircuit eq 'carch' and rc.moduleid eq '00000000000000000000000000000000099'> active</cfif>" data-moduleid="00000000000000000000000000000000099" href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#session.siteid#&amp;topid=00000000000000000000000000000000099&amp;parentid=00000000000000000000000000000000099&amp;moduleid=00000000000000000000000000000000099">
                                <i class="mi-cloud"></i>
                                #application.rbFactory.getKeyValue(session.rb,"layout.variations")#
                              </a>
                            </li>
                            </cfif>
                            /Variations --->

                            <!--- Change Sets --->
                            <cfif isNumeric(application.settingsManager.getSite(session.siteid).getValue("HasChangesets"))
                              and application.settingsManager.getSite(session.siteid).getHasChangesets() and application.permUtility.getModulePerm("00000000000000000000000000000000014",session.siteid)>
                            <li>
                            <a<cfif rc.originalcircuit eq 'cChangesets' > class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cChangesets.list&amp;siteid=#session.siteid#">
                              <i class="mi-files-o"></i>
                                #application.rbFactory.getKeyValue(session.rb,"layout.changesets")#
                              </a>
                            </li>
                            </cfif>
                            <!--- /Change Sets --->

                            <!--- Comments --->
                            <cfif isBoolean(application.settingsManager.getSite(session.siteid).getHasComments()) and application.settingsManager.getSite(session.siteid).getHasComments() and application.permUtility.getModulePerm("00000000000000000000000000000000015",session.siteid)>
                              <li>
                                <a<cfif rc.originalcircuit eq 'cComments'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cComments.default&amp;siteid=#session.siteid#">
                                  <i class="mi-cog"></i>
                                  #application.rbFactory.getKeyValue(session.rb,'layout.comments')#
                                </a>
                              </li>
                            </cfif>
                            <!---- /Comments --->

                            <!--- Categories --->
                            <cfif application.permUtility.getModulePerm("00000000000000000000000000000000010",session.siteid)>
                              <li>
                                <a<cfif  rc.originalcircuit eq 'cCategory'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cCategory.list&amp;siteid=#session.siteid#">
                                  <i class="mi-table"></i>
                                  #application.rbFactory.getKeyValue(session.rb,"layout.categories")#
                                </a>
                              </li>
                            </cfif>
                            <!--- /Categories --->

                            <!--- Content Collections --->
                            <cfif application.settingsManager.getSite(session.siteid).getHasFeedManager() and application.permUtility.getModulePerm("00000000000000000000000000000000011",session.siteid)>
                              <li>
                                <a<cfif  rc.originalcircuit eq 'cFeed' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000011')> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cFeed.list&amp;siteid=#session.siteid#">
                                  <i class="mi-th-list"></i>
                                  #application.rbFactory.getKeyValue(session.rb,"layout.contentcollections")#
                                </a>
                              </li>
                            </cfif>
                            <!--- /Content Collections --->

                            <!--- File Manager --->
                            <li>
                            <a<cfif rc.originalcircuit eq 'cFilemanager'> class="active"</cfif> href="./?muraAction=cFilemanager.default&amp;siteid=#session.siteid#">
                              <i class="mi-cog"></i>
                              #application.rbFactory.getKeyValue(session.rb,"layout.filemanager")#
                            </a>
                            </li>
                            <!--- /File Manager --->

                            <!--- Advertising, this is not only available in certain legacy situations --->
                              <cfif application.settingsManager.getSite(session.siteid).getAdManager() and  application.permUtility.getModulePerm("00000000000000000000000000000000006",session.siteid)>
                                <li>
                                  <a<cfif rc.originalcircuit eq 'cAdvertising' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000006')> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cAdvertising.listAdvertisers&amp;siteid=#session.siteid#&amp;moduleid=00000000000000000000000000000000006">
                                    <i class="mi-cog"></i>
                                    #application.rbFactory.getKeyValue(session.rb,"layout.advertising")#
                                  </a>
                                </li>
                              </cfif>
                            <!--- /Advertising --->

                            <!--- Email Broadcaster --->
                              <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000005",session.siteid)>
                                <li>
                                  <a<cfif rc.originalcircuit eq 'cEmail' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000005')> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cEmail.list&amp;siteid=#session.siteid#">
                                    <i class="mi-cog"></i>
                                    #application.rbFactory.getKeyValue(session.rb,"layout.emailbroadcaster")#
                                  </a>
                                </li>
                              </cfif>
                            <!--- /Email Broadcaster --->

                            <!--- Mailing Lists --->
                              <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009",session.siteid)>
                                <li>
                                  <a<cfif rc.originalcircuit eq 'cMailingList' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000009')> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cMailingList.list&amp;siteid=#session.siteid#">
                                    <i class="mi-cog"></i>
                                    #application.rbFactory.getKeyValue(session.rb,"layout.mailinglists")#
                                  </a>
                                </li>
                              </cfif>
                            <!--- /Mailing Lists --->
						  </ul>
                    </li>

                    <!--- users --->
                    <cfif ListFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2') or (application.settingsManager.getSite(session.siteid).getextranet() and application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#"))>
                        <li id="admin-nav-users"<cfif rc.originalcircuit eq 'cusers'> class="open"</cfif>>
                            <a class="nav-submenu<cfif listFindNoCase('cUsers,cPrivateUsers,cPublicUsers',rc.originalcircuit) or (rc.originalfuseaction eq 'imagedetails' and isDefined('url.userID'))> active</cfif>" data-toggle="nav-submenu" href="##"><i class="mi-users"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.users")#</span></a>
                            <ul>

                                    <!--- view groups --->
                                    <li>
                                        <a<cfif not Len(rc.userid) and IsDefined('rc.ispublic') and rc.ispublic eq 1 and ( request.action eq 'core:cusers.list' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000008') or (rc.originalcircuit eq 'cusers' and len(rc.userid)) )> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cUsers.list&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-users"></i>#rc.$.rbKey("user.viewgroups")#</a>
                                    </li>
                                    <!--- view users --->
                                    <li>
                                        <a<cfif not Len(rc.userid) and IsDefined('rc.ispublic') and rc.ispublic eq 1 and ( request.action eq 'core:cusers.listusers' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000008') or (rc.originalcircuit eq 'cusers' and len(rc.userid)) )> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cUsers.listUsers&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-user"></i>#rc.$.rbKey("user.viewusers")#</a>
                                    </li>
                                    <li class="divider"></li>
                                    <!--- add group --->
                                    <li>
                                        <a<cfif request.action eq "core:cusers.editgroup" and not len(rc.userID)> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cUsers.editgroup&amp;siteid=#esapiEncode('url',session.siteid)#&amp;userid="><i class="mi-user-plus"></i>#rc.$.rbKey('user.addgroup')#</a>
                                    </li>
                                    <!--- add user --->
                                    <li>
                                        <a<cfif request.action eq "core:cusers.edituser" and not len(rc.userID)> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cUsers.edituser&amp;siteid=#esapiEncode('url',session.siteid)#&amp;userid="><i class="mi-user-plus"></i>#rc.$.rbKey('user.adduser')#</a>
                                    </li>
                            </ul>
                        </li>
                    </cfif>

                    <!--- Plugins --->
                      <cfset rc.rsplugins=application.pluginManager.getSitePlugins(siteID=session.siteid, applyPermFilter=true) />
                      <cfif rc.rsplugins.recordcount or listFind(session.mura.memberships,'S2')>
                        <li class="divider"></li>
                        <li  id="admin-plugin-manager"<cfif rc.originalcircuit eq 'cPlugins'> class="open"</cfif>>
                          <a class="nav-submenu<cfif rc.originalcircuit eq 'cPlugins'> active</cfif>" data-toggle="nav-submenu" href="#application.configBean.getContext()#/admin/?muraAction=cPlugins.list&amp;siteid=#session.siteid#">
                            <i class="mi-puzzle-piece"></i>
                            <span class="sidebar-mini-hide">#application.rbFactory.getKeyValue(session.rb,"layout.plugins")#</span>
                          </a>

                          <ul>
                            <li>
                              <a class="<cfif rc.originalcircuit eq 'cplugins' and rc.originalfuseaction eq 'list'> active</cfif>" href="#application.configBean.getContext()#/admin/?muraAction=cPlugins.list&amp;siteid=#session.siteid#">
                                <i class="mi-puzzle-piece"></i>
                                Site Plugins
                              </a>
                            </li>
                            <cfloop query="rc.rsplugins">
                               <li>
                                <a<cfif rc.moduleid eq rc.rsplugins.moduleid> class="active"</cfif> href="#application.configBean.getContext()#/plugins/#rc.rsplugins.directory#/">
                                  <i class="mi-puzzle-piece"></i>
                                  #esapiEncode('html',rc.rsplugins.name)#
                                </a>
                              </li>
                            </cfloop>

                            <!--- Add Plugin --->
                            <cfif listFind(session.mura.memberships,'S2')>
                              <cfif rc.rsplugins.recordcount>
                                <li class="divider"></li>
                              </cfif>
                              <li>
            <!--- TODO GoWest : set active state only when adding plugin (tabPlugins), not for tab 1 : 2015-12-15T11:24:15-07:00 --->
                                <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list##tabPlugins">
                                  <i class="mi-plus-circle"></i>
                                  #application.rbFactory.getKeyValue(session.rb,"layout.addplugin")#
                                </a>
                              </li>
                            </cfif>
                            <!--- /Add Plugin --->
                          </ul>
                        </li>
                      </cfif>
                    <!--- /Plugins --->

                    <!--- site config --->
                    <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
                        <cfset isSiteConfig=listFindNoCase('csettings,cextend,ctrash,cchain,cperm',rc.originalcircuit) and request.action neq "core:csettings.list">
                        <li id="admin-nav-site-config"<cfif isSiteConfig> class="open"</cfif>>
<!--- TODO GoWest : prevent active state when viewing plugin details, e.g.
/admin/?muraAction=cSettings.editPlugin&moduleID=122506FE-7FFC-422E-A010DDC157B75853
and
/admin/?muraAction=cSettings.list#tabPlugins
 : 2015-12-15T11:20:07-07:00 --->

                            <a class="nav-submenu<cfif isSiteConfig> active</cfif>" data-toggle="nav-submenu" href="index.cfm"><i class="mi-wrench"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.sitesettings")#</span></a>

                            <ul>
                                <!--- edit site --->
<!--- TODO GoWest : prevent active state when using 'add new site' - rc.siteid defaults to 'default' rather than '' : 2015-12-18T11:58:19-07:00 --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'editSite' and rc.action neq 'updateFiles'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-edit"></i>#rc.$.rbKey("layout.editcurrentsite")#</a>
                                </li>
                                <!--- permissions --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cPerm'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cPerm.module&amp;contentid=00000000000000000000000000000000000&amp;siteid=#esapiEncode('url',session.siteid)#&amp;moduleid=00000000000000000000000000000000000"><i class="mi-users"></i>Permissions</a>
                                </li>
                                <!--- approval chains --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cChain'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cChain.list&amp;siteid=#esapiEncode('url',session.siteid)#"><i class="mi-check"></i>#rc.$.rbKey("layout.approvalchains")#</a>
                                </li>
                                <!--- class extensions --->
                                <li<cfif rc.originalcircuit eq 'cextend'> class="open"</cfif>>
                                    <a class="nav-submenu" data-toggle="nav-submenu" href="##"><i class="mi-wrench"></i>Class Extensions</a>
                                    <ul>
                                        <!--- class extension manager --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'listSubTypes'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',session.siteid)#">
                                                <i class="mi-cog"></i>
                                                #rc.$.rbKey('layout.classextensionmanager')#
                                            </a>
                                        </li>
                                        <!--- add class extension --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'editSubType'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cExtend.editSubType&amp;subTypeID=&amp;siteid=#esapiEncode('url',session.siteid)#">
                                                <i class="mi-plus-circle"></i>
                                                #rc.$.rbKey("layout.addclassextension")#
                                            </a>
                                        </li>
                                        <!--- import class extension --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'importSubTypes'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cExtend.importSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#">
                                                <i class="mi-sign-in"></i>
                                                #rc.$.rbKey('layout.importclassextensions')#
                                            </a>
                                        </li>
                                        <!--- export class extension --->
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'exportSubType'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cExtend.exportSubType&amp;siteid=#esapiEncode('url',rc.siteid)#">
                                                <i class="mi-sign-out"></i>
                                                #rc.$.rbKey('layout.exportclassextensions')#
                                            </a>
                                        </li>
                                        <!--- list class extensions --->
                                        <cfif rsExts.recordcount>
                                            <li class="divider"></li>
                                            <cfloop query="rsExts">
                                                <li>
                                                    <a<cfif rc.originalcircuit eq 'cExtend' and rc.originalfuseaction eq 'listsets' and rc.subTypeID eq rsExts.subtypeID> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cExtend.listSets&amp;subTypeID=#rsExts.subtypeID#&amp;siteid=#esapiEncode('url',session.siteid)#">
                                                        <i class="<cfif len(exp)>#evaluate(exp)#<cfelse>mi-cog</cfif>"></i>
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
                                        </cfif>
                                    </ul>
                                </li>
                                <!--- /class extensions --->

                                <!--- create site bundle --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'selectBundleOptions'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cSettings.selectBundleOptions&amp;siteID=#esapiEncode('url',rc.siteBean.getSiteID())#">
                                        <i class="mi-gift"></i>
                                        #rc.$.rbKey('layout.createsitebundle')#
                                    </a>
                                </li>
<!--- TODO GoWest : create active link here, is a tab of 'edit site' : 2015-12-18T11:29:28-07:00 --->
                                <!--- deploy site bundle --->
                                <li>
                                    <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)###tabBundles">
                                        <i class="mi-download"></i>
                                        #rc.$.rbKey('layout.deploysitebundle')#
                                    </a>
                                </li>

                                <cfif listFind(session.mura.memberships,'S2')>
                                    <!--- trash bin --->
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cTrash'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cTrash.list&amp;siteID=#esapiEncode('url',session.siteid)#">
                                            <i class="mi-trash"></i>
                                            #rc.$.rbKey('layout.trashbin')#
                                        </a>
                                    </li>

                                    <!--- update site --->
                                    <cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                        <li>
                                            <a<cfif rc.originalcircuit eq 'cSettings' and rc.action eq 'updateFiles'> class="active"</cfif> href="##" onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#&amp;action=updateFiles#rc.$.renderCSRFTokens(context=session.siteid & 'updatesite',format='url')#')});return false;">
                                                <i class="mi-bolt"></i>
                                                #rc.$.rbKey('layout.updatesite')#
                                            </a>
                                        </li>
                                    </cfif>
                                </cfif>

                                <!--- export static html --->
                                <cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'exportHtml'> class="active"</cfif> href="##" onclick="confirmDialog('Export static HTML files to #esapiEncode("javascript","'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=csettings.exportHTML&amp;siteID=#rc.siteBean.getSiteID()#')});return false;">
                                            <i class="mi-cog"></i>
                                            #rc.$.rbKey('layout.exportstatichtml')#
                                        </a>
                                    </li>
                                </cfif>

                            </ul>
                        </li>
                     </cfif>
                    <!--- settings --->
<!--- TODO GoWest : active states for all settings links : 2015-12-15T11:35:55-07:00 --->
                    <cfif listFind(session.mura.memberships,'S2')>
                        <li id="admin-nav-global">
                            <a class="nav-submenu" data-toggle="nav-submenu" href="index.cfm"><i class="mi-cogs"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.globalconfig")#</span></a>

                            <ul>
                                <!--- global settings --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'list'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list"><i class="mi-cogs"></i>#rc.$.rbKey("layout.globalsettings-sites")#</a>
                                </li>
                                <!--- global plugins --->
<!--- TODO GoWest : active state for plugins tab view : 2015-12-18T11:59:17-07:00 --->
<!--- TODO GoWest : show correct tab when clicked and already on global settings view : 2015-12-15T11:34:23-07:00 --->
                                <li>
                                    <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list##tabPlugins"><i class="mi-puzzle-piece"></i>#rc.$.rbKey("layout.globalsettings-plugins")#</a>
                                </li>
                                <!--- add site --->
<!--- TODO GoWest : active state for 'add site' - rc.siteid defaults to 'default' rather than '' : 2015-12-18T11:58:19-07:00 --->
                                <li>
                                    <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid="><i class="mi-plus-circle"></i>#rc.$.rbKey("layout.addsite")#</a>
                                </li>
                                <!--- copy site --->
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.originalfuseaction eq 'siteCopySelect'> class="active"</cfif> href="#application.configBean.getContext()#/admin/?muraAction=cSettings.sitecopyselect"><i class="mi-copy"></i>#rc.$.rbKey("layout.sitecopytool")#</a>
                                </li>
                                <!--- reload application --->
                                <li>
                                    <a href="#application.configBean.getContext()#/admin/?#esapiEncode('url',application.appreloadkey)#&amp;reload=#esapiEncode('url',application.appreloadkey)#" onclick="return actionModal(this.href);"><i class="mi-refresh"></i>#rc.$.rbKey("layout.reloadapplication")#</a>
                                </li>
                                <!--- update core --->
                                <cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                    <li>
                                        <a<cfif rc.originalcircuit eq 'cSettings' and rc.action eq 'updateCore'> class="active"</cfif> href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')});return false;"><i class="mi-bolt"></i>#rc.$.rbKey('layout.updatemuracore')#</a>
                                    </li>
                                </cfif>
                            </ul>
                        </li>
                    </cfif>
                    <!--- help --->
                    <li id="admin-nav-help">
                        <a class="nav-submenu" data-toggle="nav-submenu" href="index.cfm"><i class="mi-question-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.help")#</span></a>

                        <ul>
                            <!--- docs --->
                            <li>
                                <a id="navCSS-API" href="http://docs.getmura.com/v6/" target="_blank"><i class="mi-bookmark"></i>#rc.$.rbKey("layout.developers")#</a>
                            </li>
                            <!--- editor docs --->
                            <li>
                                <a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank"><i class="mi-bookmark"></i>#rc.$.rbKey("layout.editordocumentation")#</a>
                            </li>
                            <!--- component API --->
                            <li>
                                <a id="navProg-API" href="http://www.getmura.com/component-api/6.1/" target="_blank"><i class="mi-bookmark"></i>Component API</a>
                            </li>
                            <!--- professional support --->
                            <li>
                                <a id="navHelpDocs" href="http://www.getmura.com/support/professional-support/" target="_blank"><i class="mi-group"></i>#rc.$.rbKey("layout.support")#</a>
                            </li>
                            <!--- community support --->
                            <li>
                                <a id="navHelpForums" href="http://www.getmura.com/support/community-support/" target="_blank"><i class="mi-bullhorn"></i>#rc.$.rbKey("layout.supportforum")#</a>
                            </li>
                        </ul>
                    </li>
                    <!--- version --->
                    <li>
                        <a class="nav-submenu" data-toggle="nav-submenu" href="index.cfm"><i class="mi-info-circle"></i><span class="sidebar-mini-hide">#rc.$.rbKey("layout.version")#</span></a>
                        <ul class="version">
                            <li class="divider"></li>
                            <!--- core version --->
                            <li>
                                <a href="##" <cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                    onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')});return false;"
                                <cfelse>class="no-link"</cfif> >
                                 <span><strong>#rc.$.rbKey('version.core')#</strong> #application.autoUpdater.getCurrentCompleteVersion()#</span>
                               <!---  <i class="mi-action mi-check" data-toggle="tooltip" data-placement="right" title="Core files are up to date"></i> --->
<!---                                 <i class="mi-action mi-cloud-download" data-toggle="tooltip" data-placement="right" title="New version available (6.2.7890) Click to update"></i>
 --->
                                 </a>
                             </li>

                            <!--- update core --->
                            <cfif listFind(session.mura.memberships,'S2') and (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.action eq 'updateCore'> class="active"</cfif> href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf you are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')});return false;"><i class="mi-bolt"></i>#rc.$.rbKey('layout.updatemuracore')#</a>
                                </li>
                            </cfif>
                            <!--- site version --->
                            <li>
                                <a href="##" <cfif (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')> onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#&amp;action=updateFiles#rc.$.renderCSRFTokens(context=session.siteid & 'updatesite',format='url')#')});return false;"
                                <cfelse> class="no-link"</cfif> >
                                 <span><strong>#rc.$.rbKey('version.site')#</strong> #application.autoUpdater.getCurrentCompleteVersion(session.siteid)#</span>
<!---                                 <i class="mi-action mi-cloud-download" data-toggle="tooltip" data-placement="right" title="New version available (6.2.7890) Click to update"></i>
 --->
                                </a>
                            </li>
                            <!--- update site --->
                            <cfif listFind(session.mura.memberships,'S2') and (not isBoolean(application.configBean.getAllowAutoUpdates()) or application.configBean.getAllowAutoUpdates()) and isDefined('rc.currentUser.renderCSRFTokens')>
                                <li>
                                    <a<cfif rc.originalcircuit eq 'cSettings' and rc.action eq 'updateFiles'> class="active"</cfif> href="##" onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('#application.configBean.getContext()#/admin/?muraAction=cSettings.editSite&amp;siteid=#esapiEncode('url',session.siteid)#&amp;action=updateFiles#rc.$.renderCSRFTokens(context=session.siteid & 'updatesite',format='url')#')});return false;">
                                        <i class="mi-bolt"></i>
                                        #rc.$.rbKey('layout.updatesite')#
                                    </a>
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
                            </cfif>
                            <!--- java version --->
                            <cfif structKeyExists(server,'java') and structKeyExists(server.java,'version') >
                                <li>
                                    <a class="no-link" href="##"> <strong>#rc.$.rbKey('version.java')#</strong> #server.java.version#</a>
                                </li>
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
