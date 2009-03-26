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
		
			
 $Id: aggregatorService.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="Aggregator Service" output="false">

	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.aggregator.aggregatorService" output="false">
	
		<cfreturn this/>
	
	</cffunction>

	<cffunction name="setNormalizationService" returntype="void" access="public"	output="false" hint="dependency: normalizationService">
		<cfargument name="normalizationService" type="coldspring.examples.feedviewer.model.normalization.normalizationService"	required="true"/>
		<cfset variables.m_normalizationService = arguments.normalizationService/>
	</cffunction>	
	
	<cffunction name="setEntryService" returntype="void" access="public"	output="false" hint="dependency: entryService">
		<cfargument name="entryService" type="coldspring.examples.feedviewer.model.entry.entryService" required="true"/>
		<cfset variables.m_entryService = arguments.entryService/>
	</cffunction>	
		
	
	<cffunction name="aggregateEntriesByChannel" returntype="void" access="public" output="false" hint="I aggregate and store all entries for a supplied channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel"	required="true"/>
		
		<cfset var normalizedEntries = variables.m_normalizationService.normalize(arguments.channel.getUrl())/>
		<cfset var entryIndex = 0/>
		<cfset var entryData = structnew()/>
		
		<cfset entryData.channelID = arguments.channel.getId()/>
		<cfset entryData.channelName = arguments.channel.getTitle()/>
		
		<cfloop from="1" to="#arraylen(normalizedEntries)#" index="entryIndex">
			<cfset entryData.UniqueID = normalizedEntries[entryIndex].id/>
			<cfset entryData.Title = normalizedEntries[entryIndex].title/>		
			<cfset entryData.Url = normalizedEntries[entryIndex].link/>
			<cfset entryData.Body = normalizedEntries[entryIndex].content/>
			<cfset entryData.Author = normalizedEntries[entryIndex].Author/>					
			<cfif len(normalizedEntries[entryIndex].Date)>
				<cfset entryData.AuthorDate = normalizedEntries[entryIndex].Date/>			
			</cfif>
			
			<!--- (attempt to) save the entry --->
			<cfset variables.m_entryService.save(createObject('component','coldspring.examples.feedviewer.model.entry.entry').init(argumentcollection=entryData))/>
			
		</cfloop>
		
		
	</cffunction>
	
	<cffunction name="getById" returntype="coldspring.examples.feedviewer.model.category.category" access="public" output="false" hint="I retrieve a category">
		<cfargument name="categoryId" type="numeric" required="true"/>
		<cfreturn variables.m_CategoryDAO.fetch(arguments.categoryId)/>
	</cffunction>
	
</cfcomponent>