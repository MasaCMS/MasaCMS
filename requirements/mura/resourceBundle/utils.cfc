<!---
	Name         :	utils.cfc
	Author       :	Paul Hastings, Raymond Camden 
	Created      :	October 29, 2003
	Last Updated :	11/30/06 (rkc)
					- added more BIDI languages in isBIDI method, tracking CLDR changes
					- cleaned up & fixed bugs in loadLocale where calendar, etc were init using server default locale
					- added hacks to cover datetime varchar goop coming out of mysql (instead of datetime object)
					- added getCurrentLocale() to show what locale is currently loaded
					- added datetimeLocaleFormat() to format date/time
	History      : Two fixes for BD compat (rkc 10/12/06)
				 : Java to cf locale mapping, thanks Tom J @ Adobe (rkc 10/30/06)
	Purpose		 :	Locale utils. Lots of help from Paul Hastings. Basically, since CF's locale funcs
					don't accept Java locales, I wrote these functions instead.
				   
				   Most of these methods operate on the current locale.
				   
				   To Do - handle converting from UTC to local time, modded by user pref TZ
--->
<cfcomponent extends="mura.cfobject" output="false">
<cfset variables.locale = "en_US">
	
	<cffunction name="init" return="any" output="false">
	<cfargument name="locale" required="true" default="en_US">

		<cfif isValidLocale(arguments.locale)
		and not (not listLen(arguments.locale,"_") is 2 or
			  not len(listFirst(arguments.locale,"_")) is 2 or
			  not len(listLast(arguments.locale,"_")) is 2)>
			<cfset variables.locale=arguments.locale />
		</cfif>
	
		<cfset loadLocale()>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="dateLocaleFormat"  returnType="string" output="false" hint="locale version of dateFormat">
		<cfargument name="date" type="date" required="true">
		<cfargument name="style" type="string" required="false" default="LONG">
		<cfscript>
		// hack to trap & fix varchar mystery goop coming out of mysql datetimes
		try {
			return variables.aDateFormat.getDateInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(arguments.date);
		}
		catch(Any e) {
			variables.aCalendar.setTime(arguments.date);
			return variables.aDateFormat.getDateInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(variables.aCalendar.getTime());
		}	
		</cfscript>
	</cffunction>

	<cffunction name="getAvailableLocales" access="public" returnType="array" output="false"
				hint="Returns an array of locales.">
		<cfscript>
		var i=0;
		var orgLocales=createObject("java","java.util.Locale").getAvailableLocales();
		var theseLocales=arrayNew(1);
		// we skip plain languages, en, fr, ar, etc.
		for (i=1; i LTE arrayLen(orgLocales); i=i+1) {
			if (listLen(orgLocales[i].toString(),"_") GT 1) {
			arrayAppend(theseLocales,orgLocales[i].toString());
			} // if
		} //for  
		return theseLocales;
		</cfscript>
	</cffunction>

	<cffunction name="getLocalizedDays" access="public" returnType="array" output="false"
				hint="Returns localized days">
		<cfscript>
		var localizedShortDays="";
		var i=0;
		var tmp=variables.dateSymbols.getShortWeekdays();
		// kludge java returns NULL first element in array so can't use arrayDeleteAt
		tmp=listToArray(arrayToList(tmp));
		// more kludge, fixup days to match week start
		switch (weekStarts()) {
			case 1:  //starts on sunday, just return day names
				localizedShortDays=tmp;
			break;

			case 2: // euro dates, starts on monday needs kludge
				localizedShortDays=arrayNew(1);
				localizedShortDays[7]=tmp[1]; //move sunday to last
				for (i=1; i LTE 6; i=i+1) {
					localizedShortDays[i]=tmp[i+1];
				}
			break;
			
			case 7: // starts saturday, usually arabic, needs kludge
				localizedShortDays=arrayNew(1);
				localizedShortDays[1]=tmp[7]; //move saturday to first
				for (i=1; i LTE 6; i=i+1) {
					localizedShortDays[i+1]=tmp[i];	
				}
			break;
		}
		return localizedShortDays;
		</cfscript>
	</cffunction>
	
	<cffunction name="getLocalizedMonth" access="public" returnType="string" output="false"
				hint="Returns localized month">
		<cfargument name="month" type="numeric" required="true">
		<cfscript>		
		variables.sDateFormat.init("MMMM",variables.thisLocale);
		return variables.sDateFormat.format(createDate(1999,arguments.month,1));
		</cfscript>
		
	</cffunction>

	<cffunction name="getLocalizedName" access="public" returnType="string" output="false"
				hint="Returns current locale name">
		<cfreturn variables.localeName>
	</cffunction>
	
	<cffunction name="getCurrentLocale" access="public" returnType="string" output="false"
				hint="Returns current locale">
		<cfreturn variables.thisLocale>
	</cffunction>

	<cffunction name="getLocalizedYear" access="public" returnType="string" output="false"
				hint="Returns localized year, probably only useful for BE calendars like in thailand, etc.">
		<cfargument name="thisYear" type="numeric" required="true">
		<cfscript>
		variables.sDateFormat.init("yyyy",variables.thisLocale);
		return variables.sDateFormat.init("yyyy",variables.thisLocale).format(createDate(arguments.thisYear,1,1));
		</cfscript>
	</cffunction>

	<cffunction name="isBIDI" access="public" returnType="boolean" output="false">
		<cfreturn listFind(variables.BIDILanguages,variables.lang)>
	</cffunction>
	
	<cffunction name="loadLocale" access="public" returnType="void" output="false"
				hint="Loads a locale.">
		
		<cfset variables.lang = listFirst(variables.locale,"_")>
		<cfset variables.country = listLast(variables.locale,"_")>
		
		<cfset variables.BIDIlanguages="ar,he,fa,ps"><!--- couple more BIDI writing systems --->
		<cfset variables.thisLocale=createObject("java","java.util.Locale").init(variables.lang, variables.country)>
		<cfset variables.localeName=variables.thisLocale.getDisplayName(variables.thisLocale)>
		<cfset variables.aDateFormat=createObject("java","java.text.DateFormat")>
		<cfset variables.sDateFormat=createObject("java","java.text.SimpleDateFormat")>
		<cfset variables.aCalendar=createObject("java","java.util.GregorianCalendar").init(variables.thisLocale)>
		<cfset variables.dateSymbols=createObject("java","java.text.DateFormatSymbols").init(variables.thisLocale)>
		<cfset setJSDateKeys()>
	</cffunction>

	<cffunction name="timeLocaleFormat" access="public" returnType="string" output="false"
				hint="locale version of timeFormat">
		<cfargument name="date" type="date" required="true">
		<cfargument name="style" type="string" required="false" default="SHORT">
		<cfscript>
		// hack to trap & fix varchar mystery goop coming out of mysql datetimes
		try {
			return variables.aDateFormat.getTimeInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(arguments.date);
		}
		catch (Any e) {
			variables.aCalendar.setTime(arguments.date);
			return variables.aDateFormat.getTimeInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(variables.aCalendar.getTime());
		}	
		</cfscript>		
	</cffunction>

	<cffunction name="datetimeLocaleFormat" access="public" returnType="string" output="false"
				hint="locale date/time format">
		<cfargument name="date" type="date" required="true">
		<cfargument name="dateStyle" type="string" required="false" default="SHORT">
		<cfargument name="timeStyle" type="string" required="false" default="SHORT">
		<cfscript>
		// hack to trap & fix varchar mystery goop coming out of mysql datetimes
		try {
			return variables.aDateFormat.getDateTimeInstance(variables.aDateFormat[arguments.dateStyle],variables.aDateFormat[arguments.timeStyle],variables.thisLocale).format(arguments.date);
		}
		catch (Any e) {
			variables.aCalendar.setTime(arguments.date);
			return variables.aDateFormat.getDateTimeInstance(variables.aDateFormat[arguments.dateStyle],variables.aDateFormat[arguments.timeStyle],variables.thisLocale).format(variables.aCalendar.getTime());
		}	
		</cfscript>
	</cffunction>

	<cffunction name="isValidLocale" access="public" returnType="boolean" output="false">
		<cfargument name="thisLocale" type="string" required="true">   
		<cfscript>
		    var locales=arrayToList(getAvailableLocales());
		    return listFind(locales,arguments.thisLocale) gte 1;
		</cfscript>
	</cffunction> 
	
	<cffunction name="weekStarts" access="public" returnType="string" output="false"
				hint="Determines the first DOW">
		<cfscript>
		return variables.aCalendar.getFirstDayOfWeek();
		</cfscript>
	</cffunction>
	
	<cffunction name="java2CF" access="public" returnType="string" output="false" hint="Switches Java locale to CF locale (for CF6)">
		
		<cfswitch expression="#variables.locale#">

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
	
	<cffunction name="setJSDateKeys" output="false" returntype="any">
	<!--- make sure that a locale and language resouce bundle have been set in the users session --->	
	<cfset var f="">
	<cfset var dtCh="">
	<cfset var dtFormat="">
	<cfset var formatTest=LSDateFormat(createDate(2018,11,10),'short')/>
	<cfset variables.jsDateKey="">
	<cfset variables.dateKeyFormat="">
	<cfset variables.datekeyExample="">
	
	<!--- now we create a date so we can parse it and figure out the date format and then create a date validation key --->

	<cfif find(".",formatTest)>
		<cfset dtCh=	"."/>
	<cfelseif find("-",formatTest)>
		<cfset dtCh=	"-"/>
	<cfelse>
		<cfset dtCh=	"/"/>
	</cfif>
	<cfset dtFormat=""/>
	
	<cfloop list="#formatTest#" index="f" delimiters="#dtCh#">
		<cfif listFind("2018,18",f)>	
			<cfset variables.dateKeyFormat=listAppend(variables.dateKeyFormat,"YYYY",dtCh)>
		<cfelseif f eq 11>
			<cfset variables.dateKeyFormat=listAppend(variables.dateKeyFormat,"MM",dtCh)>
		<cfelse>
			<cfset variables.dateKeyFormat=listAppend(variables.dateKeyFormat,"DD",dtCh)>
		</cfif>
	</cfloop>
	
	<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"11",dtCh) -1) />
	<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"10",dtCh) -1) />
	<cfif listFind(formatTest,"2018",dtCh)>
		<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"2018",dtCh) -1) />
	<cfelseif listFind(formatTest,"18",dtCh)>
		<cfset dtFormat=listAppend(dtFormat,listFind(formatTest,"18",dtCh) -1) />
	</cfif>
	
	<cfset variables.datekeyExample=lsDateFormat(createDate(2018,11,10),variables.datekeyFormat)/>
	
	<cfif not isdefined('session.locale')>
		<cfset session.locale="en_US">
	</cfif>
	
	<cfsavecontent variable="variables.jsDateKey">
	<cfoutput><script type="text/javascript">
	var dtExample="#variables.datekeyExample#";
	var dtCh="#dtCh#";
	var dtFormat =[#dtFormat#];
	var dtLocale="#replace(session.locale,'_','-')#";
	</script></cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="variables.jsDateKeyObjInc">
	<cfoutput>
	dtExample:"#variables.datekeyExample#",
	dtCh:"#dtCh#",
	dtFormat:[#dtFormat#],
	dtLocale:"#replace(session.locale,'_','-')#"
	</cfoutput>
	</cfsavecontent>

	</cffunction>

	<cffunction name="getJsDateKeyObjInc" output="false" returntype="any">
	<cfreturn variables.jsDateKeyObjInc>
	</cffunction>

	<cffunction name="getJSDateKey" output="false" returntype="any">
	<cfreturn variables.JSDateKey>
	</cffunction>
	
	<cffunction name="getJSDateKeyFormat" output="false" returntype="any">
	<cfreturn variables.datekeyFormat>
	</cffunction>
	
	<cffunction name="getJSDateKeyExample" output="false" returntype="any">
	<cfreturn variables.datekeyExample>
	</cffunction>
</cfcomponent>

