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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->


<cfset listed=0><cfoutput>
	<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts')#</h2>
	<table class="stripe">
    <tr> 
      <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts.title')#</th>
	  <th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.drafts.contenttype')#</th>
      <th class="administration">&nbsp;</th>
    </tr></cfoutput>
   
      <cfoutput query="request.rslist">
	  <cfset itemcrumbdata=application.contentManager.getCrumbList(request.rslist.contentid,attributes.siteid)>
	  <cfset itemperm=application.permUtility.getnodePerm(itemcrumbdata)>
<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2') or itemperm eq 'editor' or itemperm eq 'author'>
      
		<tr> 
        <td class="varWidth">
<cfswitch expression="#request.rslist.type#">
<cfcase value="Form,Component">
<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rslist.ContentID#&type=#request.rslist.type#&parentid=#request.rslist.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#request.rslist.moduleid#">#request.rslist.menutitle#</a>
</cfcase>
<cfdefaultcase>
#application.contentRenderer.dspZoom(itemcrumbdata,request.rslist.fileExt)#</cfdefaultcase>
</cfswitch></td>
			<td>#request.rslist.module#</td> 
          <td class="administration"><ul class="drafts"><li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rslist.ContentID#&type=#request.rslist.type#&parentid=#request.rslist.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#request.rslist.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#</a></li></ul></td>
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
