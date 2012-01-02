<!--- 
LICENSE 
Copyright 2008 Brian Kotek

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	    http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

	Thanks to Jon Messer for the thread safety patch that added the loadedKey logic.

File Name: 

	BeanInjector.cfc
	
Version: 1.1	

Description: 

	This component will autowire any target component with matching beans from ColdSpring. It is useful for injecting beans into
	"transient" or "per-request" components. It also has advantages over using ColdSpring to manage the non-Singleton objects: 
	
	1. ColdSpring goes through several phases of lookup and resolution when beans are created. This adds performance overhead
	when managing non-Singleton beans. This BeanInjector avoids that overhead.
	
	2. Since ColdSpring creates a fully-initialized component before it returns it to you, you have only limited control over
	how that object is constructed (via the ColdSpring XML configuration). Using this BeanInjector allows you to create and call 
	the init() method on your components, allowing you full control over how they are constructed. 
	
	This makes it much easier to create "rich" objects that can handle much more business logic than objects that can't leverage
	ColdSpring. The dependencies are cached by the BeanInjector for performance. After the first instance of object is created, all 
	subsequent objects of that type will have their dependencies injected using cached information. The component is thread-safe.

Usage:

	Usage of the BeanInjector is fairly straightforward. The ColdSpring XML file might look like this:
		
		<bean id="userService" class="components.userService">
			<property name="beanInjector">
				<ref bean="beanInjector" />
			</property>
		</bean>
		
		<bean id="beanInjector" class="components.BeanInjector" />
		
		<bean id="validatorFactory" class="components.ValidatorFactory" />
	
	Next, I would create public setter method(s) for the bean(s) you want to inject into my component, for example I might
	have a User.cfc with the following method:
	
		<cffunction name="setValidatorFactory" access="public" returntype="void" output="false" hint="I set the ValidatorFactory.">
			<cfargument name="validatorFactory" type="any" required="true" hint="ValidatorFactory" />
			<cfset variables.instance.validatorFactory = arguments.validatorFactory />
		</cffunction>
		
	To autowire a new User inside my UserService, I would simply create the User (either directly or with a factory) and then
	call autowire() on the BeanInjector:
	
		<cfset var user = CreateObject('component', 'components.User').init() />
		<cfset variables.beanInjector.autowire(user) />	
	
	That's it. The User object would now be autowired and have the ValidatorFactory injected into it. The end result is that 
	any setters in your target object that have matching bean IDs in ColdSpring will have those beans injected automatically. 
	As an additional example, a bean with an ID of "productService" would be autowired into a component that had a public setter 
	method named setProductService(), and so on.
	
	There is an optional constructor argument called "suffixList" that can be supplied. This is a comma-delimited list
	of propery name suffixes that will be allowed. If you specify a suffixList, the Observer will only inject beans which
	end in one of the suffixes in the list. For example, if you specify a suffixList of "service", setter methods for
	setUserService() and setLoginService() would be called, but setter methods for setValidatorFactory() or setContext()
	would NOT be called. This can be useful in rare situations where your Transfer Object may have database-driven properties
	that conflict with the names of ColdSpring beans. Most people probably won't need to worry about this, but the option
	is here in case the issue arises.
	
	In case you have problems determining whether beans are being properly injected into your Decorators, there is
	an optional init() method argument called "debugMode". By default, this is false. If you set it to true via the ColdSpring
	XML config file, the component will trace successful dependency injections to the debugging output. It will also
	rethrow any errors that occur while trying to inject beans into your Decorators. Obviously, ensure that this is
	remains off in production.
	
	The autowire() method also has two optional arguments that can be used for small performance increases: 
	
	The first optional argument is "targetComponentTypeName". If the calling code already knows the full type name of the target 
	component, you can pass this string into the autowire() method to avoid the need to look up the type name in the component 
	metadata. For example, Transfer ORM Decorators already know their type, so if you are autowiring a Decorator, you can pass in 
	the type name. The performance differnce is small, but every little bit helps so I made this an option. In most cases, the
	type won't be known by the calling code, so this argument won't be used.
	
	The second optional argument is "stopRecursionAt". This is the full type name of a superclass of the target component at which
	you want dependency resolution lookup to stop. For example, Transfer ORM Decorators inherit from the "transfer.com.TransferDecorator"
	class. However, when autowiring Transfer Decorators, you don't want to waste time trying to resolve dependencies at that level,
	because from that parent class upwards, everything is managed by Transfer. There are no custom properties for you to define at
	that level. Looking for properties to autowire in those parent classes would usually not cause any errors, but it is wasted time.
	By specifying a type name to stop the lookup recursion, you can save some processing time and avoid looking at unnecessary 
	parent classes. Unless the target component is part of some greater framework, such as Transfer, using this optional argument
	will usually be unnecessary.
	
--->

<cfcomponent name="BeanInjector" hint="">
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor.">
		<cfargument name="suffixList" type="string" required="false" default="" />
		<cfargument name="debugMode" type="boolean" required="false" default="false" />
		<cfset variables.DICache = StructNew() />
		<cfset variables.debugMode = arguments.debugMode />
		<cfset variables.suffixList = arguments.suffixList />
		<cfset variables.loadedKey = CreateUUID() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="autowire" access="public" returntype="any" output="false" hint="">
		<cfargument name="targetComponent" type="any" required="true" />
		<cfargument name="targetComponentTypeName" type="any" required="false" default="" hint="If the calling code already knows the type name of the target component, passing this will provide a small speed improvment because the type doesn't have to be looked up in the component metadata." />
		<cfargument name="stopRecursionAt" type="string" required="false" default="" hint="When recursing the parent classes of the target component, recusion will stop when it reaches this class name." />
		<cfset var local = StructNew() />
		
		<cfif not Len(arguments.targetComponentTypeName)>
			<cfset local.typeName = GetMetaData(arguments.targetComponent).name />
		<cfelse>
			<cfset local.typeName = arguments.targetComponentTypeName />
		</cfif>
		
		<!--- If the DI resolution has already been cached, inject from the cache. --->
		<cfif StructKeyExists(variables.DICache, local.typeName) and StructKeyExists(variables.DICache[local.typeName], variables.loadedKey)>
			<cfset injectCachedBeans(arguments.targetComponent, local.typeName) />
		<cfelse>
		
			<!--- Double-checked lock based on Object Type Name to handle race conditions. --->
			<cflock name="BeanInjector_#local.typeName#_#application.instanceID#" type="exclusive" timeout="5" throwontimeout="true">
				
				<cfif StructKeyExists(variables.DICache, local.typeName) and StructKeyExists(variables.DICache[local.typeName], variables.loadedKey)>
					<cfset injectCachedBeans(arguments.targetComponent, local.typeName) />
				<cfelse>	
					<!--- Create a new cache element for this component. --->
					<cfset variables.DICache[local.typeName] = StructNew() />
					
					<!--- Get the metadata for the component. --->
					<cfset local.objMetaData = GetMetaData(arguments.targetComponent) />
			    	
			    	<!--- Recurse the inheritance tree of the component and attempt to resolve dependencies. --->
			    	<cfset performDIRecursion(arguments.targetComponent, local.objMetaData, local.typeName, arguments.stopRecursionAt) />
			    	
			    	<!--- Update the DI cache to set this type as loaded. --->
			    	<cfset variables.DICache[local.typeName][variables.loadedKey]=true />
				</cfif>
				
			</cflock>
			
		</cfif>
		
		<cfreturn arguments.targetComponent />
	</cffunction>
	
	<cffunction name="injectCachedBeans" access="private" returntype="void" output="false" hint="">
		<cfargument name="targetComponent" type="any" required="true" />
		<cfargument name="typeName" type="string" required="true" />
		<cfset var thisProperty = "" />
		<cfif StructCount(variables.DICache[arguments.typeName]) gt 0>
			<cfloop collection="#variables.DICache[arguments.typeName]#" item="thisProperty">
				<cfif thisProperty neq variables.loadedKey>
					<cfset injectBean(arguments.targetComponent, thisProperty, variables.DICache[arguments.typeName][thisProperty]) />
					<cfif variables.debugMode><cftrace text="The cached dependency #thisProperty# was successfully injected into #arguments.typeName#." inline="false"></cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="injectBean" access="private" returntype="void" output="false" hint="">
		<cfargument name="targetObject" type="any" required="true" />
		<cfargument name="propertyName" type="string" required="true" />
		<cfargument name="propertyValue" type="any" required="true" />
		<cfinvoke component="#arguments.targetObject#" method="set#arguments.propertyName#">
			<cfinvokeargument name="#arguments.propertyName#" value="#arguments.propertyValue#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="performDIRecursion" access="private" returntype="void" output="false" hint="">
		<cfargument name="targetObject" type="any" required="true" />
		<cfargument name="metaData" type="struct" required="true" />
		<cfargument name="originalTypeName" type="string" required="true" />
		<cfargument name="stopRecursionAt" type="string" required="true" />
		<cfset var thisFunction = "" />
		<cfset var propertyName = "" />
		<cfset var thisSuffix = "" />
		<cfset var suffixMatch = true />
		
		<!--- If the metadata element has functions, attempt to resolve dependencies. --->
		<cfif StructKeyExists(arguments.metadata, 'functions')>
			<cfloop from="1" to="#ArrayLen(arguments.metaData.functions)#" index="thisFunction">
				<cfif Left(arguments.metaData.functions[thisFunction].name, 3) eq "set" 
						and Len(arguments.metaData.functions[thisFunction].name) gt 3
						and (not StructKeyExists(arguments.metaData.functions[thisFunction], 'access') 
							 or 
							 arguments.metaData.functions[thisFunction].access eq 'public')>
					<cfset propertyName = Right(arguments.metaData.functions[thisFunction].name, Len(arguments.metaData.functions[thisFunction].name)-3) />
					<cftry>
						
						<cfif getBeanFactory().containsBean(propertyName)>
							
							<!--- If a suffix List is defined, confirm that the property has the proper suffix. --->
							<cfif Len(variables.suffixList)>
								<cfset suffixMatch = false />
								<cfloop list="#variables.suffixList#" index="thisSuffix" delimiters=",">
									<cfif Right(propertyName, Len(thisSuffix)) eq thisSuffix>
										<cfset suffixMatch = true />
										<cfbreak />
									</cfif>
								</cfloop>
							</cfif>
							
							<cfif suffixMatch>
							
								<!--- Try to call the setter. --->
								<cfset injectBean(arguments.targetObject, propertyName, getBeanFactory().getBean(propertyName)) />
								
								<!--- If the set was successful, add a cache reference to the bean for the current TDO property. --->						
								<cfset variables.DICache[arguments.originalTypeName][propertyName] = getBeanFactory().getBean(propertyName) />
								
								<cfif variables.debugMode><cftrace text="The dependency #propertyName# was successfully injected into #arguments.originalTypeName# and cached." inline="false"></cfif>
							
							</cfif>
								
						</cfif>
						
						<cfcatch type="any">
							<!--- Bean injection failed. --->
							<cfif variables.debugMode><cfrethrow /></cfif>
						</cfcatch>
						
					</cftry>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- If the metadata element extends another component, recurse that component. --->		
		<cfif StructKeyExists(arguments.metadata, 'extends')>
			<cfif not Len(arguments.stopRecursionAt) or (Len(arguments.stopRecursionAt) and arguments.metadata.extends.name neq arguments.stopRecursionAt)>
				<cfset performDIRecursion(arguments.targetObject, arguments.metaData.extends, arguments.originalTypeName, arguments.stopRecursionAt) />
			</cfif>
		</cfif>
	</cffunction>
	
	<!--- Dependency injection methods for Bean Factory. --->
	<cffunction name="getBeanFactory" access="public" returntype="any" output="false" hint="I return the BeanFactory.">
		<cfreturn variables.instance.beanFactory />
	</cffunction>
		
	<cffunction name="setBeanFactory" access="public" returntype="void" output="false" hint="I set the BeanFactory.">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset variables.instance.beanFactory = arguments.beanFactory />
	</cffunction>

</cfcomponent>