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
		
			
 $Id: flashUtilityService.cfc,v 1.8 2006/04/04 04:23:02 simb Exp $

--->

<cfcomponent>
		
	<cffunction name="setFlashMappings" access="public" returntype="void" output="false">
		<cfargument name="flashMappings" type="coldspring.remoting.flash.flashMappings" required="true">
		<cfset variables.mappings = arguments.flashMappings/>
	</cffunction>
	
	<cffunction name="addMapping" access="public" returntype="void" output="false">
		<cfargument name="cfcType" type="string" required="true">
		<cfargument name="flashType" type="string" required="true">	
		<cfargument name="instanceDataMethod" type="string" required="false" default="getTO">	
		<cfset variables.mappings.addMapping(arguments.cfcType,arguments.flashType,arguments.instanceDataMethod)>
	</cffunction>
	
	<cffunction name="processServiceMethodResult" returntype="any" access="public" output="false" hint="">
		<cfargument name="result" type="any" required="true" />
		<cfset var aresult = 0>
		<cfif isObject(arguments.result)>
			<cfset aresult = mapToASObject(arguments.result)>
		<cfelse>
			<cfset aresult = flashCast(arguments.result)>
		</cfif>
		<cfreturn aresult />
	</cffunction>
	
	<cffunction name="mapToASObject" returntype="struct" access="private" output="false">
		<cfargument name="result" type="any" required="true" />
		<cfset var asObject = CreateObject("java", "flashgateway.io.ASObject").init()>
		<cfset var props = 0>
		<cfset var prop = 0>
		<cfset var i = 0>
		<cfset var cfcType = getMetaData(arguments.result).name>
		<cfinvoke component="#arguments.result#" method="#mappings.getInstanceDataMethod(cfcType)#" returnvariable="props" />
		<cfloop list="#structKeyList(props)#" index="prop">
			<cfif isObject(evaluate('props.#prop#'))>
				<cfset asObject["#prop#"] = mapToASObject(evaluate('props.#prop#'))>
			<cfelseif isArray(evaluate('props.#prop#'))>
				<cfset asObject["#prop#"] = arrayNew(1)>
				<cfloop from="1" to="#arrayLen(evaluate('props.#prop#'))#" index="i">
					<cfif isObject(evaluate('props.#prop#[#i#]'))>
						<cfset asObject["#prop#"][i] = mapToASObject(evaluate('props.#prop#[#i#]'))>
					<cfelse>
						<cfset asObject["#prop#"][i] = flashCast(evaluate('props.#prop#[#i#]'))>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset asObject["#prop#"] = flashCast(evaluate('props.#prop#'))>
			</cfif>
		</cfloop>
		<!--- <cftrace text="getFlashType = #mappings.getFlashType(getMetaData(result).name)#, cfcType = #getMetaData(result).name#"> --->
		 <cfset asObject["_REMOTECLASS"] = mappings.getFlashType(cfcType) />
		<cfset asObject.setType(mappings.getFlashType(cfcType))>
		<cfreturn asObject>
	</cffunction>

	<cffunction name="flashCast" returntype="any" access="private" output="false">
		<cfargument name="value" type="any" required="true" />
		<!--- <cfif IsBoolean(arguments.value)>
			<cfreturn JavaCast("boolean", arguments.value)/> --->
		<cfif isNumeric(arguments.value)>
			<cfreturn Val(arguments.value)/>
		<cfelse>
			<cfreturn arguments.value/>
		</cfif>
	</cffunction>

	<cffunction name="mapToCFC" returntype="any" access="private" output="false">
		<cfargument name="data" type="struct" required="true" />
		<cfset var key = 0>
		<cfset var i = 0>
		<cfset var array = 0>
		<cfset var result = 0>
		<cfset var resultData = structNew()>
		<cfset var type = "">
		<cfloop collection="#arguments.data#" item="key">
			<cfset type = "">
			<cfif key neq "serviceName">
				<cftrace text="key = #key#, isObject(key) = #isObject(arguments.data[key])#, isStruct(key) = #isStruct(arguments.data[key])#, key = #arguments.data[key].toString()#">
				<cfif IsStruct(arguments.data[key])>
					<cftry>
						<cfset type = arguments.data[key].getType()>
						<cfcatch type="any">
							<cfset type = "">
						</cfcatch>
					</cftry>
					<cftrace text="testtype = #type#">
					<cfif type neq "">
						<cfset resultData[key] = mapToCFC(arguments.data[key])>
					<cfelse>
						<cfset resultData[key][i] = arguments.data[key][i]>
					</cfif>
				<cfelseif IsArray(arguments.data[key])>
					<cfset array = arguments.data[key]>
					<cfif NOT StructKeyExists(resultData, key)>
						<cfset resultData[key] = ArrayNew(1)>
						<cfloop index="i" from="1" to="#ArrayLen(arguments.data[key])#">
							<cfif IsObject(arguments.data[key][i])>
								<cfset resultData[key][i] = mapToCFC(arguments.data[key][i])>
							<cfelse>
								<cfset resultData[key][i] = arguments.data[key][i]>
							</cfif>
						</cfloop>
					</cfif>
				<cfelse>
					<cfset resultData[key] = arguments.data[key]>
				</cfif>
			</cfif>
		</cfloop>
		<cftrace text="data.getType() = #data.getType()#">
		<cfset result = createObject("component", mappings.getCFCType(data.getType())).init(argumentCollection=resultData)>		
		<cfreturn result>
	</cffunction>
	
	<cffunction name="processServiceMethodParams" returntype="struct" access="private" output="false">
		<cfargument name="params" type="struct" required="true" hint=""/>
		<cfset var args = StructNew()>
		<cfset var key = 0>
		<cfset var metaData = 0>
		<cfloop collection="#arguments.params#" item="key">
			<cfset args[key] = arguments.params[key]>
			<cfset metaData = getMetadata(args[key])>
			<cftrace text="metaData.name = #metaData.name#">
			<cfif metaData.name IS "flashgateway.io.ASObject">
				<cfset args[key] = mapToCFC(args[key])>
			<cfelse>
				<cfset args[key] = flashCast(args[key])>
			</cfif>
		</cfloop>
		<cfreturn args/>
	</cffunction>
	
</cfcomponent>