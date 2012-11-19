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

<form class="form-inline" novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">  
	<div class="input-append">
		    <input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" />
		    <button type="button" class="btn" onclick="submitForm(document.forms.siteSearch);" /><i class="icon-search"></i></button>
	</div>
<!--- <input name="keywords" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" maxlength="50" /> --->
	<input type="hidden" name="muraAction" value="cAdvertising.listadzones">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
</form>

<h1>#application.rbFactory.getKeyValue(session.rb,'advertising.viewadzones')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<ul class="navTask nav nav-pills">
<li><a href="index.cfm?muraAction=cAdvertising.editAdZone&adzoneid=&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'advertising.addnewadzone')#</a></li>
</ul>

<table class="table table-striped table-condensed table-bordered mura-table-grid">
<tr>
	<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
	<th class="actions">&nbsp;</th>
</tr></cfoutput>
<cfif rc.rslist.recordcount>
<cfoutput query="rc.rslist">
	<tr>
		<td class="var-width"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?muraAction=cAdvertising.editAdZone&adZoneid=#rc.rslist.adzoneid#&siteid=#URLEncodedFormat(rc.siteid)#">#name#</a></td>
		<td>#creativeType#</td>
		<td>#height#</td>
		<td>#width#</td>
	<td>
		<cfif isActive>
			<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(isActive)#')#"></i>
		<cfelse>
			<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(isActive)#')#"></i>
		</cfif>
		<span>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoformat(isActive)#')#</span>
		</td>
		<td class="actions"><ul>
		<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?muraAction=cAdvertising.editAdZone&adZoneid=#rc.rslist.adzoneid#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a></li>
		<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.delte')#" href="index.cfm?muraAction=cAdvertising.updateAdZone&action=delete&adzoneid=#rc.rslist.adZoneid#&siteid=#URLEncodedFormat(rc.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteadzoneconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul>
		</td></tr>
</cfoutput>
<cfelse>
<tr>
		<td class="noResults" colspan="6"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.noadzones')#</cfoutput></td>
	</tr>
</cfif>
</table>