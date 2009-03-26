<!-- 
	  
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

  $Id: Application.cfm,v 1.1 2005/10/09 20:12:06 scottc Exp $
  $Log: Application.cfm,v $
  Revision 1.1  2005/10/09 20:12:06  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


-->

<cfapplication name="klondikeRecords" sessionmanagement="yes" />


<!--- set up log4j --->
<cfscript>
	if (NOT IsDefined("application.initLogger")) {
		configurator = CreateObject("java", "org.apache.log4j.PropertyConfigurator");
		configurator.configure('/usr/local/cf7/htdocs/klondike/logs/logger.properties');
		application.initLogger = true;
	}
</cfscript>