<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<div id="svCalendar" class="svCalendar">
<cfoutput>
<table>
<tr>
<th title="#HTMLEditFormat(dateLong)#" id="previousMonth"><a href="?month=#previousmonth#&year=#previousyear#&categoryID=#URLEncodedFormat(request.categoryID)#&relatedID=#URLEncodedFormat(request.relatedID)#">&laquo;</a></th>
<th colspan="5">#dateLong#</th>
<th id="nextMonth"><a href="?month=#nextmonth#&year=#nextyear#&categoryID=#URLEncodedFormat(request.categoryID)#&relatedID=#URLEncodedFormat(request.relatedID)#">&raquo;</a></th>
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
	<cfsilent>
	<cfset calendarDay=createdate('#request.year#','#request.month#','#id#')>
	<cfquery dbType="query" name="rsDay">
	select * from rsSection where 
		DisplayStart < <cfqueryparam value="#dateadd('D',1,calendarDay)#" cfsqltype="CF_SQL_DATE"> 
			AND 
				(
		 			DisplayStop >= <cfqueryparam value="#calendarDay#" cfsqltype="CF_SQL_DATE"> or DisplayStop =''
		  		)	
		order by DisplayStart
	</cfquery>
	</cfsilent>
	<td><span class="date">#id#</span>#dspNestedNav('#request.contentBean.getcontentid()#',1,1,'calendar',calendarDay,'','?month=#request.month#&year=#request.year#&categoryID=#request.categoryID#&relatedID=#request.relatedID#','displaystart, orderno','','#application.configBean.getContext()#','#application.configBean.getStub()#','#request.categoryID#','#request.relatedID#',rsDay)#</td>
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