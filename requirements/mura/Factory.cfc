<cfcomponent output="false" extends="mura.cfobject">

	<cfset variables.parent = "" />
	<cfset variables.javaLoader = "" />
	<!--- main collection --->
	<cfset variables.collections = createObject( "java", "java.util.Collections" ) />
	<cfset variables.collection = "" />
	<cfset variables.map = createObject( "java", "java.util.HashMap" ).init() />
	<!--- default variables --->

	<cffunction name="init" access="public" returntype="mura.Factory" output="false">
		
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
			<cfset cacheData=variables.collection.get( getHashKey( arguments.key ) )>
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
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="key" type="string" required="true" />

		<cfset var refLocal = structnew() />
		<cfset var hashLocal=getHashKey( arguments.key ) />
		<cfset var cacheData=""/>
		<cfset refLocal.tmpObj=0 />
		
		<!--- Check for Object in Cache. --->
		<cfif structKeyExists( variables.collection , hashLocal ) >
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
		<cfif isObject( arguments.obj ) AND getMetaData( arguments.obj ).name EQ "java.lang.ref.SoftReference">
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>

</cfcomponent>