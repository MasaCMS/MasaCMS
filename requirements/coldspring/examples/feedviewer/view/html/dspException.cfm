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
		
			
 $Id: dspException.cfm,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfset exception = request.event.getArg('exception') />
<cfoutput>
<div id="error">
<h3>Uh-oh... you broke it!</h3>
<table>
	<tr>
		<td valign="top"><b>Message</b></td>
		<td valign="top">#exception.getMessage()#</td>
	</tr>
	<tr>
		<td valign="top"><b>Detail</b></td>
		<td valign="top">#exception.getDetail()#</td>
	</tr>
	<tr>
		<td valign="top"><b>Extended Info</b></td>
		<td valign="top">#exception.getExtendedInfo()#</td>
	</tr>	
	<tr>
		<td valign="top"><b>Tag Context</b></td>
		<td valign="top">
			<cfset tagCtxArr = exception.getTagContext() />
			<cfloop index="i" from="1" to="#ArrayLen(tagCtxArr)#">
				<cfset tagCtx = tagCtxArr[i] />
				#tagCtx['template']# (#tagCtx['line']#)<br>
			</cfloop>
		</td>
	</tr>
</table><br /> <h3><A href="javascript: history.go(-1)">Click here to go back and try again!</A></h3>
</div>
</cfoutput>