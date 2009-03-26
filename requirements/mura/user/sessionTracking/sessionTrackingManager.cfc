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
<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="sessionTrackingDAO" type="any" required="yes"/>
<cfargument name="sessionTrackingGateway" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfset variables.settingsManager=arguments.settingsManager />
<cfset variables.sessionTrackingDAO=arguments.sessionTrackingDAO />
<cfset variables.sessionTrackingGateway=arguments.sessionTrackingGateway />
<cfreturn this />
</cffunction>

<cffunction name="trackRequest" access="public" returntype="string">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="script_name" type="string" required="yes" default="#cgi.SCRIPT_NAME#">
	<cfargument name="keywords" type="string" required="yes" default="">
	<cfargument name="contentID" type="string" required="yes" default="">
	<cfset var myURLToken="" />
	<cfparam name="session.remote_addr" default="#cgi.REMOTE_ADDR#">
	<cfparam name="session.trackingID" default="#createUUID()#">
	
	<cfif session.remote_addr eq cgi.REMOTE_ADDR>
		<cfif cgi.HTTP_USER_AGENT neq 'vspider'>
			
			<cftry>
			<cfset variables.sessionTrackingDAO.trackRequest(session.REMOTE_ADDR,
																	arguments.SCRIPT_NAME,
																	cgi.QUERY_STRING,
																	cgi.SERVER_NAME,
																	cgi.HTTP_REFERER,
																	cgi.USER_AGENT,
																	arguments.keywords,
																	session.trackingID,
																	iif(getAuthUser() neq '',de('#listfirst(getAuthUser(),"^")#'),de('')),
																	arguments.siteid,
																	arguments.contentid,
																	getCFLocale(listFirst(cgi.HTTP_ACCEPT_LANGUAGE,';')),
																	cookie.originalURLToken
																	)/>
			<cfcatch><cfreturn ""/></cfcatch></cftry>
		</cfif>
		<cfreturn ""/>
	<cfelse>
		<cfreturn "killSession"/>
	</cfif>
	

</cffunction>

<cffunction name="getSessionData" access="public" returntype="query">
	<cfargument name="urlToken" type="string" default="">

	<cfreturn variables.sessionTrackingGateway.getSessionHistory(arguments.urlToken) />

</cffunction>

<cffunction name="getSiteSessions" access="public" returntype="query" output="false">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="contentid" required="yes" type="string" default="">

	<cfreturn variables.sessionTrackingGateway.getSiteSessions(arguments.siteid,arguments.contentid) />

</cffunction>

<cffunction name="getTopContent" access="public" returntype="query">
	<cfargument name="siteid" type="string" default="">
	<cfargument name="limit" type="numeric" required="yes" default="10">

	<cfreturn variables.sessionTrackingGateway.getTopContent(arguments.siteid,arguments.limit) />

</cffunction>

<cffunction name="deleteSession" access="public" returntype="void">
<cfargument name="URLToken" type="string" required="yes"/>

<cfset variables.sessionTrackingDAO.deleteSession(arguments.URLToken) />

</cffunction>

<cffunction name="getSiteSessionCount" access="public" returntype="numeric" output="false">
	<cfargument name="siteid" type="string" default="">

	<cfreturn variables.sessionTrackingGateway.getSiteSessionCount(arguments.siteid) />

</cffunction>

<cffunction name="isUserOnline" access="public" returntype="numeric">
	<cfargument name="userID" type="string" required="true" default="">
		
	<cfreturn variables.sessionTrackingGateway.isUserOnline(arguments.userID) />

</cffunction>

<!--- Author:Paul Hastings, Raymond Camden --->
<cffunction name="getCFLocale" access="public" returnType="string" output="false" hint="Switches Java locale to CF locale (for CF6)">
		<cfargument name="javalocale" type="string" required="false" default="#variables.lang#_#variables.country#">
		
		<cfswitch expression="#arguments.javalocale#">

			<cfcase value="nl_BE">
				<cfreturn "Dutch (Belgian)">
			</cfcase>

			<cfcase value="nl_NK">
				<cfreturn "Dutch (Standard)">
			</cfcase>

			<cfcase value="en_AU">
				<cfreturn "English (Australian)">
			</cfcase>

			<cfcase value="en_CA">
				<cfreturn "English (Canadian)">
			</cfcase>

			<cfcase value="en_GB">
				<cfreturn "English (UK)">
			</cfcase>

			<cfcase value="en_NZ">
				<cfreturn "English (New Zealand)">
			</cfcase>
		
			<cfcase value="en_US">
				<cfreturn "English (US)">
			</cfcase>
			
			<cfdefaultcase>
				<cfreturn "English (US)">
			</cfdefaultcase>

			<cfcase value="fr_BE">
				<cfreturn "French (Belgian)">
			</cfcase>

			<cfcase value="fr_CA">
				<cfreturn "French (Canadian)">
			</cfcase>

			<cfcase value="fr_FR">
				<cfreturn "French (Standard)">
			</cfcase>

			<cfcase value="fr_CH">
				<cfreturn "French (Swiss)">
			</cfcase>

			<cfcase value="de_AT">
				<cfreturn "German (Austrian)">
			</cfcase>

			<cfcase value="de_DE">
				<cfreturn "German (Standard)">
			</cfcase>

			<cfcase value="de_CH">
				<cfreturn "German (Swiss)">
			</cfcase>

			<cfcase value="it_IT">
				<cfreturn "Italian (Standard)">
			</cfcase>

			<cfcase value="it_CH">
				<cfreturn "Italian (Swiss)">
			</cfcase>

			<cfcase value="no_NO">
				<cfreturn "Norwegian (Bokmal)">
			</cfcase>

			<cfcase value="no_NO@nynorsk">
				<cfreturn "Norwegian (Nynorsk)">
			</cfcase>

			<cfcase value="pt_BR">
				<cfreturn "Portuguese (Brazilian)">
			</cfcase>

			<cfcase value="pt_PT">
				<cfreturn "Portuguese (Standard)">
			</cfcase>

			<cfcase value="es_MX">
				<cfreturn "Spanish (Mexican)">
			</cfcase>

			<!--- Only support Spanish Standard
			<cfcase value="es_ES">
				<cfreturn "Spanish (Modern)">
			</cfcase>
			--->
			<cfcase value="es_ES">
				<cfreturn "Spanish (Standard)">
			</cfcase>

			<cfcase value="sv_SE">
				<cfreturn "Swedish">
			</cfcase>

			<cfcase value="ja_JP">
				<cfreturn "Japanese">
			</cfcase>

			<cfcase value="ko_KR">
				<cfreturn "Korean">
			</cfcase>

			<cfcase value="zh_CN">
				<cfreturn "Chinese (China)">
			</cfcase>

			<cfcase value="zh_HK">
				<cfreturn "Chinese (Hong Kong)">
			</cfcase>

			<cfcase value="zh_TW">
				<cfreturn "Chinese (Taiwan)">
			</cfcase>
				
		</cfswitch>
</cffunction>

</cfcomponent>