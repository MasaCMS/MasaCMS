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
<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true)>
	<cfset tabList="tabBasic,tabUsagereport">
	<cfset tabLabelList="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic')#,#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.usagereport')#">
<cfelse>
	<cfset tabList="tabBasic">
</cfif>
<cfoutput>
<div class="mura-header">
	<h1>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h1>
	<cfinclude template="dsp_secondary_menu.cfm">
</div> <!-- /.mura-header -->

<form novalidate="novalidate" action="./?muraAction=cMailingList.update" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);">

<div class="block block-constrain">

<cfif rc.listBean.getispurge() neq 1>
	<cfif rc.mlid eq ''>
	<div class="block block-bordered">
		<div class="block-content">
		<div class="mura-control-group">
			<label>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#
			</label>
			<input type="text" name="Name" value="#esapiEncode('html_attr',rc.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#">
		</div>
	<cfelse>
		<ul class="mura-tabs nav-tabs" data-toggle="tabs">
		<cfloop from="1" to="#listlen(tabList)#" index="t">
		<li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
		</cfloop>
		</ul>

		<div class="tab-content">
		<div id="tabBasic" class="tab-pane active">
			<div class="block block-bordered">
                <div class="block-content">

			<div class="mura-control-group">
				<label>
					#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#
				</label>
					<input type=text name="Name" value="#esapiEncode('html_attr',rc.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#">
			</div>
	</cfif>

	<div class="mura-control-group">
		<label>
			#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.type')#
		</label>
			<label for="isPublicYes" class="radio inline">
				<input type="radio" value="1" id="isPublicYes" name="isPublic" <cfif rc.listBean.getisPublic() eq 1>checked</cfif>>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.public')#
			</label>
			<label for="isPublicNo" class="radio inline">
				<input type="radio" value="0" id="isPublicNo" name="isPublic" <cfif rc.listBean.getisPublic() neq 1>checked</cfif>>
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.private')#
			</label>
				<input type=hidden name="ispurge" value="0">
	</div>

<cfelse>
	<ul class="mura-tabs nav-tabs" data-toggle="tabs">
	<cfloop from="1" to="#listlen(tabList)#" index="t">
	<li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
	</ul>

		<div class="tab-content">

		<div id="tabBasic" class="tab-pane active">
			<div class="block block-bordered">
				<!-- block header -->
				<div class="block-header">
					<h3 class="block-title">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic')#</h3>
				</div> <!-- /.block header -->
				<div class="block-content">
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.masterdonotemaillistname')#</label>
				<input type="text" name="Name" value="#esapiEncode('html_attr',rc.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#">
				<input type=hidden name="ispurge" value="1"><input type=hidden name="ispublic" value="1">
			</div>
</cfif>

	<div class="mura-control-group">
		<label>
			#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.description')#
		</label>
		<textarea id="description" name="description" rows="6">#esapiEncode('html',rc.listBean.getdescription())#</textarea>
		<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
	</div>

	<div class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploadlistmaintenancefile')#</label>
		<label for="da" class="radio inline">
			<input type="radio" name="direction" id="da" value="add" checked>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.addaddressestolist')#
		</label>
		<label for="dm" class="radio inline">
			<input type="radio" name="direction" id="dm" value="remove"> #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.removeaddressesfromlist')#
		</label>
		<label for="dp" class="radio inline">
			<input type="radio" name="direction" id="dp" value="replace"> #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.replaceemaillistwithnewfile')#
		</label>
	</div>

	<div class="mura-control-group">
	<label>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#</label>
	<input type="file" name="listfile" accept="text/plain" >
	</div>

	<cfif rc.mlid neq ''>
		<div class="mura-control-group">
			<label for="cm" class="checkbox inline">
			<input type="checkbox" id="cm" name="clearMembers" value="1" /> #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.clearoutexistingmembers')#
			</label>
		</div>


			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->

		</div> <!-- /.tab-pane -->
	<cfelse>
		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
	</cfif>


<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and rc.mlid neq ''>
	<cfinclude template="dsp_tab_usage.cfm">
</cfif>



	<div class="mura-actions">
		<div class="form-actions">
			<cfif rc.mlid eq ''>
				<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1,'add');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.add')#</button>
				<input type=hidden name="mlid" value="#createuuid()#">
			<cfelse>
				<cfif not rc.listBean.getispurge()>
					<button type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deleteconfirm'))#');"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</button>
				</cfif>
				<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.update')#</button>
				<input type=hidden name="mlid" value="#rc.listBean.getmlid()#">
			</cfif>
			<input type="hidden" name="action" value="">
		</div>
	</div>


	</div> <!-- /.block-constrain -->
</form>

</cfoutput>
