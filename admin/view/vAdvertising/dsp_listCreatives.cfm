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
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.viewcreativeassets')#</h2>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'advertising.assetsearch')#</h3><form id="siteSearch" name="siteSearch" method="get"><input name="keywords" value="#attributes.keywords#" type="text" class="text" />  
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.search')#</span></a>
	<input type="hidden" name="fuseaction" value="cAdvertising.listCreatives">
	<input type="hidden" name="siteid" value="#attributes.siteid#">
</form>

<table class="stripe">
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
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#request.rslist.userid#&siteid=#attributes.siteid#&creativeid=#request.rslist.creativeID#">#request.rslist.name#</a></td>
		<td class="varWidth">#request.rslist.company#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#request.rslist.creativeType#')#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.mediatype.#request.rslist.mediatype#')#</td>
		<td>#request.rslist.height#</td>
		<td>#request.rslist.width#</td>
		<td>#LSDateFormat(request.rslist.dateCreated,session.dateKeyFormat)#</td>
		<td>#LSDateFormat(request.rslist.lastUpdate,session.dateKeyFormat)#</td>
		<td>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</td>
		<td class="administration"><ul class="creatives">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editCreative&userid=#request.rslist.userid#&siteid=#attributes.siteid#&creativeid=#request.rslist.creativeID#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="10"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocreatives')#</cfoutput></td>
	</tr>
</cfif>
</table>
