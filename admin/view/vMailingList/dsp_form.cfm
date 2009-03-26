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

 <cfoutput><form action="index.cfm?fuseaction=cMailingList.update" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);">
<h2>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h2>
<cfif attributes.mlid neq ''><ul id="navTask">
<li><a href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#attributes.mlid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.vieweditmembers')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.download&mlid=#attributes.mlid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.downloadmembers')#</a></li>
</ul></cfif>
<dl class="oneColumn"><cfif request.listBean.getispurge() neq 1>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#</dt>
<dd><input type=text name="Name" value="#HTMLEditFormat(request.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="text"></dd>
<cfif attributes.mlid neq ''>
</dl>
<div id="page_tabView">
<div class="page_aTab">
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
<div id="page_tabView">
<div class="page_aTab">
<dl class="oneColumn">
<dt class="first">
</cfif>
#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.description')#</dt>
<dd><textarea id="description" name="description" cols="17" rows="7" class="alt">#HTMLEditFormat(request.listBean.getdescription())#</textarea><input type=hidden name="siteid" value="#attributes.siteid#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploadlistmaintenancefile')#</dt>
<dd><input type="radio" name="direction" id="da" value="add" checked> <label for="da">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.addaddressestolist')#</label></dd>
<dd><input type="radio" name="direction" id="dm" value="remove"> <label for="dm">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.removeaddressesfromlist')#</label></dd>
<dd><input type="radio" name="direction" id="dp" value="replace"> <label for="dp">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.replaceemaillistwithnewfile')#</label></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#</dt>
<dd><input type="file" name="listfile" accept="text/html,test/plain" ></dd>
<cfif attributes.mlid neq ''>
<dt><input type="checkbox" id="cm" name="clearMembers" value="1" /> <label for="cm">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.clearoutexistingmembers')#</label></dt>
</cfif></dl>      
<cfif attributes.mlid neq ''>
</div>
<cfinclude template="dsp_tab_usage.cfm">
</div>
</cfif>  			
<cfif attributes.mlid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.add')#</span></a><input type=hidden name="mlid" value="#createuuid()#"><cfelse><cfif not request.listBean.getispurge()><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deleteconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</span></a></cfif> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.update')#</span></a>
<input type=hidden name="mlid" value="#request.listBean.getmlid()#"></cfif><input type="hidden" name="action" value=""></form></cfoutput>

<cfif attributes.mlid neq ''>
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.usagereport'))#"),0,0,0);
</script></cfoutput>
</cfif>