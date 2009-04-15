<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfif session.siteid neq ''>
  <cfoutput>
    <ul id="navSecondary">
		<li <cfif  myfusebox.originalcircuit eq 'cDashboard'>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#">#application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</a>
        	<cfif  myfusebox.originalcircuit eq 'cDashboard'><cfinclude template="../../view/vDashboard/dsp_secondary_menu.cfm"></cfif>
		</li>
      <li <cfif attributes.moduleid eq '00000000000000000000000000000000000' and myfusebox.originalcircuit eq 'cArch'>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a>
	   <cfif attributes.moduleid eq '00000000000000000000000000000000000' and myfusebox.originalcircuit neq 'cDashboard'>
	    <cfinclude template="../../view/vArchitecture/dsp_secondary_menu.cfm"></cfif></li>
      <li <cfif myfusebox.originalfuseaction eq 'draft'>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.draft&siteid=#session.siteid#" >#application.rbFactory.getKeyValue(session.rb,"layout.drafts")#</a></li>
      <cfif application.permUtility.getModulePerm("00000000000000000000000000000000003","#session.siteid#")>
        <li <cfif attributes.moduleid eq '00000000000000000000000000000000003'>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list&siteid=#session.siteid#&topid=00000000000000000000000000000000003&parentid=00000000000000000000000000000000003&moduleid=00000000000000000000000000000000003">#application.rbFactory.getKeyValue(session.rb,"layout.components")#</a>
          <cfif attributes.moduleid eq '00000000000000000000000000000000003' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000003')>
            <cfinclude template="../../view/vArchitecture/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
		<li<cfif myfusebox.originalcircuit eq 'cPlugins' > id="current"</cfif>>
		<a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPlugins.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.plugins")#</a>
        </li>
      <cfif application.permUtility.getModulePerm("00000000000000000000000000000000010","#session.siteid#")>
        <li <cfif  myfusebox.originalcircuit eq 'cCategory' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000010')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cCategory.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.categories")#</a>
          <cfif myfusebox.originalcircuit eq 'cCategory' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000010')>
            <cfinclude template="../../view/vCategory/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
      <cfif application.settingsManager.getSite(session.siteid).getHasFeedManager() and application.permUtility.getModulePerm("00000000000000000000000000000000011","#session.siteid#")>
        <li <cfif  myfusebox.originalcircuit eq 'cFeed' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000011')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFeed.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.contentcollections")#</a>
          <cfif myfusebox.originalcircuit eq 'cFeed' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000011')>
            <cfinclude template="../../view/vFeed/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
      <cfif application.settingsManager.getSite(session.siteid).getDataCollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004","#session.siteid#")>
        <li <cfif attributes.moduleid eq '00000000000000000000000000000000004' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000004')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list&siteid=#session.siteid#&topid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004&moduleid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,"layout.forms")#</a>
          <cfif attributes.moduleid eq '00000000000000000000000000000000004'>
            <cfinclude template="../../view/vArchitecture/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
	
	   <cfif application.settingsManager.getSite(session.siteid).getextranet() and  application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#")>
        <li <cfif myfusebox.originalcircuit eq 'cPublicUsers' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000008')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPublicUsers.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.sitemembers")#</a>
          <cfif myfusebox.originalcircuit eq 'cPublicUsers' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000008')>
            <cfinclude template="../../view/vPublicUsers/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
	
      <cfif application.settingsManager.getSite(session.siteid).getAdManager() and  application.permUtility.getModulePerm("00000000000000000000000000000000006","#session.siteid#")>
        <li <cfif myfusebox.originalcircuit eq 'cAdvertising' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000006')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cAdvertising.listAdvertisers&siteid=#session.siteid#&moduleid=00000000000000000000000000000000006">#application.rbFactory.getKeyValue(session.rb,"layout.advertising")#</a>

          <cfif myfusebox.originalcircuit eq 'cAdvertising' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000006')>
            <cfinclude template="../../view/vAdvertising/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
	   
      <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000005","#session.siteid#")>
        <li <cfif myfusebox.originalcircuit eq 'cEmail' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000005')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cEmail.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.emailbroadcaster")#</a>
          <cfif myfusebox.originalcircuit eq 'cEmail' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000005')>
            <cfinclude template="../../view/vEmail_Broadcaster/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
      <cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009","#session.siteid#")>
        <li <cfif myfusebox.originalcircuit eq 'cMailingList' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000009')>id="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cMailingList.list&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.mailinglists")#</a>
          <cfif myfusebox.originalcircuit eq 'cMailingList' or (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000009')>
            <cfinclude template="../../view/vMailingList/dsp_secondary_menu.cfm">
          </cfif>
        </li>
      </cfif>
	
	  <cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##session.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_secondary_menu.cfm")> 
			<cfinclude template="/#application.configBean.getWebRootMap()#/#session.siteID#/includes/display_objects/custom/admin/dsp_secondary_menu.cfm" >
	  </cfif>
	  
      <!--- <cfif isuserInRole('S2') or isuserInRole('Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#')><li<cfif myfusebox.originalcircuit eq 'cPrivateUsers'>id="current"</cfif>><a href="index.cfm?fuseaction=cPrivateUsers.list&siteid=#session.siteid#" >Administrative Users</a><cfif myfusebox.originalcircuit eq 'cPrivateUsers'><cfinclude template="../../view/vPrivateUsers/dsp_secondary_menu.cfm"></cfif></li></cfif> --->
      <cfif isUserInRole('S2')>
        <li <cfif myfusebox.originalcircuit eq 'cFilemanager'>id="current"</cfif>><a href="index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.filemanager")#</a>
<cfif myfusebox.originalcircuit eq 'cFilemanager'>
<ul>
<li<cfif session.location eq 'assets'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=&location=assets">#application.rbFactory.getKeyValue(session.rb,"layout.userassets")#</a></li>
<li<cfif session.location eq 'files'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=&location=files">#application.rbFactory.getKeyValue(session.rb,"layout.sitefiles")#</a></li>
<cfif isUserInRole('S2')>
<li<cfif session.location eq 'root'> class="current"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFilemanager.default&siteid=#session.siteid#&subdir=&location=root">#application.rbFactory.getKeyValue(session.rb,"layout.applicationroot")#</a></li>
</cfif>
</ul>
</cfif>
</li>
      </cfif>
      <cfif isUserInRole('Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')>
        <li <cfif (myfusebox.originalcircuit eq 'cPerm' and  attributes.moduleid eq '00000000000000000000000000000000000')>id='current'</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cPerm.module&contentid=00000000000000000000000000000000000&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000">#application.rbFactory.getKeyValue(session.rb,"layout.permissions")#</a></li>
      </cfif>
	<cfif isuserInRole('S2')>
	  <li><a href="#application.configBean.getContext()#/admin/index.cfm?#urlEncodedFormat(application.appreloadkey)#&fusebox.load=true&fusebox.password=#urlEncodedFormat(application.appreloadkey)#">#application.rbFactory.getKeyValue(session.rb,"layout.reloadapplication")#</a></li>
	  </cfif>
    </ul>
  </cfoutput>
</cfif>
