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

<!--- which version of the parser is this? --->
<cfset myFusebox.version.parser = "4.1.0" />

<cfif myFusebox.version.runtime NEQ myFusebox.version.parser>
	<cfthrow type="fusebox.versionMismatchException"
		message="The parser is not the same version as the runtime" />
</cfif>

<cffunction name="fb_appendLine" output="false" returntype="void">
	<cfargument name="lineContent" type="string" required="true" />
	<cfset fb_appendIndent() />
	<cfset fb_appendSegment(lineContent) />
	<cfset fb_appendNewline() />
</cffunction>

<cffunction name="fb_appendIndent" output="false" returntype="void">
	<cfset fb_appendSegment(repeatString(fb_.indentBlock, min(fb_.maxIndentLevel, fb_.indentLevel))) />
</cffunction>

<cffunction name="fb_appendSegment" output="false" returntype="void">
	<cfargument name="segmentContent" type="string" required="true" />
	<cfset fb_.parsedFile = fb_.parsedFile & segmentContent />
</cffunction>

<cffunction name="fb_appendNewline" output="false" returntype="void">
	<cfset fb_appendSegment(fb_.CRLF) />
</cffunction>

<cffunction name="fb_increaseIndent" output="false" returntype="void">
	<cfset fb_.indentLevel = fb_.indentLevel + 1 />
</cffunction>

<cffunction name="fb_decreaseIndent" output="false" returntype="void">
	<cfset fb_.indentLevel = max(fb_.indentLevel - 1, 0) />
</cffunction>

<cffunction name="fb_throw" output="false" returntype="void">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="message" type="string" required="false" default="" />
	<cfargument name="detail" type="string" required="false" default="" />
	<cfif left(type, len("fusebox.badGrammar")) NEQ "fusebox.badGrammar" OR NOT application.fusebox.ignoreBadGrammar>
		<cfthrow type="#type#" message="#message#" detail="#detail#" />
	<cfelse>
		<cfthrow type="fusebox.continueException" />
	</cfif>
</cffunction>

<cfscript>
	// prepare to create the fuseaction file
	fb_.parsedfile = "";
	fb_.CRLF = chr(10);	
	
	// this variable tracks the current level of indentation
	fb_.indentLevel = 0;
	fb_.indentBlock = chr(9);
	// we'll just assume that no one is going to look at a parse file with
	// more than 1000 levels of indentation.
	fb_.maxIndentLevel = iif(application.fusebox.parseWithIndentation, 1000, 0);
	
	// cut down on white space a bit
	fb_appendLine('<cfsetting enablecfoutputonly="Yes">');
	
	// set the character encoding for this file
	fb_appendLine('<cfprocessingdirective pageencoding="' & application.fusebox.characterEncoding & '">');
	
	// if any plugins were defined for the processError phase then insert an opening tag for <cftry> here
	if (arrayLen(application.fusebox.pluginphases['processError']) GT 0) {
		fb_appendLine("<cftry>");
	}
</cfscript>

<!--- now parse the Fusebox XML grammar --->
<cfloop from="1" to="#arrayLen(fb_.fuseQ)#" index="fb_.i">
<cftry><!--- the first part of the hack to let us have a CFCONTINUE tag --->
	<cfscript>
		if (listLen(fb_.fuseQ[fb_.i].xmlName, '.') GT 1) {
			fb_.lexicon = listFirst(fb_.fuseQ[fb_.i].xmlName, '.');
			fb_.lexiconVerb = listRest(fb_.fuseQ[fb_.i].xmlName, '.');
		} else {
			fb_.lexiconVerb = fb_.fuseQ[fb_.i].xmlName;
			fb_.lexicon = 'fusebox';
		}
		
		if (application.fusebox.parseWithComments) {
			fb_.parsedComment = '';
			fb_.parsedComment = fb_.parsedComment & '#fb_.fuseQ[fb_.i].circuit#.#fb_.fuseQ[fb_.i].fuseaction#: ';
			fb_.parsedComment = fb_.parsedComment & '<#lcase(fb_.lexicon)#:#lcase(fb_.lexiconVerb)#';
			for (fb_.attr in fb_.fuseQ[fb_.i].xmlAttributes) {
				if (fb_.attr NEQ "circuit")
					fb_.parsedComment = fb_.parsedComment & ' #fb_.attr#="#fb_.fuseQ[fb_.i].xmlAttributes[fb_.attr]#"';
				}
			fb_.parsedComment = fb_.parsedComment & '>';
			fb_appendLine(fb_.COMMENT_CF_BEGIN & ljustify(fb_.parsedComment, 75) & fb_.COMMENT_CF_END);
		}
	</cfscript>
	
	<cfswitch expression="#fb_.fuseQ[fb_.i].xmlName#">

		<cfcase value="set,xfa">
		<cfscript>
			// throw an error if we have an overwrite attribute, but no name attribute
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "name")) {
				fb_throw("fusebox.badGrammar.invalidAttributeSet",
					"If you specify the OVERWRITE attribute to a SET or XFA verb, you must also specify the NAME attribute",
					"The error occurred in the #fb_.fuseQ[fb_.i].circuit#.#fb_.fuseQ[fb_.i].fuseaction# fuseaction"
				);
			}
			// bit of massaging if this is the <xfa> verb
			if (fb_.fuseQ[fb_.i].xmlName EQ "xfa") {
				// throw an error if we don't have a name
				if ( NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "name") OR NOT Len( fb_.fuseQ[fb_.i].xmlAttributes.name) ) {
					fb_throw("fusebox.badGrammar.requiredAttributeMissing",
						"The XFA verb requires a NAME attribute",
						"The error occurred in the #fb_.fuseQ[fb_.i].circuit#.#fb_.fuseQ[fb_.i].fuseaction# fuseaction"
					);
				}
				//prepend "xfa." to the value of the "name" attribute
				fb_.fuseQ[fb_.i].xmlAttributes.name = "xfa." & fb_.fuseQ[fb_.i].xmlAttributes.name;
				//assume no circuit specified means the current circuit
				if (ListLen(fb_.fuseQ[fb_.i].xmlAttributes.value, '.') LTE 1) {
					fb_.fuseQ[fb_.i].xmlAttributes.value = fb_.fuseQ[fb_.i].circuit & '.' & fb_.fuseQ[fb_.i].xmlAttributes.value;
				}
			}
			// if the attribute 'overwrite' is FALSE then treat this like a CFPARAM
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
				fb_appendLine('<cfif NOT IsDefined("' & fb_.fuseQ[fb_.i].xmlAttributes.name & '")>');
				fb_increaseIndent();
			}
			fb_appendIndent();
			// if the 'name' attribute has any pound ( that is, chr(35) ) signs in it, we'll need double quotes to evaluate the dynamic variable name
			fb_appendSegment('<cfset ');
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "name") AND Len( fb_.fuseQ[fb_.i].xmlAttributes.name)) {
				if ( FindNoCase( chr(35) , fb_.fuseQ[fb_.i].xmlAttributes.name ) ) {
					fb_appendSegment('"#fb_.fuseQ[fb_.i].xmlAttributes.name#"');
				}
				else {
					fb_appendSegment('#fb_.fuseQ[fb_.i].xmlAttributes.name#');
				}
				fb_appendSegment(' = ');
			}
			// if the attributes 'evaluate' is TRUE the use the evaluate function
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "evaluate") AND fb_.fuseQ[fb_.i].xmlAttributes.evaluate) {
				fb_appendSegment('Evaluate("' &  fb_.fuseQ[fb_.i].xmlAttributes.value & '")>');
			}
			else {
				fb_appendSegment('"' &  fb_.fuseQ[fb_.i].xmlAttributes.value & '">');
			}
			fb_appendNewline();
			// if the attribute 'overwrite' is FALSE then treat this like a CFPARAM
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
				fb_decreaseIndent();
				fb_appendLine('</cfif>');
			}
		</cfscript>
		</cfcase>

		<cfcase value="invoke">
		<cfscript>
			// if returning a value and the attribute 'overwrite' is FALSE then treat this like a CFPARAM
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "returnVariable") AND LEN(fb_.fuseQ[fb_.i].xmlAttributes.returnVariable) AND StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
				fb_appendLine('<cfif NOT IsDefined("' & fb_.fuseQ[fb_.i].xmlAttributes.returnVariable & '")>');
				fb_increaseIndent();
			}
			// if the 'returnVariable' attribute has any pound ( that is, chr(35) )signs in it, we'll need double quotes to evaluate the dynamic variable name
			fb_appendIndent();
			fb_appendSegment('<cfset ');
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "returnVariable") AND LEN(fb_.fuseQ[fb_.i].xmlAttributes.returnVariable) ) {
				if ( FindNoCase( chr(35) , fb_.fuseQ[fb_.i].xmlAttributes.returnVariable ) ) {
					fb_appendSegment('"#fb_.fuseQ[fb_.i].xmlAttributes.returnVariable#"');
				}
				else {
					fb_appendSegment('#fb_.fuseQ[fb_.i].xmlAttributes.returnVariable#');
				}
				fb_appendSegment(' = ');
			}    
			
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "object")) {
				fb_appendSegment(fb_.fuseQ[fb_.i].xmlAttributes.object & '.' & fb_.fuseQ[fb_.i].xmlAttributes.methodcall & ' />');
			}
			else if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "class")) {
				fb_appendSegment("createObject('" & application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].type & "', '" & application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].classpath  & "')");
				fb_appendSegment("." & fb_.fuseQ[fb_.i].xmlAttributes.methodcall & ' />');
			}
			else if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "webservice")) {
				fb_appendSegment(fb_.fuseQ[fb_.i].xmlAttributes.webservice & '.' & fb_.fuseQ[fb_.i].xmlAttributes.methodcall & ' />');
			}
			else {
				fb_throw("fusebox.badGrammar.noInvokeeException",
					"Bad Grammar verb in circuit file",
					"A bad grammar construct was encountered in the circuit '#fb_.fuseQ[fb_.i].circuit#' caused by not providing a object, class, or webservice attribute to the INVOKE verb."
				);
			}
			fb_appendNewline();
			// if returning a value and the attribute 'overwrite' is FALSE then treat this like a CFPARAM
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "returnVariable") AND StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
				fb_decreaseIndent();
				fb_appendLine('</cfif>');
			}
		</cfscript>
		</cfcase>		
		
		<cfcase value="instantiate">
		<cfscript>
			// give empty value for arguments if not specified
			if (NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "arguments")) {
				fb_.fuseQ[fb_.i].xmlAttributes.arguments = "";
			}
			// if returning a value and the attribute 'overwrite' is FALSE then treat this like a CFPARAM
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
				fb_appendIndent();
				fb_appendSegment('<cfif NOT IsDefined("' & fb_.fuseQ[fb_.i].xmlAttributes.object & '")>');
				fb_increaseIndent();
			}
			// if the 'object' attribute has any pound ( that is, chr(35) )signs in it, we'll need double quotes to evaluate the dynamic variable name
			fb_appendIndent();
			fb_appendSegment('<cfset ');
			if ( FindNoCase( chr(35) , fb_.fuseQ[fb_.i].xmlAttributes.object ) ) {
				fb_appendSegment('"#fb_.fuseQ[fb_.i].xmlAttributes.object#"');
			}
			else {
				fb_appendSegment('#fb_.fuseQ[fb_.i].xmlAttributes.object#');
			}
			fb_appendSegment(' = ');
			
			if ( StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes,"class") AND Len(fb_.fuseQ[fb_.i].xmlAttributes.class) ) {
				//creating a reference to a class
				fb_appendSegment("createObject('" & application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].type & "', '" & application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].classpath & "') />");
				if (application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].type EQ "component" AND StructKeyExists(application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class],"constructor") AND Len(application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].constructor) ) {
					// if CFML, call a constructor if specified (in Java constructor is called automatically)
					fb_appendSegment('<cfset ' & fb_.fuseQ[fb_.i].xmlAttributes.object & '.' & application.fusebox.classes[fb_.fuseQ[fb_.i].xmlAttributes.class].constructor & '(' & fb_.fuseQ[fb_.i].xmlAttributes.arguments & ')');
				}
			} else if ( StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "webservice") AND Len(fb_.fuseQ[fb_.i].xmlAttributes.webservice) ) {
				// else creating a webservice
				fb_appendSegment("createObject('webservice', '" & fb_.fuseQ[fb_.i].xmlAttributes.webservice & "')");
			}
			
			fb_appendSegment(' />');
			// if returning a value and the attribute 'overwrite' is FALSE then treat this like a CFPARAM
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite") AND NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
				fb_decreaseIndent();
				fb_appendLine('</cfif>');
			}
		</cfscript>
		</cfcase>

		<cfcase value="include">
		<cfscript>
			fb_.template = fb_.fuseQ[fb_.i].xmlAttributes.template;
			fb_.templateDelimiter = ListLast(fb_.template, '.');
			if (NOT ( ListFindNoCase(application.fusebox.maskedFileDelimiters, fb_.templateDelimiter, ',') OR ListFindNoCase(application.fusebox.maskedFileDelimiters, '*', ',') )) {
				fb_.template = fb_.template & '.' & application.fusebox.scriptFileDelimiter;
			}
			if ( NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "required")) {
				StructInsert(fb_.fuseQ[fb_.i].xmlAttributes, "required", "true");
			}
			if ( NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "contentvariable")) {
				fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"] = "";
			}
			if ( (NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "overwrite")) OR fb_.fuseQ[fb_.i].xmlAttributes.overwrite NEQ "false" ) {
				fb_.fuseQ[fb_.i].xmlAttributes["overwrite"] = "true";
			}
			if ( (NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "append")) OR fb_.fuseQ[fb_.i].xmlAttributes.overwrite NEQ "true" ) {
				fb_.fuseQ[fb_.i].xmlAttributes["append"] = "false";
			}
			if ( (NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "prepend")) OR fb_.fuseQ[fb_.i].xmlAttributes.overwrite NEQ "true" ) {
				fb_.fuseQ[fb_.i].xmlAttributes["prepend"] = "false";
			}
						
			if ( len(fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]) AND fb_.fuseQ[fb_.i].xmlAttributes["overwrite"] IS FALSE ) {
				fb_appendLine('<cfif NOT IsDefined("#fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]#")>');
				fb_increaseIndent();
			}

	  	fb_appendLine('<cftry>');
			fb_increaseIndent();
			
				if ( len(fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]) ) {
					if ( fb_.fuseQ[fb_.i].xmlAttributes["append"] IS TRUE OR fb_.fuseQ[fb_.i].xmlAttributes["prepend"] IS TRUE ) {
						fb_appendLine('<cfparam name="#fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]#" default="">');
					}
					fb_appendIndent();
					fb_appendSegment('<cfsavecontent variable="#fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]#">');
					fb_increaseIndent();
					if ( fb_.fuseQ[fb_.i].xmlAttributes["append"] IS TRUE ) {
						fb_appendSegment('<cfoutput>###fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]###</cfoutput>');
					}
				} else {
					fb_appendIndent();
				}
				fb_appendSegment('<cfoutput><cfinclude template="' & REreplace(application.fusebox.parseRootPath & application.fusebox.circuits[fb_.fuseQ[fb_.i].xmlAttributes.circuit].path & fb_.template, "\\/", application.fusebox.osdelimiter, "all") & '"></cfoutput>');
				
				if ( len(fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]) ) {
					if ( fb_.fuseQ[fb_.i].xmlAttributes["prepend"] IS TRUE ) {
						fb_appendSegment('<cfoutput>###fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]###</cfoutput>');
					}
					fb_decreaseIndent();
					fb_appendSegment('</cfsavecontent>');
					if ( fb_.fuseQ[fb_.i].xmlAttributes["prepend"] IS TRUE ) {
						fb_appendLine('<cfparam name="#fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]#" default="">');
					}

				}
				fb_appendNewline();
		  
			
				fb_appendLine('<cfcatch type="missingInclude">');
				fb_increaseIndent();
					fb_appendLine('<cfif Right(cfcatch.missingFilename, len("#application.fusebox.circuits[fb_.fuseQ[fb_.i].xmlAttributes.circuit].path##fb_.template#") ) EQ "#application.fusebox.circuits[fb_.fuseQ[fb_.i].xmlAttributes.circuit].path##fb_.template#">');
					fb_increaseIndent();
						if ( fb_.fuseQ[fb_.i].xmlAttributes['required'] IS TRUE) {
							fb_appendLine('<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse #fb_.fuseQ[fb_.i].xmlAttributes.template# in circuit #fb_.fuseQ[fb_.i].xmlAttributes.circuit# which does not exist.">');
						} else {
							fb_appendLine(fb_.COMMENT_CF_BEGIN & 'do nothing' & fb_.COMMENT_CF_END);
						}
					fb_decreaseIndent();
					fb_appendLine('<cfelse>');
					fb_increaseIndent();
						fb_appendLine('<cfrethrow>');
					fb_decreaseIndent();
					fb_appendLine('</cfif>');
				fb_decreaseIndent();
				fb_appendLine('</cfcatch>');
			fb_decreaseIndent();
			fb_appendLine('</cftry>');
			
			if ( len(fb_.fuseQ[fb_.i].xmlAttributes["contentvariable"]) AND fb_.fuseQ[fb_.i].xmlAttributes["overwrite"] IS FALSE ) {
				fb_decreaseIndent();
				fb_appendLine('</cfif>');
			}
		</cfscript>
		</cfcase>

		<cfcase value="plugin">
		<cfscript>
			fb_.template = fb_.fuseQ[fb_.i].plugin.template;
			fb_.templateDelimiter = ListLast(fb_.template, '.');
			if (NOT ( ListFindNoCase(application.fusebox.maskedFileDelimiters, fb_.templateDelimiter, ',')
				OR ListFindNoCase(application.fusebox.maskedFileDelimiters, '*', ',') )) {
					fb_.template = fb_.template & '.' & application.fusebox.scriptFileDelimiter;
			}
			fb_appendLine('<cfset myFusebox.thisPlugin  = "' & fb_.fuseQ[fb_.i].plugin.name & '">');
			fb_appendLine('<cfset myFusebox.thisPhase  = "' & fb_.fuseQ[fb_.i].phase & '">');
			fb_appendLine('<cfoutput><cfinclude template="' & application.fusebox.parseRootPath & REreplace(fb_.fuseQ[fb_.i].plugin.path, "\\/", application.fusebox.osdelimiter, "all") & REreplace(fb_.template, "\\/", application.fusebox.osdelimiter, "all") & '"></cfoutput>');
		</cfscript>
		</cfcase>
		
		<cfcase value="errorHandler,exceptionHandler">
			<cfset fb_.handlerfile = application.fusebox.approotdirectory & REreplace(fb_.fuseQ[fb_.i].plugin.path, "\\/", application.fusebox.osdelimiter, "all") & REreplace(fb_.fuseQ[fb_.i].plugin.template, "\\/", application.fusebox.osdelimiter, "all")>
			<cffile action="read" file="#fb_.handlerfile#" variable="fb_.handlerfile" charset="#application.fusebox.characterEncoding#">
			<cfset fb_.handlerfile = repeatString(fb_.indentBlock, min(fb_.maxIndentLevel, fb_.indentLevel)) & REreplace(fb_.handlerfile, "([#chr(10)##chr(13)#])", "\1" & repeatString(fb_.indentBlock, min(fb_.maxIndentLevel, fb_.indentLevel)), "all") />
			<cfset fb_appendNewline() />
			<cfset fb_appendSegment(fb_.handlerfile) />
			<cfset fb_appendNewline() />
		</cfcase>

		<cfcase value="beginExceptionHandler">
			<cfset fb_appendLine("<cftry>") />
			<cfset fb_increaseIndent() />
		</cfcase>

		<cfcase value="endExceptionHandler">
			<cfset fb_decreaseIndent() />
			<cfset fb_appendLine("</cftry>") />
		</cfcase>

		<cfcase value="conditional">
		<cfscript>
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "mode")) {
				if (fb_.fuseQ[fb_.i].xmlAttributes['mode'] EQ "begin") {
					fb_appendLine("<cfif " & fb_.fuseQ[fb_.i].xmlAttributes['condition'] & ">");
					fb_increaseIndent();
				}
				else if (fb_.fuseQ[fb_.i].xmlAttributes['mode'] EQ "else") {
					fb_decreaseIndent();
					fb_appendLine("<cfelse>");
					fb_increaseIndent();
				}
				else if (fb_.fuseQ[fb_.i].xmlAttributes['mode'] EQ "end") {
					fb_decreaseIndent();
					fb_appendLine("</cfif>");
				}
			}
		</cfscript>
		</cfcase>

		<cfcase value="loop">
		<cfscript>
			// mode=begin 
			if (fb_.fuseQ[fb_.i].xmlAttributes['mode'] EQ "begin") {
				if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, 'condition')) {
					fb_appendLine('<cfloop condition="' & fb_.fuseQ[fb_.i].xmlAttributes['condition'] & '">');
				} 
				else if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, 'query')) {
					fb_appendLine('<cfloop query="' & fb_.fuseQ[fb_.i].xmlAttributes['query'] & '">');
				} 
				else if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, 'from')
					AND StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, 'to')
					AND StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, 'index')) {
						if (NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, 'step')) {
							fb_.fuseQ[fb_.i].xmlAttributes.step = 1;
						}
						fb_appendLine('<cfloop from="' & fb_.fuseQ[fb_.i].xmlAttributes['from'] & '"'
							& ' to="' & fb_.fuseQ[fb_.i].xmlAttributes['to'] & '"'
							& ' index="' & fb_.fuseQ[fb_.i].xmlAttributes['index'] & '"'
							& ' step="' & fb_.fuseQ[fb_.i].xmlAttributes['step'] & '"'
							& '>');
				}
				fb_increaseIndent();
			} else { // mode=end
				fb_decreaseIndent();
				fb_appendline("</cfloop>");
			}
		</cfscript>
		</cfcase>
		
		<cfcase value="contentvariable">
		<cfscript>
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "mode")) {
				if (fb_.fuseQ[fb_.i].xmlAttributes['mode'] EQ "begin") {
					if (fb_.fuseQ[fb_.i].xmlAttributes.overwrite EQ "false") {
						fb_appendLine('<cfif NOT isDefined("' & fb_.fuseQ[fb_.i].xmlAttributes['contentvariable'] & '")>');
						fb_increaseIndent();
					}
					fb_appendLine('<cfsavecontent variable="' & fb_.fuseQ[fb_.i].xmlAttributes['contentvariable'] & '">');
					fb_increaseIndent();
					if (fb_.fuseQ[fb_.i].xmlAttributes.append EQ "true") {
						fb_appendLine('<cfparam name="'& fb_.fuseQ[fb_.i].xmlAttributes['contentvariable'] & '" default="">');
						fb_appendLine('<cfoutput>##' & fb_.fuseQ[fb_.i].xmlAttributes['contentvariable'] & '##</cfoutput>');
					}
				}
				else { // mode=end
					if (fb_.fuseQ[fb_.i].xmlAttributes.prepend EQ "true") {
						fb_appendLine('<cfparam name="'& fb_.fuseQ[fb_.i].xmlAttributes['contentvariable'] & '" default="">');
						fb_appendLine('<cfoutput>##' & fb_.fuseQ[fb_.i].xmlAttributes['contentvariable'] & '##</cfoutput>');
					}
					fb_decreaseIndent();	
					fb_appendLine('</cfsavecontent>');
					if (NOT fb_.fuseQ[fb_.i].xmlAttributes.overwrite) {
						fb_decreaseIndent();
						fb_appendLine('</cfif>');
					}
				}
			}
		</cfscript>
		</cfcase>

		<cfcase value="relocate">
		<cfscript>
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "addtoken") AND fb_.fuseQ[fb_.i].xmlAttributes['addtoken'] IS TRUE) {
				fb_.addtoken = 'addtoken="yes"';
			}
			else {
				fb_.addtoken = 'addtoken="no"';
			}
			if (StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "type") AND fb_.fuseQ[fb_.i].xmlAttributes['type'] EQ "server") {
				fb_appendLine('<cfset getPageContext().forward("' & fb_.fuseQ[fb_.i].xmlAttributes.url & '")>');
			}
			else {
				fb_appendLine('<cflocation url="' & fb_.fuseQ[fb_.i].xmlAttributes.url & '" ' & fb_.addtoken & '>');
			}
			// add a cfabort after each relocate (server or client)
			fb_appendLine('<cfabort>');
		</cfscript>
		</cfcase>

		<cfcase value="assert">
		<cfscript>
			if ( NOT StructKeyExists(fb_.fuseQ[fb_.i].xmlAttributes, "message"))   {
				StructInsert(fb_.fuseQ[fb_.i].xmlAttributes, 'message', 'The assertion failed.');
			}
			fb_appendLine(fb_.COMMENT_CF_BEGIN & '<assertion>');
			fb_increaseIndent();
			
				fb_appendLine('<cfif NOT (' & fb_.fuseQ[fb_.i].xmlAttributes.expression & ')>'); 
				/* John QvT's former code
				fb_.indentLevel = fb_.indentLevel + 1;
				fb_.parsedfile = fb_.parsedfile & fb_.CRLF & repeatString(fb_.indentBlock, min(fb_.maxIndentLevel, fb_.indentLevel)) & '<!-'&'-- assertion is TRUE; do nothing --'&'->';
				fb_.indentLevel = fb_.indentLevel - 1;
				fb_.parsedfile = fb_.parsedfile & fb_.CRLF & repeatString(fb_.indentBlock, min(fb_.maxIndentLevel, fb_.indentLevel)) & '<cfelse>'; 
				fb_.indentLevel = fb_.indentLevel + 1;
				*/
				fb_appendLine('<cfthrow type="fusebox.failedAssertion" message="#fb_.fuseQ[fb_.i].xmlAttributes.message#" detail="The assertion, #fb_.fuseQ[fb_.i].xmlAttributes.expression#, failed at run-time in fuseaction #fb_.fuseQ[fb_.i].circuit#.#fb_.fuseQ[fb_.i].fuseaction#.">');
				/* John QvT's former code
				fb_.indentLevel = fb_.indentLevel - 1;
				*/
				fb_appendLine('</cfif>');
				
			fb_decreaseIndent();
			fb_appendLine('</assertion>' & fb_.COMMENT_CF_END);
			fb_.hasAssertions = TRUE;
		</cfscript>
		</cfcase>

		<cfdefaultcase>
			<cfif (application.fusebox.allowLexicon AND ListLen(fb_.fuseQ[fb_.i].xmlName, '.') GT 1)>
				<cftry>
					<cfset fb_.lexicon = listFirst(fb_.fuseQ[fb_.i].xmlName, '.')>
					<cfset fb_.lexiconVerb = listRest(fb_.fuseQ[fb_.i].xmlName, '.')>
					
					<cfset fb_.verbInfo = structNew() />
					<cfset fb_.verbInfo.lexicon = fb_.lexicon />
					<cfset fb_.verbInfo.verb = fb_.lexiconVerb />
					<cfset fb_.verbInfo.attributes = fb_.fuseQ[fb_.i].xmlAttributes />
					<cfif StructKeyExists(application.fusebox.lexicons, fb_.lexicon)>
						<cfinclude template="#application.fusebox.CoreToAppRootPath##application.fusebox.lexiconPath##application.fusebox.lexicons[fb_.lexicon].path##fb_.lexiconVerb#.#application.fusebox.scriptFileDelimiter#">
					<cfelse>
						<cfset fb_throw("fusebox.badGrammar.unregisteredLexiconException",
							"Bad Grammar verb in circuit file",
							"The '#fb_.lexicon#' lexicon is not registered in fusebox.xml, but is used in the '#fb_.fuseQ[fb_.i].circuit#' circuit."
						) />
					</cfif>
					<cfcatch type="missingInclude">
						<cfset fb_throw("fusebox.badGrammar.missingImplementationException",
							"Bad Grammar verb in circuit file",
							"The implementation file for the '#fb_.lexiconVerb#' verb from the '#fb_.lexicon#' custom lexicon could not be found.  It is used in the '#fb_.fuseQ[fb_.i].circuit#' circuit."
						) />
					</cfcatch>
				</cftry>
			<cfelse>
				<cfscript>
					if (application.fusebox.parseWithComments) {
						fb_appendLine(fb_.COMMENT_CF_BEGIN & 'generated by fuseQ[#fb_.i#]  UNKNOWN VERB: #fb_.fuseQ[fb_.i].xmlName#' & fb_.COMMENT_CF_END);
					}
				</cfscript>
				<cfset fb_throw("fusebox.badGrammar.unknownVerbException",
					"Bad Grammar verb in circuit file",
					"A bad grammar construct was encountered in the circuit '#fb_.fuseQ[fb_.i].circuit#' caused by the unknown or misspelled Fusebox grammar verb '#fb_.fuseQ[fb_.i].xmlName#'."
				) />
			</cfif>
		</cfdefaultcase>

	</cfswitch>
	
	<!--- the rest of the CFCONTINUE hack --->
	<cfcatch type="fusebox.continueException">
		<!--- just let 'er continue --->
	</cfcatch>
</cftry>
</cfloop>

<cfscript>
	// if any plugins were defined for the processError phase then insert a closing tag for </cftry> here
	if (arrayLen(application.fusebox.pluginphases['processError']) GT 0) {
		fb_decreaseIndent();
		fb_appendLine("</cftry>");
	}
	fb_appendLine('<cfsetting enablecfoutputonly="No">');
</cfscript>

<!--- finished --->
</cfsilent>
