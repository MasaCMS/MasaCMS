<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayName="EventHandler" output="false" hint="I am metadata about an event, including its views, announcements and their arguments." >
  <cffunction name="init" returnType="ModelGlue.unity.eventhandler.EventHandler" output="false" hint="I build a new event.">
    <cfset variables._instance.name = "" />
    <cfset variables._instance.access = "public" />
    <cfset variables._instance.extensible = false />
    <cfset variables._instance.scaffold = false />
    <cfset variables._instance.messages = arrayNew(1) />
    <cfset variables._instance.messagesMap = structNew() />
    <cfset variables._instance.views = arrayNew(1) />
    <cfset variables._instance.generatedViews = arrayNew(1) />
    <cfset variables._instance.resultMappings = structNew() />
    <cfset variables._instance.implicitResults = arrayNew(1) />
    <cfreturn this />
  </cffunction>

  <cffunction name="toStruct" access="public" returntype="struct" output="false">
		<cfset var result = structNew() />
		<cfset var i = "" />
		<cfset var j = "" />
		
		<cfset result.name = variables._instance.name />
		<cfset result.access = variables._instance.access />
		<cfset result.extensible = variables._instance.extensible />
		<cfset result.scaffold  = variables._instance.scaffold />
		<cfset result.generatedViews = variables._instance.generatedViews />
		<cfset result.results = variables._instance.resultMappings />
		<cfset result.implicitResults = variables._instance.implicitResults />

		<cfset result.messages = arrayNew(1) />
		
		<cfloop from="1" to="#arrayLen(variables._instance.messages)#" index="i">
			<cfset result.messages[i] = arrayNew(1) />
			<cfloop from="1" to="#arrayLen(variables._instance.messagesMap[variables._instance.messages[i]])#" index="j">
			  <cfset arrayAppend(result.messages[i], variables._instance.messagesMap[variables._instance.messages[i]][j].toStruct()) />
			</cfloop>
		</cfloop>
		
		<cfset result.views = arrayNew(1) />
		
		<cfloop to="#arrayLen(variables._instance.views)#" from="1" index="i">
			<cfset result.views [i] = variables._instance.views[i].toStruct() />
		</cfloop>

		<cfreturn result />
	</cffunction>
	
	<cffunction name="toXmlString" access="public" returntype="any" output="false">
		<cfset var eh = toStruct() />
		<cfset var messages = eh.messages />
		<cfset var message = "" />
		<cfset var views = eh.views />
		<cfset var results = eh.results />
		<cfset var xml = "" />
		<cfset var i = "" />
		<cfset var j = "" />
		<cfset var k = "" />
		
		<cfoutput>
		<cfsavecontent variable="xml">
			<event-handler name="#eh.name#" access="#eh.access#">
				<broadcasts>
					<cfloop from="1" to="#arrayLen(messages)#" index="i">
						<cfloop from="1" to="#arrayLen(messages[i])#" index="j">
							<message name="#messages[i][j].name#">
								<cfloop collection="#messages[i][j].arguments#" item="k">
									<argument name="#k#" value="#messages[i][j].arguments[k]#" />
								</cfloop>
							</message>
						</cfloop>
					</cfloop>
				</broadcasts>
				<views>
					<cfloop from="1" to="#arrayLen(views)#" index="i">
						<view name="#views[i].name#" template="#views[i].template#" append="#views[i].append#">
							<cfloop collection="#views[i].values#" item="j">
								<value name="#j#" value="#views[i].values[j].value#" overwrite="#views[i].values[j].overwrite#" />
							</cfloop>
						</view>
					</cfloop>
				</views>
				<results>
					<cfloop collection="#results#" item="i">
						<cfloop from="1" to="#arrayLen(results[i])#" index="j">
							<result name="#i#" do="#results[i][j].event#" redirect="#results[i][j].redirect#" append="#results[i][j].append#" preserveState="#results[i][j].preservestate#" />
						</cfloop>
					</cfloop>
				</results>
			</event-handler>
		</cfsavecontent>
		</cfoutput>
		
		<cfreturn xml />
	</cffunction>
	
  <cffunction name="setName" access="public" returnType="void" output="false" hint="I set the event's name.">
    <cfargument name="name" required="true" type="string">
    <cfset variables._instance.name = arguments.name />
  </cffunction>
  
  <cffunction name="getName" access="public" returnType="string" output="false" hint="I get the event's name.">
    <cfreturn variables._instance.name />
  </cffunction>
    
  <cffunction name="setAccess" access="public" returnType="void" output="false" hint="I set the event's ""access"" property.">
    <cfargument name="access" required="true" type="string">
    
    <cfif arguments.access neq "public" and arguments.access neq "private">
      <cfthrow message="Model-Glue:  Bad access value" detail="An &lt;event-handler&gt;'s ACCESS attribute may only be equal to PUBLIC or PRIVATE" />
    </cfif>
    
    <cfset variables._instance.access = arguments.access />
  </cffunction>
  
  <cffunction name="getAccess" access="public" returnType="string" output="false" hint="I get the event's ""access"" property.">
    <cfreturn variables._instance.access />
  </cffunction>

  <cffunction name="setExtensible" access="public" returnType="void" output="false" hint="I set the event's ""extensible"" property.">
    <cfargument name="extensible" required="true" type="boolean">
    <cfset variables._instance.extensible = arguments.extensible />
  </cffunction>
  
  <cffunction name="getExtensible" access="public" returnType="boolean" output="false" hint="I get the event's ""extensible"" property.">
    <cfreturn variables._instance.extensible />
  </cffunction>

  <cffunction name="setScaffold" access="public" returnType="void" output="false" hint="I set the event's ""scaffold"" property.">
    <cfargument name="scaffold" required="true" type="string">
    <cfset variables._instance.scaffold = arguments.scaffold />
  </cffunction>
  
  <cffunction name="getScaffold" access="public" returnType="string" output="false" hint="I get the event's ""scaffold"" property.">
    <cfreturn variables._instance.scaffold />
  </cffunction>

  <cffunction name="addMessage" access="public" returnType="void" output="false" hint="I add a message.">
    <cfargument name="message" required="true" type="ModelGlue.unity.eventhandler.Message">

		<cfif not structKeyExists(variables._instance.messagesMap, arguments.message.getName())>
	    <cfset arrayAppend(variables._instance.messages, arguments.message.getName()) />
			<cfset variables._instance.messagesMap[arguments.message.getName()] = arrayNew(1) />
		</cfif>
		
		<cfset arrayAppend(variables._instance.messagesMap[arguments.message.getName()], arguments.message) />
  </cffunction>

  <cffunction name="hasMessage" access="public" returnType="boolean" output="false" hint="I state if a message already exists in this <event-handler>.">
    <cfargument name="messagename" required="true" type="string">
		<cfreturn structKeyExists(variables._instance.messagesMap, arguments.messageName) />
  </cffunction>

  <cffunction name="getMessage" access="public" returnType="array" output="false" hint="I get a message by name.">
    <cfargument name="messagename" required="true" type="string">
		<cfreturn variables._instance.messagesMap[arguments.messageName] />
  </cffunction>

  <cffunction name="getMessages" access="public" returnType="array" output="false" hint="I return messages this event broadcasts.">
    <cfreturn variables._instance.messages />
  </cffunction>
  
  <cffunction name="addView" access="public" returnType="void" output="false" hint="I add a view.">
    <cfargument name="view" required="true" type="ModelGlue.unity.eventhandler.View">
    <cfset arrayPrepend(variables._instance.views, arguments.view) />
  </cffunction>
  
  <cffunction name="getViews" access="public" returnType="array" output="false" hint="I return the views this event renders.">
    <cfreturn variables._instance.views />
  </cffunction>

  <cffunction name="addResultMapping" access="public" returnType="void" output="false" hint="I add a ResultMapping.">
    <cfargument name="Name" required="true" type="string">
    <cfargument name="Event" required="true" type="string">
    <cfargument name="Redirect" required="true" type="boolean">
    <cfargument name="Append" required="true" type="string">
    <cfargument name="Anchor" required="true" type="string">
    <cfargument name="Reset" required="true" type="boolean">
    <cfargument name="PreserveState" required="true" type="boolean">

		<cfset var mapping = structNew() />
		<cfset mapping.event = arguments.event />
		<cfset mapping.redirect = arguments.redirect />
		<cfset mapping.append = arguments.append />
		<cfset mapping.anchor = arguments.anchor />
		<cfset mapping.preserveState = arguments.preserveState />

    <cfparam name="variables._instance.resultMappings[arguments.name]" type="array" default="#arrayNew(1)#" />
		
		<cfif arguments.reset>
			<cfset variables._instance.resultMappings[arguments.name] = arrayNew(1) />
		</cfif>

    <cfset arrayAppend(variables._instance.resultMappings[arguments.name], mapping) />
  </cffunction>
  
	<cffunction name="resultMappingExists" access="public" returntype="boolean" output="false" hint="Do any mappings yet exist for the given name?">
    <cfargument name="Name" required="true" type="string">
		<cfreturn structKeyExists(variables._instance.resultMappings, arguments.name) />
	</cffunction>
	
  <cffunction name="getResultMappings" access="public" output="false" hint="I return the ResultMappings this event renders.">
    <cfreturn variables._instance.ResultMappings />
  </cffunction>

</cfcomponent>
