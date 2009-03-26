<!---
 
  Copyright (c) 2002-2005	David Ross,	Chris Scott, Kurt Wiersma
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: remoteFacade.cfc,v 1.3 2005/10/11 03:46:35 wiersma Exp $

--->


<cfcomponent displayname="Remote Facade" output="false" hint="I am a remote facade for feedviewer">
		
	<cffunction name="getAllChannels" returntype="query" access="remote" output="false" hint="I retrieve all existing channels">
		<!--- remember, each remote call will cause a new instance of this cfc to be created 
		  thus, we will reference the service factory thru the application scope:
		--->
		<cfset var channelService = application.serviceFactory.getBean('channelService') />
		<cfreturn channelService.getAll()/>
	</cffunction>

	<cffunction name="getAllCategories" returntype="query" access="remote" output="false" hint="I retrieve all existing channel categories">
		<cfset var categoryService = application.serviceFactory.getBean('categoryService') />
		<cfreturn categoryService.getAllCategories()/>
	</cffunction>

	<!--- Returns a ActionScript object with the mapping defined in the flashMappings config --->
	<cffunction name="getCategory" access="remote" returntype="struct" output="false">
		<cfargument name="categoryID" type="numeric" required="true">
		<cfset var categoryService = application.serviceFactory.getBean('categoryService') />
		<cfset var flashUtilService = application.serviceFactory.getBean('flashUtilityService') />
		<cfreturn flashUtilService.processServiceMethodResult(categoryService.getById(arguments.categoryID)) />
	</cffunction>
		
	<cffunction name="saveCategory" access="remote" returntype="struct" output="false">
		<cfargument name="category" type="struct" required="true">
		<cfset var categoryService = application.serviceFactory.getBean('categoryService') />
		<cfset var flashUtilService = application.serviceFactory.getBean('flashUtilityService') />
		<!--- Takes a actionscript category objects and converts it to a CFC instance --->
		<cfset var args = flashUtilService.processServiceMethodParams(arguments) />
		<cfset categoryService.save(args.category)>
	</cffunction>

	<cffunction name="getChannelsByCategoryIds" returntype="query" access="remote" output="false" hint="I retrieve all existing channels within a given category ID">
		<cfargument name="categoryID" type="numeric" required="true" hint="I am the category ID to fetch the channels by"/>
		<cfset var channelService = application.serviceFactory.getBean('channelServiceyService') />
		<!--- channelService expects an array of category ids, but since this method only retrieves 1 at a time, we place the supplied categoryID into an array: --->
		<cfreturn channelService.getAllByCategory(listToArray(categoryID))/>
	</cffunction>	

	<cffunction name="getRecentEntries" returntype="query" access="remote" output="false" hint="I retrieve the most recent entries">
		<cfargument name="maxEntries" type="numeric" required="true"/>
		<cfset var entryService = application.serviceFactory.getBean('entryService') />
		<cfreturn entryService.getAll(0,arguments.maxEntries)/>
	</cffunction>

	<cffunction name="refreshAllChannels" returntype="void" access="remote" output="false" hint="I will aggregate all the newest entries for each channel in the system. I would probably be called on a repeating schedule, to keep the entries up to date.">
		<cfargument name="maxEntries" type="numeric" required="false" default="50" />
		
		<!--- get all channels: --->
		<cfset var channelService = application.serviceFactory.getBean('channelService') />
		<cfset var allChannels = channelService.getAll() />
		
		<!--- get a reference to the aggregator service --->
		<cfset var aggregatorService = variables.serviceFactory.getBean('aggregatorService')/>
		
		<!--- loop over the channels, obtaining a channel instance for each to be passed to the aggregatorService  --->
		<cfloop query="allChannels">
			<cfset aggregatorService.aggregateEntriesByChannel(
				   										channelService.getById(allChannels.id)
																)/>
		
		</cfloop>
		
	</cffunction>


</cfcomponent>