<cfcomponent output="false">

<cffunction name="init" output="false">
	<cfargument name="MuraScope">
	<cfset $=arguments.MuraScope>
	<cfset rbFactory=application.settingsManager.getSite(request.siteid).getRBFactory()>
	<cfscript>
	weekdayShort=$.rbKey('calendar.weekdayshort');
	weekdayLong=$.rbKey('calendar.weekdaylong');
	monthShort=$.rbKey('calendar.monthshort');
	monthLong=$.rbKey('calendar.monthlong');
	</cfscript>

	<cfreturn this>
</cffunction>

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
	<cfset var qrystr="">

	<cfquery name="rs" dbtype="query">
	select contentID from rsMonth where
					<cfif navType eq "releaseMonth">
					  		(
						  		releaseDate < <cfqueryparam value="#dateadd('D',1,arguments.today)#" cfsqltype="CF_SQL_DATE">
						  		AND releaseDate >= <cfqueryparam value="#arguments.today#" cfsqltype="CF_SQL_DATE">
						 	)

						  	OR
						  	 (
						  	 	releaseDate is Null
						  		AND lastUpdate < <cfqueryparam value="#dateadd('D',1,arguments.today)#" cfsqltype="CF_SQL_DATE">
						  		AND lastUpdate >= <cfqueryparam value="#arguments.today#" cfsqltype="CF_SQL_DATE">
						  	)
					  <cfelse>
					 	DisplayStart < <cfqueryparam value="#dateadd('D',1,arguments.today)#" cfsqltype="CF_SQL_DATE">

						  	AND
						  		(
						  			DisplayStop >= <cfqueryparam value="#arguments.today#" cfsqltype="CF_SQL_DATE"> or DisplayStop =''
						  		)
					  </cfif>
	</cfquery>

	<cfif rs.recordcount>
		<cfif request.day eq day(arguments.today)>
		<cfreturn '<a href="#arguments.navPath#date/#year(arguments.today)#/#month(arguments.today)#/#day(arguments.today)#/#qrystr#" class="current">#day(arguments.today)#</a>' />
		<cfelse>
		<cfreturn '<a href="#arguments.navPath#date/#year(arguments.today)#/#month(arguments.today)#/#day(arguments.today)#/#qrystr#">#day(arguments.today)#</a>' />
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
<cfargument name="_navType">
<cfscript>
navMonth=arguments._navMonth;
navYear=arguments._navYear;
navDay=arguments._navDay;
navID=arguments._navID;
navPath=arguments._navPath;
navType=arguments._navType;
selectedMonth = createDate(navYear,navMonth,1);
rsMonth=$.getBean('contentGateway').getKids('00000000000000000000000000000000000',$.event('siteID'),navID,navType,selectedMonth,0,'',0,"orderno","desc",$.event('categoryID'),request.relatedID);
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
<cfset qrystr="">
<!---
<cfif len(request.sortBy) or len($.event('categoryID')) or len(request.relatedID)>
	<cfset qrystr="?">
</cfif>
<cfif len(request.sortBy)>
	<cfset qrystr="&sortBy=#request.sortBy#&sortDirection=#request.sortDirection#"/>
</cfif>
<cfif len($.event('categoryID'))>
	<cfset qrystr=qrystr & "&categoryID=#$.event('categoryID')#"/>
</cfif>
<cfif len(request.relatedID)>
	<cfset qrystr=qrystr & "&relatedID=#request.relatedID#"/>
</cfif>
--->
</cffunction>

<cffunction name="dspMonth" output="true">
<cfoutput>
<table class="table table-bordered">
<thead>
<tr>
<th title="#dateLong#" id="previousMonth"><a href="#navPath#date/#previousYear#/#previousMonth#/#qrystr#" rel=“nofollow”>&laquo;</a></th>
<th colspan="5"><a href="#navPath#date/#navYear#/#navmonth#/#qrystr#">#dateLong#</a></th>
<th id="nextMonth"><a href="#navPath#date/#nextyear#/#nextmonth#/#qrystr#" rel=“nofollow”>&raquo;</a></th>
</tr>
</tr>
	<tr class="dayofweek">
	<cfloop index="id" from="1" to="#listLen(weekdayShort)#">
	<cfset dayValue = listGetAt(weekdayShort,id,",")>
	<cfset dayValueLong = listGetAt(weekdayLong,id,",")>
	<td title="#dayValueLong#">#dayValue#</td>

	</cfloop>
	</tr>
</thead>
	<cfset posn = 1>
<tbody>
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
</tbody>
	</table>
</cfoutput>
</cffunction>


</cfcomponent>


