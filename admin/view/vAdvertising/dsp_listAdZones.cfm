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
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.viewadzones')#</h2>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'advertising.adzonesearch')#</h3><form id="siteSearch" name="siteSearch" method="get"><input name="keywords" value="#attributes.keywords#" type="text" class="text" maxlength="50" />  
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.search')#</span></a>
	<input type="hidden" name="fuseaction" value="cAdvertising.listadzones">
	<input type="hidden" name="siteid" value="#attributes.siteid#">
</form>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cAdvertising.editAdZone&adzoneid=&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.addnewadzone')#</a></li>
</ul>


<table class="stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="administration">&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rslist">
	<tr>
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editAdZone&adZoneid=#request.rslist.adzoneid#&siteid=#attributes.siteid#">#name#</a></td>
		<td>#creativeType#</td>
		<td>#height#</td>
		<td>#width#</td>
	<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(isActive)#')#</td>
		<td class="administration"><ul class="two">
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.editAdZone&adZoneid=#request.rslist.adzoneid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delte')#" href="index.cfm?fuseaction=cAdvertising.updateAdZone&action=delete&adzoneid=#request.rslist.adZoneid#&siteid=#attributes.siteid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteadzoneconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="6"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.noadzones')#</cfoutput></td>
	</tr>
</cfif>
</table>