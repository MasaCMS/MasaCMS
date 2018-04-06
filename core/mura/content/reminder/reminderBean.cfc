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
 * This provides reminder bean functionality
 */
component extends="mura.cfobject" output="false" hint="This provides reminder bean functionality" {
	variables.instance=structNew();
	variables.instance.contentid="";
	variables.instance.email="";
	variables.instance.isSent=0;
	variables.instance.remindHour=0;
	variables.instance.remindMinute=0;
	variables.instance.siteID="";
	variables.instance.errors=structnew();
	variables.instance.isNew=1;
	variables.instance.RemindInterval=0;

	public function init() output=false {
		return this;
	}

	public function set(required property, propertyValue) output=false {
		if ( !isDefined('arguments.reminder') ) {
			if ( isSimpleValue(arguments.property) ) {
				return getValue(argumentCollection=arguments);
			}
			arguments.reminder=arguments.property;
		}
		var prop = "";
		var tempFunc="";
		if ( isquery(arguments.reminder) ) {
			setcontentID(arguments.reminder.contentid);
			setEmail(arguments.reminder.email);
			setIsSent(arguments.reminder.isSent);
			setRemindHour(arguments.reminder.remindHour);
			setRemindMinute(arguments.reminder.remindMinute);
			setSiteID(arguments.reminder.siteID);
			setRemindInterval(arguments.reminder.RemindInterval);
		} else if ( isStruct(arguments.reminder) ) {
			for ( prop in arguments.reminder ) {
				if ( isdefined("variables.instance.#prop#") ) {
					tempFunc=this["set#prop#"];
					tempFunc(arguments.reminder['#prop#']);
				}
			}
		}
	}

	public struct function getAllValues() output=false {
		return variables.instance;
	}

	public function validate() output=false {
		variables.instance.errors=structnew();
		if ( REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}",variables.instance.email) != 0 ) {
			variables.instance.errors.email="The 'email' address that you provided mus be in a valid format.";
		}
	}

	public function setcontentId(required string ContentId) output=false {
		variables.instance.ContentId = trim(arguments.ContentId);
	}

	public function getcontentId() output=false {
		return variables.instance.ContentId;
	}

	public function setEmail(required string Email) output=false {
		variables.instance.Email = trim(arguments.Email);
	}

	public function getEmail() output=false {
		return variables.instance.Email;
	}

	public function setIsSent(required numeric IsSent) output=false {
		variables.instance.IsSent =arguments.IsSent;
	}

	public function getIsSent() output=false {
		return variables.instance.IsSent;
	}

	public function setRemindDate(required string RemindDat) output=false {
		variables.instance.RemindDat = trim(arguments.RemindDat);
	}

	public function getRemindDate() output=false {
		return variables.instance.RemindDat;
	}

	public function setRemindHour(required numeric RemindHour) output=false {
		variables.instance.RemindHour =arguments.RemindHour;
	}

	public function getRemindHour() output=false {
		return variables.instance.RemindHour;
	}

	public function setRemindMinute(required numeric RemindMinute) output=false {
		variables.instance.RemindMinute =arguments.RemindMinute;
	}

	public function getRemindMinute() output=false {
		return variables.instance.RemindMinute;
	}

	public function setSiteID(required string SiteID) output=false {
		variables.instance.SiteID = trim(arguments.SiteID);
	}

	public function getSiteID() output=false {
		return variables.instance.SiteID;
	}

	public function setIsNew(required numeric IsNew) output=false {
		variables.instance.IsNew = arguments.IsNew;
	}

	public function getIsNew() output=false {
		return variables.instance.IsNew;
	}

	public function setRemindInterval(required numeric RemindInterval) output=false {
		variables.instance.RemindInterval = arguments.RemindInterval;
	}

	public function getRemindInterval() output=false {
		return variables.instance.RemindInterval;
	}

}
