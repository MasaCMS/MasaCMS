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

  $Id: mainLayout.cfm,v 1.1 2005/10/09 20:12:05 scottc Exp $
  $Log: mainLayout.cfm,v $
  Revision 1.1  2005/10/09 20:12:05  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


--->

<cfsilent>
	<cfset clID = event.getArg('clID',0) />
	<cfset qryString = '' />
	<cfif clID GT 0>
		<cfset qryString = "&clID=" & clID />
	</cfif>
</cfsilent>
<cfcontent reset="true" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Klondike Records</title>
	<link rel="stylesheet" type="text/css" href="views/css/klondike.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>

<body>
	
	<div id="content">
	
	<!-- primary nav -->
	<div class="primary-nav">
		<table cellspacing="0">
			<tr valign="middle">	
				<td class="nav1" height="22"><a href="index.cfm?event=logout" class="rev">Logout</a></td>							
			</tr>
		</table>
	</div>
	
	<cfoutput>
	<!-- breadcrumb -->
	<cfif isDefined("request.breadcrumb")>
	<p class="breadcrumb">
		<cfsetting enablecfoutputonly="yes">
		<cfloop from="1" to="#ArrayLen(request.breadcrumb)#" index="i">
			<cfset aCrumb=request.breadcrumb[i]>
				<cfif i NEQ ArrayLen(request.breadcrumb)>
					<cfoutput><a href="index.cfm?event=#trim(GetToken(aCrumb,2,'|'))##qryString#">#trim(GetToken(aCrumb,1,'|'))#</a>&nbsp;&gt;&nbsp; </cfoutput>
				<cfelse>
					<cfoutput>#trim(GetToken(aCrumb,1,'|'))#&nbsp;&gt;&nbsp; </cfoutput>
				</cfif>
		</cfloop>
		<cfsetting enablecfoutputonly="no">
	</p>
	</cfif>
	
	<!-- left columns -->
	<div class="left">
		<cfif isDefined("request.contentLeft")>
			#request.contentLeft#
		</cfif>
	</div>
	
	<!-- center -->
	<div class="center">
		<div class="noframes">
		
			<!-- content -->
			<cfoutput>
			#request.content#
			</cfoutput>
		
		</div>
	</div>
	</cfoutput>
	
	<div class="clearer">&#160;</div>
	
	<!-- copyright -->
	<p class="fine">&copy; 2005 Klondike, Inc. All Rights Reserved.</p>
	
	</div>
	
</body>
</html>