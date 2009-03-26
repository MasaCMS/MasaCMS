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

  $Id: index.cfm,v 1.1 2005/10/09 20:12:06 scottc Exp $
  $Log: index.cfm,v $
  Revision 1.1  2005/10/09 20:12:06  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.


-->
 
<!--- Set the path to the application's mach-ii.xml file. ./config/mach-ii.xml --->
<cfset MACHII_CONFIG_PATH = ExpandPath("./config/klondike-conf.xml") />

<!--- Set the configuration mode (when to reload): -1=never, 0=dynamic, 1=always --->
<cfset MACHII_CONFIG_MODE =iif(isDefined("url.rl"),1,0)/>
<!--- Set the app key for sub-applications within a single cf-application. --->
<cfset MACHII_APP_KEY = GetFileFromPath(ExpandPath(".")) />
<!--- Include the mach-ii.cfm file included with the core code. --->
<cfinclude template="/MachII/mach-ii.cfm" />

