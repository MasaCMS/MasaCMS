<cfcomponent output="false" hint="
<pre>
DEVELOPER NOTES:

*******************************************************************************************************
This component is a CFC implementation of Jacob Munson's cffpVerify.cfm (part of CFFormProtect) written
by Dave Shuck dshuck@gmail.com.  All calculations/algorithms are a direct port of Jacob's original code,
with exceptions noted in the NOTES section below.
*******************************************************************************************************

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
TEMPLATE    : cffpVerify.cfc

CREATED     : 23 Mar 2007

USAGE       : Perform various tests on a form submission to ensure that a human submitted it.

DEPENDANCY  : NONE

NOTES       : Dave Shuck - created
			  Dave Shuck - 23 Mar 2007 - Added testTooManyUrls() method and call to the method in testSubmission()
			  Dave Shuck - 23 Mar 2007 - Removed the '0' padding in FormTime in testTimedSubmission() which was causing
			  								consistent failure on that test
			  Dave Shuck - 24 Mar 2007 - Added logFailure() method and the call to the method in testSubmission().  This
			  								code is still backwards compatable with older ini files that do not make use of
			  								the properties 'logFailedTests' and 'logFile'
			  Dave Shuck - 26 Mar 2007 - Altered the FormTime in testTimedSubmission() to use NumberFormat as the previous
			  								change caused exceptions before 10:00am.  (see comments in method)
			  Mary Jo Sminkey - 18 July 2007 - Added new function 'testSpamStrings' which allows the user to configure a list
			  									of text strings to test the form against. Similar to using Akismet but with no
			  									cost involved for commercial use and can be configured as needed for the spam
			  									received. Update Akismet function to log to same file and not log as passed if
			  									the key validation failed.
        Ben Elliott - 16 Jan 2009 - Added ability to specify ini config filename during init() and setConfig() with new cfargument 'ConfigFilename'. This new argument defaults to 'cffp.ini.cfm' for backwards compatability.
        Jake Munson - 10 Oct 2012 - Added the LinkSleeve test.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
</pre>
">

	<cffunction name="init" access="public" output="false" returntype="cffpVerify">
		<cfargument name="ConfigPath" required="false" default="#ExpandPath("/cfformprotect")#" type="string" />
    <cfargument name="ConfigFilename" required="false" default="#application.configBean.getCFFPConfigFilename()#" type="string" />
		<cfscript>
		setConfig(arguments.ConfigPath, arguments.ConfigFilename);
		this.ConfigPath = arguments.ConfigPath;
		this.configFilename = arguments.ConfigFilename;
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="getConfig" access="public" output="false" returntype="struct">
		<cfreturn variables.Config />
	</cffunction>

	<cffunction name="setConfig" access="public" output="false" returntype="void">
		<cfargument name="ConfigPath" required="true" />
    <cfargument name="ConfigFilename" required="true" />
		<cfscript>
		var IniEntries = GetProfileSections(arguments.ConfigPath & "/" & arguments.ConfigFilename).CFFormProtect;
		var i = "";
		variables.Config = StructNew();

		for (i=1;i LTE ListLen(IniEntries);i=i+1)	{
			variables.Config[ListGetAt(IniEntries,i)] = GetProfileString(arguments.ConfigPath & "/" & arguments.ConfigFilename,"CFFormProtect",ListGetAt(IniEntries,i));
		}
		//set logfile
		if (NOT Len(variables.Config.logFile))	{ variables.Config.logFile = "CFFormProtect"; }
		</cfscript>
	</cffunction>

	<!--- Custom --->
	<cffunction name="updateConfig" access="public" output="false" returntype="void">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">

		<cfset variables.Config[name] = value>
	</cffunction>
	<!--- --->

	<cffunction name="testSubmission" access="public" output="false" returntype="any">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Pass = true;
		// each time a test fails, totalPoints is incremented by the user specified amount
		var TotalPoints = 0;
		// setup a variable to store a list of tests that failed, for informational purposes
		var TestResults = StructNew();

		// Begin tests
		// Test for mouse movement
		try	{
			if (getConfig().mouseMovement)	{
				TestResults.MouseMovement = testMouseMovement(arguments.FormStruct);
				if (NOT TestResults.MouseMovement.Pass)	{
					// The mouse did not move
					TotalPoints = TotalPoints + getConfig().mouseMovementPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }


		// Test for used keyboard
		try	{
			if (getConfig().usedKeyboard)	{
				TestResults.usedKeyboard = testUsedKeyboard(arguments.FormStruct);
				if (NOT TestResults.usedKeyboard.Pass)	{
					// No keyboard activity was detected
					TotalPoints = TotalPoints + getConfig().usedKeyboardPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }


		// Test for time taken on the form
		try	{
			if (getConfig().timedFormSubmission)	{
				TestResults.timedFormSubmission = testTimedFormSubmission(arguments.FormStruct);
				if (NOT TestResults.timedFormSubmission.Pass)	{
					// Time was either too short, too long, or the form field was altered
					TotalPoints = TotalPoints + getConfig().timedFormPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }


		// Test for empty hidden form field
		try	{
			if (getConfig().hiddenFormField)	{
				TestResults.hiddenFormField = testHiddenFormField(arguments.FormStruct);
				if (NOT TestResults.hiddenFormField.Pass)	{
					// The submitter filled in a form field hidden via CSS
					TotalPoints = TotalPoints + getConfig().hiddenFieldPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }


		// Test Akismet
		try	{
			if (getConfig().akismet)	{
				TestResults.akismet = testAkismet(arguments.FormStruct);
				if (NOT TestResults.akismet.Pass)	{
					// Akismet says this form submission is spam
					TotalPoints = TotalPoints + getConfig().akismetPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }

		// Test LinkSleeve
		try	{
			if (getConfig().linkSleeve)	{
				TestResults.linkSleeve = testLinkSleeve(arguments.FormStruct);
				if (NOT TestResults.linkSleeve.Pass)	{
					// LinkSleeve says this form submission is spam
					TotalPoints = TotalPoints + getConfig().linkSleevePoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }


		// Test tooManyUrls
		try	{
			if (getConfig().tooManyUrls)	{
				TestResults.tooManyUrls = TestTooManyUrls(arguments.FormStruct);
				if (NOT TestResults.tooManyUrls.Pass)	{
					// Submitter has included too many urls in at least one form field
					TotalPoints = TotalPoints + getConfig().tooManyUrlsPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }

		// Test spamStrings
		try	{
			if (getConfig().teststrings)	{
				TestResults.SpamStrings = testSpamStrings(arguments.FormStruct);
				if (NOT TestResults.SpamStrings.Pass)	{
					// Submitter has included a spam string in at least one form field
					TotalPoints = TotalPoints + getConfig().spamStringPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }

		// Test Project Honey Pot
		try	{
			if (getConfig().projectHoneyPot)	{
				TestResults.ProjHoneyPot = testProjHoneyPot(arguments.FormStruct);
				if (NOT TestResults.ProjHoneyPot.Pass)	{
					// Submitter has included a spam string in at least one form field
					TotalPoints = TotalPoints + getConfig().projectHoneyPotPoints;
				}
			}
		}
		catch(any excpt)	{ /* an error occurred on this test, but we will move one */ }

		// Compare the total points from the spam tests to the user specified failure limit
		if (TotalPoints GTE getConfig().failureLimit)	{
			Pass = false;
			try	{
				if (getConfig().emailFailedTests)	{
					emailReport(TestResults=TestResults,FormStruct=FormStruct,TotalPoints=TotalPoints);
				}
			}
			catch(any excpt)	{ /* an error has occurred emailing the report, but we will move on */ }
			try	{
				if (getConfig().logFailedTests)	{
					logFailure(TestResults=TestResults,FormStruct=FormStruct,TotalPoints=TotalPoints,LogFile=getConfig().logFile);
				}
			}
			catch(any excpt)	{ /* an error has occurred logging the spam, but we will move on */ }
		}
		return pass;
		</cfscript>
	</cffunction>

	<cffunction name="testMouseMovement" access="public" output="false" returntype="struct"
				hint="I make sure this form field exists, and it has a numeric value in it (the distance the mouse traveled)">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		Result.Pass = false;
		if (StructKeyExists(arguments.FormStruct,"formfield1234567891") AND IsNumeric(arguments.FormStruct.formfield1234567891))	{
			Result.Pass = true;
		}
		return Result;
		</cfscript>
	</cffunction>

	<cffunction name="testUsedKeyboard" access="public" output="false" returntype="struct"
				hint="I make sure this form field exists, and it has a numeric value in it (the amount of keys pressed by the user)">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		Result.Pass = false;
		if (StructKeyExists(arguments.FormStruct,"formfield1234567892") AND IsNumeric(arguments.FormStruct.formfield1234567892))	{
			Result.Pass = true;
		}
		return Result;
		</cfscript>
	</cffunction>

	<cffunction name="testTimedFormSubmission" access="public" output="false" returntype="struct"
					hint="I check the time elapsed from the begining of the form load to the form submission">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		var FormDate = "";
		var FormTime = "";
		var FormDateTime = "";
		//var FormTimeElapsed = "";

		Result.Pass = true;

		// Decrypt the initial form load time
		if (StructKeyExists(arguments.FormStruct,"formfield1234567893") AND ListLen(arguments.FormStruct.formfield1234567893) eq 2)	{
			FormDate = ListFirst(arguments.FormStruct.formfield1234567893)-19740206;
			if (Len(FormDate) EQ 7) {
				FormDate = "0" & FormDate;
			}
			FormTime = ListLast(arguments.FormStruct.formfield1234567893)-19740206;
			if (Len(FormTime))	{
				// in original form, FormTime was always padded with a "0" below.  In my testing, this caused the timed test to fail
				// consistantly after 9:59am due to the fact it was shifting the time digits one place to the right with 2 digit hours.
				// To make this work I added NumberFormat()
				FormTime = NumberFormat(FormTime,'000000');
			}

			FormDateTime = CreateDateTime(Left(FormDate,4),Mid(FormDate,5,2),Right(FormDate,2),Left(FormTime,2),Mid(FormTime,3,2),Right(FormTime,2));
			// Calculate how many seconds elapsed
			Result.FormTimeElapsed = DateDiff("s",FormDateTime,Now());
			if (Result.FormTimeElapsed LT getConfig().timedFormMinSeconds OR Result.FormTimeElapsed GT getConfig().timedFormMaxSeconds)	{
				Result.Pass = false;
			}
		}
		else	{
			Result.Pass = false;
		}
		return Result;
		</cfscript>
	</cffunction>

	<cffunction name="testHiddenFormField" access="public" output="false" returntype="struct"
				hint="I make sure the CSS hidden form field doesn't have a value">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		Result.Pass = false;
		if (StructKeyExists(arguments.FormStruct,"formfield1234567894") AND NOT Len(arguments.FormStruct.formfield1234567894))	{
			Result.Pass = true;
		}
		return Result;
		</cfscript>
	</cffunction>

	<cffunction name="testAkismet" access="public" output="false" returntype="struct"
				hint="I send form contents to the public Akismet service to validate that it's not 'spammy'">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		var AkismetKeyIsValid = false;
		var AkismetHTTPRequest = true;
		var logfile = getConfig().logFile;
		Result.Pass = true;
		Result.ValidKey = false;
		</cfscript>

		<cftry>
			<!--- validate the Akismet API key --->
			<cfhttp url="http://rest.akismet.com/1.1/verify-key" timeout="10" method="post">
				<cfhttpparam name="key" type="formfield" value="#getConfig().akismetAPIKey#" />
				<cfhttpparam name="blog" type="formfield" value="#getConfig().akismetBlogURL#" />
			</cfhttp>
			<cfif AkismetHTTPRequest AND Trim(cfhttp.FileContent) EQ "valid">
				<cfset AkismetKeyIsValid = true />
				<cfset Result.ValidKey = true />
			</cfif>
 			<cfcatch type="any">
				<cfset AkismetHTTPRequest = false />
				<cflog file="#logfile#" text="Akismet API key validation failed" />
			</cfcatch>
		</cftry>

		<cfif AkismetKeyIsValid>
			<cftry>
				<!--- send form contents to Akismet API --->
				<cfhttp url="http://#getConfig().akismetAPIKey#.rest.akismet.com/1.1/comment-check" timeout="10" method="post">
					<cfhttpparam name="key" type="formfield" value="#getConfig().akismetAPIKey#" />
					<cfhttpparam name="blog" type="formfield" value="#getConfig().akismetBlogURL#" />
					<cfhttpparam name="user_ip" type="formfield" value="#request.remoteAddr#" />
					<cfhttpparam name="user_agent" type="formfield" value="CFFormProtect/1.0 | Akismet/1.11" />
					<cfhttpparam name="referrer" type="formfield" value="#cgi.http_referer#" />
					<cfhttpparam name="comment_author" type="formfield" value="#arguments.FormStruct[getConfig().akismetFormNameField]#" />
					<cfif Len(getConfig().akismetFormEmailField)>
						<cfhttpparam name="comment_author_email" type="formfield" value="#arguments.FormStruct[getConfig().akismetFormEmailField]#" />
					</cfif>
					<cfif Len(getConfig().akismetFormURLField)>
						<cfhttpparam name="comment_author_url" type="formfield" value="#arguments.FormStruct[getConfig().akismetFormURLField]#" />
					</cfif>
					<cfhttpparam name="comment_content" type="formfield" value="#arguments.FormStruct[getConfig().akismetFormBodyField]#" />
				</cfhttp>
				<!--- check Akismet results --->
				<cfif AkismetHTTPRequest AND Trim(cfhttp.FileContent)>
					<!--- Akismet says this form submission is spam --->
					<cfset Result.Pass = false />
				</cfif>

				<cfcatch type="any">
					<cfset akismetHTTPRequest = false />
					<cflog file="#logfile#" text="Akismet request failed" />
				</cfcatch>
			</cftry>
		<cfelse>
			<cflog file="#logfile#" text="Akismet API Key is invalid" />
		</cfif>
		<cfreturn Result />
	</cffunction>

	<cffunction name="testLinkSleeve" access="public" output="false" returntype="struct"
				hint="I send form contents to the public LinkSleeve service to validate that it's not 'spammy'">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		Result.Pass = true;
		var linkSleeveHTTPRequest = true;
		var linkSleeveResult = 0;
		var formData = "";
		</cfscript>

		<!--- lump all form data together to send to the LinkSleeve service --->
		<cfloop list="#arguments.FormStruct.fieldNames#" index="formField">
			<cfset formData = formData&" "&arguments.FormStruct[formField]>
		</cfloop>

		<cfsavecontent variable="linkSleeveXML"><?xml version="1.0" encoding="UTF-8"?>
			<methodCall>
				<methodName>slv</methodName>
				<params>
					<param>
						<value><string><cfoutput>#formData#</cfoutput></string></value>
					</param>
				</params>
			</methodCall>
		</cfsavecontent>

		<cftry>
			<!--- send form contents to LinkSleeve API --->
			<cfhttp method="post" url="http://www.linksleeve.org/slv.php" result="linkSleeveResponse" timeout="10">
				<cfhttpparam type="HEADER" name="Content-Type" value="text/xml; charset=utf-8">
				<cfhttpparam type="HEADER" name="Content-Length" value="#len(trim(linkSleeveXML))#">
				<cfhttpparam type="BODY" value="#trim(linkSleeveXML)#">
			</cfhttp>
			<cfcatch type="any">
				<cfset linkSleeveHTTPRequest = false />
			</cfcatch>
		</cftry>

		<!--- check LinkSleeve results --->
		<cfif linkSleeveHTTPRequest>
			<cftry>
				<cfset responseXML = xmlParse(linkSleeveResponse.fileContent)>
				<cfset linkSleeveResult = responseXML.methodResponse.params.param.value.int.xmlText>
				<cfif linkSleeveResult eq 0>
					<!--- LinkSleeve says this form submission is spam --->
					<cfset Result.Pass = false />
				</cfif>
				<cfcatch type="any"><!--- if there are any unforseen XML problems, just ignore. This should not happen :) ---></cfcatch>
			</cftry>
		</cfif>
		<cfreturn Result />
	</cffunction>

	<cffunction name="testTooManyUrls" access="public" output="false" returntype="struct" hint="I test whether too many URLs have been submitted in fields">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
			var Result = StructNew();
			var checkfield = "";
			var urlRegex = "(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'"".,<>?«»“”‘’]))";
			var UrlCount = "";

			Result.Pass = true;
			for (checkfield in arguments.FormStruct)   {
				if ( IsSimpleValue(arguments.FormStruct[checkfield])) {
					UrlCount = arrayLen(rematch(urlRegex,arguments.FormStruct[checkfield])) - 1;
					if (UrlCount GTE getConfig().tooManyUrlsMaxUrls)   {
						Result.Pass = false;
						break;
					}
				}
			}
			return Result;
		</cfscript>
	</cffunction>

	<cffunction name="listFindOneOf" access="public" output="false" returntype="boolean">
		<cfargument name="texttosearch" type="string" required="yes"/>
		<cfargument name="values" type="string" required="yes"/>
		<cfargument name="delimiters" type="string" required="no" default=","/>
		<cfset var value = 0/>
		<cfloop list="#arguments.values#" index="value" delimiters="#arguments.delimiters#">
			<cfif FindNoCase(value, arguments.texttosearch)>
				<cfreturn false />
			</cfif>
		</cfloop>
		<cfreturn true />
	</cffunction>

	<cffunction name="testSpamStrings" access="public" output="false" returntype="struct"
				hint="I test whether any of the configured spam strings are found in the form submission">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfscript>
		var Result = StructNew();
		var value = 0;
		var teststrings = getConfig().spamstrings;
		var checkfield = '';
		Result.Pass = true;

		// Loop through the list of spam strings to see if they are found in the form submission
		for (checkfield in arguments.FormStruct)	{
			if (Result.Pass IS true && IsSimpleValue(arguments.FormStruct[checkfield]))	{
				Result.Pass = listFindOneOf(arguments.FormStruct[checkfield],teststrings);
			}
		}
		return Result;
		</cfscript>
	</cffunction>

	<cffunction name="testProjHoneyPot" access="public" output="false" returntype="struct"
				hint="I send the user's IP address to the Project Honey Pot service to check if it's from a known spammer.">
		<cfargument name="FormStruct" required="true" type="struct" />
		<cfset var Result = StructNew()>
		<cfset var apiKey = getConfig().projectHoneyPotAPIKey>
		<cfset var visitorIP = request.remoteAddr> <!--- 93.174.93.221 is known to be bad --->
		<cfset var reversedIP = "">
		<cfset var addressFound = 1>
		<cfset var isSpammer = 0>
		<cfset var inetObj = "">
		<cfset var hostNameObj = "">
		<cfset var projHoneypotResult = "">
		<cfset var resultArray = "">
		<cfset var threatScore = "">
		<cfset var classification = "">
		<cfset Result.Pass = true>

		<!--- Setup the DNS query string --->
		<cfset reversedIP = listToArray(visitorIP,".")>
		<cfset reversedIP = reversedIP[4]&"."&reversedIP[3]&"."&reversedIP[2]&"."&reversedIP[1]>

		<cftry>
			<!--- Query Project Honeypot for this address --->
			<cfset inetObj = createObject("java", "java.net.InetAddress")>
			<cfset hostNameObj = inetObj.getByName("#apiKey#.#reversedIP#.dnsbl.httpbl.org")>
			<cfset projHoneypotResult = hostNameObj.getHostAddress()>
			<cfcatch type="java.net.UnknownHostException">
				<!--- The above Java code throws an exception when the address is not
							found in the Project Honey Pot database. --->
				<cfset addressFound = 0>
			</cfcatch>
		</cftry>

		<cfif addressFound>
			<cfset resultArray = listToArray(projHoneypotResult,".")>
			<!--- resultArray[3] is the threat score for the address, rated from 0 to 255.
						resultArray[4] is the classification for the address, anything higher than
						1 is either a harvester or comment spammer --->
			<cfset threatScore = resultArray[3]>
			<cfset classification = resultArray[4]>
			<cfif (threatScore gt 10) and (classification gt 1)>
				<cfset isSpammer = isSpammer+1>
			</cfif>
		</cfif>

		<cfif isSpammer>
			<cfset Result.Pass = false>
		</cfif>

		<cfreturn Result>
	</cffunction>

	<cffunction name="emailReport" access="public" output="false" returntype="void">
		<cfargument name="TestResults" required="true" type="struct" />
		<cfargument name="FormStruct" required="true" type="struct">
		<cfargument name="TotalPoints" required="true" type="numeric" />
		<cfscript>
		var falsePositiveURL = "";
		var missedSpamURL = "";
		</cfscript>
		<!--- Here is where you might want to make some changes, to customize what happens
				if a spam message is found.  depending on your system, you can either just use
				my code here, or email yourself the failed test, or plug into your system
				in the best way for your needs --->
			<!---  --->

	 	<cfmail
			from="#getConfig().emailFromAddress#"
			to="#getConfig().emailToAddress#"
			subject="#getConfig().emailSubject#"
			server="#getConfig().emailServer#"
			username="#getConfig().emailUserName#"
			password="#getConfig().emailPassword#"
			type="html">
				This message was marked as spam because:
				<ol>
					<cfif StructKeyExists(arguments.TestResults,"mouseMovement") AND NOT arguments.TestResults.mouseMovement.Pass>
					<li>No mouse movement was detected.</li>
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"usedKeyboard") AND NOT arguments.TestResults.usedKeyboard.Pass>
					<li>No keyboard activity was detected.</li>
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"timedFormSubmission") AND NOT arguments.TestResults.timedFormSubmission.Pass>
						<cfif StructKeyExists(arguments.FormStruct,"formfield1234567893")>
						<li>The time it took to fill out the form was
							<cfif arguments.FormStruct.formfield1234567893 lt getConfig().timedFormMinSeconds>
								too short.
							<cfelseif arguments.FormStruct.formfield1234567893 gt getConfig().timedFormMaxSeconds>
								too long.
							</cfif>
							It took them #arguments.FormStruct.formfield1234567893# seconds to submit the form, and your allowed
							threshold is #getConfig().timedFormMinSeconds#-#getConfig().timedFormMaxSeconds#
							seconds.
						</li>
						<cfelse>
							<li>The time it took to fill out the form did not fall within your
								configured threshold of #getConfig().timedFormMinSeconds#-#getConfig().timedFormMaxSeconds#
								seconds.  Also, I think the form data for this field was tampered with by the
								spammer.
							</li>
						</cfif>
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"hiddenFormField") AND NOT arguments.TestResults.hiddenFormField.Pass>
					<li>The hidden form field that is supposed to be blank contained data.</li>
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"SpamStrings") AND NOT arguments.TestResults.SpamStrings.Pass>
					<li>One of the configured spam strings was found in the form submission.</li>
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"akismet") AND NOT arguments.TestResults.akismet.Pass>
						<!--- The next few lines build the URL to submit a false
									positive notification to Akismet if this is not spam --->
						<cfset falsePositiveURL = replace("#getConfig().akismetBlogURL#cfformprotect/akismetFailure.cfm?type=ham","://","^^","all")>
						<cfset falsePositiveURL = replace(falsePositiveURL,"//","/","all")>
						<cfset falsePositiveURL = replace(falsePositiveURL,"^^","://","all")>
						<cfset falsePositiveURL = falsePositiveURL&"&user_ip=#urlEncodedFormat(request.remoteAddr,'utf-8')#">
						<cfset falsePositiveURL = falsePositiveURL&"&referrer=#urlEncodedFormat(cgi.http_referer,'utf-8')#">
						<cfset falsePositiveURL = falsePositiveURL&"&comment_author=#urlEncodedFormat(form[getConfig().akismetFormNameField],'utf-8')#">
						<cfif getConfig().akismetFormEmailField neq "">
						<cfset falsePositiveURL = falsePositiveURL&"&comment_author_email=#urlEncodedFormat(form[getConfig().akismetFormEmailField],'utf-8')#">
						</cfif>
						<cfif getConfig().akismetFormURLField neq "">
						<cfset falsePositiveURL = falsePositiveURL&"&comment_author_url=#urlEncodedFormat(form[getConfig().akismetFormURLField],'utf-8')#">
						</cfif>
						<cfset falsePositiveURL = falsePositiveURL&"&comment_content=#urlEncodedFormat(form[getConfig().akismetFormBodyField],'utf-8')#">
						<li>Akisment thinks this is spam, if it's not please mark this as a
						false positive by <cfoutput><a href="#falsePositiveURL#">clicking here</a></cfoutput>.</li>
					<cfelseif StructKeyExists(arguments.TestResults,"akismet") AND arguments.TestResults.akismet.ValidKey AND arguments.TestResults.akismet.Pass>
						<!--- The next few lines build the URL to submit a missed
									spam notification to Akismet --->
						<cfset missedSpamURL = replace("#getConfig().akismetBlogURL#cfformprotect/akismetFailure.cfm?type=spam","://","^^","all")>
						<cfset missedSpamURL = replace(missedSpamURL,"//","/","all")>
						<cfset missedSpamURL = replace(missedSpamURL,"^^","://","all")>
						<cfset missedSpamURL = missedSpamURL&"&user_ip=#urlEncodedFormat(request.remoteAddr,'utf-8')#">
						<cfset missedSpamURL = missedSpamURL&"&referrer=#urlEncodedFormat(cgi.http_referer,'utf-8')#">
						<cfset missedSpamURL = missedSpamURL&"&comment_author=#urlEncodedFormat(form[getConfig().akismetFormNameField],'utf-8')#">
						<cfif getConfig().akismetFormEmailField neq "">
						<cfset missedSpamURL = missedSpamURL&"&comment_author_email=#urlEncodedFormat(form[getConfig().akismetFormEmailField],'utf-8')#">
						</cfif>
						<cfif getConfig().akismetFormURLField neq "">
						<cfset missedSpamURL = missedSpamURL&"&comment_author_url=#urlEncodedFormat(form[getConfig().akismetFormURLField],'utf-8')#">
						</cfif>
						<cfset missedSpamURL = missedSpamURL&"&comment_content=#urlEncodedFormat(form[getConfig().akismetFormBodyField],'utf-8')#">
						Akismet did not think this message was spam.  If it was, please <a href="#missedSpamURL#">notify Akismet</a> that it
						missed one.
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"TooManyUrls") AND NOT arguments.TestResults.tooManyUrls.Pass>
					       <li>There were too many URLs in the form contents</li>
					</cfif>

					<cfif StructKeyExists(arguments.TestResults,"ProjHoneyPot") AND NOT arguments.TestResults.ProjHoneyPot.Pass>
					<li>The user's IP address has been flagged by Project Honey Pot.</li>
					</cfif>

				</ol>
				Failure score: #totalPoints#<br />
				Your failure threshold: #getConfig().failureLimit#
			<br /><br />
			IP address: #request.remoteAddr#<br />
			User agent: #cgi.http_user_agent#<br />
			Previous page: #cgi.http_referer#<br />
			Form variables:
			<cfdump var="#form#">
		</cfmail>
	</cffunction>

	<cffunction name="logFailure" acces="private" output="false" returntype="void">
		<cfargument name="TestResults" required="true" type="struct" />
		<cfargument name="FormStruct" required="true" type="struct">
		<cfargument name="TotalPoints" required="true" type="numeric" />
		<cfargument name="LogFile" required="true" type="string" />
		<cfscript>
		var falsePositiveURL = "";
		var missedSpamURL = "";
		var LogText = "Message marked as spam!   ";
		</cfscript>

		<cfif StructKeyExists(arguments.TestResults,"mouseMovement") AND NOT arguments.TestResults.mouseMovement.Pass>
			<cfset LogText = LogText & "--- No mouse movement was detected." />
		</cfif>

		<cfif StructKeyExists(arguments.TestResults,"usedKeyboard") AND NOT arguments.TestResults.usedKeyboard.Pass>
			<cfset LogText = LogText & "--- No keyboard activity was detected." />
		</cfif>

		<cfif StructKeyExists(arguments.TestResults,"timedFormSubmission") AND NOT arguments.TestResults.timedFormSubmission.Pass>
			<cfif StructKeyExists(arguments.FormStruct,("formfield1234567893"))>
				<cfset LogText = LogText & "--- The time it took to fill out the form did not fall within your configured threshold of #getConfig().timedFormMinSeconds#-#getConfig().timedFormMaxSeconds# seconds." />

			<cfelse>
				<cfset LogText = LogText & "The time it took to fill out the form did not fall within your configured threshold of #getConfig().timedFormMinSeconds#-#getConfig().timedFormMaxSeconds# seconds.  Also, I think the form data for this field was tampered with by the spammer." />
			</cfif>
		</cfif>

		<cfif StructKeyExists(arguments.TestResults,"hiddenFormField") AND NOT arguments.TestResults.hiddenFormField.Pass>
			<cfset LogText = LogText & "--- The hidden form field that is supposed to be blank contained data." />
		</cfif>

		<cfif StructKeyExists(arguments.TestResults,"SpamStrings") AND NOT arguments.TestResults.SpamStrings.Pass>
			<cfset LogText = LogText & "--- One of the configured spam strings was found in the form submission." />
		</cfif>

		<cfif StructKeyExists(arguments.TestResults,"akismet") AND NOT arguments.TestResults.akismet.Pass>
			<!--- The next few lines build the URL to submit a false
						positive notification to Akismet if this is not spam --->
			<cfset falsePositiveURL = replace("#getConfig().akismetBlogURL#cfformprotect/akismetFailure.cfm?type=ham","://","^^","all")>
			<cfset falsePositiveURL = replace(falsePositiveURL,"//","/","all")>
			<cfset falsePositiveURL = replace(falsePositiveURL,"^^","://","all")>
			<cfset falsePositiveURL = falsePositiveURL&"&user_ip=#urlEncodedFormat(request.remoteAddr,'utf-8')#">
			<cfset falsePositiveURL = falsePositiveURL&"&referrer=#urlEncodedFormat(cgi.http_referer,'utf-8')#">
			<cfset falsePositiveURL = falsePositiveURL&"&comment_author=#urlEncodedFormat(form[getConfig().akismetFormNameField],'utf-8')#">
			<cfif getConfig().akismetFormEmailField neq "">
				<cfset falsePositiveURL = falsePositiveURL&"&comment_author_email=#urlEncodedFormat(form[getConfig().akismetFormEmailField],'utf-8')#">
			</cfif>
			<cfif getConfig().akismetFormURLField neq "">
				<cfset falsePositiveURL = falsePositiveURL&"&comment_author_url=#urlEncodedFormat(form[getConfig().akismetFormURLField],'utf-8')#">
			</cfif>
			<cfset falsePositiveURL = falsePositiveURL&"&comment_content=#urlEncodedFormat(form[getConfig().akismetFormBodyField],'utf-8')#">
			<cfset LogText = LogText & "--- Akisment thinks this is spam, if it's not please mark this as a
							false positive by visiting: #falsePositiveURL#" />
		<cfelseif StructKeyExists(arguments.TestResults,"akismet") AND arguments.TestResults.akismet.ValidKey AND arguments.TestResults.akismet.Pass>
			<!--- The next few lines build the URL to submit a missed
						spam notification to Akismet --->
			<cfset missedSpamURL = replace("#getConfig().akismetBlogURL#cfformprotect/akismetFailure.cfm?type=spam","://","^^","all")>
			<cfset missedSpamURL = replace(missedSpamURL,"//","/","all")>
			<cfset missedSpamURL = replace(missedSpamURL,"^^","://","all")>
			<cfset missedSpamURL = missedSpamURL&"&user_ip=#urlEncodedFormat(request.remoteAddr,'utf-8')#">
			<cfset missedSpamURL = missedSpamURL&"&referrer=#urlEncodedFormat(cgi.http_referer,'utf-8')#">
			<cfset missedSpamURL = missedSpamURL&"&comment_author=#urlEncodedFormat(form[getConfig().akismetFormNameField],'utf-8')#">
			<cfif getConfig().akismetFormEmailField neq "">
				<cfset missedSpamURL = missedSpamURL&"&comment_author_email=#urlEncodedFormat(form[getConfig().akismetFormEmailField],'utf-8')#">
			</cfif>
			<cfif getConfig().akismetFormURLField neq "">
				<cfset missedSpamURL = missedSpamURL&"&comment_author_url=#urlEncodedFormat(form[getConfig().akismetFormURLField],'utf-8')#">
			</cfif>
			<cfset missedSpamURL = missedSpamURL&"&comment_content=#urlEncodedFormat(form[getConfig().akismetFormBodyField],'utf-8')#">
			<cfset LogText = LogText & "--- Akismet did not think this message was spam.  If it was, please visit: #missedSpamURL#" />
		</cfif>

		<cfif StructKeyExists(TestResults,"TooManyUrls") AND NOT arguments.TestResults.tooManyUrls.Pass>
		      <cfset LogText = LogText & "--- There were too many URLs in the form contents." />
		</cfif>

		<cfif StructKeyExists(TestResults,"ProjHoneyPot") AND NOT arguments.TestResults.ProjHoneyPot.Pass>
		      <cfset LogText = LogText & "--- The user's IP address has been flagged by Project Honey Pot." />
		</cfif>

		<cfset LogText = LogText & "--- Failure score: #totalPoints#.  Your failure threshold: #getConfig().failureLimit#.  IP address: #request.remoteAddr#	User agent: #cgi.http_user_agent#	Previous page: #cgi.http_referer#" />

		<cflog file="#arguments.LogFile#" text="#LogText#" />
	</cffunction>

</cfcomponent>