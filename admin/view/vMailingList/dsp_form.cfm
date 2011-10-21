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
<cfoutput><form novalidate="novalidate" action="index.cfm?fuseaction=cMailingList.update" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);">
<h2>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h2>
<cfif attributes.mlid neq ''><ul id="navTask">
<li><a href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#attributes.mlid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.vieweditmembers')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.download&mlid=#attributes.mlid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.downloadmembers')#</a></li>
</ul></cfif>
<dl class="oneColumn separate"><cfif request.listBean.getispurge() neq 1>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#</dt>
<dd><input type=text name="Name" value="#HTMLEditFormat(request.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="text"></dd>
<cfif attributes.mlid neq ''>
</dl>
<div class="tabs initActiveTab">
<ul>
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
<div id="tabBasic">
<dl class="oneColumn">
<dt class="first">
<cfelse>
<dt>
</cfif>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.type')#</dt>
<dd>
<input type="radio" value="1" id="isPublicYes" name="isPublic" <cfif request.listBean.getisPublic() eq 1>checked</cfif>> <label for="isPublicYes">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.public')#</label> <input type="radio" value="0" id="isPublicNo" name="isPublic" <cfif request.listBean.getisPublic() neq 1>checked</cfif>> <label for="isPublicNo">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.private')#</label>
<input type=hidden name="ispurge" value="0">
</dd>
<dt>
<cfelse>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.masterdonotemaillistname')#</dt>
<dd><input type=text name="Name" value="#HTMLEditFormat(request.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="text"> <input type=hidden name="ispurge" value="1"><input type=hidden name="ispublic" value="1"></dd>
</dl>
<div class="tabs">
<ul>
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
<div id="tabBasic">
<dl class="oneColumn">
<dt class="first">
</cfif>
#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.description')#</dt>
<dd><textarea id="description" name="description" cols="17" rows="7" class="alt">#HTMLEditFormat(request.listBean.getdescription())#</textarea><input type=hidden name="siteid" value="#HTMLEditFormat(attributes.siteid)#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploadlistmaintenancefile')#</dt>
<dd><input type="radio" name="direction" id="da" value="add" checked> <label for="da">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.addaddressestolist')#</label></dd>
<dd><input type="radio" name="direction" id="dm" value="remove"> <label for="dm">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.removeaddressesfromlist')#</label></dd>
<dd><input type="radio" name="direction" id="dp" value="replace"> <label for="dp">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.replaceemaillistwithnewfile')#</label></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#</dt>
<dd><input type="file" name="listfile" accept="text/plain" ></dd>
<cfif attributes.mlid neq ''>
<dt><input type="checkbox" id="cm" name="clearMembers" value="1" /> <label for="cm">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.clearoutexistingmembers')#</label></dt>
</cfif></dl>      
<cfif attributes.mlid neq ''>
</div>
<cfinclude template="dsp_tab_usage.cfm">
</div>
</cfif>
<div class="clearfix" id="actionButtons">			
<cfif attributes.mlid eq ''>
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.add')#" />
	<input type=hidden name="mlid" value="#createuuid()#">
<cfelse>
	<cfif not request.listBean.getispurge()>
		<input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deleteconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#" />
	</cfif> 
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.update')#" />
	<input type=hidden name="mlid" value="#request.listBean.getmlid()#">
</cfif>
<input type="hidden" name="action" value="">
</form>
</div>
<div id="actionIndicator" style="display: none;">
	<img class="loadProgress" src="#application.configBean.getContext()#/admin/images/progress_bar.gif">
</div>
</cfoutput>
<!---
<cfif attributes.mlid neq ''>
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.usagereport'))#"),0,0,0);
</script></cfoutput>
</cfif>--->