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
 * This provides base iterating functionality to all entities
 */
component extends="mura.iterator.queryIterator" output="false" hint="This provides base iterating functionality to all entities" {
	variables.entityName="bean";

	public function init() output=false {
		super.init();
		return this;
	}

	public function setEntityName(entityName) output=false {
		if ( len(arguments.entityName) ) {
			variables.entityName=arguments.entityName;
		}
		return this;
	}

	public function getEntityName() output=false {
		return variables.entityName;
	}

	public function packageRecord(recordIndex="#currentIndex()#") output=false {
		var bean="";
		if ( isQuery(variables.records) ) {
			return getBean(variables.entityName).set(queryRowToStruct(variables.records,arguments.recordIndex)).setIsNew(0);
		} else if ( isArray(variables.records) ) {
			bean=variables.records[arguments.recordIndex];
			if ( isObject(bean) ) {
				return bean;
			} else {
				return getBean(variables.entityName).set(bean);
			}
		} else {
			throw( message="The records have not been set." );
		}
	}

	public function getBeanArray() output=false {
		var array=arrayNew(1);
		var record = "";
		if ( isArray(variables.records) ) {
			for ( record in variables.records ) {
				arrayAppend(array,packageRecord(record));
			}
			return array;
		} else if ( isQuery(variables.records) ) {

			if(variables.records.recordcount){
				for(var i=1;i<=variables.records.recordcount;i++){
					arrayAppend(array,packageRecord(i));
				}
			}

			return array;
		} else {
			throw( message="The records have not been set." );
		}
	}

}
