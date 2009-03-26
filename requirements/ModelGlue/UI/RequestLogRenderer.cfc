<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayname="RequestLogRenderer" output="false" hint="I render a ModelGlue.Core.RequestLog to HTML.">

<cffunction name="Init" returntype="ModelGlue.UI.RequestLogRenderer" output="false" hint="Constructor">
  <cfreturn this />
</cffunction>

<cffunction name="Render" returntype="string" output="false" hint="I render the log and return a string of HTML.">
  <cfargument name="RequestLog" required="true" type="ModelGlue.Core.RequestLog">
  
  <cfset var result = "" />
  <cfset var log = arguments.RequestLog.getLog() />
  
  <cfsavecontent variable="result">
  <br />
  <div style="clear:both;padding-top:10px;border-bottom:1px Solid #CCC;font-family:verdana;font-size:16px;font-weight:bold">Model-Glue Debugging:</div>
  <br />
  <cfoutput>
  <table cellpadding="2" cellspacing="0" width="100%" style="border:1px Solid ##CCC;font-family:verdana;font-size:11pt;">
    <tr style="background:##EAEAEA">
      <td style="border-bottom:1px Solid ##CCC;"><strong>Time</strong></td>
      <td style="border-bottom:1px Solid ##CCC;"><strong>Category</strong></td>
      <td style="border-bottom:1px Solid ##CCC;"><strong>Message</strong></td>
    </tr>
    <cfloop from="1" to="#arrayLen(log)#" index="i">
    <cfif i mod 2>
      <tr style="background:##F9F9F9">
    <cfelse>
      <tr>
    </cfif>
      <td valign="top">#log[i].time#ms</td>
      <td valign="top">#log[i].type#</td>
      <td valign="top">#log[i].message#</td>
    </tr>
    <cfif i mod 2>
      <tr style="background:##F9F9F9">
    <cfelse>
      <tr>
    </cfif>
      <td valign="top" colspan="2" style="border-bottom:1px Solid ##CCC;">&nbsp;</td>
      <td valign="top" style="font-size:10pt;border-bottom:1px Solid ##CCC;">#log[i].tag#&nbsp;</td>
    </tr>
    </cfloop>
  </table>
  </cfoutput>
  </cfsavecontent>

  <cfreturn result />
</cffunction>

</cfcomponent>