<cfcomponent extends="mura.cfobject" output="false" hint="This provides content interval service level logic functionality">

<!--- Heavily borrowed from http://www.bennadel.com/projects/kinky-calendar.htm --->

	<cffunction name="isAllDay" output="false">
		<cfargument name="start">
		<cfargument name="stop">

		<cfreturn (isDate(arguments.start)
			and hour(arguments.start) eq 0
			and minute(arguments.start) eq 0
			and (
				not isDate(arguments.stop)
				or hour(arguments.stop) eq 23
				and minute(arguments.stop) eq 59
				)
			)>
	</cffunction>

	<cffunction name="findConflicts">
		<cfargument name="content">

		<cfset var result=[]>
		<cfset var rsresult=''>
		<cfset var rscandidate=''>

		<cfif arguments.content.getDisplay() eq 2>
			<cfset var calendar=getBean('content').loadBy(contentid=content.getParentID(),siteid=content.getSiteID())>

			<cfif calendar.getType() eq 'Calendar'>
				<cfset var calendarSettings=calendar.getDisplayInterval().getAllValues()>
				<cfset var displayInterval=arguments.content.getDisplayInterval().getAllValues()>
				<cfset var start=content.getDisplayStart()>
				<cfset var end=content.getDisplayStop()>

				<cfif calendarSettings.detectconflicts and calendarSettings.detectspan>
					<cfif displayInterval.repeats>
						<cfif listFindNoCase('never,after',displayInterval.end)>
							<cfset end=dateAdd('m',calendarSettings.detectspan,content.getDisplayStart())>
						<cfelseif isDate(displayInterval.endon)>
							<cfset end=displayInterval.endon>
						<cfelse>
							<cfset displayInterval.repeats=1>
							<cfset displayInterval.end="never">
							<cfset end=dateAdd('m',calendarSettings.detectspan,content.getDisplayStart())>
						</cfif>
					<cfelseif not isDate(content.getDisplayStop())>
						<cfset displayInterval.repeats=1>
						<cfset displayInterval.end="never">
						<cfset displayInterval.type="daily">
						<cfset end=dateAdd('m',calendarSettings.detectspan,content.getDisplayStart())>
					</cfif>

					<cfset var events=calendar.getEventsIterator(start=start,end=end)>

					<cfset var rsevents=duplicate(events.getQuery())>
					<cfset var rscheck=''>
					<cfset var rsresult=''>
					<cfset var rsresultfinal=''>
					<cfset var rsitemdetails=''>

					<cfquery name="rscandidate" dbtype="query">
						select * from rsevents where 0=1
					</cfquery>

					<cfset QueryAddRow( rscandidate ) />

					<!--- Set query data in the event query. --->
					<cfloop list="#rscandidate.columnList#" index="local.i">
						<cfif local.i eq 'displayInterval'>
							<cfset querySetCell(rscandidate,
								local.i,
								arguments.content.getDisplayInterval(serialize=true),
								rscandidate.recordCount) />
						<cfelse>
							<cfset querySetCell(rscandidate,
								local.i,
								arguments.content.getValue(i),
								rscandidate.recordCount) />
						</cfif>
					</cfloop>

					<cfset querySetCell(rscandidate,
						'parentType',
						'Calendar',
						rscandidate.recordCount) />

					<cfset rscandidate=apply(query=rscandidate,current=start,from=start,to=end) />

					<cfquery name="rsresult" dbtype="query">
						select * from rsevents where 0=1
					</cfquery>

					<cfquery name="rsevents" dbtype="query">
						select * from rsevents
						union
						select * from rscandidate
					</cfquery>

					<cfset events.setQuery(rsevents)>

					<cfloop condition="events.hasNext()">
						<cfset var event=events.next()>

						<cfif event.getContentID() eq arguments.content.getContentID()>
							<cfquery name="rscheck" dbtype="query">
								select * from rsevents
								where contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getContentID()#">
								and
									(
										(
											displaystart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#event.getDisplayStop()#">
											and displaystart >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#event.getDisplayStart()#">
										)
										or

										(
											displaystop <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#event.getDisplayStop()#">
											and displaystop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#event.getDisplayStart()#">
										)
									)
							</cfquery>

							<cfloop query="rscheck">
								<cfset QueryAddRow(rsresult) />

								<cfloop list="#rsresult.columnList#" index="local.i">
									<cfset querySetCell(rsresult,
									local.i,
									rscheck[local.i][rscheck.currentrow],
									rsresult.recordCount) />
								</cfloop>
							</cfloop>
						</cfif>
					</cfloop>

					<cfif rsresult.recordcount>
						<cfset var utility=getBean("utility")>
						<cfquery name="rsresultfinal" dbtype="query">
							select distinct contentid,contenthistid,siteid,menutitle,title from rsresult
						</cfquery>

						<cfloop query="rsresultfinal">
							<cfset arrayAppend(result, utility.queryRowToStruct(rsresultfinal,rsresultfinal.currentrow))>

							<cfquery name="rsitemdetails" dbtype="query">
								select * from rsresult
								where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsresultfinal.contentid#">
							</cfquery>

							<cfset result[arrayLen(result)].confictdetailiterator=getBean('contentIterator').setQuery(rsitemdetails)>
						</cfloop>
					</cfif>
				</cfif>

			</cfif>

		</cfif>

		<cfreturn getBean('contentIterator').setArray(result)>

	</cffunction>

	<cffunction name="deserializeInterval" output="false">
		<cfargument name="interval">
		<cfargument name="displayStart">
		<cfargument name="displayStop">

		<cfset var data=''>
		<cfif isJSON(arguments.interval)>
			<cfset data=deserializeJSON(arguments.interval)>
		<cfelseif isSimpleValue(arguments.interval)>
			<cfset data={}>
			<cfif len(arguments.interval)>
				<cfset data.type=arguments.interval>
			</cfif>
		</cfif>

		<cfparam name="data.every" default=1>
		<cfparam name="data.type" default="daily">
		<cfparam name="data.endafter" default="1">
		<cfparam name="data.endon" default="">
		<cfparam name="data.allday" default="1">
		<cfparam name="data.detectconflicts" default="0">
		<cfparam name="data.detectspan" default="12">

		<cfif not structKeyExists(data,'end')>
			<cfif isDate(arguments.displayStart) and isDate(arguments.displayStop)>
				<cfset data.end='on'>
				<cfset data.endon=arguments.displayStop>
			<cfelse>
				<cfset data.end='never'>
				<cfset data.endon=''>
			</cfif>
		</cfif>

		<cfif not structKeyExists(data,'timezone') or not len(data.timezone) or data.allday>
			<cfset data.timezone=CreateObject("java", "java.util.TimeZone").getDefault().getID()>
		</cfif>

		<cfif not structKeyExists(data,'repeats')>
			<cfif data.type eq 'daily' and not data.every>
				<cfset data.repeats=0>
			<cfelse>
				<cfset data.repeats=1>
			</cfif>
		</cfif>

		<cfif not data.every>
			<cfset data.every=1>
		</cfif>

		<cfset var hasdaysofweek=listFindNoCase('weekly,bi-weekly,monthly,week1,week2,week3,week4,weeklast',data.type)>

		<cfif hasdaysofweek>
			<cfif not structkeyExists(data,'daysofweek')>
				<cfset data.daysofweek=''>
				<cfif isDate(arguments.displayStart)>
					<cfset data.daysofweek=dayofweek(displayStart)>
				</cfif>
			</cfif>
		<cfelse>
			<cfset data.daysofweek=''>
		</cfif>

		<cfreturn data>
	</cffunction>

	<cffunction name="apply" access="public" returntype="query" output="false" hint="Gets the events between the given dates (inclusive). Returns a structure that has both the event query and event index.">
		<cfargument name="query" type="query" required="true" hint="The Query the has the items that may need intervals applied" />
		<cfargument name="from" type="date" required="true" hint="The From date for our date span (inclusive)." />
		<cfargument name="to" type="date" required="true" hint="The To date for our date span (inclusive)." />
		<cfargument name="current" type="any" required="true" default="0" hint="The From date for our date span (inclusive). Pass 0 or empty string when not applicable." />

		<!--- Define the local scope. --->
		<cfset local.deleteList="" />

		<cfif not arguments.query.recordcount>
			<cfreturn arguments.query>
		</cfif>

		<!---
			Make sure that we are working with date objects
			that are DAY-only dates (no time component).
		--->
		<cfset arguments.from = getBean('utility').dateOnly(arguments.from) />
		<cfset arguments.to = getBean('utility').dateOnly(arguments.to) />

		<cfif isDefined('arguments.query.parentType') and arguments.current neq 0>
			<cfset arguments.current = getBean('utility').dateOnly(arguments.current) />
		<cfelse>
			<cfset arguments.current = 0>
		</cfif>

		<!--- Build out raw events to and in event type--->

		<!---
			Now, we will loop over the raw events and populate the
			calculated events query. This way, when we are rendering
			the calednar itself, we won't have to worry about repeat
			types or anything of that nature.
		--->
		<cfset local.currentrow = 1>
		<cfset local.recordcount = arguments.query.recordcount>

		<cfloop from="1" to="#local.recordcount#" index="local.currentrow">

			<!---
				No matter what kind of repeating event type we are
				dealing with, the TO date will always be calculated
				in the same manner (it the Starting date that get's
				hairy). If there is an end date for the event, the
				the TO date is the minumium of the end date and the
				end of the time period we are examining. If there
				is no end date on the event, then the TO date is the
				end of the time period we are examining.
			--->

			<cfset local.displayInterval = deserializeInterval(arguments.query.displayInterval[local.currentrow],arguments.query.displayStart[local.currentrow],arguments.query.displayStop[local.currentrow])>

			<cfif arguments.query.display[local.currentrow] eq 2
					and len(local.displayInterval.type)
					and (
						arguments.query.parentType[local.currentrow] eq 'calendar'
						or local.displayInterval.repeats
				)>

				<cfif not local.displayInterval.every>
					<cfset local.displayInterval.every=1>
				</cfif>

				<cfset local.repeatcount = 0>
				<cfset local.repeatmax = 0>
				<cfset local.repeatuntil = getBean('utility').dateOnly(dateAdd('yyyy',1,now()))>

				<cfif local.displayInterval.end eq 'after' and  isNumeric(local.displayInterval.endafter)>
					<cfset local.repeatmax=local.displayInterval.endafter>
				<cfelseif local.displayInterval.end eq 'on' and isDate(local.displayInterval.endon)>
					<cfset local.endOnDate = parseDateTime(listFirst(local.displayInterval.endon,'+'))>
					<cfset local.repeatuntil = getBean('utility').dateOnly(parseDateTime(listFirst(local.displayInterval.endon,'+')))>
				</cfif>

				<cfset local.displayStart = getBean('utility').dateOnly(arguments.query.displayStart[local.currentrow])>

				<cfif isDate(arguments.query.displayStop[local.currentrow])>
					<cfset local.eventStopDateTime = arguments.query.displayStop[local.currentrow]>
					<cfset local.displayStop = getBean('utility').dateOnly(local.eventStopDateTime)>
				<cfelse>
					<cfset local.displayStop = getBean('utility').dateOnly(arguments.query.displayStop[local.currentrow])>
				</cfif>

				<cfif isDate(arguments.current) and arguments.query.parentType[local.currentrow] neq 'Calendar'>
					<cfset local.from = arguments.current>
					<cfset local.to = arguments.current>
				<cfelse>
					<cfset local.from = arguments.from>
					<cfset local.to = arguments.to>
				</cfif>

				<cfset local.fromOrig = local.from>
				<cfset local.toOrig = local.to>

				<cfif isDate(arguments.query.displayStop[local.currentrow])>
					<!---
						Since the event has an end date, get what ever
						is most efficient for the future loop evaluation
						- the end of the time period or the end date of
						the event.
					--->
					<cfset local.to = getBean('utility').dateMin(local.displayStop, local.toOrig)>
				</cfif>

				<!---
					Set the default loop type and increment. We are
					going to default to 1 day at a time.
				--->
				<cfset local.LoopType = "d" />
				<cfset local.LoopIncrement = 1 />

				<!---
					Set additional conditions to be met. We are going
					to default to allowing all days of the week.
				--->
				<cfset local.daysOfWeek = "" />
				<cfset local.hasDaysOfWeek = false />

				<!---
					Check to see what kind of event we have - is
					it a single day event or an event that type. If
					we have an event repeat, we are going to flesh it
					out directly into the event query by adding rows.
					The point of this switch statement is to use the
					repeat type to figure out what the START date,
					the type of loop skipping (ie. day, week, month),
					and the number of items we need to skip per loop
					iteration.
				--->
				<cfswitch expression="#local.displayInterval.type#">


					<!--- Repeat weekly. --->
					<cfcase value="weekly">

						<!---
							Set the start date of the loop. For
							efficiency's sake, we don't want to loop
							from the very beginning of the event; we
							can get the max of the start date and first
							day of the calendar month.
						--->

						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart>
						</cfif>

						<!---
							Since this event type weekly, we want
							to make sure to start on a day that might
							be in the event series. Therefore, adjust
							the start day to be on the closest day of
							the week.
						--->

						<cfset local.From = alignToWeekday(local.From, local.DisplayStart)>

						<!--- Set the loop type and increment. --->
						<cfset local.LoopType = "d" />
						<cfset local.hasdaysofweek = true />
						<cfset local.LoopIncrement = 1 />
						<cfset local.DaysOfWeek = local.displayInterval.daysofweek>

					</cfcase>

					<!--- Repeat bi-weekly. --->
					<cfcase value="bi-weekly">

						<!---
							Set the start date of the loop. For
							efficiency's sake, we don't want to loop
							from the very beginning of the event; we
							can get the max of the start date and first
							day of the calendar month.
						--->

						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart />
						</cfif>

						<!---
							Since this event type weekly, we want
							to make sure to start on a day that might
							be in the event series. Therefore, adjust
							the start day to be on the closest day of
							the week.
						--->

						<cfset local.From = alignToWeekday(local.From, local.DisplayStart)>

						<!--- Set the loop type and increment. --->
						<cfset local.LoopType = "bi-weekly" />
						<cfset local.LoopIncrement = 8 />
						<cfset local.hasdaysofweek = true />
						<cfset local.DaysOfWeek = local.displayInterval.daysofweek>

					</cfcase>

					<!--- Repeat monthly. --->
					<cfcase value="monthly">

						<!---
							When dealing with the start date of a
							monthly repeating, we have to be very
							careful not to try tro create a date that
							doesnt' exists. Therefore, we are simply
							going to go back a year from the current
							year and start counting up. Not the most
							efficient, but the easist way of dealing
							with it.
						--->

						<cfset local.From = getBean('utility').dateMax(
							getBean('utility').dateOnly(DateAdd("yyyy", -1, local.DisplayStart)), 
							local.DisplayStart
						)>
						
						<!--- Set the loop type and increment. --->
						<cfset local.LoopType = "m" />
						<cfset local.LoopIncrement = 1 />
						<cfset local.hasdaysofweek = false />

					</cfcase>

					<!--- Repeat monthly. --->
					<cfcase value="week1,week2,week3,week4,weeklast">

						<!---
							When dealing with the start date of a
							monthly repeating, we have to be very
							careful not to try tro create a date that
							doesnt' exists. Therefore, we are simply
							going to go back a year from the current
							year and start counting up. Not the most
							efficient, but the easist way of dealing
							with it.
						--->
						<cfset local.LoopIncrement=right(local.displayInterval.type,1)>

						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart />
						</cfif>

						<!--- Set the loop type and increment. --->
						<cfif local.displayInterval.type eq 'weeklast'>
							<cfset local.LoopType = "weeklast" />
						<cfelse>
							<cfset local.LoopType = "nthweek" />
							<cfset local.LoopWeek = right(local.displayInterval.type,1) />
							<cfif not isNumeric(local.LoopWeek)>
								<cfset local.LoopWeek=1>
							</cfif>
						</cfif>

						<cfset local.DaysOfWeek = local.displayInterval.daysofweek>
						<cfset local.hasdaysofweek = true />
						<cfset local.LoopIncrement = 1 />

						<cfif len(local.DaysOfWeek)>
							<cfset local.startCheck=listToArray(local.DaysOfWeek)>
							<cfset arraySort(local.startCheck,'numeric','asc')>
							<cfset local.startdayofweek=local.startCheck[1]>
							<cfset local.enddayofweek=local.startCheck[arrayLen(local.startCheck)]>
						<cfelse>
							<cfset local.startdayofweek=1>
							<cfset local.enddayofweek=1>
						</cfif>

					</cfcase>


					<!--- Repeat yearly. --->
					<cfcase value="yearly">
						
						<!---
							When dealing with the start date of a
							yearly repeating, we have to be very
							careful not to try tro create a date that
							doesnt' exists. Therefore, we are simply
							going to go back a year from the current
							year and start counting up. Not the most
							efficient, but the easist way of dealing
							with it.
						--->
						<!--- TODO: optimization, needs to be tested --->
						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart />
						</cfif>
						
						<!--- Set the loop type and increment. --->
						<cfset local.LoopType = "yyyy" />
						<cfset local.LoopIncrement = 1 />

					</cfcase>

					<!--- Repeat monday - friday. --->
					<cfcase value="weekdays">

						<!---
							Set the start date of the loop. For
							efficiency's sake, we don't want to loop
							from the very beginning of the event; we
							can get the max of the start date and first
							day of the calendar month.
						--->
						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart />
						</cfif>

						<cfset local.LoopType = "d" />
						<cfset local.LoopIncrement = 1 />
						<cfset local.DaysOfWeek = "2,3,4,5,6" />

					</cfcase>

					<!--- Repeat saturday - sunday. --->
					<cfcase value="weekends">

						<!---
							Set the start date of the loop. For
							efficiency's sake, we don't want to loop
							from the very beginning of the event; we
							can get the max of the start date and first
							day of the calendar month.
						--->

						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart />
						</cfif>

						<!--- Set the loop type and increment. --->
						<cfset local.LoopType = "d" />
						<cfset local.LoopIncrement = 1 />
						<cfset local.DaysOfWeek = "1,7" />

					</cfcase>

					<!--- Repeat daily. --->
					<cfdefaultcase>

						<!---
							Set the start date of the loop. For
							efficiency's sake, we don't want to loop
							from the very beginning of the event; we
							can get the max of the start date and first
							day of the calendar month.
						--->

						<cfif not local.repeatmax>
							<cfset local.From = getBean('utility').dateMax(local.DisplayStart, local.FromOrig)>
						<cfelse>
							<cfset local.From = local.DisplayStart />
						</cfif>

						<!--- Set the loop type and increment. --->
						<cfset local.LoopType = "d" />
						<cfset local.LoopIncrement = local.displayInterval.every />
						<cfset local.DaysOfWeek = "1,2,3,4,5,6,7" />

					</cfdefaultcase>

				</cfswitch>

				<cfset local.found = false />

				<!---
					Check to see if we are looking at an event that need
					to be fleshed it (ie. it has a repeat type).
				--->

				<cfif len(local.loopType)>

					<!---
						Set the offset. This is the number of iterations
						we are away from the start date.
					--->
					<cfset local.offset = 0 />

					<!---
						Get the initial date to look at when it comes to
						fleshing out the events.
					--->
					<cfif local.loopType eq 'nthweek'>
						<cfset local.loopMonth = month(local.from)>
						<cfset local.loopYear = year(local.from)>
						<cfset local.loopIndex = 1>
						<cfset local.daysOfWeekArray = listToArray(local.daysOfWeek)>
						<cfset local.dayArray = []>
						<cfloop from="1" to="#arrayLen(local.daysOfWeekArray)#" index="local.i">
							<cfset arrayAppend(local.dayArray, GetNthDayOfMonth(local.loopYear, local.loopMonth, local.daysOfWeekArray[local.i], local.loopWeek))>
						</cfloop>
						<cfset local.day=getBean('utility').dateArrayMin(local.dayArray)>
					<cfelseif local.loopType eq 'weeklast'>
						<cfset local.loopMonth = month(local.from)>
						<cfset local.loopYear = year(local.from)>
						<cfset local.loopIndex = 1>
						<cfset local.daysOfWeekArray = listToArray(local.daysOfWeek)>
						<cfset local.dayArray = []>
						<cfloop from="1" to="#arrayLen(local.daysOfWeekArray)#" index="local.i">
							<cfset arrayAppend(local.dayArray, GetLastDayOfWeekOfMonth(local.loopYear, local.loopMonth, local.daysOfWeekArray[local.i], local.loopWeek))>
						</cfloop>
						<cfset local.day=getBean('utility').dateArrayMin(local.dayArray)>
					<cfelse>
						<cfset local.day = local.from />
					</cfif>

					<cfif local.hasdaysofweek>
						<cfif isDate(local.displayStop) and local.day gt local.displayStop>
							<cfset local.day = dateAdd('d', 1, local.To)>
						</cfif>

						<cfif ListFindNoCase("nthweek,weeklast",local.loopType)>
							<cfif local.day lt local.displayStart>
								<cfset local.weekdayfound=false>
								<cfloop from="1" to="#arrayLen(local.dayArray)#" index="local.i">
									<cfif local.dayArray[local.i] gte local.displayStart>
										<cfset local.day = local.displayStart>
										<cfset local.weekdayfound=true>
										<cfbreak>
									</cfif>
								</cfloop>

								<cfif not local.weekdayfound>
									<cfset local.baseLoopDate = dateAdd('m',1,createDate(local.loopYear,local.loopMonth,1))>
									<cfif local.loopType eq "nthweek">
										<cfset local.day = GetNthDayOfMonth(year(local.baseLoopDate),month(local.baseLoopDate),arrayMin(local.daysOfWeekArray),local.LoopWeek)>
									<cfelse>
										<cfset local.day = GetLastDayOfWeekOfMonth(year(local.baseLoopDate),month(local.baseLoopDate),arrayMin(local.daysOfWeekArray),local.LoopWeek)>
									</cfif>
								</cfif>
							</cfif>
						<cfelse>
							<cfif local.day lt local.displayStart>
								<cfset local.day = local.displayStart>
							</cfif>
						</cfif>

					</cfif>

					<!---
						Now, keep looping over the incrementing date
						until we are past the cut off for this time
						period of potential events.
					--->

					<cfloop condition="(local.day LTE local.To)">

						<!---
							Check to make sure that this day is in
							the appropriate date range and that we meet
							any days-of-the-week criteria that have been
							defined. Remember, to ensure proper looping,
							our FROM date (local.From) may be earlier than
							the window in which we are looking.
						--->

						<cfif local.repeatmax and local.repeatcount eq local.repeatmax>
							<cfbreak>
						</cfif>

						<cfif NOT Len(local.DaysOfWeek) OR
								ListFind(
									local.DaysOfWeek,
									DayOfWeek( local.Day )
								) >

							<cfif
									(local.From LTE local.Day) AND
									(local.Day LTE local.To) AND
									(local.Day GTE local.FromOrig) AND
									(not local.repeatmax or local.repeatcount LT local.repeatmax) AND
									local.day LTE local.repeatuntil
								>

								<!---
									Populate the event query. Add a row to
									the query and then copy over the data.
								--->

								<cfif not local.found>
									<cfset querySetCell(
											arguments.query,
											"displayStart",
											createDateTime(
												year(local.day),
												month(local.day),
												day(local.day),
												hour(arguments.query['displayStart'][local.currentrow]),
												minute(arguments.query['displayStart'][local.currentrow]),
												0
											),
										local.currentrow
									) />

									<cfif isDate(arguments.query['displayStop'][local.currentrow])>
										<cfset querySetCell(
											arguments.query,
											"displayStop",
											createDateTime(
												year(local.day),
												month(local.day),
												day(local.day),
												hour(arguments.query['displayStop'][local.currentrow]),
												minute(arguments.query['displayStop'][local.currentrow]),
												0
											),
											local.currentrow
										) />
									<cfelse>
										<cfset querySetCell(
											arguments.query,
											"displayStop",
											createDateTime(
												year(local.day),
												month(local.day),
												day(local.day),
												hour(arguments.query['displayStart'][local.currentrow]),
												minute(arguments.query['displayStart'][local.currentrow]),
												0
											),
											local.currentrow
										) />
									</cfif>

								<cfelse>
									<cfset QueryAddRow( arguments.query ) />

									<!--- Set query data in the event query. --->
									<cfloop list="#arguments.query.columnList#" index="local.i">
										<!--- Use try/catch to handle BoxLang query column access issues --->
										<cftry>
											<cfset local.cellValue = arguments.query[local.i][local.currentrow]>
											<cfset querySetCell(arguments.query,
												local.i,
												local.cellValue,
												arguments.query.recordCount) />
											<cfcatch>
												<!--- Skip problematic columns --->
											</cfcatch>
										</cftry>
									</cfloop>

									<cfset querySetCell(
											arguments.query,
											"displayStart",
											createDateTime(
												year(local.day),
												month(local.day),
												day(local.day),
												hour(arguments.query['displayStart'][local.currentrow]),
												minute(arguments.query['displayStart'][local.currentrow]),
												0
											),
											arguments.query.recordCount
										) />

									<cfif isDate(arguments.query['displayStop'][local.currentrow])>
										<cfset querySetCell(
											arguments.query,
											"displayStop",
											createDateTime(
												year(local.day),
												month(local.day),
												day(local.day),
												hour(arguments.query['displayStop'][local.currentrow]),
												minute(arguments.query['displayStop'][local.currentrow]),
												0
											),
											arguments.query.recordCount
										) />
									<cfelse>
										<cfset querySetCell(
											arguments.query,
											"displayStop",
											createDateTime(
												year(local.day),
												month(local.day),
												day(local.day),
												hour(arguments.query['displayStart'][local.currentrow]),
												minute(arguments.query['displayStart'][local.currentrow]),
												0
											),
											arguments.query.recordCount
										) />

									</cfif>
								</cfif>
								<cfset local.found = true />
							</cfif>

							<cfset local.repeatcount=local.repeatcount+1>
						</cfif>

						<cfset local.offset = (local.offset + 1) />

						<!--- Set the next day to look at. --->
						<cfif local.loopType eq 'nthweek'>
							<cfif local.LoopWeek eq 1>
								<cfif local.loopindex eq 7>
									<cfset local.day=dateAdd("m",1 * local.displayInterval.every,createDate(local.loopYear,local.loopMonth,1))>
									<cfset local.loopMonth=month(local.day)>
									<cfset local.loopYear=year(local.day)>
									<cfset local.loopindex=1>
									<cfset local.tempArray=[GetNthDayOfMonth(local.loopYear,local.loopMonth,local.startdayofweek,local.LoopWeek),GetNthDayOfMonth(local.loopYear,local.loopMonth,local.enddayofweek,local.LoopWeek)]/>
									<cfset local.day=getBean('utility').dateArrayMin(local.tempArray)>
								<cfelse>
									<cfset local.loopIndex=local.loopIndex+1>
									<cfset local.day=dateAdd("d",1,local.day)>
								</cfif>
							<cfelse>
								<cfif dayOfWeek(local.day) eq 7>
									<cfset local.day=dateAdd("m",1 * local.displayInterval.every,createDate(local.loopYear,local.loopMonth,1))>
									<cfset local.loopMonth=month(local.day)>
									<cfset local.loopYear=year(local.day)>
									<cfset local.day=GetNthDayOfMonth(local.loopYear,local.loopMonth,local.startdayofweek,local.LoopWeek)/>
								<cfelse>
									<cfset local.day=dateAdd("d",1,local.day)>
								</cfif>
							</cfif>
						<cfelseif local.loopType eq 'weeklast'>
							<cfif local.loopIndex eq 7>
								<cfset local.loopIndex=1>
								<cfset local.day=dateAdd("m",1 * local.displayInterval.every,createDate(local.loopYear,local.loopMonth,1))>
								<cfset local.loopMonth=month(local.day)>
								<cfset local.loopYear=year(local.day)>
								<cfset local.tempArray=[GetLastDayOfWeekOfMonth(year(local.day),month(local.day),local.startdayofweek),GetLastDayOfWeekOfMonth(year(local.day),month(local.day),local.enddayofweek)]/>
								<cfset local.day=getBean('utility').dateArrayMin(local.tempArray)>
							<cfelse>
								<cfset local.loopIndex=local.loopIndex+1>
								<cfset local.day=dateAdd("d",1,local.day)>
							</cfif>
						<cfelseif local.loopType eq 'bi-weekly'>
							<cfif dayOfWeek(local.day) eq 7>

								<cfset local.Day = DateAdd(
									'd',
									8 + (14 * (local.displayInterval.every-1)),
									local.day
									) />
							<cfelse>
								<cfset local.day = DateAdd('d',1,local.day) />
							</cfif>
						<cfelseif local.hasdaysofweek>
							<cfif dayOfWeek(local.day) eq 7>

								<cfset local.Day = DateAdd(
									'd',
									(7 * (local.displayInterval.every-1)) + 1,
									local.day
									) />
							<cfelse>
								<cfset local.day = DateAdd('d',1,local.day) />
							</cfif>
						<cfelse>
							<!--- Add one to the offset. --->

							<cfset local.day = DateAdd(
								local.LoopType,
								(local.Offset * local.LoopIncrement),
								local.From
								) />
						</cfif>

						<cfif local.hasdaysofweek>
							<cfif isDate(local.displayStop) and local.day gt local.displayStop>
								<cfset local.day = dateAdd('d', 1, local.To)>
							</cfif>

							<cfif local.day lt local.displayStart>
								<cfset local.day = local.displayStart>
							</cfif>
						</cfif>

					</cfloop>
				</cfif>

				<cfif not local.found>
					<cfset local.deleteList = listAppend(local.deleteList,arguments.query['contentid'][local.currentrow])>
				</cfif>
			</cfif>
		</cfloop>

		<cfif len(local.deleteList)>
			<cfquery name="arguments.query" dbtype="query">
				select * from arguments.query 
				where contentid not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.deleteList#">)
			</cfquery>
		</cfif>

		<cfreturn arguments.query />
	</cffunction>

	<cffunction name="applyByMenuTypeAndDate" output="false">
		<cfargument name="query">
		<cfargument name="menuType">
		<cfargument name="menuDate">

		<cfswitch expression="#arguments.menuType#">
			<cfcase value="default,Calendar,CalendarDate,calendar_features,ReleaseDate">
				<cfreturn apply(
					query=arguments.query,
					from=createDate(year(arguments.menuDate),month(arguments.menuDate),day(arguments.menuDate)),
					to=createDate(year(arguments.menuDate),month(arguments.menuDate),day(arguments.menuDate))
					)
				/>
			</cfcase>
			<cfcase value="CalendarMonth">
				<cfreturn apply(
					query=arguments.query,
					from=createDate(year(arguments.menuDate),month(arguments.menuDate),1),
					to=createDate(year(arguments.menuDate),month(arguments.menuDate),daysInMonth(arguments.menuDate))
					)
				/>
			</cfcase>
			<cfcase value="ReleaseYear,CalendarYear">
				<cfreturn apply(
					query=arguments.query,
					from=createDate(year(arguments.menuDate),1,1),
					to=createDate(year(arguments.menuDate),12,31)
					)
				/>
			</cfcase>
			<cfdefaultcase>
				<cfreturn arguments.query>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<!---
	/**
	 * Adjusts a date to match the same day of the week as a reference date.
	 * Useful for aligning recurring events to specific weekdays.
	 * 
	 * @param dateToAdjust The date to be adjusted to a different weekday
	 * @param referenceDate The reference date whose weekday to match
	 * @return Date shifted to the same day of week as referenceDate
	 */
	--->
	<cffunction
		name="alignToWeekday"
		access="public"
		returntype="date"
		output="false"
		hint="Adjusts a date to match the same day of the week as a reference date.">

		<!--- Define arguments. --->
		<cfargument
			name="dateToAdjust"
			type="date"
			required="true"
			hint="The date to be adjusted to a different weekday."
			/>

		<cfargument
			name="referenceDate"
			type="date"
			required="true"
			hint="The reference date whose weekday we want to match."
			/>

		<cfset var dayOffset = -DayOfWeek(arguments.dateToAdjust) + DayOfWeek(arguments.referenceDate) />

		<cfreturn DateAdd("d", dayOffset, arguments.dateToAdjust) />
	</cffunction>

	<!---
	/**
	 * Returns the date of the Nth occurrence of a specific weekday in a given month.
	 * For example, find the 2nd Sunday or 3rd Wednesday of a month.
	 * 
	 * @param year The year (e.g., 2024)
	 * @param month The month (1-12)
	 * @param DayOfWeek The day of week (1=Sunday, 7=Saturday)
	 * @param Nth The occurrence number (1=first, 2=second, etc.)
	 * @return Date of the Nth weekday in the specified month
	 * @note May return a date in the next month if Nth is too large
	 * @note No locale support
	 */
	--->
	<cffunction
		name="GetNthDayOfMonth"
		access="public"
		returntype="date"
		output="false"
		hint="Returns the date of the Nth given day of the week of the given month.">

		<!--- Define arguments. --->

		<cfargument
			name="year"
			type="numeric"
			required="true"
			hint="The year for which we are finding the Nth occurrence of the weekday."
			/>

		<cfargument
			name="Month"
			type="numeric"
			required="true"
			hint="The month (1-12) for which we are finding the Nth occurrence of the weekday."
			/>

		<cfargument
			name="DayOfWeek"
			type="numeric"
			required="true"
			hint="The day of the week of which we want to find the Nth monthly occurence."
			/>

		<cfargument
			name="Nth"
			type="numeric"
			required="false"
			default="1"
			hint="The instance of the day of the week that we want to find (ex. 2 for 2nd Sunday)."
			/>

		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />

		<!---
			First, we need to make sure that the date we were given
			was actually the first of the month.
		--->
		<cfset local.Date = CreateDate(arguments.Year,arguments.Month,1) />

		<!---
			Now that we have the correct start date of the month, we
			need to find the first instance of the given day of the
			week.
		--->

		<cfif (DayOfWeek( local.Date ) LTE arguments.DayOfWeek)>

			<!---
				The first of the month falls on or before the first
				instance of our target day of the week. This means we
				won't have to leave the current week to hit the first
				instance.
			--->
			<cfset local.Date = DateAdd("d", arguments.DayOfWeek - DayOfWeek(local.Date), local.Date) />

		<cfelse>

			<!---
				The first of the month falls after the first instance
				of our target day of the week. This means we will
				have to move to the next week to hit the first target
				instance.
			--->
			<cfset local.Date = DateAdd("d", (7 - DayOfWeek(local.Date)) + arguments.DayOfWeek, local.Date) />

		</cfif>

		<!---
			At this point, our Date is the first occurrence of our
			target day of the week. Now, we have to navigate to the
			target occurence.
		--->
		<cfset local.Date = DateAdd("d", 7 * (arguments.Nth - 1), local.Date) />

		<!---
			Return the given date as a date object. There is a chance 
			that this date will be in the NEXT month if someone put in 
			an Nth value that was too large for the current month to handle.
		--->
		<cfreturn local.Date />
	</cffunction>

	<!---
	/**
	 * Returns the date of the last occurrence of a specific weekday in a given month.
	 * For example, find the last Sunday or last Friday of a month.
	 * 
	 * @param year The year (e.g., 2024)
	 * @param month The month (1-12)
	 * @param DayOfWeek The day of week (1=Sunday, 7=Saturday)
	 * @return Date of the last occurrence of the weekday in the specified month
	 * @note No locale support
	 */
	--->
	<cffunction
		name="GetLastDayOfWeekOfMonth"
		access="public"
		returntype="date"
		output="false"
		hint="Returns the date of the last given weekday of the given month.">

		<!--- Define arguments. --->
		<cfargument
			name="year"
			type="numeric"
			required="true"
			hint="The year for which we are finding the last occurrence of the weekday."
		/>

		<cfargument
			name="month"
			type="numeric"
			required="true"
			hint="The month (1-12) for which we are finding the last occurrence of the weekday."
			/>

		<cfargument
			name="DayOfWeek"
			type="numeric"
			required="true"
			hint="The day of the week of which we want to find the last monthly occurence."
			/>

		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />

		<!--- Get the current month based on the given date. --->
		<cfset local.ThisMonth = CreateDate(arguments.year, arguments.month, 1) />

		<!---
			Now, get the last day of the current month. We
			can get this by subtracting 1 from the first day
			of the next month.
		--->
		<cfset local.LastDay = DateAdd("d", -1, DateAdd("m", 1, local.ThisMonth)) />

		<!---
			Now, the last day of the month is part of the last
			week of the month. However, there is no guarantee
			that the target day of this week will be in the current
			month. Regardless, let's get the date of the target day
			so that at least we have something to work with.
		--->
		<cfset local.Day = DateAdd("d", -DayOfWeek(local.LastDay) + arguments.DayOfWeek, local.LastDay) />

		<!---
			Now, we have the target date, but we are not exactly
			sure if the target date is in the current month. if
			is not, then we know it is the first of that type of
			the next month, in which case, subracting 7 days (one
			week) from it will give us the last occurence of it in
			the current Month.
		--->
		<cfif (Month( local.Day ) NEQ Month( local.ThisMonth ))>

			<!--- Subtract a week. --->
			<cfset local.Day = DateAdd("d", -7, local.Day) />

		</cfif>

		<!--- Return the given day as a date object. --->
		<cfreturn local.Day />
	</cffunction>

</cfcomponent>
