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
<cfset variables.resourceBundles=structNew() />
<cfset variables.parentFactory=""/>
<cfset variables.resourceDirectory=""/>
<cfset variables.configBean="" />
<cfset variables.settingsManager="" />
<cfset variables.locale="" />

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="parentFactory" type="any" required="true" default="">
	<cfargument name="resourceDirectory" type="any" required="true" default="">
	<cfargument name="locale" type="any" required="true" default="en_us">
	
	<cfset variables.parentFactory = arguments.parentFactory />
	<cfset variables.locale = arguments.locale />
	<cfset variables.configBean=getBean("configBean") />
	<cfset variables.settingsManager=getBean("settingsManager") />

	<cfif not len(arguments.resourceDirectory)>
		<cfset variables.resourceDirectory=getDirectoryFromPath(getCurrentTemplatePath()) & "resources/"  />
	<cfelse>
		<cfset variables.resourceDirectory=arguments.resourceDirectory  />
	</cfif>

	<cfreturn this />
</cffunction>

<cffunction name="getResourceBundle" returntype="any" access="public" output="false">
<cfargument name="locale"  type="string" required="true" default="#variables.locale#">


	<cfif not structKeyExists(variables.resourceBundles,"#arguments.locale#")>
		<cfset variables.resourceBundles["#arguments.locale#"]=createObject("component","mura.resourceBundle.resourceBundle").init(arguments.locale,variables.resourceDirectory) />
	</cfif>	

	<cfreturn variables.resourceBundles["#arguments.locale#"] />
	

</cffunction>

<cffunction name="getUtils" returntype="any" access="public" output="false">
<cfargument name="locale"  type="string" required="true" default="#variables.locale#">

	<cfreturn getResourceBundle(arguments.locale).getUtils().init(arguments.locale) />
	
</cffunction>

<cffunction name="getKeyValue" returnType="String" output="false">
	<cfargument name="locale" required="true" default="#variables.locale#">
	<cfargument name="key">
	<cfargument name="useMuraDefault" type="boolean" required="true" default="false">

	<cfset var keyValue=getResourceBundle(arguments.locale).getKeyValue(arguments.key,true) />

	<cfif keyValue neq "muraKeyEmpty">
		<cfreturn keyValue />
	<cfelseif isObject(variables.parentFactory)>
		<cfset keyValue=variables.parentFactory.getKeyValue(arguments.locale,arguments.key,true) />
		<cfif keyValue neq "muraKeyEmpty">
			<cfreturn keyValue />
		</cfif>	
	</cfif>
	
	<cfif arguments.locale neq "en_US">
		<cfset keyValue = getResourceBundle("en_US").getKeyValue(arguments.key,true) />
	 
		<cfif keyValue neq "muraKeyEmpty">
			<cfreturn keyValue />
		<cfelseif isObject(variables.parentFactory)>
			<cfset keyValue=variables.parentFactory.getKeyValue(arguments.locale,arguments.key,true) />
			<cfif keyValue neq "muraKeyEmpty">
				<cfreturn keyValue />
			</cfif>
		</cfif>
	</cfif>
	
	<cfif arguments.useMuraDefault>
		<cfreturn "muraKeyEmpty">
	<cfelse>
		<cfreturn arguments.key & "_missing" />
	</cfif>
</cffunction>

<cffunction name="getKey" returnType="String" output="false">
	<cfargument name="key">
	
	<cfreturn getKeyValue(variables.locale,arguments.key)>

</cffunction>

<cffunction name="CF2Java" access="public" returnType="string" output="false" hint="Switches Java locale to CF locale (for CF6)">
		<cfargument name="cflocale" type="string" required="false" default="#variables.lang#_#variables.country#">
		
		<cfset var testLocale=trim(arguments.cflocale)>
		
		<cfif testLocale eq "Server">
			<cfset testLocale=getLocale()>
		</cfif>
		
		<cfswitch expression="#testLocale#">

			<cfcase value="Dutch (Belgian)">
				<cfreturn "nl_BE">
			</cfcase>

			<cfcase value="Dutch (Standard)">
				<cfreturn "nl_NL">
			</cfcase>

			<cfcase value="English (Australian)">
				<cfreturn "en_AU">
			</cfcase>

			<cfcase value="English (Canadian)">
				<cfreturn "en_CA">
			</cfcase>

			<cfcase value="English (UK)">
				<cfreturn "en_GB">
			</cfcase>

			<cfcase value="English (New Zealand)">
				<cfreturn "en_NZ">
			</cfcase>
		
			<cfcase value="English (US)">
				<cfreturn "en_US">
			</cfcase>

			<cfcase value="French (Belgian)">
				<cfreturn "fr_BE">
			</cfcase>

			<cfcase value="French (Canadian)">
				<cfreturn "fr_CA">
			</cfcase>

			<cfcase value="French (Standard)">
				<cfreturn "fr_FR">
			</cfcase>

			<cfcase value="French (Swiss)">
				<cfreturn "fr_CH">
			</cfcase>

			<cfcase value="German (Austrian)">
				<cfreturn "de_AT">
			</cfcase>

			<cfcase value="German (Standard)">
				<cfreturn "de_DE">
			</cfcase>

			<cfcase value="German (Swiss)">
				<cfreturn "de_CH">
			</cfcase>

			<cfcase value="Italian (Standard)">
				<cfreturn "it_IT">
			</cfcase>

			<cfcase value="Italian (Swiss)">
				<cfreturn "it_CH">
			</cfcase>

			<cfcase value="Norwegian (Bokmal)">
				<cfreturn "no_NO">
			</cfcase>

			<cfcase value="Norwegian (Nynorsk)">
				<cfreturn "no_NO@nynorsk">
			</cfcase>

			<cfcase value="Portuguese (Brazilian)">
				<cfreturn "pt_BR">
			</cfcase>

			<cfcase value="Portuguese (Standard)">
				<cfreturn "pt_PT">
			</cfcase>

			<cfcase value="Spanish (Mexican)">
				<cfreturn "es_MX">
			</cfcase>

			<cfcase value="Spanish (Modern)">
				<cfreturn "es_ES">
			</cfcase>
			
			<cfcase value="Spanish (Standard)">
				<cfreturn "es_ES">
			</cfcase>

			<cfcase value="Swedish">
				<cfreturn "sv_SE">
			</cfcase>

			<cfcase value="Japanese">
				<cfreturn "ja_JP">
			</cfcase>

			<cfcase value="Korean">
				<cfreturn "ko_KR">
			</cfcase>

			<cfcase value="Chinese (China)">
				<cfreturn "zh_CN">
			</cfcase>

			<cfcase value="Chinese (Hong Kong)">
				<cfreturn "zh_HK">
			</cfcase>

			<cfcase value="Chinese (Taiwan)">
				<cfreturn "zh_TW">
			</cfcase>
			
			<!--- Railo --->
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
				<!--- it's probably already a java locale'--->
				<cfif not len(testLocale)>
					<cfreturn getLocale()>
				<cfelse>
					<cfreturn testLocale>
				</cfif>
			</cfdefaultcase>
				
		</cfswitch>
</cffunction>

<cffunction name="setAdminLocale" returnType="void" output="false">
<cfargument name="mySession" required="true" default="#session#">
<cfset var utils="">
<!--- make sure that a locale and language resouce bundle have been set in the users session --->

<cfif not structKeyExists(arguments.mySession,"dateKey")>
	<cfset arguments.mySession.dateKey="">
</cfif>
<cfif not structKeyExists(arguments.mySession,"dateKeyformat")>
	<cfset arguments.mySession.dateKeyformat="">
</cfif>
<cfif not structKeyExists(arguments.mySession,"rb")>
	<cfset arguments.mySession.rb="">
</cfif>
<cfif not structKeyExists(arguments.mySession,"locale")>
	<cfset arguments.mySession.locale="">
</cfif>

<!---  session.rb is used to tell mura what resource bundle to use for lan translations --->
<cfif not Len(arguments.mySession.rb)>
	<cfif application.configBean.getDefaultLocale() neq "Server">
		<cfif application.configBean.getDefaultLocale() eq "Client">
			<cfset arguments.mySession.rb=listFirst(cgi.HTTP_ACCEPT_LANGUAGE,';') />		
		<cfelse>
			<cfif listFind(server.coldfusion.supportedlocales,application.configBean.getDefaultLocale())>
				<cfset arguments.mySession.rb=application.configBean.getDefaultLocale() />
			<cfelse>
				<cfset arguments.mySession.rb=application.rbFactory.CF2Java(application.configBean.getDefaultLocale()) />
			</cfif>
		</cfif>
	<cfelse>

		<cfset arguments.mySession.rb=application.rbFactory.CF2Java(getLocale()) />
	</cfif>
</cfif>


<!--- session.locale  is the locale that mura uses for date formating --->
<cfif not len(arguments.mySession.locale)>
	<cfif application.configBean.getDefaultLocale() neq "Server">
		<cfif application.configBean.getDefaultLocale() eq "Client">
			<cfset arguments.mySession.locale=listFirst(cgi.HTTP_ACCEPT_LANGUAGE,';') />
			<cfset arguments.mySession.dateKey=""/>
			<cfset arguments.mySession.dateKeyFormat=""/>		
		<cfelse>
			<cfset arguments.mySession.locale=application.configBean.getDefaultLocale() />
			<cfset arguments.mySession.dateKey=""/>
		</cfif>
	<cfelse>

		<cfset arguments.mySession.locale=getLocale() />
		<cfset arguments.mySession.dateKey=""/>
		<cfset arguments.mySession.dateKeyFormat=""/>
	</cfif>
</cfif>

<!--- set locale for current page request --->
<cfset setLocale(mySession.locale) />

<!--- now we create a date so we can parse it and figure out the date format and then create a date validation key --->
<cfif not len(arguments.mySession.dateKey) or not len(arguments.mySession.dateKeyFormat)>
	<cfset utils=getUtils(arguments.mySession.locale)>
	<cfset arguments.mySession.dateKey=utils.getJSDateKey()>
	<cfset arguments.mySession.dateKeyFormat=utils.getJSDateKeyFormat()>
</cfif>

<cfset arguments.mySession.localeHasDayParts=findNoCase('AM',LSTimeFormat(createTime(0,0,0),  'medium'))>

</cffunction>

<cffunction name="resetSessionLocale" output="false">
<cfargument name="mySession" required="true" default="#session#">
	<cfset arguments.mySession.locale=application.settingsManager.getSite(arguments.mySession.siteID).getJavaLocale() />
	<cfset arguments.mySession.localeHasDayParts=true>
	<cfset arguments.mySession.dateKey=""/>
	<cfset arguments.mySession.dateKeyFormat=""/>
	<cfset setAdminLocale(arguments.mySession)>
</cffunction>

</cfcomponent>

