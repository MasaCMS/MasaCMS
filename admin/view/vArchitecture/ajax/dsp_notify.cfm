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

<cfset request.perm=application.permUtility.getnodePerm(request.crumbdata)/>
<cfset request.rsNotify=application.contentUtility.getNotify(request.crumbdata) />
<cfoutput><table class="displayObjects" ><tr><td class="nested" width="300">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sendto')#<br />
	<select id="notifyEditor" name="notify" size="6" multiple class="multiSelect" <cfif request.perm eq 'editor'> onChange="javascript: this.selectedIndex==0?document.form1.approved.checked=true:document.form1.approved.checked=false;"</cfif>>
	<option value="" selected>None</option>
	<cfloop query="request.rsnotify">
	<option value="#request.rsnotify.userID#">#request.rsnotify.lname#, #request.rsnotify.fname# (#application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions.#request.rsnotify.type#')#)</option>
	</cfloop>
	</select></td>
	<td class="nested" width="400">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.message')#<br />
	<textarea name="message" rows="6" id="messageEditor">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.messagetext')#</textarea></td></tr></table>
</cfoutput>