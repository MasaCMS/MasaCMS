<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.
	
	As a special exception to the terms and conditions of version 2.0 of
	the GPL, you may redistribute this Program as described in Mura CMS'
	Plugin exception. You should have recieved a copy of the text describing
	this exception, and it is also available here:
	'http://www.getmura.com/exceptions.txt"

	 --->
<cfcomponent extends="mura.cfobject" output="false">
	
<cfset variables.eventHandler="">
<cfset variables.eventName="">
<cfset variables.objectName="">

<cffunction name="init" output="false" returntype="any">
<cfargument name="eventHandler">
<cfargument name="eventName">

<cfset variables.eventHandler=arguments.eventHandler>
<cfset variables.eventName=arguments.eventName>
<cfset variables.objectName=getMetaData(variables.eventHandler).name>

<cfreturn this>
</cffunction>

<cffunction name="splitContexts" output="false" returntype="any">
<cfargument name="context">
	<cfset var contexts=structNew()>
	
	<cfif getMetaData(arguments.context).name eq "mura.MuraScope">
		<cfset contexts.muraScope=arguments.context>
		<cfset contexts.event=arguments.context.event()>
	<cfelse>
		<cfset contexts.muraScope=arguments.context.getValue("muraScope")>
		<cfset contexts.event=arguments.context>
	</cfif>
	<cfreturn contexts>
</cffunction>

<cffunction name="handle" output="false">
<cfargument name="context">
	<cfset var contexts=splitContexts(arguments.context)>
	<cfset var tracePoint=0>	
	<cfif structKeyExists(variables.eventHandler,variables.eventName)>
		<cfset tracePoint=initTracePoint("#variables.objectName#.#variables.eventName#")>
		<cfset evaluate("variables.eventHandler.#variables.eventName#(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope)")>
	<cfelse>
		<cfset tracePoint=initTracePoint("#variables.objectName#.handle")>
		<cfset variables.eventHandler.handle(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope)>
	</cfif>
	<cfset commitTracePoint(tracePoint)>
	<cfset request.muraHandledEvents["#variables.eventName#"]=true>
</cffunction>

<cffunction name="validate" output="false">
<cfargument name="context">
	<cfset var contexts=splitContexts(arguments.context)>
	<cfset var verdict="">
	<cfset var tracePoint=0>
	<cfif structKeyExists(variables.eventHandler,variables.eventName)>
		<cfset tracePoint=initTracePoint("#variables.objectName#.#variables.eventName#")>
		<cfset verdict=evaluate("variables.eventHandler.#variables.eventName#(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope)")>
	<cfelse>
		<cfset tracePoint=initTracePoint("#variables.objectName#.validate")>
		<cfset verdict=variables.eventHandler.validate(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope)>
	</cfif>
	<cfset commitTracePoint(tracePoint)>
	<cfset request.muraHandledEvents["#variables.eventName#"]=true>
	<cfif isdefined("verdict")>
		<cfreturn verdict>
	</cfif>
</cffunction>

<cffunction name="translate" output="false">
<cfargument name="context">
	<cfset var contexts=splitContexts(arguments.context)>
	<cfset var tracePoint=0>
	<cfif structKeyExists(variables.eventHandler,variables.eventName)>
		<cfset tracePoint=initTracePoint("#variables.objectName#.#variables.eventName#")>
		<cfset evaluate("variables.eventHandler.#variables.eventName#(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope)")>
	<cfelse>
		<cfset tracePoint=initTracePoint("#variables.objectName#.translate")>
		<cfset variables.eventHandler.translate(event=contexts.event, mura=contexts.muraScope, $=contexts.muraScope)>
	</cfif>
	<cfset commitTracePoint(tracePoint)>
	<cfset request.muraHandledEvents["#variables.eventName#"]=true>
</cffunction>

</cfcomponent>