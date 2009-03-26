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
<ul>
	<li<cfif myfusebox.originalfuseaction eq "listadzones"> class="current"</cfif>><a href="index.cfm?fuseaction=cAdvertising.listadzones&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.adzones')#</a></li>
	<li<cfif myfusebox.originalfuseaction eq "listAdvertisers"> class="current"</cfif>><a href="index.cfm?fuseaction=cAdvertising.listAdvertisers&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.advertisers')#</a></li>
	<li<cfif myfusebox.originalfuseaction eq "listCampaigns"> class="current"</cfif>><a href="index.cfm?fuseaction=cAdvertising.listCampaigns&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.campaigns')#</a></li>
	<li<cfif myfusebox.originalfuseaction eq "listCreatives"> class="current"</cfif>><a href="index.cfm?fuseaction=cAdvertising.listCreatives&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.creatives')#</a></li>
	<li<cfif myfusebox.originalfuseaction eq "editIPWhitelist"> class="current"</cfif>><a href="index.cfm?fuseaction=cAdvertising.editIPWhitelist&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.ipwhitelist')#</a></li>
	<cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')>
	<li<cfif myfusebox.originalfuseaction eq "module"> class="current"</cfif>><a href="index.cfm?fuseaction=cPerm.module&contentid=00000000000000000000000000000000006&moduleid=00000000000000000000000000000000006&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.permissions')#</a></li>
	</cfif>
</ul></cfoutput>