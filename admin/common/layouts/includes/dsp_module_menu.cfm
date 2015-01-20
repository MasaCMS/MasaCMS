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
<cfif session.siteid neq ''>

  <cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 30>
    <cfparam name="session.dashboardSpan" default="30">
  <cfelse>
    <cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
  </cfif>

  <cfoutput>
    <li id="modules" class="dropdown<cfif listFind('00000000000000000000000000000000003,00000000000000000000000000000000004',rc.moduleID) or not listFindNoCase('carch,cchain,cusers,csettings,cdashboard,ceditprofile,nmessage,ctrash,clogin,cextend',rc.originalcircuit) and not (rc.moduleID eq '00000000000000000000000000000000000' and rc.originalcircuit eq 'cPerm')> active</cfif>">
      <a class="dropdown-toggle" data-toggle="dropdown" href="##">
        <i class="icon-th-large"></i> 
        <span>#application.rbFactory.getKeyValue(session.rb,"layout.modules")#</span> 
        <b class="caret"></b>
      </a>

      <ul id="navSecondary" class="dropdown-menu">
        <!--- Change Sets --->
          <cfif isNumeric(application.settingsManager.getSite(session.siteid).getValue("HasChangesets"))>
            <cfif application.settingsManager.getSite(session.siteid).getHasChangesets() and application.permUtility.getModulePerm("00000000000000000000000000000000014",session.siteid)>
              <li <cfif  rc.originalcircuit eq 'cChangesets' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000014')>class="active"</cfif>>
                <a href="#application.configBean.getContext()#/admin/?muraAction=cChangesets.list&amp;siteid=#session.siteid#">
                  <i class="icon-cog"></i> 
                  #application.rbFactory.getKeyValue(session.rb,"layout.changesets")#
                </a>
              </li>
            </cfif> 
          </cfif>
        <!--- /Change Sets --->

        <!--- Comments --->
          <cfif isBoolean(application.settingsManager.getSite(session.siteid).getHasComments()) and application.settingsManager.getSite(session.siteid).getHasComments() and application.permUtility.getModulePerm("00000000000000000000000000000000015",session.siteid)>
            <li <cfif rc.originalcircuit eq 'cComments'>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cComments.default&amp;siteid=#session.siteid#">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,'layout.comments')#
              </a>
            </li>
          </cfif>
        <!---- /Comments --->

        <!--- Components --->
          <cfif application.permUtility.getModulePerm("00000000000000000000000000000000003",session.siteid)>
            <li <cfif rc.moduleid eq '00000000000000000000000000000000003'>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#session.siteid#&amp;topid=00000000000000000000000000000000003&amp;parentid=00000000000000000000000000000000003&amp;moduleid=00000000000000000000000000000000003">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.components")#
              </a>
            </li>
          </cfif>
        <!---- /Components --->
       
        <!--- Categories --->
          <cfif application.permUtility.getModulePerm("00000000000000000000000000000000010",session.siteid)>
            <li <cfif  rc.originalcircuit eq 'cCategory' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000010')>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cCategory.list&amp;siteid=#session.siteid#">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.categories")#
              </a>
            </li>
          </cfif>
        <!--- /Categories --->

        <!--- Content Collections --->
          <cfif application.settingsManager.getSite(session.siteid).getHasFeedManager() and application.permUtility.getModulePerm("00000000000000000000000000000000011",session.siteid)>
            <li <cfif  rc.originalcircuit eq 'cFeed' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000011')>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cFeed.list&amp;siteid=#session.siteid#">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.contentcollections")#
              </a>
            </li>
          </cfif>
        <!--- /Content Collections --->

        <!--- Forms --->
          <cfif application.settingsManager.getSite(session.siteid).getDataCollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004",session.siteid)>
            <li <cfif rc.moduleid eq '00000000000000000000000000000000004' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000004')>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cArch.list&amp;siteid=#session.siteid#&amp;topid=00000000000000000000000000000000004&amp;parentid=00000000000000000000000000000000004&amp;moduleid=00000000000000000000000000000000004">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.forms")#
              </a>
            </li>
          </cfif>
        <!--- /Forms --->

        <!--- Advertising, this is not only available in certain legacy situations --->
          <cfif application.settingsManager.getSite(session.siteid).getAdManager() and  application.permUtility.getModulePerm("00000000000000000000000000000000006",session.siteid)>
            <li <cfif rc.originalcircuit eq 'cAdvertising' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000006')>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cAdvertising.listAdvertisers&amp;siteid=#session.siteid#&amp;moduleid=00000000000000000000000000000000006">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.advertising")#
              </a>
            </li>
          </cfif>
        <!--- /Advertising --->

        <!--- Email Broadcaster --->     
          <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000005",session.siteid)>
            <li <cfif rc.originalcircuit eq 'cEmail' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000005')>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cEmail.list&amp;siteid=#session.siteid#">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.emailbroadcaster")#
              </a>
            </li>
          </cfif>
        <!--- /Email Broadcaster --->
        
        <!--- Mailing Lists --->
          <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009",session.siteid)>
            <li <cfif rc.originalcircuit eq 'cMailingList' or (rc.originalcircuit eq 'cPerm' and rc.moduleid eq '00000000000000000000000000000000009')>class="active"</cfif>>
              <a href="#application.configBean.getContext()#/admin/?muraAction=cMailingList.list&amp;siteid=#session.siteid#">
                <i class="icon-cog"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.mailinglists")#
              </a>
            </li>
          </cfif>
        <!--- /Mailing Lists --->
      
        <!--- Custom Site Secondary Menu --->
          <cfif fileExists("#application.configBean.getWebRoot()#/#session.siteid#/includes/display_objects/custom/admin/dsp_secondary_menu.cfm")> 
            <cfinclude template="/#application.configBean.getWebRootMap()#/#session.siteID#/includes/display_objects/custom/admin/dsp_secondary_menu.cfm" >
          </cfif>
        <!--- /Custom Site Secondary Menu --->

        <!--- File Manager --->
          <li <cfif rc.originalcircuit eq 'cFilemanager'>class="active"</cfif>>
            <a href="./?muraAction=cFilemanager.default&amp;siteid=#session.siteid#">
              <i class="icon-cog"></i> 
              #application.rbFactory.getKeyValue(session.rb,"layout.filemanager")#
            </a>
          </li>
        <!--- /File Manager --->

        <!--- Plugins --->    
          <cfset rc.rsplugins=application.pluginManager.getSitePlugins(siteID=session.siteid, applyPermFilter=true) />
          <cfif rc.rsplugins.recordcount or listFind(session.mura.memberships,'S2')>
            <li class="divider"></li>
            <li class="dropdown-submenu<cfif rc.originalcircuit eq 'cPlugins'> active</cfif>">
              <a href="#application.configBean.getContext()#/admin/?muraAction=cPlugins.list&amp;siteid=#session.siteid#">
                <i class="icon-puzzle-piece"></i> 
                #application.rbFactory.getKeyValue(session.rb,"layout.plugins")#
              </a>

              <ul class="dropdown-menu">
                <cfloop query="rc.rsplugins">
                   <li<cfif rc.moduleid eq rc.rsplugins.moduleid> class="active"</cfif>>
                    <a href="#application.configBean.getContext()#/plugins/#rc.rsplugins.directory#/">
                      <i class="icon-puzzle-piece"></i> 
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
                    <a href="#application.configBean.getContext()#/admin/?muraAction=cSettings.list##tabPlugins">
                      <i class="icon-plus-sign"></i> 
                      #application.rbFactory.getKeyValue(session.rb,"layout.addplugin")#
                    </a>
                  </li>
                </cfif>
                <!--- /Add Plugin --->
              </ul>
            </li>
          </cfif>
        <!--- /Plugins --->
      </ul>
    </li>
  </cfoutput>

</cfif>