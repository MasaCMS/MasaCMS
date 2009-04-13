<!-----------------------------------------------------------------------
BASED ON : COLDBOX.SYSTEM.CACHE.OBJECTPOOL
EDITED FOR MURA SPEIFIC USE BY BLUERIVER

ORIGINAL LICENSE:
********************************************************************************
Copyright 2005-2008 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author 	    :	Luis Majano
Date        :	January 18, 2007
Description :
	This is an object cache pool.
----------------------------------------------------------------------->
<cfcomponent output="false" extends="mura.Factory">
	<cfset variables.isSoft=true>
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="isSoft" type="boolean" required="true" default="true"/>
		<cfscript>
			var Collections = createObject("java", "java.util.Collections");
			/* Create the reference maps */
			var Map = CreateObject("java","java.util.HashMap").init();
			
			variables.isSoft=arguments.isSoft;
			/* Prepare instance */
			variables.instance = structnew();
			
			/* Instantiate object pools */
			setcollection( Collections.synchronizedMap( Map ) );
		
			/* Return pool */
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="purgeAll" access="public" returntype="void" output="false">
		<cfset init(variables.isSoft)>
	</cffunction>

	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="context" type="any" required="false" />
		<cfset var hashKey = getHashKey( arguments.key ) />
		
		<!--- if the key cannot be found and context is passed then push it in --->
		<cfif NOT has( arguments.key ) AND isDefined("arguments.context")>
			<!--- create object --->
			<cfset set(hashKey,arguments.context) />
		</cfif>
		
		<!--- if the key cannot be found then throw an error --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="Context not found for '#arguments.key#'" />
		</cfif>

		<!--- return cached context --->		
		<cfreturn getFromCache( hashKey) />

	</cffunction>
	
	<cffunction name="has" access="public" output="false" returntype="boolean" hint="Check if an object is in cache, it doesn't tell you if the soft reference expired or not">
		<!--- ************************************************************* --->
		<cfargument name="objectKey" type="any" required="true">
		<!--- ************************************************************* --->
		<cfset var refLocal = structnew()>
		<cfset var hashLocal=getHashKey(arguments.objectKey) >
		<cfset reLocal.tmpObj=0 >
		
		<!--- Check for Object in Cache. --->
		<cfif structKeyExists(variables.collection, hashLocal)>
			<cfset refLocal.tmpObj=getFromCache(hashLocal)>
			<cfreturn structKeyExists(refLocal, "tmpObj") >
		<cfelse>
			<cfreturn false>
		</cfif>		
	</cffunction>
	
	<cffunction name="getFromCache" access="public" output="false" returntype="any" hint="Get an object from cache. If its a soft reference object it might return a null value.">
		<!--- ************************************************************* --->
		<cfargument name="objectKey" type="any" required="true">
		<!--- ************************************************************* --->
		<cfscript>
			var tmpObj = 0;
			
			/* Get Object */
			tmpObj = variables.collection[arguments.objectKey];
			
			/* Validate if SR or eternal */
			if( isSoftReference(tmpObj) ){
				return tmpObj.get();
			}
			else{
				return tmpObj;
			}
		</cfscript>
	</cffunction>

	<cffunction name="set" access="public" output="false" returntype="void" hint="sets an object in cache.">
		<!--- ************************************************************* --->
		<cfargument name="objectKey" 			type="any"  required="true">
		<cfargument name="MyObject"				type="any" 	required="true">
		<!--- ************************************************************* --->
		<cfscript>
			
			var targetObj = 0;
			
			if(variables.isSoft){
				/* Check for eternal object */
				targetObj = createSoftReference(arguments.objectKey,arguments.MyObject);
				
				/* Set new Object into cache pool */
				variables.collection[arguments.objectKey] = targetObj;
			
			} else {
				variables.collection[arguments.objectKey] = arguments.myObject;
			}
		
		</cfscript>
	</cffunction>

	<!--- Set the object pool --->
	<cffunction name="setCollection" access="private" returntype="void" output="false" hint="Set the cache pool">
		<cfargument name="collection" type="struct" required="true">
		<cfset variables.collection = arguments.collection>
	</cffunction>

	
	<!--- Create a soft referenec --->
	<cffunction name="createSoftReference" access="private" returntype="any" hint="Create SR, register cached object and reference" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="objectKey" type="any"  	required="true" hint="The value of the key pair">
		<cfargument name="MyObject"	 type="any" 	required="true" hint="The object to wrap">
		<!--- ************************************************************* --->
		<cfscript>
			/* Create Soft Reference Wrapper and register with Queue */
			var softRef = CreateObject("java","java.lang.ref.SoftReference").init(arguments.MyObject);
			return softRef;
		</cfscript>
	</cffunction>
	
	<!--- Check if this is a soft referene --->
	<cffunction name="isSoftReference" access="private" returntype="boolean" hint="Whether the passed object is a soft reference" output="false" >
		<cfargument name="MyObject"	 type="any" required="true" hint="The object to test">
		<cfscript>
			if( isObject(arguments.myObject) and getMetaData(arguments.MyObject).name eq "java.lang.ref.SoftReference" ){
				return true;
			}
			else{
				return false;
			}			
		</cfscript>
	</cffunction>
	
</cfcomponent>