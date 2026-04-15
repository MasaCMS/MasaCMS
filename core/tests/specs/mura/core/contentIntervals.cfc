/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';

		config={
			title="My Unit Test",
			menutitle="My Unit Testing Calendar",
			filename="my-unit-test",
			urltitle="my-unit-test",
			siteID="default",
			parentID="00000000000000000000000000000000001",
			contentID="0000000000000000000000000000000test",
			type="Page",
			subtype="Default",
			remoteID="remoteIDforUnitTest"
		};

		entityName='content';
		entityClass='mura.content.contentBean';

		$=application.serviceFactory.getBean('$').init(config.siteid);

		calendarConfig={
		   title="My Unit Testing Calendar",
		   menutitle="My Unit Testing Calendar",
		   filename="my-unit-testing-calendar",
		   urltitle="my-unit-testing-calendar",
		   siteID="default",
		   parentID="00000000000000000000000000000000001",
		   contentID='0000000000000000000000000000000test',
		   type="Calendar",
		   approved="1"
	   };

	   calendar=$.getBean('content').loadBy(contentid=calendarConfig.contentid);

	   if(calendar.exists()){
		   calendar.delete();
		   calendar=$.getBean('content').loadBy(contentid=calendarConfig.contentid);
	   }

	   calendar.set(calendarConfig).save();

	   events='';
	   params={};
	   eventConfig={
		   title="My Unit Testing Event",
		   filename="my-unit-testing-event",
		   urltitle="my-unit-testing-event",
		   siteID="default",
		   parentID=calendar.getContentID(),
		   type="Page",
		   approved="1",
		   display=2,
		   displayStart=now(),
		   displayStop=now()
	   };

	   event=$.getBean('content').set(eventConfig).save();
	}

	function afterAll(){
		$.getBean('content').loadBy(contentid='0000000000000000000000000000000test').delete();
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Content Intervals", function() {

			it(
				title="DAILY: Should have an event each day until the to date",
				body=function() {
					//Daily
					event.setDisplayInterval({
						repeats=1,
						event=1,
						type='daily'
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now())
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;

					while(events.hasNext()){
						instance=events.next();

						if(dateFormat(instance.getdisplayStart(),'yyyy-mm-dd') != dateFormat(current,'yyyy-mm-dd')){
							complete=false;
							break;
						}

						current=dateAdd('d',1,current);
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="WEEKLY: Should only have events on days 1,3,5,7",
				body=function() {

					//Weekly
					event.setDisplayInterval({
						repeats=1,
						event=1,
						type='weekly',
						daysofweek='1,3,5,7'
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now()),
						daysofweek="1,3,5,7"
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;

					while(events.hasNext()){
						instance=events.next();

						if(!listFind(params.daysofweek,dayofWeek(instance.getdisplayStart()))){
							complete=false;
							break;
						}
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="WEEKENDS: Should only have events on days 1,7",
				body=function() {

					//WeekEnds
					event.setDisplayInterval({
						repeats=1,
						type='weekends'
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now()),
						daysofweek='1,7'
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;

					while(events.hasNext()){
						instance=events.next();

						if(!listFind(params.daysofweek,dayofWeek(instance.getdisplayStart()))){
							complete=false;
							break;
						}
					}

					expect(complete).tobeTrue();
				}
			);


			it(
				title="WEEKDAYS: Should only have events on days 2,3,4,5,6",
				body=function() {

					//WeekDays
					event.setDisplayInterval({
						repeats=1,
						type='weekdays'
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now()),
						daysofweek="2,3,4,5,6"
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;

					while(events.hasNext()){
						instance=events.next();

						if(!listFind(params.daysofweek,dayofWeek(instance.getdisplayStart()))){
							complete=false;
							break;
						}
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="BI-WEEKLY: Should have 14 days between dates",
				body=function() {

					//Bi-Weekly
					event.setDisplayInterval({
						repeats=1,
						type='bi-weekly',
						daysofweek=dayofweek(now())
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now()),
						daysofweek=dayofweek(now())
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;
					var previous=params.from;
					var diff=0;
					var started=false;

					while(events.hasNext()){
						instance=events.next();
						diff=dateDiff('d',previous,instance.getdisplayStart());

						if(started && diff!=14){
							complete=false;
							break;
						} else {
							started=true;
						}

						previous=instance.getdisplayStart();
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="MONTHLY: Should have 1 month between dates",
				body=function() {

					//Monthly
					event.setDisplayInterval({
						repeats=1,
						type='monthly'
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',3,now())
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;
					var previous=params.from;
					var diff=0;
					var started=false;

					while(events.hasNext()){
						instance=events.next();
						diff=dateDiff('m',previous,instance.getdisplayStart());

						if(started && diff!=1){
							complete=false;
							break;
						} else {
							started=true;
						}

						previous=instance.getdisplayStart();
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="YEARLY: Should have 1 year between dates",
				body=function() {

					//Yearly
					event.setDisplayInterval({
						repeats=1,
						type='yearly'
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('yyyy',3,now())
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;
					var previous=params.from;
					var diff=0;
					var started=false;

					while(events.hasNext()){
						instance=events.next();
						diff=dateDiff('yyyy',previous,instance.getdisplayStart());

						if(started && diff!=1){
							complete=false;
							break;
						} else {
							started=true;
						}

						previous=instance.getdisplayStart();
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="ENDS AFTER: Should only have 5 events",
				body=function() {

					//End After
					event.setDisplayStop('');
					event.setDisplayInterval({
						repeats=1,
						type='daily',
						end='after',
						endafter=5
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now())
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;
					var i=0;

					while(events.hasNext()){
						events.next();
						i++;

						if(i > 5){
							complete=false;
							break;
						}
					}

					expect(complete).tobeTrue();
				}
			);

			it(
				title="ENDS ON: Should only have events before end date",
				body=function() {

					//End On
					event.setDisplayStop('');
					event.setDisplayInterval({
						repeats=1,
						type='daily',
						end='on',
						endon=dateAdd('d',5,now())
					}).setApproved(1).save();

					params=	{
						from=now(),
						to=dateAdd('m',1,now()),
						endon=dateAdd('d',5,now())
					};

					events=calendar.getEventsIterator(
						argumentCollection=params
					);

					var instance='';
					var current=params.from;
					var complete=true;
					var i=0;

					while(events.hasNext()){
						instance=events.next();

						if(fix(instance.getDisplayStart()) > fix(params.endon)){
							complete=false;
							break;
						}
					}

					expect(complete).tobeTrue();
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
