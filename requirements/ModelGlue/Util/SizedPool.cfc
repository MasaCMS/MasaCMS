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


<cfcomponent>

<cffunction name="init" output="false" access="public">
	<cfargument name="class" type="string" required="true" />
	<cfargument name="maxSize" type="numeric" required="true" />
	<cfargument name="timeout" type="numeric" required="true" />
	<cfargument name="throwOnTimeout" type="boolean" required="false" default="false"/>
	
	<cfset variables._poolId = createUUID() />
	<cfset variables._maxSize = arguments.maxSize />
	<cfset variables._class = arguments.class />
	<cfset variables._poolSize = 0 />
	<cfset variables._availableInstances = arrayNew(1) />
	<cfset variables._timeout = arguments.timeout />
	<cfset variables._throwOnTimeout = arguments.throwOnTimeout />
		
	<cfreturn this />
</cffunction>

<cffunction name="getInstance" output="false" access="public">
		
	<cfset var result = "" />
	<cfset var waitStartTime = "" />

	<!--- We've been called (possibly recursively) and there's an available instance --->	
	<cfif arrayLen(variables._availableInstances)>
		<cflock type="exclusive" name="#variables._poolId#.useAvailableInstance" timeout="30">
			<cfif arrayLen(variables._availableInstances)>
				<cfset result = variables._availableInstances[arrayLen(variables._availableInstances)] />
				<cfset arrayDeleteAt(variables._availableInstances, arrayLen(variables._availableInstances)) />
			<cfelse>
				<cfset result = getInstance() />
			</cfif>
		</cflock>
	<!--- There are no avail. instances, but there's room to add to the pool --->
	<cfelseif variables._poolSize lt variables._maxSize>
		<cfset result = createObject("component", variables._class) />
		<cfset variables._poolSize = variables._poolSize + 1 />
	<!--- Pool is max sized and we need to get in line --->
	<cfelse>
		<cfset waitStartTime = getTickCount() />

		<!--- Wait for an available instance up to timeout --->		
		<cfloop condition="not arrayLen(variables._availableInstances)">
			<!--- Check for timeout --->
			<cfif getTickCount() - waitStartTime GT variables._timeout>
				<cfif variables._throwOnTimeout>
					<cfthrow message="Resource Pool: Timed out waiting for resource" type="net.clearsoftware.resourcepool.timeout" />
				<cfelse>
					<!--- They've timed out waiting.  We don't want them to fail, so create an instance outside of the pool. --->
					<cfreturn createObject("component", variables._class) />
				</cfif>		
			</cfif>
		</cfloop>
		<cfset result = getInstance() />
	</cfif>
	
	<cfreturn result />
</cffunction>

<cffunction name="releaseInstance" output="false" access="public">
	<cfargument name="instance" />
	
	<cfset arrayAppend(variables._availableInstances, instance) />	
</cffunction>

<cffunction name="removeInstance" output="false" access="public">
	<cfargument name="instance" />

	<cfset variables._poolSize = variables._poolSize - 1 />
</cffunction>

</cfcomponent>
