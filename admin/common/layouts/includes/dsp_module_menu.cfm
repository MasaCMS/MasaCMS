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
<cfif session.siteid neq ''>
<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 30>
	<cfparam name="session.dashboardSpan" default="30">
<cfelse>
	<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
</cfif>
<cfoutput>

<li class="dropdown<cfif listFind('00000000000000000000000000000000003,00000000000000000000000000000000004',rc.moduleID) or not listFindNoCase('carch,cprivateusers,cpublicusers,csettings,cdashboard,ceditprofile,nmessage,ctrash,clogin,cextend',rc.originalcircuit) and not (rc.moduleID eq '00000000000000000000000000000000000' and rc.originalcircuit eq 'cPerm')> active</cfif>">
  <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-th-large"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.modules")#</span> <b class="caret"></b></a>
  <ul id="navSecondary" class="dropdown-menu">
		
      <!--- Made this a main subnav item
      <li <cfif rc.moduleid eq '00000000000000000000000000000000000' and rc.originalcircuit eq 'cArch'>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a>--->
	
  <!--- Moved to flat view 
  <li <cfif rc.originalfuseaction eq 'draft'>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.draft&siteid=#session.siteid#" ><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.drafts")#</a></li>--->
    
	<cfif isNumeric(application.settingsManager.getSite(session.siteid).getValue("HasChangesets"))>
	  <cfif application.settingsManager.getSite(session.siteid).getHasChangesets() and application.permUtility.getModulePerm("00000000000000000000000000000000014","#session.siteid#")>
        <li <cfif  rc.originalcircuit eq 'cChangesets' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000014')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cChangesets.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.changesets")#</a>
        </li>
      </cfif> 
	</cfif>  
	
	    <cfif application.permUtility.getModulePerm("00000000000000000000000000000000000","#session.siteid#")>
        <li <cfif rc.moduleid eq '00000000000000000000000000000000003'>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#session.siteid#&topid=00000000000000000000000000000000003&parentid=00000000000000000000000000000000003&moduleid=00000000000000000000000000000000003"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.components")#</a>
        </li>
      </cfif>
	 
	 <!--- Categories --->
      <cfif application.permUtility.getModulePerm("00000000000000000000000000000000010","#session.siteid#")>
        <li <cfif  rc.originalcircuit eq 'cCategory' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000010')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cCategory.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.categories")#</a>
        </li>
      </cfif>
      <cfif application.settingsManager.getSite(session.siteid).getHasFeedManager() and application.permUtility.getModulePerm("00000000000000000000000000000000011","#session.siteid#")>
        <li <cfif  rc.originalcircuit eq 'cFeed' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000011')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFeed.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.contentcollections")#</a>
        </li>
      </cfif>
      <cfif application.settingsManager.getSite(session.siteid).getDataCollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004","#session.siteid#")>
        <li <cfif rc.moduleid eq '00000000000000000000000000000000004' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000004')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#session.siteid#&topid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004&moduleid=00000000000000000000000000000000004"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.forms")#</a>
        </li>
      </cfif>
	
	   <!---<cfif application.settingsManager.getSite(session.siteid).getextranet() and  application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#")>
        <li <cfif rc.originalcircuit eq 'cPublicUsers' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000008')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPublicUsers.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitemembers")#</a>
        </li>
      </cfif>--->
	
      <cfif application.settingsManager.getSite(session.siteid).getAdManager() and  application.permUtility.getModulePerm("00000000000000000000000000000000006","#session.siteid#")>
        <li <cfif rc.originalcircuit eq 'cAdvertising' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000006')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cAdvertising.listAdvertisers&siteid=#session.siteid#&moduleid=00000000000000000000000000000000006"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.advertising")#</a>
        </li>
      </cfif>
	   
      <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000005","#session.siteid#")>
        <li <cfif rc.originalcircuit eq 'cEmail' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000005')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cEmail.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.emailbroadcaster")#</a>
        </li>
      </cfif>
      <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009","#session.siteid#")>
        <li <cfif rc.originalcircuit eq 'cMailingList' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000009')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cMailingList.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.mailinglists")#</a>
        </li>
      </cfif>
	
	  <cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##session.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_secondary_menu.cfm")> 
			<cfinclude template="/#application.configBean.getWebRootMap()#/#session.siteID#/includes/display_objects/custom/admin/dsp_secondary_menu.cfm" >
	  </cfif>
	  
      <!--- <cfif listFind(session.mura.memberships,'S2') or listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0')><li<cfif rc.originalcircuit eq 'cPrivateUsers'>class="active"</cfif>><a href="index.cfm?muraAction=cPrivateUsers.list&siteid=#session.siteid#" >Administrative Users</a><cfif rc.originalcircuit eq 'cPrivateUsers'><cfinclude template="../../view/vPrivateUsers/dsp_secondary_menu.cfm"></cfif></li></cfif> --->
     
	
  	<li <cfif rc.originalcircuit eq 'cFilemanager'>class="active"</cfif>><a href="index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.filemanager")#</a>
  	</li>
    <cfset rc.rsplugins=application.pluginManager.getSitePlugins(siteID=session.siteid, applyPermFilter=true) />
     <cfif rc.rsplugins.recordcount or listFind(session.mura.memberships,'S2')>
      <li class="divider"></li>
      <li class="dropdown-submenu<cfif rc.originalcircuit eq 'cPlugins' > active</cfif>">
      <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPlugins.list&siteid=#session.siteid#"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.plugins")#</a>
  	   
  	   <ul class="dropdown-menu">
  	     <cfloop query="rc.rsplugins">
  	         <li><a href="#application.configBean.getContext()#/plugins/#rc.rsplugins.directory#/"><i class="icon-cog"></i> #HTMLEditFormat(rc.rsplugins.name)#</a>
  	        </li>
  	     </cfloop> 
         <cfif listFind(session.mura.memberships,'S2')>
         <cfif rc.rsplugins.recordcount>
           <li class="divider"></li>
         </cfif>
          <li><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.list##tabPlugins"><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addplugin")#</a>
      </cfif>
  	   </ul>
        
      </li>
    </cfif>
     <!---
     <cfif isdefined("request.event")>
     	<cfset pluginEvent=request.event>
     <cfelse>
     	<cfset params.siteID=session.siteID>
     	<cfset pluginEvent=createObject("component","mura.event")>
     	<cfset pluginEvent.init(params)>
     </cfif>
     #application.pluginManager.renderEvent("onAdminModuleNav",pluginEvent)#
     --->
    </ul>
  </cfoutput>
</cfif>
</li>
