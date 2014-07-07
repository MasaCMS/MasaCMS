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
	<cfparam name="session.remote_addr" default="#request.remoteAddr#">
	<cfparam name="session.trackingID" default="#createUUID()#">
	
	<cfif application.configBean.getSessionHistory() 
		and application.configBean.getDashboard() 
		and not application.sessionTrackingThrottle>

		<cfif session.remote_addr eq request.remoteAddr>
			<cfif cgi.HTTP_USER_AGENT neq 'vspider'>
				
				<!---<cftry>--->
				<cfset variables.sessionTrackingDAO.trackRequest(session.REMOTE_ADDR,
																		arguments.SCRIPT_NAME,
																		cgi.QUERY_STRING,
																		listFirst(cgi.http_host,":"),
																		cgi.HTTP_REFERER,
																		cgi.USER_AGENT,
																		arguments.keywords,
																		session.trackingID,
																		session.mura.userID,
																		arguments.siteid,
																		arguments.contentid,
																		getCFLocale( trim( replace( listFirst( listFirst(cgi.HTTP_ACCEPT_LANGUAGE,';') ),"-","_") ) ),
																		cookie.originalURLToken,
																		session.mura.fname,
																		session.mura.lname,
																		session.mura.company
																		)/>
				<!---<cfcatch><cfreturn ""/></cfcatch></cftry>--->
			</cfif>
			<cfreturn ""/>
		<cfelse>
			<cfreturn "killSession"/>
		</cfif>
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
		
		<cfif len(arguments.javalocale)>
			<cfreturn arguments.javalocale>
		<cfelse>
			<cfparam name="session.rb" default="en">
			<cfreturn application.rbFactory.getKeyValue(session.rb,'dashboard.session.unknown')>
		</cfif>
			
		<!---
		<cfswitch expression="#arguments.javalocale#">

			<cfcase value="nl_BE">
				<cfreturn "Dutch (Belgian)">
			</cfcase>

			<cfcase value="nl_NL">
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

			<cfcase value="es_ES">
				<cfreturn "Spanish (Modern)">
			</cfcase>
			
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
			
			<cfcase value="arabic">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (united arab emirates)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (bahrain)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (algeria)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (egypt)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (iraq)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (jordan)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (kuwait)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (lebanon)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (libya)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (morocco)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (oman)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (qatar)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (saudi arabia)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (sudan)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (syria)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (tunisia)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="arabic (yemen)">
					<cfreturn "ar">
			</cfcase>

			<cfcase value="hindi (india)">
					<cfreturn "hi_IN">
			</cfcase>

			<cfcase value="hebrew">
					<cfreturn "iw_IL">
			</cfcase>

			<cfcase value="hebrew (israel)">
					<cfreturn "iw_IL">
			</cfcase>

			<cfcase value="japanese (japan)">
					<cfreturn "ja_JP">
			</cfcase>

			<cfcase value="korean (south korea)">
					<cfreturn "ko_KY">
			</cfcase>

			<cfcase value="thai">
					<cfreturn "vi_VN">
			</cfcase>

			<cfcase value="thai (thailand)">
					<cfreturn "vi_VN">
			</cfcase>

			<cfcase value="vietnamese">
					<cfreturn "vi_VN">
			</cfcase>

			<cfcase value="vietnamese (vietnam)">
					<cfreturn "vi_VN">
			</cfcase>

			<cfcase value="chinese">
					<cfreturn "ch_CN">
			</cfcase>

			<cfcase value="belarusian">
					<cfreturn "be_BY">
			</cfcase>

			<cfcase value="belarusian (belarus)">
					<cfreturn "be_BY">
			</cfcase>

			<cfcase value="bulgarian">
					<cfreturn "bg_BG">
			</cfcase>

			<cfcase value="bulgarian (bulgaria)">
					<cfreturn "bg_BG">
			</cfcase>

			<cfcase value="catalan">
					<cfreturn "ca_ES">
			</cfcase>

			<cfcase value="catalan (spain)">
					<cfreturn "ca_ES">
			</cfcase>

			<cfcase value="czech">
					<cfreturn "cs_CZ">
			</cfcase>

			<cfcase value="czech (czech republic)">
					<cfreturn "cs_CZ">
			</cfcase>

			<cfcase value="danish">
					<cfreturn "da_DK">
			</cfcase>

			<cfcase value="danish (denmark)">
					<cfreturn "da_DK">
			</cfcase>

			<cfcase value="german">
					<cfreturn "de_DE">
			</cfcase>

			<cfcase value="german (austria)">
					<cfreturn "de_AT">
			</cfcase>

			<cfcase value="german (switzerland)">
					<cfreturn "de_CH">
			</cfcase>

			<cfcase value="german (germany)">
					<cfreturn "de_DE">
			</cfcase>

			<cfcase value="german (luxembourg)">
					<cfreturn "de_LU">
			</cfcase>

			<cfcase value="greek">
					<cfreturn "el_GR">
			</cfcase>

			<cfcase value="greek (greece)">
					<cfreturn "el_GR">
			</cfcase>

			<cfcase value="english (australia)">
					<cfreturn "en_AU">
			</cfcase>

			<cfcase value="english (canada)">
					<cfreturn "en_CA">
			</cfcase>

			<cfcase value="english (united kingdom)">
					<cfreturn "en_GB"> 
			</cfcase>

			<cfcase value="english (ireland)">
					<cfreturn "en_IE">
			</cfcase>

			<cfcase value="english (india)">
					<cfreturn "en_IN">
			</cfcase>

			<cfcase value="english (south africa)">
					<cfreturn "en_ZA">
			</cfcase>

			<cfcase value="spanish">
					<cfreturn "es_ES">
			</cfcase>

			<cfcase value="spanish (argentina)">
					<cfreturn "es_BO">
			</cfcase>

			<cfcase value="spanish (bolivia)">
					<cfreturn "es_UY">
			</cfcase>

			<cfcase value="spanish (chile)">
					<cfreturn "es_CL">
			</cfcase>

			<cfcase value="spanish (colombia)">
					<cfreturn "es_CO">
			</cfcase>

			<cfcase value="spanish (costa rica)">
					<cfreturn "es_CR">
			</cfcase>

			<cfcase value="spanish (dominican republic)">
					<cfreturn "es_DO">
			</cfcase>

			<cfcase value="spanish (ecuador)">
					<cfreturn "es_EC">
			</cfcase>

			<cfcase value="spanish (spain)">
					<cfreturn "es_ES">
			</cfcase>

			<cfcase value="spanish (guatemala)">
					<cfreturn "es_GT">
			</cfcase>

			<cfcase value="spanish (honduras)">
					<cfreturn "es_HN">
			</cfcase>

			<cfcase value="spanish (mexico)">
					<cfreturn "es_MX">
			</cfcase>

			<cfcase value="spanish (nicaragua)">
					<cfreturn "es_NI">
			</cfcase>

			<cfcase value="spanish (panama)">
					<cfreturn "es_PA">
			</cfcase>

			<cfcase value="spanish (peru)">
					<cfreturn "es_PE">
			</cfcase>

			<cfcase value="spanish (puerto rico)">
					<cfreturn "es_PR">
			</cfcase>

			<cfcase value="spanish (paraguay)">
					<cfreturn "es_PY">
			</cfcase>

			<cfcase value="spanish (el salvador)">
					<cfreturn "es_SV">
			</cfcase>

			<cfcase value="spanish (uruguay)">
				<cfreturn "es_UY">
			</cfcase>

			<cfcase value="spanish (venezuela)">
				<cfreturn "es_VE">
			</cfcase>

			<cfcase value="estonian">
				<cfreturn "et_EE">
			</cfcase>

			<cfcase value="estonian (estonia)">
				<cfreturn "et_EE">
			</cfcase>

			<cfcase value="finnish">
				<cfreturn "fi_FI">
			</cfcase>

			<cfcase value="finnish (finland)">
				<cfreturn "fi_FI">
			</cfcase>

			<cfcase value="french">
				<cfreturn "fr_FR">
			</cfcase>

			<cfcase value="french (belgium)">
				<cfreturn "fr_BE">
			</cfcase>

			<cfcase value="french (canada)">
				<cfreturn "fr_CA">
			</cfcase>

			<cfcase value="french (switzerland)">
				<cfreturn "fr_CH">
			</cfcase>

			<cfcase value="french (france)">
				<cfreturn "fr_FR">
			</cfcase>

			<cfcase value="french (luxembourg)">
				<cfreturn "fr_LU">
			</cfcase>

			<cfcase value="croatian">
				<cfreturn "hr_HR">
			</cfcase>

			<cfcase value="croatian (croatia)">
				<cfreturn "hr_HR">
			</cfcase>

			<cfcase value="hungarian">
				<cfreturn "hu_HU">
			</cfcase>

			<cfcase value="hungarian (hungary)">
				<cfreturn "hu_HU">
			</cfcase>

			<cfcase value="icelandic">
				<cfreturn "is_IS">
			</cfcase>

			<cfcase value="icelandic (iceland)">
				<cfreturn "is_IS">
			</cfcase>

			<cfcase value="italian">
				<cfreturn "it_IT">
			</cfcase>

			<cfcase value="italian (switzerland)">
				<cfreturn "it_CH">
			</cfcase>

			<cfcase value="italian (italy)">
				<cfreturn "it_IT">
			</cfcase>

			<cfcase value="lithuanian">
				<cfreturn "lt_LT">
			</cfcase>

			<cfcase value="lithuanian (lithuania)">
				<cfreturn "lt_LT">
			</cfcase>

			<cfcase value="latvian">
				<cfreturn "lv_LV">
			</cfcase>

			<cfcase value="latvian (latvia)">
				<cfreturn "lv_LV">
			</cfcase>

			<cfcase value="macedonian">
				<cfreturn "mk_MK">
			</cfcase>

			<cfcase value="macedonian (macedonia)">
				<cfreturn "mk_MK">
			</cfcase>

			<cfcase value="dutch">
				<cfreturn "nl_BE">
			</cfcase>

			<cfcase value="dutch (belgium)">
				<cfreturn "nl_BE">
			</cfcase>

			<cfcase value="dutch (netherlands)">
				<cfreturn "nl_BE">
			</cfcase>

			<cfcase value="norwegian">
				<cfreturn "no_NO_NY">
			</cfcase>

			<cfcase value="norwegian (norway)">
				<cfreturn "no_NO_NY">
			</cfcase>

			<cfcase value="polish">
				<cfreturn "pl_PL">
			</cfcase>

			<cfcase value="polish (poland)">
				<cfreturn "pl_PL">
			</cfcase>

			<cfcase value="portuguese">
				<cfreturn "pt_PT">
			</cfcase>

			<cfcase value="portuguese (brazil)">
				<cfreturn "pt_BR">
			</cfcase>

			<cfcase value="portuguese (portugal)">
				<cfreturn "pt_PT">
			</cfcase>

			<cfcase value="romanian">
				<cfreturn "ro_RO">
			</cfcase>

			<cfcase value="romanian (romania)">
				<cfreturn "ro_RO">
			</cfcase>

			<cfcase value="russian">
				<cfreturn "ru_RU">
			</cfcase>

			<cfcase value="russian (russia)">
				<cfreturn "ru_RU">
			</cfcase>

			<cfcase value="slovak">
				<cfreturn "sk_SK">
			</cfcase>

			<cfcase value="slovak (slovakia)">
				<cfreturn "sk_SK">
			</cfcase>

			<cfcase value="slovenian">
				<cfreturn "sl_SI">
			</cfcase>

			<cfcase value="slovenian (slovenia)">
				<cfreturn "sl_SI">
			</cfcase>

			<cfcase value="albanian">
				<cfreturn "sq_AL">
			</cfcase>

			<cfcase value="albanian (albania)">
				<cfreturn "sq_AL">
			</cfcase>

			<cfcase value="serbian">
				<cfreturn "sh_YU">
			</cfcase>

			<cfcase value="serbian (bosnia and herzegovina)">
				<cfreturn "sh_YU">
			</cfcase>

			<cfcase value="serbian (serbia and montenegro)">
				<cfreturn "sh_YU">
			</cfcase>

			<cfcase value="swedish (sweden)">
				<cfreturn "sv_SE">
			</cfcase>

			<cfcase value="turkish">
				<cfreturn "tr_TR">
			</cfcase>

			<cfcase value="turkish (turkey)">
				<cfreturn "tr_TR">
			</cfcase>

			<cfcase value="ukrainian">
				<cfreturn "uk_UA">
			</cfcase>

			<cfcase value="ukrainian (ukraine)">
				<cfreturn "uk_UA">
			</cfcase>

			<cfcase value="english (united states)">
				<cfreturn "en_US">
			</cfcase>

			<cfcase value="english">
				<cfreturn "en_US">
			</cfcase>
			
			<cfdefaultcase>
				<cfparam name="session.rb" default="en">
				<cfreturn application.rbFactory.getKeyValue(session.rb,'dashboard.session.unknown')>
			</cfdefaultcase>
				
		</cfswitch>
		--->
</cffunction>

</cfcomponent>