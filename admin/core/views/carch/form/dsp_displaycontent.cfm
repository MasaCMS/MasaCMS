
		<cfset bydate=iif(rc.contentBean.getdisplay() EQ 2 or (rc.ptype eq 'Calendar' and rc.contentBean.getIsNew()),de('true'),de('false'))>
		<cfoutput>
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
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
					</div>		
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<cf_datetimeselector name="displayStop" datetime="#rc.contentBean.getDisplayStop()#" defaulthour="23" defaultminute="59">
					</div>
					<cfif rc.$.globalConfig().getValue(property='advancedScheduling',defaultValue=false)>
						<cfset displayInterval=rc.contentBean.getDisplayInterval(deserialize=true)>
					
						<input type="hidden" name="displayInterval" id="displayInterval" value="#esapiEncode('html_attr',rc.contentBean.getDisplayInterval())#">

						<div class="controls">
							<label for="displayIntervalAllDay" class="control-label">
								<input type="checkbox" id="displayIntervalAllDay" name="displayIntervalllDay" value="1"/>&nbsp;&nbsp;All Day
							</label>
							<label for="displayIntervalRepeats" class="control-label">
								<input type="checkbox" class="mura-repeat-option" id="displayIntervalRepeats" value="1" name="displayIntervalRepeats"<cfif displayInterval.repeats> checked</cfif>>&nbsp;&nbsp;Repeats
							</label>
							<div class="mura-repeat-options" style="display:none">
								<div class="controls">
									<select id="displayIntervalType" name="displayIntervalType" class="span4 mura-repeat-option">
										<cfloop list="daily,weekly,bi-weekly,monthly,weekdays,weekends,week1,week2,week3,week4,weeklast,yearly" index="i">
										<option value="#i#"<cfif displayInterval.type eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
										</cfloop>
									</select>
									&nbsp;every&nbsp;
									<input type="text" id="displayIntervalEvery" name="displayIntervalEvery" value="#esapiEncode('html_attr',displayInterval.every)#" class="span1 mura-repeat-option" size="3">
								
									&nbsp;
									<span class="mura-interval-every-label" id="mura-interval-every-label-weeks" style="display:none">weeks</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-months" style="display:none">months</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-years" style="display:none">years</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-days" style="display:none">days</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-biweeks" style="display:none">bi-weeks</span>
								</div>
								<div class="controls mura-daysofweek" style="display:none">
									on

									<input class="mura-repeat-option" id="dow1" name="displayIntervalDays" type="checkbox" value="1"<cfif listFind(displayInterval.daysofweek,1)> checked</cfif>/> S
									<input class="mura-repeat-option" id="dow2" name="displayIntervalDays" type="checkbox" value="2"<cfif listFind(displayInterval.daysofweek,2)> checked</cfif>/> M
									<input class="mura-repeat-option" id="dow3" name="displayIntervalDays" type="checkbox" value="3"<cfif listFind(displayInterval.daysofweek,3)> checked</cfif>/> T
									<input class="mura-repeat-option" id="dow4" name="displayIntervalDays" type="checkbox" value="4"<cfif listFind(displayInterval.daysofweek,4)> checked</cfif>/> W
									<input class="mura-repeat-option" id="dow5" name="displayIntervalDays" type="checkbox" value="5"<cfif listFind(displayInterval.daysofweek,5)> checked</cfif>/> T
									<input class="mura-repeat-option" id="dow6" name="displayIntervalDays" type="checkbox" value="6"<cfif listFind(displayInterval.daysofweek,6)> checked</cfif>/> F
									<input class="mura-repeat-option" id="dow7" name="displayIntervalDays" type="checkbox" value="7"<cfif listFind(displayInterval.daysofweek,7)> checked</cfif>/> S
								
								</div>
								<div class="controls">
									ends 
									<select id="displayIntervalEnd" name="displayIntervalEnd" class="span2 mura-repeat-option">
										<option value="never" <cfif displayInterval.end eq 'never'> selected</cfif>>Never</option>
										<option value="after"<cfif displayInterval.end eq 'after'> selected</cfif>>After</option>
										<option value="on"<cfif displayInterval.end eq 'on'> selected</cfif>>On</option>
									</select>
									<span class="mura-interval-end" id="mura-interval-end-after" style="display:none">
										<input type="text" id="displayIntervalEndAfter" name="displayIntervalEndAfter" value="#esapiEncode('html_attr',displayInterval.endafter)#" class="span1 mura-repeat-option" size="3">
										occurences
									</span>
									<span class="mura-interval-end" id="mura-interval-end-on" style="display:none">
										<input type="text" id="displayIntervalEndOn" name="displayIntervalEndOn" class="mura-repeat-option datepicker span3 mura-datepickerdisplayIntervalEndOn" value="#LSDateFormat(displayInterval.endon,session.dateKeyFormat)#" maxlength="12"/>
									</span>
								</div>
							</div>
						</div>
						<script>
							$(function(){

								function updateDisplayInterval(){
									$('##displayInterval').val(
										JSON.stringify(
											{
												repeats: $('##displayIntervalRepeats').val() || 0,
												every: $('##displayIntervalEvery').val() || 0,
												type: $('##displayIntervalType').val(),
												end: $('##displayIntervalEnd').val(),
												endon: $('##displayIntervalEndOn').val(),
												endafter: $('##displayIntervalEndAfter').val(),
												daysofweek: getDaysOfWeek()
											}
										)
									);
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
										$('##mura-datepicker-displayStop').val('');
									} else if(type=='on'){
										$('##mura-interval-end-on').show();

										var start=$('##mura-datepicker-displayStart');
										var stop=$('##mura-datepicker-displayStop');
										var endon=$('##displayIntervalEndOn');

										if(!stop.val() && endon.val()){
											stop.val(endon.val());
										}

										if(!endon.val()){
											endon.val(stop.val())
										}

										if(!endon.val()){
											endon.val(start.val());
											stop.val(start.val());
										}
										
										
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
									
									if(input.val().toLowerCase().search('week') > -1 && input.val() != 'WeekEnds' && input.val() != 'WeekDays'){
										$('.mura-daysofweek').show();
										setDaysOfWeekDefault();
									
									} else {
										$('.mura-daysofweek').hide();
									}

									setIntervalUnitLabel();
								}

								function toggleRepeatOptionsContainer(){
									var input=$('input[name="displayIntervalEvery"]');

									if($('##displayIntervalRepeats').is(':checked')){
										$('.mura-repeat-options').show();
										setDaysOfWeekDefault();

										/*
										if(!isNaN(input.val())){
											input.val(0);
										}
										*/
										
									} else {
										$('.mura-repeat-options').hide();
										$('##displayIntervalType').val('daily');
										
										if($('##displayIntervalEndOn').val()){
											$('##displayIntervalEnd').val('on');
										} else {
											$('##displayIntervalEnd').val('never');
										}
										
										setEndOption()
										//input.val(0);
									}

									setIntervalUnitLabel();
								}

								$('.mura-repeat-option').on('change',updateDisplayInterval);
								$('##displayIntervalRepeats').click(toggleRepeatOptionsContainer);
								$('##displayIntervalType').on('change',toggleRepeatOptions);
								$('##displayIntervalEnd').on('change',setEndOption);

								$('##displayIntervalEndOn')
									.on('change',
									function(){
										$('##mura-datepicker-displayStop').val($(this).val());
									}
								);

								var repeats=$('input[name="displayIntervalEvery"]').val();
								
								if(!isNaN(repeats) && parseInt(repeats)){
									$('##displayIntervalRepeats').attr('checked',true);
								}

								toggleRepeatOptionsContainer();
								toggleRepeatOptions();
								setEndOption();
							})


						</script>
					<cfelse>
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
					</cfif>
				</div>
			</div>
			</cfoutput>