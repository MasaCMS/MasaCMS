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
<cfsilent>
<cfparam name="rc.originalfuseaction" default="">
<cfparam name="rc.originalcircuit" default="">
<cfparam name="rc.moduleid" default="">
<cfif not isDefined("session.mura.memberships")>
  <cflocation url="#application.configBean.getContext()#/admin/?muraAction=cLogin.logout" addtoken="false">
</cfif>
</cfsilent><cfoutput>
<header>
	<div class="navbar navbar-top">
	  <div class="navbar-inner">
	   <div class="container">
	      <a class="brand" href="./index.cfm" title="Mura CMS by Blue River">#HTMLEditFormat(application.configBean.getTitle())#</a>
	      <a class="brand-credit" title="Mura CMS by Blue River" target="_blank" href="http://www.blueriver.com"></a>
	      
	      <cfif listFind(session.mura.memberships,'S2IsPrivate')>
	       <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </a>
	         
	          <div class="nav-collapse">
	            <ul class="nav">
	              
	              <cfif application.configBean.getDashboard()>
	                  <cfset baseURL="index.cfm?muraAction=cDashboard.main">
	              <cfelse>
	                   <cfset baseURL="index.cfm?muraAction=cArch.list&amp;moduleID=00000000000000000000000000000000000&amp;topID=00000000000000000000000000000000001">
	               </cfif>
	              
	              <li class="dropdown">
	                <a class="dropdown-toggle">
	                  #application.rbFactory.getKeyValue(session.rb,"layout.selectsite")#
	                  <b class="caret"></b>
	                </a>
	                
	                <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
	                <ul class="dropdown-menu">
	                  <cfloop query="theSiteList">
	                    <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
	                      <a href="#baseURL#&amp;siteID=#theSiteList.siteID#">#HTMLEditFormat(theSiteList.site)#</a>
	                    </li>
	                  </cfloop>
	                </ul>
	              </li>
	
	              <cfset hidelist="cLogin">
	              <cfif not listfindNoCase(hidelist,rc.originalcircuit)>
	                <cfinclude template="dsp_module_menu.cfm">
	              </cfif>
	
	              <cfif session.siteid neq '' 
	                  and listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') 
	                    or listFind(session.mura.memberships,'S2'
	                  )>
	                <li id="navAdminUsers" class="dropdown">
	                  <a class="dropdown-toggle" href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.administrativeusers")#
	                  <b class="caret"></b>
	                  </a>
	                  <ul class="dropdown-menu">
	                  <li><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.viewadministrativeusers")#</a></li>
	                    <li><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.edituser&siteid=#session.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,"layout.adduser")#</a></li>
	                    <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.editgroup&siteid=#session.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,"layout.addgroup")#</a></li>
	                  </ul>
	                </li>
	              </cfif>
	
	               <cfif listFind(session.mura.memberships,'S2')>
	                  <li id="navSiteSettings" class="dropdown">
	                    <a  class="dropdown-toggle" href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.list">
	                      #application.rbFactory.getKeyValue(session.rb,"layout.sitesettings")#
	                      <b class="caret"></b>
	                    </a>
	                    <ul class="dropdown-menu">
	                    <li>
	                        <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.list">#application.rbFactory.getKeyValue(session.rb,"layout.globalsettings")#</a>
	                    </li>
	                    <li>
	                      <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.editcurrentsite")#</a>
	                    </li>
	                    <li>
	                      <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid=">#application.rbFactory.getKeyValue(session.rb,"layout.addsite")#</a>
	                    </li>
	                    <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.sitecopyselect">#application.rbFactory.getKeyValue(session.rb,"layout.sitecopytool")#</a>
	                    </li>
	                    </ul>
	                  </li>
	                </cfif>
	                <cfif session.siteid neq '' and listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
	                 <li id="navEditProfile"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cEditProfile.edit">#application.rbFactory.getKeyValue(session.rb,"layout.editprofile")#</a></li>
	                <li id="navHelp" class="dropdown">
	                  <a  class="dropdown-toggle" href="http://www.getmura.com/index.cfm/support/">#application.rbFactory.getKeyValue(session.rb,"layout.help")#
	                   <b class="caret"></b>
	                  </a>
	                  <ul  class="dropdown-menu">
	                    <li><a id="navHelpDocs" href="http://www.getmura.com/support/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.support")#</a></li>
	                <li>
	                    <a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.editordocumentation")#</a></li>
	                <li><a id="navProg-API" href="http://www.getmura.com/mura/5/components/" target="_blank">Component API</a></li>
	                <li><a id="navCSS-API" href="http://docs.getmura.com/index.cfm/developer-guides/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.developers")#</a></li>
	                   <li class="last"><a id="navHelpForums" href="http://www.getmura.com/forum/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.supportforum")#</a></li>
	                  </ul>
	                </li>
	                <li id="navLogout"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
	                </cfif> 
	              </ul>
	          </div><!--/.nav-collapse -->
	     
	    </div>
	    </cfif>
	   </div>
	  </div>
	</div>
</header>
</cfoutput>