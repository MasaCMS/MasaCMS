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


<html>
<head>
	<title>Model-Glue 2.0:  Unity</title>
	<link rel="stylesheet" type="text/css" href="css/stylesheet.css" media="screen" />
</head>


<body>
<div>
	<div id="banner">Model-Glue 2.0: Unity</div>
	<div>
		<div>
			<cfoutput>#viewcollection.getView("body")#</cfoutput>
		</div>
	</div>
	<div id="footer">
			<cfoutput>
				<p><a href="http://www.model-glue.com">Model-Glue</a> is &copy; #LSDateFormat(now(), "yyyy")# Joe Rinehart.  It is Free Open Source Software, distributed under the Lesser GPL.</p>
				
				<p>Many thanks go out to Dave Ross and Chris Scott for developing <a href="http://www.coldspringframework.org">ColdSpring</a>, 
				Doug Hughes for developing <a href="http://www.doughughes.net">Reactor</a>, Mark Mandel for developing <a href="http://transfer.riaforge.org/">Transfer</a>, <a href="http://www.corfield.org">Sean Corfield</a> and 
				<a href="http://www.web-relevant.com/blogs/cfobjective">Jared Rypka-Hauer</a> for their code and advice, 
				<a href="http://ray.camdenfamily.com/">Ray Camden</a> for being a great spokesperson and teacher for Model-Glue, and, especially, 
				my wife Dale for putting up with my hours of coding.</p>
			</cfoutput>
	</div>
</div>
</body>
</html>	