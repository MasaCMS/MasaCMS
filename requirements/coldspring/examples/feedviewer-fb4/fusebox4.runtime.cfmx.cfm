<cftry>
<cfsilent>
<!---
Fusebox Software License
Version 1.0

Copyright (c) 2003, 2004, 2005 The Fusebox Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form or otherwise encrypted form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The end-user documentation included with the redistribution, if any, must include the following acknowledgment:

"This product includes software developed by the Fusebox Corporation (http://www.fusebox.org/)."

Alternately, this acknowledgment may appear in the software itself, if and wherever such third-party acknowledgments normally appear.

4. The names "Fusebox" and "Fusebox Corporation" must not be used to endorse or promote products derived from this software without prior written (non-electronic) permission. For written permission, please contact fusebox@fusebox.org.

5. Products derived from this software may not be called "Fusebox", nor may "Fusebox" appear in their name, without prior written (non-electronic) permission of the Fusebox Corporation. For written permission, please contact fusebox@fusebox.org.

If one or more of the above conditions are violated, then this license is immediately revoked and can be re-instated only upon prior written authorization of the Fusebox Corporation.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE FUSEBOX CORPORATION OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-------------------------------------------------------------------------------

This software consists of voluntary contributions made by many individuals on behalf of the Fusebox Corporation. For more information on Fusebox, please see <http://www.fusebox.org/>.

--->
<!---<cftrace category="core" text="runtime is executing" />--->
	<cfscript>
	  // copy all FORM and URL variables to ATTRIBUTES scope
	  // here, FORM has precendence although this can be over-written later depending on the application's fusebox.xml setting.
	  if (NOT IsDefined("attributes"))
	    attributes=structNew();
	  StructAppend(attributes, url, "yes");
	  StructAppend(attributes, form, "yes");
	  
	  // initialize the fusebox "working" structure (only for internal use of the core file(s) -- considered hands-off to developers
	  fb_ = structNew();
	  fb_.fuseQ = ArrayNew(1);
		fb_.COMMENT_CF_BEGIN = "<" & "!--- ";
		fb_.COMMENT_CF_END = " ---" & ">";
	  
	  fb_.osdelimiter = left(REreplace(getCurrentTemplatePath(), "[^\\/]", "", "all"), 1); //createObject("java", "java.io.File").separator;
	  
	  // initialize the myFusebox structure which is specific to a given request (can be read by the developer (and written to if creating plugins)
	  myFusebox = structNew();
	  myFusebox.version.runtime     = "unknown";
	  myFusebox.version.loader      = "unknown";
	  myFusebox.version.transformer = "unknown";
	  myFusebox.version.parser      = "unknown";
	  
	  myFusebox.version.runtime     = "4.1.0";
	  
	  myFusebox.thisCircuit = "";
	  myFusebox.thisFuseaction =  "";
	  myFusebox.thisPlugin = "";
	  myFusebox.thisPhase = "";
	  myFusebox.plugins = structNew();
	  myFusebox.parameters = structNew();
	  
	  myFusebox.parameters.load = true;
	  myFusebox.parameters.parse = true;
	  myFusebox.parameters.execute = true;
	  
	  myFusebox.parameters.userProvidedLoadParameter = false;
	  myFusebox.parameters.userProvidedParseParameter = false;
	  myFusebox.parameters.userProvidedExecuteParameter = false;
	  
	  // default myFusebox.parameters depending on "mode" of the application set in fusebox.xml
	  if (IsDefined("application.fusebox") AND IsDefined("application.fusebox.mode")) {
	    if (application.fusebox.mode EQ "development") {
	      myFusebox.parameters.load = true;
	  	   myFusebox.parameters.parse = true;
			myFusebox.parameters.execute = true;
	    }
	    if (application.fusebox.mode EQ "production") {
	      myFusebox.parameters.load = false;
			myFusebox.parameters.parse = false;
			myFusebox.parameters.execute = true;
	    }
	  }
	</cfscript>

	<!--- did the user pass in any special "fuseboxDOT" parameters for this request? --->
	<!--- If so, process them --->
	<!--- note: only if attributes.fusebox.password matches the application password --->
	<cfparam name="attributes['fusebox.password']" default="">
	<cfscript>
	  if (IsDefined("application.fusebox.password") AND application.fusebox.password EQ attributes['fusebox.password']) {
	    if (StructKeyExists(attributes, 'fusebox.load') and IsBoolean(attributes['fusebox.load'])) {
	      myFusebox.parameters.load = attributes['fusebox.load'];
		  myFusebox.parameters.userProvidedLoadParameter = true;
	    }
	    if (StructKeyExists(attributes, 'fusebox.parse') and IsBoolean(attributes['fusebox.parse'])) {
	      myFusebox.parameters.parse = attributes['fusebox.parse'];
		  myFusebox.parameters.userProvidedParseParameter = true;
	    }
	    if (StructKeyExists(attributes, 'fusebox.execute') and IsBoolean(attributes['fusebox.execute'])) {
	      myFusebox.parameters.execute = attributes['fusebox.execute'];
		  myFusebox.parameters.userProvidedExecuteParameter = true;
	    }
	  }
	  
	  // if application.fusebox doesn't already exist we definitely want to reload
	  if (NOT IsDefined("application.fusebox.isFullyLoaded") OR NOT application.fusebox.isFullyLoaded) {
	    myFusebox.parameters.load = true;
	  }
	</cfscript>
	  
	<!--- set up the appPath variable, which is the relative path from the web root to the app root --->
	<cfset fb_.appPathVarName = "FUSEBOX_APPLICATION_PATH" />
	<cfif NOT structKeyExists(variables, fb_.appPathVarName)>
		<cfthrow type="fusebox.missingAppPath"
			message="#fb_.appPathVarName# not found."
			detail="The required variable #fb_.appPathVarName# containing the relative path from the web root to the application root was not found.  If your web and application roots are the same directory, you can use the empty string as its value" />
	</cfif>
	<cfset fb_.appPath = variables[fb_.appPathVarName] />
	<!--- append a trailing slash, if needed --->
	<cfif right(fb_.appPath, 1) NEQ fb_.osdelimiter>
		<cfset fb_.appPath = fb_.appPath & fb_.osdelimiter />
	</cfif>
	
	<!--- if necessary, call the fusebox loader --->
	<cfif myFusebox.parameters.load>
		<cfset fb_.loaderFile="fusebox4.loader.cfmx.cfm" />
		<cfoutput>		
		<cftry>
			<cfinclude template="#fb_.loaderFile#">
			<!--- if we loaded the XML, we definitely want to parse --->
			<cfset myFusebox.parameters.parse = true />
			<cfset fb_.loaderForcedParse = true />
			<!---<cftrace category="core" text="loader has executed" />--->
			<cfcatch type="fusebox.LoadUnneeded">
				<!--- saving time!! --->
				<cfset myFusebox.parameters.load = false />
				<!---<cftrace category="core" text="loader aborted because it wasn't needed" />--->
			</cfcatch>
			<cfcatch type="missingInclude">
				<cfif right(cfcatch.missingFileName, Len(fb_.loaderFile)) EQ fb_.loaderFile>
					<cfthrow type="fusebox.missingCoreFile" message="core file not found." detail="The core file #fb_.loaderFile# was not found. All core files should be of the same version as the calling Runtime core file.">
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>
		</cfoutput>
	</cfif>
	
	<cfscript>
	  // make sure the correct structures are set up for myFusebox.plugins.{plugin-name} and any potential parameters it might have
	  for (fb_.aPlugin in application.fusebox.plugins) {
	    myFusebox.plugins[fb_.aPlugin] = structNew();
	  }
	  
	  // does this app give higher precedence to URL scope over FORM scope? If so, adjust
	  if (application.fusebox.precedenceFormOrURL EQ "URL") {
	    StructAppend(attributes, url, "yes");
	  }
	  
	</cfscript>
	
	<!--- if it exists, load the fusebox.init file in the application root --->
	<cftry>
		<cfinclude template="#application.fusebox.CoreToAppRootPath#fusebox.init.cfm">
		<!---<cftrace category="file" text="fusebox.init has executed" />--->
		<cfcatch type="MissingInclude"><!--- do nothing ---></cfcatch>
	</cftry>
	
	<cfscript>
	  // how about a default fuseaction?
	  if (NOT IsDefined('attributes.#application.fusebox.fuseactionVariable#') OR attributes[application.fusebox.fuseactionVariable] EQ "") {
	    attributes[application.fusebox.fuseactionVariable] = application.fusebox.defaultFuseaction;
	  }
	  
	  // copy the value of the fuseactionVariable into the variable "attributes.fuseaction" for standardization
	  attributes.fuseaction = attributes[application.fusebox.fuseactionVariable];
	</cfscript>
	
	<!--- set the myFusebox.originalCircuit, myFusebox.originalFuseaction --->
	<cfif ListLen(attributes.fuseaction, '.') EQ 2>
	  <cfscript>
	    myFusebox.thisCircuit    = ListFirst(attributes.fuseaction, '.');
	    myFusebox.thisFuseaction = ListLast(attributes.fuseaction, '.');
		 myFusebox.originalCircuit    = myFusebox.thisCircuit;
		 myFusebox.originalFuseaction = myFusebox.thisFuseaction;
	  </cfscript>
	<cfelse>
		<cfthrow type="fusebox.malformedFuseaction" message="malformed Fuseaction" detail="You specified a malformed Fuseaction of #attributes.fuseaction#.  A fully qualified Fuseaction must be in the form [Circuit].[Fuseaction].">	
	</cfif>
	
	<!--- if the circuit specified by myFusebox.originalCircuit does not exist throw an error --->
	<!--- if the fuseaction specified by myFusebox.originalFuseaction does not exist throw an error --->
	
	<cfif NOT IsDefined("application.fusebox.circuits.#myFusebox.originalCircuit#")>
		<cfthrow type="fusebox.undefinedCircuit" message="undefined Circuit" detail="You specified a Circuit of #myFusebox.originalCircuit# which is not defined.">
	<cfelse>
		<cfif NOT IsDefined("application.fusebox.circuits.#myFusebox.originalCircuit#.fuseactions.#myFusebox.originalFuseaction#")>
			<cfthrow type="fusebox.undefinedFuseaction" message="undefined Fuseaction" detail="You specified a Fuseaction of #myFusebox.originalFuseaction# which is not defined in Circuit #myFusebox.originalCircuit#.">
		</cfif>
	</cfif>
	
	<!--- ensure that the fuseaction has access="public" --->
	<!---<cfset fb_.xnAccess = xmlSearch(CircuitXML, "//circuit/fuseaction[@name='#fuseaction#']")>--->
	<!--- <cfset fb_.xnAccess = xmlSearch(fb_.CircuitXML, "//circuit/fuseaction[translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='#lcase(myFusebox.thisFuseaction)#']")> --->
	<cfif application.fusebox.circuits[myFusebox.originalCircuit].fuseactions[myFusebox.thisFuseaction].access NEQ "public">
		<cfthrow type="fusebox.InvalidAccessModifier" message="Invalid Access Modifier" detail="You tried to access #myFusebox.originalCircuit#.#myFusebox.originalFuseaction# which does not have access modifier of public. A Fuseaction which is to be accessed from anywhere outside the application (such as called via an URL, or a FORM, or as a web service) must have an access modifier of public or if unspecified at least inherit such a modifier from its circuit.">
	</cfif>
	
	<!--- here is the file to be parsed --->
	<cfset fb_.file2Parse = trim("#application.fusebox.parsePath#" & lcase("#myFusebox.originalCircuit#.#myFusebox.originalFuseaction#.#application.fusebox.scriptFileDelimiter#"))>
	<cfset fb_.assertedfile2Parse = trim("#application.fusebox.parsePath#" & "_" & lcase("#myFusebox.originalCircuit#.#myFusebox.originalFuseaction#.#application.fusebox.scriptFileDelimiter#"))>
	<cfset fb_.file2ParsePath = application.fusebox.approotdirectory & fb_.file2Parse />
	
	<cfif NOT fileExists(fb_.file2ParsePath)>
		<cfset myFusebox.parameters.parse = true />
	</cfif>

	<!--- see if we can avoid the parse file generation --->
	<cfif isDefined("application.fusebox.conditionalParse") AND application.fusebox.conditionalParse AND myFusebox.parameters.parse>
		<cftry>
			<!--- if we're in production mode, do the parse --->
			<cfif application.fusebox.mode NEQ "development">
				<cfthrow type="fusebox.forceParseException.production"
					message="If we're in production mode, we must really want the parse to happen" />
			</cfif>
			
			<!--- the XML was reloaded, so we need to parse --->
			<cfif structKeyExists(fb_, "loaderForcedParse") AND fb_.loaderForcedParse>
				<cfthrow type="fusebox.forceParseException.loaderForcedParse"
					message="The loader ran, so we must reparse" />
			</cfif>
			
			<!--- the user requested a parse --->
			<cfif myFusebox.parameters.userProvidedParseParameter AND attributes["fusebox.parse"]>
				<cfthrow type="fusebox.forceParseException.userRequestedParse"
					message="The user requested a parse" />
			</cfif>
			
			<!--- see if the parse file is older than the last full load --->
			<cfdirectory action="list"
				directory="#getDirectoryFromPath(fb_.file2ParsePath)#"
				name="fb_.dirlist"
				filter="#getFileFromPath(fb_.file2ParsePath)#" />
			<cfif fb_.dirlist.recordCount NEQ 1>
				<cfthrow type="fusebox.forceParseException.parseFileNotFound"
					message="The parse file does not exist" />
			</cfif>
			<cfset fb_.parseFileTimestamp = parseDateTime(fb_.dirlist.datelastmodified) />
			<cfif parseDateTime(application.fusebox.dateLastLoaded) GT fb_.parseFileTimestamp>
				<cfthrow type="fusebox.forceParseException.InMemoryIsNewer"
					message="The in-memory structure is newer than the existing parse file" />
			</cfif>
			
			<!--- see if the parse file is older than any plugin file --->
			<cfset fb_.scannedDirectories = "" />
			<cfloop list="fuseactionException,processError" index="fb_.phase">
				<cfloop from="1" to="#arrayLen(application.fusebox.pluginphases[fb_.phase])#" index="fb_.plugin">
					<cfset fb_.path = "#application.fusebox.pluginphases[fb_.phase][fb_.plugin].path##application.fusebox.pluginphases[fb_.phase][fb_.plugin].template#" />
					<cfif listFindNoCase(fb_.scannedDirectories, fb_.path, chr(5)) EQ 0>
						<cfdirectory action="list"
							directory="#getDirectoryFromPath('#application.fusebox.approotdirectory##fb_.path#')#"
							name="fb_.dirlist" />
						<cfloop query="fb_.dirlist">
							<cfif type EQ "file" AND parseDateTime(dateLastModified) GT fb_.parseFileTimestamp>
								<cfthrow type="fusebox.forceParseException.pluginIsNewer"
									message="A plugin file (#fb_.path#) is newer than the existing parse file" />
							</cfif>
						</cfloop>
						<cfset fb_.scannedDirectories = listAppend(fb_.scannedDirectories, fb_.path, chr(5)) />
					</cfif>
				</cfloop>
			</cfloop>
			
			<!--- see if the parse file is older than any lexicon file --->
			<cfset fb_.scannedDirectories = "" />
			<cfloop collection="#application.fusebox.lexicons#" item="fb_.lex">
				<cfset fb_.path = application.fusebox.lexiconPath & application.fusebox.lexicons[fb_.lex].path />
				<cfif listFindNoCase(fb_.scannedDirectories, fb_.path, chr(5)) EQ 0>
					<cfdirectory action="list"
						directory="#application.fusebox.approotdirectory##fb_.path#"
						name="fb_.dirlist" />
					<cfloop query="fb_.dirlist">
						<cfif type EQ "file" AND parseDateTime(dateLastModified) GT fb_.parseFileTimestamp>
							<cfthrow type="fusebox.forceParseException.lexiconIsNewer"
								message="A file (#name#) in the #fb_.lex# lexicon (#fb_.path#) is newer than the existing parse file" />
						</cfif>
					</cfloop>
					<cfset fb_.scannedDirectories = listAppend(fb_.scannedDirectories, fb_.path, chr(5)) />
				</cfif>
			</cfloop>
		
			<!--- check the core files and see if any are newer than the parse file --->
			<!--- this is theoretically unneeded since it exists in the conditionalLoad as well,
				and if a load is performed a parse will be forced, but it's here as well
				for completeness' sake
			 --->
			<cfdirectory action="list"
				directory="#getDirectoryFromPath(getCurrentTemplatePath())#"
				name="fb_.dirlist" />
			<cfloop query="fb_.dirlist">
				<cfif type EQ "file" AND parseDateTime(datelastmodified) GT fb_.parseFileTimestamp>
					<cfthrow type="fusebox.forceParseException.coreFileIsNewer"
						message="The #name# core is newer than the existing parse file." />
				</cfif>
			</cfloop>
	
			<!--- if we've gotten this far, the parse file is present and up to date, so skip the parse --->
			<!---<cftrace category="core" text="parse file is up to date" />--->
			<cfthrow type="fusebox.parseUnneededException"
				message="Parse file regeneration is deemed unneeded because it appears to be up to date" />
			
			<cfcatch type="fusebox.forceParseException">
				<cfset myFusebox.parameters.parse = true />
			</cfcatch>
			<cfcatch type="fusebox.parseUnneededException">
				<cfset myFusebox.parameters.parse = false />
			</cfcatch>
		</cftry>
	</cfif>

	<!--- if we need to re-parse, call the Transformer and Parser --->
	<cfif myFusebox.parameters.parse>
	
		<!--- call the Transformer --->
		<cfset fb_.transformerFile = "fusebox4.transformer.#application.fusebox.scriptlanguage#.cfm" />
		<cfoutput>		
		<cftry>
			<cfinclude template="#fb_.transformerFile#">
			<!---<cftrace category="core" text="transformer has executed" />--->
			<cfcatch type="missingInclude">
				<cfif right(cfcatch.missingFileName, Len(fb_.transformerFile)) EQ fb_.transformerFile>
					<cfthrow type="fusebox.missingCoreFile" message="core file not found." detail="The core file #fb_.transformerFile# was not found. All core files should be of the same version as the calling Runtime core file.">
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>
		</cfoutput>
	
		<!--- call the Parser --->
		<cfset fb_.parserFile="fusebox4.parser.#application.fusebox.scriptlanguage#.cfm" />
		<cfoutput>		
		<cftry>
			<cfinclude template="#fb_.parserFile#">
			<!---<cftrace category="core" text="parser has executed" />--->
			<cfcatch type="missingInclude">
				<cfif right(cfcatch.missingFileName, Len(fb_.parserFile)) EQ fb_.parserFile>
					<cfthrow type="fusebox.missingCoreFile" message="core file not found." detail="The core file #fb_.parserFile# was not found. All core files should be of the same version as the calling Runtime core file.">
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>
		</cfoutput>
		
		<cfscript>
			fb_.parsedfilecontents = fb_.parsedfile;
			fb_.devparsedfilecontents = fb_.parsedfile;
			/* (old version)
			// strip out the comments around the assertion flags for development mode parsed file
			fb_.devparsedfilecontents = ReplaceNoCase(fb_.devparsedfilecontents, '<!-'&'--<assertion>', '', 'ALL');
			fb_.devparsedfilecontents = ReplaceNoCase(fb_.devparsedfilecontents, '</assertion>--'&'->', '', 'ALL');
			  (/old version)
			*/
			// for production mode file, strip out the entire assertion
			fb_.parsedfilecontents = REReplace(fb_.parsedfilecontents,"(#fb_.COMMENT_CF_BEGIN#<assertion>)(.*?)(</assertion>#fb_.COMMENT_CF_END#)","","ALL");
			// for development mode file, strip out the <!- --<assertion> (and its closing tag) but leave the content in-between
			fb_.devparsedfilecontents = REReplace(fb_.devparsedfilecontents,"(#fb_.COMMENT_CF_BEGIN#<assertion>)(.*?)(</assertion>#fb_.COMMENT_CF_END#)","\2","ALL");
		</cfscript>
		
		<cflock name="#application.fusebox.approotdirectory##fb_.file2Parse#" timeout="30" type="Exclusive">
			<!--- delete the old parsed file --->
			<cfif FileExists(application.fusebox.approotdirectory & fb_.file2Parse)>
				<cftry>
				<cffile action="DELETE" file="#application.fusebox.approotdirectory##fb_.file2Parse#">
				<cfcatch>
				<!--- no comment --->
				</cfcatch>
				</cftry>
			</cfif>
			<cfif application.fusebox.mode NEQ "production">
				<!--- delete the old dev parsed file --->
				<cfif FileExists(application.fusebox.approotdirectory & fb_.assertedfile2Parse)>
					<cftry>
					<cffile action="DELETE" file="#application.fusebox.approotdirectory##fb_.assertedfile2Parse#">
					<cfcatch>
					<!--- no comment --->
					</cfcatch>
					</cftry>
				</cfif>
			</cfif>
		
			<!--- write out the parsed file --->	
			<cftry>
				<cffile action="WRITE" file="#application.fusebox.approotdirectory##fb_.file2Parse#" output="#fb_.parsedfilecontents#" charset="#application.fusebox.characterEncoding#" mode="660">	
				<cfcatch>
					<cfthrow type="fusebox.errorWritingParsedFile" message="An Error during write of Parsed File or Parsing Directory not found." detail="Attempting to write the parsed file '#fb_.file2Parse#' threw an error. This can also occur if the parsed file directory cannot be found.">
				</cfcatch>
			</cftry>
	
			<cfparam name="fb_.hasAssertions" default="false" type="boolean"/>
			<cfif application.fusebox.mode NEQ "production">
			<!--- write out the devparsed file --->
				<cfif fb_.hasAssertions>
					<cftry>
						<cffile action="WRITE" file="#application.fusebox.approotdirectory##fb_.assertedfile2Parse#" output="#fb_.devparsedfilecontents#" charset="#application.fusebox.characterEncoding#" mode="660">	
						<cfcatch>
							<cfthrow type="fusebox.errorWritingParsedFile" message="An Error during write of Parsed File or Parsing Directory not found." detail="Attempting to write the parsed file '#fb_.assertedfile2Parse#' threw an error. This can also occur if the parsed file directory cannot be found.">
						</cfcatch>
					</cftry>
				</cfif>	
			</cfif>
		</cflock>
		
	</cfif>
</cfsilent>

<cfprocessingdirective suppresswhitespace="Yes">
	<!--- OK, now execute everything --->
	<cfif myFusebox.parameters.execute>
		<cfif application.fusebox.useAssertions EQ "true" AND FileExists(application.fusebox.approotdirectory & fb_.assertedfile2Parse)>
			<cfset fb_.file2Execute = fb_.assertedfile2Parse />
		<cfelse>
			<cfset fb_.file2Execute = fb_.file2Parse />
		</cfif>
		<cftry>
		<cfinclude template="#application.fusebox.CoreToAppRootPath##fb_.file2Execute#">
		<!---<cftrace category="file" text="generated parse file has executed" />--->
		<cfcatch type="missingInclude">
			<cfif right(cfcatch.missingFileName, Len(fb_.file2Parse)) EQ fb_.file2Parse>
				<cfoutput>
				<cfthrow type="fusebox.missingParsedFile" message="Parsed File or 
		Directory not found." detail="Attempting to execute the parsed file 
		'#fb_.file2Execute#' threw an error. This can occur if the parsed file does 
		not exist in the parsed directory or if the parsed directory itself is 
		missing.">
				</cfoutput>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>
</cfprocessingdirective>
	
	<!--- here's where we catch fusebox core file errors --->
	<cfcatch type="fusebox">
		<cfif isDefined("application.fusebox.errortemplatesPath")>
			<cfset fb_.type = cfcatch.type />
			<cfset fb_.errorFile = application.fusebox.errortemplatesPath & fb_.type & ".cfm" />
			<cfloop condition="NOT fileExists(application.fusebox.approotdirectory & fb_.errorFile) AND len(fb_.type) GT 0">
				<cfset fb_.type = listDeleteAt(fb_.type, listLen(fb_.type, "."), ".") />
				<cfset fb_.errorFile = application.fusebox.errortemplatesPath & fb_.type & ".cfm" />
			</cfloop>
			<cfif FileExists(application.fusebox.approotdirectory & fb_.errorFile)>
				<cfinclude template="#application.fusebox.CoreToAppRootPath##fb_.errorFile#"/>
			<cfelse>
				<cfrethrow><!--- if no appropriate errorTemplate is specified, then rethrow the expected error --->
			</cfif>
		<cfelse>
			<cfrethrow><!--- no errortemplates directory defined --->
		</cfif>
	</cfcatch>
</cftry>
