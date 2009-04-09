<cfcomponent output="false">
<cfset rbFactory=application.settingsManager.getSite(request.siteid).getRBFactory()>	
<cfscript>
weekdayShort=rbFactory.getKey('calendar.weekdayshort');
weekdayLong=rbFactory.getKey('calendar.weekdaylong');
monthShort=rbFactory.getKey('calendar.monthshort');
monthLong=rbFactory.getKey('calendar.monthlong');
</cfscript>
<cffunction name="getNavID"  output="false" returntype="numeric">
		<cfset var I = 0 />

		<cfloop from="1" to="#arrayLen(request.crumbdata)#" index="I">
		<cfif  request.crumbdata[I].type eq 'Portal'>
		<cfreturn I />
		</cfif>
		</cfloop>
		
		<cfreturn "" />
</cffunction>

<cffunction name="dspDay" output="true" returntype="string">
	<cfargument name="contentID" type="string"  default="">
	<cfargument name="today" type="date"  default="#now()#">
	<cfargument name="navPath" type="string"  default="">

	<cfset var rs = "">	
	<cfset var qrystr="?day=#day(arguments.today)#&month=#month(arguments.today)#&year=#year(arguments.today)#&filterBy=releaseDate">

	<cfquery name="rs" dbtype="query">
	select contentID from rsMonth where
					  (
					  	(releaseDate < #createodbcdate(dateadd("D",1,arguments.today))#
					  		AND releaseDate >= #createodbcdate(arguments.today)#) 
					  		
					  	OR 
					  	 ((releaseDate is Null or releaseDate ='')
					  		AND lastUpdate < #createodbcdate(dateadd("D",1,arguments.today))#
					  		AND lastUpdate >= #createodbcdate(arguments.today)#) 	 
					  	)
	</cfquery>
	
	<cfif rs.recordcount>
		<cfif len(request.sortBy)>
			<cfset qrystr="&sortBy=#request.sortBy#&sortDirection=#request.sortDirection#"/>
		</cfif>
		<cfif len(request.categoryID)>
			<cfset qrystr=qrystr & "&categoryID=#request.categoryID#"/>
		</cfif>
		<cfif len(request.relatedID)>
			<cfset qrystr=qrystr & "&relatedID=#request.relatedID#"/>
		</cfif>
		<cfif request.day eq day(arguments.today)>
		<cfreturn '<a href="#arguments.navPath##qrystr#" class="current">#day(arguments.today)#</a>' />
		<cfelse>
		<cfreturn '<a href="#arguments.navPath##qrystr#">#day(arguments.today)#</a>' />
		</cfif>
	<cfelse>
		<cfreturn "#day(arguments.today)#">
	</cfif>
	
</cffunction>


<cffunction name="setParams" output="false" returnType="void">
<cfargument name="_navMonth">
<cfargument name="_navDay">
<cfargument name="_navYear">
<cfargument name="_navID">
<cfargument name="_navPath">
<cfscript>
navMonth=arguments._navMonth;
navYear=arguments._navYear;
navDay=arguments._navDay;
navID=arguments._navID;
navPath=arguments._navPath;
selectedMonth = createDate(navYear,navMonth,1);
rsMonth=application.contentGateway.getKids('00000000000000000000000000000000000',request.siteid,navID,"ReleaseMonth",selectedMonth,0,'',0,"orderno","desc",request.categoryID,request.relatedID);
daysInMonth=daysInMonth(selectedMonth);
firstDayOfWeek=dayOfWeek(selectedMonth)-1;
previousMonth = navMonth-1;
nextMonth = navMonth+1;
nextYear = navYear;
previousYear=navYear;
if (previousMonth lte 0) {previousMonth=12;previousYear=previousYear-1;}
if (nextMonth gt 12) {nextMonth=1;nextYear=nextYear+1;}
dateLong = "#listGetAt(monthLong,navMonth,",")# #navYear#";
dateShort = "#listGetAt(monthShort,navMonth,",")# #navYear#";
</cfscript>
</cffunction>

<cffunction name="dspMonth" output="true">
<cfoutput>
<table>
<tr>
<th title="#dateLong#" id="previousMonth"><a href="#navPath#?month=#previousmonth#&year=#previousyear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#&filterBy=releaseMonth">&laquo;</a></th>
<th colspan="5"><a href="#navPath#?month=#navMonth#&year=#navYear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#&filterBy=releaseMonth">#dateLong#</a></th>
<th id="nextMonth"><a href="index.cfm?month=#nextmonth#&year=#nextyear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#&filterBy=releaseMonth">&raquo;</a></th>
</tr>
</tr>
	<tr class="dayofweek">
	<cfloop index="id" from="1" to="#listLen(weekdayShort)#">
	<cfset dayValue = listGetAt(weekdayShort,id,",")>
	<cfset dayValueLong = listGetAt(weekdayLong,id,",")>
	<td title="#dayValueLong#">#dayValue#</td>
	
	</cfloop>
	</tr>
	<cfset posn = 1>
	<tr>
	<cfloop index="id" from="1" to="#firstDayOfWeek#">
	<td>&nbsp;</td>
	<cfset posn=posn+1>
	</cfloop>
	<cfloop index="id" from="1" to="#daysInMonth#">
	<cfif posn eq 8></tr><cfif id lte daysInMonth><tr></cfif>
	<cfset posn=1></cfif>
	<td<cfif day(now()) eq id and navMonth eq month(now())> class="current"</cfif>>#dspDay(navID,createdate('#navYear#','#navMonth#','#id#'),navPath)#</td>
	<cfset posn=posn+1>
	</cfloop>
	<cfif posn lt 8>
	<cfloop index="id" from="#posn#" to="7">
	<td>&nbsp;</td>
	</cfloop>
	</cfif></tr>
	</table>
</cfoutput>
</cffunction>


</cfcomponent>


