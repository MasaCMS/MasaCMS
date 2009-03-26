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
		
			
 $Id: aggregatorListener.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->


<cfcomponent name="aggregatorListener.cfc" extends="MachII.framework.listener" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset var sf = getProperty('serviceFactory')/>
		<cfset variables.m_aggregatorService = sf.getBean('aggregatorService')/>
	</cffunction>
	
	
	<cffunction name="aggregrateChannelFeed" access="public" returntype="void" output="false" hint="I retrieve a aggregator">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_aggregatorService.aggregateEntriesByChannel(arguments.event.getArg('channel'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','aggregation failed... reason: #cfcatch.message#!')/>
				<cfreturn/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','entries refreshed!')/>

	</cffunction>
</cfcomponent>
			
