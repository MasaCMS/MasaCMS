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
 * This provides specialized methods to the primary front end request event object
 */
component output="false" extends="mura.cfobject" hint="This provides specialized methods to the primary front end request event object" {

	public function init() output=false {

		if (NOT IsDefined("request"))
	    request=structNew();
	StructAppend(request, url, "no");
	StructAppend(request, form, "no");

	if (IsDefined("request.muraGlobalEvent")){
		StructAppend(request, request.muraGlobalEvent.getAllValues(), "no");
		StructDelete(request,"muraGlobalEvent");
	}
		param name="request.doaction" default="";
		param name="request.month" default=month(now());
		param name="request.year" default=year(now());
		param name="request.display" default="";
		param name="request.startrow" default=1;
		param name="request.pageNum" default=1;
		param name="request.keywords" default="";
		param name="request.tag" default="";
		param name="request.mlid" default="";
		param name="request.noCache" default=0;
		param name="request.categoryID" default="";
		param name="request.relatedID" default="";
		param name="request.linkServID" default="";
		param name="request.track" default=1;
		param name="request.exportHTMLSite" default=0;
		param name="request.returnURL" default="";
		param name="request.showMeta" default=0;
		param name="request.forceSSL" default=0;
		param name="request.muraForceFilename" default=true;
		param name="request.muraSiteIDInURL" default=false;

		setValue('HandlerFactory',application.pluginManager.getStandardEventFactory(getValue('siteid')));
		setValue("MuraScope",createObject("component","mura.MuraScope"));
		getValue('MuraScope').setEvent(this);
		return this;
	}

	public function setValue(required string property, propertyValue="", required scope="request") output=false {
		var theScope=getScope(arguments.scope);
		theScope["#arguments.property#"]=arguments.propertyValue;
		return this;
	}

	public function set(required string property, defaultValue, required scope="request") output=false {
		return setValue(argumentCollection=arguments);
	}

	public function getValue(required string property, defaultValue, required scope="request") output=false {
		var theScope=getScope(arguments.scope);
		if ( structKeyExists(theScope,"#arguments.property#") ) {
			return theScope["#arguments.property#"];
		} else if ( structKeyExists(arguments,"defaultValue") ) {
			theScope["#arguments.property#"]=arguments.defaultValue;
			return theScope["#arguments.property#"];
		} else {
			return "";
		}
	}

	public function get(required string property, defaultValue, required scope="request") output=false {
		return getValue(argumentCollection=arguments);
	}

	public function getAllValues(required scope="request") output=false {
		return getScope(arguments.scope);
	}

	public struct function getScope(required scope="request") output=false {
		switch ( arguments.scope ) {
			case  "request":
				return request;
				break;
			case  "form":
				return form;
				break;
			case  "url":
				return url;
				break;
			case  "session":
				return session;
				break;
			case  "server":
				return server;
				break;
			case  "application":
				return application;
				break;
			case  "attributes":
				return attributes;
				break;
			case  "cluster":
				return cluster;
				break;
		}
	}

	public function valueExists(required string property, required scope="request") output=false {
		var theScope=getScope(arguments.scope);
		return structKeyExists(theScope,arguments.property);
	}

	public function removeValue(required string property, required scope="request") output=false {
		var theScope=getScope(arguments.scope);
		structDelete(theScope,arguments.property);
	}

	public function getHandler(handler) output=false {
		return getValue('HandlerFactory').get(arguments.handler & "Handler",getValue("localHandler"));
	}

	public function getValidator(validation) output=false {
		return getValue('HandlerFactory').get(arguments.validation & "Validator",getValue("localHandler"));
	}

	public function getTranslator(translator) output=false {
		return getValue('HandlerFactory').get(arguments.translator & "Translator",getValue("localHandler"));
	}

	public function getContentRenderer() output=false {
		return getValue('contentRenderer');
	}

	/**
	 * deprecated: use getContentRenderer()
	 */
	public function getThemeRenderer() output=false {
		return getContentRenderer();
	}

	public function getContentBean() output=false {
		return getValue('contentBean');
	}

	public function getCrumbData() output=false {
		return getValue('crumbdata');
	}

	public function getSite() output=false {
		return application.settingsManager.getSite(getValue('siteid'));
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

}
