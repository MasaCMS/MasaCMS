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


<cfcomponent displayName="EventContext" output="false" hint="I am the Event that is manipulated inside of a Controller's listener functions." extends="ModelGlue.Core.Event">
  <cffunction name="Init" access="public" returnType="any" output="false" hint="I build a new Event.">
		<cfargument name="message" />
    <cfargument name="eventRequest" />
    <cfargument name="eventHandler" />
    <cfargument name="framework" />
    <cfargument name="beanMaker" />

    <cfset variables._eventRequest = arguments.eventRequest />
    <!--- <cfset variables._event = arguments.eventHandler /> --->
    <cfset variables._possibleResults = arguments.eventHandler.getResultMappings() />
    <cfset variables._state = arguments.eventRequest.getStateContainer() />
    <cfset variables._arguments = arguments.message.getArguments() />
    <cfset variables._results = arrayNew(1) />
    <cfset variables._beanMaker = arguments.beanMaker />
		<cfset variables._message = arguments.message />
		<cfset variables._framework = arguments.framework />

    <cfreturn this />
  </cffunction>

  <cffunction name="GetModelglue" returntype="ModelGlue.unity.framework.ModelGlue" access="public" output="false">
  	<cfreturn variables._framework />
  </cffunction>

  <cffunction name="GetMessage" access="public" output="false">
  	<cfreturn variables._message />
  </cffunction>

  <cffunction name="GetEventRequest" access="public" output="false">
		<cfreturn variables._eventRequest />
  </cffunction>

  <cffunction name="AddResult" access="public" returnType="void" output="false" hint="I add a result to the event.">
    <cfargument name="name" type="string" required="true" hint="Name of the result to add.">

		<cfset var mappings = "" />
		<cfset var i = "" />

		<cfif structKeyExists(variables._possibleResults, arguments.name)>
			<cfset mappings = variables._possibleResults[arguments.name] />
			<cfloop from="1" to="#arrayLen(mappings)#" index="i">
				<cfif mappings[i].redirect>
					<cfset ForwardResult(mappings[i].event, mappings[i].append, mappings[i].anchor, mappings[i].preserveState) />
				</cfif>
			</cfloop>
		  <cfset arrayAppend(variables._results, arguments.name) />
		</cfif>
  </cffunction>

  <cffunction name="GetResults" access="public" returnType="array" output="false" hint="I return the events requested for addition to the queue.">
    <cfreturn variables._results />
  </cffunction>

  <cffunction name="SetValue" access="public" returnType="void" output="false" hint="I set a value in the view state.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
    <cfargument name="value" type="any" required="true" hint="I am the value.">
    <cfset variables._state.setValue(argumentCollection=arguments) />
  </cffunction>
<!---
  <cffunction name="GetValue" access="public" returnType="any" output="false" hint="I get a value from view state.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value." />
    <cfargument name="default" required="false" />
	<cfset var retVal = "">
	<cfinvoke component="#variables._state#" method="getValue" returnvariable="retVal">
		<cfinvokeargument name="name" value="#arguments.name#" />
		<cfif structKeyExists(arguments,"default")>
			<cfinvokeargument name="default" value="#arguments.default#" />
		</cfif>
	</cfinvoke>
    <cfreturn retVal />
  </cffunction>
 --->

  <cffunction name="GetValue" access="public" returnType="any" output="false" hint="I get a value from view state.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value." />
    <cfargument name="default" required="false" />
    <cfreturn variables._state.getValue(argumentCollection=arguments) />
  </cffunction>

  <cffunction name="GetAllValues" access="public" returnType="struct" output="false" hint="I return the entire view's current state.">
    <cfreturn variables._state.getAll() />
  </cffunction>

  <cffunction name="ValueExists" access="public" returnType="boolean" output="false" hint="I state if a value exists in the view's current state.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
    <cfreturn variables._state.exists(arguments.name) />
  </cffunction>

  <cffunction name="RemoveValue" access="public" returnType="void" output="false" hint="I remove a value from the view's state.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value to remove.">
    <cfset variables._state.removeValue(arguments.name) />
  </cffunction>

  <cffunction name="setArgument" access="public" returnType="void" output="false" hint="I get a value from the message's arguments (ARGUMENT tag inside a MESSAGE tag).">
    <cfargument name="name" type="string" required="true" hint="I am the name of the argument to get.">
    <cfargument name="value" type="string" required="true" />
    
    <cfif not structKeyExists(variables._arguments, arguments.name) and structKeyExists(arguments, "defaultValue")>
    	<cfthrow message="Nonexistent arguments can't be modified!" />
    </cfif>

    <cfset variables._arguments[arguments.name] = arguments.value />
  </cffunction>
	
  <cffunction name="GetArgument" access="public" returnType="string" output="false" hint="I get a value from the message's arguments (ARGUMENT tag inside a MESSAGE tag).">
    <cfargument name="name" type="string" required="true" hint="I am the name of the argument to get.">
    <cfargument name="defaultValue" type="string" required="false" />

    <cfif not structKeyExists(variables._arguments, arguments.name) and structKeyExists(arguments, "defaultValue")>
    	<cfreturn arguments.defaultValue />
    <cfelseif not structKeyExists(variables._arguments, arguments.name)>
    	<cfreturn "" />
    </cfif>

    <cfreturn variables._arguments[arguments.name] />
  </cffunction>

  <cffunction name="GetAllArguments" access="public" returnType="struct" output="false" hint="I get all of the arguments for the message (by value).">
    <cfreturn duplicate(variables._arguments) />
  </cffunction>

  <cffunction name="ArgumentExists" access="public" returnType="boolean" output="false" hint="I state if a given argument exists.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the argument.">
    <cfreturn structKeyExists(variables._arguments, arguments.name) />
  </cffunction>

  <cffunction name="Trace" access="public" returnType="Void" output="false" hint="I add a message to the trace log.">
    <cfargument name="name" type="string" required="true" />
    <cfargument name="value" type="any" required="true" />
    <cfargument name="tag" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="USER" />
		<cfset var message = "" />

		<cfif isSimpleValue(arguments.value)>
			<cfset message = arguments.value>
		<cfelse>
			<cfsavecontent variable="message"><cfdump var="#arguments.value#"></cfsavecontent>
		</cfif>

		<cfset variables._eventRequest.trace(arguments.name, message, arguments.tag, arguments.type) />
  </cffunction>

  <cffunction name="GetTrace" access="private" returnType="array" output="false" hint="I return the tracelog.">
    <cfreturn variables._eventRequest.getTrace() />
  </cffunction>

	<cffunction name="MakeEventBean" access="public" returnType="any" output="false" hint="I make a CFC and populate it (via like-named ""setters"") from the event values">
		<cfargument name="type" type="any" required="true" hint="I am the CFC type to create or an instance of a CFC to populate." />
		<cfargument name="fields" type="string" required="false" hint="I am the [optional] list of fields to populate." />

		<cfif structKeyExists(arguments, "fields")>
			<cfreturn variables._beanMaker.MakeBean(variables._state, arguments.type, arguments.fields) />
		<cfelse>
			<cfreturn variables._beanMaker.MakeBean(variables._state, arguments.type) />
		</cfif>
	</cffunction>

	<!--- REQUEST FORWARDING --->
	<cffunction name="Forward" access="public" output="false" hint="I forward the request to a new event handler using a CFLocation, maintaining all state.">
		<cfargument name="event" type="string" required="true" hint="The event to forward to.">
		<cfargument name="append" type="string" required="false" hint="A list of state values to append to the URL.">
		<cfargument name="stateful" type="boolean" required="false" default="true" hint="A list of state values to append to the URL.">
		<cfargument name="anchor" type="string" required="false" hint="An anchor to append to the URL." default="">

		<cfparam name="arguments.append" default="" />
		<cfparam name="arguments.stateful" default="true" />
		<cfparam name="arguments.anchor" default="" />

		<cfset ForwardResult(arguments.event, arguments.append, arguments.anchor, arguments.stateful) />
	</cffunction>

	<cffunction name="ForwardResult" access="private" output="false" hint="I relocate the user to another event after storing a state container in session, to be picked up later.">
		<cfargument name="event" type="string" required="true" hint="The event to forward to.">
		<cfargument name="append" type="string" required="true" hint="A list of state values to append to the URL.">
		<cfargument name="anchor" type="string" required="false" defailt="" hint="An anchor to target in the target event">
		<cfargument name="stateful" type="boolean" required="false" default="true" hint="Whether or not to maintain the state container across the redirect." />
		<cfargument name="stateContainer" default="#variables._eventRequest.getStateContainer()#" type="ModelGlue.Util.GenericCollection" required="true" hint="An existing state container to store in session.">

		<cfset var appendedState = "" />
		<cfset var i = "" />
		<cfset var useSession = getModelGlue().getUseSession() />

		<cfif Len(arguments.anchor)>
			<cfset arguments.anchor = "###arguments.anchor#" />
		</cfif>

		<cfif not stateContainer.exists("myself")>
			<cfthrow message="Model-Glue:  I can't forward the event request because you've removed the ""myself"" variable from the event's state." />
		</cfif>

		<cfif arguments.stateful and useSession>
			<cfset session._ModelGlue.forwardedStateContainer = arguments.stateContainer />
		</cfif>

		<cfif useSession>
			<cfset session._ModelGlue.forwardedRequestLog = variables._eventRequest.getLog() />
		</cfif>

		<cfloop list="#arguments.append#" index="i">
			<cfif arguments.stateContainer.exists(i) and isSimpleValue(arguments.stateContainer.getValue(i))>
				<cfset appendedState = appendedState & "&" & i & "=" & arguments.stateContainer.getValue(i) />
			</cfif>
		</cfloop>

		<cfset variables._eventRequest.trace("Forward", "The request is being forwarded/redirected to the ""#arguments.event#"" event-handler.") />

		<cflocation url="#stateContainer.getValue("myself")##arguments.event##appendedState##anchor#" addToken="false" />
	</cffunction>

	<!--- UTILITY --->
	<cffunction name="GetEventHandlerName" access="public" output="false" hint="Returns the current event handler name.">
		<cfreturn getEventRequest().getCurrentEventHandler().getName() />
	</cffunction>

	<!--- VIEWS --->
	<cffunction name="GetView" access="public" output="false" hint="I return the HTML of any already rendered view by name.  If the view doesn't exist, I return an empty string.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the view to get.">
    <cfreturn getEventRequest().getRenderedView(arguments.name) />
	</cffunction>
</cfcomponent>