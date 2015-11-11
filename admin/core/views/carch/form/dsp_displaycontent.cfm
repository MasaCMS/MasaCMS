
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
						<div class="controls">
							<label for="displayIntervalAllDay" class="control-label">
								<input type="checkbox" id="displayIntervalAllDay" name="displayIntervalllDay" value="1"/>&nbsp;&nbsp;All Day
							</label>
							<label for="displayIntervalRepeats" class="control-label">
								<input type="checkbox" id="displayIntervalRepeats" name="displayIntervalRepeats">&nbsp;&nbsp;Repeats
							</label>
							<div class="mura-repeat-options" style="display:none">
								<div class="controls">
									<select id="displayIntervalType" name="displayIntervalType" class="span4">
										<cfloop list="Daily,Weekly,Bi-Weekly,Monthly,WeekDays,WeekEnds,Week1,Week2,Week3,Week4,WeekLast,Yearly" index="i">
										<option value="#i#"<cfif rc.contentBean.getDisplayInterval() eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayInterval.#i#')#</option>
										</cfloop>
									</select>
									&nbsp;every&nbsp;
									<input type="text" name="displayIntervalEvery" value="0" class="span1" size="3">
								
									&nbsp;
									<span class="mura-interval-every-label" id="mura-interval-every-label-weeks" style="display:none">weeks</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-months" style="display:none">months</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-years" style="display:none">years</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-days" style="display:none">days</span>
									<span class="mura-interval-every-label" id="mura-interval-every-label-biweeks" style="display:none">bi-weeks</span>
								</div>
								<div class="controls mura-daysofweek" style="display:none">
									on

									<input id="dow1" name="displayIntervalDays" type="checkbox" value="1"/> S
									<input id="dow2" name="displayIntervalDays" type="checkbox" value="2"/> M
									<input id="dow3" name="displayIntervalDays" type="checkbox" value="3"/> T
									<input id="dow4" name="displayIntervalDays" type="checkbox" value="4"/> W
									<input id="dow5" name="displayIntervalDays" type="checkbox" value="5"/> T
									<input id="dow6" name="displayIntervalDays" type="checkbox" value="6"/> F
									<input id="dow7" name="displayIntervalDays" type="checkbox" value="7"/> S
								
								</div>
								<div class="controls">
									ends 
									<select id="displayIntervalEndType" name="displayIntervalEndType" class="span2">
										<option value="never">Never</option>
										<option value="occurences">After</option>
										<option value="on">On</option>
									</select>
									<span class="mura-interval-end" id="mura-interval-end-occurences" style="display:none">
										<input type="text" name="displayIntervalEndOccurrences" value="0" class="span1" size="3">
										occurences
									</span>
									<span class="mura-interval-end" id="mura-interval-end-on" style="display:none">
										<input type="text" id="displayIntervalEndOn" name="displayIntervalEndOn" class="datepicker span3 mura-datepickerdisplayIntervalEndOn" value="#LSDateFormat('',session.dateKeyFormat)#" maxlength="12"/>
									</span>
								</div>
							</div>
						</div>
						<script>
							$(function(){
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
									var type=$('##displayIntervalEndType').val();

									$('.mura-interval-end').hide();
									//alert(type)
									if(type=='occurences'){
										$('##mura-interval-end-occurences').show();
									} else if(type=='on'){
										$('##mura-interval-end-on').show();

										/*
										if(!$('##displayIntervalEndOn').val()){
											$('##displayIntervalEndOn').val($('##mura-displayStop').val())
										}

										if(!$('##displayIntervalEndOn').val()){
											$('##displayIntervalEndOn').val($('##mura-displayStart').val())
										}
										*/
									}

								}
								function setIntervalUnitLabel(){
									var type=$('##displayIntervalType').val();
									//alert(type)
									$('.mura-interval-every-label').hide();

									switch(type){
										case 'Weekly':
										case 'WeekEnds':
										case 'WeekDays':
										$('##mura-interval-every-label-weeks').show();
										break;
										case 'Bi-Weekly':
										$('##mura-interval-every-label-biweeks').show();
										break;
										case 'Yearly':
										$('##mura-interval-every-label-years').show();
										break;
										case 'Daily':
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

										if(!isNaN(input.val()) && parseInt(input.val())==0){
											input.val(1);
										}
										
									} else {
										$('.mura-repeat-options').hide();
										input.val(0);
									}

									setIntervalUnitLabel();
								}

								$('##displayIntervalRepeats').click(toggleRepeatOptionsContainer);
								$('##displayIntervalType').on('change',toggleRepeatOptions);
								$('##displayIntervalEndType').on('change',setEndOption);
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