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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset request.layout="false">
<cfinclude template="act_defaults.cfm">
<cfset rsList=application.dashboardManager.getRecentFormActivity(rc.siteID,5) />
<cfoutput><table class="table table-striped table-condensed table-bordered mura-table-grid">
<thead>
<tr><th class="title">#application.rbFactory.getKeyValue(session.rb,"dashboard.title")#</th><th class="dateTime">#application.rbFactory.getKeyValue(session.rb,"dashboard.lastresponse")#</th><th class="total">#application.rbFactory.getKeyValue(session.rb,"dashboard.totalresponses")#</th></tr>
</thead>
<tbody>
	<cfif rslist.recordcount>
	<cfloop query="rslist">
	<cfset crumbdata=application.contentManager.getCrumbList(rslist.contentid, rc.siteid)/>
	<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
	<tr>
	<td><cfif verdict neq 'none'><a title="Version History" href="index.cfm?muraAction=cArch.datamanager&contentid=#rslist.ContentID#&type=Form&parentid=00000000000000000000000000000000004&topid=00000000000000000000000000000000004&siteid=#rsList.siteid#&moduleid=00000000000000000000000000000000004">#rsList.menuTitle#</a><cfelse>#rsList.menuTitle#</cfif> </td>
	<td class="dateTime">#LSDateFormat(rsList.lastEntered,session.dateKeyFormat)# #LSTimeFormat(rsList.lastEntered,"short")#</td>
	<td class="total">#rsList.submissions#</td>
	</tr>
	</cfloop>
	<cfelse>
	<tr><td class="noResults" colspan="3">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.noformsubmissions"),rc.span)#</td></tr>
	</cfif>
	</tbody>
	</table>
</cfoutput>