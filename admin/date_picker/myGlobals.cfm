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

<cfparam name="URL.month" default="#month(now())#">
<cfparam name="URL.year" default="#year(now())#">
<cfparam name="URL.day" default="#day(now())#">

<cfscript>
currentDate=now();
selectedMonth = createDate(URL.year,URL.month,1);
daysInMonth=daysInMonth(selectedMonth);
firstDayOfWeek=dayOfWeek(selectedMonth)-1;
weekdayShort="S,M,T,W,T,F,S";
weekdayLong="Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday";
monthShort="Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sept,Oct,Nov,Dec";
monthLong="January,February,March,April,May,June,July,August,September,October,November,December";
dateLong = "#listGetAt(monthLong,URL.month,",")# #URL.year#";
dateShort = "#listGetAt(monthShort,URL.month,",")# #URL.year#";
previousMonth = URL.month-1;
nextMonth = URL.month+1;
nextYear = URL.year;
previousYear=URL.year;
if (previousMonth lte 0) {previousMonth=12;previousYear=previousYear-1;}
if (nextMonth gt 12) {nextMonth=1;nextYear=nextYear+1;}
</cfscript>
