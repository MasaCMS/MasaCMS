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
