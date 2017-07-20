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
 /tasks/
 /config/
 /core/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
/**
 * This provide basic factory methods for cache factories
 */
component output="false" extends="mura.cfobject" hint="This provide basic factory methods for cache factories" {
	variables.parent = "";
	variables.javaLoader = "";
	//  main collection
	variables.collections = "";
	variables.collection = "";
	variables.map = "";
	variables.utility="";
	//  default variables

	public function init() output=false {
		variables.collections = createObject( "java", "java.util.Collections" );
		variables.collection = "";
		variables.map = createObject( "java", "java.util.HashMap" ).init();
		variables.utility=application.utility;
		//  set the map into the collections
		setCollection( variables.collections.synchronizedMap( variables.map ) );
		return this;
	}
	//  *************************
	//  GLOBAL
	//  *************************

	public function getHashKey(required string key) output=false {
		return hash( arguments.key, "MD5" );
	}

	public function setParent(required parent) output=false {
		variables.parent = arguments.parent;
	}

	public function getParent() output=false {
		return variables.parent;
	}

	public boolean function hasParent() output=false {
		return isObject( variables.parent );
	}

	private function setCollection(required struct collection) output=false {
		variables.collection = arguments.collection;
	}
	//  *************************
	//  COMMON
	//  *************************

	public function get(required string key) output=false {
		var hashedKey = getHashKey( arguments.key );
		var cacheData=structNew();
		//  check to see if the item is in the parent
		//  only if a parent is present
		if ( !has( arguments.key ) && hasParent() && getParent().has( arguments.key ) ) {
			return getParent().get( arguments.key );
		}
		//  check to make sure the key exists within the factory collection
		if ( has( arguments.key ) ) {
			//  if it's a soft reference then do a get against the soft reference
			cacheData=variables.collection.get( hashedKey );
			if ( isSoftReference( cacheData.object ) ) {
				//  is it still a soft reference
				//  if so then return it
				return cacheData.object.get();
			} else {
				//  return the object from the factory collection
				return cacheData.object;
			}
		}
		throw( message="Key '#arguments.key#' was not found within the map collection" );
	}

	public function getAll() output=false {
		return variables.collection;
	}

	public function set(required string key, required any obj, boolean isSoft="false", timespan="") output=false {
		var softRef = "";
		var hashedKey = getHashKey( arguments.key );
		var cacheData=structNew();
		if ( arguments.timespan != '' ) {
			cacheData.expires=now() + arguments.timespan;
		} else {
			cacheData.expires=dateAdd("yyyy",1,now()) + 0;
		}
		//  check to see if this should be a soft reference
		if ( arguments.isSoft ) {
			//  create the soft reference
			cacheData.object = createObject( "java", "java.lang.ref.SoftReference" ).init( arguments.obj );
		} else {
			//  assign object to main collection
			cacheData.object =arguments.obj;
		}
		//  assign object to main collection
		variables.collection.put( hashedKey, cacheData );
	}

	public function size() output=false {
		return variables.map.size();
	}

	public boolean function keyExists(key) output=false {
		return structKeyExists( variables.collection , arguments.key );
	}

	public boolean function has(required string key) output=false {
		var refLocal = structnew();
		var hashLocal=getHashKey( arguments.key );
		var cacheData="";
		refLocal.tmpObj=0;
		//  Check for Object in Cache.
		if ( keyExists( hashLocal ) ) {
			cacheData=variables.collection.get( hashLocal );
			if ( isNumeric(cacheData.expires) && cacheData.expires > (now() + 0) ) {
				if ( isSoftReference( cacheData.object ) ) {
					refLocal.tmpObj =cacheData.object.get();
					return structKeyExists(refLocal, "tmpObj");
				}
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	//  *************************
	//  PURGE
	//  *************************

	public function purgeAll() output=false {
		variables.collections = createObject( "java", "java.util.Collections" );
		variables.collection = "";
		variables.map = createObject( "java", "java.util.HashMap" ).init();
		init();
	}

	public function purge(required string key) output=false {
		//  check to see if the id exists
		if ( variables.map.containsKey( getHashKey( arguments.key ) ) ) {
			//  delete from map
			variables.map.remove( getHashKey( arguments.key ) );
		}
	}
	//  *************************
	//  JAVALOADER
	//  *************************

	public function setJavaLoader(required any javaLoader) output=false {
		variables.javaLoader = arguments.javaLoader;
	}

	public function getJavaLoader() output=false {
		return variables.javaLoader;
	}
	//  *************************
	//  SOFT REFERENCE
	//  *************************

	private boolean function isSoftReference(required any obj) output=false {
		if ( isdefined("arguments.obj") && isObject( arguments.obj ) && variables.utility.checkForInstanceOf( arguments.obj, "java.lang.ref.SoftReference") ) {
			return true;
		}
		return false;
	}

	public function getCollection() output=false {
		return variables.collection;
	}

}
