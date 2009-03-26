<!---
 
  Copyright (c) 2002-2005	David Ross,	Chris Scott
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: dspEntries.cfm,v 1.4 2007/06/18 12:01:26 rossd Exp $

--->

<cfscript>
    /**
    * Removes HTML from the string.
    * 
    * @param string String to be modified. 
    * @return Returns a string. 
    * @author Raymond Camden (ray@camdenfamily.com) 
    * @version 1, December 19, 2001 
    */
    function StripHTML(str) {
                 return REReplaceNoCase(str,"<[^>]*>","","ALL");
    }
</cfscript>

<cfset entries = event.getArg('entries')/>
<cfoutput>
<table id="entriesTable" cellpadding="3" cellspacing="0" border="0">
	<cfloop query="entries">
	<tr>
		<td width="100%">
			<table class="singleEntry" border="0" width="100%">
				<tr><td class="entryTitle"><strong>#blogTitle#&nbsp;::&nbsp; <a href="#entries.url#" target="_blank">#entries.title#</a></strong></td>
				<td  class="entryTitle" align="right">#authored_on#</td>
				</tr>
				<tr><td colspan="2">#Left(StripHTML(body),450)#</td></tr>
			</table>
		</td>
	</tr>	
	</cfloop>
</table>
</cfoutput>

