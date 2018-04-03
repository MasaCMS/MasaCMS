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
 * This provides the User Address ben
 */
component extends="mura.bean.beanExtendable" entityName="address" table="tuseraddresses" output="false" hint="This provides the User Address ben" {
	property name="addressID" fieldtype="id" type="string" default="";
	property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="userID";
	property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";
	property name="isPrimary" type="numeric" default="0";
	property name="address1" type="string" default="";
	property name="address2" type="string" default="";
	property name="fax" type="string" default="";
	property name="city" type="string" default="";
	property name="state" type="string" default="";
	property name="zip" type="string" default="";
	property name="phone" type="string" default="";
	property name="country" type="string" default="";
	property name="addressName" type="string" default="";
	property name="addressEmail" type="string" default="";
	property name="addressNotes" type="string" default="";
	property name="addressURL" type="string" default="";
	property name="hours" type="string" default="";
	property name="longitude" type="numeric" default="0";
	property name="latitude" type="numeric" default="0";
	property name="extendDataTable" type="string" default="tclassextenddatauseractivity";
	property name="isNew" type="numeric" default="0" persistent="false";
	variables.primaryKey = 'addressid';
	variables.entityName = 'address';
	variables.instanceName= 'addressname';

	public function init() output=false {
		super.init(argumentCollection=arguments);
		variables.instance.addressid="";
		variables.instance.userid="";
		variables.instance.siteid="";
		variables.instance.isPrimary=0;
		variables.instance.address1="";
		variables.instance.address2="";
		variables.instance.fax="";
		variables.instance.city="";
		variables.instance.state="";
		variables.instance.zip="";
		variables.instance.phone="";
		variables.instance.country="";
		variables.instance.addressID="";
		variables.instance.addressName="";
		variables.instance.addressEmail="";
		variables.instance.addressNotes="";
		variables.instance.addressURL="";
		variables.instance.hours="";
		variables.instance.longitude=0;
		variables.instance.latitude=0;
		variables.instance.errors=structnew();
		variables.instance.extendDataTable="tclassextenddatauseractivity";
		variables.instance.isNew=0;
		variables.instance.type="Address";
		variables.instance.subType="Default";
		return this;
	}

	public function setUserManager(userManager) {
		variables.userManager=arguments.userManager;
		return this;
	}

	public function setSettingsManager(settingsManager) {
		variables.settingsManager=arguments.settingsManager;
		return this;
	}

	public function setConfigBean(configBean) {
		variables.configBean=arguments.configBean;
		return this;
	}

	public function set(required property, propertyValue) output=false {
		if ( !isDefined('arguments.args') ) {
			if ( isSimpleValue(arguments.property) ) {
				return setValue(argumentCollection=arguments);
			}
			arguments.args=arguments.property;
		}
		var prop="";
		if ( isQuery(arguments.args) && arguments.args.recordcount ) {


			for(prop in listToArray(arguments.args.columnlist)){
				setValue(prop,arguments.args[prop][1]);
			}

		} else if ( isStruct(arguments.args) ) {
			for ( prop in arguments.args ) {
				setValue(prop,arguments.args[prop]);
			}
		}
		if ( isdefined('arguments.args.siteid') && trim(arguments.args.siteid) != ''
		and isdefined('arguments.args.isPublic') && trim(arguments.args.isPublic) != '' ) {
			if ( arguments.args.isPublic == 0 ) {
				setSiteID(variables.settingsManager.getSite(arguments.args.siteid).getPrivateUserPoolID());
			} else {
				setSiteID(variables.settingsManager.getSite(arguments.args.siteid).getPublicUserPoolID());
			}
		}
		return this;
	}

	public function setGeoCoding() output=false {
		var result=structNew();
		var address="";
		var googleAPIKey="";
		if ( len(variables.instance.siteID) ) {
			googleAPIKey=variables.settingsManager.getSite(variables.instance.siteID).getGoogleAPIKey();
			if ( len(googleAPIKey) ) {
				if ( len(variables.instance.address1) ) {
					address=listAppend(address,trim("#variables.instance.address1# #variables.instance.address2#"));
				}
				if ( len(variables.instance.siteID) ) {
					address=listAppend(address,variables.instance.state);
				}
				if ( len(variables.instance.country) ) {
					address=listAppend(address,variables.instance.country);
				}
				if ( len(variables.instance.city) ) {
					address=listAppend(address,variables.instance.city);
				}
				if ( len(variables.instance.zip) ) {
					address=listAppend(address,variables.instance.zip);
				}
				result = getBean("geoCoding").geocode(googleAPIKey,trim(address));
				if ( structKeyExists(result, "latitude") && structKeyExists(result, "longitude") ) {
					variables.instance.longitude=result.longitude;
					variables.instance.latitude=result.latitude;
				}
			}
		}
		return this;
	}

	public function getAddressID() output=false {
		if ( !len(variables.instance.addressID) ) {
			variables.instance.addressID = createUUID();
		}
		return variables.instance.addressID;
	}

	public function setIsPrimary(required IsPrimary) output=false {
		if ( isNumeric(arguments.IsPrimary) ) {
			variables.instance.IsPrimary = arguments.IsPrimary;
		}
		return this;
	}

	public function validate() output=false {
		var extErrors=structNew();
		if ( len(variables.instance.siteID) ) {
			extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues());
		}
		super.validate();
		if ( !structIsEmpty(extErrors) ) {
			structAppend(variables.instance.errors,extErrors);
		}
		setGeoCoding();
		return this;
	}

	public function setLongitude(required Longitude) output=false {
		if ( isNumeric(arguments.Longitude) ) {
			variables.instance.Longitude = arguments.Longitude;
		}
		return this;
	}

	public function setLatitude(required Latitude) output=false {
		if ( isNumeric(arguments.Latitude) ) {
			variables.instance.Latitude = arguments.Latitude;
		}
		return this;
	}

	public function getExtendBaseID() output=false {
		return getAddressID();
	}

	public function save() output=false {
		var qs=getQueryService();

		qs.addParam(name="addressid", cfsqltype="cf_sql_varchar", value=getAddressID());

		if ( qs.execute(sql="select addressID from tuseraddresses where addressID= :addressid").getResult().recordcount ) {
			variables.userManager.updateAddress(this);
		} else {
			variables.userManager.createAddress(this);
		}
		return this;
	}

	public function delete() output=false {
		variables.userManager.deleteAddress(getAddressID());
	}

	public function clone() output=false {
		return getBean("addressBean").setAllValues(structCopy(getAllValues()));
	}

	public function getPrimaryKey() output=false {
		return "addressID";
	}

	public function loadBy() output=false {
		if ( !structKeyExists(arguments,"siteID") ) {
			arguments.siteID=variables.instance.siteID;
		}
		arguments.addressBean=this;
		return variables.userManager.readAddress(argumentCollection=arguments);
	}

}
