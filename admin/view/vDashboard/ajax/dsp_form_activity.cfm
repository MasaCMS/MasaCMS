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

<cfinclude template="../act_defaults.cfm">
<cfset rsList=application.dashboardManager.getRecentFormActivity(attributes.siteID,5) />
<cfoutput><table>
<tr><th class="title">#application.rbFactory.getKeyValue(session.rb,"dashboard.title")#</th><th class="dateTime">#application.rbFactory.getKeyValue(session.rb,"dashboard.lastresponse")#</th><th class="total">#application.rbFactory.getKeyValue(session.rb,"dashboard.totalresponses")#</th></tr>
	<cfif rslist.recordcount>
	<cfloop query="rslist">
	<cfset crumbdata=application.contentManager.getCrumbList(rslist.contentid, attributes.siteid)/>
	<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
	<tr<cfif rslist.currentrow mod 2> class="alt"</cfif>>
	<td><cfif verdict neq 'none'><a title="Version History" href="index.cfm?fuseaction=cArch.datamanager&contentid=#rslist.ContentID#&type=Form&parentid=00000000000000000000000000000000004&topid=00000000000000000000000000000000004&siteid=#rsList.siteid#&moduleid=00000000000000000000000000000000004">#rsList.menuTitle#</a><cfelse>#rsList.menuTitle#</cfif> </td>
	<td class="dateTime">#LSDateFormat(rsList.lastEntered,session.dateKeyFormat)# #LSTimeFormat(rsList.lastEntered,"short")#</td>
	<td class="total">#rsList.submissions#</td>
	</tr>
	</cfloop>
	<cfelse>
	<tr class="alt"><td class="noResults" colspan="3">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.noformsubmissions"),attributes.span)#</td></tr>
	</cfif>
	</table>
</cfoutput>