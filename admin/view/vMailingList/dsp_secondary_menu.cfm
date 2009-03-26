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
<!---<li<cfif myfusebox.originalfuseaction eq "edit"> class="current"</cfif>><a href="index.cfm?fuseaction=cMailingList.edit&siteid=#attributes.siteid#&mlid=">Add Mailing List</a></li>--->
<cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')><ul><li<cfif myfusebox.originalfuseaction eq "module"> class="current"</cfif>><a href="index.cfm?fuseaction=cPerm.module&contentid=00000000000000000000000000000000009&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000009">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.permissions')#</a></li></ul></cfif>
</cfoutput>