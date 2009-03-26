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
<h2>#application.rbFactory.getKeyValue(session.rb,'user.adminusersgroups')#</h2>
<form action="index.cfm?fuseaction=cPrivateUsers.advancedSearch&siteid=#attributes.siteid#" method="post" name="form2" id="advancedSiteSearch"><h3>Advanced Search for Adminstrative User</h3>
<dl class="oneColumn">
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.fname')#</dt>
	<dd><input name="fname" type="text" class="text"></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.lname')#e</dt>
	<dd><input name="lname" type="text" class="text"></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
	<dd><input name="email" type="text" class="text"></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.username')#</dt>
	<dd><input name="username" type="text" class="text"></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.company')#</dt>
	<dd><input name="company" type="text" class="text"></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.lasupdatedy')#</dt>
	<dd><input name="lastUpdateBy" type="text" class="text"></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'user.inactive')#</dt>
	<dd>
		<select name="inactive">
			<option value=""></option>
			<option value="1">#application.rbFactory.getKeyValue(session.rb,'user.yes')#</option>
			<option value="0">#application.rbFactory.getKeyValue(session.rb,'user.no')#</option>
		</select>
	</dd>
</dl>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form2);"><span>#application.rbFactory.getKeyValue(session.rb,'user.search')#</span></a></form>
</cfoutput>