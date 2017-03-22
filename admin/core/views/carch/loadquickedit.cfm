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
<cfset $=application.serviceFactory.getBean("MuraScope").init(session.siteID)>
<cfset content=$.getBean("content").loadBy(contentID=rc.contentID)>
<cfif not content.hasDrafts()>
	<cfoutput>
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.edit#rc.attribute#')#</h1>
	<span class="cancel" onclick="siteManager.closeQuickEdit();" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.cancel')#"><i class="mi-close"></i></span>

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
		<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.edit.childtemplate')#</h1>
		<select id="mura-quickEdit-childtemplate">
			<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
			<cfloop query="rsTemplates">
			<cfif right(rsTemplates.name,4) eq ".cfm">
				<cfoutput>
				<option value="#rsTemplates.name#" <cfif content.getchildTemplate() eq rsTemplates.name>selected</cfif>>#rsTemplates.name#</option>
				</cfoutput>
			</cfif>
			</cfloop>
		</select>
	<cfelseif rc.attribute eq "display">
		<cfparam name="session.localeHasDayParts" default="true">

		<cfoutput>
		<div class="mura-control-group">
			<select name="display" id="mura-display" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
				<option value="1"  <cfif content.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
				<option value="0"  <cfif content.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
				<option value="2"  <cfif content.getdisplay() EQ 2> selected</CFIF>>
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perschedule')#
				</option>
			</select>
		</div>
		<div id="editDates" <cfif content.getdisplay() NEQ 2>style="display: none;"</cfif>>
			<cfset displayInterval=content.getDisplayInterval().getAllValues()>
			<cfset rc.ptype=content.getParent().getType()>
			<cfif rc.ptype neq 'Calendar'>
				<cfset displayInterval.repeats=1>
				<cfset displayInterval.allday=0>
			</cfif>
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.schedule')#</label>
				<cf_datetimeselector name="displayStart" datetime="#content.getDisplayStart(timezone=displayInterval.timezone)#">
				<cfif rc.ptype eq 'Calendar'>
				<label id="displayIntervalToLabel" class="time">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.to')#</label>
				<cf_datetimeselector name="displayStop" datetime="#content.getDisplayStop(timezone=displayInterval.timezone)#" defaulthour="23" defaultminute="59">
				</cfif>
			</div>
			<cfif len(rc.$.globalConfig('tzRegex'))>
			<div id="mura-tz-container" class="mura-control-group" style="display:none">
				<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.timezone')#</label>
				<cfset tz=CreateObject("java", "java.util.TimeZone")>
				<cfset defaultTZ=tz.getDefault().getID()>
				<cfset timezones=tz.getAvailableIDs()>
				<cfset timezones=listToArray(arrayToList(timezones))>
				<cfset arraySort(timezones,'text')>
				<select name="displayIntervalTZ" id="displayIntervalTZ" class="mura-repeat-option">
					<option value="#defaultTZ#"<cfif defaultTZ eq displayInterval.timezone> selected </cfif>>
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.default')# (#defaultTZ#)
					</option>
					<cfloop array="#timezones#" index="i">
						<cfif i neq defaultTZ and (len(rc.$.globalConfig('tzRegex')) and refind(rc.$.globalConfig('tzRegex'),i) or not len(rc.$.globalConfig('tzRegex')))>
							<option value="#i#"<cfif i eq displayInterval.timezone> selected </cfif>>#i#</option>
						</cfif>
					</cfloop>
				</select>
			</div>
			<cfelse>
				<cfset tz=CreateObject("java", "java.util.TimeZone")>
				<cfset defaultTZ=tz.getDefault().getID()>
				<input type="hidden" name="displayIntervalTZ" id="displayIntervalTZ" value="#defaultTZ#">
			</cfif>
			<input type="hidden" name="displayInterval" id="displayInterval" value="#esapiEncode('html_attr',content.getDisplayInterval(serialize=true))#">
			<input name="convertDisplayTimeZone" type="hidden" value="true">


			<cfif rc.ptype eq 'Calendar'>
				<div class="mura-control-group">
					<label class="checkbox" for="displayIntervalAllDay">
						<input type="checkbox" id="displayIntervalAllDay" name="displayIntervalllDay" value="1" <cfif displayInterval.allday> checked</cfif>/>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.allday')#
					</label>
					<label for="displayIntervalRepeats" class="checkbox">
						<input type="checkbox" class="mura-repeat-option" id="displayIntervalRepeats" value="1" name="displayIntervalRepeats"<cfif displayInterval.repeats> checked</cfif>>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.repeats')#
					</label>
				</div>
			<cfelse>
				<input type="hidden" id="displayIntervalAllDay" name="displayIntervalllDay" value="0"/>
				<input type="hidden" class="mura-repeat-option" id="displayIntervalRepeats" value="1" name="displayIntervalRepeats">
			</cfif>

			<div class="mura-repeat-options mura-control-group" style="display:none">
				<div class="mura-control-inline">
					<select id="displayIntervalType" name="displayIntervalType" class="mura-repeat-option">
						<cfloop list="daily,weekly,bi-weekly,monthly,weekdays,weekends,week1,week2,week3,week4,weeklast,yearly" index="i">
						<option value="#i#"<cfif displayInterval.type eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
						</cfloop>
					</select>
					<label class="time-repeat">
					&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.every')#</label>
					<input type="text" id="displayIntervalEvery" name="displayIntervalEvery" value="#esapiEncode('html_attr',displayInterval.every)#" class="mura-repeat-option">

					<label class="time-repeat">
					<span class="mura-interval-every-label" id="mura-interval-every-label-weeks" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.weeks')#</span>
					<span class="mura-interval-every-label" id="mura-interval-every-label-months" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.months')#</span>
					<span class="mura-interval-every-label" id="mura-interval-every-label-years" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.years')#</span>
					<span class="mura-interval-every-label" id="mura-interval-every-label-days" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.days')#</span>
					<span class="mura-interval-every-label" id="mura-interval-every-label-biweeks" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.bi-weeks')#</span>
				</label>
				</div>
			</div><!-- /mura-repeat-options -->

			<!--- days of week --->
			<cfset daysofweekshortlabels=application.rbFactory.getKeyValue(session.rb,'calendar.weekdayAbrev')>
			<div class="mura-daysofweek mura-control-group" style="display:none">
				<label class="checkbox inline">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.ondow')#: </label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow1" name="displayIntervalDays" type="checkbox" value="1"<cfif listFind(displayInterval.daysofweek,1)> checked</cfif>/> #listGetAt(daysofweekshortlabels,1)#</label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow2" name="displayIntervalDays" type="checkbox" value="2"<cfif listFind(displayInterval.daysofweek,2)> checked</cfif>/> #listGetAt(daysofweekshortlabels,2)#</label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow3" name="displayIntervalDays" type="checkbox" value="3"<cfif listFind(displayInterval.daysofweek,3)> checked</cfif>/> #listGetAt(daysofweekshortlabels,3)#</label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow4" name="displayIntervalDays" type="checkbox" value="4"<cfif listFind(displayInterval.daysofweek,4)> checked</cfif>/> #listGetAt(daysofweekshortlabels,4)#</label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow5" name="displayIntervalDays" type="checkbox" value="5"<cfif listFind(displayInterval.daysofweek,5)> checked</cfif>/> #listGetAt(daysofweekshortlabels,5)#</label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow6" name="displayIntervalDays" type="checkbox" value="6"<cfif listFind(displayInterval.daysofweek,6)> checked</cfif>/> #listGetAt(daysofweekshortlabels,6)#</label>
					<label class="checkbox inline"><input class="mura-repeat-option" id="dow7" name="displayIntervalDays" type="checkbox" value="7"<cfif listFind(displayInterval.daysofweek,7)> checked</cfif>/> #listGetAt(daysofweekshortlabels,7)#</label>
			</div>
			<!--- /end days of week --->

			<div class="mura-repeat-options mura-control-group" style="display:none">
				<label class="time-repeat">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.ends')#: </label>
				<select id="displayIntervalEnd" name="displayIntervalEnd" class="mura-repeat-option time">
					<option value="never" <cfif displayInterval.end eq 'never'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.never')#</option>
					<option value="after"<cfif displayInterval.end eq 'after'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.after')#</option>
					<option value="on"<cfif displayInterval.end eq 'on'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.on')#</option>
				</select>
					<span class="mura-interval-end" id="mura-interval-end-after" style="display:none">
						<input type="text" id="displayIntervalEndAfter" name="displayIntervalEndAfter" value="#esapiEncode('html_attr',displayInterval.endafter)#" class="mura-repeat-option" size="3">
				<label class="time-repeat">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.occurrences')#
				</label>
					</span>
					<span class="mura-interval-end" id="mura-interval-end-on" style="display:none">
						<input type="text" id="displayIntervalEndOn" name="displayIntervalEndOn" class="mura-repeat-option datepicker mura-datepickerdisplayIntervalEndOn" value="#LSDateFormat(displayInterval.endon,session.dateKeyFormat)#" maxlength="12"/>
						<cfif rc.ptype neq 'Calendar'>
							<cf_datetimeselector name="displayStop" datetime="#content.getDisplayStop(timezone=displayInterval.timezone)#" defaulthour="23" defaultminute="59">
						</cfif>
					</span>
			</div>
		</div>
	<script>
	$(function(){
		<cfif rc.ptype eq 'Calendar'>
			var isCalendar=true;
		<cfelse>
			var isCalendar=false;
		</cfif>

		function pushDisplayStopOut(){
			$('##mura-datepicker-displayStop').val($('##mura-datepicker-displayStart').val());
			$('##mura-datepicker-displayStop').trigger('change');

			var stopMinute = ($('##mura-displayStopMinute').length) ? $('##mura-displayStopMinute').val() : 0;
			var stopHour=($('##mura-displayStopHour').length) ? $('##mura-displayStopHour').val() : 0;

			if($('##mura-displayStopDayPart').length){
				if($('##mura-displayStopDayPart').val().toLowerCase() == 'pm'){
					stopHour=parseInt(stopHour) + 12;
					if(stopHour==24){
						stopHour=12;
					}
				} else if (parseInt(stopHour) ==12) {
					stopHour=0;
				}
			}

			if(stopHour.length==1){
				stopHour='0' + stopHour;
			}

			if(stopMinute.length==1){
				stopMinute='0' + stopMinute;
			}

			$('##mura-displayStop').val("{ts '2100-01-01 " + stopHour + ":" + stopMinute + ":00'}");
			$('##displayIntervalEndOn').val('');
		}

		function updateDisplayInterval(){
			if($('##displayIntervalEnd').val()=='on'){
				$('##mura-datepicker-displayStop').val($('##displayIntervalEndOn').val());
				$('##mura-datepicker-displayStop').trigger('change');
			} else {
				pushDisplayStopOut();
			}

			var options={
				repeats: (!isCalendar || isCalendar && $('##displayIntervalRepeats').is(':checked')) ? 1 : 0,
				detectconflicts: $('##displayIntervalDetectConflicts').is(':checked') ? 1 : 0,
				detectspan: $('##mura-detectspan').val(),
				allday:  (isCalendar && $('##displayIntervalAllDay').is(':checked')) ? 1 : 0,
				timezone: $('##displayIntervalTZ').val(),
				every: $('##displayIntervalEvery').val() || 0,
				type: $('##displayIntervalType').val(),
				end: $('##displayIntervalEnd').val(),
				endon: $('##displayIntervalEndOn').val(),
				endafter: $('##displayIntervalEndAfter').val(),
				daysofweek: getDaysOfWeek()
			};

			if(!options.repeats && options.allday){
				$('##mura-datepicker-displayStop').val($('##mura-datepicker-displayStart').val());
				$('##mura-datepicker-displayStop').trigger('change');
				options.endon=$('##mura-datepicker-displayStop').val();
			}

			$('##displayInterval').val(JSON.stringify(options));
		}

		function getDaysOfWeek(){
			var daysofweek=[];

			$('input[name="displayIntervalDays"]').each(function(){
				var day=$(this);
				if(day.is(':checked')){
					daysofweek.push(day.val());
				}
			});

			return daysofweek.join();
		}

		function setDaysOfWeekDefault(){

			if(!$('input[name="displayIntervalDays"]:checked').length){
				var dateString=$('input[name="displayStart"]').val();

				if(dateString){
					var dateObj=new Date(dateString.substring(5,24));

					if(dateObj.getDay() > -1){
						$('input[name="displayIntervalDays"]:eq('+ dateObj.getDay() + ')').prop('checked',true);
					}
				}
			}
		}

		function setEndOption(){

			if(!isCalendar || isCalendar && $('##displayIntervalRepeats').is(':checked')){
				var type=$('##displayIntervalEnd').val();

				$('.mura-interval-end').hide();
				//alert(type)
				if(type=='after'){
					$('##mura-interval-end-after').show();
					pushDisplayStopOut();
				} else if(type=='on'){
					$('##mura-interval-end-on').show();

					var start=$('##mura-datepicker-displayStart');
					var stop=$('##mura-datepicker-displayStop');
					var endon=$('##displayIntervalEndOn');

					if(!stop.val() && endon.val()){
						stop.val(endon.val()).trigger('change');
					}

					if(!endon.val()){
						endon.val(stop.val())
					}

					if(!endon.val()){
						endon.val(start.val());
						stop.val(start.val()).trigger('change');
					}
				} else if(type=='never'){
					pushDisplayStopOut();
				}
			} else {
				var start=$('##mura-datepicker-displayStart');
				var stop=$('##mura-datepicker-displayStop');
				stop.val(start.val()).trigger('change');
				$('##displayIntervalEnd').val('on');
				$('##displayIntervalEndOn').val(start.val());
			}

			updateDisplayInterval();

		}

		function setIntervalUnitLabel(){
			var type=$('##displayIntervalType').val();
			//alert(type)
			$('.mura-interval-every-label').hide();

			switch(type){
				case 'weekly':
				case 'weekends':
				case 'weekdays':
				$('##mura-interval-every-label-weeks').show();
				break;
				case 'bi-weekly':
				$('##mura-interval-every-label-biweeks').show();
				break;
				case 'yearly':
				$('##mura-interval-every-label-years').show();
				break;
				case 'daily':
				$('##mura-interval-every-label-days').show();
				break;
				default:
				$('##mura-interval-every-label-months').show();
			}
		}

		function toggleRepeatOptions(){
			var input=$('##displayIntervalType');

			if(input.val().toLowerCase().search('week') > -1 && input.val() != 'weekends' && input.val() != 'weekdays'){
				$('.mura-daysofweek').show();
				setDaysOfWeekDefault();

			} else {
				$('.mura-daysofweek').hide();
			}

			setIntervalUnitLabel();
		}

		function toggleAllDayOptions(){
			if(isCalendar && $('##displayIntervalAllDay').is(':checked')){
				$('##mura-displayStartHour').hide();
				$('##mura-displayStartMinute').hide();
				$('##mura-displayStartDayPart').hide();
				$('##mura-displayStopHour').hide();
				$('##mura-displayStopMinute').hide();
				$('##mura-displayStopDayPart').hide();
				$('##mura-tz-container').hide();
				$('##displayIntervalToLabel').hide();

				$('##displayIntervalTZ').val('#tz.getDefault().getID()#');

				<cfif session.localeHasDayParts>
					$('##mura-displayStartHour').val('12');
					$('##mura-displayStartMinute').val('0');
					$('##mura-displayStartDayPart').val('AM');
					$('##mura-displayStopHour').val('11');
					$('##mura-displayStopMinute').val('59');
					$('##mura-displayStopDayPart').val('PM');
				<cfelse>
					$('##mura-displayStartHour').val('0');
					$('##mura-displayStartMinute').val('0');
					$('##mura-displayStopHour').val('23');
					$('##mura-displayStopMinute').val('59');
				</cfif>

			} else if(isCalendar){
				$('##mura-tz-container').show();
				$('##mura-displayStartHour').show();
				$('##mura-displayStartMinute').show();
				$('##mura-displayStartDayPart').show();
				$('##mura-displayStopHour').show();
				$('##mura-displayStopMinute').show();
				$('##mura-displayStopDayPart').show();
				$('##displayIntervalToLabel').show();
				$('##mura-tz-container').show();
			} else {
				$('##mura-tz-container').show();
				$('##mura-displayStartHour').show();
				$('##mura-displayStartMinute').show();
				$('##mura-displayStartDayPart').show();
				$('##mura-displayStopHour').hide();
				$('##mura-displayStopMinute').hide();
				$('##mura-displayStopDayPart').hide();
				$('##displayIntervalToLabel').show();
				$('##mura-tz-container').show();
			}

			updateDisplayInterval();
		}

		function toggleRepeatOptionsContainer(){
			var input=$('input[name="displayIntervalEvery"]');

			if(!isCalendar || isCalendar && $('##displayIntervalRepeats').is(':checked')){
				$('.mura-repeat-options').show();
				setDaysOfWeekDefault();

			} else {
				$('.mura-repeat-options').hide();
				//$('##mura-datepicker-displayStop').show();
				$('##displayIntervalType').val('daily');

				if($('##displayIntervalEndOn').val()){
					$('##displayIntervalEnd').val('on');
				} else {
					$('##displayIntervalEnd').val('never');
				}

				toggleRepeatOptions();
			}
			setEndOption();
			setIntervalUnitLabel();
		}

		function toggleDetectConflicts(){
			if($('##displayIntervalDetectConflicts').is(':checked')){
				$('##mura-detectspan-container').show();
			} else {
				$('##mura-detectspan-container').hide();
			}

		}

		$('##mura-datepicker-displayStop').hide();
		//$('##displayIntervalToLabel').hide();

		$('.mura-repeat-option').on('change',updateDisplayInterval);
		$('##displayIntervalRepeats').click(toggleRepeatOptionsContainer);
		$('##displayIntervalAllDay').click(toggleAllDayOptions);
		$('##displayIntervalDetectConflicts').click(toggleDetectConflicts);
		$('##displayIntervalType').on('change',toggleRepeatOptions);
		$('##displayIntervalEnd').on('change',setEndOption);
		$('##mura-datepicker-displayStart').change(setEndOption);

		var repeats=$('input[name="displayIntervalEvery"]').is(':checked');

		if(repeats){
			$('##displayIntervalRepeats').attr('checked',true);
		}

		toggleRepeatOptionsContainer();
		toggleRepeatOptions();
		toggleAllDayOptions();
		setEndOption();
		toggleDetectConflicts();

		//This is only in quick edit
		$('##mura-display').change(function(){
			if($(this).val() == 2){
				$('.mura-quickEdit').addClass("large");
			} else {
				$('.mura-quickEdit').removeClass("large")
			}
		}).trigger('change');
	})
	</script>
	</cfoutput>
	</cfif>
	<div class="form-actions">
		<button class="btn mura-primary" onclick="siteManager.saveQuickEdit(this);">Submit</button>
	</div>
	</cfoutput>
<cfelse>
	<cfoutput>
	<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.hasdraftstitle')# </h1>
	<span class="cancel" onclick="siteManager.closeQuickEdit();" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.cancel')#"><i class="mi-close"></i></span>
		<p id="hasDraftsMessage">#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.hasdraftsmessage')#</p>
	</cfoutput>
</cfif>
