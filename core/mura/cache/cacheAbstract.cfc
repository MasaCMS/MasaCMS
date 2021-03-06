<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" extends="mura.cfobject" hint="This provide basic factory methods for cache factories">

	<cfset variables.parent = "" />
	<cfset variables.javaLoader = "" />
	<!--- main collection --->
	<cfset variables.collections = "" />
	<cfset variables.collection = "" />
	<cfset variables.map = "" />
	<cfset variables.utility="">
	<!--- default variables --->

	<cffunction name="init" output="false">

		<cfset variables.collections = createObject( "java", "java.util.Collections" ) />
		<cfset variables.collection = "" />
		<cfset variables.map = createObject( "java", "java.util.HashMap" ).init() />
		<cfset variables.utility=application.utility>
		<!--- set the map into the collections --->
		<!---
		<cfset setCollection( variables.collections.synchronizedMap( variables.map ) ) />
		--->

		<cfset setCollection( variables.map ) />

		<cfreturn this />
	</cffunction>

	<!--- *************************--->
	<!--- GLOBAL --->
	<!--- *************************--->
	<!---
	<cffunction name="configure" output="false">
	</cffunction>
	--->

	<cffunction name="getHashKey" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfreturn hash( arguments.key, "MD5" ) />
	</cffunction>

	<cffunction name="setParent" output="false">
		<cfargument name="parent" required="true" />
		<cfset variables.parent = arguments.parent />
	</cffunction>

	<cffunction name="getParent" output="false">
		<cfreturn variables.parent />
	</cffunction>
	<cffunction name="hasParent" returntype="boolean" output="false">
		<cfreturn isObject( variables.parent ) />
	</cffunction>

	<cffunction name="setCollection" access="private" output="false">
		<cfargument name="collection" type="struct" required="true" />
		<cfset variables.collection = arguments.collection />
	</cffunction>

	<!--- *************************--->
	<!--- COMMON --->
	<!--- *************************--->
	<cffunction name="get" output="false">
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

	<cffunction name="getAll" output="false">
		<cfreturn variables.collection />
	</cffunction>

	<cffunction name="set" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="obj" type="any" required="true" />
		<cfargument name="isSoft" type="boolean" required="false" default="false" />
		<cfargument name="timespan" required="false" default="">

		<cfset var softRef = "" />
		<cfset var hashedKey = getHashKey( arguments.key ) />
		<cfset var cacheData=structNew()>

		<cfif arguments.timespan neq ''>
			<cfset cacheData.expires=now() + arguments.timespan>
		<cfelse>
			<cfset cacheData.expires=dateAdd("yyyy",1,now()) + 0>
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

	<cffunction name="size" output="false">
		<cfreturn variables.map.size() />
	</cffunction>

	<cffunction name="keyExists" returntype="boolean" output="false">
		<cfargument name="key">
		<cfreturn isStruct( variables.collection ) and structKeyExists( variables.collection , arguments.key ) />
	</cffunction>

	<cffunction name="has" returntype="boolean" output="false">
		<cfargument name="key" type="string" required="true" />

		<cfset var refLocal = structnew() />
		<cfset var hashLocal=getHashKey( arguments.key ) />
		<cfset var cacheData=""/>
		<cfset refLocal.tmpObj=0 />

		<!--- Check for Object in Cache. --->
		<cfif keyExists( hashLocal ) >
			<cfset cacheData=variables.collection.get( hashLocal )>
			<cfif isNumeric(cacheData.expires) and cacheData.expires gt (now() + 0)>
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
	<cffunction name="purgeAll" output="false">
		<cfset variables.collections = createObject( "java", "java.util.Collections" ) />
		<cfset variables.collection = "" />
		<cfset variables.map = createObject( "java", "java.util.HashMap" ).init() />
		<cfset init()/>
	</cffunction>
	<cffunction name="purge" output="false">
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
	<cffunction name="setJavaLoader" output="false">
		<cfargument name="javaLoader" type="any" required="true" />
		<cfset variables.javaLoader = arguments.javaLoader />
	</cffunction>
	<cffunction name="getJavaLoader" output="false">
		<cfreturn variables.javaLoader />
	</cffunction>

	<!--- *************************--->
	<!--- SOFT REFERENCE --->
	<!--- *************************--->
	<cffunction name="isSoftReference" access="private" returntype="boolean" output="false">
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
