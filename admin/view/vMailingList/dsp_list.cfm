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
<h2>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h2>
<cfoutput><ul id="navTask"><li><a title="Add Mailing List" href="index.cfm?fuseaction=cMailingList.edit&siteid=#attributes.siteID#&mlid=">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.addmailinglist')#</a></li></ul></cfoutput>
<table class="stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.currentmailinglists')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.type')#</th>
	<th>&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rslist">
	<tr>
		<td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cMailingList.edit&mlid=#request.rslist.mlid#&siteid=#attributes.siteid#">#HTMLEditFormat(name)# (#members#)</a></td>
		<td><cfif request.rslist.ispublic>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.public')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.private')#</cfif></td>
		<td class="administration"><ul class="mailingLists"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.edit')#" href="index.cfm?fuseaction=cMailingList.edit&mlid=#request.rslist.mlid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.edit')#</a></li><li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.viewmembership')#" href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#request.rslist.mlid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.viewmembership')#</a></li><cfif not request.rslist.ispurge><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#" href="index.cfm?fuseaction=cMailingList.update&action=delete&mlid=#request.rslist.mlid#&siteid=#attributes.siteid#" onClick="return confirm('#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deleteconfirm')#');">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</li></cfif></ul></td></tr>
</cfoutput>
<cfelse>
<tr>
		<td nowrap class="noResults" colspan="3"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.nolists')#</cfoutput></td>
	</tr>
</cfif>
</table>