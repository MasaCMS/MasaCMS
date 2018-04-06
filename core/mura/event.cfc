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
 * This provides a utility to hold the contextual information related to code execution
 */
component output="false" extends="mura.cfobject" hint="This provides a utility to hold the contextual information related to code execution" {
	variables.event=structNew();

	public function init(any data="#structNew()#", $) output=false {
		if ( isStruct(arguments.data) ) {
			variables.event=arguments.data;
		}
		if ( isdefined("form") ) {
			structAppend(variables.event,form,false);
		}
		structAppend(variables.event,url,false);
		if ( structKeyExists(arguments,"$") ) {
			setValue("MuraScope",arguments.$);
		} else {
			setValue("MuraScope",createObject("component","mura.MuraScope"));
		}
		getValue('MuraScope').setEvent(this);
		if ( len(getValue('siteid')) && getBean('settingsManager').siteExists(getValue('siteid')) ) {
			loadSiteRelatedObjects();
		} else {
			setValue("contentRenderer",getBean('contentRenderer'));
		}
		return this;
	}

	public function setValue(required string property, propertyValue="") output=false {
		variables.event["#arguments.property#"]=arguments.propertyValue;
		return this;
	}

	public function set(required string property, defaultValue) output=false {
		return setValue(argumentCollection=arguments);
	}

	public function getValue(required string property, defaultValue) output=false {
		if ( structKeyExists(variables.event,"#arguments.property#") ) {
			return variables.event["#arguments.property#"];
		} else if ( structKeyExists(arguments,"defaultValue") ) {
			variables.event["#arguments.property#"]=arguments.defaultValue;
			return variables.event["#arguments.property#"];
		} else {
			return "";
		}
	}

	public function get(required string property, defaultValue) output=false {
		return getValue(argumentCollection=arguments);
	}

	public function valueExists(required string property) output=false {
		return structKeyExists(variables.event,arguments.property);
	}

	public function removeValue(required string property) output=false {
		structDelete(variables.event,arguments.property);
		return this;
	}

	public function getValues() output=false {
		return variables.event;
	}

	public function getAllValues() output=false {
		return variables.event;
	}

	public function getHandler(handler) output=false {
		if ( isObject(getValue('HandlerFactory')) ) {
			return getValue('HandlerFactory').get(arguments.handler & "Handler",getValue("localHandler"));
		} else {
			throwSiteIDError();
		}
	}

	public function getValidator(validation) output=false {
		if ( isObject(getValue('ValidatorFactory')) ) {
			return getValue('ValidatorFactory').get(arguments.validation & "Validator",getValue("localHandler"));
		} else {
			throwSiteIDError();
		}
	}

	public function getTranslator(translator) output=false {
		if ( isObject(getValue('TranslatorFactory')) ) {
			return getValue('TranslatorFactory').get(arguments.translator & "Translator",getValue("localHandler"));
		} else {
			throwSiteIDError();
		}
	}

	public function getContentRenderer() output=false {
		var renderer=getValue('contentRenderer');
		return getValue('contentRenderer');
		return renderer;
	}

	/**
	 * deprecated: use getContentRenderer()
	 */
	public function getThemeRenderer() output=false {
		return getContentRenderer();
	}

	public function getSite() output=false {
		if ( len(getValue('siteid')) ) {
			return getBean('settingsManager').getSite(getValue('siteid'));
		} else {
			throwSiteIDError();
		}
	}

	public function getServiceFactory() output=false {
		if ( isDefined('application') && structKeyExists(application,'serviceFactory') ) {
			return application.serviceFactory;
		} else if ( structKeyExists(variables,'applicationScope') ) {
			//  in case this is called in the onRequestEnd()
			return variables.applicationScope;
		}
	}

	public function getMuraScope() output=false {
		return getValue("MuraScope");
	}

	public function getBean(beanName, siteID) output=false {
		if ( structKeyExists(arguments,"siteid") ) {
			return super.getBean(arguments.beanName,arguments.siteID);
		} else {
			return super.getBean(arguments.beanName,getValue('siteid'));
		}
	}

	public function throwSiteIDError() output=false {
		throw( message="The 'SITEID' was not defined for this event", type="custom" );
	}

	public function loadSiteRelatedObjects() output=false {
		if ( !isObject(getValue("HandlerFactory")) ) {
			setValue('HandlerFactory',getBean('pluginManager').getStandardEventFactory(getValue('siteid')));
		}
		if ( !valueExists("contentRenderer") ) {
			setValue('contentRenderer',getValue('MuraScope').getContentRenderer());
		}
		setValue('localHandler',getBean('settingsManager').getSite(getValue('siteID')).getLocalHandler());
		return this;
	}

}
