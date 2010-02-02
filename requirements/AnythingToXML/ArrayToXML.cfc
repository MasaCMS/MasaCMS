<cfcomponent namespace="ArrayToXML" displayname="ArrayToXML" output="no" >
	<!--- Array to XML by Daniel Gaspar <daniel.gaspar@gmail.com> 5/1/2008 --->
	<!--- 
	
		Copyright 2008 Daniel Gaspar Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License. You may obtain a copy of the
		License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or
		agreed to in writing, software distributed under the License is distributed on an "AS IS"
		BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License
		for the specific language governing permissions and limitations under the License.
	
	
	--->
	<cffunction name="init" access="public" output="no" returntype="any">
		<cfargument name="XMLutils" type="any" required="yes" />
		<cfargument name="TabUtils" type="any" required="yes" />
		<cfset variables.XMLutils = arguments.XMLutils />
		<cfset variables.TabUtils = arguments.TabUtils />
		<cfreturn this>
	</cffunction>			
	
	<cffunction name="setAnythingToXML" access="public" output="no" returntype="void">
		<cfargument name="AnythingToXML" type="any" required="yes" />
		<cfset variables.AnythingToXML = arguments.AnythingToXML />
	</cffunction>
	
	<cffunction name="ArrayToXML" access="public" output="no" returntype="string" >
		<cfargument name="TheseItems" type="array" required="yes">
		<cfargument name="rootNodeName" type="string" required="no" default="">
		<cfargument name="AttributeList" type="string" required="no" default="">
		<cfset var xmlString = "" />	
		<cfset var i = 1 />
		<cfprocessingdirective suppresswhitespace="yes">
		<cfsetting enablecfoutputonly="yes">
			<cfsavecontent variable="xmlString" >
				<cfoutput>#variables.TabUtils.printtabs()#<#variables.XMLutils.getNodePlural(arguments.rootNodeName)#></cfoutput>
						<cfoutput>#createXML(arguments.TheseItems,arguments.rootNodeName,arguments.AttributeList)#</cfoutput>				
				<cfoutput>#variables.TabUtils.printtabs()#</#variables.XMLutils.getNodePlural(arguments.rootNodeName)#></cfoutput>
			</cfsavecontent>
		</cfprocessingdirective>		
		<cfreturn xmlString />
	</cffunction>
	
	
	<cffunction name="createXML" access="public" output="no" returntype="string">
		<cfargument name="thisArray" type="Array" required="yes">
		<cfargument name="rootNodeName" type="string" required="no" default="">
		<cfargument name="AttributeList" type="string" required="no" default="">	
		<cfset var thisSize = thisArray.size() />
		<cfset var xmlString = "" />	
		<cfset var i = 1 />			
		<cfset variables.TabUtils.addtab() />				
		<cfprocessingdirective suppresswhitespace="yes">
		<cfsetting enablecfoutputonly="yes">
			<cfsavecontent variable="xmlString" >
				<cfloop from="1" to="#thisSize#" index="i" >			
					<cfif IsSimpleValue(thisArray[i])>
							<cfoutput>#variables.TabUtils.printtabs()#<#ucase(rootNodeName)#><![CDATA[#thisArray[i]#]]></#ucase(rootNodeName)#></cfoutput>					
					<cfelse>
						<!--- Yay for Recursion!--->	
						<cfoutput>#variables.AnythingToXML.ToXML(thisArray[i],arguments.rootNodeName,arguments.AttributeList)#</cfoutput>
					</cfif>
				</cfloop>	
			</cfsavecontent>
		</cfprocessingdirective>		
		<cfset variables.TabUtils.removetab() />		
		<cfreturn xmlString />
	</cffunction>
	
</cfcomponent>