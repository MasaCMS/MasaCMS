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
 * This cache store items in java soft references
 */
component output="false" extends="mura.cache.cacheAbstract" hint="This cache store items in java soft references" {
	variables.isSoft=true;

	/**
	 * Constructor
	 */
	public function init(required boolean isSoft="true", required numeric freeMemoryThreshold="0") output=false {

		super.init( argumentCollection:arguments );
			variables.isSoft = arguments.isSoft;
			variables.freeMemoryThreshold=arguments.freeMemoryThreshold;
			return this;
	}

	public function set(required string key, any context, boolean isSoft="#variables.isSoft#", timespan="") output=false {
		super.set(arguments.key,arguments.context,arguments.isSoft,arguments.timespan);
	}

	public function get(required string key, any context, boolean isSoft="#variables.isSoft#", timespan="") output=false {
		var hashKey = getHashKey( arguments.key );
		//  if the key cannot be found and context is passed then push it in
		if ( !has( arguments.key ) && isDefined("arguments.context") ) {
			if ( hasFreeMemoryAvailable() ) {
				//  create object
				set( arguments.key, arguments.context, arguments.isSoft, arguments.timespan );
			} else {
				return arguments.context;
			}
		}
		//  if the key cannot be found then throw an error
		if ( !has( arguments.key ) ) {
			throw( message="Context not found for '#arguments.key#'" );
		}
		//  return cached context
		return super.get( arguments.key );
	}

	public boolean function hasFreeMemoryAvailable() output=false {
		if ( variables.freeMemoryThreshold ) {
			if ( getPercentFreeMemory() > variables.freeMemoryThreshold ) {
				return true;
			} else {
				return false;
			}
		} else {
			return true;
		}
	}

	public function getPercentFreeMemory() output=false {
		if ( !structKeyExists(request,"percentFreeMemory") ) {
			var runtime = getJavaRuntime();
			var usedMemory=runtime.totalMemory() - Runtime.freeMemory();
			request.percentFreeMemory=(Round((1-(usedMemory / runtime.maxMemory())) * 100));
		}
		return request.percentFreeMemory;
	}

	public function getJavaRuntime() output=false {
		if ( !structKeyExists(application,"javaRuntime") ) {
			application.javaRuntime=createObject("java","java.lang.Runtime").getRuntime();
		}
		return application.javaRuntime;
	}

}
