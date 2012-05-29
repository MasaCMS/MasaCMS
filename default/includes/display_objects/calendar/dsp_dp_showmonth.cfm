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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<div id="svCalendar" class="svCalendar">
<cfoutput>
<table class="table table-bordered">
<thead>
<tr>
<th title="#HTMLEditFormat(variables.datelong)#" id="variables.previousMonth"><a href="?month=#variables.previousMonth#&year=#variables.previousYear#&categoryID=#URLEncodedFormat(variables.$.event('categoryID'))#&relatedID=#URLEncodedFormat(request.relatedID)#" rel=“nofollow”>&laquo;</a></th>
<th colspan="5">#variables.datelong#</th>
<th id="variables.nextmonth"><a href="?month=#variables.nextmonth#&year=#variables.nextyear#&categoryID=#URLEncodedFormat(variables.$.event('categoryID'))#&relatedID=#URLEncodedFormat(request.relatedID)#" rel=“nofollow”>&raquo;</a></th>
</tr>
	<tr class="dayofweek">
	<cfloop index="variables.id" from="1" to="#listLen(variables.weekdayshort)#">
	<cfset variables.dayvalue = listGetAt(variables.weekdayshort,variables.id,",")>
	<cfset variables.dayvaluelong = listGetAt(variables.weekdaylong,variables.id,",")>
	<td title="#variables.dayvaluelong#">#variables.dayvalue#</td>
	
	</cfloop>
	</tr></thead>
	<cfset variables.posn = 1>
	<tbody>
	<tr>
	<cfloop index="variables.id" from="1" to="#variables.firstDayOfWeek#">
	<td>&nbsp;</td>
	<cfset variables.posn=variables.posn+1>
	</cfloop>
	<cfloop index="variables.id" from="1" to="#variables.daysInMonth#">
	<cfif variables.posn eq 8></tr><cfif variables.id lte variables.daysInMonth><tr></cfif>
	<cfset variables.posn=1></cfif>
	<cfsilent>
	<cfset variables.calendarDay=createdate('#request.year#','#request.month#','#variables.id#')>
	<cfquery dbType="query" name="variables.rsDay">
	select * from variables.rssection where 
		DisplayStart < <cfqueryparam value="#dateadd('D',1,variables.calendarDay)#" cfsqltype="CF_SQL_DATE"> 
			AND 
				(
		 			DisplayStop >= <cfqueryparam value="#variables.calendarDay#" cfsqltype="CF_SQL_DATE"> or DisplayStop =''
		  		)	
		order by DisplayStart
	</cfquery>
	</cfsilent>
	<td><span class="date">#variables.id#</span>#dspNestedNav('#variables.$.content('contentID')#',1,1,'calendar',variables.calendarDay,'','?month=#request.month#&year=#request.year#&categoryID=#variables.$.event('categoryID')#&relatedID=#request.relatedID#','displaystart, orderno','','#variables.$.globalConfig('context')#','#variables.$.globalConfig('stub')#','#variables.$.event('categoryID')#','#request.relatedID#',variables.rsDay)#</td>
	<cfset variables.posn=variables.posn+1>
	</cfloop>
	<cfif variables.posn lt 8>
	<cfloop index="variables.id" from="#variables.posn#" to="7">
	<td>&nbsp;</td>
	</cfloop>
	</cfif></tr>
</tbody>
	</table>
</cfoutput>
</div>