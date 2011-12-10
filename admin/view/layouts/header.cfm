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
<cfif not isDefined("session.mura.memberships")>
<cflocation url="#application.configBean.getContext()#/admin/?fuseaction=cLogin.logout" addtoken="false">
</cfif>
</cfsilent>
<cfoutput>
  <cfif listFind(session.mura.memberships,'S2IsPrivate')>
    <div id="header">
      <a id="blueRiverLink" href="http://blueriver.com" target="_blank" title="mura by blueRiver"></a>
	  <h1>#application.configBean.getTitle()#</h1>
      <ul id="navUtility">
        <cfif session.siteid neq '' and listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
          <li id="navAdminUsers"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.administrativeusers")#</a>
            <ul class="addMenuNav">
	          <li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.viewadministrativeusers")#</a></li>
              <li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.edituser&siteid=#session.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,"layout.adduser")#</a></li>
              <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.editgroup&siteid=#session.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,"layout.addgroup")#</a></li>
            </ul>
          </li>
        </cfif>
        <cfif listFind(session.mura.memberships,'S2')>
          <li id="navSiteSettings"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.list">#application.rbFactory.getKeyValue(session.rb,"layout.sitesettings")#</a>
            <ul class="addMenuNav">
            <li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.list">#application.rbFactory.getKeyValue(session.rb,"layout.globalsettings")#</a></li>
			<li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.editSite&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.editcurrentsite")#</a></li>
              <li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.editSite&siteid=">#application.rbFactory.getKeyValue(session.rb,"layout.addsite")#</a></li>
			  <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.sitecopyselect">#application.rbFactory.getKeyValue(session.rb,"layout.sitecopytool")#</a></li>
            </ul>
          </li>
        </cfif>
        <li id="navEditProfile"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cEditProfile.edit">#application.rbFactory.getKeyValue(session.rb,"layout.editprofile")#</a></li>
        <li id="navHelp"><a href="http://www.getmura.com/index.cfm/support/">#application.rbFactory.getKeyValue(session.rb,"layout.help")#</a>
          <ul class="addMenuNav"><li><a id="navHelpDocs" href="http://docs.getmura.com/index.cfm">#application.rbFactory.getKeyValue(session.rb,"layout.cmsdocumentation")#</a></li>
	    	<li><a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.editordocumentation")#</a></li>
	    	<li><a id="navProg-API" href="http://www.getmura.com/mura/5/components/" target="_blank">Component API</a></li>
	    	<li><a id="navCSS-API" href="http://docs.getmura.com/index.cfm/developer-guides/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.developers")#</a></li>
           <li class="last"><a id="navHelpForums" href="http://www.getmura.com/forum/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.supportforum")#</a></li>
          </ul>
        </li>
        <li id="navLogout"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
      </ul>
	  <div id="siteSelectWrapper">
      <form novalidate="novalidate" id="siteSelect" name="siteSelect" method="get" action="#application.configBean.getContext()#/admin/">
       	<cfif application.configBean.getDashboard()>
		<input type="hidden" name="fuseaction" value="cDashboard.main">
		<cfelse>
		<input type="hidden" name="fuseaction" value="cArch.list">
		<input type="hidden" name="moduleID" value="00000000000000000000000000000000000">
		<input type="hidden" name="topID" value="00000000000000000000000000000000001">
		</cfif>
        <select name="siteid" onchange="if(this.value != ''){document.forms.siteSelect.submit();}">
			<option vaue="">#application.rbFactory.getKeyValue(session.rb,"layout.selectsite")#</option>
		    <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
		  	<cfloop query="theSiteList">
			<option value="#theSiteList.siteid#">#theSiteList.site#</option>
			</cfloop>
        </select>
      </form>
	  </div>
     <cftry><cfset siteName=application.settingsManager.getSite(session.siteid).getSite()><cfif len(siteName)><p id="currentSite">#application.rbFactory.getKeyValue(session.rb,"layout.currentsite")# &rarr; <a href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.configBean.getStub()#/<cfif application.configBean.getSiteIDInURLS()>#session.siteid#/</cfif>" target="_blank">#application.settingsManager.getSite(session.siteid).getSite()#</a></p></cfif><cfcatch></cfcatch></cftry>
	<p id="welcome"><strong>#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</strong><cfif yesNoFormat(application.configBean.getValue("sessionTimeout"))> #application.rbFactory.getKeyValue(session.rb,"layout.loggedoutin")# <span id="clock">0:00:00</span>.</cfif></p>
    </div>
    <cfelse>
    <div id="header">
	  <a id="blueRiverLink" href="http://www.blueriver.com" target="_blank" title="Mura CMS by Blue River"></a>
      <h1>#application.configBean.getTitle()#</h1>
	  <div id="siteSelectWrapper"></div>
    </div>
  </cfif>
</cfoutput>