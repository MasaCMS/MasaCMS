<cfset rc.ptype=rc.contentBean.getParent().getType()>

<cfif rc.contentBean.getIsNew() and rc.ptype eq 'Calendar'>
	<cfset rc.contentBean.setDisplay(2)>
</cfif>

<cfparam name="session.localeHasDayParts" default="true">

<cfoutput>
<cfif rc.$.globalConfig().getValue(property='advancedScheduling',defaultValue=false)>
	<div class="control-group">
	  	<label class="control-label">
	  		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
	  			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#
	  		 <i class="icon-question-sign"></i></a>
	  	</label>
	  	<div class="controls">
	  		<select name="display" id="mura-display" class="span3" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
				<option value="1"  <cfif rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
				<option value="0"  <cfif rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
				<option value="2"  <cfif rc.contentBean.getdisplay() EQ 2> selected</CFIF>>
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perschedule')#
				</option>
			</select>
		</div>
		<div id="editDates" <cfif rc.contentBean.getdisplay() NEQ 2>style="display: none;"</cfif>>
			<cfset displayInterval=rc.contentBean.getDisplayInterval(deserialize=true)>
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.schedule')#</label>
			
			<!---
			<cfdump var="#rc.contentBean.getDisplayStart()#">
			<cfdump var="#rc.contentBean.getDisplayStop()#">
			<cfdump var="#rc.contentBean.getDisplayInterval()#">
			--->

			<div class="controls">
				<cf_datetimeselector name="displayStart" datetime="#rc.contentBean.getDisplayStart(timezone=displayInterval.timezone)#"> <span id="displayIntervalToLabel">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.to')#</span>
				<cf_datetimeselector name="displayStop" datetime="#rc.contentBean.getDisplayStop(timezone=displayInterval.timezone)#" defaulthour="23" defaultminute="59"></span>
			</div>
			<cfif len(rc.$.globalConfig('tzRegex'))>
			<div id="mura-tz-container" style="display:none">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.timezone')#</label>
				<div class="controls">
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
			</div>
			<cfelse>
				<cfset tz=CreateObject("java", "java.util.TimeZone")>
				<cfset defaultTZ=tz.getDefault().getID()>
				<input type="hidden" name="displayIntervalTZ" id="displayIntervalTZ" value="#defaultTZ#">
			</cfif>
			<input type="hidden" name="displayInterval" id="displayInterval" value="#esapiEncode('html_attr',rc.contentBean.getDisplayInterval())#">
			<input name="convertDisplayTimeZone" type="hidden" value="true">

			<div class="controls">
				<label for="displayIntervalAllDay" class="control-label">
					<input type="checkbox" id="displayIntervalAllDay" name="displayIntervalllDay" value="1" <cfif displayInterval.allday> checked</cfif>/>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.allday')#
				</label>
				<cfif rc.ptype eq 'Calendar'>
					<label for="displayIntervalDetectConflicts" class="control-label">
						<input type="checkbox" class="mura-repeat-option" id="displayIntervalDetectConflicts" value="1" name="displayIntervalDetectConflicts"<cfif displayInterval.detectconflicts> checked</cfif>>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.detectconflicts')#
					</label>

					<div id="mura-detectspan-container"<cfif displayInterval.detectconflicts> style="display:none;"</cfif>>
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.for')#
						<select id="mura-detectspan">
							<cfloop from="1" to="12" index="m">
								<option value="#m#"<cfif m eq displayInterval.detectspan> selected</cfif>>
								#m#
								</option>
							</cfloop>
						</select> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.months')#
					</div>
				</cfif>
				<label for="displayIntervalRepeats" class="control-label">
					<input type="checkbox" class="mura-repeat-option" id="displayIntervalRepeats" value="1" name="displayIntervalRepeats"<cfif displayInterval.repeats> checked</cfif>>&nbsp;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.repeats')#
				</label>
				<div class="mura-repeat-options" style="display:none">
					<div class="controls">
						<select id="displayIntervalType" name="displayIntervalType" class="span4 mura-repeat-option">
							<cfloop list="daily,weekly,bi-weekly,monthly,weekdays,weekends,week1,week2,week3,week4,weeklast,yearly" index="i">
							<option value="#i#"<cfif displayInterval.type eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
							</cfloop>
						</select>
						&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.every')#&nbsp;
						<input type="text" id="displayIntervalEvery" name="displayIntervalEvery" value="#esapiEncode('html_attr',displayInterval.every)#" class="span1 mura-repeat-option" size="3">
					
						&nbsp;
						<span class="mura-interval-every-label" id="mura-interval-every-label-weeks" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.weeks')#</span>
						<span class="mura-interval-every-label" id="mura-interval-every-label-months" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.months')#</span>
						<span class="mura-interval-every-label" id="mura-interval-every-label-years" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.years')#</span>
						<span class="mura-interval-every-label" id="mura-interval-every-label-days" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.days')#</span>
						<span class="mura-interval-every-label" id="mura-interval-every-label-biweeks" style="display:none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.bi-weeks')#</span>
					</div>
					<div class="controls mura-daysofweek" style="display:none">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.ondow')#
						<cfset daysofweekshortlabels=application.rbFactory.getKeyValue(session.rb,'calendar.weekdayAbrev')>
						<input class="mura-repeat-option" id="dow1" name="displayIntervalDays" type="checkbox" value="1"<cfif listFind(displayInterval.daysofweek,1)> checked</cfif>/> #listGetAt(daysofweekshortlabels,1)#
						<input class="mura-repeat-option" id="dow2" name="displayIntervalDays" type="checkbox" value="2"<cfif listFind(displayInterval.daysofweek,2)> checked</cfif>/> #listGetAt(daysofweekshortlabels,2)#
						<input class="mura-repeat-option" id="dow3" name="displayIntervalDays" type="checkbox" value="3"<cfif listFind(displayInterval.daysofweek,3)> checked</cfif>/> #listGetAt(daysofweekshortlabels,3)#
						<input class="mura-repeat-option" id="dow4" name="displayIntervalDays" type="checkbox" value="4"<cfif listFind(displayInterval.daysofweek,4)> checked</cfif>/> #listGetAt(daysofweekshortlabels,4)#
						<input class="mura-repeat-option" id="dow5" name="displayIntervalDays" type="checkbox" value="5"<cfif listFind(displayInterval.daysofweek,5)> checked</cfif>/> #listGetAt(daysofweekshortlabels,5)#
						<input class="mura-repeat-option" id="dow6" name="displayIntervalDays" type="checkbox" value="6"<cfif listFind(displayInterval.daysofweek,6)> checked</cfif>/> #listGetAt(daysofweekshortlabels,6)#
						<input class="mura-repeat-option" id="dow7" name="displayIntervalDays" type="checkbox" value="7"<cfif listFind(displayInterval.daysofweek,7)> checked</cfif>/> #listGetAt(daysofweekshortlabels,7)#
					</div>
					<div class="controls">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.ends')#
						<select id="displayIntervalEnd" name="displayIntervalEnd" class="span2 mura-repeat-option">
							<option value="never" <cfif displayInterval.end eq 'never'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.never')#</option>
							<option value="after"<cfif displayInterval.end eq 'after'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.after')#</option>
							<option value="on"<cfif displayInterval.end eq 'on'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.on')#</option>
						</select>
						<span class="mura-interval-end" id="mura-interval-end-after" style="display:none">
							<input type="text" id="displayIntervalEndAfter" name="displayIntervalEndAfter" value="#esapiEncode('html_attr',displayInterval.endafter)#" class="span1 mura-repeat-option" size="3">
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayinterval.occurrences')#
						</span>
						<span class="mura-interval-end" id="mura-interval-end-on" style="display:none">
							<input type="text" id="displayIntervalEndOn" name="displayIntervalEndOn" class="mura-repeat-option datepicker span3 mura-datepickerdisplayIntervalEndOn" value="#LSDateFormat(displayInterval.endon,session.dateKeyFormat)#" maxlength="12"/>
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$(function(){
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
			}

			function updateDisplayInterval(){
				
				if($('##displayIntervalEnd').val()=='on'){
					$('##mura-datepicker-displayStop').val($('##displayIntervalEndOn').val());
					$('##mura-datepicker-displayStop').trigger('change');
				} else {
					pushDisplayStopOut();
				}

				var options={
					repeats: $('##displayIntervalRepeats').is(':checked') ? 1 : 0,
					detectconflicts: $('##displayIntervalDetectConflicts').is(':checked') ? 1 : 0,
					detectspan: $('##mura-detectspan').val(),
					allday: $('##displayIntervalAllDay').is(':checked') ? 1 : 0,
					timezone: $('##displayIntervalTZ').val(),
					every: $('##displayIntervalEvery').val() || 0,
					type: $('##displayIntervalType').val(),
					end: $('##displayIntervalEnd').val(),
					endon: $('##displayIntervalEndOn').val(),
					endafter: $('##displayIntervalEndAfter').val(),
					daysofweek: getDaysOfWeek()
				};

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
				if($('##displayIntervalAllDay').is(':checked')){
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
				
				} else {
					$('##mura-tz-container').show();
					$('##mura-displayStartHour').show();
					$('##mura-displayStartMinute').show();
					$('##mura-displayStartDayPart').show();
					$('##mura-displayStopHour').show();
					$('##mura-displayStopMinute').show();
					$('##mura-displayStopDayPart').show();
					$('##displayIntervalToLabel').show();
				}

				updateDisplayInterval();
			}

			function toggleRepeatOptionsContainer(){
				var input=$('input[name="displayIntervalEvery"]');

				if($('##displayIntervalRepeats').is(':checked')){
					$('.mura-repeat-options').show();
					setDaysOfWeekDefault();
					$('##mura-datepicker-displayStop').hide();
					
					$('##mura-datepicker-displayStart')
						.removeClass('span2')
						.addClass('span3');
					$('##mura-datepicker-displayStop')
						.removeClass('span2')
						.addClass('span3');
					
				} else {
					$('.mura-repeat-options').hide();
					$('##mura-datepicker-displayStop').show();
					$('##displayIntervalType').val('daily');
					
					$('##mura-datepicker-displayStart')
						.removeClass('span3')
						.addClass('span2');
					$('##mura-datepicker-displayStop')
						.removeClass('span3')
						.addClass('span2');

					if($('##displayIntervalEndOn').val()){
						$('##displayIntervalEnd').val('on');
					} else {
						$('##displayIntervalEnd').val('never');
					}
					
					setEndOption();
					toggleRepeatOptions();
					//input.val(0);
				}

				setIntervalUnitLabel();
			}

			function toggleDetectConflicts(){
				if($('##displayIntervalDetectConflicts').is(':checked')){
					$('##mura-detectspan-container').show();
				} else {
					$('##mura-detectspan-container').hide();
				}
				
			}
			
			$('.mura-repeat-option').on('change',updateDisplayInterval);
			$('##displayIntervalRepeats').click(toggleRepeatOptionsContainer);
			$('##displayIntervalAllDay').click(toggleAllDayOptions);
			$('##displayIntervalDetectConflicts').click(toggleDetectConflicts);
			$('##displayIntervalType').on('change',toggleRepeatOptions);
			$('##displayIntervalEnd').on('change',setEndOption);

			var repeats=$('input[name="displayIntervalEvery"]').val();
			
			if(!isNaN(repeats) && parseInt(repeats)){
				$('##displayIntervalRepeats').attr('checked',true);
			}

			toggleRepeatOptionsContainer();
			toggleRepeatOptions();
			toggleAllDayOptions();
			setEndOption();
			toggleDetectConflicts();
		})


	</script>
<cfelse>
	<div class="control-group">
	  	<label class="control-label">
	  		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
	  			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#
	  		 <i class="icon-question-sign"></i></a>
	  	</label>
	  	<div class="controls">
	  		<select name="display" class="span3" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
				<option value="1"  <cfif rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
				<option value="0"  <cfif rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
				<option value="2"  <cfif rc.contentBean.getdisplay() EQ 2> selected</CFIF>>
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#
				</option>
			</select>
		</div>
		<div id="editDates" <cfif rc.contentBean.getdisplay() NEQ 2>style="display: none;"</cfif>>
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</label>
			<div class="controls">
				<cf_datetimeselector name="displayStart" datetime="#rc.contentBean.getDisplayStart()#">
			</div>		
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
			</label>
			<div class="controls">
				<cf_datetimeselector name="displayStop" datetime="#rc.contentBean.getDisplayStop()#" defaulthour="23" defaultminute="59">
			</div>
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval')#
			</label>
			<div class="controls">
				<select name="displayInterval" class="span2">
					<cfloop list="Daily,Weekly,Bi-Weekly,Monthly,WeekDays,WeekEnds,Week1,Week2,Week3,Week4,WeekLast,Yearly" index="i">
					<option value="#i#"<cfif rc.contentBean.getDisplayInterval() eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
					</cfloop>
				</select>
			</div>
		</div>
	</div>
</cfif>
</cfoutput>