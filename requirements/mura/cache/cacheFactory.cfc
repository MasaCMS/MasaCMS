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

Modification History:
01/18/2007 - Created


----------------------------------------------------------------------->
<cfcomponent output="false" extends="mura.Factory">
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="isSoft" type="boolean" required="true" default="true"/>
		<cfscript>
			var Collections = createObject("java", "java.util.Collections");
			/* Create the reference maps */
			var Map = CreateObject("java","java.util.HashMap").init();
			var SoftRefKeyMap = CreateObject("java","java.util.HashMap").init();
			
			variables.isSoft=arguments.isSoft;
			/* Prepare instance */
			variables.instance = structnew();
			
			/* Instantiate object pools */
			setpool( Collections.synchronizedMap( Map ) );
			setSoftRefKeyMap( Collections.synchronizedMap(SoftRefKeyMap) );
			
			/* Register the reference queue for our soft references */
			setReferenceQueue( CreateObject("java","java.lang.ref.ReferenceQueue").init() );
			
			/* Return pool */
			return this;
		</cfscript>
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
		<cfreturn getFromPool( hashKey) />

	</cffunction>
	
	<cffunction name="has" access="public" output="false" returntype="boolean" hint="Check if an object is in cache, it doesn't tell you if the soft reference expired or not">
		<!--- ************************************************************* --->
		<cfargument name="objectKey" type="any" required="true">
		<!--- ************************************************************* --->
		<cfset var refLocal = structnew()>
		<cfset var hashLocal=getHashKey(arguments.objectKey) >
		<!--- Check for Object in Cache. --->
		<cfif structKeyExists(variables.collection, hashLocal)>
			<cfset refLocal[hashLocal]=variables.collection[hashLocal]>
			<cfreturn structKeyExists(refLocal, hashLocal) >
		<cfelse>
			<cfreturn false>
		</cfif>		
	</cffunction>
	
	<cffunction name="lookup" access="public" output="false" returntype="boolean" hint="Check if an object is in cache, it doesn't tell you if the soft reference expired or not">
		<!--- ************************************************************* --->
		<cfargument name="objectKey" type="any" required="true">
		<!--- ************************************************************* --->
		<!--- Check for Object in Cache. --->
		<cfreturn structKeyExists(variables.collection, arguments.objectKey) >
	</cffunction>
	
	<cffunction name="getFromPool" access="public" output="false" returntype="any" hint="Get an object from cache. If its a soft reference object it might return a null value.">
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
	<cffunction name="setpool" access="private" returntype="void" output="false" hint="Set the cache pool">
		<cfargument name="pool" type="struct" required="true">
		<cfset variables.collection = arguments.pool>
	</cffunction>

	<!--- Set the reference queue --->
	<cffunction name="setReferenceQueue" access="private" output="false" returntype="void" hint="Set ReferenceQueue">
		<cfargument name="ReferenceQueue" type="any" required="true"/>
		<cfset variables.ReferenceQueue = arguments.ReferenceQueue/>
	</cffunction>
	
	<!--- Set the soft ref key map --->
	<cffunction name="setSoftRefKeyMap" access="private" output="false" returntype="void" hint="Set SoftRefKeyMap">
		<cfargument name="SoftRefKeyMap" type="any" required="true"/>
		<cfset variables.SoftRefKeyMap = arguments.SoftRefKeyMap/>
	</cffunction>
	
	<!--- Create a soft referenec --->
	<cffunction name="createSoftReference" access="private" returntype="any" hint="Create SR, register cached object and reference" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="objectKey" type="any"  	required="true" hint="The value of the key pair">
		<cfargument name="MyObject"	 type="any" 	required="true" hint="The object to wrap">
		<!--- ************************************************************* --->
		<cfscript>
			/* Create Soft Reference Wrapper and register with Queue */
			var softRef = CreateObject("java","java.lang.ref.SoftReference").init(arguments.MyObject,getReferenceQueue());
			var RefKeyMap = getSoftRefKeyMap();
			
			/* Create Reverse Mapping */
			RefKeyMap[softRef] = arguments.objectKey;
			
			/* Return object */
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
	
		<!--- Get/Set the Ref Queue --->
	<cffunction name="getReferenceQueue" access="public" output="false" returntype="any" hint="Get ReferenceQueue">
		<cfreturn variables.ReferenceQueue/>
	</cffunction>	
	
	<!--- Get/Set Soft Reference KeyMap --->
	<cffunction name="getSoftRefKeyMap" access="public" output="false" returntype="any" hint="Get SoftRefKeyMap">
		<cfreturn variables.SoftRefKeyMap/>
	</cffunction>	
		
	<!--- Check if the soft reference exists --->
	<cffunction name="softRefLookup" access="public" returntype="boolean" hint="See if the soft reference is in the key map" output="false" >
		<cfargument name="softRef" required="true" type="any" hint="The soft reference to check">
		<cfreturn structKeyExists(getSoftRefKeyMap(),arguments.softRef)>
	</cffunction>
</cfcomponent>