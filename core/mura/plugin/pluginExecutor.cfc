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
 * This provides a thread safe context to execute plugin cfm base event handling
 */
component extends="mura.cfobject" output="false" hint="This provides a thread safe context to execute plugin cfm base event handling" {
	variables.configBean="";
	variables.settingsManager="";
	variables.pluginManager="";

	public function init(configBean, settingsManager, pluginManager) output=false {
		variables.configBean=arguments.configBean;
		variables.settingsManager=arguments.settingsManager;
		variables.pluginManager=arguments.pluginManager;
		return this;
	}

	public function displayObject(objectID, event, rsDisplayObject, $, mura, m) output=true {
		var rs="";
		var str="";
		var pluginConfig="";
		var tracePoint=0;
		request.pluginConfig=variables.pluginManager.getConfig(arguments.rsDisplayObject.pluginID);
		request.pluginConfig.setSetting("pluginMode","object");
		request.scriptEvent=arguments.event;
		pluginConfig=request.pluginConfig;
		if ( arguments.rsDisplayObject.location == "global" ) {
			pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/");
			tracePoint=initTracePoint("/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#");
			savecontent variable="str" {
				include "/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#";
			}
			commitTracePoint(tracePoint);
		} else {
			pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/");
			tracePoint=initTracePoint("/#variables.configBean.getWebRootMap()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#");
			savecontent variable="str" {
				include "/#variables.configBean.getWebRootMap()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#";
			}
			commitTracePoint(tracePoint);
		}
		structDelete(request,"pluginConfig");
		structDelete(request,"scriptEvent");
		return trim(str);
	}

	public function executeScript(required any event="", required any scriptFile="", required any pluginConfig="", $, mura, m) output=false {
		var scriptEvent=arguments.event;
		var tracePoint=0;
		request.pluginConfig=arguments.pluginConfig;
		request.scriptEvent=arguments.event;
		tracePoint=initTracePoint(arguments.scriptFile);
		include arguments.scriptFile;
		commitTracePoint(tracePoint);
		structDelete(request,"pluginConfig");
		structDelete(request,"scriptEvent");
		return event;
	}

	public function renderScript(required any event="", required any scriptFile="", required any pluginConfig="", $, mura, m) output=true {
		var rs="";
		var str="";
		var tracePoint=0;
		var attributes=structNew();
		request.pluginConfig=arguments.pluginConfig;
		request.pluginConfig.setSetting("pluginMode","object");
		request.scriptEvent=arguments.event;
		pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/");
		attributes=arguments.event.getAllValues();
		tracePoint=initTracePoint(arguments.scriptFile);
		savecontent variable="str" {
			include arguments.scriptFile;
		}
		commitTracePoint(tracePoint);
		structDelete(request,"pluginConfig");
		structDelete(request,"scriptEvent");
		return trim(str);
	}

}
