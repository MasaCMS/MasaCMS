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

<cfsilent>

	<cfif not application.configBean.getSessionHistory() or application.configBean.getSessionHistory() gte 30>
			<cfparam name="attributes.span" default="30">
	<cfelse>
			<cfparam name="attributes.span" default="#application.configBean.getSessionHistory()#">
	</cfif>

	<cfparam name="attributes.threshold" default="1">
	
	<!--- <cfswitch expression="#attributes.span#">
	<cfcase value="Week">
	<cfset attributes.stopDate=LSDateFormat(now(),session.dateKeyFormat)/>
	<cfset attributes.startDate=LSDateFormat(dateAdd("ww",-1,now()),session.dateKeyFormat) />
	<cfset spanType="ww" />
	<cfset spanUnits=1 />
	</cfcase>
	<cfcase value="Month">
	<cfset attributes.stopDate=LSDateFormat(now(),session.dateKeyFormat)/>
	<cfset attributes.startDate=LSDateFormat(dateAdd("m",-1,now()),session.dateKeyFormat) />
	<cfset spanType="m" />
	<cfset spanUnits=1 />
	</cfcase>
	<cfcase value="Quarter">
	<cfset attributes.stopDate=LSDateFormat(now(),session.dateKeyFormat)/>
	<cfset attributes.startDate=LSDateFormat(dateAdd("m",-3,now()),session.dateKeyFormat) />
	<cfset spanType="ww" />
	<cfset spanUnits=3 />
	</cfcase>
	<cfcase value="Year">
	<cfset attributes.stopDate=LSDateFormat(now(),session.dateKeyFormat)/>
	<cfset attributes.startDate=LSDateFormat(dateAdd("yyyy",-1,now()),session.dateKeyFormat) />
	<cfset spanType="yyyy" />
	<cfset spanUnits=1 />
	</cfcase>
	</cfswitch> --->

	<cfset attributes.stopDate=LSDateFormat(now(),session.dateKeyFormat)/>
	<cfset attributes.startDate=LSDateFormat(dateAdd("d",-attributes.span,now()),session.dateKeyFormat) />
	<cfset spanType="d" />
	<cfset spanUnits=attributes.span />
	<cfset session.dashboardSpan=attributes.span />
</cfsilent>