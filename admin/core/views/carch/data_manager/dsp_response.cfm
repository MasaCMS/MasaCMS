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
<form novalidate="novalidate" action="index.cfm" method="get" name="download" onsubmit="return validate(this);">

	<div class="mura-control-group">
  	<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.from')#</label>
  	<input type="text" class="datepicker" name="date1"  validate="onServer" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tovalidate')#" required="true" value="#LSDateFormat(rc.date1,session.dateKeyFormat)#">
  	<select name="hour1" class="time"><cfloop from="0"to="23" index="h"><option value="#h#" <cfif hour(rc.rsDataInfo.firstentered) eq h>selected</cfif>><cfif h eq 0>12 AM<cfelseif h lt 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# AM<cfelseif h eq 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# PM<cfelse><cfset h2=h-12>#iif(len(h2) lt 2,de('0#h2#'),de('#h2#'))# PM</cfif></option></cfloop></select>
    <select name="minute1" class="time"><cfloop from="0"to="59" index="mn"><option value="#mn#" <cfif minute(rc.rsDataInfo.firstentered) eq mn>selected</cfif>>#iif(len(mn) lt 2,de('0#mn#'),de('#mn#'))#</option></cfloop></select>
	</div>

	<div class="mura-control-group">
  	<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.to')#</label>
  	<input type="text" class="datepicker" name="date2" validate="onServer" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tovalidate')#" required="true" value="#LSDateFormat(rc.date2,session.dateKeyFormat)#">
  	<select name="hour2" class="time"><cfloop from="0"to="23" index="h"><option value="#h#" <cfif hour(rc.rsDataInfo.Lastentered) eq h>selected</cfif>><cfif h eq 0>12 AM<cfelseif h lt 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# AM<cfelseif h eq 12>#iif(len(h) lt 2,de('0#h#'),de('#h#'))# PM<cfelse><cfset h2=h-12>#iif(len(h2) lt 2,de('0#h2#'),de('#h2#'))# PM</cfif></option></cfloop></select>
    <select name="minute2" class="time" ><cfloop from="0"to="59" index="mn"><option value="#mn#" <cfif minute(rc.rsDataInfo.lastentered) eq mn>selected</cfif>>#iif(len(mn) lt 2,de('0#mn#'),de('#mn#'))#</option></cfloop>
   </select>
	</div>

<div class="mura-control-group">
  <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sortby')#</label>
  <select name="sortBy" class="mura-constrain">
<option value="Entered" <cfif "Entered" eq rc.sortBy>selected</cfif>>Entered</option>
<cfloop list="#rc.fieldnames#" index="f">
<option value="#esapiEncode('html_attr',f)#" <cfif f eq rc.sortBy>selected</cfif>>#esapiEncode('html',f)#</option>
</cfloop>
</select>
<select name="sortDirection" class="mura-constrain">
<option value="asc" <cfif rc.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ascending')#</option>
<option value="desc" <cfif rc.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.descending')#</option>
</select>
</div>

	<div class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywordsearch')#</label>
		<select name="filterBy" class="mura-constrain">
			<cfloop list="#rc.fieldnames#" index="f">
			<option value="#esapiEncode('html_attr',f)#" <cfif f eq session.filterBy>selected</cfif>>#esapiEncode('html',f)#</option>
			</cfloop>
		</select>
		<input type="text" name="keywords" class="mura-constrain" value="#esapiEncode('html_attr',session.datakeywords)#">
	</div>

<input type="hidden" name="muraAction" value="cArch.datamanager" />
<input type="hidden" name="contentid" value="#esapiEncode('html_attr',rc.contentid)#" />
<input type="hidden" name="siteid" value="#esapiEncode('html_attr',session.siteid)#" />
<input type="hidden" name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#" />
<input type="hidden" name="newSearch" value="1" />
<input type="hidden" name="delete" value="0" />
<div class="mura-actions">
	<div class="form-actions">
		<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.download);" /><i class="mi-bar-chart"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewdata')#</button>
		<cfset downloadLocationString="'./?muraAction=cArch.downloaddata&siteid=#esapiEncode('url',rc.siteid)#&contentid=#esapiEncode('url',rc.contentid)#&date1=' + document.download.date1.value + '&hour1=' +document.download.hour1.value + '&minute1=' +document.download.minute1.value + '&date2=' + document.download.date2.value + '&hour2=' + document.download.hour2.value + '&minute2=' + document.download.minute2.value + '&sortBy=' +  document.download.sortBy.value + '&sortDirection=' +  document.download.sortDirection.value + '&filterBy='  + document.download.filterBy.value + '&keywords=' + document.download.keywords.value + '&columns=#esapiEncode('url',rc.columns)#'">
		<cfif isdefined ('rc.minute1')><button type="button" class="btn" onclick="return confirmDialog('Delete filtered results?',function(){document.download.delete.value=1;submitForm(document.forms.download);});" /><i class="mi-trash"></i> Delete Results</button></cfif>
		<button type="button" class="btn" onclick="location.href=#downloadLocationString#;"><i class="mi-download"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.download')#</button>
	</div>
</div>
</form>
</cfoutput>
<cfelse>
	<div class="help-block-empty">No data to display for this form</div>
</cfif>
<cfif isdefined ('rc.minute1')>
	<cfsilent>
	<cfset rsData=application.dataCollectionManager.getData(rc)/>
	</cfsilent>
	<cfif rsData.recordcount>
		<cfif isDefined('rc.delete') and isBoolean(rc.delete) and rc.delete>
			<cfloop query="rsData">
				<cfset application.dataCollectionManager.delete(responseid=rsData.responseID,deleteFiles=true)>
			</cfloop>
			<div class="help-block-empty"><cfoutput>#rsData.recordcount#</cfoutput> responses were deleted.</div>
		<cfelse>
			<div class="mura-grid-container">
			<table class="mura-table-grid">
			<thead>
			<tr>
				<th class="actions"></th>
				<th><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datetimeentered')#</cfoutput></th>
				<cfloop list="#rc.fieldnames#" index="f">
				<th><cfoutput>#esapiEncode('html',f)#</cfoutput></th>
				</cfloop>
			</tr>
			</thead>
			<tbody>
			<cfoutput query="rsData">
			<tr>
				<cftry>
					<cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>
					<td class="actions">
						<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
						<div class="actions-menu hide">
							<ul class="actions-list">
								<li class="edit">
									<a href="./?muraAction=cArch.datamanager&contentid=#esapiEncode('url',rc.contentid)#&siteid=#esapiEncode('url',rc.siteid)#&date1=#esapiEncode('url',rc.date1)#&hour1=#esapiEncode('url',rc.hour1)#&minute1=#esapiEncode('url',rc.minute1)#&date2=#esapiEncode('url',rc.date2)#&hour2=#esapiEncode('url',rc.hour2)#&minute2=#esapiEncode('url',rc.minute2)#&responseid=#rsdata.responseid#&action=edit&moduleid=#esapiEncode('url',rc.moduleid)#&sortBy=#esapiEncode('url',rc.sortBy)#&sortDirection=#esapiEncode('url',rc.sortDirection)#&filterBy=#esapiEncode('url',rc.filterBy)#&keywords=#esapiEncode('url',rc.keywords)#"><i class="mi-pencil"></i>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#</a>
								</li>
								<li class="delete">
									<a href="./?muraAction=cArch.datamanager&contentid=#esapiEncode('url',rc.contentid)#&siteid=#esapiEncode('url',rc.siteid)#&date1=#esapiEncode('url',rc.date1)#&hour1=#esapiEncode('url',rc.hour1)#&minute1=#esapiEncode('url',rc.minute1)#&date2=#esapiEncode('url',rc.date2)#&hour2=#esapiEncode('url',rc.hour2)#&minute2=#esapiEncode('url',rc.minute2)#&responseid=#rsdata.responseid#&action=delete&moduleid=#esapiEncode('url',rc.moduleid)#&sortBy=#esapiEncode('url',rc.sortBy)#&sortDirection=#esapiEncode('url',rc.sortDirection)#&filterBy=#esapiEncode('url',rc.filterBy)#&keywords=#esapiEncode('url',rc.keywords)##rc.$.renderCSRFTokens(context=rsdata.responseID,format='url')#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponseconfirm'))#',this.href)"><i class="mi-trash"></i>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponse')#</a>
								</li>
							</ul>
						</div>
					</td>
					<td class="dateSubmitted">#lsdateformat(rsdata.entered,session.dateKeyFormat)# #lstimeformat(rsdata.entered,"short")#</td>
					<cfloop list="#rc.fieldnames#" index="f">
						<cftry><cfset fValue=info['#f#']><cfcatch><cfset fValue=""></cfcatch></cftry>
					<td class="mForm-data"><cfif findNoCase('attachment',f) and isValid("UUID",fvalue)><a  href="##" onclick="return preview('#rc.$.siteConfig('scheme')#://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#esapiEncode('url',fvalue)#');">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.viewattachment')#</a><cfelse>#$.setParagraphs(esapiEncode('html',fvalue))#</cfif></td>
					</cfloop>
					<cfcatch>
						<td>Invalid Response: #rsData.responseID#</td>
					</cfcatch>
				</cftry>
			</tr>
			</cfoutput>
			</tbody>
			</table>
			</div><!-- /.mura-grid-container -->
		</cfif>
	</cfif>
</cfif>
</div>
