<!---
License:
Copyright (c) 2005, David Ross, Chris Scott, Kurt Wiersma, Sean Corfield

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
  
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
		
$Id: ColdspringPlugin.cfc,v 1.13 2007/09/04 18:57:32 pjf Exp $

Description:
DEPRECATED - FOR USE WITH MACH-II 1.1.1 OR LOWER ONLY
(Use the never ColdspringProperty.cfc for Mach-II 1.5 higher)
A Mach-II plugin that provides easy ColdSpring integration with Mach-II applications.

Usage:
<plugin name="coldSpringPlugin" type="coldspring.machii.ColdspringPlugin">
	<parameters>
		<!-- Name of a Mach-II property name that will hold a reference to the ColdSpring beanFactory
			Default: 'beanFactory' -->
		<parameter name="beanFactoryPropertyName" value="serviceFactory"/>

		<!-- Name of a Mach-II property name that holds the path to the ColdSpring config file 
			default: 'ColdSpringComponentsLocation' -->
		<parameter name="configFilePropertyName" value="ColdspringComponentRelativePath"/>
		
		<!-- Flag to indicate whether supplied config path is relative (mapped) or absolute 
			Default: FALSE (absolute path) -->
		<parameter name="configFilePathIsRelative" value="true"/>
		
		<!-- Flag to indicate whether to resolve dependencies for listeners/filters/plugins 
			Default: FALSE -->
		<parameter name="resolveMachIIDependencies" value="false"/>
		
		<!-- indicate a scope to pull in a parent bean factory from 
			 default: application -->
		<parameter name="parentBeanFactoryScope" value="application"/>
		
		<!-- Indicate a key to pull in a parent bean factory from the application scope
			Default: FALSE -->
		<parameter name="parentBeanFactoryKey" value="serviceFactory"/>
			
		<!-- Indicate whether or not to place the bean factory in the application scope 
			 Default: FALSE -->
		<parameter name="placeFactoryInApplicationScope" value="false" />

		<!-- Indicate whether or not to place the bean factory in the server scope 
			 Default: FALSE -->
		<parameter name="placeFactoryInServerScope" value="false" />
		
		<!--- List of bean names and coresponding Mach-II property names for injecting back into Mach-II
			Default: '' --->
		<parameter name="beansToMachIIProperties" value="beanName1=machIIpropertyName1,beanName2=machIIpropertyName2" />
		
	</parameters>
</plugin>

The [beanFactoryPropertyName] parameter value is the name of the Mach-II property name 
that will hold a reference to the ColdSpring beanFactory. This parameter 
defaults to "beanFactory" if not defined.

The [configFilePropertyName] paramater value is the name of Mach-II property name that
hold the path of the ColdSpring configuration file. The value of the Mach-II property can 
be an relative, ColdFusion mapped or absolute path. If you are using a relative or mapped
path, be sure to set the [configFilePathIsRelative] parameter to TRUE or the plugin will
not find your configuration file. This parameter defaults to "ColdSpringComponentsLocation" 
if not defined.

The [configGilePathIsRelative] parameter value defines if the configure file is an relative
(including ColdFusion mapped) or absolute path. If you are using a relative or mapped
path, be sure to set the [configFilePathIsRelative] parameter to TRUE or the plugin will
not find your configuration file.
- TRUE (for relative or mapped configuration file paths)
- FALSE (for absolute configuration file paths)

The [resolveMachIIDependencies] parameter value indicates if the plugin to "automagically"
wire Mach-II listeners/filters/plugins.  This parameter defaults to FALSE if not defined.
- TRUE (resolves all Mach-II dependencies)
- FALSE (does not resolve Mach-II dependencies)

The [parentBeanFactoryKey] parameter values defines a key to pull in a parent bean factory
from the application scope.  This parameter defaults to FALSE if not defined.

The [beansToMachIIProperties] parameter holds a special list of bean names and coresponding
Mach-II property names. This parameter will inject the specified beans in the Mach-II property
manager as the bean factory has been loaded.  In the past, a seperate plugin has to be written 
to accomplish this task. This should be used for framework required "utility" objects that you 
want to be managed by ColdSpring such as UDF, i18n or session facade objects. Do not use this 
feature to inject your model objects into the Mach-II property manager.

The format of this list should be a comma delimited list name/value pairs consisting of the bean 
name and corresponding Mach-II property name. Example:
beanName1=machIIpropertyName1,beanName2=machIIpropertyName2

--->
<cfcomponent
	name="ColdspringPlugin"
	extends="MachII.framework.Plugin"
	hint="A Mach-II plugin for easy ColdSpring integration"
	output="false">

	<!---
	INITALIZATION / CONFIGURATION
	--->
	<cffunction name="configure" access="public" returntype="void" output="false"
		hint="DEPRECATED - I initialize this plugin during framework startup.">
		
		<!--- Default vars --->
		<cfset var appContext = 0 />
		<cfset var bf = 0 />
		<cfset var p = 0 />
		
		<!--- Get the Mach-II property manaager --->
		<cfset var pm = getAppManager().getPropertyManager() />
	
		<!--- Determine the location of the bean def xml file --->
		<cfset var serviceDefXmlLocation = pm.getProperty(getParameter("configFilePropertyName", "ColdSpringComponentsLocation")) />
		
		<!--- Get all properties to pass to bean factory --->
		<cfset var props = pm.getProperties() />
		
		<!--- todo: Defaults set via mach-ii params --->
		<cfset var defaults = StructNew() />
		
		<!--- Locating and storing bean factory (from properties/params) --->
		<cfset var bfUtils = CreateObject("component", "coldspring.beans.util.BeanFactoryUtils").init() />
		<cfset var parentBeanFactoryKey = getParameter("parentBeanFactoryKey", "") />
		
		<cfset var localBeanFactoryKey = getParameter("beanFactoryPropertyName", bfUtils.DEFAULT_FACTORY_KEY) />
		<cfset var placeFactoryInApplicationScope = getParameter("placeFactoryInApplicationScope", FALSE) />
		
		<cfset var placeFactoryInServerScope = getParameter('placeFactoryInServerScope','false') />
		<cfset var parentBeanFactoryScope = getParameter('parentBeanFactoryScope', 'application')>

		<!--- Get the parent props if in modules --->
		<cfif StructKeyExists(getAppManager(), "getModuleName") AND getAppManager().getModuleName() NEQ ''>
			<cfset StructAppend(props, pm.getParent().getProperties(), false) />
		</cfif>				
		
		<!--- Evaluate any dynamic properties --->
		<cfloop collection="#props#" item="p">
			<cfif IsSimpleValue(props[p]) AND Left(props[p], 2) EQ "${" AND Right(props[p], 1) EQ "}">
				<cfset props[p] = Evaluate(Mid(props[p], 3, Len(props[p]) -3)) />
			</cfif>
		</cfloop>
		
		<!--- Create a new bean factory and appContext --->
		<cfset bf = CreateObject("component", "coldspring.beans.DefaultXmlBeanFactory").init(defaults, props)/>
		
		<!--- if we're using an application scoped factory, retrieve the appContext from app scope
		<cfif placeFactoryInApplicationScope and bfUtils.namedContextExists('application', localBeanFactoryKey)>
			<cfset appContext = bfUtils.getNamedApplicationContext('application', localBeanFactoryKey)>
			<cfset appContext.setBeanFactory(bf) />
		<cfelse>
			<cfset appContext = createObject("component","coldspring.context.DefaultApplicationContext").init(bf)/>
		</cfif> --->
		<!--- <cfset appContext = createObject("component", "coldspring.context.DefaultApplicationContext").init(bf)/> --->
		
		<!--- If necessary setup the parent bean factory --->
		<cfif len(parentBeanFactoryKey) and bfUtils.namedFactoryExists(parentBeanFactoryScope, parentBeanFactoryKey)>
			<!--- OK, this time we're gonna try to use the new ApplicationContextUtils --->
			<cfset bf.setParent(bfUtils.getNamedFactory(parentBeanFactoryScope, parentBeanFactoryKey))/>
			<!--- <cfset bf.setParent(application[getParameter("parentBeanFactoryKey")].getBeanFactory())/> --->
		</cfif>
		
		<!--- Expand path for relative and mapped config file paths --->
		<cfif getParameter("configFilePathIsRelative", FALSE)>
			<cfset serviceDefXmlLocation = ExpandPath(serviceDefXmlLocation) />
		</cfif>
		
		<!--- Load the bean defs --->
		<cfset bf.loadBeansFromXmlFile(serviceDefXmlLocation, TRUE)/>

		<!--- Put a bean factory reference into Mach-II property manager --->
		<cfset setProperty("beanFactoryName", localBeanFactoryKey) />
		<cfset setProperty(localBeanFactoryKey, bf) />
		
		<!--- Put a bean factory reference into the application if required --->
		<cfif placeFactoryInApplicationScope>
			<cfset bfUtils.setNamedFactory("application", localBeanFactoryKey, bf) />
		</cfif>
		<cfif placeFactoryInServerScope>
			<cfset bfUtils.setNamedFactory('server', localBeanFactoryKey, bf)>
		</cfif>
		
		<!--- Resolve Mach-II dependences if required --->
		<cfif getParameter("resolveMachiiDependencies", FALSE)>
			<cfset resolveDependencies() />
		</cfif>
		
		<!--- Place bean references into the Mach-II properties if required --->
		<cfif Len(getParameter("beansToMachIIProperties", ""))>
			<cfset referenceBeansToMachIIProperties(getParameter("beansToMachIIProperties")) />
		</cfif>		
	</cffunction>
	
	<!---
	PROTECTED FUNCTIONS
	--->
	<cffunction name="resolveDependencies" access="private" returntype="void" output="false"
		hint="DEPRECATED - Resolves Mach-II dependencies.">
		
		<cfset var beanFactory = getProperty(getProperty("beanFactoryName")) />
		<cfset var targets = StructNew() />
		
		<cfset var targetObj = 0 />
		<cfset var targetIx = 0 />
		
		<cfset var md = "" />
		<cfset var functionIndex = 0 />
		
		<cfset var setterName = "" />
		<cfset var beanName = "" />
		<cfset var access = "" />
		
		<!--- Get listeners/filters/plugin targets --->
		<cfset targets.data = ArrayNew(1) />
		<cfset getListeners(targets) />
		<cfset getFilters(targets) />
		<cfset getPlugins(targets) />
		
		<cfloop from="1" to="#ArrayLen(targets.data)#" index="targetIx">
			<!--- Get this iteration target object for easy use --->
			<cfset targetObj = targets.data[targetIx] />
			
			<!--- Look for autowirable collaborators for any SETTERS --->
			<cfset md = GetMetaData(targetObj) />
			
			<cfif StructKeyExists(md, "functions")>
				<cfloop from="1" to="#arraylen(md.functions)#" index="functionIndex">
					<!--- first get the access type --->
					<cfif StructKeyExists(md.functions[functionIndex], "access")>
						<cfset access = md.functions[functionIndex].access />
					<cfelse>
						<cfset access = "public" />
					</cfif>
					
					<!--- if this is a 'real' setter --->
					<cfif Left(md.functions[functionIndex].name, 3) EQ "set" 
							  AND Arraylen(md.functions[functionIndex].parameters) EQ 1 
							  AND (access IS NOT "private")>
						
						<!--- look for a bean in the factory of the params's type --->	  
						<cfset setterName = Mid(md.functions[functionIndex].name, 4, Len(md.functions[functionIndex].name)-3) />
						
						<!--- Get bean by setter name and if not found then get by type --->
						<cfif beanFactory.containsBean(setterName)>
							<cfset beanName = setterName />
						<cfelse>
							<cfset beanName = beanFactory.findBeanNameByType(md.functions[functionIndex].parameters[1].type) />
						</cfif>
						
						<!--- If we found a bean, put the bean by calling the target object's setter --->
						<cfif Len(beanName)>
							<cfinvoke component="#targetObj#"
									  method="set#setterName#">
								<cfinvokeargument name="#md.functions[functionIndex].parameters[1].name#"
									  	value="#beanFactory.getBean(beanName)#"/>
							</cfinvoke>	
						</cfif>			  
					</cfif>
				</cfloop>		
			</cfif>
		</cfloop>
		
	</cffunction>
		
	<cffunction name="getListeners" access="private" returntype="void" output="false"
		hint="DEPRECATED - Gets the listener targets.">
		<cfargument name="targets" type="struct" required="true" />
		
		<cfset var listenerManager = getAppManager().getListenerManager() />
		<cfset var listenerNames = ArrayNew(1) />
		<cfset var i = 0 />
		
		<!--- Get the listener names (inject a method for Mach-II 1.1.0 or lower) --->
		<cfif StructKeyExists(listenerManager,"getListenerNames")>
			<cfset listenerNames = listenerManager.getListenerNames() />
		<cfelse>
			<!--- Inject a method I need into the manager and use it to get the listener names --->
			<cfset listenerManager["getListenerNamesForColdSpring"] = variables["getListenerNamesForColdSpring"] />
			<cfset listenerNames = listenerManager.getListenerNamesForColdSpring() />
			<!--- Cleanup the mayhem --->
			<cfset StructDelete(listenerManager, "getListenerNamesForColdSpring") /> 
		</cfif>
		
		<!--- Append each retrieved listener to the targets array (in struct) --->
		<cfloop from="1" to="#ArrayLen(listenerNames)#" index="i">
			<cfset ArrayAppend(targets.data, listenerManager.getListener(listenerNames[i])) />
		</cfloop>
		
	</cffunction>
		
	<cffunction name="getFilters" access="private" returntype="void" output="false"
		hint="DEPRECATED - Get the filter targets.">
		<cfargument name="targets" type="struct" required="true" />
		
		<cfset var filterManager = getAppManager().getFilterManager() />
		<cfset var filterNames = ArrayNew(1) />
		<cfset var i = 0 />
		
		<!--- Get the filter names (inject a method for Mach-II 1.1.0 or lower) --->
		<cfif StructKeyExists(filterManager, "getFilterNames")>
			<cfset filterNames = filterManager.getFilterNames() />
		<cfelse>
			<!--- Inject a method I need into the manager and use it to get the filter names --->
			<cfset filterManager["getFilterNamesForColdSpring"] = variables["getFilterNamesForColdSpring"] />
			<cfset filterNames = filterManager.getFilterNamesForColdSpring() />
			<!--- Cleanup the mayhem --->
			<cfset StructDelete(filterManager, "getFilterNamesForColdSpring") /> 
		</cfif>
		
		<!--- Append each retrieved filter to the targets array (in struct) --->
		<cfloop from="1" to="#ArrayLen(filterNames)#" index="i">
			<cfset ArrayAppend(targets.data, filterManager.getFilter(filterNames[i])) />
		</cfloop>
	</cffunction>
		
	<cffunction name="getPlugins" returntype="void" access="private" output="false"
		hint="DEPRECATED - Get the plugin targets.">
		<cfargument name="targets" type="struct" required="true" />
		
		<cfset var pluginManager = getAppManager().getPluginManager() />
		<cfset var pluginNames = ArrayNew(1) />
		<cfset var i = 0 />
		
		<!--- Get the plugin names (inject a method for Mach-II 1.1.0 or lower) --->
		<cfif StructKeyExists(pluginManager, "getPluginNames")>
			<cfset pluginNames = pluginManager.getPluginNames() />
		<cfelse>
			<!--- Inject a method I need into the manager and use it to get the plugin names --->
			<cfset pluginManager["getPluginNamesForColdSpring"] = variables["getPluginNamesForColdSpring"] />
			<cfset pluginNames = pluginManager.getPluginNamesForColdSpring() />
			<!--- Cleanup the mayhem --->
			<cfset StructDelete(pluginManager, "getPluginNamesForColdSpring") /> 
		</cfif>
		
		<!--- Append each retrieved plugin to the targets array (in struct) --->
		<cfloop from="1" to="#ArrayLen(pluginNames)#" index="i">
			<cfset ArrayAppend(targets.data, pluginManager.getPlugin(pluginNames[i])) />
		</cfloop>
	</cffunction>
	
	<cffunction name="referenceBeansToMachIIProperties" access="private" returntype="void" output="false"
		hint="DEPRECATED - Places references to ColdSpring managed beans into the Mach-II properties.">
		<cfargument name="beanToPropertyList" type="string" required="true" />
		
		<cfset var beanFactory = getProperty(getProperty("beanFactoryName")) />
		<cfset var beanName = "" />
		<cfset var i = "" />
		
		<!--- Build references struct --->
		<cfloop list="#arguments.beanToPropertyList#" index="i">
			<cfset beanName = ListGetAt(i, 1, "=") />
			
			<cfif beanFactory.containsBean(beanName)>
				<cfset setProperty(ListGetAt(i, 2, "="), beanFactory.getBean(beanName)) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!---
	PUBLIC FUNCTIONS - INJECTABLE UTILITY METHODS
	--->
	<cffunction name="getPluginNamesForColdSpring" access="public" returntype="array" output="false"
		hint="DEPRECATED - Injectable method for getting plugin names (for Mach-II versions 1.1.0 and lower)">
		<cfreturn StructKeyArray(variables.plugins) />
	</cffunction>
	
	<cffunction name="getFilterNamesForColdSpring" access="public" returntype="array" output="false"
		hint="DEPRECATED - Injectable method for getting filter names (for Mach-II versions 1.1.0 and lower)">
		<cfreturn StructKeyArray(variables.filters) />
	</cffunction>
	
	<cffunction name="getListenerNamesForColdSpring" access="public" returntype="array" output="false"
		hint="DEPRECATED - Injectable method for getting listener names (for Mach-II versions 1.1.0 and lower)">
		<cfreturn StructKeyArray(variables.listeners) />
	</cffunction>

</cfcomponent>