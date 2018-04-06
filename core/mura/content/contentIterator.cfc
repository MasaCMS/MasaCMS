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
 * This provides content iterating functionality
 */
component extends="mura.iterator.queryIterator" output="false" hint="This provides content iterating functionality" {
	variables.content="";
	variables.recordIDField="contenthistid";

	public function getEntityName() output=false {
		return "content";
	}

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.content=getBean("contentNavBean");
		return this;
	}

	public function packageRecord() output=false {
		var item="";
		if ( isQuery(variables.records) ) {
			item=queryRowToStruct(variables.records,currentIndex());
		} else if ( isArray(variables.records) ) {
			item=variables.records[currentIndex()];
		} else {
			throw( message="The records have not been set." );
		}
		variables.content=getBean("contentNavBean").set(item,this);
		return variables.content;
	}

	public function getRecordIdField() output=false {
		if ( isArray(variables.records) ) {
			if ( arrayLen(variables.records) && structKeyExists(variables.records[1],'contenthistid') ) {
				return "contenthistid";
			} else {
				return "contentid";
			}
		} else {
			if ( isdefined("variables.records.contenthistid") ) {
				return "contenthistid";
			} else {
				return "contentid";
			}
		}
	}

	public function buildQueryFromList(idList, siteid, required idType="contentID") output=false {
		var i="";
		var idArray=listToArray(arguments.idList);
		variables.records=queryNew("#arguments.idType#,siteID","VARCHAR,VARCHAR");
		for ( i=1 ; i<=arrayLen(idArray) ; i++ ) {
			QueryAddRow(variables.records);
			QuerySetCell(variables.records, arguments.idType, idArray[i]);
			QuerySetCell(variables.records, 'siteID',arguments.siteid);
		}
		variables._recordcount=variables.records.recordcount;
		variables.maxRecordsPerPage=variables.records.recordcount;
		variables.recordIndex = 0;
		variables.pageIndex = 1;
		return this;
	}

}
