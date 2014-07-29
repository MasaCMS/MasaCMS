<!--- Temporary structure to hold information while we build functions --->
<cfset cfbackport = StructNew() />

<cffunction name="GetApplicationMetadata" output="false" returntype="struct">
  <cfscript>
    var lc = StructNew();
    if (IsDefined("application")) {
      lc.settings = Duplicate(application.getApplicationSettings());
      for (lc.key in lc.settings) {
        if (IsCustomFunction(lc.settings[lc.key])) {
          StructDelete(lc.settings, lc.key);
        }
      }
      if (StructKeyExists(lc.settings, "scriptProtect") And Len(lc.settings.scriptProtect)) {
        lc.settings.scriptProtect = ListToArray(UCase(lc.settings.scriptProtect));
      }
      return lc.settings;
    }
    return StructNew();
  </cfscript>
</cffunction>

<!--- Mimic duplicate form field names as arrays --->
<cfscript>
  cfbackport.app = GetApplicationMetadata();
  if (StructKeyExists(cfbackport.app, 'sameFormFieldsAsArray') And cfbackport.app.sameFormFieldsAsArray) {
    //
  }
</cfscript>

<cffunction name="ArraySlice" output="false" returntype="array" description="Returns part of an array, as specified">
  <cfargument name="array" type="array" required="true" />
  <cfargument name="offset" type="numeric" required="true" />
  <cfargument name="length" type="numeric" required="false" />
  <cfscript>
    var lc = StructNew();
    if (Not StructKeyExists(arguments, "length")) {
      lc.from = arguments.offset - 1;
      arguments.length = ArrayLen(arguments.array) - lc.from;
    } else if (arguments.offset Lt 0) {
      lc.from = ArrayLen(arguments.array) + arguments.offset;
    } else {
      lc.from = arguments.offset - 1;
    }
    lc.to = lc.from + arguments.length;
    // subList(from [inclusive], to [exclusive]), start index is 0
    lc.slice = arguments.array.subList(lc.from, lc.to);
    // Slice is the wrong type java.util.Collections$SynchronizedRandomAccessList#
    // Recreate as a normal CF array
    lc.array = ArrayNew(1);
    lc.array.addAll(lc.slice);
    return lc.array;
  </cfscript>
</cffunction>

<cffunction name="SessionInvalidate" output="false" returntype="void">
  <cfscript>
    var lc = StructNew();
    lc.sessionId = session.cfid & '_' & session.cftoken;

    // Fire onSessionEnd
    lc.appEvents = application.getEventInvoker();
    lc.args = ArrayNew(1);
    lc.args[1] = application;
    lc.args[2] = session;
    lc.appEvents.onSessionEnd(lc.args);

    // Make sure that session is empty
    StructClear(session);

    // Clean up the session
    lc.sessionTracker = CreateObject("java", "coldfusion.runtime.SessionTracker");
    lc.sessionTracker.cleanUp(application.applicationName, lc.sessionId);
  </cfscript>
</cffunction>

<cffunction name="SessionStartTime" output-="false" returntype="date">
  <cfscript>
    var lc = StructNew();
    lc.mirror = ArrayNew(1);
    lc.class = lc.mirror.getClass().forName("coldfusion.runtime.SessionScope");
    // See blog post for how "mStartTime" was found.
    lc.start = lc.class.getDeclaredField("mStartTime");
    lc.start.setAccessible(true);
    // Credit to Styggiti http://rob.brooks-bilson.com/index.cfm/2007/10/11/Some-Notes-on-Using-Epoch-Time-in-ColdFusion
    return DateAdd("s", lc.start.get(session) / 1000, DateConvert("utc2Local", "January 1 1970 00:00:00"));
  </cfscript>
</cffunction>

<cffunction name="CallStackGet" output="false" returntype="array">
  <cfscript>
    var lc = StructNew();
    lc.trace = CreateObject("java", "java.lang.Throwable").getStackTrace();
    lc.op = ArrayNew(1);
    lc.elCount = ArrayLen(lc.trace);
    for (lc.i = 1; lc.i Lte lc.elCount; lc.i = lc.i + 1) {
      if (ListFindNoCase('runPage,runFunction', lc.trace[lc.i].getMethodName())) {
        lc.info = StructNew();
        lc.info["Template"] = lc.trace[lc.i].getFileName();
        if (lc.trace[lc.i].getMethodName() Eq "runFunction") {
          lc.info["Function"] = ReReplace(lc.trace[lc.i].getClassName(), "^.+\$func", "");
        } else {
          lc.info["Function"] = "";
        }
        lc.info["LineNumber"] = lc.trace[lc.i].getLineNumber();
        ArrayAppend(lc.op, Duplicate(lc.info));
      }
    }
    // Remove the entry for this function
    ArrayDeleteAt(lc.op, 1);
    return lc.op;
  </cfscript>
</cffunction>

<cffunction name="CallStackDump" output="false" returntype="void">
  <cfargument name="destination" required="false" type="string" default="browser" />
  <cfscript>
    var lc = StructNew();
    lc.trace = CallStackGet();
    lc.op = ArrayNew(1);
    lc.elCount = ArrayLen(lc.trace);
    // Skip 1 (CallStackDump)
    for (lc.i = 2; lc.i lte lc.elCount; lc.i = lc.i + 1) {
      if (Len(lc.trace[lc.i]["Function"]) Gt 0) {
        ArrayAppend(lc.op, lc.trace[lc.i].Template & ":" & lc.trace[lc.i]["Function"] & ":" & lc.trace[lc.i].LineNumber);
      } else {
        ArrayAppend(lc.op, lc.trace[lc.i].Template & ":" & lc.trace[lc.i].LineNumber);
      }
    }
    lc.op = ArrayToList(lc.op, Chr(10));

    if (arguments.destination Eq "browser") {
      // Use the buffer since output = false
      GetPageContext().getCFOutput().print(lc.op);
    } else if (arguments.destination Eq "console") {
      CreateObject("java", "java.lang.System").out.println(lc.op);
    } else {
      lc.fp = FileOpen(arguments.destination, "append");
      FileWrite(lc.fp, lc.op & Chr(10));
      FileClose(lc.fp);
    }
  </cfscript>
</cffunction>

<cffunction name="CsrfGenerateToken" output="false" returntype="string">
  <cfargument name="key" type="string" required="false" default="_cfbackportcsrfdefaultkey" />
  <cfargument name="forceNew" type="boolean" required="false" default="false" />
  <cfscript>
    var lc = StructNew();
    // TODO: Session locking?
    if (Not StructKeyExists(session, '_cfbackportcsrf')) {
      session['_cfbackportcsrf'] = StructNew();
    }
    if (arguments.forceNew Or Not StructKeyExists(session._cfbackportcsrf, arguments.key)) {
      lc.token = Now();
      // Throw in the datetime for a little more randomisation
      lc.times = 3;
      // Combinations = 65536^lc.times
      // e.g. 65536^3 = 281,474,976,710,656 possible values to pick from
      // This should be secure enough as the value is either per
      // generation (forceNew=true) or only lives for the session lifetime
      for (lc.i = 1; lc.i Lte lc.times; lc.i = lc.i + 1) {
        lc.token = lc.token & RandRange(0, 65535, "SHA1PRNG");
      }
      // Hash the token, trim to 40 characters (20-bytes), upper case
      lc.token = UCase(Left(Hash(lc.token, "SHA-256"), 40));
      session._cfbackportcsrf[arguments.key] = lc.token;
    } else {
      return session._cfbackportcsrf[arguments.key];
    }
    return lc.token;
  </cfscript>
</cffunction>

<cffunction name="CsrfVerifyToken" output="false" returntype="boolean">
  <cfargument name="token" type="string" required="true" />
  <cfargument name="key" type="string" required="false" default="_cfbackportcsrfdefaultkey" />
  <cfscript>
    // TODO: Session locking?
    if (StructKeyExists(session, '_cfbackportcsrf')
      And StructKeyExists(session._cfbackportcsrf, arguments.key)
      And session._cfbackportcsrf[arguments.key] Eq arguments.token) {
      return true;
    }
    return false;
  </cfscript>
</cffunction>

<cffunction name="isClosure" output="false" returntype="boolean">
	<!--- Couldn't resist, closures cannot be backported so no test possible --->
	<cfreturn false />
</cffunction>

<cffunction name="ReEscape" output="false" returntype="string">
	<cfargument name="string" type="string" required="true" />
	<cfreturn ReReplace(arguments.string, "([\[\]\(\)\^\$\.\+\?\*\-\|])", "\$1", "all") />
</cffunction>

<cffunction name="Canonicalize" output="false" returntype="string" hint="Canonicalize or decode the input string, returns Decoded form of input string">
	<cfargument name="inputString" type="string" required="true" hint="Required. String to be encode" />
	<cfargument name="restrictMultiple" type="boolean" required="true" hint="Required. If set to true, multiple encoding is restricted" />
	<cfargument name="restrictMixed" type="boolean" required="true" hint="Required. If set to true, mixed encoding is restricted (Ignored with ESAPI <2.0.0)" />
  
	<cfscript>
		var lc = StructNew(); 
		var canonicalizedString = "";

		lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();

		/* 
		 * ESAPI 2.0.0+ (r1630) supports String canonicalize( String input, boolean restrictMultiple, boolean restrictMixed )
		 * unfortunately APSB11-04+ installs ESAPI 1.4.4 for CF8.0.x and ESAPI 2.0_rc10 for CF9.0.x and CF9.0.2 which don't have it
		 * try ESAPI 2.0.0+ call then fall back
		 */
 		try {
			canonicalizedString = lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.restrictMultiple), JavaCast("boolean", arguments.restrictMixed));
		}
		catch(Any excpt) {
			canonicalizedString = lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.restrictMultiple));
		}	
	 
	 	return canonicalizedString; 	
	</cfscript>
</cffunction>

<cffunction name="EncodeForCSS" output="false" returntype="string" hint="Encodes the input string for use in CSS, returns Encoded string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
 	<cfargument name="strict" type="boolean" default="false" hint="Optional. If set to true, restricts multiple and mixed encoding" />
	 
	<cfscript>
    	var lc = StructNew();
    	var encodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	encodedString = lc.encoder.encodeForCSS(lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.strict)));
    	
    	return encodedString;
 	</cfscript>
</cffunction>

<cffunction name="DecodeForHTML" output="false" returntype="string" hint="Decodes an HTML encoded string, returns Decoded HTML string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. Encoded string to decode" />
 	 
	<cfscript>
    	var lc = StructNew();
    	var decodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	decodedString = lc.encoder.DecodeForHTML(JavaCast("string", arguments.inputString));
    	
    	return decodedString;
	</cfscript>
</cffunction>

<cffunction name="EncodeForHTML" output="false" returntype="string" hint="Encodes the input string for use in HTML, returns Encoded string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
 	<cfargument name="strict" type="boolean" default="false" hint="Optional. If set to true, restricts multiple and mixed encoding" />
	 
	<cfscript>
    	var lc = StructNew();
    	var encodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	encodedString = lc.encoder.encodeForHTML(lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.strict)));
    	
    	return encodedString;
	</cfscript>
</cffunction>

<cffunction name="EncodeForHTMLAttribute" output="false" returntype="string" hint="Encodes the input string for use in HTML attribute, returns Encoded string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
 	<cfargument name="strict" type="boolean" default="false" hint="Optional. If set to true, restricts multiple and mixed encoding" />
	 
	<cfscript>
    	var lc = StructNew();
    	var encodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	encodedString = lc.encoder.encodeForHTMLAttribute(lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.strict)));
    	
    	return encodedString;
	</cfscript>
</cffunction>

<cffunction name="EncodeForJavaScript" output="false" returntype="string" hint="Encodes the input string for use in JavaScript, returns Encoded string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
 	<cfargument name="strict" type="boolean" default="false" hint="Optional. If set to true, restricts multiple and mixed encoding" />
	 
	<cfscript>
    	var lc = StructNew();
    	var encodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	encodedString = lc.encoder.encodeForJavaScript(lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.strict)));
    	
    	return encodedString;
	</cfscript>
</cffunction>


<cffunction name="DecodeFromURL" output="false" returntype="string" hint="">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to decode" />

	<cfscript>
    	var lc = StructNew();
    	
		local.encoding = createObject("java", "java.lang.System").getProperty("file.encoding");
		try {
				return createObject("java", "java.net.URLDecoder").decode(javaCast("string", canonicalize(arguments.inputString, false, false)), local.encoding);
		}
		// throw the same errors as CF10
		catch(java.io.UnsupportedEncodingException ex) {
			// Character encoding not supported
			throw("There was an error while encoding.", "Application", "For more details check logs.");
		}
		catch(java.lang.Exception e) {
			// Problem URL decoding input
			throw("There was an error while encoding.", "Application", "For more details check logs.");
		}
		</cfscript>

	</cffunction>


<cffunction name="EncodeForURL" output="false" returntype="string" hint="Encodes the input string for use in URLs, returns Encoded string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
 	<cfargument name="strict" type="boolean" default="false" hint="Optional. If set to true, restricts multiple and mixed encoding" />
	 
	<cfscript>
    	var lc = StructNew();
    	var encodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	encodedString = lc.encoder.encodeForURL(lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.strict)));
    	
    	return encodedString;
	</cfscript>
</cffunction>

<cffunction name="EncodeForXML" output="false" returntype="string" hint="Encodes the input string for use in XML, returns Encoded string">
 	<cfargument name="inputString" type="string" required="true" hint="Required. String to encode" />
 	<cfargument name="strict" type="boolean" default="false" hint="Optional. If set to true, restricts multiple and mixed encoding" />
	 
	<cfscript>
    	var lc = StructNew();
    	var encodedString = "";
    	
    	lc.encoder = CreateObject("java", "org.owasp.esapi.ESAPI").encoder();
    	encodedString = lc.encoder.encodeForXML(lc.encoder.canonicalize(JavaCast("string", arguments.inputString), JavaCast("boolean", arguments.strict)));
    	
    	return encodedString;
	</cfscript>
</cffunction>

<!---
Based upon code from http://www.coldfusiondeveloper.com.au/go/note/2008/01/18/hmac-sha1-using-java/
 --->
<cffunction name="HMac" output="false" returntype="string" description="Creates Hash-based Message Authentication Code for the given string or byte array based on the algorithm and encoding">
	<cfargument name="message" type="any" required="true" hint="can be string or byte array" />
	<cfargument name="key" type="any" required="true" hint="can be string or byte array" />
	<cfargument name="algorithm" type="string" default="HMACMD5" hint="HMACMD5, HMACSHA1, HMACSHA256, HMACSHA384, HMACSHA512, HMACRIPEMD160, HMACSHA224" />
	<cfargument name="encoding" type="string" default="#createObject('java', 'java.lang.System').getProperty('file.encoding')#" hint="encoding to use" />

	<cfset var byteArray = {} />
	<cfset var javaObject = {} />
	
	<cfif NOT IsBinary(arguments.message)>
		<cfset byteArray.Message = CharsetDecode(arguments.message, arguments.encoding) />
	<cfelse>
		<cfset byteArray.Message = arguments.message />
	</cfif>

	<cfif NOT IsBinary(arguments.key)>
		<cfset byteArray.Key = CharsetDecode(arguments.key, arguments.encoding) />
	<cfelse>
		<cfset byteArray.Key = arguments.key />
	</cfif>

	<cfset javaObject.Key = createObject("java","javax.crypto.spec.SecretKeySpec").init(byteArray.Key, arguments.algorithm) />
 	<cfset javaObject.Mac = createObject("java","javax.crypto.Mac") />
  
  	<cfset javaObject.Mac = javaObject.Mac.getInstance(arguments.algorithm) />
  	<cfset javaObject.Mac.init(javaObject.Key) />

  	<cfreturn BinaryEncode(javaObject.Mac.doFinal(byteArray.Message), "hex") />
</cffunction>

<!---
	Hopefully, ColdFusion is patched and therefore ESAPI is available
	APSB11-04+ installs ESAPI 1.4.4 for CF8.0.x and ESAPI 2.0_rc10 for CF9.0.x and CF9.0.2

	Test for ESAPI existance by calling canonicalize, if exception is thrown
	remove the functions that are dependent upon it
--->
<cftry>
  <cfset canonicalize("", false, false) />

  <cfcatch type="any">
    <cfset StructDelete(variables, "Canonicalize") />
    <cfset StructDelete(variables, "DecodeFromURL") />
    <cfset StructDelete(variables, "EncodeForCSS") />
    <cfset StructDelete(variables, "EncodeForHTML") />
    <cfset StructDelete(variables, "EncodeForHTMLAttribute") />
    <cfset StructDelete(variables, "EncodeForJavaScript") />
    <cfset StructDelete(variables, "EncodeForURL") />
    <cfset StructDelete(variables, "EncodeForXML") />
  </cfcatch>
</cftry>

<!---
	ESAPI 1.4.4 does not have DecodeForHTML
 --->
<cftry>
  <cfset decodeForHTML("") />

  <cfcatch type="any">
    <cfset StructDelete(variables, "DecodeForHTML") />
  </cfcatch>
</cftry>

<cfset StructDelete(variables, "cfbackport") />
