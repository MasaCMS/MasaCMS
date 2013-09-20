
		<cfset bydate=iif(rc.contentBean.getdisplay() EQ 2 or (rc.ptype eq 'Calendar' and rc.contentBean.getIsNew()),de('true'),de('false'))>
		<cfoutput>
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#
	      		 <i class="icon-question-sign"></i></a>
	      	</label>
	      	<div class="controls">
	      		<select name="display" class="span3" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
					<option value="1"  <cfif  rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="0"  <cfif  rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="2"  <cfif  bydate> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
				</select>
			</div>
			<div id="editDates" <cfif  not bydate>style="display: none;"</cfif>>
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</label>
					<div class="controls">
						<cf_datetimeselector name="displayStart" datetime="#rc.contentBean.getDisplayStart()#">
						<!---
						<input type="text" name="displayStart" value="#LSDateFormat(rc.contentBean.getdisplaystart(),session.dateKeyFormat)#" class="textAlt datepicker">
					
						<cf_timeselector name="start" time="#rc.contentBean.getDisplayStart()#">
						
						<cfif session.localeHasDayParts>
							<select name="starthour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystart())  and h eq 12 or (LSisDate(rc.contentBean.getdisplaystart()) and (hour(rc.contentBean.getdisplaystart()) eq h or (hour(rc.contentBean.getdisplaystart()) - 12) eq h or hour(rc.contentBean.getdisplaystart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<cfelse>
							<select name="starthour" class="time"><cfloop from="0" to="23" index="h"><option value="#h#" <cfif LSisDate(rc.contentBean.getdisplaystart())  and hour(rc.contentBean.getdisplaystart()) eq h >selected</cfif>>#h#</option></cfloop></select>
						</cfif>

						<select name="startMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getdisplaystart()) and minute(rc.contentBean.getdisplaystart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						
						<cfif session.localeHasDayParts>
							<select name="startDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getdisplaystart()) and hour(rc.contentBean.getdisplaystart()) gte 12>selected</cfif>>PM</option></select>
						</cfif>
						--->
					</div>			
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<cf_datetimeselector name="displayStop" datetime="#rc.contentBean.getDisplayStop()#" defaulthour="23" defaultminute="59">

						<!---
						<input type="text" name="displayStop" value="#LSDateFormat(rc.contentBean.getdisplaystop(),session.dateKeyFormat)#" class="textAlt datepicker">
						
						
						<cfif session.localeHasDayParts>
							<select name="stophour" class="time"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystop())  and h eq 11 or (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) eq h or (hour(rc.contentBean.getdisplaystop()) - 12) eq h or hour(rc.contentBean.getdisplaystop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<cfelse>
							<select name="stophour" class="time"><cfloop from="0" to="23" index="h"><option value="#h#" <cfif LSisDate(rc.contentBean.getdisplaystop()) and hour(rc.contentBean.getdisplaystop()) eq h or not LSisDate(rc.contentBean.getdisplaystop()) and h eq 23>selected</cfif>>#h#</option></cfloop></select>
						</cfif>

						<select name="stopMinute" class="time"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getdisplaystop()) and m eq 59) or (LSisDate(rc.contentBean.getdisplaystop()) and minute(rc.contentBean.getdisplaystop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>

						<cfif session.localeHasDayParts>
						<select name="stopDayPart" class="time"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) gte 12)) or not LSisDate(rc.contentBean.getdisplaystop())>selected</cfif>>PM</option></select>
						</cfif>
						--->
					</div>
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval')#
					</label>
					<div class="controls">
						<select name="displayInterval" class="span2">
							<cfloop list="Daily,Weekly,Bi-Weekly,Monthly,WeekDays,WeekEnds,Week1,Week2,Week3,Week4,WeekLast" index="i">
							<option value="#i#"<cfif rc.contentBean.getDisplayInterval() eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</div>
			</cfoutput>