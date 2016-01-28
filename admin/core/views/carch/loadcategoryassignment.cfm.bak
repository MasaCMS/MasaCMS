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
<cfset request.layout=false>
<cfif not isNumeric(rc.categoryAssignment)>
	<cfset rc.categoryAssignment=0>
</cfif>
<cfset $=application.serviceFactory.getBean("MuraScope").init(session.siteID)>
	<cfoutput>
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.feature')#</h1>
	<span class="cancel" onclick="siteManager.closeCategoryAssignment();" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.cancel')#"><i class="icon-remove-sign"></i></span>

		<!---
		<select id="mura-quickEdit-display" onchange="this.selectedIndex==2?toggleDisplay2('mura-quickEdit-displayDates',true):toggleDisplay2('mura-quickEdit-displayDates',false);">
			<option value=""  <cfif rc.categoryAssignment EQ ''> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
			<option value="0"  <cfif content.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
			<option value="2"  <cfif content.getdisplay() EQ 2> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
		</select>
		--->
		<select id="mura-quickEdit-display" onchange="this.selectedIndex==2?toggleDisplay2('mura-quickEdit-displayDates',true):toggleDisplay2('mura-quickEdit-displayDates',false);">
		<option <cfif rc.categoryAssignment eq '0'>selected</cfif> value="0">#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
		<option value="1" <cfif rc.categoryAssignment eq '1'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
		<option value="2" <cfif rc.categoryAssignment eq '2'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.scheduledfeature')#</option>
		</select>
		
		<ol id="mura-quickEdit-displayDates"<cfif rc.categoryAssignment NEQ 2> style="display: none;"</cfif>>
			<li><label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</label>
			<input type="text" id="mura-quickEdit-featureStart" value="#LSDateFormat(rc.featurestart,session.dateKeyFormat)#" class="textAlt datepicker mura-quickEdit-datepicker"><br />

			<cfif session.localeHasDayParts>
				<select id="mura-quickEdit-startHour" class="time">
					<cfloop from="1" to="12" index="h">
						<option value="#h#" <cfif isNumeric(rc.startHour) and (rc.startHour eq h or rc.startHour eq 0 and h eq 12) or not isNumeric(rc.startHour) and h eq 12>selected</cfif>>#h#</option>
					</cfloop>
				</select>
			<cfelse>
				<select id="mura-quickEdit-startHour" class="time">
					<cfloop from="0" to="23" index="h">
						<option value="#h#" <cfif isNumeric(rc.startHour) and rc.startHour eq h>selected</cfif>>#h#</option>
					</cfloop>
				</select>

			</cfif>

			<select id="mura-quickEdit-startMinute" class="time">
				<cfloop from="0" to="59" index="m">
					<option value="#m#" <cfif isNumeric(rc.startMinute) and rc.startMinute eq m>selected</cfif>>
						#iif(len(m) eq 1,de('0#m#'),de('#m#'))#
					</option>
				</cfloop>
			</select>

			<cfif session.localeHasDayParts>
				<select id="mura-quickEdit-startDayPart" class="time">
					<option value="AM">AM</option>
					<option value="PM" <cfif rc.startDayPart eq 'PM'>selected</cfif>>PM</option>
				</select>
			</cfif>
	
			</li>
			<li><label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#</label>
			<input type="text" id="mura-quickEdit-featureStop" value="#LSDateFormat(rc.featureStop,session.dateKeyFormat)#" class="textAlt datepicker mura-quickEdit-datepicker"><br />


			<cfif session.localeHasDayParts>
				<select id="mura-quickEdit-stopHour" class="time">
					<cfloop from="1" to="12" index="h">
						<option value="#h#" <cfif isNumeric(rc.stopHour) and (rc.stopHour eq h or rc.stopHour eq 0 and h eq 12) or not isNumeric(rc.stopHour) and h eq 11>selected</cfif>>#h#</option>
					</cfloop>
				</select>
			<cfelse>
				<select id="mura-quickEdit-stopHour" class="time">
					<cfloop from="0" to="23" index="h">
						<option value="#h#" <cfif isNumeric(rc.stopHour) and rc.stopHour eq h or not isNumeric(rc.stopHour) and h eq 23>selected</cfif>>#h#</option>
					</cfloop>
				</select>
			</cfif>

			<select id="mura-quickEdit-stopMinute" class="time">
				<cfloop from="0" to="59" index="m">
					<option value="#m#" <cfif isNumeric(rc.stopMinute) and rc.stopMinute eq m or m eq 59>selected</cfif>>
						#iif(len(m) eq 1,de('0#m#'),de('#m#'))#
					</option>
				</cfloop>
			</select>

			<cfif session.localeHasDayParts>
				<select id="mura-quickEdit-stopDayPart" class="time">
					<option value="AM">AM</option>
					<option value="PM" <cfif rc.stopDayPart neq 'AM'>selected</cfif>>PM</option>
				</select>
			</cfif>
			</li>
		</ol>	
	<input type="hidden" id="mura-quickEdit-cattrim" value="#esapiEncode('html_attr',rc.cattrim)#">
	<div class="form-actions">
	<input type="button" value="Submit" class="btn" onclick="siteManager.saveCategoryAssignment();" />
	</div>
	</cfoutput>


