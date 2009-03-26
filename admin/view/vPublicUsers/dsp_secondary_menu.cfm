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

<cfoutput><ul>
<!---<li<cfif myfusebox.originalfuseaction eq "edituser"> class="current"</cfif>><a href="index.cfm?fuseaction=cPublicUsers.edituser&siteid=#attributes.siteid#&userid=">Add Member</a></li>
<li<cfif myfusebox.originalfuseaction eq "editgroup"> class="current"</cfif>><a href="index.cfm?fuseaction=cPublicUsers.editgroup&siteid=#attributes.siteid#&userid=">Add Group</a></li>
<li<cfif myfusebox.originalfuseaction eq "advancedSearchForm" or  myfusebox.originalfuseaction eq "advancedSearch"> class="current"</cfif>><a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&siteid=#attributes.siteid#&newSearch=true">Advanced Search</a></li>--->
<cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')><li<cfif myfusebox.originalfuseaction eq "module"> class="current"</cfif>><a href="index.cfm?fuseaction=cPerm.module&contentid=00000000000000000000000000000000008&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000008">#application.rbFactory.getKeyValue(session.rb,'user.permissions')#</a></li></cfif>
</ul></cfoutput>