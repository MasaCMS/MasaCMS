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
<cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2') or itemperm eq 'editor' or itemperm eq 'author'>
      
		<tr> 
        <td class="varWidth">
<cfswitch expression="#request.rslist.type#">
<cfcase value="Form,Component">
<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rslist.ContentID#&type=#request.rslist.type#&parentid=#request.rslist.parentID#&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#request.rslist.moduleid#">#request.rslist.menutitle#</a>
</cfcase>
<cfdefaultcase>
#application.contentRenderer.dspZoom(itemcrumbdata,request.rslist.fileExt)#</cfdefaultcase>
</cfswitch></td>
			<td>#request.rslist.module#</td> 
          <td class="administration"><ul class="drafts"><li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rslist.ContentID#&type=#request.rslist.type#&parentid=#request.rslist.parentID#&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#request.rslist.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#</a></li></ul></td>
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
