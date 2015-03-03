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
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

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
<cfif request.muraFrontEndRequest and this.asyncObjects>
	<div class="mura-async-object" 
		data-object="calendar">
	</div>
<cfelse>
<div class="mura-calendar-wrapper">
	<div id="mura-calendar-error" class="alert alert-warning" role="alert" style="display:none;">
		<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">#variables.$.rbKey('calendar.close')#</span></button>
		<i class="fa fa-warning"></i> #variables.$.rbKey('calendar.eventfetcherror')#
	</div>
	<div id="mura-calendar" class="mura-calendar-object"></div>
	<div id="mura-calendar-loading">#this.preloaderMarkup#</div>
</div>

<script>
$(function(){
	mura.loader()
		.loadcss("#$.siteConfig('requirementspath')#/fullcalendar/fullcalendar.css",{media:'all'})
		.loadcss("#$.siteConfig('requirementspath')#/fullcalendar/fullcalendar.print.css",{media:'print'})		
		.loadjs(
			"#$.siteConfig('requirementspath')#/fullcalendar/lib/moment.min.js",
			"#$.siteConfig('requirementspath')#/fullcalendar/fullcalendar.min.js",
			"#$.siteConfig('requirementspath')#/fullcalendar/gcal.js",
			function(){
				$('##mura-calendar').fullCalendar({
					timezone: 'false'
					, defaultDate: '#variables.$.getCalendarUtility().getDefaultDate()#'
					, buttonText: {
						day: '#variables.$.rbKey('calendar.day')#'
						, week: '#variables.$.rbKey('calendar.week')#'
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
					/*
					, header: {
						left: 'today prev,next'
						, center: 'title'
						, right: 'agendaDay,agendaWeek,month'
					}*/
					, defaultView: 'month'
					, allDayDefault: false
					, loading: function(isLoading) {
							$('##mura-calendar-loading').toggle(isLoading);
					}
					//, timeFormat: 'LT' // see http://arshaw.com/fullcalendar/docs/utilities/date_formatting_string/ for options
					, eventSources: [
						{
							url: '#variables.$.siteConfig('requirementspath')#/fullcalendar/proxy.cfc'
							, type: 'POST'
							, data: {
								method: 'getFullCalendarItems'
								, calendarid: '#variables.$.content('contentid')#'
								, siteid: '#variables.$.content('siteid')#'
								, categoryid: '#variables.$.event('categoryid')#'
								, tag: '#variables.$.event('tag')#'
							}
							, color: '##3a87ad' // sets calendar events background+border colors
							, textColor: 'white'
							, error: function() { 
								$('##mura-calendar-error').show();
							}
						}

						// optionally include U.S. Holidays
						// NOTE: if using Google Calendars, you must first have a Google Calendar API Key! See http://fullcalendar.io/docs/google_calendar/
						// , {
						// 	googleCalendarApiKey: '<YOUR API KEY>'
						// 	, url: 'http://www.google.com/calendar/feeds/usa__en%40holiday.calendar.google.com/public/basic'
						// 	, color: 'yellow'
						// 	, textColor: 'black'
						// }
					]
					// example of how to open events in a separate window
					// , eventClick: function(event) {
					// 	window.open(event.url, 'fcevent', 'width=700,height=600');
					// 	return false;
					// }
				});
			}
		);
});
</script>
</cfif>
</cfoutput>
