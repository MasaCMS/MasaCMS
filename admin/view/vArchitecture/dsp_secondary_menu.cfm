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
<cfswitch expression="#attributes.moduleid#">
		<cfcase value="00000000000000000000000000000000003">
			<cfif myfusebox.originalcircuit eq 'cPerm' or request.perm neq 'none'><!---<li<cfif myfusebox.originalfuseaction eq "edit"> class="current"</cfif>><a href="index.cfm?fuseaction=cArch.edit&type=Component&contentid=&topid=#attributes.topid#&parentid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#">Add Component</a></li>---><cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')><ul><li<cfif myfusebox.originalfuseaction eq "main"> class="current"</cfif>><a href="index.cfm?fuseaction=cPerm.main&contentid=00000000000000000000000000000000003&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">Permissions</a></li></ul></cfif></cfif>
		</cfcase>
		<cfcase value="00000000000000000000000000000000004">
			<cfif myfusebox.originalcircuit eq 'cPerm' or request.perm neq 'none'><!---<li<cfif myfusebox.originalfuseaction eq "edit"> class="current"</cfif>><a href="index.cfm?fuseaction=cArch.edit&type=Form&contentid=&topid=#attributes.topid#&parentid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#">Add Form</a></li>---><cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')><ul><li<cfif myfusebox.originalfuseaction eq "main"> class="current"</cfif>><a href="index.cfm?fuseaction=cPerm.main&contentid=00000000000000000000000000000000004&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">Permissions</a></li></ul></cfif></cfif>
		</cfcase>
		</cfswitch>
</cfoutput>