<cfprocessingdirective pageencoding="utf-8">
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
param name="application.setupComplete" default=false;
param name="application.appInitialized" default=false;
param name="application.instanceID" default=createUUID();

setEncoding("url", "utf-8");
setEncoding("form", "utf-8");

if ( left(server.coldfusion.productversion,5) == "9,0,0" || listFirst(server.coldfusion.productversion) < 9 ) {

	writeOutput("Mura CMS requires Adobe Coldfusion 9.0.1 or greater compatibility");

	abort;
}
/*  Double check that the application has started properly.
If it has not, set application.appInitialized=false. */
try {
	if ( !(
			structKeyExists(application.settingsManager,'validate')
			and application.settingsManager.validate()
			and structKeyExists(application.contentManager,'validate')
			and application.contentManager.validate()
			and application.serviceFactory.containsBean('contentManager')
			and isStruct(application.configBean.getAllValues())
		) ) {
		application.appInitialized=false;
		application.broadcastInit=false;
	}
	application.clusterManager.runCommands();
	if ( !application.appInitialized ) {
		request.muraAppreloaded=false;
	}
} catch (any cfcatch) {
	application.appInitialized=false;
	request.muraAppreloaded=false;
	application.broadcastInit=false;
}
if ( isDefined("onApplicationStart") ) {
	if ( (
			not application.setupComplete
		OR
		(
			not request.muraAppreloaded
			and
				(
					not application.appInitialized
					or structKeyExists(url,application.appReloadKey)
				)
		)
	) ) {
		lock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200" {
			if(!(isDefined('url.method') && url.method == 'processAsyncObject')){
			//  Since the request may have had to wait twice, this code still needs to run
				if ( (not application.appInitialized || structKeyExists(url,application.appReloadKey)) ) {
					include "onApplicationStart_include.cfm";
					if ( isdefined("setupApplication") ) {
						setupApplication();
					}
				}
			}
		}
	}
	if ( !application.setupComplete ) {
		request.renderMuraSetup = true;
		//  go to the index.cfm page (setup)
		include "/muraWRM/core/appcfc/setup_check.cfm";
		include "/muraWRM/core/setup/index.cfm";
		abort;
	}
}

/* Potentially Clear Out Secrets, also in onApplicationStart_include
for(secret in listToArray(structKeyList(request.muraSecrets))){
	structDelete(request.muraSysEnv,'#secret#');
}
*/

for(handlerKey in application.appHandlerLookUp){
	handler=application.appHandlerLookUp['#handlerKey#'];
	if(structKeyExists(handler,'onApplicationLoad') 
		&& (!structKeyExists(handler,'appliedAppLoad') || !handler.appliedAppLoad)
	){
		lock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200" {
			lock name="setSites#application.instanceID#" type="exclusive" timeout="200" {
				if((!structKeyExists(handler,'appliedAppLoad') || !handler.appliedAppLoad)){
					try{
						$=getBean('$').init();
						handler.onApplicationLoad($=$,m=$,Mura=$,event=$.event());
						handler.appliedAppLoad=true;
					} catch(any e){
						writeLog(type="Error", file="exception", text="Error Registering Handler: #serializeJSON(e)#");
					}
				}
			}
		}
	}
}

application.userManager.setUserStructDefaults();
sessionData=application.userManager.getSession();
if ( isDefined("url.showTrace") && isBoolean(url.showTrace) ) {
	sessionData.mura.showTrace=url.showTrace;
} else if ( !isDefined("sessionData.mura.showTrace") ) {
	sessionData.mura.showTrace=false;
}
request.muraShowTrace=sessionData.mura.showTrace;
if ( !isDefined("application.cfstatic") ) {
	application.cfstatic=structNew();
}
//  Making sure that session is valid
try {
	if ( yesNoFormat(application.configBean.getValue("useLegacySessions")) && structKeyExists(sessionData,"mura") ) {
		if ( (not sessionData.mura.isLoggedIn && isValid("UUID",listFirst(getAuthUser(),"^")))
			or
		(sessionData.mura.isLoggedIn && !isValid("UUID",listFirst(getAuthUser(),"^"))) ) {
			variables.tempcookieuserID=cookie.userID;
			application.loginManager.logout();
		}
	}
} catch (any cfcatch) {
	application.loginManager.logout();
}

if (getSystemEnvironmentSetting('MURA_ENABLEDEVELOPMENTSETTINGS') == "true" && structKeyExists(application, "settingsManager")){
	variables.allSitesEDS = application.settingsManager.getSites();
	for (variables.siteEDS in variables.allSitesEDS) {
		variables.allSitesEDS[variables.siteEDS].setEnableLockdown('');
		variables.allSitesEDS[variables.siteEDS].setUseSSL(0);
	}
}

// settings.custom.vars.cfm reference is for backwards compatability
if ( fileExists(expandPath("/muraWRM/config/settings.custom.vars.cfm")) ) {
	include "/muraWRM/config/settings.custom.vars.cfm";
}

try {
	if ( (not isdefined('cookie.userid') || cookie.userid == '') && structKeyExists(sessionData,"rememberMe") && session.rememberMe == 1 && sessionData.mura.isLoggedIn ) {
		application.utility.setCookie(name="userid",value=sessionData.mura.userID);
		application.utility.setCookie(name="userHash",value=encrypt(application.userManager.readUserHash(sessionData.mura.userID).userHash,application.userManager.readUserPassword(cookie.userid),'cfmx_compat','hex'));
	}
} catch (any cfcatch) {
	application.utility.deleteCookie(name="userHash");
	application.utility.deleteCookie(name="userid");
}
try {
	if ( isDefined('cookie.userid') && cookie.userid != '' && !sessionData.mura.isLoggedIn ) {
		application.loginManager.rememberMe(cookie.userid,decrypt(cookie.userHash,application.userManager.readUserPassword(cookie.userid),"cfmx_compat",'hex'));
	}
} catch (any cfcatch) {
}
try {
	if ( isDefined('cookie.userid') && cookie.userid != '' && structKeyExists(sessionData,"rememberMe") && sessionData.rememberMe == 0 && sessionData.mura.isLoggedIn ) {
		application.utility.deleteCookie(name="userHash");
		application.utility.deleteCookie(name="userid");
	}
} catch (any cfcatch) {
	application.utility.deleteCookie(name="userHash");
	application.utility.deleteCookie(name="userid");
}

if(request.muraSessionManagement){
	try {
		param name="sessionData.muraSessionID" default=application.utility.getUUID();
		if ( !structKeyExists(cookie,"MXP_TRACKINGID") ) {
			if ( structKeyExists(cookie,"originalURLToken") ) {
				application.utility.setCookie(name="MXP_TRACKINGID", value=cookie.originalURLToken);
				StructDelete(cookie, 'originalURLToken');
			} else {
				application.utility.setCookie(name="MXP_TRACKINGID", value=sessionData.muraSessionID);
			}
		}
		param name="sessionData.muraTrackingID" default=cookie.MXP_TRACKINGID;
	} catch (any cfcatch) {
	}
}
//  look to see is there is a custom remote IP header in the settings.ini.cfm
variables.remoteIPHeader=application.configBean.getValue("remoteIPHeader");
if ( len(variables.remoteIPHeader) ) {
	try {
		if ( StructKeyExists(GetHttpRequestData().headers, variables.remoteIPHeader) ) {
			request.remoteAddr = GetHttpRequestData().headers[remoteIPHeader];
		} else {
			request.remoteAddr = CGI.REMOTE_ADDR;
		}
	} catch (any cfcatch) {
		request.remoteAddr = CGI.REMOTE_ADDR;
	}
} else {
	request.remoteAddr = CGI.REMOTE_ADDR;
}
if (request.muraSessionManagement && !isdefined('url.muraadminpreview') ) {
	request.muraMobileRequest=false;
	if ( isDefined("form.mobileFormat") && isBoolean(form.mobileFormat) ) {
		request.muraMobileRequest=form.mobileFormat;
		application.utility.setCookie(name="mobileFormat",value=form.mobileFormat);
	} else if ( isDefined("url.mobileFormat") && isBoolean(url.mobileFormat) ) {
		request.muraMobileRequest=url.mobileFormat;
		application.utility.setCookie(name="mobileFormat",value=url.mobileFormat);
	}
	if ( !isdefined("cookie.mobileFormat") ) {
		application.pluginManager.executeScripts('onGlobalMobileDetection');
		if ( !isdefined("cookie.mobileFormat") ) {
			if ( findNoCase("iphone",CGI.HTTP_USER_AGENT)
				or
					(
						findNoCase("mobile",CGI.HTTP_USER_AGENT)
						and !reFindNoCase("tablet|ipad|xoom",CGI.HTTP_USER_AGENT)
					) ) {
				application.utility.setCookie(name="mobileFormat",value=true);
				request.muraMobileRequest=true;
			} else {
				application.utility.setCookie(name="mobileFormat",value=false);
				request.muraMobileRequest=false;
			}
		}
	} else if (isBoolean(cookie.mobileFormat)) {
		request.muraMobileRequest=cookie.mobileFormat;
	}
	if ( !isBoolean(request.muraMobileRequest) ) {
		request.muraMobileRequest=false;
		application.utility.setCookie(name="mobileFormat",value=false);
	}
} else {
	param name="url.mobileFormat" default=false;
	request.muraMobileRequest=url.mobileFormat;
}
if ( !request.hasCFApplicationCFM && !fileExists("#expandPath('/muraWRM/config')#/cfapplication.cfm") ) {
	variables.tracePoint=initTracePoint("Writing config/cfapplication.cfm");
	application.serviceFactory.getBean("fileWriter").writeFile(file="#expandPath('/muraWRM/config')#/cfapplication.cfm", output='<!--- Add Custom Application.cfc Vars Here --->');
	commitTracePoint(variables.tracePoint);
}

param name="sessionData.mura.requestcount" default=0;
sessionData.mura.requestcount=sessionData.mura.requestcount+1;
param name="sessionData.mura.csrfsecretkey" default=createUUID();
param name="sessionData.mura.csrfusedtokens" default=structNew();
param name="application.coreversion" default=application.configBean.getVersion();

if (
		request.muraSessionManagement
			&& (
				structKeyExists(request,"doMuraGlobalSessionStart")
				|| !(
					isDefined('cookie.cfid') || isDefined('cookie.cftoken') || isDefined('cookie.jsessionid')
					)
			)
		) {
	application.utility.setSessionCookies();
	application.pluginManager.executeScripts('onGlobalSessionStart');
}
application.pluginManager.executeScripts('onGlobalRequestStart');

// HSTS: https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
local.HSTSMaxAge=application.configBean.getValue(property='HSTSMaxAge',defaultValue=1200);

if(local.HSTSMaxAge){
	getPageContext()
		.getResponse()
		.setHeader('Strict-Transport-Security', 'max-age=#application.configBean.getValue(property='HSTSMaxAge',defaultValue=1200)#');
}

	getPageContext()
		.getResponse()
		.setHeader('Generator', 'Mura CMS #application.serviceFactory.getBean('configBean').getVersion()#');

</cfscript>
