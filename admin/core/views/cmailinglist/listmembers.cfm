<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfoutput>
<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h1>
	<cfinclude template="dsp_secondary_menu.cfm">
</div> <!-- /.mura-header -->

<div class="block block-constrain">
	<div class="block block-bordered">
	  <div class="block-content">
					
		<form novalidate="novalidate" action="./?muraAction=cMailingList.updatemember" name="form1" method="post" onsubmit="return validate(this);">
		<div class="mura-control-group">
			<label>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.email')#
			</label>
			<input type=text name="email" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.emailrequired')#">
		</div>
		<div class="mura-control-group">
			<label>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.firstname')#
			</label>
			<input type=text name="fname" class="text" />
		</div>

		<div class="mura-control-group">
			<label>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.lastname')#
			</label>
			<input type=text name="lname" class="text" />
		</div>

		<div class="mura-control-group">
			<label>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.company')#
			</label>
			<input type=text name="company" class="text" />
		</div>

		<div class="mura-control-group">
			<label for="a" class="radio">
				<input type="radio" name="action" id="a" value="add" checked> 
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.subscribe')#
			</label> 
			<label id="d" class="radio">
				<input type="radio" id="d" name="action" value="delete"> 
				 #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.unsubscribe')#
			</label>
		</div>
		<div class="mura-actions">
			<div class="form-actions">
				<button class="btn mura-primary" onclick="submitForm(document.forms.form1);"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.submit')#</button>
			</div>
		</div>
		<input type=hidden name="mlid" value="#esapiEncode('html_attr',rc.mlid)#">
		<input type=hidden name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
		<input type=hidden name="isVerified" value="1">
		</form>

		</div> <!-- /.block-content -->

		<div class="block-content">

			<h2>#rc.listBean.getname()#</h2>

			<table id="metadata" class="mura-table-grid">
			<tr>
				<th class="actions"></th>
				<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.emails')# (#rc.rslist.recordcount#)</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.company')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.verified')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.created')#</th>
			</tr></cfoutput>
			<cfif rc.rslist.recordcount>
			<cfoutput query="rc.rslist" startrow="#rc.startrow#" maxrows="#rc.nextN.RecordsPerPage#">
				<tr>
					<td class="actions">
						<ul class="mailingListMembers actions-list">
							<li class="delete"><a href="./?muraAction=cMailingList.updatemember&action=delete&mlid=#rc.rslist.mlid#&email=#esapiEncode('url',rc.rslist.email)#&siteid=#esapiEncode('url',rc.siteid)#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deletememberconfirm'))#',this.href);"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</a></li>
						</ul>
					</td>
					<td class="var-width"><a href="mailto:#esapiEncode('html',rc.rslist.email)#">#esapiEncode('html',rc.rslist.email)#</a></td>
					<td>#esapiEncode('html',rc.rslist.fname)#&nbsp;#esapiEncode('html',rc.rslist.lname)#</td>
					<td>#esapiEncode('html',rc.rslist.company)#</td>
					<td><cfif rc.rslist.isVerified eq 1>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.yes')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.no')#</cfif></td>
					<td>#LSDateFormat(rc.rslist.created,session.dateKeyFormat)#</td>
				</tr>
			</cfoutput>
			<cfelse>
			<tr>
			<td class="noResults" colspan="6"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.nomembers')#</cfoutput></td>
			</tr>
			</cfif>
			</table>

			<cfinclude template="dsp_list_members_next_n.cfm">

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.block-constrain -->
