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
<cfcomponent output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>

<cfset variables.datasource=arguments.configBean.getDatasource() />
<cfset variables.dbUsername=arguments.configBean.getDbUsername() />
<cfset variables.dbPassword=arguments.configBean.getDbPassword() />
<cfset variables.clearHistory=arguments.configBean.getClearSessionHistory() />
<cfset variables.sessionHistory=arguments.configBean.getSessionHistory() />
<cfset variables.trackSessionInNewThread=arguments.configBean.getTrackSessionInNewThread()>
<cfset variables.longRequests=0>
<cfset variables.lastPurge=now()>
	
<cfreturn this />
</cffunction>

<cffunction name="trackRequest" output="false">
	<cfargument name="remote_addr" type="string" required="yes"/>
	<cfargument name="script_name" type="string" required="yes"/>
	<cfargument name="query_string" type="string" required="yes"/>
	<cfargument name="server_name" type="string" required="yes"/>
	<cfargument name="referer" type="string" required="yes" default=""/>
	<cfargument name="user_agent" type="string" required="yes" default=""/>
	<cfargument name="keywords" type="string" required="yes" default="" />
	<cfargument name="urlToken" type="string" required="yes"/>
	<cfargument name="UserID" type="string" required="yes"/>
	<cfargument name="siteID" type="string" required="yes"/>
	<cfargument name="contentID" type="string" required="yes"/>
	<cfargument name="locale" type="string" required="yes"/>
	<cfargument name="originalURLToken" type="string" required="yes"/>

	<cfset var $ = createObject("component","mura.MuraScope") />

	<cfif trim(arguments.referer) eq ''>
		<cfset arguments.referer='Unknown' />
	<cfelseif findNoCase(arguments.server_name,arguments.referer)>
		<cfset arguments.referer="Internal" />
	</cfif>
	
	<!---
	<cfif arguments.user_agent neq ''>
		<cfset arguments.user_agent=arguments.user_agent />
	</cfif>
	--->

	<cfset $.init(duplicate(arguments))>
	<cfset $.announceEvent("onSiteSessionTrack")>

	<cfif variables.trackSessionInNewThread>
		<cflock name="MuraSessionTracking#application.instanceID#" timeout="5">
			<cfthread action="run" name="MuraSessionTracking#application.utility.getUUID()#" context="#arguments#" priority="low">
				<cfset createTrackingRecord(argumentCollection=context)>
			</cfthread>
		</cflock>
	<cfelse>
		 <cfset createTrackingRecord(argumentCollection=arguments)>
	</cfif>
</cffunction>

<cffunction name="createTrackingRecord" output="false">
	<cfargument name="remote_addr" type="string" required="yes"/>
	<cfargument name="script_name" type="string" required="yes"/>
	<cfargument name="query_string" type="string" required="yes"/>
	<cfargument name="server_name" type="string" required="yes"/>
	<cfargument name="referer" type="string" required="yes" default=""/>
	<cfargument name="user_agent" type="string" required="yes" default=""/>
	<cfargument name="keywords" type="string" required="yes" default="" />
	<cfargument name="urlToken" type="string" required="yes"/>
	<cfargument name="UserID" type="string" required="yes"/>
	<cfargument name="siteID" type="string" required="yes"/>
	<cfargument name="contentID" type="string" required="yes"/>
	<cfargument name="locale" type="string" required="yes"/>
	<cfargument name="originalURLToken" type="string" required="yes"/>

	<cfset arguments.language = 'Unknown' />
	<cfset arguments.country ='Unknown' />
	<cfset arguments.startCount =GetTickCount()>

	<cfset application.scriptProtectionFilter.scan(
					object=arguments,
					objectname="arguments",
					ipAddress=arguments.remote_addr,
					useWordFilter=true,
					useSQLFilter=false,
					useTagFilter=true)>
			
	<cftry>
		<cfquery>
			INSERT INTO tsessiontracking (REMOTE_ADDR,SCRIPT_NAME,QUERY_STRING,SERVER_NAME,URLToken,UserID,siteID,
				country,lang,locale, contentID, referer,keywords,user_agent,Entered,originalURLToken)
			values (
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.REMOTE_ADDR#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.SCRIPT_NAME,200)#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.QUERY_STRING#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.SERVER_NAME,50)#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.URLToken,130)#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" null="#iif(arguments.userid neq '',de('no'),de('yes'))#" value="#arguments.userid#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" null="#iif(arguments.siteid neq '',de('no'),de('yes'))#" value="#arguments.siteid#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.country#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.language#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.locale#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" null="#iif(arguments.contentid neq '',de('no'),de('yes'))#" value="#arguments.contentid#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.referer,255)#" />,
				<cfqueryparam  cfsqltype="cf_sql_varchar" null="#iif(arguments.keywords neq '',de('no'),de('yes'))#" value="#left(arguments.keywords,200)#"/>,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.user_agent,200)#"/>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.originalURLToken,130)#" />
			)	
		</cfquery>
			
		<cfcatch></cfcatch>
	</cftry>
			
			
	<cfset clearOldData(argumentCollection=arguments)/>
	
	<cfset arguments.duration=GetTickCount()-arguments.startCount>
			
	<cfif arguments.duration gt 5000>
		<cfset variables.longRequests=variables.longRequests+1>
	<cfelse>
		<cfset variables.longRequests=0>
	</cfif>
			
	<cfif variables.longRequests gt 20>
		<cfset application.sessionTrackingThrottle=true>
	 </cfif>
			
</cffunction>

<cffunction name="clearOldData" returnType="void" access="public">
	<cfset var requestTime=now()>
	
	<cfif variables.clearHistory
		and dateDiff("s", variables.lastPurge,requestTime) gte 60>
		
       	<cfset variables.lastPurge = requestTime>
		
		<cfquery datasource="#variables.datasource#" username="#variables.dbUsername#" password="#variables.dbPassword#">
		delete from tsessiontracking 
		where entered <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d',-variables.sessionHistory,now())#">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="deleteSession" access="public" returntype="void">
	<cfargument name="URLToken" type="string" required="yes"/>
	<cfquery>
	delete from tsessiontracking 
	where urlToken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.urlToken#" />
	</cfquery>

</cffunction>

</cfcomponent>