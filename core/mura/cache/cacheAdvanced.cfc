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
component extends="mura.cache.cacheAbstract" hint="This allows Mura to use core CFML caching" output="false" {

	public any function init(name,siteid) {
		lock name="creatingCache#arguments.name##arguments.siteid#" type="exclusive" timeout=90{
			if ( ListFindNoCase('Railo,Lucee',  server.coldfusion.productname) ) {
				variables.collection=new provider.cacheLucee(argumentCollection=arguments);
			} else {
				variables.collection=new provider.cacheAdobe(argumentCollection=arguments);
			}
			variables.map=variables.collection;
		}
		return this;
	}

	public any function set(key,context,timespan=1,idleTime=1) {
		try	{
			variables.collection.put( getHashKey( arguments.key ), arguments.context, arguments.timespan, arguments.idleTime );
		} catch(Any e){
			writeLog(type='error',text=serializeJSON(e));
			return arguments.context;
		}
	}

	public any function get(key, context, timespan=createTimeSpan(1,0,0,0), idleTime=createTimeSpan(1,0,0,0)) {
		var local.exists = has( arguments.key );

		try	{
			if ( local.exists ) {
				return variables.collection.get(getHashKey( arguments.key ));
			} else {
				if ( isDefined("arguments.context") ) {
						set( arguments.key, arguments.context,arguments.timespan,arguments.idleTime );
						return arguments.context;
				} else  if ( hasParent() && getParent().has( arguments.key ) ) {
					return getParent().get( arguments.key );
				} else {
					if ( isDefined("arguments.context") ) {
							return arguments.context;
					} else {
						throw(message="Context not found for '#arguments.key#'");
					}
				}
			}
		} catch(Any e){
			writeLog(type='error',text=serializeJSON(e));
			if ( isDefined("arguments.context") ) {
				set( arguments.key, arguments.context,arguments.timespan,arguments.idleTime );
				return arguments.context;
			} else  if ( hasParent() && getParent().has( arguments.key ) ) {
				return getParent().get( arguments.key );
			} else {
				if ( isDefined("arguments.context") ) {
						return arguments.context;
				} else {
					throw(message="Context not found for '#arguments.key#'");
				}
			}
		}		
	}

	public any function purge(key) {
		try	{
			variables.collection.purge(getHashKey( arguments.key ));
		} catch(Any e){
			writeLog(type='error',text=serializeJSON(e));
		}
	}

	public any function purgeAll() {
		try	{
			variables.collection.purgeAll();
		} catch(Any e){
			writeLog(type='error',text=serializeJSON(e));
		}	
	}

	public any function getAll() {
		try	{
			return variables.collection.getAll();
		} catch(Any e){
			writeLog(type='error',text=serializeJSON(e));
			return [];
		}	
	}

	public any function has(key) {
		try	{
			if ( isDefined('request.purgeCache') && yesNoFormat(request.purgeCache)) {
				return false;
			}
			return variables.collection.has(getHashKey( arguments.key ) );
		} catch(Any e){
			writeLog(type='error',text=serializeJSON(e));
			return false;
		}	
		
	}

	public any function getCollection() {
		return variables.collection;
	}

}
