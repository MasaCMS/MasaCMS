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
 * This provides category bean functionality
 */
component extends="mura.bean.bean" entityName="category" table="tcontentcategories" output="false" hint="This provides category bean functionality" {
	property name="categoryID" fieldtype="id";
	property name="kids" fieldtype="one-to-many" cfc="category" loadkey="parentid" nested=true orderby="name asc" cascade="delete";
	property name="parent" fieldtype="many-to-one" cfc="category" fkcolumn="parentid" loadkey="categoryid" renderfield="name";
	property name="contentAssignments" fieldtype="one-to-many" cfc="contentCategoryAssign";
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid";
	property name="dateCreated" type="date" default="";
	property name="lastUpdate" type="date" default="";
	property name="lastUpdateBy" type="string" default="";
	property name="name" type="string" default="" required="true";
	property name="isInterestGroup" type="numeric" default="1" required="true";
	property name="isActive" type="numeric" default="1" required="true";
	property name="isOpen" type="numeric" default="1";
	property name="note" type="string" default="";
	property name="sortBy" type="string" default="orderno" required="true";
	property name="sortDirection" type="string" default="asc" required="true";
	property name="restrictGroups" type="string" default="";
	property name="path" type="string" default="";
	property name="remoteID" type="string" default="";
	property name="remoteSourceURL" type="string" default="";
	property name="remotePubDate" type="date" default="";
	property name="URLtitle" type="string" default="";
	property name="filename" type="string" default="";
	property name="isNew" type="numeric" default="1" required="true" persistent="false";
	property name="isFeatureable" type="numeric" default="1" required="true";
	variables.primaryKey = 'categoryid';
	variables.entityName = 'category';

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.instance.categoryID="";
		variables.instance.siteID="";
		variables.instance.dateCreated="#now()#";
		variables.instance.lastUpdate="#now()#";
		variables.instance.lastUpdateBy="";
		variables.instance.name="";
		variables.instance.isInterestGroup=1;
		variables.instance.parentID="";
		variables.instance.isActive=1;
		variables.instance.isOpen=1;
		variables.instance.notes="";
		variables.instance.sortBy = "orderno";
		variables.instance.sortDirection = "asc";
		variables.instance.RestrictGroups = "";
		variables.instance.Path = "";
		variables.instance.remoteID = "";
		variables.instance.remoteSourceURL = "";
		variables.instance.remotePubDate = "";
		variables.instance.URLTitle = "";
		variables.instance.filename = "";
		variables.instance.isNew=1;
		variables.instance.isFeatureable=1;
		variables.kids = arrayNew(1);
		return this;
	}

	public function setConfigBean(configBean) {
		variables.configBean=arguments.configBean;
		return this;
	}

	public function setCategoryManager(categoryManager) {
		variables.categoryManager=arguments.categoryManager;
		return this;
	}

	public function setContentUtility(contentUtility) {
		variables.contentUtility=arguments.contentUtility;
		return this;
	}

	public function setDateCreated(String dateCreated) output=false {
		variables.instance.dateCreated = parseDateArg(arguments.dateCreated);
		return this;
	}

	public function setLastUpdate(String lastUpdate) output=false {
		variables.instance.lastUpdate = parseDateArg(arguments.lastUpdate);
		return this;
	}

	public function setlastUpdateBy(String lastUpdateBy) output=false {
		variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50);
		return this;
	}

	public function save() output=false {
		var kid="";
		var i="";
		setAllValues(variables.categoryManager.save(this).getAllValues());
		if ( arrayLen(variables.kids) ) {
			for ( i=1 ; i<=arrayLen(variables.kids) ; i++ ) {
				kid=variables.kids[i];
				kid.save();
			}
		}
		variables.kids=arrayNew(1);
		return this;
	}

	public function addChild(child) output=false {
		arguments.child.setSiteID(variables.instance.siteID);
		arguments.child.setParentID(variables.instance.categoryID);
		arrayAppend(variables.kids,arguments.child);
		return this;
	}

	public function delete() output=false {
		variables.categoryManager.delete(variables.instance.categoryID);
	}

	public function getKidsQuery(required boolean activeOnly="true", required boolean InterestsOnly="false") output=false {
		return variables.categoryManager.getCategories(variables.instance.siteID,variables.instance.categoryID,"", arguments.activeOnly, arguments.InterestsOnly);
	}

	public function getKidsIterator(required boolean activeOnly="true", required boolean InterestsOnly="false") output=false {
		var it=getBean("categoryIterator").init();
		it.setQuery(getKidsQuery(arguments.activeOnly, arguments.InterestsOnly));
		return it;
	}

	public function loadBy() output=false {
		if ( !structKeyExists(arguments,"siteID") ) {
			arguments.siteID=variables.instance.siteID;
		}
		arguments.categoryBean=this;
		return variables.categoryManager.read(argumentCollection=arguments);
	}

	public function setRemotePubDate(required string RemotePubDate) output=false {
		if ( lsisDate(arguments.RemotePubDate) ) {
			try {
				variables.instance.RemotePubDate = lsparseDateTime(arguments.RemotePubDate);
			} catch (any cfcatch) {
				variables.instance.RemotePubDate = arguments.RemotePubDate;
			}
		} else {
			variables.instance.RemotePubDate = "";
		}
		return this;
	}

	public function setURLTitle(required string URLTitle) output=false {
		if ( arguments.URLTitle != variables.instance.URLTitle ) {
			variables.instance.URLTitle = variables.contentUtility.formatFilename(arguments.URLTitle);
		}
		return this;
	}

	public function setFilename(required string filename) output=false {
		variables.instance.filename = left(trim(arguments.filename),255);
		return this;
	}

	public function setIsFeatureable(IsFeatureable) output=false {
		if ( isNumeric(arguments.IsFeatureable) ) {
			variables.instance.IsFeatureable = arguments.IsFeatureable;
		}
		return this;
	}

	public function getParent() output=false {
		return getBean('category').loadBy(categoryID=variables.instance.parentID, siteid=variables.instance.siteID );
	}

	public function getCrumbQuery(required sort="asc") output=false {
		return variables.categoryManager.getCrumbQuery( variables.instance.path, variables.instance.siteID, arguments.sort);
	}

	public function getCrumbIterator(required sort="asc") output=false {
		var rs=getCrumbQuery(arguments.sort);
		var it=getBean("categoryIterator").init();
		it.setQuery(rs);
		return it;
	}

	public function getEditUrl(required any compactDisplay="false") output=false {
		var returnStr="";
		returnStr= "#variables.configBean.getAdminPath()#/?muraAction=cCategory.edit&categoryID=#esapiEncode('url',variables.instance.categoryID)#&parentID=#esapiEncode('url',variables.instance.parentID)#&siteid=#esapiEncode('url',variables.instance.siteID)#&compactDisplay=#esapiEncode('url',arguments.compactdisplay)#";
		return returnStr;
	}

	public function hasParent() output=false {
		return listLen(variables.instance.path) > 1;
	}

	public function clone() output=false {
		return getBean("category").setAllValues(structCopy(getAllValues()));
	}

	public function getPrimaryKey() output=false {
		return "categoryID";
	}

}
