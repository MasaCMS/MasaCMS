<!---
	This file is part of Mura CMS.

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
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
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
variables.firstDayOfWeek=dayOfWeek(variables.selectedMonth)-application.rbFactory.getResourceBundle(session.rb).getUtils().weekStarts();
if (variables.firstDayOfWeek<0) {variables.firstDayOfWeek+=7;}
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
<table class="#$.getSiteRenderer().getNavCalendarTableClass()#" summary="Calendar Navigation">
<thead>
<tr>
<th title="#dateLong#" id="previousMonth"><a href="#navPath#date/#previousYear#/#previousMonth#/#qrystr#" rel="nofollow">&laquo;</a></th>
<th colspan="5" id="nav-calendar-month-year"><a href="#navPath#date/#navYear#/#navmonth#/#qrystr#">#dateLong#</a></th>
<th id="nextMonth"><a href="#navPath#date/#nextyear#/#nextmonth#/#qrystr#" rel="nofollow">&raquo;</a></th>
</tr>
</tr>
	<tr class="dayofweek">
	<cfloop index="id" from="1" to="#listLen(weekdayShort)#">
	<cfset dayValue = listGetAt(weekdayShort,id,",")>
	<cfset dayValueLong = listGetAt(weekdayLong,id,",")>
	<th title="#dayValueLong#" id="nav-calendar-#dayValueLong#">#dayValue#</th>

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
	<td headers="nav-calendar-month-year nav-calendar-#DateFormat("#navmonth#/#id#/#navYear#","dddd")#"<cfif day(now()) eq id and navMonth eq month(now())>
class="current"</cfif>>#dspDay(navID,createdate('#navYear#','#navMonth#','#id#'),navPath)#</td>
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


