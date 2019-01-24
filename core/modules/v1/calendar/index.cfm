<!---
	This file is part of Mura CMS.

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
	the preparation of a derivative work based on Mura CMS. Thus, the terms
	and conditions of the GNU General Public License version 2 ("GPL") cover
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant
	you permission to combine Mura CMS with programs or libraries that are
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS
	grant you permission to combine Mura CMS with independent software modules
	(plugins, themes and bundles), and to distribute these plugins, themes and
	bundles without Mura CMS under the license of your choice, provided that
	you follow these specific guidelines:

	Your custom code

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

	/admin/
	/core/
	/Application.cfc
	/index.cfm

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that
	meets the above guidelines as a combined work under the terms of GPL for
	Mura CMS, provided that you include the source code of that other code when
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not
	obligated to grant this special exception for your modified version; it is
	your choice whether to do so, or to make such modified version available
	under the GNU General Public License version 2 without this exception.  You
	may, if you choose, apply this exception to your own modified versions of
	Mura CMS.
--->
<cfoutput>
	<cfsilent>
		<cfparam name="objectParams.items" default="[]">
		<cfparam name="objectParams.viewoptions" default="agendaDay,agendaWeek,month">
		<cfparam name="objectParams.viewdefault" default="month">
		<cfparam name="objectParams.displaylist" default="#$.content('displaylist')#">
		<cfparam name="objectParams.format" default="calendar">
		<cfparam name="objectParams.nextn" default="#$.content('next')#">
		<cfparam name="objectParams.categoryid" default="">
		<cfparam name="objectParams.startrow" default="1">
		<cfparam name="objectParams.tag" default="">
		<cfparam name="objectParams.layout" default="default">
		<cfparam name="objectParams.dateparams" default="false">

		<cfif not $.getContentRenderer().useLayoutManager()>
			<cfset objectparams.displaylist=$.content('displayList')>
			<cfset objectparams.sortBy=$.content('sortBy')>
			<cfset objectparams.sortDirectory=$.content('sortDirectory')>
			<cfset objectparams.nextn=$.content('nextn')>
			<cfset objectparams.layout='default'>
			<cfset objectParams.format='calendar'>
		</cfif>

		<cfif isJson(objectParams.items)>
			<cfset objectParams.items=deserializeJSON(objectParams.items)>
		<cfelseif isSimpleValue(objectParams.items)>
			<cfset objectParams.items=listToArray(objectParams.items)>
		</cfif>
		<cfif not isArray(objectParams.items)>
			<cfset objectParam.items=[]>
		</cfif>
		<cfif not arrayFind(objectParams.items,variables.$.content('contentid'))>
			<cfset arrayPrepend(objectParams.items,variables.$.content('contentid'))>
		</cfif>
	</cfsilent>
	<cfif objectParams.format eq 'list'>
		<cfset objectParams.sourcetype='calendar'>
		<cfset structDelete(objectParams,'isbodyobject')>
		#variables.dspObject(object='collection',objectid=variables.$.content('contentid'),params=objectParams)#
	<cfelse>

		<div class="mura-calendar-wrapper">
			<div id="mura-calendar-error" class="alert alert-warning" role="alert" style="display:none;">
				<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">#variables.$.rbKey('calendar.close')#</span></button>
				<i class="fa fa-warning"></i> #variables.$.rbKey('calendar.eventfetcherror')#
			</div>

			<cfif arrayLen(objectParams.items) gt 1>
				<cfsilent>
					<cfset colorIndex=0>
					<cfset calendars=$.getBean('contentManager')
						.findMany(
							contentids=objectParams.items,
							siteid=$.event('siteid'),
							showNavOnly=0
						)>
				</cfsilent>
				<div class="mura-calender__filters" style="display:none;">
				<cfloop condition="calendars.hasNext()">
					<cfsilent>
						<cfset calendar=calendars.next()>
						<cfset i=calendars.currentIndex()-1>
						<cfset colorIndex=colorIndex+1>
						<cfif colorIndex gt arrayLen(this.calendarcolors)>
							<cfset colorIndex=1>
						</cfif>
					</cfsilent>
					<div class="mura-calendar__filter-item">
						<label class="mura-calendar__filter-item__option">
							<input type="checkbox" class="input-style--swatch" data-index="#i#" data-contentid="#calendar.getContentID()#" data-color="#this.calendarcolors[colorIndex].background#" style="display:none;">
							<span>
								<span class="mura-calendar__filter-item__swatch"></span>
								<span class="mura-calendar__filter-item__swatch-label">#esapiEncode('html',calendar.getMenuTitle())#</span>
							</span>
						</label>
					</div>
				</cfloop>
				</div>
			</cfif>
			<div id="mura-calendar" class="mura-calendar-object"></div>
			<div id="mura-calendar-loading">#this.preloaderMarkup#</div>
		</div>
		<script>
		Mura(function(){
			<cfset muraCalenderView='muraCalenderView' & replace(variables.$.content('contentid'),'-','','all')>
			<cfset muraHiddenCals='muraHiddenCals' & replace(variables.$.content('contentid'),'-','','all')>
			var hiddenCalendars=window.sessionStorage.getItem('#muraHiddenCals#');

			if(hiddenCalendars){
				hiddenCalendars=hiddenCalendars.split(',');
			} else {
				hiddenCalendars=[];
			}

			var muraCalendarView=JSON.parse(window.sessionStorage.getItem('#muraCalenderView#'));

			if(!muraCalendarView){
				muraCalendarView={
					name:'#esapiEncode("javascript",objectParams.viewdefault)#',
				};
			}

			<cfif objectParams.dateparams>
				var defaultDate= '#variables.$.getCalendarUtility().getDefaultDate()#';
			<cfelse>
				if(muraCalendarView.defaultDate){
				var defaultDate=  muraCalendarView.defaultDate;
				} else {
					var defaultDate= '#variables.$.getCalendarUtility().getDefaultDate()#';
				}
			</cfif>

			var colors=#lcase(serializeJSON(this.calendarcolors))#;
			var calendars=#lcase(serializeJSON(objectparams.items))#;
			var eventSources=[
				<cfset colorIndex=0>
				<cfloop array="#objectParams.items#" index="i">
					<cfsilent>
						<cfset colorIndex=colorIndex+1>
						<cfif colorIndex gt arrayLen(this.calendarcolors)>
							<cfset colorIndex=1>
						</cfif>
					</cfsilent>
					{
						url: '#variables.$.siteConfig().getApi("JSON","v1").getEndpoint()#/findCalendarItems?calendarid=#esapiEncode("javascript",i)#'
						, type: 'POST'
						, data: {
							method: 'getFullCalendarItems'
							, calendarid: '#esapiEncode("javascript",i)#'
							, siteid: '#variables.$.content('siteid')#'
							, categoryid: '#esapiEncode('javascript',variables.$.event('categoryid'))#'
							, tag: '#esapiEncode('javascript',variables.$.event('tag'))#'
							, format: 'fullcalendar'
							, showNavOnly: 0
							, showExcludeSearch: 0
						}
						, color: '#this.calendarcolors[colorIndex].background#'
						, textColor: '#this.calendarcolors[colorIndex].text#'
						, error: function() {
							$('##mura-calendar-error').show();
						}
					},
				</cfloop>
			];

			$('.mura-calender__filters').show();

			Mura.loader()
				.loadcss("#$.siteConfig('corepath')#/vendor/fullcalendar/fullcalendar.css",{media:'all'})
				.loadcss("#$.siteConfig('corepath')#/vendor/fullcalendar/fullcalendar.print.css",{media:'print'})
				.loadjs(
					"#$.siteConfig('corepath')#/vendor/fullcalendar/lib/moment-with-locales.min.js",
					"#$.siteConfig('corepath')#/vendor/fullcalendar/fullcalendar.min.js",
					"#$.siteConfig('corepath')#/vendor/fullcalendar/gcal.js",
					function(){
						$('##mura-calendar').fullCalendar({
							timezone: 'local'
							, defaultDate: defaultDate
							, buttonText: {
								day: '#variables.$.rbKey('calendar.day')#'
								, agendaDay: '#variables.$.rbKey('calendar.agendaday')#'
								, week: '#variables.$.rbKey('calendar.week')#'
								, agendaWeek: '#variables.$.rbKey('calendar.agendaweek')#'
								, month: '#variables.$.rbKey('calendar.month')#'
								, today: '#variables.$.rbKey('calendar.today')#'
							}
							, monthNames: #SerializeJSON(ListToArray(variables.$.rbKey('calendar.monthLong')))#
							, monthNamesShort: #SerializeJSON(ListToArray(variables.$.rbKey('calendar.monthShort')))#
							, dayNames: #SerializeJSON(ListToArray(variables.$.rbKey('calendar.weekdaylong')))#
							, dayNamesShort: #SerializeJSON(ListToArray(variables.$.rbKey('calendar.weekdayShort')))#
							, firstDay: 0 // (0=Sunday, 1=Monday, etc.)
							, weekends: true // show weekends?
							, weekMode: 'fixed' // fixed, liquid, or variable
							, header: {
								left: 'today prev,next'
								, center: 'title'
								, right: '#esapiEncode("javascript",objectParams.viewoptions)#'
							}
							<cfif isNumeric(variables.$.event('day')) and variables.$.event('day')>
								, defaultView: 'agendaDay'
							<cfelse>
								, defaultView:  muraCalendarView.name
							</cfif>
							, viewRender: function(view,element){
								if(view.end){
									var newDefaultDate=new Date((new Date(view.start).getTime() + new Date(view.end).getTime()) / 2)
								} else {
									var newDefaultDate=view.start;
								}
								window.sessionStorage.setItem('#muraCalenderView#',JSON.stringify({
									name:view.name,
									defaultDate:newDefaultDate
								}));
							}
							, loading: function(isLoading) {
									$('##mura-calendar-loading').toggle(isLoading);
							}
							, eventLimit: true
						});

						<cfif arrayLen(objectParams.items) eq 1>
							$('##mura-calendar').fullCalendar('addEventSource',eventSources[0]);
						<cfelse>
							$('.mura-calendar__filter-item').each(function(){
								var optionContainer=$(this);
								var calendarToggleInput=optionContainer.find('.input-style--swatch');

								if(hiddenCalendars.indexOf(calendarToggleInput.data('contentid')) == -1){
									calendarToggleInput.attr('checked',true);
								} else {
									calendarToggleInput.attr('checked',false);
								}

								calendarToggleInput.on('change',function(){
									var swatch=optionContainer.find('.mura-calendar__filter-item__swatch');
									var self=$(this);
									if(self.is(':checked')){
										swatch.css('background-color',self.data('color'));
										$('##mura-calendar').fullCalendar('addEventSource',eventSources[self.data('index')]);

										var temp=[];
										var contentid=self.data('contentid');
										for(var i in hiddenCalendars){
											if(hiddenCalendars[i] !=contentid){
												temp.push(hiddenCalendars[i])
											}
										}
										hiddenCalendars=temp;;
									} else {
										swatch.css('background-color','');
										$('##mura-calendar').fullCalendar('removeEventSource',eventSources[self.data('index')]);
										hiddenCalendars.push(self.data('contentid'));
									}
									window.sessionStorage.setItem('#muraHiddenCals#',hiddenCalendars.join(','));
								}).trigger('change');
							});
						</cfif>

					}
				);
		});
		</script>
	</cfif>
</cfoutput>

<cfsilent>
<!-- delete params that we don't want to persist --->
<cfset structDelete(objectParams,'dateparams')>
<cfset structDelete(objectParams,'categoryid')>
<cfset structDelete(objectParams,'tag')>
<cfset structDelete(objectParams,'sortyby')>
<cfset structDelete(objectParams,'sortdirection')>
</cfsilent>
