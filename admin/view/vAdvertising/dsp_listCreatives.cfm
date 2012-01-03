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
<cfoutput>
<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get"><input name="keywords" value="#HTMLEditFormat(attributes.keywords)#" type="text" class="text" />  
	<input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="#application.rbFactory.getKeyValue(session.rb,'advertising.search')#" />
	<input type="hidden" name="fuseaction" value="cAdvertising.listCreatives">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
</form>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.viewcreativeassets')#</h2>

<table class="mura-table-grid stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.advertiser')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.datecreated')#</th> 
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.dateupdated')#</th> 
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="administration">&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rsList">
	<tr>
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#request.rslist.userid#&siteid=#URLEncodedFormat(attributes.siteid)#&creativeid=#request.rslist.creativeID#">#request.rslist.name#</a></td>
		<td class="varWidth">#request.rslist.company#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#request.rslist.creativeType#')#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#request.rslist.mediatype#')#</td>
		<td>#request.rslist.height#</td>
		<td>#request.rslist.width#</td>
		<td>#LSDateFormat(request.rslist.dateCreated,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(request.rslist.lastUpdate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</td>
		<td class="administration"><ul class="creatives">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#request.rslist.userid#&siteid=#URLEncodedFormat(attributes.siteid)#&creativeid=#request.rslist.creativeID#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="10"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocreatives')#</cfoutput></td>
	</tr>
</cfif>
</table>
