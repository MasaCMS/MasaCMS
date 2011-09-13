<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

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