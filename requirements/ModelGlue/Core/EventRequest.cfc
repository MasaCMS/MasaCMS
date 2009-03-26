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


<cfcomponent displayName="EventRequest" output="false" hint="I am a request for an event-handler.">
  <cffunction name="Init" access="public" returnType="ModelGlue.Core.EventRequest" output="false" hint="I build a new EventRequest.">
    <cfargument name="initialEvent" type="string" required="true" hint="I am the name of the initial event." />
    <cfargument name="stateContainer" type="ModelGlue.Util.GenericCollection" required="true" hint="I am the state container for this event request." />
    <cfargument name="log" type="ModelGlue.Core.RequestLog" required="false" default="#createObject("component", "ModelGlue.Core.RequestLog").init()#" />
    <cfset variables.stateContainer = arguments.stateContainer />
    <cfset variables.log = arguments.log />
    <cfset variables.initialevent = arguments.initialevent />
    <cfset variables.currentEvent = arguments.initialevent />
    <cfset variables.created = getTickCount() />
    <cfset variables.output = "" />
    <cfset variables.eventQueue = createObject("component", "ModelGlue.Util.GenericStack").init() />
    <cfset variables.viewQueue = createObject("component", "ModelGlue.Util.GenericStack").init() />
    <cfreturn this />
  </cffunction>

  <cffunction name="GetStateContainer" access="public" returnType="ModelGlue.Util.GenericCollection" output="false" hint="I return the state container for this request.">
    <cfreturn variables.stateContainer />
  </cffunction>

  <cffunction name="GetInitialEvent" access="public" returnType="string" output="false" hint="I return the initial event for this request.">
    <cfreturn variables.initialevent />
  </cffunction>

  <cffunction name="GetEventQueue" access="public" returnType="ModelGlue.Util.GenericStack" output="false" hint="I return the event queue for this request.">
    <cfreturn variables.eventQueue />
  </cffunction>

  <cffunction name="EventQueueIsEmpty" access="public" returnType="boolean" output="false" hint="I state if the event queue is empty.">
    <cfreturn variables.eventQueue.isEmpty() />
  </cffunction>

  <cffunction name="GetNextEvent" access="public" returnType="ModelGlue.Metadata.Event" output="false" hint="I get the next event in the queue.">
		<cfset variables.currentEvent = variables.eventQueue.get() />
    <cfreturn variables.currentEvent />
  </cffunction>

	<cffunction name="GetCurrentEvent" access="public" returntype="ModelGlue.Metadata.Event" output="false" hint="I get the metadata for the current event handler in the queue.">
    <cfreturn variables.currentEvent />
	</cffunction>
	
  <cffunction name="AddEvent" access="public" returnType="void" output="false" hint="I add an event-handler to the event queue.">
    <cfargument name="event" type="ModelGlue.Metadata.Event" required="true">
    <cfif not variables.eventQueue.count()>
    	<cfset variables.currentEvent = arguments.event />
    </cfif>
    <cfset variables.eventQueue.put(arguments.event) />
  </cffunction>

  <cffunction name="GetViewQueue" access="public" returnType="ModelGlue.Util.GenericStack" output="false" hint="I return the view queue for this request.">
    <cfreturn variables.viewQueue />
  </cffunction>

  <cffunction name="ViewQueueIsEmpty" access="public" returnType="boolean" output="false" hint="I state if the View queue is empty.">
    <cfreturn variables.ViewQueue.isEmpty() />
  </cffunction>

  <cffunction name="GetNextView" access="public" returnType="ModelGlue.Metadata.View" output="false" hint="I get the next View in the queue.">
    <cfreturn variables.ViewQueue.get() />
  </cffunction>

  <cffunction name="AddView" access="public" returnType="void" output="false" hint="I add a view to the view queue.">
    <cfargument name="view" type="ModelGlue.Metadata.View" required="true">
    <cfset variables.viewQueue.put(arguments.view) />
  </cffunction>

  <cffunction name="SetOutput" access="public" returnType="void" output="false" hint="I am the resultant output of this event request.">
    <cfargument name="output" type="string" required="true">
    <cfset variables.output = arguments.output />
  </cffunction>

  <cffunction name="GetOutput" access="public" returnType="string" output="false" hint="I get the resultant output of this event request.">
    <cfreturn variables.output />
  </cffunction>

  <cffunction name="Trace" access="public" returnType="Void" output="false" hint="I add a message to the trace log.">
    <cfargument name="type" type="string" required="true" />
    <cfargument name="message" type="string" required="true" />
    <cfargument name="tag" type="string" required="false" default="" />

		<cfset variables.log.add(getTickCount() - variables.created, arguments.type, arguments.message, arguments.tag, "OK") />
  </cffunction>

  <cffunction name="Warn" access="public" returnType="Void" output="false" hint="I add a message to the trace log.">
    <cfargument name="type" type="string" required="true" />
    <cfargument name="message" type="string" required="true" />
    <cfargument name="tag" type="string" required="false" default="" />

		<cfset variables.log.add(getTickCount() - variables.created, arguments.type, arguments.message, arguments.tag, "WARNING") />
  </cffunction>

	<cffunction name="GetLog" access="public" returnType="ModelGlue.Core.RequestLog" output="false">
		<cfreturn variables.log />
	</cffunction>

  <cffunction name="GetTrace" access="public" returnType="array" output="false" hint="I return the tracelog.">
    <cfreturn variables.log.getLog() />
  </cffunction>
</cfcomponent>