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
<cfset rsUsage=application.contentGateway.getUsage(attributes.feedID) />
</cfsilent><cfoutput>
<div class="page_aTab">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.usagetext')#:</dt>
 <table id="metadata" class="stripe">
    <tr> 
      <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'collections.title')#</th>
      <th>#application.rbFactory.getKeyValue(session.rb,'collections.display')#</th>
      <th>#application.rbFactory.getKeyValue(session.rb,'collections.update')#</th>
      <th>&nbsp;</th>
    </tr></cfoutput>
    <cfif rsUsage.recordcount>
     <cfoutput query="rsUsage">
		<cfset crumbdata=application.contentManager.getCrumbList(rsUsage.contentid, attributes.siteid)/>
		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
        <tr>  
          <td class="varWidth">#application.contentRenderer.dspZoom(crumbdata)#</td>
			   <td> 
	    <cfif rsUsage.Display and (rsUsage.Display eq 1 and rsUsage.approved)>Yes<cfelseif(rsUsage.Display eq 2 and rsUsage.approved)>#LSDateFormat(rsUsage.displaystart,session.dateKeyFormat)# - #LSDateFormat(rsUsage.displaystop,session.dateKeyFormat)#<cfelse>No</cfif></td>
		<td>#LSDateFormat(rsUsage.lastupdate,session.dateKeyFormat)#</td>
          <td class="administration"><ul class="two"><cfif verdict neq 'none'><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#rsUsage.ContentHistID#&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#">#application.rbFactory.getKeyValue(session.rb,'collections.edit')#</a></li><li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#">#application.rbFactory.getKeyValue(session.rb,'collections.versionhistory')#</a></li><cfelse><li class="editOff">#application.rbFactory.getKeyValue(session.rb,'collections.edit')#</li><li class="versionHistoryOff">#application.rbFactory.getKeyValue(session.rb,'collections.versionhistory')#</li></cfif></ul></td></tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="7" class="noResults"><cfoutput><cfif request.feedBean.getType() eq 'Local'>#application.rbFactory.getKeyValue(session.rb,'collections.noindexusage')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'collections.nofeedusage')#</cfif></cfoutput></td>
      </tr>
    </cfif>
	  </table>
</td></tr></table>
</dl>
</div>
