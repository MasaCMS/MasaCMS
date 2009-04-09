<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfparam name="request.month" default="#month(now())#">
<cfparam name="request.year" default="#year(now())#">
<cfparam name="request.day" default="#day(now())#">
<cfset rbFactory=getSite().getRBFactory()>
<cfscript>
currentDate=now();
selectedMonth = createDate(request.year,request.month,1);
daysInMonth=daysInMonth(selectedMonth);
firstDayOfWeek=dayOfWeek(selectedMonth)-1;
weekdayShort=rbFactory.getKey('calendar.weekdayshort');
weekdayLong=rbFactory.getKey('calendar.weekdaylong');
monthShort=rbFactory.getKey('calendar.monthshort');
monthLong=rbFactory.getKey('calendar.monthlong');
dateLong = "#listGetAt(monthLong,request.month,",")# #request.year#";
dateShort = "#listGetAt(monthShort,request.month,",")# #request.year#";
previousMonth = request.month-1;
nextMonth = request.month+1;
nextYear = request.year;
previousYear=request.year;
if (previousMonth lte 0) {previousMonth=12;previousYear=previousYear-1;}
if (nextMonth gt 12) {nextMonth=1;nextYear=nextYear+1;}
</cfscript>
