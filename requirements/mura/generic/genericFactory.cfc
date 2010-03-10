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
<cfcomponent extends="mura.Factory" output="false">

<cffunction name="init" output="false" returnType="any">
<cfargument name="class">
	<cfset variables.class=arguments.class>
	<cfset super.init() />
	<cfreturn this>
</cffunction>

<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashKey = getHashKey( arguments.key ) />
		
		<!--- if the key cannot be found and context is passed then push it in --->
		<cfif NOT has( arguments.key )>
			<!--- create object --->
			<cfset handlerWrapper=createObject("component","mura.generic.genericEventWrapper")>
			<cfset super.set( arguments.key, wrapHandler(createObject("component",getComponentPath(arguments.key)).init()) ) />
		</cfif>
		
		<!--- if the key cannot be found then throw an error --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="Component not found for '#getComponentPath(arguments.key)#'" />
		</cfif>

		<!--- return cached context --->		
		<cfreturn super.get( arguments.key ) />

</cffunction>

<cffunction name="getComponentPath" output="false" returnType="string">
	<cfargument name="key">
	<cfreturn "mura.#variables.class#.#arguments.key##variables.class#"/>
</cffunction>

<cffunction name="wrapHandler" access="public"  output="false">
<cfargument name="handler">
<cfreturn createObject("component","mura.generic.genericEventWrapper").init(arguments.handler)>
</cffunction>
</cfcomponent>