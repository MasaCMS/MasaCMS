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

<cfset rslist=application.classExtensionManager.getSubTypes(attributes.siteID) />
<h2>Class Extensions</h2>

<cfoutput>


<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.editSubType&subTypeID=&siteid=#attributes.siteid#">Add Class Extension</a></li>
</ul>

</cfoutput>
<table class="stripe">
<tr>
	<th class="varWidth">Class Extension</th>
	<th class="administration">&nbsp;</th>
</tr>
<cfif rslist.recordcount>
<cfoutput query="rslist">
	<tr>
		<td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cExtend.listSets&subTypeID=#rslist.subTypeID#&siteid=#attributes.siteid#">#application.classExtensionManager.getTypeAsString(rslist.type)# / #rslist.subtype#</a></td>
		<td class="administration"><ul class="two">
		<li class="edit"><a title="Edit" href="index.cfm?fuseaction=cExtend.listSets&subTypeID=#rslist.subTypeID#&siteid=#attributes.siteid#">View Sets</a></li>
		</ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="2">There are currently no available sub types.</td>
	</tr>
</cfif>
</table>