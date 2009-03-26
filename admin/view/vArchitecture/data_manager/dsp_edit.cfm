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

<cfsilent>
<cfset rsData=application.dataCollectionManager.read(attributes.responseid)/>
</cfsilent>
<cfoutput>
<form name="form1" action="index.cfm" method="post">
<dl class="oneColumn">
<cfsilent><cfwddx action="wddx2cfml" input="#rsdata.data#" output="info"></cfsilent>
<dt>Date/Time Entered</dt>
<dd>#rsdata.entered#</dd>
<cfloop list="#attributes.fieldnames#" index="f">
	<cftry><cfset fValue=info['#f#']><cfcatch><cfset fValue=""></cfcatch></cftry>
	<cfif findNoCase('attachment',f) and isValid("UUID",fvalue)>
	<input type="hidden" name="#f#" value="#fvalue#">
	<cfelse>
	<dt>#f#</dt><dd><cfif len(fValue) gt 100><textarea name="#f#">#HTMLEditFormat(fvalue)#</textarea><cfelse><input type="text" name="#f#" value="#HTMLEditFormat(fvalue)#"></cfif></dd>
	</cfif>
</cfloop>
</dl>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.update')#</span></a><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','This');"><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.deleteresponse')#</span></a>
<input type="hidden" name="formid" value="#attributes.contentid#">
<input type="hidden" name="contentid" value="#attributes.contentid#">
<input type="hidden" name="siteid" value="#attributes.siteid#">
<input type="hidden" name="fuseaction" value="cArch.datamanager">
<input type="hidden" name="responseID" value="#rsdata.responseID#">
<input type="hidden" name="hour1" value="#attributes.hour1#">
<input type="hidden" name="hour2" value="#attributes.hour2#">
<input type="hidden" name="minute1" value="#attributes.minute1#">
<input type="hidden" name="minute2" value="#attributes.minute2#">
<input type="hidden" name="date1" value="#attributes.date1#">
<input type="hidden" name="date2" value="#attributes.date2#">
<input type="hidden" name="fieldlist" value="#attributes.fieldnames#">
<input type="hidden" name="sortBy" value="#attributes.sortBy#">
<input type="hidden" name="sortDirection" value="#attributes.sortDirection#">
<input type="hidden" name="filterBy" value="#attributes.filterBy#">
<input type="hidden" name="keywords" value="#attributes.keywords#">
<input type="hidden" name="entered" value="#rsData.entered#">
<input type="hidden" name="moduleid" value="#attributes.moduleid#">
<input type="hidden" name="action" value="update">
</form>
</cfoutput>