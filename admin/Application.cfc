/*This file is part of Mura CMS.

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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
component extends="framework" output="false" {

	include "../config/applicationSettings.cfm";

	
	if(server.coldfusion.productname != 'ColdFusion Server'){
		backportdir='';
		include "../requirements/mura/backport/backport.cfm";
	} else {
		backportdir='../requirements/mura/backport/';
		include "#backportdir#backport.cfm";
	}
	
	if(not hasMainMappings){
		//Try and include global mappings;
		canWriteMode=true;
		canWriteMappings=true;
		hasMappings=true;
		
		try{
			include "../config/mappings.cfm";
		}
		catch(any e){
			if(e.type eq 'missingInclude'){
				hasMappings=false;
			}
		}
		
		if(not hasMappings){
			include "../config/buildMainMappings.cfm";
		}
		
	}
	
	if(not hasPluginMappings){
		//Try and include plugin mappings
		canWriteMode=true;
		hasMappings=true;
		canWriteMappings=true;
		try{
			include "../plugins/mappings.cfm";
		}
		catch(any e){
			if(e.type eq 'missingInclude'){
				hasMappings=false;
			}
		}
		
		if(not hasMappings){
			include "../config/buildPluginMappings.cfm";
		}
		
	}
	
	if(not hasPluginCFApplication){
		//Try and include plugin mappings
		canWriteMode=true;
		hasMappings=true;
		canWriteMappings=true;
		try{
			include "../plugins/cfapplication.cfm";
		}
		catch(any e){
			if(e.type eq 'missingInclude'){
				hasMappings=false;
			}
		}
		
		if(not hasMappings){
			include "../config/buildPluginCFApplication.cfm";
		}
		
	}

	variables.framework=structNew();
	variables.framework.home = "core:home.redirect";
	variables.framework.action="muraAction";
	variables.framework.base="/muraWRM/admin/";
	variables.framework.defaultSubsystem="core";
	variables.framework.usingSubsystems=true;
	variables.framework.applicationKey="muraAdmin";
	variables.framework.siteWideLayoutSubsystem='common';

	if(structKeyExists(form,"fuseaction")){
		form.muraAction=form.fuseaction;
	}

	if(structKeyExists(url,"fuseaction")){
		url.muraAction=url.fuseaction;
	}
	
	function setupApplication() output="false"{

		param name="application.appInitialized" default=false;
		
		if(!application.appInitialized){
			param name="application.instanceID" default=createUUID();
			lock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200" {
				include "../config/appcfc/onApplicationStart_include.cfm";
			}
		}

		if(not structKeyExists(application,"muraAdmin") or not hasBeanFactory()){
			setupFrameworkDefaults();
			setupRequestDefaults();
			variables.framework.cache = structNew();
			variables.framework.cache.lastReload = now();
			variables.framework.cache.controllers = structNew();
			variables.framework.cache.services = structNew();
			application[variables.framework.applicationKey] = variables.framework;
			variables.framework.password=application.appreloadkey;
			setBeanFactory( application.serviceFactory );
		}
		
	}

	function onRequestStart() output="false"{

		include "../config/appcfc/onRequestStart_include.cfm";

		try{
			if(not (structKeyExists(application.settingsManager,'validate') and application.settingsManager.validate() and isStruct(application.configBean.getAllValues()))){
				application.appInitialized=false;
			}
		} catch(any e){
			application.appInitialized=false;
			request.muraAppreloaded=false;
		} 

		try{

			if(application.appInitialized and isDefined('application.scriptProtectionFilter') and application.configBean.getScriptProtect()){

				variables.remoteIPHeader=application.configBean.getValue("remoteIPHeader");
				
				if(len(variables.remoteIPHeader)){
					try{
						if(StructKeyExists(GetHttpRequestData().headers, variables.remoteIPHeader)){
					    	request.remoteAddr = GetHttpRequestData().headers[remoteIPHeader];
					   	} else {
							request.remoteAddr = CGI.REMOTE_ADDR;
					   	}
					   }
						catch(any e){
							request.remoteAddr = CGI.REMOTE_ADDR;
						}
				} else {
					request.remoteAddr = CGI.REMOTE_ADDR;
				}

				if(application.configBean.getScriptProtect()){

					for(var u in url){
						//url['#u#']=tempCanonicalize(url['#u#'],true,false);
					}

					if(isDefined("url")){
						application.scriptProtectionFilter.scan(
													object=url,
													objectname="url",
													ipAddress=request.remoteAddr,
													useTagFilter=true,
													useWordFilter=true);
					}

					for(var f in form){
						//form['#f#']=tempCanonicalize(form['#f#'],true,false);
					}

					if(isDefined("form")){
						application.scriptProtectionFilter.scan(
													object=form,
													objectname="form",
													ipAddress=request.remoteAddr,
													useTagFilter=true,
													useWordFilter=true);
					}
					try{	
						if(isDefined("cgi")){
							application.scriptProtectionFilter.scan(
														object=cgi,
														objectname="cgi",
														ipAddress=request.remoteAddr,
														useTagFilter=true,
														useWordFilter=true,
														fixValues=false);
						}

						for(var c in cookie){
							//cookie['#c#']=tempCanonicalize(cookie['#c#'],true,false);		
						}

						if(isDefined("cookie")){
							application.scriptProtectionFilter.scan(
														object=cookie,
														objectname="cookie",
														ipAddress=request.remoteAddr,
														useTagFilter=true,
														useWordFilter=true,
														fixValues=false);
						}
					} catch(any e){}
						
				}
				
			}
		} catch(any e){}

		super.onRequestStart(argumentCollection=arguments);
	}

	function setupRequest() output="false"{
		
		var siteCheck="";
		var theParam="";
		var temp="";
		var page="";
		var i="";
		var site="";
		
				
		if(right(cgi.script_name, Len("index.cfm")) NEQ "index.cfm" and right(cgi.script_name, Len("error.cfm")) NEQ "error.cfm" AND right(cgi.script_name, 3) NEQ "cfc"){
			location(url="./", addtoken="false");
		}
		
		request.context.currentURL="./";
	
		var qrystr="";
		var item="";

		for(item in url){
			try{
				qrystr="#qrystr#&#item#=#url[item]#";	
			}
			catch(any e){}
		}

		if(len(qrystr)){
			request.context.currentURL=request.context.currentURL & "?" & qrystr;
		}

		StructAppend(request.context, url, "no");
		StructAppend(request.context, form, "no");
			
		if (IsDefined("request.muraGlobalEvent")){
			StructAppend(request, request.muraGlobalEvent.getAllValues(), "no");
			StructDelete(request,"muraGlobalEvent");	
		}
		
		param name="request.context.moduleid" default="";
		param name="request.context.siteid" default="";
		param name="request.context.muraAction" default="";
		param name="request.context.layout" default="";
		param name="request.context.activetab" default="0";
		param name="request.context.activepanel" default="0";
		param name="request.context.ajax" default="";
		param name="request.context.rb" default="";
		param name="request.context.closeCompactDisplay" default="false";
		param name="request.context.compactDisplay" default="false";
		param name="session.siteid" default="";
		param name="session.keywords" default="";
		param name="session.showdashboard" default=application.configBean.getDashboard();
		param name="session.alerts" default=structNew();

		request.muraAdminRequest=true;

		if(ListFirst(server.coldfusion.productVersion) >= 10){
			param name="cookie.rb" default={value='',expires='never',httponly=true,secure=application.configBean.getSecureCookies()};
		} else {
			param name="cookie.rb" default='';
		}
		
		application.serviceFactory.getBean('utility').suppressDebugging();

		if(len(request.context.rb)){
			session.rb=request.context.rb;
			if(ListFirst(server.coldfusion.productVersion) >= 10){
				cookie.rb={value="#session.rb#",expires="never",httponly=true,secure=application.configBean.getSecureCookies()};
			}
		}
		
		if(not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() gte 30){
			param name="session.dashboardSpan" default="30";
		} else {
			param name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#";
		}
		
		if(not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() gte 30){
			session.dashboardSpan=30;
		} else {
			session.dashboardSpan=application.configBean.getSessionHistory();
		}
		
		if(request.context.siteid neq '' and (session.siteid neq request.context.siteID)){
			siteCheck=application.settingsManager.getSites();
			if(structKeyExists(siteCheck,request.context.siteID)){
				session.siteid = request.context.siteid;
				session.userFilesPath = "#application.configBean.getAssetPath()#/#request.context.siteid#/assets/";
				session.topID="00000000000000000000000000000000001";
				session.openSectionList="";
			}
		} else if(not len(session.siteID)){
			session.siteID="default";
			session.userFilesPath = "#application.configBean.getAssetPath()#/default/assets/";	
			session.topID="00000000000000000000000000000000001";
			session.openSectionList="";
		}
		
		application.rbFactory.resetSessionLocale();
		
		if(not structKeyExists(request.context,"siteid")){
			request.context.siteID=session.siteID;
		}

		if(not structKeyExists(session.alerts,'#session.siteid#')){
			session.alerts['#session.siteid#']=structNew();
		}
			
		request.event=createObject("component", "mura.event").init(request.context);
		request.context.$=request.event.getValue('MuraScope');
		request.muraScope=request.context.$;
		
		if(request.context.moduleid neq ''){
			session.moduleid = request.context.moduleid;
		}
		
		if(application.serviceFactory.containsBean("userUtility")){
			application.serviceFactory.getBean("userUtility").returnLoginCheck(request.event.getValue("MuraScope"));
		}		
		
		if(application.configBean.getAdminDomain() neq '' and application.configBean.getAdminDomain() neq listFirst(cgi.http_host,":")){
			application.contentServer.renderFilename("/admin/",false);
			abort;
		}
		
		if(session.mura.isLoggedIn and not structKeyExists(session,"siteArray")){
			session.siteArray=[];
			
			for(site in application.settingsManager.getSites()){
				if(application.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")){
					arrayAppend(session.siteArray,site);
				}
			}
		}
		
		if(session.mura.isLoggedIn and structKeyExists(session,"siteArray") and not arrayLen(session.siteArray)){
			if(not listFind(session.mura.memberships,'S2IsPrivate') and not listLast(listFirst(request.context.muraAction,"."),":") eq 'clogin'){
				location(url="#application.configBean.getContext()#/admin/?muraAction=clogin.logout", addtoken="false");
			} else if(not len(request.context.muraAction)
					or (
							len(request.context.muraAction) 
							and not listfindNoCase("clogin,cMessage,cEditprofile",listLast(listFirst(request.context.muraAction,"."),":") )
						)){
				location(url="#application.configBean.getContext()#/admin/?muraAction=cMessage.noaccess", addtoken="false");
			}
		}
		
		if(not structKeyExists(session,"siteArray")){
			session.siteArray=[];
		}
			
		param name="session.paramArray" default="#arrayNew(1)#";
		param name="session.paramCount" default="0";
		param name="session.paramCircuit" default="";
		param name="session.paramCategories" default="";
		param name="session.paramGroups" default="";
		param name="session.inActive" default="";
		param name="session.membersOnly" default="false";
		param name="session.visitorStatus" default="All";
		param name="request.context.param" default="";
		param name="request.context.inActive" default="0";
		param name="request.context.categoryID" default="";
		param name="request.context.groupID" default="";
		param name="request.context.membersOnly" default="false";
		param name="request.context.visitorStatus" default="All";
		
		if(request.context.param neq ''){
			session.paramArray=arrayNew(1);
			session.paramCircuit=listLast(listFirst(request.context.muraAction,'.'),':');
			for(i=1;i lte listLen(request.context.param);i=i+1){
				theParam=listGetAt(request.context.param,i);
				if(evaluate('request.context.paramField#theParam#') neq 'Select Field'
				and evaluate('request.context.paramField#theParam#') neq ''
				and evaluate('request.context.paramCriteria#theParam#') neq ''){
					temp={};
					temp.Field=evaluate('request.context.paramField#theParam#');
					temp.Relationship=evaluate('request.context.paramRelationship#theParam#');
					temp.Criteria=evaluate('request.context.paramCriteria#theParam#');
					temp.Condition=evaluate('request.context.paramCondition#theParam#');
					arrayAppend(session.paramArray,temp);
				}
			}
				
			session.paramCount =arrayLen(session.paramArray);
			session.inActive = request.context.inActive;
			session.paramCategories = request.context.categoryID;
			session.paramGroups = request.context.groupID;
			session.membersOnly = request.context.membersOnly;
			session.visitorStatus = request.context.visitorStatus;
				
		}
		
		request.muraPreviewDomain=listFirst(cgi.http_host,":");
	
		if(!isDefined('request.muraPreviewDomain') || !len(request.muraPreviewDomain)){
			request.muraPreviewDomain=cgi.server_name;
		}

		if(!application.settingsManager.getSite(session.siteid).isValidDomain(domain=request.muraPreviewDomain,mode='complete')){
			request.muraPreviewDomain=application.settingsManager.getSite(session.siteid).getDomain();
		}

		if(application.configBean.getAdminSSL() and application.configBean.getForceAdminSSL() and not application.utility.isHTTPS()){
			if(cgi.query_string eq ''){
				page='#cgi.script_name#';
			} else {
				page='#cgi.script_name#?#cgi.QUERY_STRING#';
			}
			
			location(addtoken="false", url="https://#listFirst(cgi.http_host,":")##page#");
		}

		if(yesNoFormat(application.configBean.getAccessControlHeaders()) 
		){
			var headers = getHttpRequestData().headers;
		  	var origin = '';
		  	var PC = getpagecontext().getresponse();
		 
		  	// Find the Origin of the request
		  	if( structKeyExists( headers, 'Origin' ) ) {
		   		origin = headers['Origin'];
		  	}
		 
		  	// If the Origin is okay, then echo it back, otherwise leave out the header key
		  	if(listFindNoCase(application.settingsManager.getSite(session.siteid).getAccessControlOriginList(), origin )) {
		   		PC.setHeader( 'Access-Control-Allow-Origin', origin );
		   		
		   		if(yesNoFormat(application.configBean.getAccessControlCredentials())){
		   			PC.setHeader( 'Access-Control-Allow-Credentials', 'true' );
		   		}
		  	}
	  	}

		application.rbFactory.setAdminLocale();
		application.pluginManager.announceEvent("onAdminRequestStart",request.event);
		
	}

	function setupSession() output="false"{
		include "../config/appcfc/onSessionStart_include.cfm";
	}

	include "../config/appcfc/onSessionEnd_method.cfm";
	
	function onError(exception,eventname) output="false"{
		include "../config/appcfc/onError_include.cfm";
	}

	include "../config/appcfc/onMissingTemplate_method.cfm";

	function onRequestEnd(targetPage) output="false"{
		if(isdefined("request.event")){
			application.pluginManager.announceEvent("onAdminRequestEnd",request.event);
			include "../config/appcfc/onRequestEnd_include.cfm";
		}
	}

	function rbKey(key){
		return application.rbFactory.getKeyValue(session.rb,arguments.key);
	}

}