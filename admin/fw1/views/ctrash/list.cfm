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
<cfsavecontent variable="rc.layout">
<cfparam name="rc.keywords" default="">
<cfoutput>
<h2>Trash Bin</h2>

<ul id="navTask"
<li><a href="index.cfm?fuseaction=cSettings.editSite&siteID=#URLEncodedFormat(rc.siteID)#">Back to Site Settings</a></li>
<li><a href="index.cfm?fuseaction=cTrash.empty&siteID=#URLEncodedFormat(rc.siteID)#" onclick="return confirmDialog('Empty Site Trash?', this.href);">Empty Trash</a></li>
</ul>

<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
   <h3>Keyword Search</h3>
    <input name="keywords" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" align="absmiddle" />
    <input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="Search" />
    <input type="hidden" name="fuseaction" value="cTrash.list">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
 </form>

<table class="mura-table-grid stripe"> 
<tr>
<th class="varWidth">Label</th>
<th>Type</th>
<th>SubType</th>
<th>SiteID</th>
<th>Date Deleted</th>
<th>Date By</th>
<th class="administration">&nbsp;</th>
</tr>
<cfset rc.trashIterator.setPage(rc.pageNum)>
<cfif rc.trashIterator.hasNext()>
<cfloop condition="rc.trashIterator.hasNext()">
<cfset trashItem=rc.trashIterator.next()>
<tr>
<td class="varWidth"><a href="?fuseaction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#">#htmlEditFormat(left(trashItem.getObjectLabel(),80))#</a></td>
<td>#htmlEditFormat(trashItem.getObjectType())#</td>
<td>#htmlEditFormat(trashItem.getObjectSubType())#</td>
<td>#htmlEditFormat(trashItem.getSiteID())#</td>
<td>#LSDateFormat(trashItem.getDeletedDate(),session.dateKeyFormat)# #LSTimeFormat(trashItem.getDeletedDate(),"short")#</td>
<td>#htmlEditFormat(trashItem.getDeletedBy())#</td>
<td class="administration"><ul><li class="edit"><a href="?fuseaction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#">View Detail</a></li></ul></td>
</tr>
</cfloop>
<cfelse>
<tr><td colspan="7">The trash is currently empty.</tr>
</cfif>
</table>

<cfif rc.trashIterator.pageCount() gt 1>
<p class="moreResults">More Results: 
<cfif rc.pageNum gt 1>
	<a href="?fuseaction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#evaluate('rc.pageNum-1')#">&laquo;&nbsp;Previous</a> 
</cfif>
<cfloop from="1"  to="#rc.trashIterator.pageCount()#" index="i">
	<cfif rc.pageNum eq i>
		<strong>#i#</strong>
	<cfelse>
		<a href="?fuseaction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#i#">#i#</a> 
	</cfif>
</cfloop>
<cfif rc.pageNum lt rc.trashIterator.pageCount()>
	<a href="?fuseaction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#evaluate('rc.pageNum+1')#">Next&nbsp;&raquo;</a> 
</cfif> 
</p>
</cfif>

</cfoutput>
</cfsavecontent>
