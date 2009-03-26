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
---><cfsilent>
<!--- A "safe" container for anything we create --->
<cfif not structKeyExists(variables, "_modelglue")>
	<cfset _modelglue = structNew() />
</cfif>

<!--- By default, we're not in 1.0 legacy mode --->
<cfparam name="_modelglue.compatibilityMode" default="Unity" />

<!--- A unique name by which to store ModelGlue in the application scope --->
<cfparam name="ModelGlue_APP_KEY" type="string" default="#GetFileFromPath(ExpandPath('.'))#" />
<!--- Framework loading --->
<cfif not structKeyExists(application, ModelGlue_APP_KEY) 
			or not structKeyExists(application[ModelGlue_APP_KEY], "framework") 
			or application[ModelGlue_APP_KEY].framework.getConfigSetting("reload") 
			or (
				structKeyExists(url, application[ModelGlue_APP_KEY].framework.getConfigSetting("reloadKey")) 
				and url[application[ModelGlue_APP_KEY].framework.getConfigSetting("reloadKey")] eq application[ModelGlue_APP_KEY].framework.getConfigSetting("reloadPassword")
			)
			or (
				structKeyExists(url, application[ModelGlue_APP_KEY].framework.getConfigSetting("rescaffoldKey")) 
				and url[application[ModelGlue_APP_KEY].framework.getConfigSetting("rescaffoldKey")] eq application[ModelGlue_APP_KEY].framework.getConfigSetting("rescaffoldPassword")
			)
>
	<cflock name="ModelGlueInit" type="exclusive" timeout="10" throwOnTimeout="true">
		<cfif not structKeyExists(application, ModelGlue_APP_KEY) 
					or not structKeyExists(application[ModelGlue_APP_KEY], "framework") 
					or application[ModelGlue_APP_KEY].framework.getConfigSetting("reload") 
					or (
						structKeyExists(url, application[ModelGlue_APP_KEY].framework.getConfigSetting("reloadKey")) 
						and url[application[ModelGlue_APP_KEY].framework.getConfigSetting("reloadKey")] eq application[ModelGlue_APP_KEY].framework.getConfigSetting("reloadPassword")
					)
					or (
						structKeyExists(url, application[ModelGlue_APP_KEY].framework.getConfigSetting("rescaffoldKey")) 
						and url[application[ModelGlue_APP_KEY].framework.getConfigSetting("rescaffoldKey")] eq application[ModelGlue_APP_KEY].framework.getConfigSetting("rescaffoldPassword")
					)
		>
			<!--- Prereq's --->
			<cfparam name="ModelGlue_CORE_COLDSPRING_PATH" type="string" default="#expandPath("/ModelGlue/unity/config/Configuration.xml")#" />
			<cfparam name="ModelGlue_SCAFFOLDING_CONFIGURATION_PATH" type="string" default="#expandPath("/ModelGlue/unity/config/ScaffoldingConfiguration.xml")#" />
			<cfparam name="ModelGlue_LOCAL_COLDSPRING_PATH" type="string" default="#expandPath(".") & "/config/ColdSpring.xml"#" />
			<cfparam name="ModelGlue_PARENT_BEAN_FACTORY" default="" />
			
			<!--- This only exists to support legacy applications.  --->
			<cfparam name="ModelGlue_CONFIG_PATH" type="string" default="" />

			<cfif not structKeyExists(application, ModelGlue_APP_KEY)>
	    	<cfset application[ModelGlue_APP_KEY] = structNew() />
	    </cfif>

			<!--- Create ColdSpring --->			
			<cfset _modelglue.beanFactory = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
			
			<!--- Very simple HBF support --->
			<cfif isObject(ModelGlue_PARENT_BEAN_FACTORY)>
				<cfset _modelglue.beanFactory.setParent(ModelGlue_PARENT_BEAN_FACTORY) />
			</cfif>
			
			<cfif fileExists(ModelGlue_CORE_COLDSPRING_PATH)>
				<cfset _modelglue.beanFactory.loadBeans(ModelGlue_CORE_COLDSPRING_PATH) />
			<cfelse>
				<cfthrow type="ModelGlue.CoreConfigurationMissing" message="Model-Glue can't start because it can't find its core Configuration.xml file." detail="It's looking in ""#ModelGlue_CORE_COLDSPRING_PATH#"".  Usually, this file is at whatever expandPath(/ModelGlue/unity/config/Configuration.xml) resolves to ." />
			</cfif>

			<!--- Load app configuration if it exists (1.x upgrades won't have a ColdSpring.xml) --->
			<cfif _modelglue.compatibilityMode neq "Legacy" and not fileExists(ModelGlue_LOCAL_COLDSPRING_PATH)>
				<cfthrow type="ModelGlue.ColdspringXmlMissing" message="Model-Glue can't start because it can't find your application's Coldspring.xml file." detail="It's looking in ""#ModelGlue_LOCAL_COLDSPRING_PATH#""." />
			</cfif>

			<cfif fileExists(ModelGlue_LOCAL_COLDSPRING_PATH)>
				<cfset _modelglue.beanFactory.loadBeans(ModelGlue_LOCAL_COLDSPRING_PATH) />
			</cfif>

			<!--- Get MG Configuration --->
			<cfset _modelglue.configuration = _modelglue.beanFactory.getBean("modelGlueConfiguration") />
				    
	    <!--- Set loading options --->
	    <cfset _modelglue.loadingOptions = createObject("component", "ModelGlue.unity.loader.LoadingOptions") />
	    
	    <cfif _modelglue.configuration.getRescaffold()
	    			or (
	    				structKeyExists(url, _modelglue.configuration.getRescaffoldKey())
	    				and url[_modelglue.configuration.getRescaffoldKey()] eq _modelglue.configuration.getRescaffoldPassword()
	    			)
	    >
	    	<cfset _modelglue.loadingOptions.setRescaffold(true) />
	    </cfif>
	    
			<!--- Get the framework loader --->
			<cfset loader = _modelglue.beanFactory.getBean("FrameworkLoader") />
			<cfset loader.setBeanFactory(_modelglue.beanFactory) />

			<!--- Load the framework --->
			<cfset application[ModelGlue_APP_KEY].framework = loader.load(ModelGlue_CONFIG_PATH, _modelglue.loadingOptions) />
			<cfset application[ModelGlue_APP_KEY].framework.setApplicationKey(ModelGlue_APP_KEY) />
		</cfif>
	</cflock>
</cfif>

<cfset _ModelGlue.framework = application[ModelGlue_APP_KEY].framework />
<cftry>
	<!--- Create and execute an event request --->
	<cfset _ModelGlue.eventRequest = _ModelGlue.framework.createEventRequest() />
	<cfset _ModelGlue.eventRequest = _ModelGlue.framework.handleEventRequest(_ModelGlue.eventRequest) />
	<cfcatch>
		<!--- Try to release the eventRequest --->
		<cfif structKeyExists(_ModelGlue, "eventRequest")>
			<cftry>
				<cfset _ModelGlue.framework.releaseEventRequest(_ModelGlue.eventRequest) />
				<cfcatch />
			</cftry>
		</cfif>
		
		<!--- 
			There's no default exception handler, and an error has been thrown from
			the framework back to this page.
		--->
		<cfrethrow />
	</cfcatch>
</cftry>

<!--- Display output --->
</cfsilent><cfoutput>#_ModelGlue.eventRequest.getOutput()#</cfoutput><cfsetting enablecfoutputonly="true">

<cfif _ModelGlue.framework.getConfigSetting("debug") neq "none" and _ModelGlue.framework.getConfigSetting("debug") neq "false" and not structKeyExists(request, "modelGlueSuppressDebugging")>
  <cfset logRenderer = createObject("component", "ModelGlue.unity.debug.RequestLogRenderer").init() />
  <cfoutput>#logRenderer.render(_ModelGlue.EventRequest.getLog(), _ModelGlue.framework.getConfigSetting("debug"))#</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false">

<!--- Release the event request --->
<cfset _ModelGlue.framework.releaseEventRequest(_ModelGlue.eventRequest) />

<!--- Clear out any forwarded state --->
<cfif _ModelGlue.framework.GetUseSession()>
	<cfset session._ModelGlue.forwardedStateContainer = structNew() />
	<cfset session._ModelGlue.forwardedRequestLog = "" />
</cfif>