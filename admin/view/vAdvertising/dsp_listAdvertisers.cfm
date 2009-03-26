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
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.viewadvertisers')#</h2>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'advertising.advertisersearch')#</h3><form id="siteSearch" name="siteSearch" method="get"><input name="keywords" value="#attributes.keywords#" type="text" class="text" maxlength="50" />  
	
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.search')#</span></a>
	<input type="hidden" name="fuseaction" value="cAdvertising.listAdvertisers">
	<input type="hidden" name="siteid" value="#attributes.siteid#">
</form>
<!--- 
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cPublicUsers.editUser&userid=&siteid=#attributes.siteid#&groupid=#application.advertiserManager.getGroupID(attributes.siteid)#&routeid=adManager">Add Advertiser</li>
</ul> --->

<table class="stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.advertiser')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.contact')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.email')#</th>
	<th class="administration">&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rslist">
	<tr>
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&userid=#request.rslist.userid#&siteid=#attributes.siteid#">#company#</a></td>
		<td>#fname# #lname#</td>
		<td><cfif email neq ''><a href="mailto:#email#">#email#</a><cfelse>&nbsp;</cfif></td>
		<td class="administration"><ul class="advertisers"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&userid=#request.rslist.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul></td></tr>
</cfoutput>
<cfelse>
<tr>
		<td nowrap class="noResults" colspan="5"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.noadvertisers')#</cfoutput></td>
	</tr>
</cfif>
</table>