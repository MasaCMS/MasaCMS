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

<div id="svCalendar">
<cfoutput>
<table>
<th title="#dateLong#" id="previousMonth"><a href="index.cfm?month=#previousmonth#&year=#previousyear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#">&laquo;</a></th>
<th colspan="5">#dateLong#</th>
<th id="nextMonth"><a href="index.cfm?month=#nextmonth#&year=#nextyear#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#">&raquo;</a></th>
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
	<td><span class="date">#id#</span>#dspNestedNav('#request.contentBean.getcontentid()#',1,1,'calendar',createdate('#request.year#','#request.month#','#id#'),'','?month=#request.month#&year=#request.year#&categoryID=#request.categoryID#&relatedID=#request.relatedID#','displaystart, orderno','','#application.configBean.getContext()#','#application.configBean.getStub()#','#request.categoryID#','#request.relatedID#')#</td>
	<cfset posn=posn+1>
	</cfloop>
	<cfif posn lt 8>
	<cfloop index="id" from="#posn#" to="7">
	<td>&nbsp;</td>
	</cfloop>
	</cfif></tr>
	</table>
</cfoutput>
</div>