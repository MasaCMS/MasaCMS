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
		
			
 $Id: entryListener.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfcomponent name="entryListener.cfc" extends="MachII.framework.listener" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset var sf = getProperty('serviceFactory')/>
		<cfset variables.m_entryService = sf.getBean('entryService')/>
	</cffunction>
	
	<cffunction name="getAllEntries" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>	
		<cfreturn variables.m_entryService.getAll(arguments.event.getArg('start','0'))/>
	</cffunction>
	
	<cffunction name="getEntriesByChannelId" returntype="query" access="public" output="false" hint="I retrieve a entry">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		<cfreturn variables.m_entryService.getByChannelId(arguments.event.getArg('channel').getId(),arguments.event.getArg('max','50'))/>		
	</cffunction>	
	
	<cffunction name="getentrysByCategoryId" access="public" returntype="query" output="false" hint="I retrieve a category">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
	
		<cfreturn variables.m_entryService.getAllByCategory(listToArray(arguments.event.getArg('categoryId')))/>
	
	</cffunction>

</cfcomponent>
			

