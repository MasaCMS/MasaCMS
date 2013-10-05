/*
 * Copyright (C) 2005-2008 Razuna Ltd.
 *
 * This file is part of Razuna - Enterprise Digital Asset Management.
 *
 * Razuna is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Razuna is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero Public License for more details.
 *
 * You should have received a copy of the GNU Affero Public License
 * along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 *
 * You may restribute this Program with a special exception to the terms
 * and conditions of version 3.0 of the AGPL as described in Razuna's
 * FLOSS exception. You should have received a copy of the FLOSS exception
 * along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 *
 *
 * HISTORY:
 * Date US Format		User					Note
 * 2013/04/10			CF Mitrah		 	Initial version
*/
component persistent="false" accessors="true" output="false" extends="core.includes.fw1" {

	include '../../../config/applicationSettings.cfm';
	include '../../../config/mappings.cfm';
	include '../../../plugins/mappings.cfm';

	// FW1 Configuration
	variables.framework = {};

	// !important: enter the plugin packageName here. must be the same as found in '{context}/plugin/config.xml.cfm'
	variables.framework.package = 'razuna';
	variables.framework.packageVersion = '0.1 Alpha';

	// If true, then additional information is returned by the Application.onError() method
	// and FW1 will 'reloadApplicationOnEveryRequest' (unless explicitly set otherwise below).
	variables.framework.debugMode = true;
	
	// change to TRUE if you're developing the plugin so you can see changes in your controllers, etc.
	variables.framework.reloadApplicationOnEveryRequest = variables.framework.debugMode ? true : false;

	// the 'action' defaults to your packageNameAction, (e.g., 'MuraFW1action') you may want to update this to something else.
	// please try to avoid using simply 'action' so as not to conflict with other FW1 plugins
	variables.framework.action = 'razunaAction';

	// less commonly modified
	variables.framework.defaultSection = 'ajax';
	variables.framework.defaultItem = 'default';
	variables.framework.usingSubsystems = false;
	variables.framework.defaultSubsystem = '';

	// by default, fw1 uses 'fw1pk' ... however, to allow for plugin-specific keys, this plugin will use your packageName + 'pk'
	variables.framework.preserveKeyURLKey = variables.framework.package & 'pk';

	// ***** rarely modified *****
	variables.framework.applicationKey = variables.framework.package;
	variables.framework.base = '/' & variables.framework.package;
	variables.framework.reload = 'reload';
	variables.framework.password = 'appreload'; // IF you're NOT using the default reload key of 'appreload', then you'll need to update this!
	variables.framework.generateSES = false;
	variables.framework.SESOmitIndex = true;
	variables.framework.baseURL = 'useRequestURI';
	variables.framework.suppressImplicitService = false; //true to suppress fw/1 from storing service calls results in rc.data
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;

	if ( variables.framework.usingSubSystems ) {
		variables.framework.subsystemDelimiter = ':';
		//variables.framework.siteWideLayoutSubsystem = 'common';
		variables.framework.home = variables.framework.defaultSubsystem & variables.framework.subsystemDelimiter & variables.framework.defaultSection & '.' & variables.framework.defaultItem;
		variables.framework.error = variables.framework.defaultSubsystem & variables.framework.subsystemDelimiter & variables.framework.defaultSection & '.error';
	} else {
		variables.framework.home = variables.framework.defaultSection & '.' & variables.framework.defaultItem;
		variables.framework.error = variables.framework.defaultSection & '.error';
	};

	variables.fw1Keys = 'SERVICEEXECUTIONCOMPLETE,LAYOUTS,CONTROLLEREXECUTIONCOMPLETE,VIEW,SERVICES,CONTROLLERS,CONTROLLEREXECUTIONSTARTED';

	public string function doAction(string action='') {
		var p = variables.framework.package; 
		var fwa = variables.framework.action;
		var local = {};

		local.targetPath = getPageContext().getRequest().getRequestURI();
		onApplicationStart();

		request.context[fwa] = StructKeyExists(form, fwa) 
			? form[fwa] : StructKeyExists(url, fwa) 
			? url[fwa] : StructKeyExists(request, fwa)
			? request[fwa] : getFullyQualifiedAction(arguments.action);

		request.action = getFullyQualifiedAction(request.context[fwa]);

		// viewKey: package_subsystem_section_item
		local.viewKey = UCase(
			p 
			& '_' & getSubSystem(arguments.action) 
			& '_' & getSection(arguments.action)
			& '_' & getItem(arguments.action)
		);

		local.response = getCachedView(local.viewKey);

		local.newViewRequired = !Len(local.response) 
			? true : getSubSystem(arguments.action) == getSubSystem(request.context[fwa])
			? true : false;

		if ( local.newViewRequired ) {
			onRequestStart(local.targetPath);
			savecontent variable='local.response' {
				onRequest(local.targetPath);
			};
			clearFW1Request();
			setCachedView(local.viewKey, local.response);
		};

		return local.response;
	}

	public any function setupApplication() {
		var local = {};

		if ( !StructKeyExists(application, 'pluginManager') ) {
			location(url='/', addtoken=false);
		};

		lock scope='application' type='exclusive' timeout=50 {
			application[variables.framework.applicationKey].pluginConfig = application.pluginManager.getConfig(ID=variables.framework.applicationKey);
		};

	}

	public void function setupRequest() {
		var local = {};

		param name='request.context.siteid' default='';

		if ( !StructKeyExists(session, 'siteid') ) {
			lock scope='session' type='exclusive' timeout='10' {
				session.siteid = 'default';
			};
		};

		secureRequest();

		request.context.isAdminRequest = isAdminRequest();
		request.context.isFrontEndRequest = isFrontEndRequest();
		
		if ( StructKeyExists(url, application.configBean.getAppReloadKey()) ) { 
			setupApplication();
		};

		if ( Len(Trim(request.context.siteid)) && ( session.siteid != request.context.siteid) ) {
			local.siteCheck = application.settingsManager.getSites();
			if ( StructKeyExists(local.siteCheck, request.context.siteid) ) {
				lock scope='session' type='exclusive' timeout='10' {
					session.siteid = request.context.siteid;
				};
			};
		};

		if ( !StructKeyExists(request.context, '$') ) {
			request.context.$ = StructKeyExists(request, 'muraScope') ? request.muraScope : application.serviceFactory.getBean('muraScope').init(session.siteid);
		};

		request.context.pc = application[variables.framework.applicationKey].pluginConfig;
		request.context.pluginConfig = application[variables.framework.applicationKey].pluginConfig;
		request.context.action = request.context[variables.framework.action];
	}
	
	public void function setupView() {
		var httpRequestData = GetHTTPRequestData();
		if ( 
			StructKeyExists(httpRequestData.headers, 'X-#variables.framework.package#-AJAX') 
			&& IsBoolean(httpRequestData.headers['X-#variables.framework.package#-AJAX']) 
			&& httpRequestData.headers['X-#variables.framework.package#-AJAX'] 
		) {
			setupResponse();
		};
	}
	
	public void function setupResponse() {
		var httpRequestData = GetHTTPRequestData();
		if (
			StructKeyExists(httpRequestData.headers, 'X-#variables.framework.package#-AJAX') 
			&& IsBoolean(httpRequestData.headers['X-#variables.framework.package#-AJAX']) 
			&& httpRequestData.headers['X-#variables.framework.package#-AJAX'] 
		) {
			StructDelete(request.context, 'fw');
			StructDelete(request.context, '$');
			WriteOutput(SerializeJSON(request.context));
			abort;
		};
	}

	public string function buildURL(required string action, string path='#variables.framework.baseURL#', string queryString='') {
		var regx = '&?compactDisplay=[true|false]';
		arguments.action = getFullyQualifiedAction(arguments.action);
		if (
			StructKeyExists(request.context, 'compactDisplay') 
			&& IsBoolean(request.context.compactDisplay) 
			&& !REFindNoCase(regx, arguments.action) 
			&& !REFindNoCase(regx, arguments.queryString) 
		) {
			var qs = 'compactDisplay=' & request.context.compactDisplay;
			if ( !Find('?', arguments.action) ) {
				arguments.queryString = ListAppend(arguments.queryString, qs, '&');
			} else {
				arguments.action = ListAppend(arguments.action, qs, '&');
			};
		};
		return super.buildURL(argumentCollection=arguments);
	}

	
	// ========================== Errors & Missing Views ==============================

	/*
	public any function onError() output="true" {
		//var scopes = 'application,arguments,cgi,client,cookie,form,local,request,server,session,url,variables';
		var scopes = 'local,request,session';
		var arrScopes = ListToArray(scopes);
		var i = '';
		var scope = '';
		WriteOutput('<h2>' & variables.framework.package & ' ERROR</h2>');
		if ( IsBoolean(variables.framework.debugMode) && variables.framework.debugMode ) {
			for ( i=1; i <= ArrayLen(arrScopes); i++ ) {
				scope = arrScopes[i];
				WriteDump(var=Evaluate(scope),label=UCase(scope));
			};
		};
		abort;
	}
	*/
	public any function onMissingView(any rc) {
		rc.errors = [];
		rc.isMissingView = true;
		// forward to appropriate error screen
		if ( isFrontEndRequest() ) {
			ArrayAppend(rc.errors, "The page you're looking for doesn't exist.");
			redirect(action='public:main.error', preserve='errors,isMissingView');
		} else {
			ArrayAppend(rc.errors, "The page you're looking for <strong>#rc.action#</strong> doesn't exist.");
			redirect(action='admin:main', preserve='errors,isMissingView');
		};
	}

	// ========================== Helper Methods ==============================

	public any function secureRequest() {
		if ( isAdminRequest() && !( IsDefined('session.mura') && ListFindNoCase(session.mura.memberships,'S2') ) ) {
			if ( !StructKeyExists(session,'siteID') || !StructKeyExists(session,'mura') || !application.permUtility.getModulePerm(application[variables.framework.applicationKey].pluginConfig.getModuleID(),session.siteid) ) {
				location(url='#application.configBean.getContext()#/admin/', addtoken=false);
			};
		};
	}

	public boolean function isAdminRequest() {
		return StructKeyExists(request, 'context') && ListFirst(request.context[variables.framework.action], ':') == 'admin' ? true : false;
	}

	public boolean function isFrontEndRequest() {
		return StructKeyExists(request, 'murascope');
	}

	// ==========================  STATE  ==============================

	public void function clearFW1Request() {
		var arrFW1Keys = ListToArray(variables.fw1Keys);
		var i = '';
		if ( StructKeyExists(request, '_fw1') ) {
			for ( i=1; i <= ArrayLen(arrFW1Keys); i++ ) {
				StructDelete(request._fw1, arrFW1Keys[i]);
			};
			request._fw1 = {
				cgiScriptName = CGI.SCRIPT_NAME
				, cgiRequestMethod = CGI.REQUEST_METHOD
				, controllers = []
				, requestDefaultsInitialized = false
				, services = []
				, trace = []
			};
		};
	}

	// ========================== PRIVATE ==============================

	private any function getCachedView(required string viewKey) {
		var view = '';
		var cache = getSessionCache();
		if ( StructKeyExists(cache, 'views') && StructKeyExists(cache.views, arguments.viewKey) ) {
			view = cache.views[arguments.viewKey];
		};
		return view;
	}

	private void function setCachedView(required string viewKey, string viewValue='') {
		lock scope='session' type='exclusive' timeout=10 {
			session[variables.framework.package].views[arguments.viewKey] = arguments.viewValue;
		};
	}

	private boolean function isCacheExpired() {
		var p = variables.framework.package;
		return !StructKeyExists(session, p) 
				|| DateCompare(now(), session[p].expires, 's') == 1 
				|| DateCompare(application.appInitializedTime, session[p].created, 's') == 1
			? true : false;
	}

	private any function getSessionCache() {
		var local = {};
		if ( isCacheExpired() ) {
			setSessionCache();
		};
		lock scope='session' type='readonly' timeout=10 {
			local.cache = session[variables.framework.package];
		};
		return local.cache;
	}

	private void function setSessionCache() {
		var p = variables.framework.package;
		// Expires - s:seconds, n:minutes, h:hours, d:days
		lock scope='session' type='exclusive' timeout=10 {
			StructDelete(session, p);
			session[p] = {
				created = Now()
				, expires = DateAdd('h', 1, Now())
				, sessionid = Hash(CreateUUID())
				, views = {}
			};
		};
	}

}
