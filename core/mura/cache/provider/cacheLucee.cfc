/*This file is part of Mura CMS.

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
component extends="mura.cfobject" output="false" hint="This is used by advanced caching to interact with CFML service" {
	property name="cacheName"
		type="string"
		getter="true"
		setter="true"
		default="data"
		hint="The name of the cache.";

	public any function init(name,siteid){

		var cachePrefix=getBean('configBean').get('AdvancedCachePrefix');

		variables.cacheName=arguments.siteID & "-" &arguments.name;
		
		if(len(cachePrefix)){
			variables.cacheName=cachePrefix & "-" & variables.cacheName;
		}

		/*
    	if(!cacheRegionExists(variables.cacheName) ) {
			cacheRegionNew(variables.cacheName);
		}
		*/

		return this;
	}

	public any function get(key){
		return cacheGet(id=arguments.key,throwWhenNotExist=true,cacheName=variables.cacheName);
	}

	public any function getAll(){
		return cacheGetAll(filter="", cacheName=variables.cacheName);
	}

	public any function put(key,value,timespan=1,idleTime=1){

		if(arguments.timespan eq ""){
			arguments.timespan=CreateTimeSpan(1,0,0,0);
		} else if (arguments.timespan < 1000){
			arguments.timespan=CreateTimeSpan(arguments.timespan,0,0,0);
		}

		if(arguments.idleTime eq ""){
			arguments.idleTime=CreateTimeSpan(1,0,0,0);
		} else if (arguments.idleTime < 1000){
			arguments.idleTime=CreateTimeSpan(arguments.idleTime,0,0,0);
		}

		cachePut(id=arguments.key,
			value=arguments.value,
			timespan=arguments.timespan,
			idleTime=arguments.idleTime,
			cacheName=variables.cacheName
		);
	}

	public any function has(key){
		return cacheKeyExists(key,variables.cacheName);
	}

	public any function purge(key){
		cacheRemove(ids=arguments.key,cacheName=variables.cacheName);
	}

	public any function purgeAll(){
		cacheClear("",variables.cacheName);
	}

	public any function size(){
		return cacheCount(variables.cacheName);
	}

}
