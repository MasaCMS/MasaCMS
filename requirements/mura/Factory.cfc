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
<cfcomponent output="false" extends="mura.cfobject">

	<cfset variables.parent = "" />
	<cfset variables.javaLoader = "" />
	<!--- main collection --->
	<cfset variables.collections = "" />
	<cfset variables.collection = "" />
	<cfset variables.map = "" />
	<cfset variables.utility="">
	<!--- default variables --->

	<cffunction name="init" access="public" returntype="mura.Factory" output="false">
		
		<cfset variables.collections = createObject( "java", "java.util.Collections" ) />
		<cfset variables.collection = "" />
		<cfset variables.map = createObject( "java", "java.util.HashMap" ).init() />
		<cfset variables.utility=application.utility>
		<!--- set the map into the collections --->
		<cfset setCollection( variables.collections.synchronizedMap( variables.map ) ) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- *************************--->
	<!--- GLOBAL --->
	<!--- *************************--->
	<!---
	<cffunction name="configure" access="public" returntype="void" output="false">
	</cffunction>
	--->
	
	<cffunction name="getHashKey" access="public" returntype="string" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfreturn hash( arguments.key, "MD5" ) />
	</cffunction>

	<cffunction name="setParent" access="public" returntype="void" output="false">
		<cfargument name="parent" type="mura.Factory" required="true" />
		<cfset variables.parent = arguments.parent />
	</cffunction>
	
	<cffunction name="getParent" access="public" returntype="mura.Factory" output="false">
		<cfreturn variables.parent />
	</cffunction>
	<cffunction name="hasParent" access="public" returntype="boolean" output="false">
		<cfreturn isObject( variables.parent ) />
	</cffunction>
	
	<cffunction name="setCollection" access="private" returntype="void" output="false">
		<cfargument name="collection" type="struct" required="true" />
		<cfset variables.collection = arguments.collection />
	</cffunction>
	
	<!--- *************************--->
	<!--- COMMON --->
	<!--- *************************--->
	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashedKey = getHashKey( arguments.key ) />
		<cfset var cacheData=structNew()>
		
		<!--- check to see if the item is in the parent --->
		<!--- only if a parent is present --->
		<cfif NOT has( arguments.key ) AND hasParent() AND getParent().has( arguments.key )>
			<cfreturn getParent().get( arguments.key ) />
		</cfif>

		<!--- check to make sure the key exists within the factory collection --->
		<cfif has( arguments.key )>
			<!--- if it's a soft reference then do a get against the soft reference --->
			<cfset cacheData=variables.collection.get( hashedKey )>
			<cfif isSoftReference( cacheData.object )>
				<!--- is it still a soft reference --->
				<!--- if so then return it --->
				<cfreturn cacheData.object.get() />
			<cfelse>
				<!--- return the object from the factory collection --->
				<cfreturn cacheData.object />
			</cfif>
		</cfif>

		<cfthrow message="Key '#arguments.key#' was not found within the map collection" />

	</cffunction>
	<cffunction name="getAll" access="public" returntype="any" output="false">
		<cfreturn variables.collection />
	</cffunction>
	
	<cffunction name="set" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="obj" type="any" required="true" />
		<cfargument name="isSoft" type="boolean" required="false" default="false" />
		<cfargument name="timespan" required="false" default="">
		
		<cfset var softRef = "" />
		<cfset var hashedKey = getHashKey( arguments.key ) />
		<cfset var cacheData=structNew()>
		
		<cfif isDate(arguments.timespan)>
			<cfset cacheData.expires=now() + arguments.timespan>
		<cfelse>
			<cfset cacheData.expires=dateAdd("yyyy",1,now())>
		</cfif>
		
		<!--- check to see if this should be a soft reference --->
		<cfif arguments.isSoft>
			<!--- create the soft reference --->
			<cfset cacheData.object = createObject( "java", "java.lang.ref.SoftReference" ).init( arguments.obj ) />
		<cfelse>
			<!--- assign object to main collection --->
			<cfset cacheData.object =arguments.obj>
		</cfif>
		
		<!--- assign object to main collection --->
		<cfset variables.collection.put( hashedKey, cacheData ) />

	</cffunction>
	
	<cffunction name="size" access="public" returntype="numeric" output="false">
		<cfreturn variables.map.size() />
	</cffunction>
	
	<cffunction name="keyExists" access="public" returntype="boolean" output="false">
		<cfargument name="key">
		<cfreturn structKeyExists( variables.collection , arguments.key ) />
	</cffunction>
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="key" type="string" required="true" />

		<cfset var refLocal = structnew() />
		<cfset var hashLocal=getHashKey( arguments.key ) />
		<cfset var cacheData=""/>
		<cfset refLocal.tmpObj=0 />
		
		<!--- Check for Object in Cache. --->
		<cfif keyExists( hashLocal ) >
			<cfset cacheData=variables.collection.get( hashLocal )>
			<cfif cacheData.expires gt now()>
				<cfif isSoftReference( cacheData.object ) >
					<cfset refLocal.tmpObj =cacheData.object.get() />
					<cfreturn structKeyExists(refLocal, "tmpObj") />
				</cfif>
				<cfreturn true />
			<cfelse>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfreturn false />
		</cfif>	
		
	</cffunction>

	<!--- *************************--->
	<!--- PURGE --->
	<!--- *************************--->
	<cffunction name="purgeAll" access="public" returntype="void" output="false">
		<cfset variables.collections = createObject( "java", "java.util.Collections" ) />
		<cfset variables.collection = "" />
		<cfset variables.map = createObject( "java", "java.util.HashMap" ).init() />
		<cfset init()/>
	</cffunction>
	<cffunction name="purge" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<!--- check to see if the id exists --->
		<cfif variables.map.containsKey( getHashKey( arguments.key ) )>
			<!--- delete from map --->
			<cfset variables.map.remove( getHashKey( arguments.key ) ) />
		</cfif>
	</cffunction>

	<!--- *************************--->
	<!--- JAVALOADER --->
	<!--- *************************--->
	<cffunction name="setJavaLoader" access="public" returntype="void" output="false">
		<cfargument name="javaLoader" type="any" required="true" />
		<cfset variables.javaLoader = arguments.javaLoader />
	</cffunction>
	<cffunction name="getJavaLoader" access="public" returntype="any" output="false">
		<cfreturn variables.javaLoader />
	</cffunction>
	
	<!--- *************************--->
	<!--- SOFT REFERENCE --->
	<!--- *************************--->
	<cffunction name="isSoftReference" access="private" returntype="boolean" output="false" >
		<cfargument name="obj" type="any" required="true" />
		<cfif isdefined("arguments.obj") and isObject( arguments.obj ) AND variables.utility.checkForInstanceOf( arguments.obj, "java.lang.ref.SoftReference")>
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>
	
	<cffunction name="getCollection" output="false">
		<cfreturn variables.collection/>
	</cffunction>

</cfcomponent>