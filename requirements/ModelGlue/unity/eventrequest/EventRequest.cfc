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
  <cfset variables._EventHandlerQueue = createObject("component", "ModelGlue.Util.GenericStack") />
  <cfset variables._viewQueue = createObject("component", "ModelGlue.Util.GenericStack") />
	<cfset variables._viewCollection = createObject("component", "ModelGlue.unity.view.ViewCollection") />
	<cfset variables._eventContext = createObject("component", "ModelGlue.unity.eventrequest.EventContext") />	
	<cfset variables._stateContainer = createObject("component", "ModelGlue.Util.GenericCollection") />

  <cffunction name="Init" access="public" returnType="any" output="false" hint="I build a new EventRequest.">
		<cfargument name="stateBuilder" />
		<cfargument name="stateContainer" />
		<cfargument name="requestLog" />
		
    <cfset variables._created = getTickCount() />
    <cfset variables._output = "" />
    <cfset variables._invokedAsyncListeners = false />
    <cfset variables._EventHandlerQueue.init() />
    <cfset variables._viewQueue.init() />
		<cfset variables._viewCollection.init() />
		<cfset variables._stateContainer.init() />
		<cfset variables._initialEventHandler = "" />
		
		<cfif structKeyExists(arguments, "requestLog")>
			<cfset variables._log = arguments.requestLog />
		<cfelse>
	    <cfset variables._log = arguments.stateBuilder.createRequestLog() />
		</cfif>

		<cfif structKeyExists(arguments, "stateContainer")>
			<cfset variables._stateContainer = arguments.stateContainer />
		<cfelse>
			<cfset arguments.stateBuilder.createStateContainer(variables._stateContainer) />
		</cfif>
		
    <cfreturn this />
  </cffunction>
	
	<cffunction name="CreateEventContext" access="public" output="false" hint="I init() and return an EventContext">
		<cfargument name="message" />
    <cfargument name="eventHandler" />
    <cfargument name="framework" />
    <cfargument name="beanMaker" />
		<cfreturn variables._eventContext.init(arguments.message, this, arguments.eventHandler, arguments.framework, arguments.beanMaker) />
	</cffunction>
	
  <cffunction name="GetViewCollection" access="public" output="false" hint="I return the view collection for this request.">
    <cfreturn variables._viewCollection />
  </cffunction>

  <cffunction name="GetStateContainer" access="public" output="false" hint="I return the state container for this request.">
    <cfreturn variables._stateContainer />
  </cffunction>

  <cffunction name="GetInvokedAsyncListeners" access="public" returnType="boolean" output="false" hint="Has this event request resulted in any async listeners?">
    <cfreturn variables._invokedAsyncListeners />
  </cffunction>
  <cffunction name="SetInvokedAsyncListeners" access="public" returnType="void" output="true" hint="Sets whether or not this event request resulted in any async listeners.">
		<cfargument name="invokedAsyncListeners" type="boolean" required="true" />
    <cfset variables._invokedAsyncListeners = arguments.invokedAsyncListeners />
  </cffunction>

  <cffunction name="GetEventHandlerQueue" access="public" output="false" hint="I return the EventHandler queue for this request.">
    <cfreturn variables._EventHandlerQueue />
  </cffunction>

  <cffunction name="EventHandlerQueueIsEmpty" access="public" output="false" hint="I state if the EventHandler queue is empty.">
    <cfreturn variables._EventHandlerQueue.isEmpty() />
  </cffunction>

  <cffunction name="GetNextEventHandler" access="public" returnType="any" output="false" hint="I get the next event in the queue.">
		<cfset variables._currentEventHandler = variables._EventHandlerQueue.get() />
    <cfreturn variables._currentEventHandler />
  </cffunction>

	<cffunction name="GetCurrentEventHandler" access="public" returntype="any" output="false" hint="I get the metadata for the current event handler in the queue.">
		<cfif not structKeyExists(variables, "_currentEventHandler")
					or left(variables._currentEventHandler.getName(), 10) eq "ModelGlue.">
			<cfreturn variables.getInitialEventHandler() />
		<cfelse>
	    <cfreturn variables._currentEventHandler />
	  </cfif>
	</cffunction>
	
	<cffunction name="GetInitialEventHandler" access="public" returntype="any" output="false" hint="I set the ""main"" event for this request.">
    <cfreturn variables._InitialEventHandler />
	</cffunction>
	<cffunction name="SetInitialEventHandler" access="public" returntype="void" output="false" hint="I get the ""main"" event for this request.">
		<cfargument name="eventHandler" />
    <cfset variables._InitialEventHandler = arguments.eventHandler />
	</cffunction>

  <cffunction name="AddEventHandler" access="public" returnType="void" output="false" hint="I add an event-handler to the event queue.">
    <cfargument name="eh" >
    
		<cfif eventHandlerQueueIsEmpty()>
			<cfset variables._initialEventHandler = arguments.eh />
			<cfset variables._currentEventHandler = arguments.eh />
		</cfif>
		
		<cfset variables._eventHandlerQueue.put(arguments.eh) />
  </cffunction>

  <cffunction name="GetViewQueue" access="public" returnType="any" output="false" hint="I return the view queue for this request.">
    <cfreturn variables._viewQueue />
  </cffunction>

  <cffunction name="ViewQueueIsEmpty" access="public" returnType="boolean" output="false" hint="I state if the View queue is empty.">
    <cfreturn variables._ViewQueue.isEmpty() />
  </cffunction>

  <cffunction name="GetNextView" access="public" returnType="any" output="false" hint="I get the next View in the queue.">
    <cfreturn variables._ViewQueue.get() />
  </cffunction>

  <cffunction name="AddView" access="public" returnType="void" output="false" hint="I add a view to the view queue.">
    <cfargument name="view" />
    <cfset variables._viewQueue.put(arguments.view) />
  </cffunction>
	
  <cffunction name="GetRenderedView" access="public" returnType="any" output="false" hint="I get a rendered view by name.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the view to get.">
    <cfreturn variables._viewCollection.getView(arguments.name) />
  </cffunction>

	<!---
  <cffunction name="SetOutput" access="public" returnType="void" output="false" hint="I am the resultant output of this event request.">
    <cfargument name="output" type="string" required="true">
    <cfset variables._output = arguments.output />
  </cffunction>
	--->
	
  <cffunction name="GetOutput" access="public" returnType="any" output="false" hint="I get the resultant output of this event request.">
    <cfreturn variables._viewCollection.getFinalView() />
  </cffunction>

  <cffunction name="Trace" access="public" returnType="Void" output="false" hint="I add a message to the trace log.">
    <cfargument name="type" type="string" />
    <cfargument name="message" type="string" />
    <cfargument name="tag" type="string" default="" />
    <cfargument name="traceType" type="string" default="OK" />

		<cfset variables._log.add(getTickCount() - variables._created, arguments.type, arguments.message, arguments.tag, arguments.traceType) />
  </cffunction>

  <cffunction name="Warn" access="public" returnType="Void" output="false" hint="I add a message to the trace log.">
    <cfargument name="type" type="string" required="true" />
    <cfargument name="message" type="string" required="true" />
    <cfargument name="tag" type="string" required="false" default="" />

		<cfset trace(arguments.type, arguments.message, arguments.tag, "WARNING") />
  </cffunction>

	<cffunction name="GetLog" access="public" returnType="any" output="false">
		<cfreturn variables._log />
	</cffunction>

  <cffunction name="GetTrace" access="public" returnType="any" output="false" hint="I return the tracelog.">
    <cfreturn variables._log.getLog() />
  </cffunction>
</cfcomponent>