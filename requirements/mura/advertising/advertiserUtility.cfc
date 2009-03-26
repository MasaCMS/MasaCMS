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

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" />
<cfargument name="advertiserGateway" type="any" />
<cfset variables.instance.configBean=arguments.configBean />
<cfset variables.instance.Gateway=arguments.advertiserGateway />
	<cfreturn this />
</cffunction>

<cffunction name="getReportDataByPlacement" returntype="void" output="false" access="public">
	<cfargument name="data" type="struct" />
	<cfargument name="PlacementBean" type="any" />
	<cfset var start ="" />
	<cfset var stop ="" />
	
	<cfparam name="arguments.data.date1" default="" />
	<cfparam name="arguments.data.date2" default="" />

	
	<!--- <cfset archiveTrackingForce(arguments.data.siteid) /> --->
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" name="request.rsdataImps"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	SELECT type,stathour, sum(counter) AS qty, Year(statDate) AS reportYear, Month(statDate) AS reportMonth, Max(statDate) AS LastEntered, Min(statDate) AS FirstEntered
	FROM tadstats
	WHERE placementid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PlacementBean.getPlacementID()#" />
	<cfif lsisdate(arguments.data.date1)>
		<cfset start=lsParseDateTime(arguments.data.date1)>
		and statdate >=#createodbcdatetime(createdatetime(year(start),month(start),day(start),0,0,0))#
	</cfif>
	<cfif lsisdate(arguments.data.date2)>
		<cfset stop=lsParseDateTime(arguments.data.date2)>
		and statDate <= #createodbcdatetime(createdatetime(year(stop),month(stop),day(stop),23,59,9))#
	</cfif>
	and ((Type)='Impression')
	GROUP BY Year(statdate), Month(statdate), Type, stathour
	ORDER BY Year(statdate) , Month(statdate), stathour;
	</cfquery>
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" name="request.rsdataClicks"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	SELECT type,stathour,sum(counter) AS qty, Year(statdate) AS reportYear, Month(statdate) AS reportMonth, Max(statdate) AS LastEntered, Max(statdate) AS FirstEntered
	FROM tadstats
	WHERE placementid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PlacementBean.getPlacementID()#" />
	<cfif lsisdate(arguments.data.date1)>
		<cfset start=lsParseDateTime(arguments.data.date1)>
		and statdate >=#createodbcdatetime(createdatetime(year(start),month(start),day(start),0,0,0))#
	</cfif>
	<cfif lsisdate(arguments.data.date2)>
		<cfset stop=lsParseDateTime(arguments.data.date2)>
		and statDate <= #createodbcdatetime(createdatetime(year(stop),month(stop),day(stop),23,59,9))#
	</cfif>
	and ((Type)='click')
	GROUP BY Year(statdate), Month(statdate), Type,stathour
	ORDER BY Year(statdate) , Month(statdate), stathour;
	</cfquery>
	
	<cfquery dbtype="query" name="request.rsTotalImps">
	select sum(qty) as total from request.rsdataImps
	</cfquery>
	
	<cfquery dbtype="query" name="request.rsTotalClicks">
	select sum(qty) as total from request.rsdataClicks
	</cfquery>
	
	

</cffunction>

<cffunction name="track" output="false" returntype="void">	
	<cfargument name="placementID" required="true" type="string">
	<cfargument name="type" required="true" type="string">
	<cfargument name="rate" required="true" type="numeric">
	
	<cfset var rsCheck="" />
	<cfset var statHour=hour(now())>
	<cfset var statDate=createDateTime(year(now()),month(now()),day(now()),0,0,0)>
	
	
		<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
		insert into tadstats (type,placementID,stathour,statdate,counter)
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementID#" />,
		#stathour#,
		#createODBCDatetime(statDate)#,
		1)
		</cfquery>
			
		<cftry>
		<cftransaction isolation="serializable">
			<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
			update tadplacements set billable=billable+#arguments.rate#
			where placementID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementID#" />
			</cfquery>
		</cftransaction>
		<cfcatch></cfcatch>
		</cftry>
		
			
	
</cffunction>

<cffunction name="compact" access="public" output="false" returntype="void" >
	<cfargument name="theDate" type="date"/>

	<cfset var rs=""/>
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select placementid,type,statdate,stathour,sum(counter) as Total from tadstats
	where date=#createodbcdate(arguments.thedate)#
	group by placementid,type,statdate,stathour
	</cfquery>
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadstats
	where date=#createodbcdate(arguments.thedate)#
	</cfquery>
	
	<cfloop query="rs">
		<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
		insert into tadstats (type,placementID,stathour,statdate,counter)
		values(
		'#rs.type#',
		'#rs.placementID#',
		#rs.stathour#,
		#createodbcdate(arguments.thedate)#,
		#rs.total#)
		</cfquery>
	</cfloop>

</cffunction>

<cffunction name="checkIPWhiteList" returntype="numeric" output="false" access="public">
	<cfargument name="IP" type="string" />
	<cfargument name="siteid" type="string" />

	<cfset var rs="" />
	<cfset var rsWhiteList=variables.instance.gateway.getIPWhiteListBySiteID(arguments.siteid) />
	
	<cfquery name="rs" dbtype="query"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select ip from rsWhiteList
	where ip=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IP#" />
	</cfquery>
	
	<cfreturn rs.recordcount />

</cffunction>

<cffunction name="updateIPWhiteListBySiteID" returntype="void" output="false" access="public">
	<cfargument name="IPWhiteList" type="string" />
	<cfargument name="siteid" type="string" />

	<cfset var ipList="" />
	<cfset var ip="" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadipwhitelist
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
	<cfset ipList = replace(arguments.IPWhiteList,chr(13)&chr(10),",","ALL")/>
	//now make Macintosh style into Unix style
	<cfset ipList = replace(ipList,chr(13),",","ALL")/>
	
	<cfloop list="#ipList#" index="ip">
		<cfif ip neq ''>
			<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
			insert into tadipwhitelist (ip,siteid) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip#" />,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
			</cfquery>
		</cfif>
	</cfloop>
	<cfobjectcache action="clear">
	
</cffunction>

</cfcomponent>