<cfcomponent extends="mura.cfobject" output="false">

<!--- Heavily borrowed from http://www.bennadel.com/projects/kinky-calendar.htm --->

<cffunction
	name="apply"
	access="public"
	returntype="query"
	output="false"
	hint="Gets the events between the given dates (inclusive). Returns a structure that has both the event query and event index.">

	<!--- Define arguments. --->
	<cfargument
		name="query"
		type="query"
		required="true"
		hint="The Query the has the items that may need intervals applied"
		/>
	
	<cfargument
		name="From"
		type="numeric"
		required="true"
		hint="The From date for our date span (inclusive)."
		/>
		
	<cfargument
		name="To"
		type="numeric"
		required="true"
		hint="The To date for our date span (inclusive)."
		/>
		
	
	<!--- Define the local scope. --->
	<cfset var LOCAL = StructNew() />
	<cfset local.deleteList="" />
	
	<cfif not arguments.query.recordcount>
		<cfreturn arguments.query>
	</cfif>
	<!--- 
		Make sure that we are working with numeric dates 
		that are DAY-only dates. 
	--->
	<cfset ARGUMENTS.From = Fix( ARGUMENTS.From ) />
	<cfset ARGUMENTS.To = Fix( ARGUMENTS.To ) />
	
	<!--- 
		Now, we will loop over the raw events and populate the 
		calculated events query. This way, when we are rendering
		the calednar itself, we won't have to worry about repeat
		types or anything of that nature.
	--->
	<cfset local.currentrow=1>
	<cfset local.recordcount=arguments.query.recordcount>

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
		<cfif arguments.query.display[local.currentrow] eq 2 
		and len(arguments.query.displayInterval[local.currentrow]) 
		and arguments.query.displayInterval[local.currentrow] neq 'daily'>

			<cfset LOCAL.DisplayStart=fix(arguments.query.displayStart[local.currentrow])>
			
			<cfif isDate(arguments.query.displayStop[local.currentrow])>
				<cfset LOCAL.DisplayStop=fix(arguments.query.displayStop[local.currentrow])>
			<cfelse>
				<cfset LOCAL.DisplayStop=0>
			</cfif>

			<cfif isDate(arguments.query.displayStop[local.currentrow])>
				
				<!--- 
					Since the event has an end date, get what ever 
					is most efficient for the future loop evaluation 
					- the end of the time period or the end date of 
					the event.
				--->
				<cfset LOCAL.To = Min( 
					LOCAL.DisplayStop,
					ARGUMENTS.To
					) />
				
			<cfelse>
			
				<!--- 
					If there is no end date, then naturally,
					we only want to go as far as the last 
					day of the month.
				--->
				<cfset LOCAL.To = ARGUMENTS.To />
			
			</cfif>
			
			<!--- 
				Set the default loop type and increment. We are 
				going to default to 1 day at a time.
			--->
			<cfset LOCAL.LoopType = "d" />
			<cfset LOCAL.LoopIncrement = 1 />
			
			<!--- 
				Set additional conditions to be met. We are going 
				to default to allowing all days of the week.
			--->
			<cfset LOCAL.DaysOfWeek = "" />
			
			<!---
				Check to see what kind of event we have - is 
				it a single day event or an event that repeats. If
				we have an event repeat, we are going to flesh it
				out directly into the event query by adding rows.
				The point of this switch statement is to use the
				repeat type to figure out what the START date, 
				the type of loop skipping (ie. day, week, month),
				and the number of items we need to skip per loop
				iteration.
			--->
			<cfswitch expression="#arguments.query.displayInterval[local.currentrow]#">
			
				
				<!--- Repeat weekly. --->
				<cfcase value="weekly">
				
					<!---
						Set the start date of the loop. For 
						efficiency's sake, we don't want to loop 
						from the very beginning of the event; we 
						can get the max of the start date and first
						day of the calendar month.
					--->
					<cfset LOCAL.From = Max(
						LOCAL.DisplayStart,
						ARGUMENTS.From
						) />
					
					<!--- 
						Since this event repeats weekly, we want 
						to make sure to start on a day that might 
						be in the event series. Therefore, adjust 
						the start day to be on the closest day of 
						the week.
					--->
					<cfset LOCAL.From = (
						LOCAL.From - 
						DayOfWeek( LOCAL.From ) + 
						DayOfWeek( LOCAL.DisplayStart )
						) />
					
					<!--- Set the loop type and increment. --->
					<cfset LOCAL.LoopType = "d" />
					<cfset LOCAL.LoopIncrement = 7 />
					
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
					<cfset LOCAL.From = Max(
						LOCAL.DisplayStart,
						ARGUMENTS.From
						) />
						
					<!--- 
						Since this event repeats weekly, we want 
						to make sure to start on a day that might 
						be in the event series. Therefore, adjust 
						the start day to be on the closest day of 
						the week.
					--->
					<cfset LOCAL.From = (
						LOCAL.From - 
						DayOfWeek( LOCAL.From ) + 
						DayOfWeek( LOCAL.DisplayStart )
						) />
					
					<!--- 
						Now, we have to make sure that our start 
						date is NOT in the middle of the bi-week 
						period. Therefore, subtract the mod of 
						the day difference over 14 days.
					--->
					<cfset LOCAL.From = (
						LOCAL.From - 
						((LOCAL.From - LOCAL.DisplayStart) MOD 14)
						) />
					
					<!--- Set the loop type and increment. --->
					<cfset LOCAL.LoopType = "d" />
					<cfset LOCAL.LoopIncrement = 14 />
					
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
					<cfset LOCAL.From = Max(
						fix(DateAdd( "yyyy", -1, LOCAL.DisplayStart )),
						LOCAL.DisplayStart
						) />
					
					<!--- Set the loop type and increment. --->
					<cfset LOCAL.LoopType = "m" />
					<cfset LOCAL.LoopIncrement = 1 />
				
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
					<cfset local.LoopIncrement=right(arguments.query.displayInterval[local.currentrow],1)>

					<cfset LOCAL.From = Max(
						LOCAL.DisplayStart,
						ARGUMENTS.From
						) />
					
					<!--- Set the loop type and increment. --->
					<cfif arguments.query.displayInterval[local.currentrow] eq 'weeklast'>
						<cfset LOCAL.LoopType = "weeklast" />
					<cfelse>
						<cfset LOCAL.LoopType = "nthweek" />
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
					<cfset LOCAL.From = Max(
						fix(DateAdd( "yyyy", -1, LOCAL.DisplayStart )),
						LOCAL.DisplayStart
						) />
							
					<!--- Set the loop type and increment. --->
					<cfset LOCAL.LoopType = "yyyy" />
					<cfset LOCAL.LoopIncrement = 1 />
				
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
					<cfset LOCAL.From = Max( 
						LOCAL.DisplayStart,
						ARGUMENTS.From
						) />
						
					<!--- Set the loop type and increment. --->
					<cfset LOCAL.LoopType = "d" />
					<cfset LOCAL.LoopIncrement = 1 />
					<cfset LOCAL.DaysOfWeek = "2,3,4,5,6" />
				
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
					<cfset LOCAL.From = Max( 
						LOCAL.DisplayStart,
						ARGUMENTS.From
						) />
						
					<!--- Set the loop type and increment. --->
					<cfset LOCAL.LoopType = "d" />
					<cfset LOCAL.LoopIncrement = 1 />
					<cfset LOCAL.DaysOfWeek = "1,7" />
					
				</cfcase>
			
			</cfswitch>
			
			<cfset LOCAL.found = false />
			<!--- 
				Check to see if we are looking at an event that need
				to be fleshed it (ie. it has a repeat type).
			--->
			<cfif len(local.LoopType)>
					
				<!--- 
					Set the offset. This is the number of iterations
					we are away from the start date.
				--->
				<cfset LOCAL.Offset = 0 />
				
				<!--- 
					Get the initial date to look at when it comes to 
					fleshing out the events.
				--->
				<cfif local.loopType eq 'nthweek'>
					<cfset LOCAL.Day =fix(GetNthDayOfMonth(year(LOCAL.from),month(LOCAL.from),dayofWeek(LOCAL.DisplayStart),local.LoopIncrement)) />
					<cfif local.displayStop and local.day gt local.displayStop>
						<cfset LOCAL.day=LOCAL.To+1>
					</cfif>
				<cfelseif local.loopType eq 'weeklast'>
					<cfset LOCAL.Day =fix(GetLastDayOfWeekOfMonth(year(LOCAL.from),month(LOCAL.from),dayofWeek(LOCAL.DisplayStart))) />
					<cfif local.displayStop and local.day gt local.displayStop>
						<cfset LOCAL.day=LOCAL.To+1>
					</cfif>
				<cfelse>	
					<cfset LOCAL.Day = Fix( 
						DateAdd(
							LOCAL.LoopType,
							(LOCAL.Offset * LOCAL.LoopIncrement),
							LOCAL.From
							) 
						) />	
				</cfif>
				
				<!--- 
					Now, keep looping over the incrementing date 
					until we are past the cut off for this time 
					period of potential events.
				--->
				<cfloop condition="(LOCAL.Day LTE LOCAL.To)">
				
					<!--- 
						Check to make sure that this day is in 
						the appropriate date range and that we meet
						any days-of-the-week criteria that have been
						defined. Remember, to ensure proper looping,
						our FROM date (LOCAL.From) may be earlier than
						the window in which we are looking.
					--->
					<cfif (
						<!--- Within window. --->
						(
							ARGUMENTS.From LTE LOCAL.Day) AND 
							(LOCAL.Day LTE LOCAL.To) AND
							
							<!--- Within allowable days. ---> 
							(
								(NOT Len( LOCAL.DaysOfWeek )) OR
								ListFind( 
									LOCAL.DaysOfWeek, 
									DayOfWeek( LOCAL.Day ) 
									)
							)
						)>
				
						<!--- 
							Populate the event query. Add a row to 
							the query and then copy over the data.
						--->
						
						<cfif not LOCAL.found>
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
								<cfset querySetCell(arguments.query,
									local.i,
									arguments.query[local.i][local.currentrow],
									arguments.query.recordCount) />
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
						<cfset LOCAL.found = true />
					</cfif>
					
					<cfset LOCAL.Offset = (LOCAL.Offset + 1) />

					<!--- Set the next day to look at. --->
					<cfif LOCAL.loopType eq 'nthweek'>
						<cfset local.day=dateAdd("m",1,LOCAL.Day)>
						<cfset LOCAL.Day=fix(GetNthDayOfMonth(year(local.day),month(local.day),dayofWeek(LOCAL.DisplayStart),local.LoopIncrement))/>
						<cfif local.displayStop and local.day gt local.displayStop>
							<cfset LOCAL.day=LOCAL.To+1>
						</cfif>

					<cfelseif LOCAL.loopType eq 'weeklast'>
						<cfset local.day=dateAdd("m",1,LOCAL.Day)>
						<cfset LOCAL.Day=fix(GetLastDayOfWeekOfMonth(year(local.day),month(local.day),dayofWeek(LOCAL.DisplayStart)))/>
						<cfif local.displayStop and local.day gt local.displayStop>
							<cfset LOCAL.day=LOCAL.To+1>
						</cfif>

					<cfelse>
						<!--- Add one to the offset. --->
						
						<cfset LOCAL.Day = Fix( 
							DateAdd(
								LOCAL.LoopType,
								(LOCAL.Offset * LOCAL.LoopIncrement),
								LOCAL.From
								) 
							) />
					</cfif>

				</cfloop>
			</cfif>

			<cfif not local.found>
				<cfset local.deleteList=listAppend(local.deleteList,arguments.query.contentID)>
			</cfif>
		</cfif>
	</cfloop>

	<cfif len(local.deleteList)>
		<cfquery name="arguments.query" dbtype="query">
		select * from arguments.query where contentid not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.deleteList#">)
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
				from=createODBCDateTime(arguments.menuDate),
				to=createODBCDateTime(arguments.menuDate)
				)		
			/>					  	
		</cfcase>
		<cfcase value="CalendarMonth">
			<cfreturn apply(
				query=arguments.query,
				from=createODBCDateTime(createDate(year(arguments.menuDate),month(arguments.menuDate),1)),
				to=createODBCDateTime(createDate(year(arguments.menuDate),month(arguments.menuDate),daysInMonth(arguments.menuDate)))
				)		
			/>
		</cfcase>
		<cfcase value="ReleaseYear,CalendarYear"> 
			<cfreturn apply(
				query=arguments.query,
				from=createODBCDateTime(createDate(year(arguments.menuDate),1,1)),
				to=createODBCDateTime(createDate(year(arguments.menuDate),12,31))
				)		
			/>
		</cfcase>				
		<cfdefaultcase>
			<cfreturn arguments.query>
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction
	name="GetNthDayOfMonth"
	access="public"
	returntype="any"
	output="false"
	hint="I return the Nth instance of the given day of the week for the given month (ex. 2nd Sunday of the month).">
 
	<!--- Define arguments. --->

	<cfargument
		name="year"
		type="numeric"
		required="true"
		hint="I am the month for which we are gathering date information."
		/>

	<cfargument
		name="Month"
		type="numeric"
		required="true"
		hint="I am the month for which we are gathering date information."
		/>
 
	<cfargument
		name="DayOfWeek"
		type="numeric"
		required="true"
		hint="I am the day of the week (1-7) that we are locating."
		/>
 
	<cfargument
		name="Nth"
		type="numeric"
		required="false"
		default="1"
		hint="I am the Nth instance of the given day of the week for the given month."
		/>
 
	<!--- Define the local scope. --->
	<cfset var LOCAL = {} />
 
	<!---
		First, we need to make sure that the date we were given
		was actually the first of the month.
	--->
	<cfset LOCAL.Date = CreateDate(
		ARGUMENTS.Year,
		ARGUMENTS.Month,
		1
		) />

	<!---
		Now that we have the correct start date of the month, we
		need to find the first instance of the given day of the
		week.
	--->
	<cfif (DayOfWeek( LOCAL.Date ) LTE ARGUMENTS.DayOfWeek)>
 
		<!---
			The first of the month falls on or before the first
			instance of our target day of the week. This means we
			won't have to leave the current week to hit the first
			instance.
		--->
		<cfset LOCAL.Date = (
			LOCAL.Date +
			(ARGUMENTS.DayOfWeek - DayOfWeek( LOCAL.Date ))
			) />
 
	<cfelse>
 
		<!---
			The first of the month falls after the first instance
			of our target day of the week. This means we will
			have to move to the next week to hit the first target
			instance.
		--->
		<cfset LOCAL.Date = (
			LOCAL.Date +
			(7 - DayOfWeek( LOCAL.Date )) +
			ARGUMENTS.DayOfWeek
			) />
 
	</cfif>
 
 
	<!---
		At this point, our Date is the first occurrence of our
		target day of the week. Now, we have to navigate to the
		target occurence.
	--->
	<cfset LOCAL.Date += (7 * (ARGUMENTS.Nth - 1)) />
 
	<!---
		Return the given date. There is a chance that this date
		will be in the NEXT month of someone put in an Nth value
		that was too large for the current month to handle.
	--->
	<cfreturn DateFormat( LOCAL.Date ) />
</cffunction>

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
		hint="Any date in the given month we are going to be looking at."
		/>

	<cfargument
		name="month"
		type="numeric"
		required="true"
		hint="Any date in the given month we are going to be looking at."
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
	<cfset LOCAL.ThisMonth = CreateDate(
		ARGUMENTS.year,
		ARGUMENTS.month,
		1
		) />
 
	<!---
		Now, get the last day of the current month. We
		can get this by subtracting 1 from the first day
		of the next month.
	--->
	<cfset LOCAL.LastDay = (
		DateAdd( "m", 1, LOCAL.ThisMonth ) -
		1
		) />
 
	<!---
		Now, the last day of the month is part of the last
		week of the month. However, there is no guarantee
		that the target day of this week will be in the current
		month. Regardless, let's get the date of the target day
		so that at least we have something to work with.
	--->
	<cfset LOCAL.Day = (
		LOCAL.LastDay -
		DayOfWeek( LOCAL.LastDay ) +
		ARGUMENTS.DayOfWeek
		) />
 
 
	<!---
		Now, we have the target date, but we are not exactly
		sure if the target date is in the current month. if
		is not, then we know it is the first of that type of
		the next month, in which case, subracting 7 days (one
		week) from it will give us the last occurence of it in
		the current Month.
	--->
	<cfif (Month( LOCAL.Day ) NEQ Month( LOCAL.ThisMonth ))>
 
		<!--- Subract a week. --->
		<cfset LOCAL.Day = (LOCAL.Day - 7) />
 
	</cfif>
 
	<!--- Return the given day. --->
	<cfreturn DateFormat( LOCAL.Day ) />
</cffunction>


</cfcomponent>