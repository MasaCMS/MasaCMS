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
		
			
 $Id: eventArgs.cfm,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfif not structKeyExists(request,'event')>
	<cfset request.event = createObject("component","coldspring.examples.feedviewer-fb4.plugins.event").init()/>
</cfif>
<cfif structKeyExists(request,'eventArgs') and isStruct(request.eventArgs)>
	<cfloop collection="#request.eventArgs#" item="a">
		<cfset request.event.setArg(a,request.eventArgs[a])/>
	</cfloop>
</cfif>
<cfloop collection="#attributes#" item="a">
		<cfset request.event.setArg(a,attributes[a])/>
	</cfloop>
<cfset event = request.event/>

