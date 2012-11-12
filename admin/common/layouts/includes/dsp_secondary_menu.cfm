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
  <cfif  rc.originalcircuit eq 'cDashboard'>
    <cfinclude template="/muraWRM/admin/core/views/cdashboard/dsp_secondary_menu.cfm">
  </cfif>  
	<cfif rc.moduleid eq '00000000000000000000000000000000000' and rc.originalcircuit neq 'cDashboard'>
    <cfinclude template="/muraWRM/admin/core/views/carch/dsp_secondary_menu.cfm">
  </cfif>
  <cfif rc.originalcircuit eq 'cChangesets' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000014')>
    <cfinclude template="/muraWRM/admin/core/views/cchangesets/dsp_secondary_menu.cfm">
  </cfif>
  <cfif rc.moduleid eq '00000000000000000000000000000000003' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000003')>
     <cfinclude template="/muraWRM/admin/core/views/carch/dsp_secondary_menu.cfm">
  </cfif>
	<cfif rc.originalcircuit eq 'cCategory' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000010')>
    <cfinclude template="/muraWRM/admin/core/views/ccategory/dsp_secondary_menu.cfm">
  </cfif>
  <cfif rc.originalcircuit eq 'cFeed' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000011')>
    <cfinclude template="/muraWRM/admin/core/views/cfeed/dsp_secondary_menu.cfm">
  </cfif>
  <cfif rc.moduleid eq '00000000000000000000000000000000004'>
    <cfinclude template="/muraWRM/admin/core/views/carch/dsp_secondary_menu.cfm">
  </cfif>
  <cfif rc.originalcircuit eq 'cPublicUsers' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000008')>
    <cfinclude template="/muraWRM/admin/core/views/cpublicusers/dsp_secondary_menu.cfm">
  </cfif>
  <cfif rc.originalcircuit eq 'cAdvertising' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000006')>
    <cfinclude template="/muraWRM/admin/core/views/cadvertising/dsp_secondary_menu.cfm">
  </cfif>
   <cfif rc.originalcircuit eq 'cEmail' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000005')>
      <cfinclude template="/muraWRM/admin/core/views/cemail/dsp_secondary_menu.cfm">
   </cfif>
    <cfif rc.originalcircuit eq 'cMailingList' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000009')>
      <cfinclude template="/muraWRM/admin/core/views/cmailinglist/dsp_secondary_menu.cfm">
    </cfif>
	  
	  
      <!--- <cfif listFind(session.mura.memberships,'S2') or listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0')><li<cfif rc.originalcircuit eq 'cPrivateUsers'>id="current"</cfif>><a href="index.cfm?muraAction=cPrivateUsers.list&siteid=#session.siteid#" >Administrative Users</a><cfif rc.originalcircuit eq 'cPrivateUsers'><cfinclude template="../../view/vPrivateUsers/dsp_secondary_menu.cfm"></cfif></li></cfif> --->
     
  <!---
	 <cfif rc.originalcircuit eq 'cFilemanager'>
    <ul class="nav nav-pills">
			<li<cfif session.resourceType eq 'assets'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=assets">#application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</a></li>
			<cfif listFind(session.mura.memberships,'S2')>
				<cfif application.configBean.getValue('fmShowSiteFiles') neq 0>
					<li<cfif session.resourceType eq 'files'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=files">#application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</a></li>
					</cfif>
					<cfif listFind(session.mura.memberships,'S2') and application.configBean.getValue('fmShowApplicationRoot') neq 0>
					<li<cfif session.resourceType eq 'root'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cFilemanager.default&siteid=#session.siteid#&resourceType=root">#application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</a></li>
				</cfif>
				</li>
			</cfif>
		</ul>
	</cfif>
  --->
  </cfoutput>
</cfif>
	

