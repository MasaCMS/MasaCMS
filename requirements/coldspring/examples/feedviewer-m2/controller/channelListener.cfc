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
		
			
 $Id: channelListener.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfcomponent name="channelListener.cfc" extends="MachII.framework.listener" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset var sf = getProperty('serviceFactory')/>
		<cfset variables.m_channelService = sf.getBean('channelService')/>
	</cffunction>
	
	<cffunction name="getAllChannels" returntype="query" access="public" output="false" hint="I retrieve all existing categories">
		<cfreturn variables.m_channelService.getAll()/>
	</cffunction>
	
	<cffunction name="getChannelById" returntype="coldspring.examples.feedviewer.model.channel.channel" access="public" output="false" hint="I retrieve a channel">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		<cfreturn variables.m_channelService.getById(arguments.event.getArg('channelId'))/>		
	</cffunction>	
	
	<cffunction name="getChannelsByCategoryId" access="public" returntype="query" output="false" hint="I retrieve a category">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
	
		<cfreturn variables.m_channelService.getAllByCategory(listToArray(arguments.event.getArg('categoryId')))/>
	
	</cffunction>
	
	<cffunction name="saveChannel" access="public" returntype="void" output="false" hint="I save a channel">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_channelService.save(arguments.event.getArg('channel'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','save failed... fix it! (#cfcatch.message#)')/>
				<cfset announceEvent('renderchannel', arguments.event.getArgs())/>
				<cfreturn/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','channel saved!')/>
		<cfset announceEvent('c.showHome', arguments.event.getArgs())/>
			
	</cffunction>
	
	<cffunction name="removeChannel" access="public" returntype="void" output="false" hint="I save a category">
		<cfargument name="event" type="MachII.framework.Event" required="yes" displayname="Event"/>
		
		<cftry>
			<cfset variables.m_channelService.remove(arguments.event.getArg('channel'))/>
			<cfcatch>
				<cfset arguments.event.setArg('message','remove failed... fix it!')/>
				<cfset announceEvent('renderchannel', arguments.event.getArgs())/>
				<cfreturn/>
			</cfcatch>
		</cftry>	

		<cfset arguments.event.setArg('message','channel removed!')/>
		<cfset announceEvent('c.showHome', arguments.event.getArgs())/>

	
	</cffunction>	
	
</cfcomponent>
			
