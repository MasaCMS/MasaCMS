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
 * This provides access to a plugin's configuration
 */
component extends="mura.cfobject" output="false" hint="This provides access to a plugin's configuration" {
	variables.settings=structNew();
	variables.name="";
	variables.deployed=0;
	variables.pluginID=0;
	variables.loadPriority=5;
	variables.moduleID="";
	variables.provider="";
	variables.providerURL="";
	variables.created="";
	variables.category="";
	variables.version="";
	variables.package="";
	variables.directory="";
	variables.customSettings=structNew();
	variables.hasCustomSettingsDir=false;
	variables.CFStatic=structNew();

	public function initSettings(any data="#structNew()#") output=false {
		var appcfcStr="";
		variables.settings=arguments.data;
		return this;
	}

	public function getModuleID() output=false {
		return variables.moduleID;
	}

	public function setModuleID(String moduleID) output=false {
		variables.moduleID = trim(arguments.moduleID);
	}

	public function setPluginID(pluginID) output=false {
		if ( isnumeric(arguments.pluginID) ) {
			variables.pluginID = arguments.pluginID;
		}
	}

	public function getPluginID() output=false {
		return variables.pluginID;
	}

	public function setName(String name) output=false {
		variables.name = trim(arguments.name);
	}

	public function getName() output=false {
		return variables.name;
	}

	public function setProvider(String provider) output=false {
		variables.provider = trim(arguments.provider);
	}

	public function getProvider() output=false {
		return variables.provider;
	}

	public function setProviderURL(String providerURL) output=false {
		variables.providerURL = trim(arguments.providerURL);
	}

	public function getProviderURL() output=false {
		return variables.providerURL;
	}

	public function setLoadPriority(loadPriority) output=false {
		if ( isNumeric(arguments.loadPriority) ) {
			variables.loadPriority = arguments.loadPriority;
		}
	}

	public function getLoadPriority() output=false {
		return variables.loadPriority;
	}

	public function setCategory(String category) output=false {
		variables.category = trim(arguments.category);
	}

	public function getCategory() output=false {
		return variables.category;
	}

	public function setCreated(String created) output=false {
		variables.created = trim(arguments.created);
	}

	public function getCreated() output=false {
		return variables.created;
	}

	public function setDeployed(deployed) output=false {
		if ( isNumeric(arguments.deployed) ) {
			variables.deployed = arguments.deployed;
		}
	}

	public function getDeployed() output=false {
		return variables.deployed;
	}

	public function setVersion(String version) output=false {
		variables.version = trim(arguments.version);
	}

	public function getVersion() output=false {
		return variables.version;
	}

	public function setPackage(String package) output=false {
		variables.package = trim(arguments.package);
	}

	public function getPackage() output=false {
		return variables.package;
	}

	public function setDirectory(String directory) output=false {
		if ( arguments.directory != variables.directory ) {
			variables.directory = trim(arguments.directory);
			variables.CFStatic=structNew();
		}
	}

	public function getDirectory() output=false {
		return variables.directory;
	}

	public function setSetting(required string property, propertyValue="") output=false {
		variables.settings["#arguments.property#"]=arguments.propertyValue;
	}

	public function getSetting(required string property) output=false {
		if ( structKeyExists(variables.settings,"#arguments.property#") ) {
			return variables.settings["#arguments.property#"];
		} else {
			return "";
		}
	}

	public function getSettings() output=false {
		return variables.settings;
	}

	public function addToHTMLHeadQueue(text) output=false {
		var headerStr="";
		var pluginPath="";
		var pluginConfig=this;
		var event="";
		var eventData=structNew();
		var sessionData=super.getSession();
		if ( structKeyExists(request,"servletEvent") && structKeyExists(request,"contentRenderer") ) {
			if ( findNoCase("<script",arguments.text) || findNoCase("<link",arguments.text) ) {
				request.contentRenderer.addtoHTMLHeadQueue(arguments.text);
			} else {
				request.contentRenderer.addtoHTMLHeadQueue(getDirectory() & "/" & arguments.text);
			}
		} else {
			if ( structKeyExists(request,"servletEvent") ) {
				event=request.servletEvent;
			} else {
				if ( structKeyExists(sessionData,"siteid") ) {
					eventData.siteID=sessionData.siteid;
				}
				event=createObject("component","mura.event").init(eventData);
			}
			pluginPath= application.configBean.getContext() & "/plugins/" & getDirectory() & "/";
			savecontent variable="headerStr" {
				include "/plugins/#getDirectory()#/#arguments.text#";
			}

			getBean('utility').setHTMLHead(headerStr);

		}
	}

	public function addToHTMLFootQueue(text) output=false {
		if ( structKeyExists(request,"servletEvent") && structKeyExists(request,"contentRenderer") ) {
			request.contentRenderer.addtoHTMLFootQueue(getDirectory() & "/" & arguments.text);
		}
	}

	public function getApplication(purge="false") output=false {
		if ( !structKeyExists(application,"plugins") ) {
			lock name="settingPluginStruct#application.instanceID#" timeout="100" {
				if ( !structKeyExists(application,"plugins") ) {
					application.plugins=structNew();
				}
			}
		}
		if ( !structKeyExists(application.plugins,"p#getPluginID()#") || arguments.purge ) {
			application.plugins["p#getPluginID()#"]=createObject("component","pluginApplication");
			application.plugins["p#getPluginID()#"].setPluginConfig(this);
		}
		return application.plugins["p#getPluginID()#"];
	}

	public function getSession(purge="false") output=false {
		var sessionData=super.getSession();
		if ( !structKeyExists(sessionData,"plugins") ) {
			sessionData.plugins=structNew();
		}
		if ( !structKeyExists(sessionData.plugins,"p#getPluginID()#") || arguments.purge ) {
			sessionData.plugins["p#getPluginID()#"]=createObject("component","pluginSession");
			sessionData.plugins["p#getPluginID()#"].setPluginConfig(this);
		}
		return sessionData.plugins["p#getPluginID()#"];
	}

	function addEventListener(required component){
		return addEventHandler(argumentCollection=arguments);
	}

	public function addEventHandler(required component) output=false {
		if ( !isDefined('arguments.component.injectMethod') ) {
			arguments.component.injectMethod=injectMethod;
		}
		if ( !isDefined('arguments.component.getValue') ) {
			arguments.component.injectMethod('getValue',getValue);
		}
		if ( !isDefined('arguments.component.setValue') ) {
			arguments.component.injectMethod('setValue',setValue);
		}
		arguments.component.setValue('pluginName',getName());
		var rsSites=getPluginManager().getAssignedSites(getModuleID());
		var applyglobal=true;

		if(rsSites.recordcount){
			for(var i=1;i<=rsSites.recordcount;i++) {
				getPluginManager().addEventHandler(component=arguments.component,siteid=rsSites.siteID[i],applyglobal=applyglobal);
				var applyglobal=false;
			}
		}

		return this;
	}

	public function addAPIMethod(required methodName, required method) output=false {
		var settingsManager=getBean('settingsManager');
		var rsSites=getPluginManager().getAssignedSites(getModuleID());

		if(rsSites.recordcount){
			for(var i=1;i<=rsSites.recordcount;i++) {
				settingsManager.getSite(rsSites.siteid[i]).getApi('json','v1').registerMethod(argumentCollection=arguments);
			}
		}

		return this;
	}

	public function registerDisplayObjectDir(dir, conditional="true", package="", custom="true") output=false {
		var settingsManager=getBean('settingsManager');
		var rsSites=getPluginManager().getAssignedSites(getModuleID());
		if ( listFind('/,\',left(arguments.dir,1) ) ) {
			arguments.dir='/' & getPackage() & arguments.dir;
		} else {
			arguments.dir='/' & getPackage() & '/' & arguments.dir;
		}

		if(rsSites.recordcount){
			for(var i=1;i<=rsSites.recordcount;i++) {
				settingsManager.getSite(rssites.siteid[i]).registerDisplayObjectDir(argumentCollection=arguments);
			}
		}

		return this;
	}

	public function registerModuleDir(dir, conditional="true", package="", custom="true") output=false {
		return registerDisplayObjectDir(arguments=arguments);
	}

	public function registerContentTypeDir(dir) output=false {
		var settingsManager=getBean('settingsManager');
		var rsSites=getPluginManager().getAssignedSites(getModuleID());
		if ( listFind('/,\',left(arguments.dir,1) ) ) {
			arguments.dir='/' & getPackage() & arguments.dir;
		} else {
			arguments.dir='/' & getPackage() & '/' & arguments.dir;
		}

		if(rsSites.recordcount){
			for(var i=1;i<=rsSites.recordcount;i++) {
				settingsManager.getSite(rssites.siteid[i]).registerContentTypeDir(argumentCollection=arguments);
			}
		}

		return this;
	}

	public function registerBeanDir(dir, package) output=false {
		var rssites=getPluginManager().getAssignedSites(getModuleID());
		var siteids=valueList(rssites.siteid);
		if ( listFind('/,\',left(arguments.dir,1) ) ) {
			arguments.dir='/' & getPackage() & arguments.dir;
		} else {
			arguments.dir='/' & getPackage() & '/' & arguments.dir;
		}
		getBean("configBean").registerBeanDir(dir=arguments.dir,siteid=siteids,moduleid=getModuleID());
		return this;
	}

	public function registerModelDir(dir, package) output=false {
		return registerBeanDir(argumentcollection=arguments);
	}

	public function getAssignedSites() output=false {
		return getPluginManager().getAssignedSites(getModuleID());
	}

	public function deleteCustomSetting(required string name) output=false {
		var wddxFile="#getFullPath()#/plugin/customSettings/wddx_#arguments.name#.xml.cfm";
		if ( fileExists(wddxFile) ) {
			fileDelete(wddxFile);
		}
		structDelete(variables.customSettings,arguments.name);
	}

	public function getCustomSetting(required string name, defaultValue) output=false {
		var customValue="";
		var customWDDX="";
		var wddxFile="#getFullPath()#/plugin/customSettings/wddx_#arguments.name#.xml.cfm";
		if ( !variables.hasCustomSettingsDir ) {
			createCustomSettingsDir();
		}
		if ( structKeyExists(variables.customSettings,arguments.name) ) {
			return variables.customSettings["#arguments.name#"];
		} else if ( fileExists(wddxFile) ) {
			customWDDX=fileRead(wddxFile,"utf-8");
			variables.customSettings["#arguments.name#"]=getBean('utility').wddx2cfml(customWDDX);
			customValue=variables.customSettings["#arguments.name#"];
			return customValue;
		} else {
			if(isdefined('arguments.default')){
				arguments.defaultValue=arguments['default'];
			}
			if ( structKeyExists(arguments,"defaultValue") ) {
				return arguments.defaultValue;
			} else {
				return "";
			}
		}
	}

	public function setCustomSetting(required string name, required any value) {
		var temp="";
		if ( !variables.hasCustomSettingsDir ) {
			createCustomSettingsDir();
		}
		if ( isQuery(arguments.value) && application.configBean.getDBType() == "Oracle" ) {
			arguments.value=fixOracleClobs(arguments.value);
		}
		variables.customSettings["#name#"]=arguments.value;

		getBean('fileWriter').writeFile( charset="utf-8", output=getBean('utility').cfml2wddx(arguments.value), file="#getFullPath()#/plugin/customSettings/wddx_#arguments.name#.xml.cfm" );
	}

	public function fixOracleClobs(rs) output=false {
		var rsmeta=getMetaData(arguments.rs);
		var clobArray=arrayNew(1);
		var i=1;
		if ( arrayLen(rsmeta) ) {
			for ( i=1 ; i<=arrayLen(rsmeta) ; i++ ) {
				if ( rsmeta[i].typename == "clob" ) {
					arrayAppend(clobArray,rsmeta[i].name);
				}
			}
		}
		if ( arrayLen(clobArray) && rs.recordcoun) {

			for(var row=1;row<=rs.recordcount;row++){
				for(i in clobArray){
					QuerySetCell(arguments.rs, clobArray[i],arguments.rs['#clobArray[i]#'][row], row);
				}
			}

		}
		return arguments.rs;
	}

	public function purgeCustomSettings() output=false {
		if ( directoryExists(getFullPath() & "/plugin/customSettings") ) {
			getBean('fileWriter').deleteDir(directory="#getFullPath()#/plugin/customSettings", recurse=true);
		}
		variables.hasCustomSettingsDir=false;
		variables.customSettings=structNew();
	}

	public function createCustomSettingsDir() output=false {
		var appcfcStr="";
		var fileWriter=getBean('fileWriter');
		try {
			if ( !directoryExists(getFullPath() & "/plugin/customSettings/") ) {
				fileWriter.createDir( directory="#getFullPath()#/plugin/customSettings/" );
				var ct="cfcomponent";
				var ft="cffunction";
				appcfcStr='<#ct#><#ft# name="onRequestStart">Access Restricted</#ft#></#ct#>';
				fileWriter.writeFile( output=appcfcStr, file="#getFullPath()#/plugin/customSettings/Application.cfc" );
			}
			variables.hasCustomSettingsDir=true;
		} catch (any cfcatch) {
		}
	}

	public function getFullPath() output=false {
		return application.configBean.getPluginDir() & "/" & getDirectory();
	}

	public function renderAdminTemplate(body, pageTitle="#getName()#", required jsLib="jquery", required jsLibLoaded="false", compactDisplay="false", moduleid="#getModuleID()#") output=false {
		return getBean('pluginManager').renderAdminTemplate(argumentCollection=arguments);
	}

	public function currentUserAccess() output=false {
		var sessionData=super.getSession();
		return isDefined('sessionData.siteID') && getBean('permUtility').getModulePerm(getModuleID(),sessionData.siteID);
	}

}
