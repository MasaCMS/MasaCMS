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
		
			
 $Id: xmlCategoryGateway.cfc,v 1.2 2005/09/26 02:01:05 rossd Exp $

--->

<cfcomponent name="XML Category Gateway" extends="coldspring.examples.feedviewer.model.category.categoryGateway" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="coldspring.examples.feedviewer.model.category.xmlCategoryGateway">
		<cfargument name="datasourceSettings" type="coldspring.examples.feedviewer.model.datasource.datasourceSettings" required="true"/>
		<cfset var cffile = 0/>
		<cfset var initialContent = ""/>
		<cfset variables.dss = arguments.datasourceSettings/>
		<cfset variables.filePath = variables.dss.getXmlStoragePath() & "category.xml" />
	
		<cfif not fileExists(variables.filePath)>
			<cfsavecontent variable="initialContent"><?xml version="1.0" encoding="UTF-8"?>
			<categories></categories>
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
		<cfset variables.categories = xmlSearch(variables.xmlContent, "//category") />
	</cffunction>	
	
	<cffunction name="getAll" returntype="query" output="false" hint="I retrieve all existing categories" access="public">
		<cfset var qGetCat = queryNew("id,name,description,channelCount")/>
		<cfset var idx = 0/>
		
		<cfset refreshXmlContent() />
		
		<cfloop from="1" to="#arrayLen(variables.categories)#" index="idx">
			<cfset queryAddRow(qGetCat)/>
			<cfset querySetCell(qGetCat,"id",variables.categories[idx].xmlAttributes.id)/>
			<cfset querySetCell(qGetCat,"name",variables.categories[idx].xmlAttributes.name)/>
			<cfset querySetCell(qGetCat,"description",variables.categories[idx].xmlAttributes.description)/>						
		</cfloop>
				
		<cfreturn qGetCat> 
		
	</cffunction>
	
</cfcomponent>