<!--- 
	  
  Copyright (c) 2005, Chris Scott, David Ross
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  $Id: exception.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: exception.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset exception = request.event.getArg('exception') />
	<!--- if this is the security type we just threw, go to loggin --->
	<cfif exception.getType() IS 'SecurityException'>
		<cflocation url="index.cfm?event=loginForm&message=#exception.getMessage()#" addtoken="no" />
		<cfabort />
	</cfif>
</cfsilent>


<h3>Exception</h3>



<cfoutput>
<table>
	<tr>
		<td valign="top"><b>Type</b></td>
		<td valign="top">#exception.getType()#</td>
	</tr>
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
</table>
</cfoutput>
