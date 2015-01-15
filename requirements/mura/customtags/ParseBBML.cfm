<cfsilent><cfsetting enablecfoutputonly="Yes">
<!--- DP_ParseBBML version 1.1 --->
<!---
Author: Jim Davis, the Depressed Press of Boston
Date: October 6, 2002
Contact: webmaster@depressedpress.com
Website: www.depressedpress.com

Full documentation can be found at:
http://www.depressedpress.com/DepressedPress/Content/Development/ColdFusion/Extensions/DP_ParseBBML/Index.cfm

"CF_ColoredCode" and all related code is copyright by Dain Anderson of www.CFCOMET.com.  It is used here with permission.

Copyright (c) 1996-2004, The Depressed Press of Boston (depressedpres.com)

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

+) Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 

+) Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. 

+) Neither the name of the DEPRESSED PRESS OF BOSTON (DEPRESSEDPRESS.COM) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--->

	<!--- This tag will only run in ExecutionMode "End" if an end tag is present --->
<cfif (ThisTag.HasEndTag) AND (ThisTag.ExecutionMode EQ "Start")>
	<cfsetting enablecfoutputonly="No"><cfexit method="ExitTemplate">
</cfif>

	<!--- Set Errors Conditions/Messages --->
<cfscript>
	// Set the ErrorInfo strucutre
eInfo = StructNew();
	// Set the prefix for all errors
eTypePrefix = "DepressedPress.DP_ParseBBML.";
	// e01xx is "InvalidAttribute"
eInfo.e0101 = StructNew();
	eInfo.e0101.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0101.ErrorCode = "e0101";
	eInfo.e0101.Message = "DP_ParseBBML: Attribute ""Input"" must be a String";
	eInfo.e0101.Detail = "The attribute ""Input"" cannot be a complex datatype (Query, Array, Structure, etc).";
eInfo.e0102 = StructNew();
	eInfo.e0102.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0102.ErrorCode = "e0102";
	eInfo.e0102.Message = "DP_ParseBBML: Attribute ""Input"" is Required";
	eInfo.e0102.Detail = "The DP_ParseBBML tag requires string input either passed within the ""Input"" attribute or contained within a tag/end tag pair.";
eInfo.e0103 = StructNew();
	eInfo.e0103.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0103.ErrorCode = "e0103";
	eInfo.e0103.Message = "DP_ParseBBML: Attribute ""OutputVar"" must be a String";
	eInfo.e0103.Detail = "The attribute ""OutputVar"" cannot be a complex datatype (Query, Array, Structure, etc).";
eInfo.e0104 = StructNew();
	eInfo.e0104.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0104.ErrorCode = "e0104";
	eInfo.e0104.Message = "DP_ParseBBML: Attribute ""OutputVar"" must be a valid variable name";
	eInfo.e0104.Detail = "The attribute ""OutputVar"" must be a string and follow the standards for ColdFusion variables.";
eInfo.e0105 = StructNew();
	eInfo.e0105.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0105.ErrorCode = "e0105";
	eInfo.e0105.Message = "DP_ParseBBML: Attribute  ""ConvertSmilies"" must be Boolean";
	eInfo.e0105.Detail = "The attribute ""ConvertSmilies"" must be boolean (""Yes""/""No"", ""True""/""False"", etc).";
eInfo.e0106 = StructNew();
	eInfo.e0106.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0106.ErrorCode = "e0106";
	eInfo.e0106.Message = "DP_ParseBBML: Attribute ""ConvertHTML"" must be Boolean";
	eInfo.e0106.Detail = "The attribute ""ConvertHTML"" must be boolean (""Yes""/""No"", ""True""/""False"", etc).";
eInfo.e0107 = StructNew();
	eInfo.e0107.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0107.ErrorCode = "e0107";
	eInfo.e0107.Message = "DP_ParseBBML: Attribute ""ConvertBBML"" must be Boolean";
	eInfo.e0107.Detail = "The attribute ""ConvertBBML"" must be boolean (""Yes""/""No"", ""True""/""False"", etc).";
eInfo.e0108 = StructNew();
	eInfo.e0108.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0108.ErrorCode = "e0108";
	eInfo.e0108.Message = "DP_ParseBBML: Attribute ""ConvertSmilies"" requires ""SmileyPath"" to be set";
	eInfo.e0108.Detail = "If the attribute ""ConvertSmilies"" is set to ""Yes"" then a valid path must be given for ""SmileyPath"".";
eInfo.e0109 = StructNew();
	eInfo.e0109.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0109.ErrorCode = "e0109";
	eInfo.e0109.Message = "DP_ParseBBML: Attribute ""RevertToBBML"" must be Boolean";
	eInfo.e0109.Detail = "The attribute ""RevertToBBML"" must be boolean (""Yes""/""No"", ""True""/""False"", etc).";
eInfo.e0110 = StructNew();
	eInfo.e0110.Type = eTypePrefix & "InvalidAttribute";
	eInfo.e0110.ErrorCode = "e0110";
	eInfo.e0110.Message = "DP_ParseBBML: Attribute ""UseCF_ColoredCode"" must be Boolean";
	eInfo.e0110.Detail = "The attribute ""UseCF_ColoredCode"" must be boolean (""Yes""/""No"", ""True""/""False"", etc).";
eInfo.e0111 = StructNew();
	eInfo.e0111.Type = eTypePrefix & "CF_ColoredCode";
	eInfo.e0111.ErrorCode = "e0111";
	eInfo.e0111.Message = "DP_ParseBBML: There was an unknown error attempting to utilize CF_ColoredCode";
	eInfo.e0111.Detail = "An error occurred while calling the supporting routine, CF_ColoredCode.";
</cfscript>

	<!--- Set Input --->
	<!--- Throw an error if the Input is not a simple string. --->
<cfif IsDefined("Attributes.Input") AND NOT IsSimpleValue(Attributes.Input)>
	<cfthrow type="#eInfo.e0101.Type#" errorcode="#eInfo.e0101.ErrorCode#" message="#eInfo.e0101.Message#" detail="#eInfo.e0101.Detail#">
</cfif>
	<!--- Set the input value based on the tag's structure --->
	<!--- If the Input attribute was passed use that and ignore the tag's contents --->
<cfif ThisTag.HasEndTag AND NOT IsDefined("Attributes.Input")>
	<cfset Input = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = "">
<cfelse>
	<cfset Input = Attributes.Input>
</cfif>
	<!--- Throw an error if no input  --->
<cfif Trim(Input) EQ "">
	<cfthrow type="#eInfo.e0102.Type#" errorcode="#eInfo.e0102.ErrorCode#" message="#eInfo.e0102.Message#" detail="#eInfo.e0102.Detail#">
</cfif>

	<!--- Set OutputVar --->
<cfparam name="Attributes.OutputVar" default="DP_ParseBBML">
	<!--- Throw an error if the OutputVar is not a simple string. --->
<cfif IsDefined("Attributes.OutputVar") AND NOT IsSimpleValue(Attributes.OutputVar)>
	<cfthrow type="#eInfo.e0103.Type#" errorcode="#eInfo.e0103.ErrorCode#" message="#eInfo.e0103.Message#" detail="#eInfo.e0103.Detail#">
</cfif>
	<!--- Throw an error of the passed attribute is not a valid variable name --->
<cftry>
	<cfset "#Attributes.OutputVar#" = "">
	<cfcatch><cfthrow type="#eInfo.e0104.Type#" errorcode="#eInfo.e0104.ErrorCode#" message="#eInfo.e0104.Message#" detail="#eInfo.e0104.Detail#"></cfcatch>
</cftry>

	<!--- Set "ConvertSmilies" --->
<cftry>
	<cfparam name="Attributes.ConvertSmilies" default="No" type="boolean">
	<cfcatch><cfthrow type="#eInfo.e0105.Type#" errorcode="#eInfo.e0105.ErrorCode#" message="#eInfo.e0105.Message#" detail="#eInfo.e0105.Detail#"></cfcatch>
</cftry>
<cfif Attributes.ConvertSmilies>
	<cfset ConvertSmilies = "Yes">
<cfelse>
	<cfset ConvertSmilies = "No">
</cfif>
<cfif ConvertSmilies>
	<cfif NOT IsDefined("Attributes.SmileyPath")>
		<cfthrow type="#eInfo.e0108.Type#" errorcode="#eInfo.e0108.ErrorCode#" message="#eInfo.e0108.Message#" detail="#eInfo.e0108.Detail#">
	</cfif>
	<cfset SmileyPath = Attributes.SmileyPath>
</cfif>

	<!--- Set "ConvertConvertHTML" --->
<cftry>
	<cfparam name="Attributes.ConvertHTML" default="Yes" type="boolean">
	<cfcatch><cfthrow type="#eInfo.e0106.Type#" errorcode="#eInfo.e0106.ErrorCode#" message="#eInfo.e0106.Message#" detail="#eInfo.e0106.Detail#"></cfcatch>
</cftry>
<cfif Attributes.ConvertHTML>
	<cfset ConvertHTML = "Yes">
<cfelse>
	<cfset ConvertHTML = "No">
</cfif>

	<!--- Set "ConvertBBML" --->
<cftry>
	<cfparam name="Attributes.ConvertBBML" default="Yes" type="boolean">
	<cfcatch><cfthrow type="#eInfo.e0107.Type#" errorcode="#eInfo.e0107.ErrorCode#" message="#eInfo.e0107.Message#" detail="#eInfo.e0107.Detail#"></cfcatch>
</cftry>
<cfif Attributes.ConvertBBML>
	<cfset ConvertBBML = "Yes">
<cfelse>
	<cfset ConvertBBML = "No">
</cfif>

	<!--- Set "RevertToBBML" --->
<cftry>
	<cfparam name="Attributes.RevertToBBML" default="No" type="boolean">
	<cfcatch><cfthrow type="#eInfo.e0109.Type#" errorcode="#eInfo.e0109.ErrorCode#" message="#eInfo.e0109.Message#" detail="#eInfo.e0109.Detail#"></cfcatch>
</cftry>
<cfif Attributes.RevertToBBML>
	<cfset RevertToBBML = "Yes">
<cfelse>
	<cfset RevertToBBML = "No">
</cfif>

	<!--- Set "UseCF_ColoredCode" --->
<cftry>
	<cfparam name="Attributes.UseCF_ColoredCode" default="No" type="boolean">
	<cfcatch><cfthrow type="#eInfo.e0110.Type#" errorcode="#eInfo.e0110.ErrorCode#" message="#eInfo.e0110.Message#" detail="#eInfo.e0110.Detail#"></cfcatch>
</cftry>
<cfif Attributes.UseCF_ColoredCode>
	<cfset UseCF_ColoredCode = "Yes">
<cfelse>
	<cfset UseCF_ColoredCode = "No">
</cfif>

	<!--- Create Output Structure --->
<cfset TempOutput = StructNew()>
<cfset TempOutput.Input = Input>
<cfset TempOutput.InputLen = Len(Input)>
<cfset TempOutput.Output = "">
<cfset TempOutput.OutputLen = "">
<cfset TempOutput.ConvertSmilies = ConvertSmilies>
<cfset TempOutput.ConvertHTML = ConvertHTML>
<cfset TempOutput.ConvertBBML = ConvertBBML>
<cfset TempOutput.RevertToBBML = RevertToBBML>
<cfset TempOutput.UseCF_ColoredCode = UseCF_ColoredCode>

<cfif NOT RevertToBBML>

	<!--- Begin Conversion Process --->
<cfscript>

	// Convert to character entities any instances of the special characters we'll be using as markers
	// The angle quotes substitute angle brackets
Input = Replace(Input, "«", "&laquo;", "All");
Input = Replace(Input, "»", "&raquo;", "All");
	// The O Graves substitute angle brackets withing in Lists
Input = Replace(Input, "#Chr(210)#", "&Ograve;", "All");
Input = Replace(Input, "#Chr(242)#", "&ograve;", "All");
	// The O Slash replaces list items
Input = Replace(Input, "#Chr(216)#", "&Oslash;", "All");
	// The Section mark substitutes quotes in generated HTML
Input = Replace(Input, "§", "&sect;", "All");
	// U graves/acutes are used to protect non-tag square brackets
Input = Replace(Input, "Ù", "&Ugrave;", "All");
Input = Replace(Input, "Ú", "&Uacute;", "All");
Input = Replace(Input, "ù", "&ugrave;", "All");
Input = Replace(Input, "ú", "&uacute;", "All");
	// The british Pound sign is used to mark beginings of links
Input = Replace(Input, "£", "&pound;", "All");

	// Set up the complex object arrays
SQLBlocks = ArrayNew(1);
CodeBlocks = ArrayNew(1);

CurPos=1;
while (FindNoCase("[code]", Input, CurPos) GT 0) {
	sCodePos = FindNoCase("[code]", Input, CurPos) + 6;
	eCodePos = FindNoCase("[/code]", Input, sCodePos);
	if (eCodePos EQ 0) {
		break;
	} else {
		CurPos = sCodePos;
	};
	CurCodeBlock = Mid(Input, sCodePos, eCodePos - sCodePos);
	Input = RemoveChars(Input, sCodePos, eCodePos - sCodePos);
	CurCodeBlock = replace(CurCodeBlock,"#chr(13)##chr(10)#","<br>","all");
	CurCodeBlock = "<div class='code'><code>#CurCodeBlock#</code></div>";
	ArrayAppend(CodeBlocks, CurCodeBlock);
	Input = Insert("***#ArrayLen(CodeBlocks)#***", Input, sCodePos - 1);
}

	// Convert BBML, if needed
if ( ConvertBBML AND Find("[", Input) AND Find("]", Input) ) {
		// Set non-tag brackets to safe entities
	Input = ReReplaceNoCase(Input, "\[(/?)((\*)|(b)||(heading)|(bold)|(i)|(italic)|(u)|(underline)|(s)|(strikethrough)|(sup)|(superscript)|(center)|(sub)|(subscript)|(size(=[0-9]*)?)|(color(=[##0-9A-Za-z]*)?)|(q)|(quote)|(sql)|(code)|(pre)|(preformatted)|((url|link)(=([^]]*))?)|(email(=([^]]*))?)|(img)|(image)|(list(=(1|a|A|i|I))?))\]", "ù\1\2ú", "All");
	Input = Replace(Input, "[", "Ù", "All");
	Input = Replace(Input, "]", "Ú", "All");
	Input = Replace(Input, "ù", "[", "All");
	Input = Replace(Input, "ú", "]", "All");

		// Validate the [size] tag's limits	
	MaximumFontSize = 300;
	MinimumFontSize = 75;
	CurPos = 1;
	while (ReFindNoCase("\[size=([0-9]*)\]", Input, CurPos) GT 0) {
		CurPos = ReFindNoCase("\[size=([0-9]*)\]", Input, CurPos, True);
		CurSize = Mid(Input, CurPos.pos[2], CurPos.Len[2]);
		if (CurSize GT MaximumFontSize) {
			Input = ReplaceNoCase(Input, "[size=#CurSize#]", "[size=#MaximumFontSize#]", "All");
		};
		if (CurSize LT MinimumFontSize) {
			Input = ReplaceNoCase(Input, "[size=#CurSize#]", "[size=#MinimumFontSize#]", "All");
		};
		CurPos = CurPos.pos[1] + CurPos.Len[1];
	};
		// Do all simple BBML conversion to psuedo HTML using "«" and "»"
		// The recursive loop, coupled with the regular expressions will validate for proper tag pairs and nesting
	do {

			// Set a temporary variable equal to the input - if it changes that means there was some work to be done and another pass is needed.
		TempInput = Input;
			// Convert Simple Formatting
		Input = ReReplaceNoCase(Input, "\[(b|bold)\]([^[]*)\[/\1\]", "«b»\2«/b»", "All");
		Input = ReReplaceNoCase(Input, "\[(i|italic)\]([^[]*)\[/\1\]", "«i»\2«/i»", "All");
		Input = ReReplaceNoCase(Input, "\[(u|underline)\]([^[]*)\[/\1\]", "«u»\2«/u»", "All");
		Input = ReReplaceNoCase(Input, "\[(s|strikethrough)\]([^[]*)\[/\1\]", "«s»\2«/s»", "All");
		Input = ReReplaceNoCase(Input, "\[(sup|superscript)\]([^[]*)\[/\1\]", "«sup»\2«/sup»", "All");
		Input = ReReplaceNoCase(Input, "\[(sub|subscript)\]([^[]*)\[/\1\]", "«sub»\2«/sub»", "All");
		Input = ReReplaceNoCase(Input, "\[center\]([^[]*)\[/center\]", "«div align=§center§»\1«/div»", "All");

			// Convert "Color" and "Size"
		Input = ReReplaceNoCase(Input, "\[size=([0-9]+)\]([^[]*)\[/size(=\1)?\]", "«span style=§font-size: \1% !important§»\2«/span»", "All");
		Input = ReReplaceNoCase(Input, "\[color=([##0-9A-Za-z]+)\]([^[]*)\[/color(=\1)?\]", "«span style=§color: \1§»\2«/span»", "All");

			// Convert Special Formatting
		Input = ReReplaceNoCase(Input, "\[(q|quote)\]([^[]*)\[/\1\]", "«blockquote»«span class=§blockquote§»\2«/span»«/blockquote»", "All");
		Input = ReReplaceNoCase(Input, "\[(code)\]([^[]*)\[/\1\]", "«code»\2«/code»", "All");
		Input = ReReplaceNoCase(Input, "\[(sql)\]([^[]*)\[/\1\]", "«sql»\2«/sql»", "All");
		Input = ReReplaceNoCase(Input, "\[(pre|preformatted)\]([^[]*)\[/\1\]", "«pre»\2«/pre»", "All");

			// Meld Forums Additions
		Input = ReReplaceNoCase(Input, "\[(h3|heading)\]([^[]*)\[/\1\]", "«h3»\2«/h3»", "All");

			// Convert Images
		Input = ReReplaceNoCase(Input, "\[(img|image)\]([^[«]*)\[/(img|image)\]", "«img src=§\2§»", "All");
	
			// Convert Links
		Input = ReReplaceNoCase(Input, "\[(url|link)=([^]]*)\]([^[£]*)\[/\1\]", "£ rel=§nofollow§ href=§\2§»\3«/a»", "All");
		Input = ReReplaceNoCase(Input, "\[(url|link)\]([^[£]*)\[/\1\]", "£  rel=§nofollow§ href=§\2§»\2«/a»", "All");
	
			// Convert Email Links
		Input = ReReplaceNoCase(Input, "\[email=([^]]*)\]([^[£]*)\[/email\]", "£ rel=§nofollow§ href=§mailto:\1§»\2«/a»", "All");
		Input = ReReplaceNoCase(Input, "\[email\]([^[(£]*)\[/email\]", "£ rel=§nofollow§ href=§mailto:\1§»\1«/a»", "All");
	
			// Convert Lists
			// List brackets get replaced with "#Chr(210)#" and "#Chr(242)#" to distingush them for validation
		Input = Replace(Input, "[*]", "#Chr(216)#", "ALL");
		Input = ReReplaceNoCase(Input, "\[list\][[:space:]]*#Chr(216)#([^[]*)\[/list\]", "#Chr(210)#ul#Chr(242)##Chr(216)#\1#Chr(210)#/ul#Chr(242)#", "All");
		Input = ReReplaceNoCase(Input, "\[list=(1|a|A|i|I)\][[:space:]]*#Chr(216)#([^[]*)\[/list(=\1)?\]", "#Chr(210)#ol type=§\1§#Chr(242)##Chr(216)#\2#Chr(210)#/ol#Chr(242)#", "All");
	
			// Clean Up lists
			// Add end item tags and remove line feeds and carriage returns
		do {
			bList = ReFind("#Chr(210)#(ul|ol)( type=§.§)?#Chr(242)#", Input, 1);
			if ( bList NEQ 0 ) {
				CurPos = bList;
				ItemCnt = 0;
				Input = Insert("«", Input, CurPos);
				Input = RemoveChars(Input, CurPos, 1);
				while (true) {
					if ( (Mid(Input, CurPos, 1) EQ Chr(10)) OR (Mid(Input, CurPos, 1) EQ Chr(13)) )  {
						Input = RemoveChars(Input, CurPos, 1);
						CurPos = CurPos - 1;
					};
						// Convert item tags to pseudo code and insert End item tags
					if ( Compare(Mid(Input, CurPos, 1), "#Chr(216)#" ) EQ 0 ) {
						Input = RemoveChars(Input, CurPos, 1);
						Input = Insert("«li»", Input, CurPos - 1);
						ItemCnt = ItemCnt + 1;
						if (ItemCnt GT 1) {
							Input = Insert("«/li»", Input, CurPos - 1);
							CurPos = CurPos + 5;
						};
					};
						// When we find the beginning of the list end tag, stop
					if ( Compare(Mid(Input, CurPos, 1), "#Chr(210)#" ) EQ 0 ) {
						Input = RemoveChars(Input, CurPos, 1);
						Input = Insert("«", Input, CurPos - 1);
						Input = Insert("«/li»", Input, CurPos - 1);
						break;
					};
					CurPos = CurPos + 1;
				};
			};
		} while (bList NEQ 0);

			// Set the List tags back to psuedo-code
		Input = Replace(Input, "#Chr(242)#", "»", "ALL");

		// If no changes have been made, break out of the loop - we're done!
	} while (TempInput NEQ Input);

		// Convert Orphaned List Items back to BBML code
	Input = Replace(Input, "#Chr(216)#", "[*]", "ALL");
};

	// Convert Smilies if Needed
if (ConvertSmilies) {
	Input = ReReplace(Input,	"(:(\^|')\))",			"«img src=§#SmileyPath#Happy.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(:(\^|')D)",			"«img src=§#SmileyPath#VeryHappy.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(:(\^|')\|)",			"«img src=§#SmileyPath#Neutral.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(:(\^|')\()",			"«img src=§#SmileyPath#Sad.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(L(\^|')\()",			"«img src=§#SmileyPath#VerySad.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(>(\^|')\()",			"«img src=§#SmileyPath#Mad.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(>(\^|')(X|x))",		"«img src=§#SmileyPath#VeryMad.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(;(\^|')\))",			"«img src=§#SmileyPath#Wink.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(;(\^|')\|)",			"«img src=§#SmileyPath#Wincing.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(:(\^|')(o|O|0))",		"«img src=§#SmileyPath#Shouting.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(=(\^|')\))",			"«img src=§#SmileyPath#Interested.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(;(\^|')`)",			"«img src=§#SmileyPath#ThinkingHard.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(;(\^|')d)",			"«img src=§#SmileyPath#Confused.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(=(\^|')~)",			"«img src=§#SmileyPath#SlightlyShocked.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(=(\^|')(o|O|0))",		"«img src=§#SmileyPath#Shocked.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(=(\^|')\*)",			"«img src=§#SmileyPath#Kiss.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(8(\^|')\))",			"«img src=§#SmileyPath#Cool.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(:(\^|')\})",			"«img src=§#SmileyPath#Drooling.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(:(\^|')(b|p))",		"«img src=§#SmileyPath#StickingOutTounge.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(\{(\^|')(o|O|0))",	"«img src=§#SmileyPath#Yawning.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(\{(\^|')\))",			"«img src=§#SmileyPath#Sleeping.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(##(\^|')\))",			"«img src=§#SmileyPath#Embarassed.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(%(\^|')\))",			"«img src=§#SmileyPath#Crazy.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(B(\^|')>)",			"«img src=§#SmileyPath#Evil.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"((o|O|0)(\^|')\))",	"«img src=§#SmileyPath#Angelic.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(\?(\^|')\))",			"«img src=§#SmileyPath#Question.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(!(\^|')\))",			"«img src=§#SmileyPath#Exclamation.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
	Input = ReReplace(Input,	"(\$(\^|')\))",			"«img src=§#SmileyPath#Idea.gif§ alt=§::\1::§ height=§15§ width=§15§ vspace=§1§ hspace=§1§»","ALL");
};

	// Convert HTML, if needed
if (ConvertHTML) {
	Input = Replace(Input, """", "&quot;", "ALL");
	Input = Replace(Input, "<", "&lt;", "ALL");
	Input = Replace(Input, ">", "&gt;", "ALL");
};

	// Set up Paragraphs and breaks

Input = "«p»" & Input & "«/p»";
Input = Replace(Input, "#Chr(13)##Chr(10)##Chr(13)##Chr(10)#", "«/p»«p»", "ALL");
Input = Replace(Input, "#Chr(13)##Chr(10)#", "«/p»«p»", "ALL");
	
	// Reset non-tag brackets to brackets
Input = Replace(Input, "Ù", "[", "All");
Input = Replace(Input, "Ú", "]", "All");

	// Reinsert code blocks
if (ArrayLen(CodeBlocks) GT 0) {
	for (Cnt = 1; Cnt LTE ArrayLen(CodeBlocks); Cnt = Cnt + 1) {
		Input = ReplaceNoCase(Input, "«code»***#Cnt#***«/code»", CodeBlocks[Cnt]);
	};
};

	// Convert Psuedo-Tags to angle brackets
	// All code-HTML conversion must be completed by this point!
Input = Replace(Input, "§", """", "ALL");
Input = Replace(Input, "«", "<", "ALL");
Input = Replace(Input, "»", ">", "ALL");
Input = Replace(Input, "£", "<a", "ALL");

</cfscript>

<cfelse>

	<!--- Begin Reversion Process --->
<cfscript>

		// Revert all simple BBML conversion to BBML
do {
		// Set a temporary variable equal to the input - if it changes that means there was some work to be done and another pass is needed.
	TempInput = Input;

		// Revert Smilies 
	Input = ReReplaceNoCase(Input, "<img src=""([^""]*)"" alt=""::(.{0,6})::"" ([^>]*)>", "\2", "All");

		// Revert Simple Formatting
	Input = ReReplaceNoCase(Input, "<b>([^<]*)</b>", "[b]\1[/b]", "All");
	Input = ReReplaceNoCase(Input, "<i>([^<]*)</i>", "[i]\1[/i]", "All");
	Input = ReReplaceNoCase(Input, "<u>([^<]*)</u>", "[u]\1[/u]", "All");
	Input = ReReplaceNoCase(Input, "<s>([^<]*)</s>", "[s]\1[/s]", "All");
	Input = ReReplaceNoCase(Input, "<sup>([^<]*)</sup>", "[superscript]\1[/superscript]", "All");
	Input = ReReplaceNoCase(Input, "<sub>([^<]*)</sub>", "[subscript]\1[/subscript]", "All");
	
		// Revert "Color" and "Size"
	Input = ReReplaceNoCase(Input, "<span style=""font-size: ([0-9]*)pt"">([^<]*)</span>", "[size=\1]\2[/size]", "All");
	Input = ReReplaceNoCase(Input, "<span style=""color: ([##0-9A-Za-z]*)"">([^<]*)</span>", "[color=\1]\2[/color]", "All");

		// Revert Special Formatting
	Input = ReReplaceNoCase(Input, "<blockquote>([^<]*)</blockquote>", "[quote]\1[/quote]", "All");
	Input = ReReplaceNoCase(Input, "<code>([^<]*)</code>", "[code]\1[/code]", "All");
	Input = ReReplaceNoCase(Input, "<pre>([^<]*)</pre>", "[preformatted]\1[/preformatted]", "All");

			// Meld Forums Additions
	Input = ReReplaceNoCase(Input, "<h3>([^<]*)</h3>", "[heading]\1[/heading]", "All");

	
		// Revert Email Links (this must be done BEFORE regular links)
	Input = ReReplaceNoCase(Input, "<a rel=""nofollow"" href=""mailto:([^>]*)"">([^<]*)</a>", "[email=\1]\2[/email]", "All");
	Input = ReReplaceNoCase(Input, "\[email=([^]]*)\]\1\[/email\]", "[email=\1]", "All");
	
		// Revert Links
	Input = ReReplaceNoCase(Input, "<a rel=""nofollow"" href=""([^>]*)"">([^<]*)</a>", "[url=\1]\2[/url]", "All");
	Input = ReReplaceNoCase(Input, "\[url=([^]]*)\]\1\[/url\]", "[url=\1]", "All");

		// Revert Images
	Input = ReReplaceNoCase(Input, "<img src=""([^""]*)""([^>]*)>", "[image]\1[/image]", "All");
	
		// Revert Lists
	Input = ReReplaceNoCase(Input, "<li>([^<]*)</li>", "[*]\1#Chr(13)##Chr(10)#", "ALL");
	Input = ReReplaceNoCase(Input, "<ul>([^<]*)</ul>", "[list]#Chr(13)##Chr(10)#\1[/list]", "ALL");
	Input = ReReplaceNoCase(Input, "<ol type=""(1|a|A|i|I)"">([^<]*)</ol>", "[list=\1]#Chr(13)##Chr(10)#\2[/list]", "ALL");

		// If no changes have been made, break out of the loop - we're done!
	} while (TempInput NEQ Input);

	// Set up Paragraphs and breaks
Input = Replace(Input, "</p><p>", "#Chr(13)##Chr(10)##Chr(13)##Chr(10)#", "ALL");
Input = Replace(Input, "<br>", "#Chr(13)##Chr(10)#", "ALL");
Input = Replace(Input, "<p>", "", "ALL");
Input = Replace(Input, "</p>", "", "ALL");

</cfscript>

</cfif>


	<!--- Dump Output --->
</cfsilent><cfif ThisTag.HasEndTag AND NOT IsDefined("Attributes.Input")><cfoutput>#input#</cfoutput></cfif>
	<!--- Set up output struct --->
<cfset TempOutput.Output = Input>
<cfset TempOutput.OutputLen = Len(Input)>
	<!--- Output the output struct --->
<cfset "Caller.#Attributes.OutputVar#" = TempOutput>

<cfsetting enablecfoutputonly="No">	