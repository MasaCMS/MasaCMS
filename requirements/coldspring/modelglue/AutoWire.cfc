<!---
 
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
		
			
 $Id: AutoWire.cfc,v 1.4 2006/03/06 01:27:05 scorfield Exp $

--->

<cfcomponent name="coldspring.modelglue.AutoWire" extends="ModelGlue.Core.Controller">
	
	<!---
		this proxy gets injected into the ModelGlue framework so we can intercept
		the AddController calls and autowire the freshly installed controllers:
		- look for setXxx(x:y) methods in each controller (single argument)
			- if bean xxx exists, call setXxx(bean("xxx"))
			- else if bean with type y exists, call setXxx(beanByType("y"))
	--->
	<cffunction name="AddControllerProxy" returntype="void" access="public" output="false" hint="I add a controller of a given type with a unique name.">
		<cfargument name="name" type="string" required="true" hint="I am the unique instance name of this controller.">
		<cfargument name="type" type="string" required="true" hint="I am the type of the controller, i.e. ""com.myapp.mycontroller"".">
		
		<cfset var ctlr = 0 />
		<cfset var md = 0 />
		<cfset var nFunc = 0 />
		<cfset var funcIdx = 0 />
		<cfset var method = 0 />
		<cfset var setterName = "" />
		<cfset var beanFactory = variables.getBeanFactory().getBeanFactory() />
		<cfset var beanName = "" />
		
		<cfset this.AddControllerTarget(arguments.name, arguments.type) />
		
		<!--- now we can autowire the new controller --->
		<cfset ctlr = variables.controllers[arguments.name] />
		<cfset md = getMetadata(ctlr) />
		<cfif structKeyExists(md,"functions")>
			<cfset nFunc = arrayLen(md.functions) />
			<cfloop index="funcIdx" from="1" to="#nFunc#">
				<cfset method = md.functions[funcIdx] />
				<cfif len(method.name) gt 3 and
						left(method.name,3) is "set" and
						arrayLen(method.parameters) eq 1>
					<cfset setterName = right(method.name,len(method.name)-3) />
					
					<cfif beanFactory.containsBean(setterName)>
						<cfset beanName = setterName />
					<cfelse>
						<cfset beanName = beanFactory.findBeanNameByType(method.parameters[1].type) />
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
		
	</cffunction>
		
	<cffunction name="Init" access="public" returnType="ModelGlue.Core.Controller" output="false" hint="I return a new Controller.">
		<cfargument name="ModelGlue" type="ModelGlue.ModelGlue" required="true" hint="I am an instance of ModelGlue.">
		<cfargument name="InstanceName" required="false" type="string" default="Unknown">
		
		<cfset super.Init(arguments.ModelGlue,arguments.InstanceName) />
		
		<!--- rewire ModelGlue framework code so we can proxy the controllers: --->
		<cfset arguments.ModelGlue.AddControllerTarget = arguments.ModelGlue.AddController />
		<cfset arguments.ModelGlue.AddController = this.AddControllerProxy />
		
		<cfreturn this />
	</cffunction>
	
</cfcomponent>