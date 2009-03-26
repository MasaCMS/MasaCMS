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
		
			
 $Id: xmlChannelGateway.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="XML Channel Gateway" extends="coldspring.examples.feedviewer.model.channel.channelGateway" output="false">
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.channel.xmlChannelGateway">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		
		<cfset var cffile = 0/>
		<cfset var initialContent = ""/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfset variables.filePath = variables.dss.getXmlStoragePath() & "channel.xml" />
	
		<cfif not fileExists(variables.filePath)>
			<cfsavecontent variable="initialContent"><?xml version="1.0" encoding="UTF-8"?>
			<channels></channels>
			</cfsavecontent>
			<cffile action="write" file="#variables.filePath#" output="#initialContent#"/>			
		</cfif>

		<cfset refreshXmlContent()/>	

		<cfreturn this/>
	</cffunction>
	
	<cffunction name="setLogger" returntype="void" access="public" output="false" hint="dependency: logger">
		<cfargument name="logger" type="coldspring.examples.feedviewer.model.logging.logger" required="true"/>
		<cfset variables.m_Logger = arguments.logger/>
	</cffunction>	


	<cffunction name="refreshXmlContent" returntype="void" access="private" output="false">
		<cfset var cffile = 0/>
		<cfset var xmlContent = 0/>
		<cffile action="read" file="#variables.filePath#" variable="xmlContent"/>
		
		<cfset variables.xmlContent = xmlParse(xmlContent)/>
		<cfset variables.channels = xmlSearch(variables.xmlContent, "//channel") />
	</cffunction>
	
	
	<cffunction name="getAll" returntype="query" output="false" hint="I retrieve all existing channels" access="public">
		<cfset var qGetChannel = queryNew("id,url,title,description,entryCount")/>
		<cfset var idx = 0/>
		<cfset variables.m_Logger.info("xmlchannelGateway: fetching all channels")/>
		
		<cfset refreshXmlContent() />
		
		<cfloop from="1" to="#arrayLen(variables.channels)#" index="idx">
			<cfset queryAddRow(qGetChannel)/>
			<cfset querySetCell(qGetChannel,"id",variables.channels[idx].xmlAttributes.id)/>
			<cfset querySetCell(qGetChannel,"title",variables.channels[idx].xmlAttributes.title)/>
			<cfset querySetCell(qGetChannel,"url",variables.channels[idx].xmlAttributes.url)/>
			<cfset querySetCell(qGetChannel,"description",variables.channels[idx].xmlAttributes.description)/>						
		</cfloop>

		<cfreturn qGetChannel> 
		
	</cffunction>
	
	<cffunction name="getAllByCategories" returntype="query" output="false" hint="I retrieve all existing channels" access="public">
		<cfargument name="categoryIds" type="array" required="true" hint="array of Ids of the categories restrict to"/>
		
		
		<cfset var qGetChannel = queryNew("id,url,title,description,entryCount")/>
		<cfset var idx = 0/>
		<cfset var li = 0/>	
		<cfset var bGrabChannel = false/>	
		<cfset var lCategoryIDs = arrayToList(arguments.categoryIds)/>			
		
		<cfset variables.m_Logger.info("xmlchannelGateway: fetching channels by category ids: #arrayToList(arguments.categoryIds)#")/>
		
		<cfset refreshXmlContent() />
		
		<cfloop from="1" to="#arrayLen(variables.channels)#" index="idx">
			<cfset bGrabChannel = false/>	
			<cfloop list="#lCategoryIDs#" index="li">
				<cfif listFind(variables.channels[idx].xmlAttributes.categoryIds, li)>
					<cfset bGrabChannel = true/>	
				</cfif>
			</cfloop>
			<cfif bGrabChannel>
				<cfset queryAddRow(qGetChannel)/>
				<cfset querySetCell(qGetChannel,"id",variables.channels[idx].xmlAttributes.id)/>
				<cfset querySetCell(qGetChannel,"title",variables.channels[idx].xmlAttributes.title)/>
				<cfset querySetCell(qGetChannel,"url",variables.channels[idx].xmlAttributes.url)/>
				<cfset querySetCell(qGetChannel,"description",variables.channels[idx].xmlAttributes.description)/>						
			</cfif>
		</cfloop>
		
		<cfreturn qGetChannel> 
	</cffunction>	
	
</cfcomponent>