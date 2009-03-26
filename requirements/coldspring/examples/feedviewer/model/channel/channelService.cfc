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
		
			
 $Id: channelService.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="Channel Service" output="false">

	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.channel.channelService" output="false">
	
		<cfreturn this/>
	
	</cffunction>

	<cffunction name="setChannelDAO" returntype="void" access="public"	output="false" hint="dependency: channelDAO">
		<cfargument name="channelDAO" type="coldspring.examples.feedviewer.model.channel.channelDAO"	required="true"/>
		
		<cfset variables.m_channelDAO = arguments.channelDAO/>
			
	</cffunction>	

	<cffunction name="setChannelGateway" returntype="void" access="public" output="false" hint="dependency: channelGateway">
		<cfargument name="channelGateway" type="coldspring.examples.feedviewer.model.channel.channelGateway" required="true"/>
		
		<cfset variables.m_channelGateway = arguments.channelGateway/>
			
	</cffunction>
	
	<cffunction name="getAll" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfreturn variables.m_channelGateway.getAll()/>
	</cffunction>

	<cffunction name="getById" returntype="coldspring.examples.feedviewer.model.channel.channel" access="public" output="false" hint="I retrieve a channel by id">
		<cfargument name="channelId" type="numeric" required="true" hint="id of channel to get"/>
		<cfreturn variables.m_channelDAO.fetch(arguments.channelId)/>
	</cffunction>
	
	<cffunction name="save" returntype="void" access="public" output="false" hint="I save a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" required="true" hint="channel to save"/>
		<cfreturn variables.m_channelDAO.save(arguments.channel)/>
	</cffunction>	
	
	<cffunction name="remove" returntype="void" access="public" output="false" hint="I remove a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" required="true" hint="channel to remove"/>
		<cfreturn variables.m_channelDAO.remove(arguments.channel)/>
	</cffunction>	

	<cffunction name="getAllByCategory" returntype="query" output="false" hint="I retrieve all existing channels by category id" access="public">
		<cfargument name="catIds" type="array" required="true" hint="array of Ids of the categories restrict to"/>
		<cfreturn variables.m_channelGateway.getAllByCategories(arguments.catIds)/>
	</cffunction>
	
</cfcomponent>