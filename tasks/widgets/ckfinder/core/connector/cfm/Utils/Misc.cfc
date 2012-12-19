<cfcomponent>
<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2012, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cffunction name="getErrorMessage"  access="public" returntype="String" output="true">
<cfargument name="number" type="numeric" required="true" />
<cfargument name="arg" type="string" required="false" default="" />
<cfscript>
var langCode = "en";
var errorMessage = "";

if (isDefined('URL.langCode') and Refind("^[a-z-]+$", URL.langCode)) {
	if (fileexists(ExpandPath(REQUEST.constants.CKFINDER_CONNECTOR_LANG_PATH & "/" & URL.langCode & ".cfm"))) {
		langCode = URL.langCode;
	}
}
</cfscript>
<cfinclude template="../#REQUEST.constants.CKFINDER_CONNECTOR_LANG_PATH#/#langCode#.cfm">
<cfif number>
<cfparam name="CKFLang.Errors[#number#]" default="">
<cfif Len(CKFLang.Errors[number])>
	<cfset errorMessage = Replace(CKFLang.Errors[number], "%1", arg)>
<cfelse>
	<cfset errorMessage = Replace(CKFLang.ErrorUnknown, "%1", number)>
</cfif>
</cfif>
<cfreturn errorMessage/>
</cffunction>

<cffunction name="trimChar" access="public" returntype="String" output="false"
hint="Trim char from the beginning and end of the string">
<cfargument name="string" type="string" required="true" />
<cfargument name="char" type="String" required="true" />
<cfscript>
	var length = len(char);
	if (len(string) gte length) {
		if ( right(string,length) eq char) {
			string = mid(string, length, len(string)-length);
		}
		if ( left(string,length) eq char) {
			string = mid(string, 1+length, len(string)-length);
		}
	}
</cfscript>
<cfreturn string />
</cffunction>

<cffunction access="public" name="encodeUriComponent" output="false" returntype="string" hint="The clone of the JavaScript function">
<cfargument name="string" type="string" required="yes">
<cfset string = replacelist(URLEncodedFormat(string), "%2D,%2E,%5F,%7E,%21,%2A,%27,%28,%29", "-,.,_,~,!,*,',(,)")>
<cfreturn string />
</cffunction>

<cffunction name="date2Timestamp" access="public" returntype="String" output="false" hint="Convert date to UNIX timestamp" >
   <cfargument name="cfdate" type="Date" required="true" />
   <cfset var result = dateDiff('s',createDate(1970,1,1), ARGUMENTS.cfdate) />
   <cfreturn result />
</cffunction>

<!---
 * Function that converts HTTPTimeString format to ColdFusion TimeStamp format.
 * Returns a string in Cold Fusion Time Stamp format.
 *
 * @author Mosh Teitelbaum (mosh.teitelbaum@evoch.com)
 * @version 1, October 23, 2002
--->
<cffunction name="httpTimeStringToTimestamp" access="public" returntype="String">
	<cfargument name="httpTimeString" hint="A datetime in the format: ddd, dd mmm yyyy hh:mm:ss GMT">

	<cfscript>
	  var tsParts = ListToArray(ARGUMENTS.httpTimeString, " ");
	  var timeStamp = "{ts '" & tsParts[4] & "-" & DateFormat("#tsParts[3]#/1/1970", "mm") & "-" & tsParts[2] & " " & tsParts[5] & "'}";

	  return timeStamp;
	</cfscript>
</cffunction>

<cffunction name="returnBytes" access="public" output="false" returntype="Numeric" description="convert shorthand php.ini notation into bytes, much like how the PHP source does it">
	<cfargument name="val" type="String" required="true" />
	<cfscript>
		var last = "";
		val = trim(val);
		last = right(val, 1);

		switch(last) {
			// The 'G' modifier is available since PHP 5.1.0
			case 'g':
				val = mid(val,1,Len(val)-1) * 1024 * 1024 * 1024;
				break;
			case 'm':
				val = mid(val,1,Len(val)-1) * 1024 * 1024;
				break;
			case 'k':
				val = mid(val,1,Len(val)-1) * 1024;
				break;
		}

		return val;
	</cfscript>
</cffunction>

</cfcomponent>
