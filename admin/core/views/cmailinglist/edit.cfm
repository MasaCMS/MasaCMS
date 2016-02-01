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
<cfset tabLabelList="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic')#,#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.usagereport')#">
<cfset tabList="tabBasic,tabUsagereport">
<cfoutput>

<h1>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<form <cfif rc.mlid eq ''>class="fieldset-wrap"</cfif> novalidate="novalidate" action="./?muraAction=cMailingList.update" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);">

<cfif rc.listBean.getispurge() neq 1>
	<cfif rc.mlid eq ''>
		<div class="fieldset">
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#
			</label>
			<div class="controls">
				<input type="text" name="Name" value="#esapiEncode('html_attr',rc.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="span12">
			</div>
		</div>
	<cfelse>
		<div class="tabbable tabs-left mura-ui">
		<ul class="nav nav-tabs tabs initActiveTab">
		<cfloop from="1" to="#listlen(tabList)#" index="t">
		<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
		</cfloop>
		</ul>
		
		<div class="tab-content">
		<div id="tabBasic" class="tab-pane fade">
		<div class="fieldset">
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#
			</label>
			<div class="controls">
				<input type=text name="Name" value="#esapiEncode('html_attr',rc.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="span12">
			</div>
		</div>
	</cfif>

	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.type')#
		</label>
		<div class="controls">
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
	</div>

<cfelse>
	<div class="tabbable tabs-left mura-ui">
		<ul class="nav nav-tabs tabs initActiveTab">
	<cfloop from="1" to="#listlen(tabList)#" index="t">
	<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
	</cfloop>
	</ul>
			
		<div class="tab-content">
		<div id="tabBasic" class="tab-pane fade">
			<div class="fieldset">
				<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.masterdonotemaillistname')#
		</label>
		<div class="controls">
			<input type="text" name="Name" value="#esapiEncode('html_attr',rc.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="span12">
			<input type=hidden name="ispurge" value="1"><input type=hidden name="ispublic" value="1">
		</div>
	</div>
</cfif>

	<div class="control-group">
	<label class="control-label">
		#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.description')#
	</label>
	<div class="controls">
		<textarea id="description" name="description" rows="6" class="span12">#esapiEncode('html',rc.listBean.getdescription())#</textarea>
		<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
	</div>
</div>
	
	<div class="control-group">
	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploadlistmaintenancefile')#</dt>
	<div class="controls">
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
</div>
	
	<div class="control-group">
	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#</label>
	<div class="controls">
		<input type="file" name="listfile" accept="text/plain" >
	</div>
</div>
	
	<cfif rc.mlid neq ''>
	<div class="control-group">
	<div class="controls">
		<label for="cm" class="checkbox inline">
			<input type="checkbox" id="cm" name="clearMembers" value="1" /> #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.clearoutexistingmembers')#
		</label>
	</div>
</div>
	</cfif>      
	
<cfif rc.mlid neq ''>
	</div>
	<cfinclude template="dsp_tab_usage.cfm">
</cfif>
	
	<div class="form-actions">			
		<cfif rc.mlid eq ''>
			<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.add')#" />
			<input type=hidden name="mlid" value="#createuuid()#">
		<cfelse>
			<cfif not rc.listBean.getispurge()>
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deleteconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#" />
			</cfif> 
			<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.update')#" />
			<input type=hidden name="mlid" value="#rc.listBean.getmlid()#">
		</cfif>
		<input type="hidden" name="action" value="">
	</div>
</div>

</form>

</cfoutput>
