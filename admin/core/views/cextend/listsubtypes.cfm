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
<cfset rslist=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=false) />
<h1>Class Extension Manager</h1>

<cfoutput>


<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cExtend.editSubType&subTypeID=&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-plus-sign"></i> Add Class Extension</a>
</div>

</cfoutput>
<table class="table table-striped table-condensed table-bordered mura-table-grid">
<tr>
	<th>Class Extension</th>	
	<th class="var-width">Description</th>
	<th>Active</th>
	<th class="actions">&nbsp;</th>
</tr>
<cfif rslist.recordcount>
<cfoutput query="rslist">
	<tr>
		<td><a title="Edit" href="index.cfm?muraAction=cExtend.listSets&subTypeID=#rslist.subTypeID#&siteid=#URLEncodedFormat(rc.siteid)#">#application.classExtensionManager.getTypeAsString(rslist.type)# / #rslist.subtype#</a></td>
		<td class="var-width">#rslist.description#</td>
		<td>#yesNoFormat(rslist.isactive)#</td>
		<td class="actions">
			<ul>
				<li class="edit">
					<a title="Edit" href="index.cfm?muraAction=cExtend.editSubType&subTypeID=#rslist.subTypeID#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a>
				</li>
				<li class="add">
					<a href="index.cfm?muraAction=cExtend.listSets&subTypeID=#rslist.subTypeID#&siteid=#URLEncodedFormat(rc.siteid)#" title="View Sets"><i class="icon-list"></i></a>
				</li>
			</ul>
		</td>
	</tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="3">There are currently no available sub types.</td>
	</tr>
</cfif>
</table>
