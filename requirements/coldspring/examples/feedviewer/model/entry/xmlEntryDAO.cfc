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
		
			
 $Id: xmlEntryDAO.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="MySQL entry DAO" output="false" extends="coldspring.examples.feedviewer.model.entry.entryDAO">
	
	<cffunction name="init" access="public" output="false" returntype="coldspring.examples.feedviewer.model.entry.xmlEntryDAO">
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
		
		<cftry>
			<cfset variables.xmlContent = xmlParse(xmlContent)/>
			<cfset variables.entries = xmlSearch(variables.xmlContent, "//entry") />
			<cfcatch>
				<cfthrow message="Error parsing: #variables.filePath#"/>
			</cfcatch>
		</cftry>
		
	</cffunction>	

	<cffunction name="writeXmlContent" returntype="void" access="private" output="false">
		<cfset var cffile = 0/>
		<cfset var xmlContent = 0/>
		<cfset var idx = 0/>		
		<cfoutput>
		<cfsavecontent variable="xmlContent"><?xml version="1.0" encoding="UTF-8"?>
			<entries>
				<cfloop from="1" to="#arraylen(variables.entries)#" index="idx">
					<entry id="#variables.entries[idx].xmlAttributes.id#"
							url="#xmlFormat(variables.entries[idx].xmlAttributes.url)#"
							guid="#xmlFormat(variables.entries[idx].xmlAttributes.guid)#"							
							channelID="#variables.entries[idx].xmlAttributes.channelID#"
							channelName="#variables.entries[idx].xmlAttributes.channelName#"
							authored_by="#variables.entries[idx].xmlAttributes.authored_by#"
							authored_on="#variables.entries[idx].xmlAttributes.authored_on#"
							retrieved_on="#variables.entries[idx].xmlAttributes.retrieved_on#">
							<title><![CDATA[#variables.entries[idx].xmlChildren[1].xmlText#]]></title>
							<body><![CDATA[#variables.entries[idx].xmlChildren[2].xmlText#]]></body>
					</entry>
							
				</cfloop>
			</entries>
		</cfsavecontent>
		</cfoutput>
		<cffile action="write" file="#variables.filePath#" output="#xmlContent#"/>			
	</cffunction>		
	
	<cffunction name="fetch" returntype="coldspring.examples.feedviewer.model.entry.entry" output="false" access="public" hint="I retrieve a entry">
		<cfargument name="entryIdentifier" type="any" required="true" hint="I am the unique ID of the entry to be retrieved"/>
		<cfset var qGetentry = 0/>
		<cfset var entry = createObject("component","coldspring.examples.feedviewer.model.entry.entry").init()/>
		
		<cfset variables.m_Logger.info("xmlentryDAO: fetching entry with id = #arguments.entryIdentifier#")/>
		
		<cfreturn entry/>

	</cffunction>

	<cffunction name="save" returntype="void" output="false" access="public" hint="I save a entry">
		<cfargument name="entry" type="coldspring.examples.feedviewer.model.entry.entry" hint="I am the entry to be saved" required="true"/>
		<cfset var xmlEntry = 0/>
		<cfif arguments.entry.hasId()>
			<cfset update(arguments.entry)/>
		<cfelse>
			<cfset xmlEntry = xmlSearch(variables.xmlContent, "//entry[@guid='#arguments.entry.getUniqueId()#'][@channelID='#arguments.entry.getChannelID()#']") />
			<cfif arrayLen(xmlEntry)>
				<cfset update(arguments.entry)/>
			<cfelse>
				<cfset create(arguments.entry)/>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="remove" returntype="void" output="false" access="public" hint="I remove a entry">
		<cfargument name="entry" type="coldspring.examples.feedviewer.model.entry.entry" hint="I am the entry to be removed" required="true"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
	<cffunction name="create" returntype="void" output="false" access="public" hint="I save a entry">
		<cfargument name="entry" type="coldspring.examples.feedviewer.model.entry.entry" hint="I am the entry to be saved" required="true"/>

		<cfset var newEntry = xmlElemNew(variables.xmlContent,"entry") />

		<cfset newEntry.xmlChildren[1] = xmlElemNew(variables.xmlContent,"title") />
		<cfset newEntry.xmlChildren[2] = xmlElemNew(variables.xmlContent,"body") />
						
		<cfset refreshXmlContent() />
		
		<cfset arguments.entry.setID(arraylen(variables.entries)+1) />
		<cfset newentry.xmlAttributes.id = arguments.entry.getID() />
		<cfset newentry.xmlAttributes.url = xmlFormat(arguments.entry.getUrl()) />
		<cfset newentry.xmlAttributes.channelID = arguments.entry.getChannelID() />				
		<cfset newentry.xmlAttributes.channelName = arguments.entry.getChannelName() />				
		
		<cfset newentry.xmlAttributes.guid = arguments.entry.getUniqueId() />				
		
		<cfset newentry.xmlAttributes.authored_by = arguments.entry.getAuthor() />				

		<cfif arguments.entry.hasAuthorDate()>
			<cfset newentry.xmlAttributes.authored_on = arguments.entry.getAuthorDate() />							
		<cfelse>
			<cfset newentry.xmlAttributes.authored_on = ""/>
		</cfif>
		<cfset newentry.xmlAttributes.retrieved_on = now()/>

		<cfset newEntry.xmlChildren[1].xmlText = arguments.entry.getTitle() />
		<cfset newEntry.xmlChildren[2].xmlText = arguments.entry.getBody() />				
		
		<!--- <cfdump var="#newEntry#"><cfabort> --->
		
		<cfset arrayAppend(variables.entries,newentry)/>

		<cfset writeXmlContent()/>			
	</cffunction>

	<cffunction name="update" returntype="void" output="false" access="public" hint="I save a entry">
		<cfargument name="entry" type="coldspring.examples.feedviewer.model.entry.entry" hint="I am the entry to be saved" required="true"/>
		<!--- do nothing... --->
				
	</cffunction>	
	
</cfcomponent>