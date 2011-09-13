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
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfset catTrim = url.id>
<cfsetting enableCFoutputOnly="true">
<cfoutput><dt class="start">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</dt><dd class="start"><input type="text" name="featureStart#catTrim#" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdate')#" onclick="if(this.value=='Start Date'){this.value=''};" class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png"  hidefocus onClick="window.open('date_picker/index.cfm?form=contentForm&field=featureStart#catTrim#&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
		<select name="starthour#catTrim#"  class="dropdown">
			<cfloop from="1" to="12" index="h">
				<option value="#h#" <cfif h eq 12>selected</cfif>>#h#</option>
			</cfloop>
		</select>
		<select name="startMinute#catTrim#" class="dropdown">
			<cfloop from="0" to="59" index="m">
				<option value="#m#">#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option>
			</cfloop>
		</select>
		<select name="startDayPart#catTrim#" class="dropdown">
			<option value="AM">AM</option>
			<option value="PM">PM</option>
		</select>
	</dd> 
	
	<dt class="stop">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#</dt>
	<dd class="stop">
		<input type="text" name="featureStop#catTrim#" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdate')#"  onclick="if(this.value=='Stop Date'){this.value=''};" class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png"  hidefocus onClick="window.open('date_picker/index.cfm?form=contentForm&field=featureStop#catTrim#&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
		<select name="stophour#catTrim#" class="dropdown">
			<cfloop from="1" to="12" index="h">
				<option value="#h#" <cfif h eq 11>selected</cfif>>#h#</option>
			</cfloop>
		</select>
		<select name="stopMinute#catTrim#"  class="dropdown">
			<cfloop from="0" to="59" index="m">
				<option value="#m#" <cfif m eq 59>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option>
			</cfloop>
		</select>
		<select name="stopDayPart#catTrim#" class="dropdown">
			<option value="AM">AM</option>
			<option value="PM" selected>PM</option>
		</select>
	</dd>
</cfoutput>
