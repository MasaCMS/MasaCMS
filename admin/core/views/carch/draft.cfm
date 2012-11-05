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
<cfinclude template="js.cfm">
<cfset listed=0><cfoutput>
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts')#</h1>
	<table class="table table-striped table-condensed table-bordered mura-table-grid">
    <tr> 
      <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts.title')#</th>
	  <th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts.contenttype')#</th>
      <th class="actions">&nbsp;</th>
    </tr></cfoutput>
   
      <cfoutput query="rc.rslist">
	  <cfset itemcrumbdata=application.contentManager.getCrumbList(rc.rslist.contentid,rc.siteid)>
	  <cfset itemperm=application.permUtility.getnodePerm(itemcrumbdata)>
<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2') or itemperm eq 'editor' or itemperm eq 'author'>
      
		<tr> 
        <td class="var-width">
<cfswitch expression="#rc.rslist.type#">
<cfcase value="Form,Component">
<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rslist.ContentID#&type=#rc.rslist.type#&parentid=#rc.rslist.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleid#">#rc.rslist.menutitle#</a>
</cfcase>
<cfdefaultcase>
#application.contentRenderer.dspZoom(itemcrumbdata)#</cfdefaultcase>
</cfswitch></td>
			<td>#rc.rslist.module#</td> 
          <td class="actions"><ul class="drafts"><li class="version-history"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rslist.ContentID#&type=#rc.rslist.type#&parentid=#rc.rslist.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleid#"><i class="icon-book"></i></a></li></ul></td>
        </tr>
		<cfset listed=1>
	  </cfif>
      </cfoutput> 
      <cfif not listed>
      <tr> 
        <td colspan="3" class="noResults">
	<cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts.nodrafts')#</cfoutput>
        </td>
      </tr>
	  </cfif>
</table>

