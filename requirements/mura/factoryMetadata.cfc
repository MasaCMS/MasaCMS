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
<cfcomponent output="false" extends="mura.Factory">

	<!--- metadata collection --->
	<cfset variables.metadataMap = {} />
	<!--- default variables --->
	<cfset variables.defaultCacheTimeout = 0 /> <!--- minutes --->
	<cfset variables.isSoft=true />
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="isSoft" type="boolean" required="true" default="true"/>
		<cfscript>
			super.init( argumentCollection:arguments );
			
			// set isSoft variable
			variables.isSoft = arguments.isSoft;
			
			return this;
		</cfscript>
	</cffunction>
	
	<!--- *************************--->
	<!--- COMMON --->
	<!--- *************************--->
	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashedKey = getHashKey( arguments.key ) />
		
		<!--- check to see if the item is in the parent --->
		<!--- only if a parent is present --->
		<cfif NOT has( arguments.key ) AND hasParent() AND getParent().has( arguments.key )>
			<cfreturn getParent().get( arguments.key ) />
		</cfif>
		
		<!--- attempt purge by timeout --->
		<cfset purgeByTimeout( arguments.key ) />
		
		<!--- check to make sure the key exists within the factory collection --->
		<cfif has( arguments.key )>
			<!--- get object metadata --->
			<!--- ping meta --->
			<cfset getObjectMetadata( arguments.key ).hits = getObjectMetadata( arguments.key ).hits+1 />
			<cfset getObjectMetadata( arguments.key ).lastAccessed = now() />
			
			<!--- if it's a soft reference then do a get against the soft reference --->
			<cfif getObjectMetadata( arguments.key ).isSoftReference>
				<!--- is it still a soft reference --->
				<!--- if so then return it --->
				<cfif isSoftReference( variables.collection.get( getHashKey( arguments.key ) ) )>
					<cfreturn variables.collection.get( getHashKey( arguments.key ) ).get() />
				</cfif>
			<cfelse>
				<!--- return the object from the factory collection --->
				<cfreturn variables.collection.get( getHashKey( arguments.key ) ) />
			</cfif>
		</cfif>

		<cfthrow message="Key '#arguments.key#' was not found within the map collection" />

	</cffunction>
	
	<cffunction name="set" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="obj" type="any" required="true" />
		<cfargument name="isSoft" type="boolean" required="false" default="#variables.isSoft#" />
		<cfargument name="timeout" type="numeric" required="false" default="#getDefaultCacheTimeout()#" />
		<cfargument name="timeoutBy" type="string" required="false" default="m" />
		
		<cfset var softRef = "" />
		<cfset var meta = {} />
		<cfset var hashedKey = getHashKey( arguments.key ) />
		
		<cfif arguments.timeout GTE 0>
			<!--- setup metadata --->
			<cfset meta.key = arguments.key />
			<cfset meta.hashedKey = hashedKey />
			<cfset meta.hits = 1 />
			<cfset meta.timeout = arguments.timeout />
			<cfset meta.timeoutBy = arguments.timeoutBy />
			<cfset meta.created = now() />
			<cfset meta.lastAccessed = now() />
			<cfset meta.isSoftReference = false />
			
			<!--- check to see if this should be a soft reference --->
			<cfif arguments.isSoft>
				<!--- create the soft reference --->
				<cfset softRef = createObject( "java", "java.lang.ref.SoftReference" ).init( arguments.obj ) />
				
				<!--- state that this is a soft reference --->
				<cfset meta.isSoftReference = true />
				
				<!--- assign object to main collection --->
				<cfset variables.collection.put( hashedKey, softRef ) />
			<cfelse>
				<!--- assign object to main collection --->
				<cfset variables.collection.put( hashedKey, arguments.obj ) />
			</cfif>
			
			<!--- assign meta to meta collection --->
			<cfset setObjectMetadata( arguments.key, meta ) />
			
		</cfif>
	
		<!--- run the cleanup --->
		<cfset cleanUp() />
		
	</cffunction>
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="key" type="string" required="true" />

		<!--- purge by timeout --->
		<cfset purgeByTimeout( arguments.key ) />

		<!--- returns true or false based on if the key exists within the collection --->
		<cfreturn super.has( arguments.key ) />

	</cffunction>

	<!--- *************************--->
	<!--- PURGE --->
	<!--- *************************--->
	<cffunction name="purgeAll" access="public" returntype="void" output="false">
		<cfset variables.metadataMap.clear() />
		<cfset super.purgeAll() />
	</cffunction>
	<cffunction name="purge" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<!--- attempt to purge metadata --->
		<cfif variables.metadataMap.containsKey( getHashKey( arguments.key ) )>
			<!--- delete from map --->
			<cfset variables.metadataMap.remove( getHashKey( arguments.key ) ) />
		</cfif>
		
		<!--- check to see if the id exists --->
		<cfset super.purge( arguments.key ) />
	</cffunction>
	<cffunction name="purgeByTimeout" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<!--- if the key is found within the map collection and meta collection --->
		<cfif super.has( arguments.key ) AND hasObjectMetadata( arguments.key ) AND getObjectMetadata( arguments.key ).timeout GT 0>
			<!--- check to see if the object has timed out --->
			<!--- if it has then purge it --->
			<cfif dateDiff( getObjectMetadata( arguments.key ).timeoutBy, getObjectMetadata( arguments.key ).lastAccessed, now() ) GT getObjectMetadata( arguments.key ).timeout>
				<cfset purge( arguments.key ) />
			</cfif>
		</cfif>
	</cffunction>
	<cffunction name="purgeByMetadataParamValues" access="public" returntype="void" output="false">
		
		<cfset var meta = "" />
		<cfset var param = "" />
		<cfset var entry = "" />
		<cfset var removeEntry = true />
		
		<!--- loop over the metadata collection and check the passed params. if they match then remove the entry --->
		<cfloop collection="#variables.metadataMap#" item="meta">
			<!--- reset --->
			<cfset removeEntry = true />
			
			<!--- get entry --->
			<cfset entry = variables.metadataMap.get( meta ) />
			
			<!--- loop over the passed collection --->
			<cfloop collection="#arguments#" item="param">
				<!--- if the param exists and the values match --->
				<!--- we only want to allow this if removeEntry is false. if removeEntry is false, then there is no match --->
				<cfif entry.containsKey( param ) AND entry.get( param ) IS arguments.get( param ) AND removeEntry>
					<cfset removeEntry = true />
				<cfelse>
					<cfset removeEntry = false />
				</cfif>
			</cfloop>
			
			<!--- removeEntry is true --->
			<cfif removeEntry>
				<cfset purge( entry.KEY ) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- *************************--->
	<!--- TIMEOUT --->
	<!--- *************************--->
	<cffunction name="setDefaultCacheTimeout" access="public" returntype="void" output="false">
		<cfargument name="minutes" type="numeric" required="true" />
		<cfset variables.defaultCacheTimeout = arguments.minutes />
	</cffunction>
	<cffunction name="getDefaultCacheTimeout" access="public" returntype="numeric" output="false">
		<cfreturn variables.defaultCacheTimeout />
	</cffunction>

	<!--- *************************--->
	<!--- METADATA --->
	<!--- *************************--->
	<cffunction name="getAllMetadata" access="public" returntype="any" output="false">
		<cfreturn variables.metadataMap />
	</cffunction>
	<cffunction name="setObjectMetadata" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="meta" type="any" required="true" />
		
		<cfset var hashedKey = getHashKey( arguments.key ) />
		
		<cfset variables.metadataMap.put( hashedKey, arguments.meta ) />
	</cffunction>
	<cffunction name="getObjectMetadata" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashedKey = getHashKey( arguments.key ) />
		
		<cfreturn variables.metadataMap.get( hashedKey ) />
	</cffunction>
	<cffunction name="setObjectMetadataProperty" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="prop" type="string" required="true" />
		<cfargument name="val" type="any" required="true" />
		
		<cfset var hashedKey = getHashKey( arguments.key ) />
		<cfset var meta = "" />
		
		<!--- throw an error if the key being referenced does not exist --->
		<cfif NOT has( arguments.key )>
			<cfthrow message="The key does not exist within the map" />
		</cfif>
		
		<cfset meta = getObjectMetadata( arguments.key ) />
		
		<!--- assign the property and value --->
		<cfset meta.put( arguments.prop, arguments.val ) />
	</cffunction>
	<cffunction name="getObjectMetadataProperty" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="prop" type="string" required="true" />
		
		<cfset var meta = "" />
		
		<!--- check to see if the key exists within the metadata map --->
		<cfif hasObjectMetadata( arguments.key )>
			<!--- get the metadata --->
			<cfset meta = getObjectMetadata( arguments.key ) />
			<!--- check to see if the prop exists in metadata --->
			<cfif meta.containsKey( arguments.prop )>
				<!--- return the prop val if prop is found --->
				<cfreturn meta.get( arguments.prop ) />
			</cfif>	
		</cfif>
		
		<cfthrow message="Property '#arguments.prop#' does not exist with key '#arguments.key#'" />
	</cffunction>
	<cffunction name="hasObjectMetadata" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var hashedKey = getHashKey( arguments.key ) />
		
		<cfif variables.metadataMap.containsKey( hashedKey )>
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>
	
	<!--- ******************************************** PRIVATE ******************************************** --->
	<cffunction name="cleanUp" access="private" returntype="void" output="false">
		
		<cfset var entry = "" />

		<!--- loop over metadata map --->
		<cfloop collection="#variables.metadataMap#" item="entry">
			<!--- if the map does not have the metadata key the purge it out of the metadata map --->
			<!--- or is a soft reference, the main collection has the object, the soft reference is not an object, and the java type is of java.lang.ref.SoftReference --->
			<cfif ( NOT has( variables.metadataMap.get( entry ).KEY ) ) OR ( variables.metadataMap.get( entry ).ISSOFTREFERENCE AND has( variables.metadataMap.get( entry ).KEY ) AND NOT isSoftReference( variables.collection.get( variables.metadataMap.get( entry ).HASHEDKEY ) ) )>
				<cfset purge( variables.metadataMap.get( entry ).KEY ) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="isSoftReference" access="private" returntype="boolean" output="false" >
		<cfargument name="obj" type="any" required="true" />
		<cfif isObject( arguments.obj ) AND getMetaData( arguments.obj ).name EQ "java.lang.ref.SoftReference">
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>

</cfcomponent>