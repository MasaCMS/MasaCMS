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

  $Id: loginForm.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: loginForm.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset submitEvent = request.event.getArg('submitEvent','') />
	<cfset message = request.event.getArg('message','') />
</cfsilent>

<!--- The login form --->
<cfoutput>

	<h1><span class="head">Klondike Records</span><br />
	Log-in</h1>
	
	<cfif len(message)>
	<p class="alert">#message#</p>
	<cfelse>
	<p>Welcome to the Klondike Records Admin area! To begin, please enter your username and password.</p>
	</cfif>

	<form action="index.cfm?event=#submitEvent#" method="post">
	<table class="stripes" cellspacing="0">
		<tr>
			<td colspan="2">
			<span class="header">Log-in Information</span>
			</td>
		</tr>
		<tr class="odd">
			<td class="label-l">Username:</td>
			<td class="input-r"><input type="text" name="username" size="18" /></td>
		</tr>
		<tr class="odd">
			<td class="label-l">Password:</td>
			<td class="input-r"><input type="password" name="password" size="18" /></td>
		</tr>
		<tr>
			<td class="button" colspan="2">
			<input type="submit" name="login" value="Log-in" class="buttonprocess" />
			</td>
		</tr>	
	</table>	
	</form>
	
</cfoutput>

<!--- End login form --->