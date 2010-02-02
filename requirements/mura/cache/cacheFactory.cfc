<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" extends="mura.Factory">
	
	<cfset variables.isSoft=true>
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="isSoft" type="boolean" required="true" default="true"/>
		<cfargument name="freeMemoryThreshold" type="numeric" required="true" default="0"/>
		<cfscript>
			super.init( argumentCollection:arguments );
			variables.isSoft = arguments.isSoft;
			variables.freeMemoryThreshold=arguments.freeMemoryThreshold;
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="context" type="any" required="false" />
		<cfargument name="isSoft" type="boolean" required="false" default="#variables.isSoft#">
		<cfset var hashKey = getHashKey( arguments.key ) />
		
		<!--- if the key cannot be found and context is passed then push it in --->
		<cfif NOT has( arguments.key ) AND isDefined("arguments.context")>		
			<cfif hasFreeMemoryAvailable()>
				<!--- create object --->
				<cfset set( key, arguments.context, arguments.isSoft ) />
			<cfelse>
				<cfreturn arguments.context>
			</cfif>
		</cfif>
		
		<!--- if the key cannot be found then throw an error --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="Context not found for '#arguments.key#'" />
		</cfif>

		<!--- return cached context --->		
		<cfreturn super.get( key ) />

	</cffunction>
	
	<cffunction name="hasFreeMemoryAvailable" returntype="boolean" output="false">
		
		<cfif variables.freeMemoryThreshold>
			<cfif getPercentFreeMemory() gt variables.freeMemoryThreshold>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getPercentFreeMemory" returntype="numeric" output="false">
		<cfset var runtime = "">
		
		<cfif not structKeyExists(request,"percentFreeMemory")>
			<cfset runtime = getJavaRuntime()>
			<cfset request.percentFreeMemory=100 - (Round((runtime.freeMemory() / runtime.maxMemory() ) * 100))>
		</cfif>
			
		<cfreturn request.percentFreeMemory>
	</cffunction>
	
	<cffunction name="getJavaRuntime" returntype="any" output="false">
		<cfif not structKeyExists(application,"javaRuntime")>
			<cfset application.javaRuntime=createObject("java","java.lang.Runtime").getRuntime() >
		</cfif>
		
		<cfreturn application.javaRuntime>
	</cffunction>
</cfcomponent>