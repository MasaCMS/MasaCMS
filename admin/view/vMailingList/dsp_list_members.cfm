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
<h2>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cMailingList.list&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.Edit&mlid=#attributes.mlid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.editmailinglist')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.download&mlid=#attributes.mlid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.downloadmembers')#</a></li>
</ul>

<form novalidate="novalidate" action="index.cfm?fuseaction=cMailingList.updatemember" name="form1" method="post" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.email')#</dt>
<dd><input type=text name="email" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.emailrequired')#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.firstname')#</dt>
<dd><input type=text name="fname" class="text" /></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.lastname')#</dt>
<dd><input type=text name="lname" class="text" /></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.company')#</dt>
<dd><input type=text name="company" class="text" /></dd>
<dt><input type="radio" name="action" id="a" value="add" checked> <label id="a">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.subscribe')#</label> <input type="radio" id="d" name="action" value="delete"> <label for="d">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.unsubscribe')#</label></dt>
</dl>
<input type="button" class="submit" onclick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.submit')#" />
<input type=hidden name="mlid" value="#attributes.mlid#">
<input type=hidden name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
<input type=hidden name="isVerified" value="1">
</form>
<h3>#request.listBean.getname()#</h3>

<table id="metadata" class="mura-table-grid stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.emails')# (#request.rslist.recordcount#)</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.company')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.verified')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.created')#</th>
	<th>&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rslist" startrow="#attributes.startrow#" maxrows="#request.nextN.RecordsPerPage#">
	<tr>
		<td class="varWidth"><a href="mailto:#HTMLEditFormat(request.rslist.email)#">#HTMLEditFormat(request.rslist.email)#</a></td>
		<td>#HTMLEditFormat(request.rslist.fname)#&nbsp;#HTMLEditFormat(request.rslist.lname)#</td>
		<td>#HTMLEditFormat(request.rslist.company)#</td>
		<td><cfif request.rslist.isVerified eq 1>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.yes')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.no')#</cfif></td>
		<td>#LSDateFormat(request.rslist.created,session.dateKeyFormat)#</td>
		<td class="administration"><ul class="mailingListMembers"><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#" href="index.cfm?fuseaction=cMailingList.updatemember&action=delete&mlid=#request.rslist.mlid#&email=#urlencodedformat(request.rslist.email)#&siteid=#URLEncodedFormat(attributes.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deletememberconfirm'))#',this.href);">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</a></li></ul></td></tr>
</cfoutput>
<cfelse>
<tr>
<td class="noResults" colspan="5"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.nomembers')#</cfoutput></td>
</tr>
</cfif>
</table>
<cfinclude template="dsp_list_members_next_n.cfm">