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
<cfparam name="rc.keywords" default="">
<cfoutput>
<form class="form-inline" novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
   <div class="input-append">
	   <input id="search" name="search" type="text" class="text" value="#HTMLEditFormat(rc.keywords)#">
	    <button type="button" class="btn" onclick="submitForm(document.forms.siteSearch);" /><i class="icon-search"></i></button>
	</div>
    
    <!---
<input name="keywords" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" align="absmiddle" />
    <input type="button" class="btn" onclick="submitForm(document.forms.siteSearch);" value="Search" />
--->
    <input type="hidden" name="muraAction" value="cTrash.list">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
 </form>

<h1>Trash Bin</h1>

<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cSettings.editSite&siteID=#URLEncodedFormat(rc.siteID)#"><i class="icon-circle-arrow-left"></i> Back to Site Settings</a>
<a class="btn" href="index.cfm?muraAction=cTrash.empty&siteID=#URLEncodedFormat(rc.siteID)#" onclick="return confirmDialog('Empty Site Trash?', this.href);">Empty Trash</a>
</div>

<table class="table table-striped table-condensed table-bordered mura-table-grid"> 
<tr>
<th class="var-width">Label</th>
<th>Type</th>
<th>SubType</th>
<th>SiteID</th>
<th>Date Deleted</th>
<th>Date By</th>
<th class="actions">&nbsp;</th>
</tr>
<cfset rc.trashIterator.setPage(rc.pageNum)>
<cfif rc.trashIterator.hasNext()>
<cfloop condition="rc.trashIterator.hasNext()">
<cfset trashItem=rc.trashIterator.next()>
<tr>
<td class="var-width"><a href="?muraAction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#">#htmlEditFormat(left(trashItem.getObjectLabel(),80))#</a></td>
<td>#htmlEditFormat(trashItem.getObjectType())#</td>
<td>#htmlEditFormat(trashItem.getObjectSubType())#</td>
<td>#htmlEditFormat(trashItem.getSiteID())#</td>
<td>#LSDateFormat(trashItem.getDeletedDate(),session.dateKeyFormat)# #LSTimeFormat(trashItem.getDeletedDate(),"short")#</td>
<td>#htmlEditFormat(trashItem.getDeletedBy())#</td>
<td class="actions"><ul><li class="edit"><a href="?muraAction=cTrash.detail&objectID=#trashItem.getObjectID()#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#URLEncodedFormat(rc.pageNum)#"><i class="icon-pencil"></i></a></li></ul></td>
</tr>
</cfloop>
<cfelse>
<tr><td colspan="7">The trash is currently empty.</tr>
</cfif>
</table>

<cfif rc.trashIterator.pageCount() gt 1>
<div class="pagination">
	<ul>
		<cfif rc.pageNum gt 1>
			<li><a href="?muraAction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#evaluate('rc.pageNum-1')#"><i class="icon-caret-left"></i>Previous</a></li>
		</cfif>
		<cfloop from="1"  to="#rc.trashIterator.pageCount()#" index="i">
		
			<cfif rc.pageNum eq i>
				<li class="active"><a href="##">#i#</a></li>
			<cfelse>
				<li><a href="?muraAction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#i#">#i#</a></li>
			</cfif>
		
		</cfloop>
		<cfif rc.pageNum lt rc.trashIterator.pageCount()>
			<li><a href="?muraAction=cTrash.list&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#URLEncodedFormat(rc.keywords)#&pageNum=#evaluate('rc.pageNum+1')#">Next<i class="icon-caret-right"></i></a></li>
		</cfif>
	</ul>
</div>
</cfif>
</cfoutput>

