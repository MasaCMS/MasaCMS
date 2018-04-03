/*  This file is part of Mura CMS.

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
*/
/**
 * This provides event handler mapping/caching functionality
 */
component extends="mura.cache.cacheAbstract" output="false" hint="This provides event handler mapping/caching functionality" {

	public function init(siteid, standardEventsHandler, pluginManager) output=false {
		variables.siteid=arguments.siteid;
		variables.standardEventsHandler=arguments.standardEventsHandler;
		variables.pluginManager=arguments.pluginManager;
		super.init();
		return this;
	}

	public function get(required string key, required localHandler="") output=false {
		var hashKey = getHashKey( arguments.key );
		var checkKey= "__check__" & arguments.key;
		var localKey=arguments.key;
		var hashCheckKey = getHashKey( checkKey );
		var rs="";
		var event="";
		var classInstance="";
		var wrappedClassInstance="";
		// If the local handler has a locally defined method then use it instead
		// if (NOT arguments.persist or NOT has( localKey )){
		if ( !has( localKey ) ) {
			if ( isObject(arguments.localHandler) && structKeyExists(arguments.localHandler, localKey) ) {
				classInstance=localHandler;
				wrappedClassInstance=wrapHandler(classInstance, localKey);
				// if (arguments.persist){
				super.set( localKey, wrappedClassInstance );
				// }
				return wrappedClassInstance;
			}
			// If there is a non plugin listener then use it instead
			classInstance=variables.pluginManager.getSiteListener(variables.siteID, localKey);
			if ( isObject(classInstance) ) {
				wrappedClassInstance=wrapHandler(classInstance, localKey);
				// if (arguments.persist){
				super.set( localKey, wrappedClassInstance );
				// }
				return wrappedClassInstance;
			}

			classInstance=variables.pluginManager.getGlobalListener(localKey);
			if ( isObject(classInstance) ) {
				wrappedClassInstance=wrapHandler(classInstance, localKey);
				// if (arguments.persist){
				super.set( localKey, wrappedClassInstance );
				// }
				return wrappedClassInstance;
			}
		}
		//  Check if the prelook for plugins has been made
		// if( NOT arguments.persist or NOT has( checkKey )){
		if ( !has( checkKey ) ) {
			rs=variables.pluginManager.getScripts(localKey, variables.siteid);
			//  If it has not then get it
			// if (arguments.persist){
			super.set( checkKey, rs.recordcount );
			// }
			if ( rs.recordcount ) {
				classInstance=variables.pluginManager.getComponent("plugins.#rs.directory#.#rs.scriptfile#", rs.pluginID, variables.siteID, rs.docache);
				wrappedClassInstance=wrapHandler(classInstance, localKey);
				// if (arguments.persist){
				super.set( localKey, wrappedClassInstance );
				// }
				return wrappedClassInstance;
			}
		}
		if ( has( localKey ) ) {
			//  It's already in cache
			return variables.collection.get( getHashKey(localKey) ).object;
		} else {
			//  return cached context
			if ( structKeyExists(variables.standardEventsHandler,localKey) ) {
				wrappedClassInstance=wrapHandler(variables.standardEventsHandler,localKey);
				super.set( localKey, wrappedClassInstance );
			} else {
				wrappedClassInstance=wrapHandler(createObject("component","mura.Translator.#localKey#").init(),localKey);
			}
			/* if (arguments.persist){
				super.set( localKey, wrappedClassInstance );
			}
			*/
			return wrappedClassInstance;
		}
	}

	public function wrapHandler(handler, eventName) output=false {
		return createObject("component","mura.plugin.pluginStandardEventWrapper").init(arguments.handler,arguments.eventName);
	}

	public boolean function has(required string key) output=false {
		return structKeyExists( variables.collection , getHashKey( arguments.key ) );
	}

}
