/*
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
*/
/**
 * This provides resource bundle utility methods
 */
component extends="mura.cfobject" output="false" hint="This provides resource bundle utility methods" {
	variables.locale = "en_US";

	/**
	 * @return any
	 */
	public function init(required locale="en_US") output=false {
		if ( isValidLocale(arguments.locale)
		and !(not listLen(arguments.locale,"_") == 2 or
			  !len(listFirst(arguments.locale,"_")) == 2 or
			  !len(listLast(arguments.locale,"_")) == 2) ) {
			variables.locale=arguments.locale;
		}
		loadLocale();
		return this;
	}

	/**
	 * locale version of dateFormat
	 */
	public function dateLocaleFormat(required date date, string style="LONG") output=false {

		// hack to trap & fix varchar mystery goop coming out of mysql datetimes
		try {
			return variables.aDateFormat.getDateInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(arguments.date);
		}
		catch(Any e) {
			variables.aCalendar.setTime(arguments.date);
			return variables.aDateFormat.getDateInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(variables.aCalendar.getTime());
		}
	}

	/**
	 * Returns an array of locales.
	 */
	public array function getAvailableLocales() output=false {

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
	}

	/**
	 * Returns localized days
	 */
	public array function getLocalizedDays() output=false {

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
	}

	/**
	 * Returns localized month
	 */
	public function getLocalizedMonth(required numeric month) output=false {

		variables.sDateFormat.init("MMMM",variables.thisLocale);
		return variables.sDateFormat.format(createDate(1999,arguments.month,1));
	}

	/**
	 * Returns current locale name
	 */
	public function getLocalizedName() output=false {
		return variables.localeName;
	}

	/**
	 * Returns current locale
	 */
	public function getCurrentLocale() output=false {
		return variables.thisLocale;
	}

	/**
	 * Returns localized year, probably only useful for BE calendars like in thailand, etc.
	 */
	public function getLocalizedYear(required numeric thisYear) output=false {

		variables.sDateFormat.init("yyyy",variables.thisLocale);
		return variables.sDateFormat.init("yyyy",variables.thisLocale).format(createDate(arguments.thisYear,1,1));
	}

	public boolean function isBIDI() output=false {
		return listFind(variables.BIDILanguages,variables.lang);
	}

	/**
	 * Loads a locale.
	 */
	public function loadLocale() output=false {
		variables.lang = listFirst(variables.locale,"_");
		variables.country = listLast(variables.locale,"_");
		variables.BIDIlanguages="ar,he,fa,ps";
		//  couple more BIDI writing systems
		variables.thisLocale=createObject("java","java.util.Locale").init(variables.lang, variables.country);
		variables.localeName=variables.thisLocale.getDisplayName(variables.thisLocale);
		variables.aDateFormat=createObject("java","java.text.DateFormat");
		variables.sDateFormat=createObject("java","java.text.SimpleDateFormat");
		variables.aCalendar=createObject("java","java.util.GregorianCalendar").init(variables.thisLocale);
		variables.dateSymbols=createObject("java","java.text.DateFormatSymbols").init(variables.thisLocale);
		setJSDateKeys();
	}

	/**
	 * locale version of timeFormat
	 */
	public function timeLocaleFormat(required date date, string style="SHORT") output=false {

		// hack to trap & fix varchar mystery goop coming out of mysql datetimes
		try {
			return variables.aDateFormat.getTimeInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(arguments.date);
		}
		catch (Any e) {
			variables.aCalendar.setTime(arguments.date);
			return variables.aDateFormat.getTimeInstance(variables.aDateFormat[arguments.style],variables.thisLocale).format(variables.aCalendar.getTime());
		}
	}

	/**
	 * locale date/time format
	 */
	public function datetimeLocaleFormat(required date date, string dateStyle="SHORT", string timeStyle="SHORT") output=false {

		// hack to trap & fix varchar mystery goop coming out of mysql datetimes
		try {
			return variables.aDateFormat.getDateTimeInstance(variables.aDateFormat[arguments.dateStyle],variables.aDateFormat[arguments.timeStyle],variables.thisLocale).format(arguments.date);
		}
		catch (Any e) {
			variables.aCalendar.setTime(arguments.date);
			return variables.aDateFormat.getDateTimeInstance(variables.aDateFormat[arguments.dateStyle],variables.aDateFormat[arguments.timeStyle],variables.thisLocale).format(variables.aCalendar.getTime());
		}
	}

	public boolean function isValidLocale(required string thisLocale) output=false {

		var locales=arrayToList(getAvailableLocales());
		    return listFind(locales,arguments.thisLocale) gte 1;
	}

	/**
	 * Determines the first DOW
	 */
	public function weekStarts() output=false {

		return variables.aCalendar.getFirstDayOfWeek();
	}

	/**
	 * Switches Java locale to CF locale (for CF6)
	 */
	public function java2CF() output=false {
		switch ( variables.locale ) {
			case  "nl_BE":
				return "Dutch (Belgian)";
				break;
			case  "nl_NL":
				return "Dutch (Standard)";
				break;
			case  "en_AU":
				return "English (Australian)";
				break;
			case  "en_CA":
				return "English (Canadian)";
				break;
			case  "en_GB":
				return "English (UK)";
				break;
			case  "en_NZ":
				return "English (New Zealand)";
				break;
			case  "en_US":
				return "English (US)";
				break;
			default:
				return "English (US)";
				break;
			case  "fr_BE":
				return "French (Belgian)";
				break;
			case  "fr_CA":
				return "French (Canadian)";
				break;
			case  "fr_FR":
				return "French (Standard)";
				break;
			case  "fr_CH":
				return "French (Swiss)";
				break;
			case  "de_AT":
				return "German (Austrian)";
				break;
			case  "de_DE":
				return "German (Standard)";
				break;
			case  "de_CH":
				return "German (Swiss)";
				break;
			case  "it_IT":
				return "Italian (Standard)";
				break;
			case  "it_CH":
				return "Italian (Swiss)";
				break;
			case  "no_NO":
				return "Norwegian (Bokmal)";
				break;
			case  "no_NO@nynorsk":
				return "Norwegian (Nynorsk)";
				break;
			case  "pt_BR":
				return "Portuguese (Brazilian)";
				break;
			case  "pt_PT":
				return "Portuguese (Standard)";
				break;
			case  "es_MX":
				return "Spanish (Mexican)";
				break;
			case  "es_ES":
				return "Spanish (Standard)";
				break;
			case  "sv_SE":
				return "Swedish";
				break;
			case  "ja_JP":
				return "Japanese";
				break;
			case  "ko_KR":
				return "Korean";
				break;
			case  "zh_CN":
				return "Chinese (China)";
				break;
			case  "zh_HK":
				return "Chinese (Hong Kong)";
				break;
			case  "zh_TW":
				return "Chinese (Taiwan)";
				break;
		}
	}

	//Since these locales use unicode in their short date format they need to use the en versions
	variables.localeLookup={
		"zh-HK"={
			dtCh="-",
			dtFormat="1,0,2",
			dateKeyFormat="dd-mm-yyyy"
		},
		"zh-TW"={
			dtCh="/",
			dtFormat="2,0,1",
			dateKeyFormat="yyyy/mm/dd"
		},
		"ru"={
			dtCh=".",
			dtFormat="1,0,2",
			dateKeyFormat="dd.mm.yyyy"
		},
		"tr"={
			dtCh=".",
			dtFormat="1,0,2",
			dateKeyFormat="dd.mm.yyyy"
		},
		"uk"={
			dtCh="/",
			dtFormat="1,0,2",
			dateKeyFormat="dd/mm/yyyy"
		}
	};

	public function setJSDateKeys() output=false {
		//  make sure that a locale and language resouce bundle have been set in the users session
		var sessionData=getSession();
		if ( !isdefined('sessionData.locale') ) {
			sessionData.locale="en_US";
		}
		var targetLocale=replace(sessionData.locale,'_','-');
		variables.jsDateKey="";
		variables.dateKeyFormat="";
		variables.datekeyExample="";

		if(!structKeyExists(variables.localeLookup,targetLocale)){
			var f="";
			var dtCh="";
			var dtFormat="";
			var formatTest=LSDateFormat(createDate(2024,11,10),'short');

			//  now we create a date so we can parse it and figure out the date format and then create a date validation key
			if ( find(".",formatTest) ) {
				dtCh=	".";
			} else if ( find("-",formatTest) ) {
				dtCh=	"-";
			} else {
				dtCh=	"/";
			}
			dtFormat="";

			dtFormat=listAppend(dtFormat,listFind(formatTest,"11",dtCh) -1);
			dtFormat=listAppend(dtFormat,listFind(formatTest,"10",dtCh) -1);
			if ( listFind(formatTest,"2024",dtCh) ) {
				dtFormat=listAppend(dtFormat,listFind(formatTest,"2024",dtCh) -1);
			} else if ( listFind(formatTest,"24",dtCh) ) {
				dtFormat=listAppend(dtFormat,listFind(formatTest,"24",dtCh) -1);
			}

			for(f in ListToArray(formatTest,dtCh)){
				if ( listFind("2024,24",f) ) {
					variables.dateKeyFormat=listAppend(variables.dateKeyFormat,"YYYY",dtCh);
				} else if ( f == 11 ) {
					variables.dateKeyFormat=listAppend(variables.dateKeyFormat,"MM",dtCh);
				} else {
					variables.dateKeyFormat=listAppend(variables.dateKeyFormat,"DD",dtCh);
				}
			}

		} else {
				dtCh=	variables.localeLookup['#targetLocale#'].dtCh;
				dtFormat=	variables.localeLookup['#targetLocale#'].dtFormat;
				variables.dateKeyFormat=variables.localeLookup['#targetLocale#'].dateKeyFormat;
		}

		variables.datekeyExample=lsDateFormat(createDate(2024,11,10),variables.datekeyFormat);
		variables.jsDateKey='<script type="text/javascript">var dtExample="#variables.datekeyExample#", dtCh="#dtCh#", dtFormat =[#dtFormat#], dtLocale="#targetLocale#";</script>';
		variables.jsDateKeyObjInc='dtExample:"#variables.datekeyExample#",#chr(13)##chr(10)#dtCh:"#dtCh#",#chr(13)##chr(10)#dtFormat:[#dtFormat#],#chr(13)##chr(10)#dtLocale:"#targetLocale#"';
}

	public function getJsDateKeyObjInc() output=false {
		return variables.jsDateKeyObjInc;
	}

	public function getJSDateKey() output=false {
		return variables.JSDateKey;
	}

	public function getJSDateKeyFormat() output=false {
		return variables.datekeyFormat;
	}

	public function getJSDateKeyExample() output=false {
		return variables.datekeyExample;
	}

}
