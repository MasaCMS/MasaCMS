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
<li<cfif myfusebox.originalfuseaction eq "sessionSearch"> class="current"</cfif>><a href="index.cfm?fuseaction=cDashboard.sessionSearch&siteID=#session.siteid#&newSearch=true">#application.rbFactory.getKeyValue(session.rb,"dashboard.sessionsearch")#</a></li>
<li<cfif myfusebox.originalfuseaction eq "topContent"> class="current"</cfif>><a href="index.cfm?fuseaction=cDashboard.topContent&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.topcontent")#</a></li>
<li<cfif myfusebox.originalfuseaction eq "topReferers"> class="current"</cfif>><a href="index.cfm?fuseaction=cDashboard.topReferers&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.topreferrers")#</a></li>
<li<cfif myfusebox.originalfuseaction eq "topSearches"> class="current"</cfif>><a href="index.cfm?fuseaction=cDashboard.topSearches&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.topsearches")#</a></li>
<li<cfif myfusebox.originalfuseaction eq "topRated"> class="current"</cfif>><a href="index.cfm?fuseaction=cDashboard.topRated&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.toprated")#</a></li>
</ul></cfoutput>