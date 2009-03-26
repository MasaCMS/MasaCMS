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
		
			
 $Id: appPlugin.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfcomponent extends="machii.framework.plugin">
	<!--- this plugin will announce the supplied rendering event after all other processing has completed  --->
	
	<cffunction name="postEvent" output="true">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		<!--- this code will insert footer as applicable --->
	<!--- 	<cfoutput>
		#arguments.eventContext.getCurrentEvent().getName()#-#arguments.eventContext.hasNextEvent()#
		<cfdump var="#arguments.eventContext.getCurrentEvent().getArgs()#"/>
		<hr>
		</cfoutput>
		 --->
		<cfif not arguments.eventContext.hasNextEvent() and arguments.eventContext.getCurrentEvent().getName() neq getParameter('renderEventName','renderPage')>
			<cfset arguments.eventContext.announceEvent(getParameter('renderEventName','renderPage'),arguments.eventContext.getCurrentEvent().getArgs())/>
		</cfif>
	</cffunction> 


</cfcomponent>