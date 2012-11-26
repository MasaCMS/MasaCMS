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
<cfsilent>
	<cfif LSisDate(rc.date1)>
		<cfset rc.date1=rc.date1>
	<cfelse>
		<cfset rc.date1=rc.rsDataInfo.firstentered>
	</cfif>

	<cfif LSisDate(rc.date2)>
		<cfset rc.date2=rc.date2>
	<cfelse>
		<cfset rc.date2=rc.rsDataInfo.lastentered>
	</cfif>
	
	<cfif len(rc.contentBean.getResponseDisplayFields()) gt 0 and rc.contentBean.getResponseDisplayFields() neq "~">
		<cfset rc.fieldnames=replace(listLast(rc.contentBean.getResponseDisplayFields(),"~"), "^", ",", "ALL")>
	<cfelse>
		<cfset rc.fieldnames=application.dataCollectionManager.getCurrentFieldList(rc.contentid)/>
	</cfif>
</cfsilent>

<div id="manage-data">
<cfif rc.rsDataInfo.CountEntered>
<cfparam name="rc.columns" default="fixed" />
<cfoutput>
<form novalidate="novalidate" action="index.cfm" method="get" name="download" onsubmit="return validate(this);" class="fieldset-wrap">

<div class="fieldset"><div class="control-group">
  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.from')#</label>
  <div class="controls">
  	<input type="text" class="datepicker span2" name="date1"  validate="date" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tovalidate')#" required="true" value="#LSDateFormat(rc.date1,session.dateKeyFormat)#">
  	<select name="hour1"  class="span2"><cfloop from="0"to="23" index="h"><option value="#h#" <cfif hour(rc.rsDataInfo.firstentered) eq h>selected</cfif>><cfif h eq 0>12 AM<cfelseif h lt 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# AM<cfelseif h eq 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# PM<cfelse><cfset h2=h-12>#iif(len(h2) lt 2,de('0#h2#'),de('#h2#'))# PM</cfif></option></cfloop></select>
    <select name="minute1" class="span1"><cfloop from="0"to="59" index="mn"><option value="#mn#" <cfif minute(rc.rsDataInfo.firstentered) eq mn>selected</cfif>>#iif(len(mn) lt 2,de('0#mn#'),de('#mn#'))#</option></cfloop></select>
</div>
</div>

<div class="control-group">
  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.to')#</label>
  <div class="controls">
  	<input type="text" class="datepicker span2" name="date2" validate="date" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tovalidate')#" required="true" value="#LSDateFormat(rc.date2,session.dateKeyFormat)#">
  	<select name="hour2"  class="span2"><cfloop from="0"to="23" index="h"><option value="#h#" <cfif hour(rc.rsDataInfo.Lastentered) eq h>selected</cfif>><cfif h eq 0>12 AM<cfelseif h lt 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# AM<cfelseif h eq 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# PM<cfelse><cfset h2=h-12>#iif(len(h2) lt 2,de('0#h2#'),de('#h2#'))# PM</cfif></option></cfloop></select>
    <select name="minute2"  class="span1"><cfloop from="0"to="59" index="mn"><option value="#mn#" <cfif minute(rc.rsDataInfo.lastentered) eq mn>selected</cfif>>#iif(len(mn) lt 2,de('0#mn#'),de('#mn#'))#</option></cfloop>
   </select>
</div>
</div>

<div class="control-group">
  <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sortby')#</label>
  <div class="controls"><select name="sortBy" class="span2">
<option value="Entered" <cfif "Entered" eq rc.sortBy>selected</cfif>>Entered</option>
<cfloop list="#rc.fieldnames#" index="f">
<option value="#f#" <cfif f eq rc.sortBy>selected</cfif>>#f#</option>
</cfloop>
</select>
<select name="sortDirection" class="span2">
<option value="asc" <cfif rc.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ascending')#</option>
<option value="desc" <cfif rc.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.descending')#</option>
</select>
</div>
</div>

<div class="control-group">
	<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywordsearch')#</label>
	<div class="controls">
		<select name="filterBy" class="span2">
		<cfloop list="#rc.fieldnames#" index="f">
		<option value="#f#" <cfif f eq session.filterBy>selected</cfif>>#f#</option>
		</cfloop>
		</select>
		<input type="text" class="span6" name="keywords" value="#session.datakeywords#">
	</div>
</div>
</div>
<input type="hidden" name="muraAction" value="cArch.datamanager" />
<input type="hidden" name="contentid" value="#HTMLEditFormat(rc.contentid)#" />
<input type="hidden" name="siteid" value="#HTMLEditFormat(session.siteid)#" />
<input type="hidden" name="moduleid" value="#rc.moduleid#" />
<input type="hidden" name="newSearch" value="1" />
<div class="form-actions">
	<button type="button" class="btn" onclick="submitForm(document.forms.download);" /><i class="icon-bar-chart"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewdata')#</button>
	<button type="button" class="btn" onclick="location.href='index.cfm?muraAction=cArch.downloaddata&siteid=#URLEncodedFormat(rc.siteid)#&contentid=#URLEncodedFormat(rc.contentid)#&date1=' + document.download.date1.value + '&hour1=' +document.download.hour1.value + '&minute1=' +document.download.minute1.value + '&date2=' + document.download.date2.value + '&hour2=' + document.download.hour2.value + '&minute2=' + document.download.minute2.value + '&sortBy=' +  document.download.sortBy.value + '&sortDirection=' +  document.download.sortDirection.value + '&filterBy='  + document.download.filterBy.value + '&keywords=' + document.download.keywords.value + '&columns=#rc.columns#';"><i class="icon-download"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.download')#</button>
</div>
</form></cfoutput>
</cfif>
<cfif isdefined ('rc.minute1')>
<cfsilent>
<cfset rsData=application.dataCollectionManager.getData(rc)/>
</cfsilent>
<cfif rsData.recordcount>
<table class="table table-striped table-condensed table-bordered mura-table-grid">
<thead>
<tr>
<th>&nbsp;</th>
<th><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datetimeentered')#</cfoutput></th>
<cfloop list="#rc.fieldnames#" index="f">
<th><cfoutput>#f#</cfoutput></th>
</cfloop>
</tr>
</thead>
<tbody>
<cfoutput query="rsData">
<tr>
<cftry>
	<cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>
	<td class="actions">
		<ul>
			<li class="edit">
				<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#" href="index.cfm?muraAction=cArch.datamanager&contentid=#URLEncodedFormat(rc.contentid)#&siteid=#URLEncodedFormat(rc.siteid)#&date1=#rc.date1#&hour1=#rc.hour1#&minute1=#rc.minute1#&date2=#rc.date2#&hour2=#rc.hour2#&minute2=#rc.minute2#&responseid=#rsdata.responseid#&action=edit&moduleid=#rc.moduleid#&sortBy=#urlEncodedFormat(rc.sortBy)#&sortDirection=#rc.sortDirection#&filterBy=#urlEncodedFormat(rc.filterBy)#&keywords=#urlEncodedFormat(rc.keywords)#"><i class="icon-pencil"></i></a>
			</li>
			<li class="delete">
				<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponse')#" href="index.cfm?muraAction=cArch.datamanager&contentid=#URLEncodedFormat(rc.contentid)#&siteid=#URLEncodedFormat(rc.siteid)#&date1=#rc.date1#&hour1=#rc.hour1#&minute1=#rc.minute1#&date2=#rc.date2#&hour2=#rc.hour2#&minute2=#rc.minute2#&responseid=#rsdata.responseid#&action=delete&moduleid=#rc.moduleid#&sortBy=#urlEncodedFormat(rc.sortBy)#&sortDirection=#rc.sortDirection#&filterBy=#urlEncodedFormat(rc.filterBy)#&keywords=#urlEncodedFormat(rc.keywords)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponseconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a>
			</li>
		</ul>
	</td>
	<td class="dateSubmitted">#lsdateformat(rsdata.entered,session.dateKeyFormat)# #lstimeformat(rsdata.entered,"short")#</td>
	<cfloop list="#rc.fieldnames#" index="f">
		<cftry><cfset fValue=info['#f#']><cfcatch><cfset fValue=""></cfcatch></cftry>
	<td class="mForm-data"><cfif findNoCase('attachment',f) and isValid("UUID",fvalue)><a  href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#fvalue#');">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewattachment')#</a><cfelse>#application.contentRenderer.setParagraphs(htmleditformat(fvalue))#</cfif></td>
	</cfloop>
	<cfcatch>
		<td>Invalid Response: #rsData.responseID#</td>
	</cfcatch>
</cftry>
</tr>
</cfoutput>
</tbody>
</table>

</cfif>
</cfif>
</div>