<cfscript>
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
param name="local" default=structNew();
local.pluginEvent="";
if ( structKeyExists(application,"pluginManager") && structKeyExists(application.pluginManager,"announceEvent") ) {
	if ( structKeyExists(request,"servletEvent") ) {
		local.pluginEvent=request.servletEvent;
	} else if ( structKeyExists(request,"event") ) {
		local.pluginEvent=request.event;
	} else {
		local.pluginEvent=createObject("component","mura.event");
	}
	local.pluginEvent.setValue("targetPage",arguments.targetPage);
	if ( len(local.pluginEvent.getValue("siteID")) ) {
		local.response=application.pluginManager.renderEvent("onSiteMissingTemplate",local.pluginEvent);
		if ( len(local.response) ) {
			writeOutput("#local.response#");
			return true;
		}
		if ( structKeyExists(request.muraHandledEvents,'onSiteMissingTemplate') ) {
			structKeyDelete(request.muraHandledEvents,'onSiteMissingTemplate');
			return true;
		}
	}
	local.response=application.pluginManager.renderEvent("onGlobalMissingTemplate",local.pluginEvent);
	if ( len(local.response) ) {
		writeOutput("#local.response#");
		return true;
	}
	if ( structKeyExists(request.muraHandledEvents,'onGlobalMissingTemplate') ) {
		structKeyDelete(request.muraHandledEvents,'onGlobalMissingTemplate');
		return true;
	}
}
if ( isDefined("application.contentServer") ) {
	request.muraTemplateMissing=true;
	onRequestStart();
	local.fileArray=listToArray(cgi.script_name,"/");
	local.filename="";
	if ( len(application.configBean.getValue('context')) ) {
		local.contextArray=listToArray(application.configBean.getValue('context'),"/");
		local.contextArrayLen=arrayLen(local.contextArray);
		for ( local.i=1 ; local.i<=local.contextArrayLen ; local.i++ ) {
			arrayDeleteAt(local.fileArray, 1);
		}
	}

	if ( local.fileArray[1] != 'index.cfm' && application.settingsManager.siteExists(local.fileArray[1])) {
		siteid=local.fileArray[1];
	} else if (arrayLen(local.fileArray) > 1 && application.settingsManager.siteExists(local.fileArray[2])) {
		siteid=local.fileArray[2];;
	} else {
		siteid=application.contentServer.bindToDomain();
	}

	if(len(cgi.path_info)){
		local.fileArray=ListToArray(cgi.path_info ,"/,\");
	}

	if(arrayLen(local.fileArray) && application.settingsManager.siteExists(local.fileArray[1])){
		local.fileArray=arrayToList(local.fileArray);
		local.fileArray=listToArray(listRest(local.fileArray));
	}

	for ( local.i=1 ; local.i<=arrayLen(local.fileArray) ; local.i++ ) {
		if ( find(".",local.fileArray[local.i]) && local.i < arrayLen(local.fileArray) ) {
			local.filename="";
		} else if ( !(find(".",local.fileArray[local.i]) && listFind(application.configBean.getAllowedIndexFiles(),local.fileArray[local.i])) ) {
			local.filename=listAppend(local.filename,local.fileArray[local.i] , "/");
		}
	}
	firstItem=listFirst(local.filename,'/');
	if ( listFind('_api,tasks',firstItem) ) {
		writeOutput("#application.contentServer.handleAPIRequest('/' & local.filename)#");
		abort;
	} else if ( !len(cgi.path_info) ) {
		// handle /missing.cfm/ file with 404 
		application.contentServer.render404();
	} else {
	
		local.fileArray=ListToArray(cgi.path_info,'\,/');
		local.last=local.fileArray[arrayLen(local.fileArray)];
		local.hasAllowedFile=find(".",local.last) and (application.configBean.getAllowedIndexFiles() eq '*' or listFind(application.configBean.getAllowedIndexFiles(),local.last));

		if (find(".",local.last) and local.hasAllowedFile){
			if (local.last eq 'index.json'){
				request.returnFormat="JSON";
			}
		}
		if( len(cgi.path_info) && right(cgi.path_info,1) != '/' && !local.hasAllowedFile ) {
			url.path=local.filename & '/';
			application.contentServer.forcePathDirectoryStructure(local.filename,siteID);
		}
		application.contentServer.renderFilename(filename=local.filename,siteid=siteid);
	}
	return true;
}
return false;
</cfscript>
