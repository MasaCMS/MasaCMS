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
	<cfif LSisDate(attributes.date1)>
		<cfset attributes.date1=attributes.date1>
	<cfelse>
		<cfset attributes.date1=request.rsDataInfo.firstentered>
	</cfif>

	<cfif LSisDate(attributes.date2)>
		<cfset attributes.date2=attributes.date2>
	<cfelse>
		<cfset attributes.date2=request.rsDataInfo.lastentered>
	</cfif>
	
	<cfif len(request.contentBean.getResponseDisplayFields()) gt 0 and request.contentBean.getResponseDisplayFields() neq "~">
		<cfset attributes.fieldnames=replace(listLast(request.contentBean.getResponseDisplayFields(),"~"), "^", ",", "ALL")>
	<cfelse>
		<cfset attributes.fieldnames=application.dataCollectionManager.getCurrentFieldList(attributes.contentid)/>
	</cfif>
</cfsilent>

<div id="manageData">
<cfif request.rsDataInfo.CountEntered>
<cfparam name="attributes.columns" default="fixed" />
<cfoutput>
<form novalidate="novalidate" action="index.cfm" method="get" name="download" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.from')#</dt>
<dd><input type="text" class="datepicker" name="date1"  validate="date" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tovalidate')#" required="true" value="#LSDateFormat(attributes.date1,session.dateKeyFormat)#">   <select name="hour1"  class="dropdown"><cfloop from="0"to="23" index="h"><option value="#h#" <cfif hour(request.rsDataInfo.firstentered) eq h>selected</cfif>><cfif h eq 0>12 AM<cfelseif h lt 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# AM<cfelseif h eq 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# PM<cfelse><cfset h2=h-12>#iif(len(h2) lt 2,de('0#h2#'),de('#h2#'))# PM</cfif></option></cfloop></select>
    <select name="minute1"  class="dropdown"><cfloop from="0"to="59" index="mn"><option value="#mn#" <cfif minute(request.rsDataInfo.firstentered) eq mn>selected</cfif>>#iif(len(mn) lt 2,de('0#mn#'),de('#mn#'))#</option></cfloop></select>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.to')#</dt>
<dd><input type="text" class="datepicker" name="date2" validate="date" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tovalidate')#" required="true" value="#LSDateFormat(attributes.date2,session.dateKeyFormat)#">    <select name="hour2"  class="dropdown"><cfloop from="0"to="23" index="h"><option value="#h#" <cfif hour(request.rsDataInfo.Lastentered) eq h>selected</cfif>><cfif h eq 0>12 AM<cfelseif h lt 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# AM<cfelseif h eq 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# PM<cfelse><cfset h2=h-12>#iif(len(h2) lt 2,de('0#h2#'),de('#h2#'))# PM</cfif></option></cfloop></select>
    <select name="minute2"  class="dropdown"><cfloop from="0"to="59" index="mn"><option value="#mn#" <cfif minute(request.rsDataInfo.lastentered) eq mn>selected</cfif>>#iif(len(mn) lt 2,de('0#mn#'),de('#mn#'))#</option></cfloop></select>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sortby')#</dt>
<dd><select name="sortBy" class="dropdown">
<option value="Entered" <cfif "Entered" eq attributes.sortBy>selected</cfif>>ENTERED</option>
<cfloop list="#attributes.fieldnames#" index="f">
<option value="#f#" <cfif f eq attributes.sortBy>selected</cfif>>#f#</option>
</cfloop>
</select>
<select name="sortDirection" class="dropdown">
<option value="asc" <cfif attributes.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ascending')#</option>
<option value="desc" <cfif attributes.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.descending')#</option>
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywordsearch')#</dt>
<dd><select name="filterBy" class="dropdown">
<cfloop list="#attributes.fieldnames#" index="f">
<option value="#f#" <cfif f eq session.filterBy>selected</cfif>>#f#</option>
</cfloop>
</select>
<input type="text" class="text" name="keywords" value="#session.datakeywords#">
</dd>
</dl>

<input type="hidden" name="fuseaction" value="cArch.datamanager" />
<input type="hidden" name="contentid" value="#HTMLEditFormat(attributes.contentid)#" />
<input type="hidden" name="siteid" value="#HTMLEditFormat(session.siteid)#" />
<input type="hidden" name="moduleid" value="#attributes.moduleid#" />
<input type="hidden" name="newSearch" value="1" />
<div class="clearfix" id="actionButtons">
	<input type="button" class="submit" onclick="submitForm(document.forms.download);" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewdata')#"/></a>
	<input type="button" class="submit" onclick="location.href='index.cfm?fuseaction=cArch.downloaddata&siteid=#URLEncodedFormat(attributes.siteid)#&contentid=#URLEncodedFormat(attributes.contentid)#&date1=' + document.download.date1.value + '&hour1=' +document.download.hour1.value + '&minute1=' +document.download.minute1.value + '&date2=' + document.download.date2.value + '&hour2=' + document.download.hour2.value + '&minute2=' + document.download.minute2.value + '&sortBy=' +  document.download.sortBy.value + '&sortDirection=' +  document.download.sortDirection.value + '&filterBy='  + document.download.filterBy.value + '&keywords=' + document.download.keywords.value + '&columns=#attributes.columns#';" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.download')#">
</div>
<div id="actionIndicator" style="display: none;">
	<img class="loadProgress" src="#application.configBean.getContext()#/admin/images/progress_bar.gif">
</div>
</form></cfoutput>
</cfif>
<cfif isdefined ('attributes.minute1')>
<cfsilent>
<cfset rsData=application.dataCollectionManager.getData(attributes)/>
</cfsilent>
<cfif rsData.recordcount>
<table class="mura-table-grid stripe">
<tr>
<th>&nbsp;</th>
<th><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datetimeentered')#</cfoutput></th>
<cfloop list="#attributes.fieldnames#" index="f">
<th><cfoutput>#f#</cfoutput></th>
</cfloop>

</tr>
<cfoutput query="rsData">
<tr>
<cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>
<td class="administration">
	<ul class="two">
		<li class="edit">
			<a href="index.cfm?fuseaction=cArch.datamanager&contentid=#URLEncodedFormat(attributes.contentid)#&siteid=#URLEncodedFormat(attributes.siteid)#&date1=#attributes.date1#&hour1=#attributes.hour1#&minute1=#attributes.minute1#&date2=#attributes.date2#&hour2=#attributes.hour2#&minute2=#attributes.minute2#&responseid=#rsdata.responseid#&action=edit&moduleid=#attributes.moduleid#&sortBy=#urlEncodedFormat(attributes.sortBy)#&sortDirection=#attributes.sortDirection#&filterBy=#urlEncodedFormat(attributes.filterBy)#&keywords=#urlEncodedFormat(attributes.keywords)#">
				<img src="images/icons/edit_24.png" width="14" height="14" border="0" />
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#
			</a>
		</li>
		<li class="delete">
			<a href="index.cfm?fuseaction=cArch.datamanager&contentid=#URLEncodedFormat(attributes.contentid)#&siteid=#URLEncodedFormat(attributes.siteid)#&date1=#attributes.date1#&hour1=#attributes.hour1#&minute1=#attributes.minute1#&date2=#attributes.date2#&hour2=#attributes.hour2#&minute2=#attributes.minute2#&responseid=#rsdata.responseid#&action=delete&moduleid=#attributes.moduleid#&sortBy=#urlEncodedFormat(attributes.sortBy)#&sortDirection=#attributes.sortDirection#&filterBy=#urlEncodedFormat(attributes.filterBy)#&keywords=#urlEncodedFormat(attributes.keywords)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponseconfirm'))#',this.href)">
				<img src="images/icons/remov_24.png" width="14" height="14" border="0" />
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponse')#
			</a>
		</li>
	</ul>
</td>
<td class="dateSubmitted">#lsdateformat(rsdata.entered,session.dateKeyFormat)# #lstimeformat(rsdata.entered,"short")#</td>
<cfloop list="#attributes.fieldnames#" index="f">
	<cftry><cfset fValue=info['#f#']><cfcatch><cfset fValue=""></cfcatch></cftry>
<td class="mForm-data"><cfif findNoCase('attachment',f) and isValid("UUID",fvalue)><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#fvalue#');">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewattachment')#</a><cfelse>#application.contentRenderer.setParagraphs(htmleditformat(fvalue))#</cfif></td>
</cfloop>

</tr>
</cfoutput>
</table>

</cfif>
</cfif>
</div>