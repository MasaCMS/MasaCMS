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
		
			
 $Id: xmlEntryGateway.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="XML entry Gateway" extends="coldspring.examples.feedviewer.model.entry.entryGateway" output="false">
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.entry.xmlEntryGateway">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		<cfset var cffile = 0/>
		<cfset var initialContent = ""/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfset variables.filePath = variables.dss.getXmlStoragePath() & "entry.xml" />
	
		<cfif not fileExists(variables.filePath)>
			<cfsavecontent variable="initialContent"><?xml version="1.0" encoding="UTF-8"?>
			<entries></entries>
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
		<cfset variables.entries = xmlSearch(variables.xmlContent, "//entry") />
	</cffunction>
	
	<cffunction name="getAll" returntype="query" output="false" hint="I retrieve all existing entrys" access="public">
		<cfargument name="start" type="numeric" required="false" hint="start" default="0"/>
		<cfargument name="maxEntries" type="numeric" required="false" hint="number of records to fetch" default="50"/>
		
		<cfset var qGetentry = queryNew("blogTitle,xmlUrl,id,channel_id,url,authored_by,authored_on,title,body,guid") />
		
		<cfset var idx = 0/>
		
		<cfset var stOrder = structnew()/>
		<cfset var arOrder = 0/>
		
		
		<cfset variables.m_Logger.info("xmlentryGateway: fetching all entrys starting at: #arguments.start#")/>
		
		
		<cfset refreshXmlContent() />
		
		
		<cfloop from="1" to="#arrayLen(variables.entries)#" index="idx">
			<cfset stOrder[idx] = structnew()/>
			<cfset stOrder[idx].ts = createOdbcDateTime(variables.entries[idx].xmlAttributes.retrieved_on).getTime().toString()/>
		</cfloop>
		
		<cfset arOrder =  StructSort( stOrder, "numeric", "DESC", "ts") />
		
		<cfloop from="#(arguments.start+1)#" to="#min((arguments.start+arguments.maxEntries),arraylen(arOrder))#" index="idx" >
			<cfset queryAddRow(qGetentry)/>
			<cfset querySetCell(qGetentry,"id",variables.entries[arOrder[idx]].xmlAttributes.id)/>
			<cfset querySetCell(qGetentry,"blogTitle",variables.entries[arOrder[idx]].xmlAttributes.channelName)/>
			<cfset querySetCell(qGetentry,"channel_id",variables.entries[arOrder[idx]].xmlAttributes.channelID)/>
			<cfset querySetCell(qGetentry,"url",variables.entries[arOrder[idx]].xmlAttributes.url)/>
			<cfset querySetCell(qGetentry,"authored_by",variables.entries[arOrder[idx]].xmlAttributes.authored_by)/>
			<cfset querySetCell(qGetentry,"authored_on",variables.entries[arOrder[idx]].xmlAttributes.authored_on)/>															
			<cfset querySetCell(qGetentry,"guid",variables.entries[arOrder[idx]].xmlAttributes.guid)/>															
			<cfset querySetCell(qGetentry,"title",variables.entries[arOrder[idx]].xmlChildren[1].XmlText)/>															
			<cfset querySetCell(qGetentry,"body",variables.entries[arOrder[idx]].xmlChildren[2].XmlText)/>															
			
		</cfloop>

		<cfreturn qGetentry> 
	</cffunction>
	
	<cffunction name="getByChannelID" returntype="query" output="false" hint="I retrieve all existing entrys" access="public">
		<cfargument name="channelID" type="numeric" required="true" hint="aIds of the channel to restrict to"/>
		<cfargument name="maxEntries" type="numeric" required="false" default="50" hint="max number of entries to retrieve" />
		
		<cfset var qGetentry = queryNew("blogTitle,xmlUrl,id,channel_id,url,authored_by,authored_on,title,body,guid") />
		
		<cfset var idx = 0/>
		
		<cfset var stOrder = structnew()/>
		<cfset var arOrder = 0/>
		
		
		<cfset variables.m_Logger.info("xmlentryGateway: fetching entrys by channel id: #arguments.channelId#")/>
		
		
		<cfset refreshXmlContent() />
		
		
		<cfloop from="1" to="#arrayLen(variables.entries)#" index="idx">
			<cfif variables.entries[idx].xmlAttributes.channelID eq arguments.channelID>
				<cfset stOrder[idx] = structnew()/>
				<cfset stOrder[idx].ts = createOdbcDateTime(variables.entries[idx].xmlAttributes.retrieved_on).getTime().toString()/>
			</cfif>	
		</cfloop>
		
		<cfset arOrder =  StructSort( stOrder, "numeric", "DESC", "ts") />
		
		<cfloop from="1" to="#min(arguments.maxEntries,arraylen(arOrder))#" index="idx" >
			<cfset queryAddRow(qGetentry)/>
			<cfset querySetCell(qGetentry,"id",variables.entries[arOrder[idx]].xmlAttributes.id)/>
			<cfset querySetCell(qGetentry,"blogTitle",variables.entries[arOrder[idx]].xmlAttributes.channelName)/>
			<cfset querySetCell(qGetentry,"channel_id",variables.entries[arOrder[idx]].xmlAttributes.channelID)/>
			<cfset querySetCell(qGetentry,"url",variables.entries[arOrder[idx]].xmlAttributes.url)/>
			<cfset querySetCell(qGetentry,"authored_by",variables.entries[arOrder[idx]].xmlAttributes.authored_by)/>
			<cfset querySetCell(qGetentry,"authored_on",variables.entries[arOrder[idx]].xmlAttributes.authored_on)/>															
			<cfset querySetCell(qGetentry,"guid",variables.entries[arOrder[idx]].xmlAttributes.guid)/>															
			<cfset querySetCell(qGetentry,"title",variables.entries[arOrder[idx]].xmlChildren[1].XmlText)/>															
			<cfset querySetCell(qGetentry,"body",variables.entries[arOrder[idx]].xmlChildren[2].XmlText)/>															
			
		</cfloop>

		<cfreturn qGetentry> 
		
	</cffunction>	
	
</cfcomponent>