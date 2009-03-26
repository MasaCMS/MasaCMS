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
		
			
 $Id: romeNormalizationService.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="romeNormalizationService" output="false" extends="coldspring.examples.feedviewer.model.normalization.normalizationService">
	
	
	<cffunction name="init" access="public" returntype="coldspring.examples.feedviewer.model.normalization.romeNormalizationService" output="false">
	
		<cfreturn this/>
	
	</cffunction>
	
	
	<cffunction name="normalize" returntype="array" output="false" hint="Returns an array of structs containing author, content, date, id, link, and title members. Also returns an isHtml member that is set to 'true' when the content element contains HTML." access="public">
		<cfargument name="url" type="string" required="true"/>
		
		<cfset var jUrl = createObject("java","java.net.URL").init(arguments.url)/>
		<cfset var xmlReader = createObject("java","com.sun.syndication.io.XmlReader").init(jUrl)/>
		<cfset var feed = createObject("java","com.sun.syndication.io.SyndFeedInput").build(xmlReader)/>
		<cfset var entries = feed.getEntries()/>
		<cfset var rtnArray = arraynew(1)/>
		<cfset var entryIdx = 0/>
		<cfset var entry = 0/>		
		<cfset var newEntry = structnew()/>
		
		<cfloop from="1" to="#arraylen(entries)#" index="entryIdx">
			<cfset newEntry.id = entries[entryIdx].getUri()/>
			<cfset newEntry.author = entries[entryIdx].getAuthor()/>
			<cfset newEntry.title = entries[entryIdx].getTitle()/>
			<cfset newEntry.content = entries[entryIdx].getDescription().getValue()/>
			<cfset newEntry.date = entries[entryIdx].getPublishedDate()/>
			<cfset newEntry.link = entries[entryIdx].getLink()/>
			
			<!--- this is really dumb, but we need to convert java nulls into cfml zero-length strings.
				  I may move this into a custom java wrapper for com.sun.syndication.io.SyndEntry if performance
				  becomes an issue --->
				  
			<cfset checkNulls(newEntry)/>
			
			<cfset arrayAppend(rtnArray,duplicate(newEntry))/>
			
		</cfloop>
		<cfreturn rtnArray/>
	</cffunction>
	
	<cffunction name="checkNulls" returntype="void" access="private">
		<cfargument name="structToCheck" type="struct"/>
		<cfset var key = 0/>
		<cfset var assignVal = 0/>
		<cfloop collection="#arguments.structToCheck#" item="key">
			<cftry>
				<cfset assignVal = arguments.structToCheck[key]/>
				<cfcatch>
					<cfset arguments.structToCheck[key] = ""/>
				</cfcatch>
			</cftry>
		</cfloop>
	</cffunction>
	
</cfcomponent>
