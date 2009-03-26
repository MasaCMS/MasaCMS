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


<cfcomponent displayname="XMLModelGlueLoader" output="false" hint="I create and configure a Model-Glue instance from an XML file.">

<cffunction name="init" returnType="ModelGlue.Core.XMLModelGlueLoader" hint="Constructor">
	<cfreturn this />
</cffunction>

<cffunction name="createModelGlue" output="false" hint="Creates and configures an instance of Model-Glue">
	<cfargument name="config" type="string" required="true" hint="XML configuration file." />
	
	<cfset var ModelGlue = createObject("component", "ModelGlue.ModelGlue").init() />
  <cfset var xCfg = "" />
  <cfset var i = "" />
	<cfset var beanFactory = "" />
	
  <cfif fileExists(arguments.config)>
    <cffile action="read" file="#arguments.config#" variable="xCfg">
  <cfelse>
    <cfthrow message="Model-Glue XML Problem:  #arguments.config# can't be found." />
  </cfif>

  <cfset xCfg=xmlParse(xCfg) />

	<!--- Load config properties --->
	<cfif not structKeyExists(xCfg.xmlRoot, "config")>
	  <cfthrow message="Model-Glue XML Problem:  No &lt;config&gt; section." detail="The root node of your configuration XML (usually &lt;modelglue&gt;), must contain a &lt;config&gt; tag." />
	</cfif>
	<cfloop from="1" to="#arrayLen(xCfg.xmlRoot.config.xmlChildren)#" index="i">
	  <cfset ModelGlue.setConfigSetting(xCfg.xmlRoot.config.xmlChildren[i].XmlAttributes.Name, xCfg.xmlRoot.config.xmlChildren[i].XmlAttributes.Value) />
	</cfloop>
	
	<!--- Config-based props --->
	<cfset ModelGlue.setViewMappings(listToArray(ModelGlue.getConfigSetting("viewMappings"))) />
	<!---
	<cfset ModelGlue.setBeanFactory(createObject("component", "ModelGlue.Bean.BeanFactory").init(ModelGlue.getConfigSetting("beanMappings"))) />
	--->
	<cfset beanFactory = createObject("component", ModelGlue.getConfigSetting("beanFactoryLoader")).init().load(ModelGlue.getConfigSetting("beanMappings")) />
	<cfset ModelGlue.setBeanFactory(beanFactory) />
	
	<!--- Load controllers --->
	<cfif not structKeyExists(xCfg.xmlRoot, "controllers")>
	  <cfthrow message="Model-Glue XML Problem:  No &lt;controllers&gt; section." detail="The root node of your configuration XML (usually &lt;modelglue&gt;), must contain a &lt;controllers&gt; tag." />
	</cfif>
	<cfloop from="1" to="#arrayLen(xCfg.xmlRoot.controllers.xmlChildren)#" index="i">
	  <cfif not structKeyExists(xCfg.xmlRoot.controllers.xmlChildren[i].xmlAttributes, "name")
	     or not structKeyExists(xCfg.xmlRoot.controllers.xmlChildren[i].xmlAttributes, "type")>
	     <cfthrow message="Model-Glue XML Problem: Bad &lt;controller&gt tag." detail="Every &lt;controller&gt; tag must have NAME and TYPE attributes.">
	  </cfif>
	  <cfset ModelGlue.addController(xCfg.xmlRoot.controllers.xmlChildren[i].xmlAttributes.name, xCfg.xmlRoot.controllers.xmlChildren[i].xmlAttributes.type) />
	  <cfloop from="1" to="#arrayLen(xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren)#" index="j">
	   <cfif not structKeyExists(xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren[j].xmlAttributes, "message")
	      or not structKeyExists(xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren[j].xmlAttributes, "function")>
	      <cfthrow message="Model-Glue XML Problem: Bad &lt;message-listener&gt tag." detail="Every &lt;message-listener&gt; tag must have MESSAGE and FUNCTION attributes.">
	   </cfif>
	   <!--- Async is not a required attribute --->
			<cfparam name="xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren[j].xmlAttributes.async" default="false" />
	    <cfset ModelGlue.addListener(xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren[j].xmlAttributes.message, xCfg.xmlRoot.controllers.xmlChildren[i].xmlAttributes.name, xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren[j].xmlAttributes.function, xCfg.xmlRoot.controllers.xmlChildren[i].xmlChildren[j].xmlAttributes.async) />
	  </cfloop>
	</cfloop>
	
	<!--- Load event handlers --->
	<cfif not structKeyExists(xCfg.xmlRoot, "event-handlers")>
	  <cfthrow message="Model-Glue XML Problem:  No &lt;event-handlers&gt; section." detail="The root node of your configuration XML (usually &lt;modelglue&gt;), must contain a &lt;event-handlers&gt; tag." />
	</cfif>
	<cfloop from="1" to="#arrayLen(xCfg.xmlRoot["event-handlers"].xmlChildren)#" index="i">
	  <cfset ModelGlue.addEventHandler(createEventHandler(ModelGlue, xCfg.xmlRoot["event-handlers"].xmlChildren[i])) />
	</cfloop>

	<cfreturn ModelGlue />
</cffunction>

<cffunction name="CreateEventHandler" output="false" access="private">
   <cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
   <cfargument name="configXml" required="true">

	 
   <cfset var event = createObject("component", "ModelGlue.Metadata.Event").init() />
   <cfset var message = "" />
   <cfset var view = "" />
   <cfset var append = "" />
   <cfset var i = "" />
   <cfset var j = "" />

   <cfif not structKeyExists(configXml.xmlAttributes, "name")>
     <cfthrow message="Model-Glue XML Problem: Bad &lt;event-handler&gt; tag." detail="Every &lt;event-handler&gt; must have a NAME attribute.">
   <cfelse>
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
      <cfset message = createObject("component", "ModelGlue.Metadata.Message").Init() />

       <cfif not structKeyExists(configXml.broadcasts.xmlChildren[i].xmlAttributes, "name")>
         <cfthrow message="Model-Glue XML Problem: Bad &lt;message&gt; tag." detail="Every &lt;message&gt; must have a NAME attribute.">
       </cfif>
      <cfset message.setName(configXml.broadcasts.xmlChildren[i].xmlAttributes.name) />
      
      <!---
					<cfparam name="variables.listeners[""#message.getName()#""]" default="#arrayNew(1)#">
      --->
      
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
    </cfloop>
   </cfif>

   <cfif structKeyExists(configXml, "views")>
    <cfloop from="1" to="#arrayLen(configXml.views.xmlChildren)#" index="i">
      <cfset view = createObject("component", "ModelGlue.Metadata.View").Init() />
      
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
      <cfif not structKeyExists(configXml.results.xmlChildren[i].xmlAttributes, "do")>
      	<cfthrow message="Model-Glue XML Problem: Bad &lt;result&gt; tag." detail="Every &lt;result&gt; must have a DO attribute.">
      </cfif>
      <cfset event.addResultMapping(configXml.results.xmlChildren[i].xmlAttributes.name, configXml.results.xmlChildren[i].xmlAttributes.do, configXml.results.xmlChildren[i].xmlAttributes.redirect, configXml.results.xmlChildren[i].xmlAttributes.append) />
    </cfloop>
   </cfif>
	<cfreturn event />
</cffunction>

</cfcomponent>