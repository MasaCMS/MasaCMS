<cfscript>
/*  This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of txhe GNU General Public License
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
param name="application.appInitializedTime" default="";
param name="application.appInitialized" default=false;
param name="application.appAutoUpdated" default=false;
param name="application.appReloadKey" default="appreload";
param name="application.broadcastInit" default=false;
param name="application.sessionTrackingThrottle" default=true;
param name="application.instanceID" default=createUUID();
param name="application.CFVersion" default=listFirst(SERVER.COLDFUSION.PRODUCTVERSION);
param name="application.setupComplete" default=false;
param name="application.appHandlerLookUp" default={};

request.muraAppreloaded=true;

if ( left(server.coldfusion.productversion,5) == "9,0,0" || listFirst(server.coldfusion.productversion) < 9 ) {
	writeOutput("Mura CMS requires Adobe Coldfusion 9.0.1 or greater compatibility");
	abort;
}

//  this is here for CF8 compatibility
variables.baseDir=this.baseDir;

//  do a settings setup check
if ( !application.setupComplete || (not application.appInitialized || structKeyExists(url,application.appReloadKey) ) ) {
	if ( getINIProperty(entry="mode",section="settings") == "production" ) {
		if ( directoryExists( variables.basedir & "/core/setup" ) ) {
			application.setupComplete = false;
			//  check the settings
			param name="application.setupSubmitButton" default="A#hash( createUUID() )#";
			param name="application.setupSubmitButtonComplete" default="A#hash( createUUID() )#";
			include "/muraWRM/core/appcfc/setup_check.cfm";

			if ( trim( getINIProperty("datasource") ) != ""
					AND (
						NOT isDefined( "FORM.#application.setupSubmitButton#" )
						AND
						NOT isDefined( "FORM.#application.setupSubmitButtonComplete#" )
						) ) {
				application.setupComplete = true;
			} else {
				//  check to see if the index.cfm page exists in the setup folder
				if ( !fileExists( variables.basedir & "/core/setup/index.cfm" ) ) {
					throw( message="Your setup directory is incomplete. Please reset it up from the Mura source." );
				}
				application.setupComplete = false;
			}
		} else {
			application.setupComplete = true;
		}
	} else {
		application.setupComplete=true;
	}
}
if ( application.setupComplete ) {
	application.appInitialized=false;
	request.muraShowTrace=true;
	variables.iniPath = "#variables.basedir#/config/settings.ini.cfm";
	variables.iniSections=getProfileSections(variables.iniPath);
	variables.iniProperties=structNew();

	for(variables.p in listToArray(variables.iniSections.settings)){
		variables.envVar='MURA_#UCASE(variables.p)#';
			if ( structKeyExists(request.muraSysEnv,variables.envVar) ) {
				variables.iniProperties[variables.p]=request.muraSysEnv[variables.envVar];
			} else {
				variables.iniProperties[variables.p]=getProfileString("#variables.basedir#/config/settings.ini.cfm","settings",variables.p);
			}
			if ( left(variables.iniProperties[variables.p],2) == "${"
						and right(variables.iniProperties[variables.p],1) == "}" ) {
				variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-3);
				variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p]);
			} else if ( left(variables.iniProperties[variables.p],2) == "{{"
						and right(variables.iniProperties[variables.p],2) == "}}" ) {
				variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-4);
				variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p]);
			}
	}

	for(variables.p in listToArray(variables.iniSections[ variables.iniProperties.mode])){
		variables.iniProperties[variables.p]=getProfileString("#variables.basedir#/config/settings.ini.cfm", variables.iniProperties.mode,variables.p);
		if ( left(variables.iniProperties[variables.p],2) == "${"
					and right(variables.iniProperties[variables.p],1) == "}" ) {
			variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-3);
			variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p]);
		} else if ( left(variables.iniProperties[variables.p],2) == "{{"
					and right(variables.iniProperties[variables.p],2) == "}}" ) {
			variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-4);
			variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p]);
		}
	}

	for (variables.envVar in request.muraSysEnv) {
		if(listFirst(variables.envVar,"_")=='MURA'){
			variables.p=listRest(variables.envVar,"_");
			variables.iniProperties[variables.p]=request.muraSysEnv[variables.envVar];
			if ( left(variables.iniProperties[variables.p],2) == "${"
						and right(variables.iniProperties[variables.p],1) == "}" ) {
				variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-3);
				variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p]);
			} else if ( left(variables.iniProperties[variables.p],2) == "{{"
						and right(variables.iniProperties[variables.p],2) == "}}" ) {
				variables.iniProperties[variables.p]=mid(variables.iniProperties[variables.p],3,len(variables.iniProperties[variables.p])-4);
				variables.iniProperties[variables.p] = evaluate(variables.iniProperties[variables.p]);
			}
		}
	}

	try {
		if ( !structKeyExists(variables.iniProperties,"encryptionkey") || !len(variables.iniProperties["encryptionkey"]) ) {
			variables.iniProperties.encryptionkey=generateSecretKey('AES');
			createobject("component","mura.IniFile").init(variables.iniPath).set( variables.iniProperties.mode, "encryptionkey", variables.iniProperties.encryptionkey );
		}
	} catch (any cfcatch) {
	}

	/* Potentially Clear Out Secrets, also in onRequestStart_include
	for(secret in listToArray(structKeyList(request.muraSecrets))){
		structDelete(request.muraSysEnv,'#secret#');
	}
	*/

	variables.iniProperties.webroot = expandPath("/muraWRM");
	variables.mode = variables.iniProperties.mode;
	variables.mapdir = "mura";
	variables.webroot = variables.iniProperties.webroot;
	if ( !structKeyExists(variables.iniProperties,"useFileMode") ) {
		variables.iniProperties.useFileMode=true;
	}
	if ( !StructKeyExists(variables.iniProperties, 'fileDelim') ) {
		variables.iniProperties.fileDelim = '';
	}
	application.appReloadKey = variables.iniProperties.appreloadkey;
	variables.iniProperties.webroot = expandPath("/muraWRM");
	variables.tracer=createObject("component","mura.cfobject").init();
	variables.tracepoint=variables.tracer.initTracepoint("Instantiating DI1");

	if(directoryExists(expandPath("/mura/content/file/imagecfc"))){
  	directoryDelete(expandPath("/mura/content/file/imagecfc") ,true);
  }

  if(fileExists(expandPath("/mura/content/file/image.cfc"))){
  	fileDelete(expandPath("/mura/content/file/image.cfc"));
  }

	application.configBean=new mura.configBean().set(variables.iniProperties);
	application.appHandlerLookUp={};

	variables.serviceFactory=new mura.bean.beanFactory("/mura",{
			recurse=true,
			exclude=["/.","/mura/autoUpdater/global","/mura/configBean.cfc","/mura/bean/beanFactory.cfc","/mura/cache/provider","/mura/moment.cfc","/mura/client/oath"],
			strict=application.configBean.getStrictFactory(),
			transientPattern = "(Iterator|Bean|executor|MuraScope|Event|dbUtility|extendObject)$"
			});

		if(!isDefined('application.serviceFactory')){
			application.serviceFactory=variables.serviceFactory;
		}

		variables.serviceFactory.addBean("useFileMode",application.configBean.getUseFileMode());
		variables.serviceFactory.addBean("tempDir",application.configBean.getTempDir());
		variables.serviceFactory.addBean("configBean",application.configBean);
		variables.serviceFactory.addBean("data","");
		variables.serviceFactory.addBean("settings",{});
		variables.serviceFactory.addBean("resourceDirectory","");
		variables.serviceFactory.addBean("locale","en_us");
		variables.serviceFactory.addBean("parentFactory","");

		if(server.coldfusion.productName eq 'Coldfusion Server'){
			variables.serviceFactory.addAlias("contentGateway","contentGatewayAdobe");
		} else {
			variables.serviceFactory.addAlias("contentGateway","contentGatewayLucee");
		}

		if(getINIProperty("javaEnabled",true) && not request.muraInDocker && getINIProperty("legacyJavaLoader",false)){
			variables.serviceFactory.addBean('javaLoader',
					new mura.javaloader.JavaLoader(
						loadPaths=[
									expandPath('/mura/lib/jBCrypt-0.3'),
									expandPath('/mura/lib/diff_match_patch.jar'),
									expandPath('/mura/lib/googleauth.jar')
								]
					)
				);
		}

		variables.serviceFactory.addBean("fileWriter",
			new mura.fileWriter()
		);

		local.fileWriter=variables.serviceFactory.getBean("fileWriter");
		/*
			As of Mura 7.1 there theme with the main MuraCMS repo.
			So if there is not any theme installed then pull down the default one
		*/
		if ( application.configBean.getCreateRequiredDirectories() ) {
			variables.tracePoint1=initTracePoint("Check for default theme");
			if(!isdefined('application.serviceFactory')){
				application.serviceFactory=variables.serviceFactory;
			}

			local.hasTheme=0;

			if(DirectoryExists("#application.configBean.getWebRoot()#/themes")){
				local.hasTheme=local.fileWriter.getDirectoryList(directory="#application.configBean.getWebRoot()#/themes",recurse=false,type="dir").recordcount;
			}

			if(!local.hasTheme && DirectoryExists("#application.configBean.getWebRoot()#/default/includes/themes")){
				local.hasTheme=local.fileWriter.getDirectoryList(directory="#application.configBean.getWebRoot()#/default/includes/themes",recurse=false,type="dir").recordcount;
			}

			if(!local.hasTheme && DirectoryExists("#application.configBean.getWebRoot()#/default/themes")){
				local.hasTheme=local.fileWriter.getDirectoryList(directory="#application.configBean.getWebRoot()#/default/themes",recurse=false,type="dir").recordcount;
			}

			if(!local.hasTheme && DirectoryExists("#application.configBean.getSiteDir()#/default/themes")){
				local.hasTheme=local.fileWriter.getDirectoryList(directory="#application.configBean.getSiteDir()#/default/themes",recurse=false,type="dir").recordcount;
			}

			if ( !local.hasTheme ) {
				//WriteDump('no theme');abort;
				variables.tracePoint2=initTracePoint("Installing Default theme");
				if ( structKeyExists(request.muraSysEnv,'MURA_DEFAULTTHEMEURL') ) {
					application.configBean.setDefaultThemeURL(request.muraSysEnv['MURA_DEFAULTTHEMEURL']);
				}

				try {
					local.themeZip="install_theme_#createUUID()#.zip";

					try{

						local.httpService=application.configBean.getHTTPService();

						local.httpService.setURL(application.configBean.getDefaultThemeURL());
						local.httpService.setGetAsBinary("yes");
						local.theme=httpService.send().getPrefix();

						local.fileWriter.writeFile(file="#application.configBean.getWebRoot()#/#local.themeZip#",output=local.theme.filecontent);
					} catch (any e){
						local.fileWriter.copyFile(source="#application.configBean.getWebRoot()#/core/templates/theme.zip.cfm",destination="#application.configBean.getWebRoot()#/#local.themeZip#");
					}

					local.zipUtil=new mura.Zip();
					local.zipUtil.Extract(zipFilePath="#application.configBean.getWebRoot()#/#local.themeZip#",extractPath="#application.configBean.getWebRoot()#/themes", overwriteFiles=false);
					local.themeRS=local.fileWriter.getDirectoryList(directory="#application.configBean.getWebRoot()#/themes",recurse=false,type="dir");
					local.fileWriter.renameDir(directory="#application.configBean.getWebRoot()#/themes/#local.themeRS.name#",newDirectory="#application.configBean.getWebRoot()#/themes/default");
					fileDelete("#application.configBean.getWebRoot()#/#local.themeZip#");
					commitTracePoint(variables.tracepoint2);
				} catch (any error) {
					writeLog(type="Error", file="exception", text="Error pullling theme from remote: #serializeJSON(error.stacktrace)#");
				}
			}
			commitTracePoint(variables.tracePoint1);
		}

		variables.serviceFactory.declareBean("beanValidator", "mura.bean.beanValidator", true);

		variables.serviceFactory.addAlias("scriptProtectionFilter","Portcullis");
		variables.serviceFactory.addAlias("eventManager","pluginManager");
		variables.serviceFactory.addAlias("permUtility","permission");
		variables.serviceFactory.addAlias("content","contentBean");
		variables.serviceFactory.addAlias("contentCategoryAssign","contentCategoryAssignBean");
		variables.serviceFactory.addAlias("HTMLExporter","contentHTMLExporter");
		variables.serviceFactory.addAlias("feed","feedBean");
		variables.serviceFactory.addAlias("contentFeed","feedBean");
		variables.serviceFactory.addAlias("site","settingsBean");
		variables.serviceFactory.addAlias("user","userBean");
		variables.serviceFactory.addAlias("group","userBean");
		variables.serviceFactory.addAlias("address","addressBean");
		variables.serviceFactory.addAlias("category","categoryBean");
		variables.serviceFactory.addAlias("categoryFeed","categoryFeedBean");
		variables.serviceFactory.addAlias("userFeed","userFeedBean");
		variables.serviceFactory.addAlias("groupFeed","userFeedBean");
		variables.serviceFactory.addAlias("comment","contentCommentBean");
		variables.serviceFactory.addAlias("commentFeed","contentCommentFeedBean");
		variables.serviceFactory.addAlias("stats","contentStatsBean");
		variables.serviceFactory.addAlias("changeset","changesetBean");
		variables.serviceFactory.addAlias("bundle","settingsBundle");
		variables.serviceFactory.addAlias("mailingList","mailingListBean");
		variables.serviceFactory.addAlias("mailingListMember","memberBean");
		variables.serviceFactory.addAlias("groupDAO","userDAO");
		variables.serviceFactory.addAlias("userRedirect","userRedirectBean");

		//The ad manager has been removed, but may be there in certain legacy conditions
		if(variables.serviceFactory.containsBean('placementBean')){
			variables.serviceFactory.addAlias("placement","placementBean");
			variables.serviceFactory.addAlias("creative","creativeBean");
			variables.serviceFactory.addAlias("adZone","adZoneBean");
			variables.serviceFactory.addAlias("campaign","campaignBean");
		}

		variables.serviceFactory.addAlias("rate","rateBean");
		variables.serviceFactory.addAlias("favorite","favoriteBean");
		variables.serviceFactory.addAlias("email","emailBean");
		variables.serviceFactory.addAlias("imageSize","settingsImageSizeBean");
		variables.serviceFactory.addAlias("imageSizeIterator","settingsImageSizeIterator");
		variables.serviceFactory.addAlias("$","MuraScope");
		variables.serviceFactory.addAlias("m","MuraScope");
		variables.serviceFactory.addAlias("mura","MuraScope");
		variables.serviceFactory.addAlias("approvalchain","approvalchainBean");
		variables.serviceFactory.addAlias("approvalRequest","approvalRequestBean");
		variables.serviceFactory.addAlias("approvalAction","approvalActionBean");
		variables.serviceFactory.addAlias("approvalChainMembership","approvalChainMembershipBean");
		variables.serviceFactory.addAlias("approvalChainAssignment","approvalChainAssignmentBean");
		variables.serviceFactory.addAlias("changesetRollBack","changesetRollBackBean");
		variables.serviceFactory.addAlias("contentSourceMap","contentSourceMapBean");
		variables.serviceFactory.addAlias("relatedContentSet","extendRelatedContentSetBean");
		variables.serviceFactory.addAlias("fileMetaData","contentFileMetaDataBean");
		variables.serviceFactory.addAlias("file","fileBean");
		variables.serviceFactory.addAlias("razunaSettings","razunaSettingsBean");
		variables.serviceFactory.addAlias("contentFilenameArchive","contentFilenameArchiveBean");
		variables.serviceFactory.addAlias("commenter","contentCommenterBean");
		variables.serviceFactory.addAlias("changesetCategoryAssignment","changesetCategoryAssignmentBean");
		variables.serviceFactory.addAlias("changesetTagAssignment","changesetTagAssignmentBean");
		variables.serviceFactory.addAlias("userDevice","userDeviceBean");
		variables.serviceFactory.addAlias("variationTargeting","contentVariationTargetingBean");
		variables.serviceFactory.addAlias("remoteContentPointer","contentRemotePointerBean");
		variables.serviceFactory.addAlias("contentDisplayInterval","contentDisplayIntervalBean");
		variables.serviceFactory.addAlias("oauthClient","oauthClientBean");
		variables.serviceFactory.addAlias("oauthToken","oauthTokenBean");
		variables.serviceFactory.addAlias("dataCollection","dataCollectionBean");
		variables.serviceFactory.addAlias("entity","beanEntity");

		application.serviceFactory=variables.serviceFactory;
		application.serviceFactory.getBean('utility').setRequestTimeout(1000);

	if ( listfindnocase('oracle,postgresql,nuodb', application.configBean.getDbType()) ) {
		application.configBean.setDbCaseSensitive(true);
	}
	try {
		if ( !application.configBean.getDbCaseSensitive() && application.serviceFactory.getBean('dbUtility').version().database_productname == 'h2' ) {
			application.configBean.setDbCaseSensitive(true);
		}
	} catch (any cfcatch) {
	}
	variables.tracer.commitTracepoint(variables.tracepoint);

	if( application.configBean.getValue(property="purgeQueriesOnAppreload",defaultValue=false) ){
		try {

			application.serviceFactory.getBean('utility').clearObjectCache();

		} catch (any cfcatch) {}
	}


	application.objectMappings={};
	application.objectMappings.bundleableBeans="";
	application.objectMappings.versionedBeans="";
	if ( application.appAutoUpdated || isdefined('url.applyDBUpdates') ) {
		if(application.configBean.getValue(property="applyDbUpdates",defaultValue=true)){
			variables.tracepoint=variables.tracer.initTracepoint("Checking/Applying DB updates");
			application.configBean.applyDbUpdates();
		} else {
			variables.tracepoint=variables.tracer.initTracepoint("Bypassing Checking/Applying DB updates");
		}
		variables.tracer.commitTracepoint(variables.tracepoint);
	} else if ( fileExists(ExpandPath("/muraWRM/config/objectMappings.json.cfm")) ) {
		cffile( variable="variables.objectMappingJSON", file=ExpandPath("/muraWRM/config/objectMappings.json.cfm"), action="read" );
		application.objectMappings=deserializeJSON(variables.objectMappingJSON);
	} else {

		variables.serviceFactory.getBean('approvalChain');
		variables.serviceFactory.getBean('approvalChainMembership');
		variables.serviceFactory.getBean('approvalRequest');
		variables.serviceFactory.getBean('approvalAction');
		variables.serviceFactory.getBean('approvalChainAssignment');
		variables.serviceFactory.getBean('changesetRollBack');
		variables.serviceFactory.getBean('contentSourceMap');
		variables.serviceFactory.getBean('relatedContentSet');
		variables.serviceFactory.getBean('fileMetaData');
		variables.serviceFactory.getBean('file');
		variables.serviceFactory.getBean('razunaSettings');
		variables.serviceFactory.getBean('contentFilenameArchive');
		variables.serviceFactory.getBean('commenter');
		variables.serviceFactory.getBean('userDevice');
		variables.serviceFactory.getBean('userRedirect');
		//variables.serviceFactory.getBean('remoteContentPointer');
		variables.serviceFactory.getBean('contentDisplayInterval');
		variables.serviceFactory.getBean('variationTargeting');
		variables.serviceFactory.getBean('oauthClient');
		variables.serviceFactory.getBean('oauthToken');
		variables.serviceFactory.getBean('entity');
	}

	variables.serviceFactory.getBean('contentCategoryAssign');

	param name="application.muraExternalConfig" default={};

	if (len(application.configBean.getValue('externalConfig'))) {

		if(isValid('url',application.configBean.getValue('externalConfig'))){
			httpService=application.configBean.getHTTPService();
			httpService.setMethod("get");
			httpService.setCharset("utf-8");
			httpService.setURL(application.configBean.getValue('externalConfig'));
			config=httpService.send().getPrefix().filecontent;
		} else if (fileExists(application.configBean.getValue('externalConfig'))) {
			config=fileRead(application.configBean.getValue('externalConfig'),'utf-8');
		}
		if(isJSON(config)){
			application.muraExternalConfig=deserializeJSON(config);
		} else {
			writeLog(type="Error", file="exception", text="Error reading external config from  '#application.configBean.getValue('externalConfig')#': #config#");
		}
	}

	if(	isdefined('url.applyDBUpdates')
			&& isDefined('application.muraExternalConfig.global.entities')
			&& isArray(application.muraExternalConfig.global.entities)
		){
		entities=application.muraExternalConfig.global.entities;
		for(entity in entities){
			if(isJSON(entity)){
				getServiceFactory().declareBean(json=entity,fromExternalConfig=true);
			}
		}
	}

	request.muraattachormlinks=true;
	application.serviceFactory.loadDynamicEntities();
	request.muraattachormlinks=false;

	application.appAutoUpdated=false;

	variables.serviceList="utility,pluginManager,settingsManager,contentManager,eventManager,contentRenderer,contentUtility,contentGateway,categoryManager,clusterManager,contentServer,changesetManager,scriptProtectionFilter,permUtility,emailManager,loginManager,mailinglistManager,userManager,dataCollectionManager,feedManager,sessionTrackingManager,favoriteManager,raterManager,dashboardManager,autoUpdater";
	//  The ad manager has been removed, but may be there in certain legacy conditions
	if ( application.serviceFactory.containsBean('advertiserManager') ) {
		variables.serviceList=listAppend(variables.serviceList,'advertiserManager');
	}
	//  These application level services

	for(variables.i in listToArray(variables.serviceList)){
		variables.tracepoint=variables.tracer.initTracepoint("Instantiating #variables.i#");
		application["#variables.i#"]=application.serviceFactory.getBean("#variables.i#");
		variables.tracer.commitTracepoint(variables.tracepoint);
	}

	application.mura=application.serviceFactory.getBean('mura');
	request.muraattachormlinks=true;

	//  End

	variables.temp='';
	application.badwords = ReReplaceNoCase(trim(variables.temp), "," , "|" , "ALL");
	variables.tracepoint=variables.tracer.initTracepoint("Instantiating classExtensionManager");
	application.classExtensionManager=application.configBean.getClassExtensionManager();
	variables.tracer.commitTracepoint(variables.tracepoint);
	variables.tracepoint=variables.tracer.initTracepoint("Instantiating resourceBundleFactory");
	application.rbFactory=new mura.resourceBundle.resourceBundleFactory();
	variables.tracer.commitTracepoint(variables.tracepoint);
	// settings.custom.managers.cfm reference is for backwards compatibility
	if ( fileExists(ExpandPath("/muraWRM/config/settings.custom.managers.cfm")) ) {
		include "/muraWRM/config/settings.custom.managers.cfm";
	}

	variables.basedir=expandPath("/muraWRM");
	variables.mapprefix="";
	if ( len(application.configBean.getValue('encryptionKey')) ) {
		application.encryptionKey=application.configBean.getValue('encryptionKey');
	}

	if ( application.configBean.getValue("autoDiscoverPlugins") && !isdefined("url.safemode") ) {
		variables.tracePoint=initTracePoint("Discovering Plugins");
		application.pluginManager.discover();
		commitTracePoint(variables.tracePoint);
	}
	application.cfstatic=structNew();
	application.appInitialized=true;
	application.appInitializedTime=now();
	variables.tracePoint=initTracePoint("Broadcasting Init:application.broadcastInit #application.broadcastInit#");
	application.clusterManager.reload(broadcast=application.broadcastInit);
	commitTracePoint(variables.tracePoint);
	application.broadcastInit=true;

	structDelete(application,"muraAdmin");
	structDelete(application,"proxyServices");
	structDelete(application,"CKFinderResources");
	//  Set up scheduled tasks
	if ( (len(application.configBean.getServerPort())-1) < 1 ) {
		variables.port=80;
	} else {
		variables.port=right(application.configBean.getServerPort(),len(application.configBean.getServerPort())-1);
	}
	if ( listFindNoCase('Railo,Lucee',application.configBean.getCompiler()) ) {
		variables.siteMonitorTask="siteMonitor";
	} else {
		variables.siteMonitorTask="#application.configBean.getWebRoot()#/index.cfm/_api/sitemonitor/";
	}
	try {
		if ( isBoolean(variables.iniProperties.ping) && variables.iniProperties.ping ) {
			variables.tracePoint=initTracePoint("Setting Ping Scheduled Task");
			local.updateurl = "http://" & listFirst(cgi.http_host,":") & application.configBean.getContext() & "/index.cfm/_api/sitemonitor/";
			application.serviceFactory.getBean('utility').scheduleTask(
				action = "update",
				task = "#variables.siteMonitorTask#",
				operation = "HTTPRequest",
				url = "#local.updateurl#",
				port="#variables.port#",
				startDate = "#dateFormat(now(),'mm/dd/yyyy')#",
				startTime = "#createTime(0,15,0)#",
				publish = "No",
				interval = "900",
				requestTimeOut = "600"
			);
			commitTracePoint(variables.tracePoint);
		}
	} catch (any cfcatch) {
	}

	//BEGIN CONFIG DIR MANAGEMENT
	if ( !fileExists(application.configBean.getWebRoot() & "/config/Application.cfc") ) {
		variables.tracePoint=initTracePoint("Writing config/Application.cfc");
		fileCopy("#application.configBean.getWebRoot()#/core/templates/Application.cfc","#application.configBean.getWebRoot()#/config/Application.cfc");
		try {
			fileSetAccessMode("#application.configBean.getWebRoot()#/config/Application.cfc","777");
		} catch (any cfcatch) {}
		commitTracePoint(variables.tracePoint);
	}

	if (directoryExists(application.configBean.getWebRoot() & "/resource_bundles") && !fileExists(application.configBean.getWebRoot() & "/resource_bundles/Application.cfc") ) {
		variables.tracePoint=initTracePoint("Writing resource_bundles/Application.cfc");
		fileCopy("#application.configBean.getWebRoot()#/core/templates/Application.cfc","#application.configBean.getWebRoot()#/resource_bundles/Application.cfc");
		try {
			fileSetAccessMode("#application.configBean.getWebRoot()#/resource_bundles/Application.cfc","777");
		} catch (any cfcatch) {}
		commitTracePoint(variables.tracePoint);
	}

	if (
		fileExists(application.configBean.getWebRoot() & "/config/appcfc/onApplicationStart_method.cfm")
		|| (
				fileExists(application.configBean.getWebRoot() & "/config/applicationSettings.cfm")
				&& !application.configBean.getValue(property='legacyAppcfcSupport',defaultvalue=false)
			)
	 ) {

		if (directoryExists(application.configBean.getWebRoot() & "/config/appcfc") ) {
			directoryDelete(application.configBean.getWebRoot() & "/config/appcfc",true);
		}

		if (fileExists(application.configBean.getWebRoot() & "/config/applicationSettings.cfm") ) {
			fileDelete(application.configBean.getWebRoot() & "/config/applicationSettings.cfm");
		}

		if (fileExists(application.configBean.getWebRoot() & "/config/settings.cfm") ) {
			fileDelete(application.configBean.getWebRoot() & "/config/settings.cfm");
		}

		if (fileExists(application.configBean.getWebRoot() & "/config/mappings.cfm") ) {
			fileDelete(application.configBean.getWebRoot() & "/config/mappings.cfm");
		}

		if (fileExists(application.configBean.getWebRoot() & "/config/buildMainMappings.cfm") ) {
			fileDelete(application.configBean.getWebRoot() & "/config/buildMainMappings.cfm");
		}

		if (fileExists(application.configBean.getWebRoot() & "/config/buildPluginCFApplication.cfm") ) {
			fileDelete(application.configBean.getWebRoot() & "/config/buildPluginCFApplication.cfm");
		}

		if (fileExists(application.configBean.getWebRoot() & "/config/buildPluginMappings.cfm") ) {
			fileDelete(application.configBean.getWebRoot() & "/config/buildPluginMappings.cfm");
		}

		if (
				fileExists(application.configBean.getWebRoot() & "/config/appcfc/onApplicationStart_method.cfm") &&
				fileExists(application.configBean.getWebRoot() & "/config/lockdown.cfm")
			) {
			fileDelete(application.configBean.getWebRoot() & "/config/lockdown.cfm");
		}
	}

	if(application.configBean.getValue(property='legacyAppcfcSupport',defaultvalue=false)){

		if ( !directoryExists(application.configBean.getWebRoot() & "/config/appcfc") ) {
			variables.tracePoint=initTracePoint("creating config/appcfc");
			try {
				directoryCreate("#application.configBean.getWebRoot()#/config/appcfc");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/appcfc/onApplicationStart_include.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/appcfc/onApplicationStart_include.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/onApplicationStart_include.cfm","#application.configBean.getWebRoot()#/config/appcfc/onApplicationStart_include.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/appcfc/onApplicationStart_include.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/appcfc/onRequestStart_include.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/appcfc/onRequestStart_include.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/onRequestStart_include.cfm","#application.configBean.getWebRoot()#/config/appcfc/onRequestStart_include.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/appcfc/onRequestStart_include.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/appcfc/onSessionEnd_include.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/appcfc/onSessionEnd_include.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/onSessionEnd_include.cfm","#application.configBean.getWebRoot()#/config/appcfc/onSessionEnd_include.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/appcfc/onSessionEnd_include.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/appcfc/onSessionStart_include.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/appcfc/onSessionStart_include.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/onSessionStart_include.cfm","#application.configBean.getWebRoot()#/config/appcfc/onSessionStart_include.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/appcfc/onSessionStart_include.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/appcfc/onSessionEnd_include.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/appcfc/onSessionEnd_include.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/onSessionEnd_include.cfm","#application.configBean.getWebRoot()#/config/appcfc/onSessionEnd_include.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/appcfc/onSessionEnd_include.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/settings.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/applicationSettings.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/settings.cfm","#application.configBean.getWebRoot()#/config/settings.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/settings.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/applicationSettings.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/applicationSettings.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/applicationSettings.cfm","#application.configBean.getWebRoot()#/config/applicationSettings.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/applicationSettings.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

		if ( !fileExists(application.configBean.getWebRoot() & "/config/mappings.cfm") ) {
			variables.tracePoint=initTracePoint("Writing config/mappings.cfm");
			fileCopy("#application.configBean.getWebRoot()#/core/templates/appcfc/mappings.cfm","#application.configBean.getWebRoot()#/config/mappings.cfm");
			try {
				fileSetAccessMode("#application.configBean.getWebRoot()#/config/mappings.cfm","777");
			} catch (any cfcatch) {}
			commitTracePoint(variables.tracePoint);
		}

	}
	//END CONFIG DIR MANAGEMENT

	if ( application.configBean.getCreateRequiredDirectories() ) {
		variables.tracePoint=initTracepoint("Checking required directories");
		if ( !directoryExists("#application.configBean.getWebRoot()#/plugins") ) {
			try {
				local.fileWriter.createDir( mode=777, directory="#application.configBean.getWebRoot()#/plugins" );
			} catch (any cfcatch) {
				local.fileWriter.createDir(directory="#application.configBean.getWebRoot()#/plugins");
			}
		}

		if ( directoryExists("#application.configBean.getWebRoot()#/modules") && !fileExists("#application.configBean.getWebRoot()#/modules/Application.cfc") ) {
			local.fileWriter.copyFile(source="#variables.basedir#/core/templates/site/application.depth1.template.cfc", destination="#variables.basedir#/modules/Application.cfc");
		}

		if ( directoryExists("#application.configBean.getWebRoot()#/sites") && !fileExists("#application.configBean.getWebRoot()#/sites/Application.cfc") ) {
			local.fileWriter.copyFile(source="#variables.basedir#/core/templates/site/application.depth1.template.cfc", destination="#variables.basedir#/sites/Application.cfc");
		}

		if ( !fileExists(variables.basedir & "/robots.txt") ) {
			local.fileWriter.copyFile(source="#variables.basedir#/core/templates/robots.template.cfm", destination="#variables.basedir#/robots.txt");
		}
		if ( findNoCase('Windows',Server.OS.Name) && !fileExists(variables.basedir & "/web.config") ) {
			local.fileWriter.copyFile(source="#variables.basedir#/core/templates/web.config.template.cfm", destination="#variables.basedir#/web.config");
		}
		if ( !fileExists(variables.basedir & "/core/vendor/cfformprotect/cffp.ini.cfm") ) {
			local.fileWriter.copyFile(source="#variables.basedir#/core/templates/cffp.ini.template.cfm", destination="#variables.basedir#/core/vendor/cfformprotect/cffp.ini.cfm");
		}
		commitTracePoint(variables.tracePoint);
	}
	if ( !structKeyExists(application,"plugins") ) {
		application.plugins=structNew();
	}
	application.pluginstemp=application.plugins;
	application.plugins=structNew();
	variables.pluginEvent=createObject("component","mura.event").init();

	if ( structKeyExists(request.muraSysEnv,'MURA_PROJECTSITEID') ) {
		application.configBean.setProjectSiteID(request.muraSysEnv['MURA_PROJECTSITEID']);
	}

	projectSiteID=application.configBean.getValue(property='ProjectSiteID',defaultValue='default');

	if(projectSiteID != 'default'  && !application.settingsManager.siteExists(projectSiteID)){

		domain=listFirst(cgi.http_host,":");

		if( domain eq '127.0.0.1') {
				domain='localhost';
		}

		application.settingsManager.create({
			siteid=projectSiteID,
			domain=domain,
			site=application.configBean.getValue(property='title',defaultValue='Mura CMS'),
			orderno=1,
			autocreated=true
			});

		if(projectSiteID != 'default' && application.settingsManager.getSite('default').getOrderNo() lt 2){
			application.settingsManager.update({
				siteid='default',
				orderno=2
			});
		}

		application.settingsManager.setSites();
	}

	if ( request.muraInDocker ) {
		local.bundleLoc="/tmp/MuraBundle.zip";
	} else {
		local.bundleLoc=expandPath("/muraWRM/config/setup/deploy/bundle.zip");
	}

	if ( fileExists(local.bundleLoc) && application.contentGateway.getPageCount(projectSiteID).counter == 1 ) {
		application.settingsManager.restoreBundle(
			bundleFile=local.bundleLoc,
			keyMode='publish',
			siteID=projectSiteID,
			contentMode='all',
			pluginMode='all'
		);
	}

	try {
		application.pluginManager.executeScripts(runat='onApplicationLoad',event= variables.pluginEvent);
	} catch (any cfcatch) {
		structAppend(application.plugins,application.pluginstemp,false);
		structDelete(application,"pluginstemp");
		rethrow;
	}
	structDelete(application,"pluginstemp");
	//  Fire local onApplicationLoad events
	variables.rsSites=application.settingsManager.getList();
	variables.tracePoint1=initTracePoint("Loading Themes");
	for(i=1;i <= variables.rsSites.recordcount;i++){
		variables.siteBean=application.settingsManager.getSite(variables.rsSites['siteid'][i]);
		variables.themedir=expandPath(variables.siteBean.getThemeIncludePath());
		if ( fileExists(variables.themedir & '/config.xml.cfm') ) {
			variables.themeConfig='config.xml.cfm';
		} else if ( fileExists(variables.themedir & '/config.xml') ) {
			variables.themeConfig='config.xml';
		} else {
			variables.themeConfig="";
		}
		if ( len(variables.themeConfig) ) {
			if ( variables.themeConfig == "config.xml.cfm" ) {
				savecontent variable="variables.themeConfig" {
					include "#variables.siteBean.getThemeIncludePath()#/config.xml.cfm";
				}
			} else {
				variables.themeConfig=fileRead(variables.themedir & "/" & variables.themeConfig);
			}
			if ( IsValid('xml', variables.themeConfig) ) {
				variables.themeConfig=xmlParse(variables.themeConfig);
				application.configBean.getClassExtensionManager().loadConfigXML(variables.themeConfig,variables.rsSites['siteid'][i]);
			}
		}
		variables.localHandler=variables.siteBean.getLocalHandler();
		if ( isObject(variables.localHandler) ) {
			if ( structKeyExists(variables.localhandler,"onApplicationLoad") ) {
				variables.pluginEvent.setValue("siteID",variables.rsSites['siteid'][i]);
				variables.pluginEvent.loadSiteRelatedObjects();
				if ( !isDefined('variables.localhandler.injectMethod') ) {
					variables.localhandler.injectMethod=variables.pluginEvent.injectMethod;
				}
				if ( !isDefined('variables.localhandler.getValue') ) {
					variables.localhandler.injectMethod('getValue',variables.pluginEvent.getValue);
				}
				if ( !isDefined('variables.localhandler.setValue') ) {
					variables.localhandler.injectMethod('setValue',variables.pluginEvent.setValue);
				}
				variables.tracepoint=application.pluginManager.initTracepoint("#variables.localhandler.getValue('_objectName')#.onApplicationLoad");
				variables.localhandler.onApplicationLoad(event=variables.pluginEvent,$=variables.pluginEvent.getValue("muraScope"),mura=variables.pluginEvent.getValue("muraScope"),m=variables.pluginEvent.getValue("muraScope"));
				application.pluginManager.commitTracepoint(variables.tracepoint);
			}
		}
		variables.expandedPath=expandPath(variables.siteBean.getThemeIncludePath()) & "/eventHandler.cfc";
		if ( fileExists(variables.expandedPath) ) {
			variables.themeHandler=createObject("component","#variables.siteBean.getThemeAssetMap()#.eventHandler").init();
			if ( structKeyExists(variables.themeHandler,"onApplicationLoad") ) {
				variables.pluginEvent.setValue("siteID",variables.rsSites['siteid'][i]);
				variables.pluginEvent.loadSiteRelatedObjects();
				if ( !isDefined('variables.themeHandler.injectMethod') ) {
					variables.themeHandler.injectMethod=variables.pluginEvent.injectMethod;
				}
				if ( !isDefined('variables.themeHandler.getValue') ) {
					variables.themeHandler.injectMethod('getValue',variables.pluginEvent.getValue);
				}
				if ( !isDefined('variables.themeHandler.setValue') ) {
					variables.themeHandler.injectMethod('setValue',variables.pluginEvent.setValue);
				}
				variables.themeHandler.setValue("_objectName","#variables.siteBean.getThemeAssetMap()#.eventHandler");
				variables.tracepoint=application.pluginManager.initTracepoint("#variables.themeHandler.getValue('_objectName')#.onApplicationLoad");
				variables.themeHandler.onApplicationLoad(event=variables.pluginEvent,$=variables.pluginEvent.getValue("muraScope"),mura=variables.pluginEvent.getValue("muraScope"),m=variables.pluginEvent.getValue("muraScope"));
				application.pluginManager.commitTracepoint(variables.tracepoint);
			}
			application.pluginManager.addEventHandler(variables.themeHandler,variables.rsSites['siteid'][i]);
		}

	}
	commitTracePoint(variables.tracePoint1);

	if(!application.configBean.getValue(property='readonly',defaultValue=false)){
		variables.tracePoint=initTracePoint("Updating Legacy URL data");
		qs=new Query();

		variables.legacyURLs=qs.execute(sql="select contenthistID, contentID,parentId,siteID,filename,urlTitle,filename from tcontent where type in ('File','Link')
			and active=1
			and body is null
			and filename is not null").getResult();

		variables.legacyURLsIterator=application.serviceFactory.getBean("contentIterator").setQuery(variables.legacyURLs);

		while ( variables.legacyURLsIterator.hasNext() ) {
			variables.item=variables.legacyURLsIterator.next();

			qs=new Query();
			qs.addParam(name="contentid", cfsqltype="cf_sql_varchar", value=variables.item.getContentID() );
			qs.addParam(name="siteid", cfsqltype="cf_sql_varchar", value=variables.item.getSiteID() );

			qs.execute(sql="update tcontent set body=filename where contentID= :contentid and siteid = :siteid and body is null");

			application.serviceFactory.getBean("contentUtility").setUniqueFilename(variables.item);
			try {

				qs=new Query();

				qs.addParam( name="filename",cfsqltype="cf_sql_varchar", value=variables.item.getFilename() );
				qs.addParam(name="urltitle", cfsqltype="cf_sql_varchar", value=variables.item.getURLTitle() );
				qs.addParam(name="contentid", cfsqltype="cf_sql_varchar", value=variables.item.getContentID() );
				qs.addParam(name="siteid", cfsqltype="cf_sql_varchar", value=variables.item.getSiteID() );

				qs.execute(sql="update tcontent set filename= :filename, urlTitle= :urltitle where contentid= :contentid and siteid= :siteid");

			} catch (any cfcatch) {
				throw( message="An error occurred trying to create a filename for #variables.item.getFilename()#" );
			}
		}
		commitTracePoint(variables.tracePoint);
	}

	//  Clean root admin directory
	variables.tracePoint=initTracePoint("Clean admin directory");
	local.fileWriter=application.serviceFactory.getBean('fileWriter');
	local.rs=local.fileWriter.getDirectoryList(expandPath('/muraWRM#application.configBean.getAdminDir()#/'));
	local.tempDir=expandPath('/muraWRM#application.configBean.getAdminDir()#/temp/');

	if(local.rs.recordcount){
		for(i=1;i <= local.rs.recordcount;i++){
			if ( !listFind('.gitignore,.svn,Application.cfc,assets,common,core,framework.cfc,index.cfm,temp,custom,framework',local.rs['name'][i]) ) {
				try {
					local.fileWriter.touchDir(local.tempDir);
					if ( local.rs['type'][i] == 'dir' ) {
						local.fileWriter.renameDir(directory=local.rs['directory'][i] & "/" & local.rs['name'][i],newDirectory=local.rs['directory'][i] & "/temp/" & local.rs['name'][i] );
					} else {
						local.fileWriter.renameFile(source=local.rs['directory'][i] & "/" & local.rs['name'][i],destination=local.rs['directory'][i] & "/temp/" & local.rs['name'][i] );
					}
				} catch (any cfcatch) {
				}
			}
		}
	}
	commitTracePoint(variables.tracePoint);

	//These were added to remove previous resource bundles tha were two specific
	if(fileExists(expandPath("/muraWRM/core/mura/resourceBundle/resources/en_US.properties"))){
		local.fileWriter=application.Mura.getBean('fileWriter');
		local.rs=application.Mura.getBean('fileWriter').getDirectoryList(expandPath("/muraWRM/core/mura/resourceBundle/resources/"));
		for(local.i=1;local.i <= local.rs.recordcount;local.i++){
			if(listLen(listFirst(local.rs.name[local.i],'.'),'_') > 1){
				fileDelete(local.rs.directory[local.i] & "/" & local.rs.name[local.i]);
			}
		}
	}

	if(fileExists(expandPath("/muraWRM/core/modules/v1/core_assets/resource_bundles/en_US.properties"))){
		local.fileWriter=application.Mura.getBean('fileWriter');
		local.rs=application.Mura.getBean('fileWriter').getDirectoryList(expandPath("/muraWRM/core/modules/v1/core_assets/resource_bundles/"));
		for(local.i=1;local.i <= local.rs.recordcount;local.i++){
			if(listLen(listFirst(local.rs.name[local.i],'.'),'_') > 1 && !listFind('zh_TW.properties,zh_CN.properties',local.rs.name[local.i])){
				fileDelete(local.rs.directory[local.i] & "/" & local.rs.name[local.i]);
			}
		}
	}

	if(isDefined('application.muraExternalConfig.global.modules') && isStruct(application.muraExternalConfig.global.modules)){
		modules=application.muraExternalConfig.global.modules;
		sites=application.configBean.getBean('settingsManager').getSites();
		for(m in modules){
			if(isStruct(modules['#m#'])){
				module=modules['#m#'];
				module.object=m;
				module.displayObjectFile="external/index.cfm";
				module.external=true;
				for(s in sites){
					sites['#s#'].registerDisplayObject(argumentCollection=module);
				}

			}
		}
	}

	if(isDefined('application.muraExternalConfig.sites') && isStruct(application.muraExternalConfig.sites)){
		sites=application.configBean.getBean('settingsManager').getSites();
		for(s in sites){
			if(isValid('variableName',s) && isDefined('application.muraExternalConfig.sites.#s#') && isStruct(application.muraExternalConfig.sites['#s#'])){
				modules=application.muraExternalConfig.sites['#s#'];
				for(m in modules){
					if(isStruct(modules['#m#'])){
						module=modules['#m#'];
						module.object=m;
						module.displayObjectFile="external/index.cfm";
						module.external=true;
						sites['#s#'].registerDisplayObject(argumentCollection=module);
					}
				}
			}
		}

	}


	application.sessionTrackingThrottle=false;

	application.clusterManager.clearOldCommands();
}
</cfscript>
