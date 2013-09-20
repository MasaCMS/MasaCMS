<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.event="">

<cffunction name="init" output="false">
	<cfargument name="data" hint="Can be an event object, struct or siteID">
	
	<cfset var initArgs=structNew()>
	
	<cfif structKeyExists(arguments,"data") and not (isSimpleValue(arguments.data) and not len(arguments.data))>
		<cfif isObject(arguments.data)>
			<cfset setEvent(arguments.data)>
		<cfelse>
			<cfif isStruct(arguments.data)>
				<cfset initArgs=arguments.data>
			<cfelse>
				<cfset initArgs.siteID=arguments.data>
			</cfif>
			<cfset initArgs.muraScope=this>
			<cfset setEvent(createObject("component","mura.event").init(initArgs).setValue('MuraScope',this))>
		</cfif>
	</cfif>
	
	<cfset structAppend(this,request.customMuraScopeKeys,false)>
	
	<cfreturn this>
</cffunction>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true"/>
	<cfset var local=structNew()>
	<cfset var object="">
	<cfset var prefix="">
	
	<cfif len(arguments.MissingMethodName)>
		
		<cfif isObject(getEvent()) and structKeyExists(variables.instance.event,arguments.MissingMethodName)>
			<cfset object=variables.instance.event>
		<cfelseif isObject(getThemeRenderer()) and structKeyExists(getThemeRenderer(),arguments.MissingMethodName)>
			<cfset object=getThemeRenderer()>
		<cfelseif isObject(getContentRenderer()) and structKeyExists(getContentRenderer(),arguments.MissingMethodName)>
			<cfset object=getContentRenderer()>
		<cfelseif isObject(getContentBean())>
			<cfif structKeyExists(getContentBean(),arguments.MissingMethodName)>
				<cfset object=getContentBean()>
			<cfelse>
				<cfset prefix=left(arguments.MissingMethodName,3)>
				<cfif listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3>
					<cfif getContentBean().valueExists(right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3))>
						<cfset object=getContentBean()>	
					<cfelse>
						<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">		
					</cfif>
				<cfelse>
					<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
				</cfif>
			</cfif>
		<cfelse>
			<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
		</cfif>
		
		<cfsavecontent variable="local.thevalue2">
		<cfif not structIsEmpty(arguments.MissingMethodArguments)>
			<cfinvoke component="#object#" method="#arguments.MissingMethodName#" argumentcollection="#arguments.MissingMethodArguments#" returnvariable="local.theValue1">
		<cfelse>
			<cfinvoke component="#object#" method="#arguments.MissingMethodName#" returnvariable="local.theValue1">
		</cfif>
		</cfsavecontent>
		
		<cfif isDefined("local.theValue1")>
			<cfreturn local.theValue1>
		<cfelseif isDefined("local.theValue2")>
			<cfreturn local.theValue2>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="getContentRenderer" output="false" returntype="any">
	<cfif not isObject(event("contentRenderer"))>
		<cfif structKeyExists(request,"contentRenderer")>
			<cfset event("contentRenderer",request.contentRenderer)>
		<cfelseif len(event('siteid'))>
			<cfset event("contentRenderer",createObject("component","#siteConfig().getAssetMap()#.includes.contentRenderer").init(event=event,$=event("muraScope"),mura=event("muraScope") ) )>
		<cfelseif structKeyExists(application,"contentRenderer")>
			<cfset event("contentRenderer",getBean('contentRenderer'))>
		</cfif>
	</cfif>
	<cfreturn event("contentRenderer")>
</cffunction>

<cffunction name="getThemeRenderer" output="false" returntype="any">
	<cfif isObject(event("themeRenderer"))>
		<cfreturn event("themeRenderer")>
	<cfelseif len(event('siteid')) and fileExists(expandPath(siteConfig().getThemeIncludePath()) & "/contentRenderer.cfc" )>
		<cfset event("themeRenderer",createObject("component","#siteConfig().getThemeAssetMap()#.contentRenderer").init(event=event,$=event("muraScope"),mura=event("muraScope") ) )>
	<cfelse>
		<cfreturn event("themeRenderer")>
	</cfif>
</cffunction>

<cffunction name="getContentBean" output="false" returntype="any">
	<cfreturn event("contentBean")>
</cffunction>

<cffunction name="setContentBean" output="false" returntype="any">
	<cfargument name="contentBean">
	<cfif isObject(arguments.contentBean)>
		<cfreturn event("contentBean",arguments.contentBean)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEvent" output="false" returntype="any">
	<cfif not isObject(variables.instance.event)>
		<cfif structKeyExists(request,"servletEvent")>
			<cfset variables.instance.event=request.servletEvent>
		<cfelseif structKeyExists(request,"event")>
			<cfset variables.instance.event=request.event>
		<cfelse>
			<cfset variables.instance.event=createObject("component","mura.event").init($=this)>
		</cfif>
	</cfif>
	<cfreturn variables.instance.event>
</cffunction>

<cffunction name="getGlobalEvent" output="false" returntype="any">
	<cfset var temp="">
	<cfif structKeyExists(request,"servletEvent")>
		<cfreturn request.servletEvent>
	<cfelseif structKeyExists(request,"event")>
		<cfreturn request.event>
	<cfelse>
		<cfset temp=structNew()>
		<cfif isdefined("session.siteid")>
			<cfset temp.siteID=session.siteID>
		</cfif>
		<cfset request.muraGlobalEvent=createObject("component","mura.event").init(temp)>
		<cfreturn request.muraGlobalEvent>
	</cfif>
</cffunction>

<cffunction name="setEvent" output="false" returntype="any">
	<cfargument name="event">
	<cfif isObject(arguments.event)>
		<cfset variables.instance.event=arguments.event>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="event" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif isObject(getEvent())>
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfset getEvent().setValue(arguments.property,arguments.propertyValue)>
				<cfreturn this>
			<cfelse>
				<cfreturn getEvent().getValue(arguments.property)>
			</cfif>
		<cfelse>
			<cfthrow message="The event is not set in the Mura Scope.">
		</cfif>
	<cfelse>
		<cfreturn getEvent()>
	</cfif>
	
</cffunction>

<cffunction name="content" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif isObject(getContentBean())>
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfset getContentBean().setValue(arguments.property,arguments.propertyValue)>
				<cfreturn this>
			<cfelse>
				<cfreturn getContentBean().getValue(arguments.property)>
			</cfif>
		<cfelse>
			<cfthrow message="The content is not set ine the Mura Scope.">
		</cfif>
	<cfelse>
		<cfreturn getContentBean()>
	</cfif>
</cffunction>

<cffunction name="currentUser" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif structKeyExists(arguments,"propertyValue")>
			<cfset getCurrentUser().setValue(arguments.property,arguments.propertyValue)>
			<cfreturn this>
		<cfelse>
			<cfreturn getCurrentUser().getValue(arguments.property)>
		</cfif>
	<cfelse>
		<cfreturn getCurrentUser()>
	</cfif>
	
</cffunction>

<cffunction name="siteConfig" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	<cfset var site="">
	<cfset var theValue="">
	<cfset var siteID=event('siteid')>
	
	<cfif len(siteid)>
		<cfset site=application.settingsManager.getSite(siteid)>
	
		<cfif structKeyExists(arguments,"property")>
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfset site.setValue(arguments.property,arguments.propertyValue)>
				<cfreturn this>
			<cfelse>
				<cfreturn site.getValue(arguments.property)>
			</cfif>
		<cfelse>
			<cfreturn site>
		</cfif>
	<cfelse>
		<cfthrow message="The siteid is not set in the current Mura Scope event.">
	</cfif>
	
</cffunction>

<cffunction name="globalConfig" output="false" returntype="any">
	<cfargument name="property">
	<cfset var site="">
	<cfset var theValue="">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif structKeyExists(arguments,"propertyValue")>
			<cfinvoke component="#application.configBean#" method="set#arguments.property#">
				<cfinvokeargument name="#arguments.property#" value="#arguments.propertyValue#">
			</cfinvoke>
			<cfreturn this>
		<cfelse>
			<cfinvoke component="#application.configBean#" method="get#arguments.property#" returnvariable="theValue">
			<cfreturn theValue>
		</cfif>
	<cfelse>
		<cfreturn application.configBean>
	</cfif>
	
</cffunction>

<cffunction name="component" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	<cfset var componentBean="">
	<cfset var component=event('component')>
	
	<cfif structKeyExists(arguments,"property") and isStruct(component)>
		<cfif structKeyExists(arguments,"property") and structKeyExists(component,arguments.property)>		
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfset component[arguments.property]=arguments.propertyValue>
				<cfreturn this>
			<cfelse>
				<cfreturn component[arguments.property]>
			</cfif>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelseif isStruct(component)>
		<cfset componentBean=getBean("content")>
		<cfset componentBean.setAllValues(component)>
		<cfreturn componentBean>
	<cfelse>
		<cfthrow message="No component has been set in the Mura Scope.">
	</cfif>
	
</cffunction>

<cffunction name="currentURL" output="false" returntype="any">
	<cfreturn getContentRenderer().getCurrentURL()>
</cffunction>

<cffunction name="getParent" output="false" returntype="any">
	<cfset var parent="">
	
	<cfif structKeyExists(request,"crumbdata") and arrayLen(request.crumbdata) gt 1>
		<cfreturn getBean("contentNavBean").set(request.crumbdata[2],"active") />
	<cfelseif isObject(getContentBean())>
		<cfreturn getContentBean().getParent()>
	<cfelse>
		<cfthrow message="No primary content has been set.">
	</cfif>
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" default="">
	
	<cfif len(arguments.siteID)>
		<cfreturn super.getBean(arguments.beanName,arguments.siteID)>
	<cfelse>
		<cfreturn super.getBean(arguments.beanName,event('siteid'))>
	</cfif>
</cffunction>

<cffunction name="announceEvent" returntype="any" access="public" output="false">
	<cfargument name="eventName">
	<cfset getEventManager().announceEvent(arguments.eventName,this)>
</cffunction>

<cffunction name="renderEvent" returntype="any" access="public" output="false">
	<cfargument name="eventName">
	<cfreturn getEventManager().renderEvent(arguments.eventName,this)>
</cffunction>

<cffunction name="createHREF" returntype="string" output="false" access="public">
	<cfargument name="type" required="true" default="Page">
	<cfargument name="filename" required="true" default="">
	<cfargument name="siteid" required="true" default="#event('siteid')#">
	<cfargument name="contentid" required="true" default="">
	<cfargument name="target" required="true" default="">
	<cfargument name="targetParams" required="true" default="">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#">
	<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#">
	<cfargument name="indexFile" type="string" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfreturn getContentRenderer().createHref(argumentCollection=arguments)>
</cffunction>

<cffunction name="rbKey" output="false" returntype="any">
	<cfargument name="key">
	<cfreturn siteConfig("RBFactory").getKey(arguments.key)>
</cffunction>

<cffunction name="setCustomMuraScopeKey" output="false">
	<cfargument name="name">
	<cfargument name="value">
	
	<cfset this['#arguments.name#']=arguments.value>
	<cfset request.customMuraScopeKeys['#arguments.name#']=arguments.value>
</cffunction>

<cffunction name="static" output="false">
	<cfargument name="staticDirectory" default="">
	<cfargument name="staticUrl" default="">
	<cfargument name="outputDirectory" default="compiled">
	<cfargument name="minifyMode" default="package">
	<cfargument name="checkForUpdates" default="true">
	<cfargument name="javaLoaderScope" default="#application.configBean.getValue('cfStaticJavaLoaderScope')#">
	<cfset var hashKey="">
	
	<cfif not len(arguments.staticDirectory) and len(event("siteid"))>
		<cfset arguments.staticDirectory=ExpandPath(siteConfig("themeIncludePath"))>	
	</cfif>
	
	<cfset hashKey=hash(arguments.staticDirectory)>
	
	<cfif not structKeyExists(application.cfstatic,hashKey)>
		
		<cfif not len(arguments.staticUrl)>
			<cfset arguments.staticUrl=replace(globalConfig("context") & right(arguments.staticDirectory,len(arguments.staticDirectory)-len(expandPath("/murawrm"))), "\","/","all")>	
		</cfif>
	
		<cfif not directoryExists(arguments.staticDirectory & "/compiled")>
			<cfset getBean("fileWriter").createDir(arguments.staticDirectory & "/compiled")>	
		</cfif>
		
		<cfset application.cfstatic[hashKey]=createObject("component","org.cfstatic.CfStatic").init(argumentCollection=arguments)>
	</cfif>
	<cfreturn application.cfstatic[hashKey]>
</cffunction>

<cffunction name="each">
	<cfargument name="collection" hint="An Query, Array, Iterator, Struct or List the action function will be applied." >
	<cfargument name="action" hint="A function that will run per item in iterator.">
	<cfargument name="$" default="#this#" hint="A context object that is passed to each method. It defaults to the current MuraScope istance">
	<cfargument name="delimiters" default="," hint="The delimiter to be used when the collection argument is a list.">
	<cfset var i="">
	<cfset var queryIterator="">
	<cfset var test=false>
	<cfset var item="">
	
	<cfif structKeyExists(arguments,"mura")>
		<cfset arguments.$=arguments.mura>
	</cfif>
	
	<cfif isObject(arguments.collection) and structKeyExists(arguments.collection,"hasNext")>	
		<cfset arguments.$.event("each:count",arguments.collection.getRecordCount())>
		<cfloop condition="arguments.collection.hasNext()">
			<cfset item=arguments.collection.next()>
			<cfset arguments.$.event("each:index",arguments.collection.getRecordIndex())>
			<cfset test=arguments.action(item=item, $=arguments.$, mura=arguments.$)>
			<cfif isDefined("test") and isBoolean(test) and not test>
				<cfbreak>	
			</cfif>
		</cfloop>	
	<cfelseif isArray(arguments.collection) and arrayLen(arguments.collection)>
		<cfset arguments.$.event("each:count",arrayLen(arguments.collection))>
		<cfloop from="1" to="#arrayLen(arguments.collection)#" index="i">
			<cfset arguments.$.event("each:index",i)>
			<cfset test=arguments.action(item=arguments.collection[i], $=arguments.$, mura=arguments.$)>
			<cfif isDefined("test") and isBoolean(test) and not test>
				<cfbreak>	
			</cfif>
		</cfloop>
	<cfelseif isStruct(arguments.collection)>
		<cfset arguments.$.event("each:count",structCount(arguments.collection))>
		<cfset arguments.$.event("each:index",0)>
		<cfloop collection="#arguments.collection#" item="i">
			<cfset arguments.$.event("each:index",arguments.$.event("each:index")+1)>
			<cfset test=arguments.action(item=arguments.collection[i], $=arguments.$, mura=arguments.$)>
			<cfif isDefined("test") and isBoolean(test) and not test>
				<cfbreak>	
			</cfif>
		</cfloop>
	<cfelseif isQuery(arguments.collection)>
		<cfset queryIterator=createObject("component","mura.iterator.queryIterator")>
		<cfset queryIterator.setQuery(arguments.collection).init()>
		<cfset arguments.$.event("each:count",queryIterator.getRecordCount())>
		<cfloop condition="queryIterator.hasNext()">	
			<cfset item=queryIterator.next()>
			<cfset arguments.$.event("each:index",queryIterator.getRecordIndex())>
			<cfset test=arguments.action(item=item, $=arguments.$)>
			<cfif isDefined("test") and isBoolean(test) and not test>
				<cfbreak>	
			</cfif>
		</cfloop>
	<cfelseif isSimpleValue(arguments.collection) and len(arguments.collection)>
		<cfset arguments.collection=listToArray(arguments.collection,arguments.delimiters)>
		<cfset arguments.$.event("each:count",arrayLen(arguments.collection))>
		<cfloop from="1" to="#arrayLen(arguments.collection)#" index="i">
			<cfset arguments.$.event("each:index",i)>
			<cfset test=arguments.action(item=arguments.collection[i], $=arguments.$, mura=arguments.$)>
			<cfif isDefined("test") and isBoolean(test) and not test>
				<cfbreak>	
			</cfif>
		</cfloop>	
	</cfif>
</cffunction>

<cffunction name="isHandledEvent" output="false">
<cfargument name="eventName">
	<cfreturn structKeyExists(request.muraHandledEvents,arguments.eventName)>
</cffunction>


</cfcomponent>