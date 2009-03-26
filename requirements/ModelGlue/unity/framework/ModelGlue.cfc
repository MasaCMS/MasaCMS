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


<cfcomponent displayname="ModelGlue" output="false" hint="I am the Model-Glue framework." extends="ModelGlue.ModelGlue">

<cfset variables._beanFactory = structNew() />
<cfset variables._stateBuilder = structNew() />
<cfset variables._iocAdapter = "" />
<cfset variables._beanMaker = "" />
<cfset variables._applicationKey = "" />
<cfset variables._useSession = true />
<cfset variables._useORMAdapter = structNew() />
<cfset variables._useORMAdapter.status = false />
<cfset variables._useORMAdapter.detail = "No ORM adapter has been loaded." />
<cfset variables._ORMAdapterName = "" />
<cfset variables._viewRenderer = createObject("component", "ModelGlue.unity.view.ViewRenderer").init() />
<cfset variables._listeners = createObject("component", "ModelGlue.unity.listener.ListenerRegistry").init() />
<cfset variables._eventHandlers = createObject("component", "ModelGlue.unity.eventhandler.EventHandlerRegistry").init() />
<cfset variables._messageBroadcaster = createObject("component", "ModelGlue.unity.eventrequest.MessageBroadcaster").init(variables._listeners) />
<cfset variables._fakeMessage = createObject("component", "ModelGlue.unity.eventhandler.Message").init() />

<cffunction name="init" returntype="ModelGlue.unity.framework.ModelGlue" access="public" hint="Constructor" output="false">
	<cfargument name="version" type="string" required="false" />
	
	<cfif structKeyExists(arguments, "version")>
		<cfset variables._version = arguments.version />
	</cfif>
	
	<cfset variables._listeners.init() />
	<cfset variables._eventHandlers.init() />
	<cfset variables._messageBroadcaster.init(variables._listeners) />
	
	<cfreturn this />
</cffunction>


<cffunction name="getVersion" returntype="string" output="false">
	<cfreturn variables._version />
</cffunction>

<cffunction name="setConfiguration" returntype="void" output="false" access="public">
	<cfargument name="modelGlueConfiguration" type="ModelGlue.unity.framework.ModelGlueConfiguration" required="true" />
	<cfset variables._config = arguments.modelGlueConfiguration.getInstance() />
</cffunction>

<cffunction name="setApplicationKey" returntype="void" output="false" access="public">
	<cfargument name="ApplicationKey" type="string" required="true" />
	<cfset variables._applicationKey = arguments.applicationKey />
</cffunction>
<cffunction name="getApplicationKey" returntype="string" output="false">
	<cfreturn variables._applicationKey />
</cffunction>

<cffunction name="setUseSession" returntype="void" output="false" access="public">
	<cfargument name="UseSession" type="boolean" required="true" />
	<cfset variables._useSession = arguments.UseSession />
</cffunction>
<cffunction name="getUseSession" returntype="boolean" output="false">
	<cfreturn variables._useSession />
</cffunction>

<cffunction name="setUseORMAdapter" returntype="void" output="false" access="public">
	<cfargument name="UseORMAdapter" type="boolean" required="true" />
	<cfargument name="Message" type="string" required="true" />
	<cfset variables._useORMAdapter.status = arguments.UseORMAdapter />
	<cfset variables._useORMAdapter.detail = arguments.message />
</cffunction>
<cffunction name="getUseORMAdapter" returntype="struct" output="false">
	<cfreturn variables._useORMAdapter />
</cffunction>

<cffunction name="setORMAdapterName" returntype="void" output="false" access="public">
	<cfargument name="ORMAdapterName" type="string" required="true" />
	<cfset variables._ORMAdapterNAme = arguments.ORMAdapterName />
</cffunction>
<cffunction name="getORMAdapterName" returntype="string" output="false">
	<cfreturn variables._ORMAdapterNAme />
</cffunction>

<cffunction name="setBeanFactory" returntype="void" access="public" hint="I set the bean factory for Model-Glue to use." output="false">
	<cfargument name="beanFactory" type="any" required="true" />
	<cfset variables._beanFactory = arguments.beanFactory />
</cffunction>
<cffunction name="getBeanFactory" returntype="any" access="public" hint="I get the bean factory for Model-Glue to use." output="false">
	<cfreturn variables._beanFactory />
</cffunction>

<cffunction name="getNativeBean" returntype="any" access="public" hint="I get a ColdSpring bean from the internal configuration store." output="false">
	<cfargument name="name" type="string" required="true" />
	
	<cfreturn variables._beanFactory.getBean(arguments.name) />
</cffunction>

<cffunction name="setIocContainer" returntype="void" access="public" hint="I set the bean factory for Model-Glue to use." output="false">
	<cfargument name="IocContainer" type="ModelGlue.unity.ioc.AbstractIOCAdapter" required="true" />
	<cfset variables._IocContainer = arguments.IocContainer />
	<cfset variables._IocContainer.setFramework(this) />
</cffunction>
<cffunction name="getIocContainer" returntype="any" access="public" hint="I get the bean factory for Model-Glue to use." output="false">
	<cfreturn variables._IocContainer />
</cffunction>

<cffunction name="getConfigBean" returntype="any" access="public" hint="I am the (deprecated) way to get a config'd bean." output="false">
	<cfargument name="name" type="string" required="true" />
	<cfreturn getBean(arguments.name) />
</cffunction>
<cffunction name="getBean" returntype="any" access="public" hint="I am the way to get a config'd bean." output="false">
	<cfargument name="name" type="string" required="true" />
	<cfreturn variables._iocContainer.getBean(arguments.name) />
</cffunction>

<cffunction name="setBeanMaker" returntype="void" output="false" access="public">
	<cfargument name="BeanMaker" type="any" required="true" />
	<cfset variables._beanMaker = arguments.BeanMaker />
</cffunction>


<cffunction name="setStateBuilder" returntype="void" access="public" hint="I set the bean state builder for Model-Glue to use." output="false">
	<cfargument name="stateBuilder" type="any" required="true" />
	<cfset variables._stateBuilder = arguments.stateBuilder />
	<cfset variables._stateBuilder.setFramework(this) />
</cffunction>
<cffunction name="getStateBuilder" returntype="ModelGlue.unity.statebuilder.StateBuilder" access="private" hint="I get the state builderfor Model-Glue to use." output="false">
	<cfreturn variables._stateBuilder />
</cffunction>
<!---
<cffunction name="setOrmAdapter" returntype="any" access="public" hint="I set the ORM Adapter." output="false">
	<cfargument name="ormAdapter" type="any" required="true" />
	<cfset variables._ormAdapter = arguments.ormAdapter />
</cffunction>
--->
<cffunction name="getOrmAdapter" returntype="any" access="public" hint="I return the ORM Adapter (abstracts multiple ORM implementations)." output="false">
	<cfreturn getNativeBean("ORMAdapter") />
</cffunction>

<!---
<cffunction name="setOrmService" returntype="any" access="public" hint="I set the ORM service." output="false">
	<cfargument name="ormService" type="any" required="true" />
	<cfset variables._ormService = arguments.ormService />
</cffunction>
--->
<cffunction name="getOrmService" returntype="any" access="public" hint="I return the ORM service (the concrete ORM implemenation used)." output="false">
	<cfreturn getNativeBean("ORMService") />
</cffunction>

<cffunction name="getConfigSetting" returntype="any" access="public" hint="I return a configuration setting." output="false">
	<cfargument name="name" type="string" required="true" />
	
	<!--- In MG 1.1, there were a few screwy names that we have to carry forward.... --->
	<cfif arguments.name eq "self">
		<cfset arguments.name = "defaultTemplate" />
	</cfif>
	
	<cfif not structKeyExists(variables._config, arguments.name)>
		<cfthrow message="Model-Glue:  Config setting ""#arguments.name#"" is not defined." />
	</cfif>
	
	<cfreturn variables._config[arguments.name] />
</cffunction>

<cffunction name="setConfigSetting" returntype="void" access="public" hint="I set a configuration setting." output="false">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="value" type="string" required="true" />
	<cfset variables._config[arguments.name] = arguments.value />
</cffunction>

<cffunction name="getFakeMessage" output="false" access="private">
	<cfreturn variables._fakeMessage />
</cffunction>

<cffunction name="createStateContainer" returntype="any" access="public" hint="I build and return the state collection." output="false">
	<cfreturn getStateBuilder().createStateContainer() />
</cffunction>

<!--- Listener management --->
<cffunction name="addListener" returntype="void" access="public" hint="I register a given Controller instance's method to listen for a given message." output="false">
	<cfargument name="message" type="string" required="true" />
	<cfargument name="target" type="any" required="true" />
	<cfargument name="method" type="string" required="true" />
	<cfargument name="async" type="boolean" required="true" />
	<cfset variables._listeners.addListener(arguments.message, arguments.target, arguments.method, arguments.async) />
</cffunction>

<!--- Asynchronous Support --->
<cffunction name="AddAsyncListener" returnType="void" output="false" access="public" hint="I configure session-level async request management for a given listener.">
	<cfargument name="message" type="string" required="true">

	<cfset session._modelGlue.asyncRequests[arguments.message] = createObject("component", "ModelGlue.unity.async.AsyncRequestCollection").init() />
</cffunction>

<cffunction name="AddAsyncRequest" returnType="void" output="false" access="public" hint="I configure session-level async request management for a given listener.">
	<cfargument name="message" type="string" required="true">
	<cfargument name="request" type="ModelGlue.unity.async.AsyncRequest" required="true">

	<cfset session._modelGlue.asyncRequests[arguments.message].add(arguments.request) />
</cffunction>

<cffunction name="GetAsyncRequests" returnType="ModelGlue.unity.async.AsyncRequestCollection" output="false" access="public" hint="I return async requests by message name for the current session.">
	<cfargument name="message" type="string" required="true" />
	<cfreturn session._modelGlue.asyncRequests[arguments.message] />
</cffunction>
	
<!--- Event-handler management --->
<cffunction name="addEventHandler" access="public" hint="I register a given event-handler." output="false">
	<cfargument name="eventHandler" type="ModelGlue.unity.eventhandler.EventHandler" required="true" />
	<cfset variables._eventhandlers.addEventHandler(arguments.eventHandler.getName(), arguments.eventHandler) />
</cffunction>
<cffunction name="getEventHandler" access="public" hint="I get a given event-handler." output="false">
	<cfargument name="name" />
	<cfreturn variables._eventhandlers.getEventHandler(arguments.name) />
</cffunction>
<cffunction name="eventHandlerExists" returntype="boolean" access="public" hint="Does a given event-handler exist?" output="false">
	<cfargument name="name" />
	<cfreturn  variables._eventhandlers.exists(arguments.name) />
</cffunction>

<!--- Event Handling --->
<cffunction name="CreateEventRequest" output="false" access="public" returntype="any">
	<cfreturn createObject("component", "ModelGlue.unity.eventrequest.EventRequest").init(getStateBuilder()) />
</cffunction>

<cffunction name="CreateRequestLog" output="false" access="public" returntype="any">
	<cfreturn createObject("component", "ModelGlue.unity.eventrequest.RequestLog").init() />
</cffunction>

<cffunction name="ReleaseEventRequest" output="false" access="public" returntype="void">
	<cfargument name="eventRequest" />

</cffunction>

<!---
<cffunction name="HandleEvent" output="false" access="public" returntype="ModelGlue.unity.eventrequest.EventRequest">
	<cfargument name="eventRequest" type="ModelGlue.unity.eventrequest.EventRequest" />
	<cfset var state = arguments.eventRequest.getStateContainer() />
	<cfset var eventHandler = getEventHandler(state.getValue(getConfigSetting("eventValue"))) />
	<cfset arguments.eventRequest.addEventHandler(eventHandler) />

	<cfreturn handleEventRequest(arguments.eventRequest) />	
	<cfreturn arguments.eventRequest />
</cffunction>
--->

<cffunction name="HandleEventRequest" output="false" access="public" hint="I handle an EventRequest.">
  <cfargument name="eventRequest" />

	<cfset var state = arguments.eventRequest.getStateContainer() />
  <cfset var exceptionRequest = "" />
  <cfset var stateContainer = "" />	
	<cfset var eventHandler = "" />
	
	<!--- It's a zen thing (actually, it's needed for exception handling - the pointer may change). --->
  <cfset var result = arguments.eventRequest />

	<cftry>
		<!--- Get the initial EventHandler to run --->
		<cfset eventHandler = getEventHandler(state.getValue(getConfigSetting("eventValue"))) />
		
		<cfif eventHandler.getAccess() eq "private">
			<cfthrow type="ModelGlue.EventHandler.Private"
							 message="#state.getValue(getConfigSetting("eventValue"))# is a private &lt;event-handler&gt;.">
		</cfif>
		
		<!---
		<cfset arguments.eventRequest.addEventHandler(eventHandler) />
		--->
		
 		<cfset result = runEventRequest(arguments.eventRequest, eventHandler) />
	  <cfcatch>
	    <cfif not len(getConfigSetting("defaultExceptionHandler"))>
	      <cfrethrow />
	    <cfelse>
	      <cfset stateContainer = arguments.eventRequest.getStateContainer() />
	      <cfset stateContainer.setValue("exception", cfcatch) />
	      <cfset exceptionRequest = createObject("component", "ModelGlue.unity.eventrequest.EventRequest").init(getStateBuilder(), stateContainer, arguments.eventRequest.getLog()) />
	      <cfset exceptionRequest.addEventHandler(getEventHandler(getConfigSetting("defaultExceptionHandler"))) />
				<cfset arguments.eventRequest.trace("<font color=""red""><strong>Exception</strong></font>", "An exception has been thrown and is being handled by the default exception handler.") />
	      <cfset result = runEventRequest(exceptionRequest) />
	    </cfif>
	  </cfcatch>
  </cftry>
  
  <cfreturn result />
</cffunction>

<cffunction name="RunEventRequest" output="false" access="private" hint="I handle an event by name.">
  <cfargument name="eventRequest" />
  <cfargument name="initialEventHandler" />

	<!--- 
		If we're running a normal event (not exception), tell the request to report the primary
		event handler name instead of the internal "ModelGlue." event handler names.
	--->
	<cfif structKeyExists(arguments, "initialEventHandler")>
		<cfset arguments.eventRequest.setInitialEventHandler(arguments.initialEventHandler) />
	</cfif>	 

	<!--- "OnRequestStart" event --->
	<cfset RunEventHandler(getEventHandler("ModelGlue.OnRequestStart"), arguments.eventRequest) />
	
	<!--- Run any events requested by OnRequestStart results --->
	<cfset RunEventHandlerQueue(arguments.eventRequest) />

	<!--- Add the initial event-handler --->
	<cfif structKeyExists(arguments, "initialEventHandler")>
		<cfset arguments.eventRequest.addEventHandler(arguments.initialEventHandler) />
	</cfif>
	
  <!--- Run the event queue --->
	<cfset RunEventHandlerQueue(arguments.eventRequest) />
		
	<!--- "OnQueueComplete" event --->
	<cfset RunEventHandler(getEventHandler("ModelGlue.OnQueueComplete"), arguments.eventRequest) />

	<!--- Run any events requested by OnQueueComplete results --->
	<cfset RunEventHandlerQueue(arguments.eventRequest) />

	<!--- Render the view queue --->
	<cfset RenderViewQueue(arguments.eventRequest) />
	
	<!--- "OnRequestEnd" event --->
	<cfset RunEventHandler(getEventHandler("ModelGlue.OnRequestEnd"), arguments.eventRequest) />
	
	<!--- Run any events requested by OnRequestEnd results --->
	<cfset RunEventHandlerQueue(arguments.eventRequest) />

	<!--- Render the view queue --->
	<cfset RenderViewQueue(arguments.eventRequest) />

  <!--- Return the eventRequest --->
  <cfreturn arguments.eventRequest />
</cffunction>

<cffunction name="RunEventHandlerQueue" returntype="void" access="private" output="false">
	<cfargument name="eventRequest" />
	
  <!--- Run the event queue --->
  <cfloop condition="not #arguments.eventRequest.eventHandlerQueueIsEmpty()#">
    <cfset RunEventHandler(arguments.eventRequest.getNextEventHandler(), arguments.eventRequest) />
  </cfloop>
</cffunction>

<cffunction name="RunEventHandler" returntype="void" access="private" output="false">
	<cfargument name="eventHandler" />
	<cfargument name="eventRequest" />

	<cfset var messageNames = arguments.eventHandler.getMessages() />
	<cfset var messages = "" />
	<cfset var views = arguments.eventHandler.getViews() />
	<cfset var resultMappings = arguments.eventHandler.getResultMappings() />
	<cfset var eventContext = "" />
	<cfset var eventName = eventHandler.getName() />
	<cfset var eventResults = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var k = "" />
	<cfset var l = "" />
	
  <cfset arguments.eventRequest.trace("Event Handler", "Running Event Handler: ""#arguments.eventHandler.getName()#""", "&lt;event-handler name=""#arguments.eventHandler.getName()#""&gt;") />
	<!--- Broadcast messages --->	
	<cfloop from="1" to="#arrayLen(messageNames)#" index="i">
		<cfset messages = arguments.eventHandler.getMessage(messageNames[i]) />
		<cfloop from="1" to="#arrayLen(messages)#" index="j">
	    <cfset arguments.eventRequest.trace("Message Broadcast", "Broadcasting message: #messages[j].getName()#", "&lt;message name=""#messages[j].getName()#"" /&gt;") />
			<cfset eventContext = arguments.eventRequest.createEventContext(messages[j], arguments.eventHandler, this, variables._beanMaker) />
			<cfset variables._messageBroadcaster.broadcast(eventContext) />
			<cfset eventResults = eventContext.getResults() />
	    <cfloop from="1" to="#arrayLen(eventResults)#" index="k">
	      <cfif structKeyExists(resultMappings, eventResults[k])>
	        <cfset mapping = resultMappings[eventResults[k]]>
	        <cfloop from="1" to="#arrayLen(mapping)#" index="l">
	 	        <cfset arguments.eventRequest.addEventHandler(getEventHandler(mapping[l].event)) />
	   	      <cfset arguments.eventRequest.trace("Result", "Event ""#eventName#""'s result of ""#eventResults[k]#"" has queued the ""#mapping[l].event#"" event-handler", "&lt;result name=""#eventResults[k]#"" do=""#mapping[l].event#"" /&gt;") />
	 	      </cfloop>
	 	    <cfelse>
	 	      <cfthrow message="Model-Glue: Result has no mapping" detail="The result ""#eventResults[k]#"" from the event ""#eventName#"" has no matching &lt;result&gt; tag." />
	 	    </cfif>
	    </cfloop>
		</cfloop>
	</cfloop>
	
	<!--- If we have no messages, we need to create a "fake" event context for implicit results to use --->
	<cfif not arrayLen(messageNames)>
		<cfset eventContext = arguments.eventRequest.createEventContext(getFakeMessage(), arguments.eventHandler, this, variables._beanMaker) />
	</cfif>	
	
  <!--- Add any implicit results to the queue --->
  <cfif structCount(resultMappings) and structKeyExists(resultMappings, "")>
    <cfset mapping = resultMappings[""]>
    <cfloop from="1" to="#arrayLen(mapping)#" index="j">
		<cfif not mapping[j].redirect>
       <cfset arguments.eventRequest.addEventHandler(getEventHandler(mapping[j].event)) />
	     <cfset arguments.eventRequest.trace("Result", "Event ""#eventName#"" has queued the ""#mapping[j].event#"" event-handler", "&lt;result do=""#mapping[j].event#"" /&gt;") />
	    <cfelse>
	    	<cfset eventContext.forward(mapping[j].event, mapping[j].append) />
	    </cfif>
    </cfloop>
  </cfif>
	
  <!--- Queue views --->
  <cfloop to="1" from="#arrayLen(views)#" index="i" step="-1">
    <cfset arguments.eventRequest.trace("View Include", "Adding view ""#views[i].getName()#"" to the view queue.", "&lt;include name=""#views[i].getName()#"" template=""#views[i].getTemplate()#"" /&gt;") />
    <cfset arguments.eventRequest.addView(views[i]) />
  </cfloop>

   <!--- Render the view queue 
  <cfset RenderViewQueue(arguments.eventRequest) />
	--->
</cffunction>

<!--- VIEW RENDERING --->
<cffunction name="RenderViewQueue" returnType="void" output="false" access="private" hint="I render the view queue.">
  <cfargument name="eventRequest" default="#createObject("component", "ModelGlue.Util.GenericStack").init()#" hint="I am the event request this rendering belongs to." />

  <cfset var thisView = "" />
  <cfset var i = "" />
  <cfset var viewMappings = listAppend(getConfigSetting("viewMappings"), getConfigSetting("generatedViewMapping")) />
  <cfset var viewCollection = arguments.eventRequest.getViewCollection() />
  <cfset var viewRenderer = variables._viewRenderer />
  <cfset var templateExists = false />
  <cfset var content = "" />

  <cfloop condition="not #eventRequest.viewQueueIsEmpty()#">
    <cfset thisView = arguments.eventRequest.getNextView() />
    <cfset templateExists = false />
    <cfloop list="#viewMappings#" index="i">
      <cfif fileExists(expandPath(i) & "/" & thisView.getTemplate())>
        <cfset arguments.eventRequest.trace("View Queue", "Rendering view ""#thisView.getName()#"" (#i & "/" & thisView.getTemplate()#)", "&lt;include name=""#thisView.getName()#"" template=""#thisView.getTemplate()#"" /&gt;") />
        <cfset content = viewRenderer.renderView(arguments.eventRequest.getStateContainer(), viewCollection, i & "/" & thisView.getTemplate(), thisView.getValues()) />
        <cfset viewCollection.addRenderedView(thisView.getName(), content, thisView.getAppend()) />
        <cfset templateExists = true />
        <cfbreak />
      </cfif>
    </cfloop>
    <cfif not templateExists>
     <cfthrow message="Model-Glue:  &lt;include&gt; Template not found!" detail="None of the directories listed in your viewMappings setting contain a file named ""#thisView.getTemplate()#""" />
    </cfif>
  </cfloop>
</cffunction>

</cfcomponent>