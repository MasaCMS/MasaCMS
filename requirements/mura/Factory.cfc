<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent output="false">

	<cfset variables.parent = "" />
	<cfset variables.collection = {} />
	<cfset variables.cacheTimeout = 60 /> <!--- minutes --->
	<cfset variables.updateDatetimeOnRequest = false />

	<cffunction name="init" access="public" returntype="Factory" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashKey = getHashKey( arguments.type) />
		
		<!---
		<cfif NOT structKeyExists( variables.collection, hashKey )>
			
			<!--- create object --->
			<cfset variables.collection[ hashKey ] = createObject( getFactoryClassType(), getClassPathPrefix() & arguments.type & getClassPathSuffix() ) />
		
			<!--- attempt to initialize --->
			<cftry>
				<cfset variables.collection[ hashKey ].init() />
				<cfcatch>
					<!--- do nothing --->
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn variables.collection[ hashKey ] />
		--->
		
		<cfthrow message="This is abstract. The GET method needs to be rebuilt" />

	</cffunction>
	
	<cffunction name="size" access="public" returntype="any" output="false">
		<cfreturn structCount( variables.collection ) />
	</cffunction>
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="key" type="string" required="true" />

		<!--- returns true or false based on if the key exists within the collection --->
		<cfreturn structKeyExists( variables.collection, getHashKey( arguments.key ) ) />

	</cffunction>

	<cffunction name="purgeAll" access="public" returntype="void" output="false">
		<cfset variables.collection = {} />
	</cffunction>

	<cffunction name="purge" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />

		<!--- check to see if the id exists --->
		<cfif structKeyExists( variables.collection, getHashKey( arguments.key ) )>
			<!--- delete from cache --->
			<cfset structDelete( variables.collection, getHashKey( arguments.key ) )>
		<cfelse>
			<cfthrow message="Id:#arguments.key# cached item from factory could not be found, so could not be deleted" />
		</cfif>

	</cffunction>

	<cffunction name="getHashKey" access="public" returntype="string" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfreturn hash(arguments.key, "MD5") />
	</cffunction>
	
	<!---
	<cffunction name="flushByTimeout" access="public" returntype="void" output="false">

		<cfset var key = "" />

		<!--- loop over the collection and scrub out any key that have been sitting over the variables.cacheTimeout --->
		<cfloop collection="#variables.collection#" item="key">
			<cfif dateDiff("n", variables.collection[key].datetime, now()) GT variables.cacheTimeout>
				<!--- <cfdump var="Cache delete: #key#" output="console" format="text" /> --->
				<cfset structDelete(variables.collection, key) />
			</cfif>
		</cfloop>

	</cffunction>

	<cffunction name="setCacheTimeout" access="public" returntype="void" output="false">
		<cfargument name="minutes" type="numeric" required="true" />
		<cfset variables.cacheTimeout = arguments.minutes />
	</cffunction>
	
	<cffunction name="setUpdateDatetimeOnRequest" access="public" returntype="void" output="false">
		<cfargument name="updateDatetimeOnRequest" type="boolean" required="true" />
		<cfset variables.updateDatetimeOnRequest = arguments.updateDatetimeOnRequest />
	</cffunction>
	--->

</cfcomponent>