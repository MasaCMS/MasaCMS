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
		
			
 $Id: entryService.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="Entry Service" output="false">

	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.entry.entryService" output="false">
	
		<cfreturn this/>
	
	</cffunction>

	<cffunction name="setEntryDAO" returntype="void" access="public"	output="false" hint="dependency: entryDAO">
		<cfargument name="entryDAO" type="coldspring.examples.feedviewer.model.entry.entryDAO"	required="true"/>
		
		<cfset variables.m_entryDAO = arguments.entryDAO/>
			
	</cffunction>	

	<cffunction name="setEntryGateway" returntype="void" access="public" output="false" hint="dependency: entryGateway">
		<cfargument name="entryGateway" type="coldspring.examples.feedviewer.model.entry.entryGateway" required="true"/>
		<cfset variables.m_entryGateway = arguments.entryGateway/>
	</cffunction>
	
	<cffunction name="save" returntype="void" access="public"	output="false" hint="dependency: entryDAO">
		<cfargument name="entry" type="coldspring.examples.feedviewer.model.entry.entry"	required="true"/>
		
		<cfset variables.m_entryDAO.save(arguments.entry)/>
	</cffunction>	

	<cffunction name="getByChannelId" returntype="query" access="public" output="false" hint="I retrieve a channel by id">
		<cfargument name="channelId" type="numeric" required="true" hint="id of channel to get"/>
		<cfargument name="maxEntries" type="numeric" required="false" default="50" hint="max number of entries to retrieve" />
		<cfreturn variables.m_entryGateway.getByChannelId(arguments.channelId,arguments.maxEntries)/>
	</cffunction>

	<cffunction name="getAll" returntype="query" access="public" output="false" hint="I retrieve entries">
		<cfargument name="start" type="numeric" required="false" default="0" hint="record to start at"/>
		<cfargument name="maxEntries" type="numeric" required="false" default="50" hint="num records to get"/>
		<cfreturn variables.m_entryGateway.getAll(arguments.start,arguments.maxEntries)/>
	</cffunction>
		
</cfcomponent>