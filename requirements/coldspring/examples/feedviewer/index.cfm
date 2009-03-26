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
		
			
 $Id: index.cfm,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfoutput>
<html>
<head>
	<title>CFML stupid feedviewer</title>
	<link rel="stylesheet" type="text/css" href="view/css/style.css" />

</head>

<cfparam name="url.show" type="string" default="Readme.html">
<body>
<table id="mainTable" width="100%" height="100%">
<tr><td colspan="2" height="25" class="mainHeader" align="center"><h3>Feedviewer, Coldspring Example App</h3></td></tr>

<tr>
	<td width="25%" class="leftContent" valign="top">
		<ul>
			<li><a href="../feedviewer-m2/">Use Mach-ii Controller</a></li>
			<li><a href="../feedviewer-fb4/">Use FuseBox 4 Controller</a></li>
			<li><a href="../feedviewer-remote/">Use the Remote Facade</a></li>						
		</ul><br /><br />  
		<ul>
			<li><a href="index.cfm?show=services.xml">View Service Definitions</a></li>
			<li><a href="http://cfopen.org/projects/coldspring">Coldspring cfopen site</a></li>			
		</ul><br /><br />		
	</td>
	<td class="mainContent" width="75%" valign="top">
			<iframe src="#url.show#" width="99%" scrolling="auto" height="99%"></iframe>			
	</td>
</tr>
</table>
</body>
</html>
</cfoutput>




