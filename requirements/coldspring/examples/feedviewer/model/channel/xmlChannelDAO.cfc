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
		
			
 $Id: xmlChannelDAO.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="XML channel DAO" output="false" extends="coldspring.examples.feedviewer.model.channel.channelDAO">
	
	<cffunction name="init" access="public" output="false" returntype="coldspring.examples.feedviewer.model.channel.xmlChannelDAO">
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

	<cffunction name="writeXmlContent" returntype="void" access="private" output="false">
		<cfset var cffile = 0/>
		<cfset var xmlContent = 0/>
		<cfset var idx = 0/>		
		<cfoutput>
		<cfsavecontent variable="xmlContent"><?xml version="1.0" encoding="UTF-8"?>
			<channels>
				<cfloop from="1" to="#arraylen(variables.channels)#" index="idx">
					<channel id="#variables.channels[idx].xmlAttributes.id#"
							title="#variables.channels[idx].xmlAttributes.title#"
							description="#variables.channels[idx].xmlAttributes.description#"
							url="#variables.channels[idx].xmlAttributes.url#"
							categoryIds="#variables.channels[idx].xmlAttributes.categoryIds#"/>
				</cfloop>
			</channels>
		</cfsavecontent>
		</cfoutput>
		<cffile action="write" file="#variables.filePath#" output="#xmlContent#"/>			
	</cffunction>	
	
	
	<cffunction name="fetch" returntype="coldspring.examples.feedviewer.model.channel.channel" output="false" access="public" hint="I retrieve a channel">
		<cfargument name="channelIdentifier" type="any" required="true" hint="I am the unique ID of the channel to be retrieved"/>
		<cfset var qGetchannel = 0/>
		<cfset var channel = createObject("component","coldspring.examples.feedviewer.model.channel.channel").init()/>
		<cfset var xmlChannel = 0 />
		<cfset var xmlAttribs = 0 />		
		
		<cfset variables.m_Logger.info("xmlchannelDAO: fetching channel with id = #arguments.channelIdentifier#")/>
		
		<cfset refreshXmlContent()/>
		
		<cfset xmlChannel = xmlSearch(variables.xmlContent, "//channel[@id='#arguments.channelIdentifier#']") />
		
		<cfif arraylen(xmlChannel) eq 1>
			<cfset xmlAttribs = xmlChannel[1].xmlAttributes />
			<cfset channel.setID(xmlAttribs.id)/>
			<cfset channel.setUrl(xmlAttribs.url)/>
			<cfset channel.setTitle(xmlAttribs.title)/>
			<cfset channel.setDescription(xmlAttribs.description)/>
			<cfset channel.setCategoryIds(xmlAttribs.categoryIds)/>
		<cfelse>
			<cfthrow message="Channel Not Found (ChannelID:#arguments.channelIdentifier#)"/>
		</cfif>
		
		<cfreturn channel/>
	</cffunction>


	<cffunction name="save" returntype="void" output="false" access="public" hint="I save a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		<cfif arguments.channel.hasId()>
			<cfset update(arguments.channel)/>
		<cfelse>
			<cfset create(arguments.channel)/>
		</cfif>
	</cffunction>
	
	<cffunction name="remove" returntype="void" output="false" access="public" hint="I remove a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be removed" required="true"/>
		<cfset var idx = 0/>
		<cfset refreshXmlContent() />
		
		<cfloop from="1" to="#arrayLen(variables.channels)#" index="idx">
			<cfif variables.channels[idx].xmlAttributes.id eq arguments.channel.getId()>
				<cfset arrayDeleteAt(variables.channels,idx)>
				<cfset writeXmlContent()/>
				<cfreturn/>
			</cfif>		
		</cfloop>
		
	</cffunction>
	
	<cffunction name="create" returntype="void" output="false" access="private" hint="I create a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		
		<cfset var newChannel = xmlElemNew(variables.xmlContent,"channel") />
		
		<cfset refreshXmlContent() />
		
		<cfset arguments.channel.setID(arraylen(variables.channels)+1) />
		<cfset newChannel.xmlAttributes.id = arguments.channel.getID() />
		<cfset newChannel.xmlAttributes.title = arguments.channel.getTitle() />
		<cfset newChannel.xmlAttributes.url = arguments.channel.getUrl() />				
		<cfset newChannel.xmlAttributes.description = arguments.channel.getDescription() />				
		<cfset newChannel.xmlAttributes.categoryIds = arguments.channel.getCategoryIds() />						
		
		<cfset arrayAppend(variables.channels,newChannel)/>
		
		<cfset writeXmlContent()/>	
		
	</cffunction>
	
	<cffunction name="update" returntype="void" output="false" access="private" hint="I create a channel">
		<cfargument name="channel" type="coldspring.examples.feedviewer.model.channel.channel" hint="I am the channel to be saved" required="true"/>
		
		<cfset var channelIdx = 1/>
		<cfset var xmlChannel = 0/>
		<cfset refreshXmlContent()/>
		
		<cfset xmlChannel = xmlSearch(variables.xmlContent, "//channel[@id='#arguments.channel.getId()#']") />

		<cfif arraylen(xmlChannel) eq 1>
			<cfset xmlAttribs = xmlChannel[1].xmlAttributes />
			<cfset xmlAttribs.id = arguments.channel.getID()/>
			<cfset xmlAttribs.title = arguments.channel.getTitle()/>
			<cfset xmlAttribs.url = arguments.channel.getUrl()/>
			<cfset xmlAttribs.description = arguments.channel.getDescription()/>	
			<cfset xmlAttribs.categoryIds = arguments.channel.getCategoryIds()/>						
			<cfset writeXmlContent()/>	
		<cfelse>
			<cfthrow message="Category Not Found (CategoryID:#arguments.channel.getId()#)"/>
		</cfif>

	</cffunction>	
	
	
</cfcomponent>