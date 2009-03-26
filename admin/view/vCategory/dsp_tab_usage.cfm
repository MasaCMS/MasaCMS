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

<cfsilent>
<cfset rsUsage=application.contentGateway.getUsage(attributes.categoryID) />
</cfsilent><cfoutput>
<div class="page_aTab">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'categorymanager.usagetext')#:</dt>
 <table class="stripe">
    <tr> 
      <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'categorymanager.title')#</th>
      <th>#application.rbFactory.getKeyValue(session.rb,'categorymanager.display')#</th>
      <th>#application.rbFactory.getKeyValue(session.rb,'categorymanager.update')#</th>
      <th class="administration">&nbsp;</th>
    </tr></cfoutput>
    <cfif rsUsage.recordcount>
     <cfoutput query="rsUsage">
		<cfset crumbdata=application.contentManager.getCrumbList(rsUsage.contentid, attributes.siteid)/>
		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
        <tr>  
          <td class="varWidth">#application.contentRenderer.dspZoom(crumbdata)#</td>
			   <td> 
	    <cfif rsUsage.Display and (rsUsage.Display eq 1 and rsUsage.approved)>#application.rbFactory.getKeyValue(session.rb,'categorymanager.yes')#<cfelseif(rsUsage.Display eq 2 and rsUsage.approved)>#LSDateFormat(rsUsage.displaystart,session.dateKeyFormat)# - #LSDateFormat(rsUsage.displaystop,session.dateKeyFormat)#<cfelse>#application.rbFactory.getKeyValue(session.rb,'categorymanager.no')#</cfif></td>
		<td>#LSDateFormat(rsUsage.lastupdate,session.dateKeyFormat)#</td>
          <td class="administration"><ul class="two"><cfif verdict neq 'none'><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#rsUsage.ContentHistID#&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#">#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#</a></li><li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#">#application.rbFactory.getKeyValue(session.rb,'categorymanager.versionhistory')#</a></li><cfelse><li class="editOff">#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#</li><li class="versionHistoryOff">#application.rbFactory.getKeyValue(session.rb,'categorymanager.versionhistory')#</li></cfif></ul></td></tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="7" cl<ass="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'categorymanager.nousage')#</cfoutput></td>
      </tr>
    </cfif>
	  </table>
</td></tr></table>
</dl>
</div>
