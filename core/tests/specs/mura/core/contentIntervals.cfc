/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
		variables.$=application.serviceFactory.getBean('$').init('default');

		// Unique per run so concurrent runs against a shared database (e.g. Lucee and Adobe CF) can't see each other's events
		variables.runID=createUUID();
		variables.eventIDs=[];

		// A fixed Monday in the past keeps weekdays and expected dates deterministic,
		// and stays well within the interval manager's default repeat limit of one year from now
		variables.anchor=createDateTime(2025,1,6,10,0,0);

		variables.calendar=variables.$.getBean('content').set({
			title="Unit Test Calendar #variables.runID#",
			menutitle="Unit Test Calendar #variables.runID#",
			filename="unit-test-calendar-#variables.runID#",
			urltitle="unit-test-calendar-#variables.runID#",
			siteID="default",
			parentID="00000000000000000000000000000000001",
			type="Calendar",
			approved="1"
		}).save();
	}

	function afterAll(){
		// Deleting the calendar also deletes any events left under it
		var bean=variables.$.getBean('content').loadBy(contentid=variables.calendar.getContentID());
		if(bean.exists()){
			bean.delete();
		}
	}

	// Creates a repeating event under this run's calendar, starting at the anchor date.
	// Pass an 'end' (never/after/on) like the admin does: setDisplayInterval() derives displayStop from it
	private function createEvent(required struct displayInterval){
		var event=variables.$.getBean('content').set({
			title="Unit Test Event #variables.runID#",
			filename="unit-test-event-#variables.runID#",
			urltitle="unit-test-event-#variables.runID#",
			siteID="default",
			parentID=variables.calendar.getContentID(),
			type="Page",
			approved="1",
			display=2,
			displayStart=variables.anchor,
			displayStop=''
		});
		event.setDisplayInterval(arguments.displayInterval).save();
		arrayAppend(variables.eventIDs,event.getContentID());
		return event;
	}

	// Returns the 'yyyy-mm-dd' dates of the event's occurrences between start and end, ignoring any other calendar items
	private function getOccurrenceDates(required event, required date start, required date end){
		var dates=[];
		var occurrences=variables.calendar.getEventsIterator(start=arguments.start,end=arguments.end);

		while(occurrences.hasNext()){
			var occurrence=occurrences.next();
			if(occurrence.getContentID() == arguments.event.getContentID()){
				arrayAppend(dates,dateFormat(occurrence.getDisplayStart(),'yyyy-mm-dd'));
			}
		}

		return dates;
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Content Intervals", function() {

			afterEach(function() {
				// Each spec gets its own event; remove it so the next spec starts from an empty calendar
				for(var eventID in variables.eventIDs){
					var bean=variables.$.getBean('content').loadBy(contentid=eventID);
					if(bean.exists()){
						bean.delete();
					}
				}
				variables.eventIDs=[];
			});

			it(
				title="DAILY: Should have an event each day in the window",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='daily'});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,1,12)) ).toBe([
						'2025-01-06','2025-01-07','2025-01-08','2025-01-09','2025-01-10','2025-01-11','2025-01-12'
					]);
				}
			);

			it(
				title="DAILY: Should only have events inside a window that starts after the event",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='daily'});

					expect( getOccurrenceDates(event,createDate(2025,1,20),createDate(2025,1,22)) ).toBe([
						'2025-01-20','2025-01-21','2025-01-22'
					]);
				}
			);

			it(
				title="WEEKLY: Should only have events on days 1,3,5,7",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='weekly',daysofweek='1,3,5,7'});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,1,19)) ).toBe([
						'2025-01-07','2025-01-09','2025-01-11','2025-01-12','2025-01-14','2025-01-16','2025-01-18','2025-01-19'
					]);
				}
			);

			it(
				title="WEEKENDS: Should only have events on days 1,7",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='weekends'});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,1,19)) ).toBe([
						'2025-01-11','2025-01-12','2025-01-18','2025-01-19'
					]);
				}
			);

			it(
				title="WEEKDAYS: Should only have events on days 2,3,4,5,6",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='weekdays'});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,1,17)) ).toBe([
						'2025-01-06','2025-01-07','2025-01-08','2025-01-09','2025-01-10',
						'2025-01-13','2025-01-14','2025-01-15','2025-01-16','2025-01-17'
					]);
				}
			);

			it(
				title="BI-WEEKLY: Should have 14 days between dates",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='bi-weekly',daysofweek=dayOfWeek(variables.anchor)});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,2,16)) ).toBe([
						'2025-01-06','2025-01-20','2025-02-03'
					]);
				}
			);

			it(
				title="MONTHLY: Should have 1 month between dates",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='monthly'});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,4,30)) ).toBe([
						'2025-01-06','2025-02-06','2025-03-06','2025-04-06'
					]);
				}
			);

			it(
				title="YEARLY: Should have 1 year between dates",
				body=function() {
					var event=createEvent({repeats=1,end='never',type='yearly'});

					expect( getOccurrenceDates(event,createDate(2025,1,1),createDate(2026,12,31)) ).toBe([
						'2025-01-06','2026-01-06'
					]);
				}
			);

			it(
				title="ENDS AFTER: Should only have 5 events",
				body=function() {
					var event=createEvent({repeats=1,type='daily',end='after',endafter=5});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,1,31)) ).toBe([
						'2025-01-06','2025-01-07','2025-01-08','2025-01-09','2025-01-10'
					]);
				}
			);

			it(
				title="ENDS AFTER: Should count events from the event start, not the window start",
				body=function() {
					var event=createEvent({repeats=1,type='daily',end='after',endafter=5});

					expect( getOccurrenceDates(event,createDate(2025,1,8),createDate(2025,1,31)) ).toBe([
						'2025-01-08','2025-01-09','2025-01-10'
					]);
				}
			);

			it(
				title="ENDS ON: Should only have events up to the end date",
				body=function() {
					var event=createEvent({repeats=1,type='daily',end='on',endon=createDate(2025,1,10)});

					expect( getOccurrenceDates(event,createDate(2025,1,6),createDate(2025,1,31)) ).toBe([
						'2025-01-06','2025-01-07','2025-01-08','2025-01-09','2025-01-10'
					]);
				}
			);
		});

		describe("Testing alignToWeekday Helper Function", function() {

			beforeEach(function() {
				intervalManager = $.getBean('contentIntervalManager');
			});

			it(
				title="Should return same date when both dates have same weekday",
				body=function() {
					var monday1 = CreateDate(2026, 4, 14); // Monday
					var monday2 = CreateDate(2026, 4, 7);  // Also Monday
					var result = intervalManager.alignToWeekday(monday1, monday2);
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe(DateFormat(monday1, 'yyyy-mm-dd'));
				}
			);

			it(
				title="Should adjust forward to match reference weekday",
				body=function() {
					var monday = CreateDate(2026, 4, 13);    // Monday (day 2)
					var wednesday = CreateDate(2026, 4, 15); // Wednesday (day 4)
					var result = intervalManager.alignToWeekday(monday, wednesday);
					// Should be Wednesday, April 15
					expect(DayOfWeek(result)).toBe(4); // Wednesday
					expect(Day(result)).toBe(15);
				}
			);

			it(
				title="Should adjust backward to match reference weekday",
				body=function() {
					var friday = CreateDate(2026, 4, 17);   // Friday (day 6)
					var tuesday = CreateDate(2026, 4, 14);  // Tuesday (day 3)
					var result = intervalManager.alignToWeekday(friday, tuesday);
					// Should be Tuesday, April 14
					expect(DayOfWeek(result)).toBe(3); // Tuesday
					expect(Day(result)).toBe(14);
				}
			);

			it(
				title="Should handle week boundary adjustments correctly",
				body=function() {
					var saturday = CreateDate(2026, 4, 18); // Saturday (day 7)
					var monday = CreateDate(2026, 4, 13);   // Monday (day 2)
					var result = intervalManager.alignToWeekday(saturday, monday);
					// Should be Monday, April 13 (5 days back)
					expect(DayOfWeek(result)).toBe(2); // Monday
					expect(Day(result)).toBe(13);
				}
			);

			it(
				title="Should return date object (not numeric)",
				body=function() {
					var date1 = CreateDate(2026, 4, 15);
					var date2 = CreateDate(2026, 4, 16);
					var result = intervalManager.alignToWeekday(date1, date2);
					expect(IsDate(result)).toBeTrue();
					// But ensure DateAdd works on it (would fail on plain number in BoxLang)
					var testAdd = DateAdd('d', 1, result);
					expect(IsDate(testAdd)).toBeTrue();
				}
			);

			it(
				title="Should handle Sunday to Saturday adjustment",
				body=function() {
					var sunday = CreateDate(2026, 4, 19);   // Sunday (day 1)
					var saturday = CreateDate(2026, 4, 18); // Saturday (day 7)
					var result = intervalManager.alignToWeekday(sunday, saturday);
					// Should be Saturday, April 25 (6 days forward - same week period)
					expect(DayOfWeek(result)).toBe(7); // Saturday
					expect(Day(result)).toBe(25);
				}
			);

		});

		describe("Testing GetNthDayOfMonth Helper Function", function() {

			beforeEach(function() {
				intervalManager = $.getBean('contentIntervalManager');
			});

			it(
				title="Should return first Sunday of April 2026",
				body=function() {
					// April 2026 starts on Wednesday the 1st
					// First Sunday is April 5th
					var result = intervalManager.GetNthDayOfMonth(2026, 4, 1, 1);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-05');
				}
			);

			it(
				title="Should return second Monday of April 2026",
				body=function() {
					// First Monday of April 2026 is the 6th
					// Second Monday is April 13th
					var result = intervalManager.GetNthDayOfMonth(2026, 4, 2, 2);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-13');
				}
			);

			it(
				title="Should return third Wednesday of April 2026",
				body=function() {
					// April 1st is Wednesday
					// Third Wednesday is April 15th
					var result = intervalManager.GetNthDayOfMonth(2026, 4, 4, 3);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-15');
				}
			);

			it(
				title="Should return fourth Friday of April 2026",
				body=function() {
					// First Friday is April 3rd
					// Fourth Friday is April 24th
					var result = intervalManager.GetNthDayOfMonth(2026, 4, 6, 4);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-24');
				}
			);

			it(
				title="Should return first Tuesday of May 2026",
				body=function() {
					// May 2026 starts on Friday the 1st
					// First Tuesday is May 5th
					var result = intervalManager.GetNthDayOfMonth(2026, 5, 3, 1);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-05-05');
				}
			);

			it(
				title="Should return a date object in JDBC timestamp format",
				body=function() {
					var result = intervalManager.GetNthDayOfMonth(2026, 4, 1, 1);
					// Should be recognized as a date
					expect(IsDate(result)).toBeTrue();
					// Should be in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					var resultStr = ToString(result);
					expect(resultStr).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					// Verify DateAdd works on it and returns same type
					var testAdd = DateAdd('d', 1, result);
					expect(IsDate(testAdd)).toBeTrue();
					expect(ToString(testAdd)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
				}
			);

			it(
				title="Should handle 5th occurrence that goes into next month",
				body=function() {
					// Looking for 5th Sunday in April 2026
					// April only has 4 Sundays (5, 12, 19, 26)
					// So 5th Sunday would be May 3rd
					var result = intervalManager.GetNthDayOfMonth(2026, 4, 1, 5);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-05-03');
				}
			);

		});

		describe("Testing GetLastDayOfWeekOfMonth Helper Function", function() {

			beforeEach(function() {
				intervalManager = $.getBean('contentIntervalManager');
			});

			it(
				title="Should return last Sunday of April 2026",
				body=function() {
					// April 2026: Last Sunday is the 26th
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 4, 1);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-26');
				}
			);

			it(
				title="Should return last Monday of April 2026",
				body=function() {
					// Last Monday of April 2026 is the 27th
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 4, 2);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-27');
				}
			);

			it(
				title="Should return last Wednesday of April 2026",
				body=function() {
					// Last Wednesday of April 2026 is the 29th
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 4, 4);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-29');
				}
			);

			it(
				title="Should return last Friday of April 2026",
				body=function() {
					// April 30th is Thursday, so last Friday is April 24th
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 4, 6);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-24');
				}
			);

			it(
				title="Should return last Tuesday of May 2026",
				body=function() {
					// May 2026 ends on Sunday the 31st
					// Last Tuesday is May 26th
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 5, 3);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-05-26');
				}
			);

			it(
				title="Should return a date object in JDBC timestamp format",
				body=function() {
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 4, 1);
					// Should be recognized as a date
					expect(IsDate(result)).toBeTrue();
					// Should be in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					var resultStr = ToString(result);
					expect(resultStr).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					// Verify DateAdd works on it and returns same type
					var testAdd = DateAdd('d', 1, result);
					expect(IsDate(testAdd)).toBeTrue();
					expect(ToString(testAdd)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
				}
			);

			it(
				title="Should handle month where last occurrence is in current month",
				body=function() {
					// February 2026 ends on Saturday the 28th
					// Last Saturday is Feb 28th (not going into next month)
					var result = intervalManager.GetLastDayOfWeekOfMonth(2026, 2, 7);
					expect(IsDate(result)).toBeTrue();
					// Check it's in JDBC timestamp format {ts 'yyyy-mm-dd HH:MM:SS'}
					expect(ToString(result)).toMatch('\{ts ''\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}''\}');
					expect(DateFormat(result, 'yyyy-mm-dd')).toBe('2026-02-28');
				}
			);

		});
	}
}
