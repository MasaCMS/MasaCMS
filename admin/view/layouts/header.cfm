<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfoutput>
  <cfif isUserInRole('S2IsPrivate')>
    <div id="header">
      <h1>#application.configBean.getTitle()#</h1>
      <ul id="navUtility">
        <cfif session.siteid neq '' and isUserInRole('Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')>
          <li id="navAdminUsers"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.administrativeusers")#</a>
            <ul>
              <li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.edituser&siteid=#session.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,"layout.adduser")#</a></li>
              <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPrivateUsers.editgroup&siteid=#session.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,"layout.addgroup")#</a></li>
            </ul>
          </li>
        </cfif>
        <cfif isUserInRole('S2')>
          <li id="navSiteSettings"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.list">#application.rbFactory.getKeyValue(session.rb,"layout.sitesettings")#</a>
            <ul>
			<li><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.editSite&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.editcurrentsite")#</a></li>
              <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cSettings.editSite&siteid=">#application.rbFactory.getKeyValue(session.rb,"layout.addsite")#</a></li>
            </ul>
          </li>
        </cfif>
        <li id="navEditProfile"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cEditProfile.edit">#application.rbFactory.getKeyValue(session.rb,"layout.editprofile")#</a></li>
        <li id="navHelp"><a href="http://www.getmura.com/go/sava/support/index.cfm">#application.rbFactory.getKeyValue(session.rb,"layout.help")#</a>
          <ul><li><a id="navHelpDocs" href="http://docs.getmura.com/go/v5/index.cfm">#application.rbFactory.getKeyValue(session.rb,"layout.cmsdocumentation")#</a></li>
	    	<li><a id="navFckEditorDocs" href="http://docs.fckeditor.net/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.editordocumentation")#</a></li>
	    	<li><a id="navProg-API" href="http://documentation.blueriver.com/sava/5/components/" target="_blank">Programmer API</a></li>
	    	<li><a id="navCSS-API" href="http://docs.getmura.com/go/v5/developer-guide/front-end-development/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.xhtmlcssapi")#</a></li>
           <li class="last"><a id="navHelpForums" href="http://www.getmura.com/sava/forum/" target="_blank">#application.rbFactory.getKeyValue(session.rb,"layout.supportforum")#</a></li>
          </ul>
        </li>
        <li id="navLogout"><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
      </ul>
      <form id="siteSelect" name="siteSelect" method="get" action="#application.configBean.getContext()#/admin/">
        <input type="hidden" name="fuseaction" value="cDashboard.main">
        <select name="siteid" onchange="if(this.value != ''){document.forms.siteSelect.submit();}">
			<option vaue="">#application.rbFactory.getKeyValue(session.rb,"layout.selectsite")#</option>
		    <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,isUserInRole('S2')) />
		  	<cfloop query="theSiteList">
			<option value="#theSiteList.siteid#">#theSiteList.site#</option>
			</cfloop>
        </select>
      </form>
     <cftry><cfset siteName=application.settingsManager.getSite(session.siteid).getSite()><cfif len(siteName)><p id="currentSite">#application.rbFactory.getKeyValue(session.rb,"layout.currentsite")# &rarr; <a href="#application.configBean.getContext()##application.configBean.getStub()#/#session.siteid#/" target="_blank">#application.settingsManager.getSite(session.siteid).getSite()#</a></p></cfif><cfcatch></cfcatch></cftry>
	<p id="welcome"><strong>#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #listgetat(getauthuser(),2,"^")#.</strong> #application.rbFactory.getKeyValue(session.rb,"layout.loggedoutin")# <span id="clock">3:00:00</span>.</p>
  </form>
    </div>
    <cfelse>
    <div id="header">
      <h1>#application.configBean.getTitle()#</h1>
    </div>
  </cfif>
</cfoutput>