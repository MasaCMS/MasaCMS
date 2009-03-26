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


<cfcomponent displayname="XmlConfigurationLoader" output="true">

<!--- _controllers does nothing but prevent duplicate-named controllers. --->
<cfset variables._controllers = structNew() />

<cffunction name="init" returntype="ModelGlue.unity.loader.XmlConfigurationLoader" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setBeanFactory" returntype="void" access="public" output="false">
	<cfargument name="beanFactory" type="any" required="true" />
	<cfset variables._beanFactory = arguments.beanFactory />
</cffunction>
<cffunction name="getBeanFactory" returntype="any" access="private" output="false">
	<cfreturn variables._beanFactory />
</cffunction>

<cffunction name="setLoadingOptions" returntype="void" access="public" output="false">
	<cfargument name="loadingOptions" type="any" required="true" />
	<cfset variables._loadingOptions = arguments.loadingOptions />
</cffunction>
<cffunction name="getLoadingOptions" returntype="any" access="private" output="false">
	<cfreturn variables._loadingOptions />
</cffunction>

<cffunction name="getBean" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfreturn variables._beanFactory.getBean(arguments.name) />
</cffunction>

<cffunction name="load" returntype="ModelGlue.unity.framework.ModelGlue" output="true" access="public">
	<cfargument name="mg" type="ModelGlue.unity.framework.ModelGlue" hint="The ModelGlue instance to load events into." />
	<cfargument name="configurationPath" type="string" hint="The configuration file to use." />
	<cfargument name="scaffoldPath" type="string" hint="The file to compile scaffolds to." />
	<cfargument name="include" type="boolean" default="false" hint="Is this an included config file?" />
	<cfargument name="compilationQueue" type="ModelGlue.Util.GenericStack" default="#createObject("component", "ModelGlue.Util.GenericStack").init()#" hint="A queue of EventHandler instances to compile to XML." />
	
	<cfset var cfg = "" />
	<cfset var i = "" />
	<cfset var includePath = "" />
	
	<cfif not arguments.include>
		<cfset addStaticMessages(arguments.mg) />
	</cfif>
	
	<cffile action="read" file="#configurationPath#" variable="cfg" />

	<cftry>
		<cfset cfg = xmlParse(cfg).xmlRoot />
		<cfcatch>
			<cfthrow message="Model-Glue: #configurationPath# isn't valid XML!" />
		</cfcatch>
	</cftry>

	<cfloop from="1" to="#arrayLen(cfg.xmlChildren)#" index="i">
		<cfswitch expression="#cfg.xmlChildren[i].xmlName#">
			<cfcase value="controllers">
				<cfset loadControllers(arguments.mg, cfg.xmlChildren[i]) />
			</cfcase>
			<cfcase value="event-handlers">
				<cfset loadEventHandlers(arguments.mg, cfg.xmlChildren[i], arguments.compilationQueue) />
			</cfcase>
			<cfcase value="config">
				<cfset loadConfiguration(arguments.mg, cfg.xmlChildren[1], arguments.include) />
			</cfcase>
			<cfcase value="include">
				<cfif not structKeyExists(cfg.xmlChildren[i].xmlAttributes, "template")>
					<cfthrow message="Model-Glue: The <include> tag requires a TEMPLATE attribute." />
				</cfif>
				<cfset includePath = expandPath(cfg.xmlChildren[i].xmlAttributes.template) />
				<cfif not fileExists(includePath)>
					<cfthrow message="Model-Glue: The xml file you're trying to include, #includePath#, cannot be found." />
				</cfif>
				<cfset load(arguments.mg, includePath, arguments.scaffoldPath, true, arguments.compilationQueue) />
			</cfcase>
		</cfswitch>		
	</cfloop>

	<cfif not arguments.include>
		<cfif getLoadingOptions().getRescaffold() or not fileExists(arguments.scaffoldPath)>
			<cfset compileEventHandlers(arguments.compilationQueue, arguments.scaffoldPath) />
		<cfelse>
			<cfset load(arguments.mg, arguments.scaffoldPath, arguments.scaffoldPath, true, arguments.compilationQueue) />
		</cfif>
	</cfif>

	<cfreturn arguments.mg />
</cffunction>

<cffunction name="addStaticMessages" returntype="void" access="private" hint="I set up the static messages.">
	<cfargument name="mg" type="ModelGlue.unity.framework.ModelGlue" hint="The ModelGlue instance to load events into." />

	<cfset var onRequestStart = createObject("component", "ModelGlue.unity.eventhandler.EventHandler").init() />
	<cfset var onQueueComplete = createObject("component", "ModelGlue.unity.eventhandler.EventHandler").init() />
	<cfset var onRequestEnd = createObject("component", "ModelGlue.unity.eventhandler.EventHandler").init() />
	<cfset var msg = "" />

	<cfset onRequestStart.setName("ModelGlue.onRequestStart") />
	<cfset msg = createObject("component", "ModelGlue.unity.eventhandler.Message").init() />
	<cfset msg.setName("onRequestStart") />
	<cfset onRequestStart.addMessage(msg) />
	<cfset onRequestStart.setExtensible(true) />
	<cfset arguments.mg.addEventHandler(onRequestStart) />
	
	<cfset onQueueComplete.setName("ModelGlue.onQueueComplete") />
	<cfset msg = createObject("component", "ModelGlue.unity.eventhandler.Message").init() />
	<cfset msg.setName("onQueueComplete") />
	<cfset onQueueComplete.addMessage(msg) />
	<cfset arguments.mg.addEventHandler(onQueueComplete) />
	
	<cfset onRequestEnd.setName("ModelGlue.onRequestEnd") />
	<cfset msg = createObject("component", "ModelGlue.unity.eventhandler.Message").init() />
	<cfset msg.setName("onRequestEnd") />
	<cfset onRequestEnd.addMessage(msg) />
	<cfset arguments.mg.addEventHandler(onRequestEnd) />
</cffunction>

<!--- 
	loadConfiguration() exists for 1.x reverse compatibility 
	and for <include>-based configuration extension.
	
	Therefore, it contains some hard-coding for settings
	(such as IOC container settings) to mimic the default
	settings of the 1.x codebase.

--->
<cffunction name="loadConfiguration" returntype="void" access="private" output="false">
	<cfargument name="mg" required="true">
	<cfargument name="config" required="true">
	<cfargument name="include" required="true">

	<cfset var i = "" />
	<cfset var ioc = "" />
	<cfset var beanMappings = "" />
	
	<!--- Defaults from the MG 1.x codebase --->
	<!--- My dog is snoring very loudly. --->
	<cfif not arguments.include>
		<cfset arguments.mg.setConfigSetting("beanFactoryLoader", "ModelGlue.Core.ChiliBeansLoader") />
		<cfset arguments.mg.setConfigSetting("autowireControllers", "false") />
	</cfif>
		
	<cfloop from="1" to="#arrayLen(arguments.config.xmlChildren)#" index="i">
		<cfif arguments.config.xmlChildren[i].xmlName eq "setting"
					and structKeyExists(arguments.config.xmlChildren[i].xmlAttributes, "name")
					and structKeyExists(arguments.config.xmlChildren[i].xmlAttributes, "value")
		>
			<cfif arguments.config.xmlChildren[i].xmlAttributes.name eq "viewMappings">
				<cfset tmp = arguments.mg.getConfigSetting(arguments.config.xmlChildren[i].xmlAttributes.name) />
				<cfset tmp = listAppend(tmp, arguments.config.xmlChildren[i].xmlAttributes.value) />
				<cfset arguments.mg.setConfigSetting(arguments.config.xmlChildren[i].xmlAttributes.name, tmp) />
			<cfelseif arguments.config.xmlChildren[i].xmlAttributes.name eq "beanMappings">
				<cfset beanMappings = arguments.config.xmlChildren[i].xmlAttributes.value />
			<!--- 
				In the dark days of 0.4, some things got kludged.  This hard coding is the result.
			--->
			<cfelseif arguments.config.xmlChildren[i].xmlAttributes.name eq "self">
				<cfset arguments.mg.setConfigSetting("defaultTemplate", arguments.config.xmlChildren[i].xmlAttributes.value) />
			<cfelse>
				<cfset arguments.mg.setConfigSetting(arguments.config.xmlChildren[i].xmlAttributes.name, arguments.config.xmlChildren[i].xmlAttributes.value) />
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- 
		If they left it alone, and want to use ChiliBeans, we need
		to tell the framework to use CB instead of ColdSpring, and we 
		need to load their bean mappings.
	--->
	<cfif arguments.mg.getConfigSetting("beanFactoryLoader") eq "ModelGlue.Core.ChiliBeansLoader" >
		<cfset ioc = getBean("chiliBeansAdapter") />
		<cfset ioc.setBeanMappings(beanMappings) />
		<cfset arguments.mg.setIocContainer(ioc) />
	<cfelse>
		<!--- 
			If they're 1.1-errific and want to use ColdSpring, we need
			to load their beans.
		--->
		<cfif len(beanMappings)>
			<cfloop list="#beanMappings#" index="i">
				<cfset arguments.mg.getIocContainer().loadBeans(i) />
			</cfloop>
		</cfif>
	</cfif>

</cffunction>
 
<cffunction name="loadControllers" returntype="void" access="private" output="false">
	<cfargument name="mg" required="true">
	<cfargument name="controllers" required="true">
	
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var ctrl = "" />
	<cfset var lis = "" />
	<cfset var instance = "" />
	
	<cfloop from="1" to="#arrayLen(arguments.controllers.xmlChildren)#" index="i">
		<cfset ctrl = arguments.controllers.xmlChildren[i]>
		<cfif ctrl.xmlName eq "controller">
			<cfset instance = "" />
			<!--- Create controller instance --->
			<cfif structKeyExists(ctrl.xmlAttributes, "bean")>
				<cfset instance = getBean(ctrl.xmlAttributes.bean) />
				<cfset instance.setModelGlue(arguments.mg) />
				<cfset instance.setName(createUUID()) />
				<cfset autowireController(instance) />
			<cfelseif structKeyExists(ctrl.xmlAttributes, "type")>
				<cfset instance = createObject("component", ctrl.xmlAttributes.type).init(arguments.mg, ctrl.xmlAttributes.name) />
				<cfset autowireController(instance) />
			</cfif>
			
			<cfif isObject(instance)>
				<cfif structKeyExists(variables._controllers, instance.getName())>
					<cfthrow type="XmlConfigurationLoader.DuplicateControllerName"
									 message="Two controllers can't share the same name."
									 detail="A second &lt;controller&gt; tag is attempting to add a controller named ""#instance.getName()#""">
					/>
				<cfelse>
					<cfset variables._controllers[instance.getName()] = true />
				</cfif>					
									
			
				<!--- Add Listeners --->
				<cfloop from="1" to="#arrayLen(ctrl.xmlChildren)#" index="i">
					<cfset lis = ctrl.xmlChildren[i] />
					<cfparam name="lis.xmlAttributes.async" type="boolean" default="false" />
					<cfif lis.xmlName eq "message-listener">
						<cfif structKeyExists(lis.xmlAttributes, "message")
									and structKeyExists(lis.xmlAttributes, "function")>
							<cfset arguments.mg.addListener(lis.xmlAttributes.message, instance, lis.xmlAttributes.function, lis.xmlAttributes.async) />
							<cfif lis.xmlAttributes.async eq "true">
										<cfset arguments.mg.addAsyncListener(lis.xmlattributes.message) />
							</cfif>
						<cfelse>
							<cfthrow message="Model-Glue: All <message-listener> tags need ""function"" and ""message"" attributes." />
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="autowireController" returntype="void" access="private" output="false" hint="Returns a controller after autowiring its depedencies from a ColdSpring BeanFactory">
	<cfargument name="controller" required="true" type="any">
	
		<!--- 
				What follows is from Sean Corfield's AutoWire controller.  Thanks, Sean!  -jRinehart
	--->
	<cfset var ctlr = arguments.controller />
	<cfset var md = 0 />
	<cfset var nFunc = 0 />
	<cfset var funcIdx = 0 />
	<cfset var method = 0 />
	<cfset var setterName = "" />
	<cfset var setterType = "" />
	<!--- Bypass the adapter and go straight to ColdSpring (jRinehart, explaining sCorfield code) --->
	<cfset var beanFactory = getBeanFactory() />
	<cfset var beanName = "" />
	
	<!---
		Modification of Sean Corfield's original (below) autowire code that
		allows controls to use mixins by treating the controller
		as a struct instead of using its metadata.
	--->
	<cfloop collection="#ctlr#" item="nFunc">
		<cfset method = "" />
		<cfset method = getMetaData(ctlr[nFunc]) />
		<cfif isStruct(method)>
			<cfif len(method.name) gt 3 and
					left(method.name,3) is "set" and
					arrayLen(method.parameters) eq 1>
				<cfset setterName = right(method.name,len(method.name)-3) />

				<cfif not structKeyExists(method.parameters[1], "type")>
					<cfset setterType = "any" />
				<cfelse>
					<cfset setterType = method.parameters[1].type />
				</cfif>
				
				<cfif beanFactory.containsBean(setterName)>
					<cfset beanName = setterName />
				<cfelse>
					<cfset beanName = beanFactory.findBeanNameByType(setterType) />
				</cfif>
	
				<!--- if we found a bean, call the target object's setter --->
				<cfif len(beanName)>
					<cfinvoke component="#ctlr#"
							  method="set#setterName#">
						<cfinvokeargument name="#method.parameters[1].name#"
							  	value="#beanFactory.getBean(beanName)#"/>
					</cfinvoke>	
				</cfif>			  
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- 
	Sean's original:
	<cfset md = getMetadata(ctlr) />
	<cfif structKeyExists(md,"functions")>
		<cfset nFunc = arrayLen(md.functions) />
		<cfloop index="funcIdx" from="1" to="#nFunc#">
			<cfset method = md.functions[funcIdx] />
			<cfif len(method.name) gt 3 and
					left(method.name,3) is "set" and
					arrayLen(method.parameters) eq 1>
				<cfset setterName = right(method.name,len(method.name)-3) />
				<cfset setterType = method.parameters[1].type />
				
				<cfif beanFactory.containsBean(setterName)>
					<cfset beanName = setterName />
				<cfelse>
					<cfset beanName = beanFactory.findBeanNameByType(setterType) />
				</cfif>
	
				<!--- if we found a bean, call the target object's setter --->
				<cfif len(beanName)>
					<cfinvoke component="#ctlr#"
							  method="set#setterName#">
						<cfinvokeargument name="#method.parameters[1].name#"
							  	value="#beanFactory.getBean(beanName)#"/>
					</cfinvoke>	
				</cfif>			  
			</cfif>
		</cfloop>
	</cfif>
	--->
</cffunction>
  
<cffunction name="loadEventHandlers" returntype="void" access="private" output="true">
	<cfargument name="mg" required="true">
	<cfargument name="eventHandlers" required="true">
	<cfargument name="compilationQueue" required="true">
	
	<cfset var i = "" />
	<cfset var ehTag = "" />
	<cfset var eh = "" />
	<cfset var factory = getBean("eventHandlerFactory") />
	<cfset var j = "" />
	<cfset var scaffolds = arrayNew(1) />

	<cfloop from="1" to="#arrayLen(arguments.eventHandlers.xmlChildren)#" index="i">
		<cfset ehTag = arguments.eventHandlers.xmlChildren[i] />
		<cfswitch expression="#ehTag.xmlName#">
			<cfcase value="event-handler">
				<cfif arguments.mg.eventHandlerExists(ehTag.xmlAttributes.name)>
					<cfset eh = arguments.mg.getEventHandler(ehTag.xmlAttributes.name) />
					<cfif not eh.getExtensible()>
						<cfset eh = factory.create("EventHandler") />
					</cfif>
				<cfelse>
					<cfset eh = factory.create("EventHandler") />
				</cfif>
				<cfset eh = configureEventHandler(arguments.mg, eh, ehTag) />
				<cfset arguments.mg.addEventHandler(eh) />
			</cfcase>
			<cfcase value="scaffold">
				<cfif getLoadingOptions().getRescaffold()>
					<cfparam name="ehTag.xmlAttributes.type" default="#arguments.mg.getConfigSetting("defaultScaffolds")#" />
					<cfif not structKeyExists(ehTag.xmlAttributes, "object")>
						<cfthrow message="Model-Glue: &lt;scaffold&gt; must have a OBJECT attribute." />
					</cfif>
					<cfloop list="#ehTag.xmlAttributes.type#" index="j">
						<cfset eh = factory.create(j, ehTag.xmlAttributes.object) />
						<cfset eh = configureEventHandler(arguments.mg, eh, ehTag) />
						<cfset eh.doPostConfiguration() />
						<cfset arguments.mg.addEventHandler(eh) />
						<cfset arguments.compilationQueue.put(eh) />
					</cfloop>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfloop>

</cffunction>

<cffunction name="configureEventHandler" output="false" access="private">
  <cfargument name="ModelGlue" required="true" type="ModelGlue.unity.framework.ModelGlue" />
  <cfargument name="EventHandler" required="true" type="ModelGlue.unity.eventhandler.EventHandler" />
  <cfargument name="configXml" required="true">

   <cfset var event = arguments.EventHandler />
   <cfset var message = "" />
   <cfset var view = "" />
   <cfset var append = "" />
   <cfset var i = "" />
   <cfset var j = "" />

   <cfif not len(arguments.eventhandler.getName()) and not structKeyExists(configXml.xmlAttributes, "name")>
     <cfthrow message="Model-Glue XML Problem: Bad &lt;event-handler&gt; tag." detail="Every &lt;event-handler&gt; must have a NAME attribute.">
   <cfelseif not len(arguments.eventhandler.getName())>
     <cfset event.setName(configXml.xmlAttributes.name) />
   </cfif>	

		<!---
   <cfif arguments.ModelGlue.EventHandlerExists(configXml.xmlAttributes.name)>
   	<cfthrow message="Model-Glue XML Problem: Duplicate event-handler." detail="There's already an event handler named #configXml.xmlAttributes.name# - maybe you have duplicates in your ModelGlue.xml?" />
   </cfif>
		--->
		
   <cfparam name="configXml.xmlAttributes.access" default="public" />
   <cfset event.setAccess(configXml.xmlAttributes.access) />

   <cfif structKeyExists(configXml, "broadcasts")>
    <cfloop from="1" to="#arrayLen(configXml.broadcasts.xmlChildren)#" index="i">
      <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlAttributes, "name")>
        <cfthrow message="Model-Glue XML Problem: Bad &lt;message&gt; tag." detail="Every &lt;message&gt; must have a NAME attribute.">
      </cfif>

			<cfset message = createObject("component", "ModelGlue.unity.eventhandler.Message").Init() />
			
			<cfset message.setName(configXml.broadcasts.xmlChildren[i].xmlAttributes.name) />
			
			<cfloop from="1" to="#arrayLen(configXml.broadcasts.xmlChildren[i].xmlChildren)#" index="j">
			   <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes, "name")>
			       <cfthrow message="Model-Glue XML Problem: Bad &lt;argument&gt; tag." detail="Every &lt;argument&gt; must have a NAME attribute.">
			   </cfif>
			   <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes, "value")>
			       <cfthrow message="Model-Glue XML Problem: Bad &lt;argument&gt; tag." detail="Every &lt;argument&gt; must have a VALUE attribute.">
			   </cfif>
			  <cfset message.addArgument(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes.name, configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes.value) />
			</cfloop>
			<cfset event.addMessage(message) />

			<!---
			<cfif not event.hasMessage(configXml.broadcasts.xmlChildren[i].xmlAttributes.name)>
	      <cfset message = createObject("component", "ModelGlue.unity.eventhandler.Message").Init() />

	      <cfset message.setName(configXml.broadcasts.xmlChildren[i].xmlAttributes.name) />

	      <cfloop from="1" to="#arrayLen(configXml.broadcasts.xmlChildren[i].xmlChildren)#" index="j">
	         <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes, "name")>
	             <cfthrow message="Model-Glue XML Problem: Bad &lt;argument&gt; tag." detail="Every &lt;argument&gt; must have a NAME attribute.">
	         </cfif>
	         <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes, "value")>
	             <cfthrow message="Model-Glue XML Problem: Bad &lt;argument&gt; tag." detail="Every &lt;argument&gt; must have a VALUE attribute.">
	         </cfif>
	        <cfset message.addArgument(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes.name, configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes.value) />
	      </cfloop>
	      <cfset event.addMessage(message) />
	     <cfelse>
	     	<cfset message = event.getMessage(configXml.broadcasts.xmlChildren[i].xmlAttributes.name) />
	      <cfloop from="1" to="#arrayLen(configXml.broadcasts.xmlChildren[i].xmlChildren)#" index="j">
	         <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes, "name")>
	             <cfthrow message="Model-Glue XML Problem: Bad &lt;argument&gt; tag." detail="Every &lt;argument&gt; must have a NAME attribute.">
	         </cfif>
	         <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes, "value")>
	             <cfthrow message="Model-Glue XML Problem: Bad &lt;argument&gt; tag." detail="Every &lt;argument&gt; must have a VALUE attribute.">
	         </cfif>
	        <cfset message.addArgument(configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes.name, configXml.broadcasts.xmlChildren[i].xmlChildren[j].xmlAttributes.value) />
	      </cfloop>
			</cfif>
			--->
    </cfloop>
   </cfif>

   <cfif structKeyExists(configXml, "views")>
    <cfloop from="1" to="#arrayLen(configXml.views.xmlChildren)#" index="i">
      <cfset view = createObject("component", "ModelGlue.unity.eventhandler.View").Init() />
      
      <cfparam name="configXml.views.xmlChildren[i].xmlAttributes.append" default="false" type="boolean" />
       <cfif not structKeyExists(configXml.views.xmlChildren[i].xmlAttributes, "name")>
           <cfthrow message="Model-Glue XML Problem: Bad &lt;include&gt; tag." detail="Every &lt;include&gt; must have a NAME attribute.">
       </cfif>
      <cfset view.SetName(configXml.views.xmlChildren[i].xmlAttributes.name) />
       <cfif not structKeyExists(configXml.views.xmlChildren[i].xmlAttributes, "template")>
           <cfthrow message="Model-Glue XML Problem: Bad &lt;include&gt; tag." detail="Every &lt;include&gt; must have a TEMPLATE attribute.">
       </cfif>
      <cfset view.SetTemplate(configXml.views.xmlChildren[i].xmlAttributes.template) />
      <cfset view.SetAppend(configXml.views.xmlChildren[i].xmlAttributes.append) />
      <cfloop from="1" to="#arrayLen(configXml.views.xmlChildren[i].xmlChildren)#" index="j">
         <cfif not structKeyExists(configXml.views.xmlChildren[i].xmlChildren[j].xmlAttributes, "name")>
             <cfthrow message="Model-Glue XML Problem: Bad &lt;value&gt; tag." detail="Every &lt;value&gt; must have a NAME attribute.">
         </cfif>
         <cfif not structKeyExists(configXml.views.xmlChildren[i].xmlChildren[j].xmlAttributes, "value")>
             <cfthrow message="Model-Glue XML Problem: Bad &lt;value&gt; tag." detail="Every &lt;value&gt; must have a VALUE attribute.">
         </cfif>
         <cfparam name="configXml.views.xmlChildren[i].xmlChildren[j].xmlAttributes.overwrite" default="false">
        <cfset view.AddValue(configXml.views.xmlChildren[i].xmlChildren[j].xmlAttributes.name, configXml.views.xmlChildren[i].xmlChildren[j].xmlAttributes.value, configXml.views.xmlChildren[i].xmlChildren[j].xmlAttributes.overwrite) />
	      </cfloop>
      <cfset event.addView(view) />
    </cfloop>
   </cfif>

   <cfif structKeyExists(configXml, "results")>
    <cfloop from="1" to="#arrayLen(configXml.results.xmlChildren)#" index="i">
      <cfparam name="configXml.results.xmlChildren[i].xmlAttributes.name" default="" />
      <cfparam name="configXml.results.xmlChildren[i].xmlAttributes.redirect" default=false />
      <cfparam name="configXml.results.xmlChildren[i].xmlAttributes.append" default="" />
      <cfparam name="configXml.results.xmlChildren[i].xmlAttributes.anchor" default="" />
      <cfparam name="configXml.results.xmlChildren[i].xmlAttributes.reset" default=false/>
      <cfparam name="configXml.results.xmlChildren[i].xmlAttributes.preserveState" default=true/>
      <cfif not structKeyExists(configXml.results.xmlChildren[i].xmlAttributes, "do")>
      	<cfthrow message="Model-Glue XML Problem: Bad &lt;result&gt; tag." detail="Every &lt;result&gt; must have a DO attribute.">
      </cfif>
      <cfset event.addResultMapping(configXml.results.xmlChildren[i].xmlAttributes.name, configXml.results.xmlChildren[i].xmlAttributes.do, configXml.results.xmlChildren[i].xmlAttributes.redirect, configXml.results.xmlChildren[i].xmlAttributes.append, configXml.results.xmlChildren[i].xmlAttributes.anchor, configXml.results.xmlChildren[i].xmlAttributes.reset, configXml.results.xmlChildren[i].xmlAttributes.preserveState) />
    </cfloop>
   </cfif>
	<cfreturn event />
</cffunction>

<cffunction name="compileEventHandlers" access="private" returntype="void" output="false">
	<cfargument name="eventHandlers" required="true">
	<cfargument name="destination" type="string" hint="The file to compile to." />
	
	<cfset var i = "" />
	<cfset var output = "" />
	
	<cfoutput>
	<cfsavecontent variable="output">
<!-- Warning:  this file is generated.  It may be overwritten at any time. -->
<modelglue>
	<event-handlers>
		<cfloop condition="not arguments.eventHandlers.isEmpty()">
			#arguments.eventHandlers.get().toXmlString()#
		</cfloop>
	</event-handlers>
</modelglue>
	</cfsavecontent>
	</cfoutput>
	
	<cfif not directoryExists(getDirectoryFromPath(arguments.destination))>
		<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.destination)#" />
	</cfif>
	
	<cffile action="write" file="#arguments.destination#" output="#output#" />
</cffunction>

</cfcomponent>