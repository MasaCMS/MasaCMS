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

	}

}
