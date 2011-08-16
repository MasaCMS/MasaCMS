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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfset request.layout=false>
<cfset $=application.serviceFactory.getBean("MuraScope").init(session.siteID)>
<cfset content=$.getBean("content").loadBy(contentID=rc.contentID)>
<cfif not content.hasDrafts()>
	<cfoutput>
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.edit#rc.attribute#')#</h1>
	<span class="cancel" onclick="jQuery('.mura-quickEdit').remove();">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.cancel')#]</span>
	
	<cfif rc.attribute eq "isnav">
		<select id="mura-quickEdit-isnav">
			 <option value="1"<cfif content.getIsNav()> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.true')#</option>
			 <option value="0"<cfif not content.getIsNav()> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.false')#</option>
		</select>
	<cfelseif rc.attribute eq "inheritObjects">
		<select id="mura-quickEdit-inheritobjects">
			<option value="Inherit"<cfif content.getInheritObjects() eq "Inherit"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritcascade')#</option>
			<option value="Cascade"<cfif content.getInheritObjects() eq "Cascade"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startnewcascade')#</option>
			<option value="Reject"<cfif content.getInheritObjects() eq "Reject"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.donotinheritcascade')#</option>
		</select>
	<cfelseif rc.attribute eq "template">
		<cfset rsTemplates=application.contentUtility.getTemplates(rc.siteid,content.getType()) />
		<select id="mura-quickEdit-template">
			<cfif rc.contentid neq '00000000000000000000000000000000001'>
				<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritfromparent')#</option>
			</cfif>
			<cfloop query="rsTemplates">
			<cfif right(rsTemplates.name,4) eq ".cfm">
				<cfoutput>
				<option value="#rsTemplates.name#" <cfif content.gettemplate() eq rsTemplates.name>selected</cfif>>#rsTemplates.name#</option>
				</cfoutput>
			</cfif>
			</cfloop>
		</select>
	<cfelseif rc.attribute eq "display">
		<select id="mura-quickEdit-display" onchange="this.selectedIndex==2?toggleDisplay2('mura-quickEdit-displayDates',true):toggleDisplay2('mura-quickEdit-displayDates',false);">
			<option value="1"  <cfif content.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
			<option value="0"  <cfif content.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
			<option value="2"  <cfif content.getdisplay() EQ 2> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
		</select>
		
		<dl id="mura-quickEdit-displayDates"<cfif content.getdisplay() NEQ 2> style="display: none;"</cfif>>
			<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</dt>
			<dd><input type="text" id="mura-quickEdit-displayStart" value="#LSDateFormat(content.getdisplaystart(),session.dateKeyFormat)#" class="textAlt datepicker mura-quickEdit-datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=displayStart&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
				<select id="mura-quickEdit-startHour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(content.getdisplaystart())  and h eq 12 or (LSisDate(content.getdisplaystart()) and (hour(content.getdisplaystart()) eq h or (hour(content.getdisplaystart()) - 12) eq h or hour(content.getdisplaystart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
				<select id="mura-quickEdit-startMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(content.getdisplaystart()) and minute(content.getdisplaystart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
				<select id="mura-quickEdit-startDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(content.getdisplaystart()) and hour(content.getdisplaystart()) gte 12>selected</cfif>>PM</option></select>
			</dd>
			<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#</dt>
			<dd><input type="text" id="mura-quickEdit-displayStop" value="#LSDateFormat(content.getdisplaystop(),session.dateKeyFormat)#" class="textAlt datepicker mura-quickEdit-datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=displayStop&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
				<select id="mura-quickEdit-stopHour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(content.getdisplaystop())  and h eq 11 or (LSisDate(content.getdisplaystop()) and (hour(content.getdisplaystop()) eq h or (hour(content.getdisplaystop()) - 12) eq h or hour(content.getdisplaystop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
				<select id="mura-quickEdit-stopMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(content.getdisplaystop()) and m eq 59) or (LSisDate(content.getdisplaystop()) and minute(content.getdisplaystop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
				<select id="mura-quickEdit-stopDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(content.getdisplaystop()) and (hour(content.getdisplaystop()) gte 12)) or not LSisDate(content.getdisplaystop())>selected</cfif>>PM</option></select>
			</dd>
		</dl>
	</cfif>
	<input type="button" name="submit" value="Submit" class="submit" onclick="saveQuickEdit(this);" />
	</cfoutput>
<cfelse>
	<cfoutput>
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.hasdraftstitle')# </h1>
	<span class="cancel" onclick="jQuery('.mura-quickEdit').remove();">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.cancel')#]</span>
		<p>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.hasdraftsmessage')#</p>
	</cfoutput>
</cfif>

