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
		
			
 $Id: dspMainLayout.cfm,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfoutput>
<html>
<head>
	<title>CFML stupid feedviewer, v#getProperty('applicationVersion')#</title>
	<link rel="stylesheet" type="text/css" href="#getProperty('styleSheetPath')#" />

</head>

<body>
<table id="mainTable" width="100%">
	
	<cfif event.isArgDefined('headerContent')>
		<tr><td colspan="2" class="mainHeader">#event.getArg('headerContent')#</td></tr>
	</cfif>
		
	<tr>
	
	<td width="25%" class="leftContent" valign="top"><cfif structKeyExists(request,'leftColContent')>#request.leftColContent#</cfif></td>
	<td class="mainContent" width="75%" valign="top">
	<cfif event.isArgDefined("message")><div id="message">#event.getArg('message')#</div></cfif>
	<cfif structKeyExists(request,'mainContent')>#request.mainContent#</cfif>
	
	</td></tr>
	
	<cfif event.isArgDefined('footerContent')>
		<tr><td colspan="2" class="mainFooter">#event.getArg('footerContent')#</td></tr>
	</cfif>
</table>
</cfoutput>
</body>
</html>
