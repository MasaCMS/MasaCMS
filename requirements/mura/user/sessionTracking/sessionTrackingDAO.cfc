<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">
<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>

<cfset variables.configBean=arguments.configBean />
<cfset variables.settingsManager=arguments.settingsManager />
<cfset variables.dsn=variables.configBean.getDatasource()/>
<cfreturn this />
</cffunction>

<cffunction name="trackRequest" access="public" returntype="void">
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


<cfset var theReferer='Internal' />
<cfset var theUserAgent='Unknown' />
<cfset var language = 'Unknown' />
<cfset var country ='Unknown' />

<cfif trim(arguments.referer) eq ''>
	<cfset theReferer='Unknown' />
<cfelseif not findNoCase(listFirst(cgi.http_host,":"),arguments.referer)>
	<cfset theReferer=arguments.referer />
</cfif>

<cfif arguments.user_agent neq ''>
<cfset theUserAgent=arguments.user_agent />
</cfif>

<cftry>
<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
	<cfqueryparam  cfsqltype="cf_sql_varchar" value="#country#" />,
	<cfqueryparam  cfsqltype="cf_sql_varchar" value="#language#" />,
	<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.locale#" />,
	<cfqueryparam  cfsqltype="cf_sql_varchar" null="#iif(arguments.contentid neq '',de('no'),de('yes'))#" value="#arguments.contentid#" />,
	<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(theReferer,255)#" />,
	<cfqueryparam  cfsqltype="cf_sql_varchar" null="#iif(arguments.keywords neq '',de('no'),de('yes'))#" value="#left(arguments.keywords,200)#"/>,
	<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(theUserAgent,200)#"/>,
	#createODBCDateTime(now())#,
	<cfqueryparam  cfsqltype="cf_sql_varchar" value="#left(arguments.originalURLToken,130)#" />
)

</cfquery>
<cfcatch></cfcatch>
</cftry>

	<cfset clearOldData()/>
	
</cffunction>

<cffunction name="clearOldData" returnType="void" access="public">
		
	<cfif variables.configBean.getSessionHistory() gt 0>
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tsessiontracking 
	where entered <  #createODBCDateTime(dateAdd('d',-variables.configBean.getSessionHistory(),now()))#
	</cfquery>
	</cfif>
</cffunction>

<cffunction name="deleteSession" access="public" returntype="void">
<cfargument name="URLToken" type="string" required="yes"/>
<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
delete from tsessiontracking 
where urlToken=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.urlToken#" />
</cfquery>

</cffunction>

</cfcomponent>