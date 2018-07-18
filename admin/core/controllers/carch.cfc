component extends="controller" output="false" {

	public function setContentManager(contentManager) output=false {
		variables.contentManager=arguments.contentManager;
	}

	public function setContentUtility(contentUtility) output=false {
		variables.contentUtility=arguments.contentUtility;
	}

	public function setContentGateway(contentGateway) output=false {
		variables.contentGateway=arguments.contentGateway;
	}

	public function before(rc) output=false {
		param default="" name="session.openSectionList";
		if ( !variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid) ) {
			secure(arguments.rc);
		}
		param default=false name="arguments.rc.ajaxrequest";
		param default="00000000000000000000000000000000000" name="arguments.rc.moduleid";
		param default="" name="arguments.rc.instanceid";
		if ( !arguments.rc.ajaxrequest ) {
			param default="" name="arguments.rc.return";
			param default=1 name="arguments.rc.startrow";
			param default="" name="arguments.rc.contentid";
			param default="Page" name="arguments.rc.ptype";
			param default="Page" name="arguments.rc.type";
			param default=createuuid(), name="arguments.rc.contentHistID";
			param default="" name="arguments.rc.parenthistid";
			param default="" name="arguments.rc.notify";
			param default=0 name="arguments.rc.preview";
			param default=20 name="arguments.rc.size";
			param default="" name="arguments.rc.action";
			param default="" name="arguments.rc.closeCompactDisplay";
			param default="" name="arguments.rc.compactDisplay";
			param default="" name="arguments.rc.returnURL";
			param default="" name="arguments.rc.homeID";
			param default=variables.configBean.getDatasource(), name="arguments.rc.datasource";
			param default="" name="arguments.rc.objectid";
			param default=false name="arguments.rc.locking";
			param default="" name="arguments.rc.moduleAssign";
			param default=0 name="arguments.rc.orderno";
			param default=false name="arguments.rc.cancelPendingApproval";
			param default=variables.settingsManager.getSite(arguments.rc.siteid).getviewdepth(), name="session.mura.viewDepth";
			param default=variables.settingsManager.getSite(arguments.rc.siteid).getnextN(), name="session.mura.nextN";
			param default="" name="session.keywords";
			param default="" name="arguments.rc.date1";
			param default="" name="arguments.rc.date2";
			param default="" name="arguments.rc.return";
			param default=false name="arguments.rc.ommitPublishingTab";
			param default=false name="arguments.rc.ommitRelatedContentTab";
			param default=false name="arguments.rc.ommitAdvancedTab";
			param default=false name="arguments.rc.murakeepediting";
			param default=false name="arguments.rc.locknode";
			if ( !arguments.rc.ommitPublishingTab ) {
			  param default=0 name="arguments.rc.isNav";
			  param default="_self" name="arguments.rc.target";
			  param default=0 name="arguments.rc.searchExclude";
			  param default=0 name="arguments.rc.restricted";
			  param default=0 name="arguments.rc.mobileExclude";
			}
			if ( !arguments.rc.ommitAdvancedTab ) {
			  param default=0 name="arguments.rc.isLocked";
			  param default=0 name="arguments.rc.forceSSL";
			  param default=1 name="arguments.rc.doCache";
			  param default=0 name="arguments.rc.displayTitle";
			}
			if ( !arguments.rc.ommitRelatedContentTab ) {
			  param default="" name="arguments.rc.relatedContentSetData";
			}
			if ( len(arguments.rc.instanceid) ) {
			  session.mura.objectInstanceId=arguments.rc.instanceid;
			}
			param default=0 name="arguments.rc.responseChart";
			param default="" name="arguments.rc.parentid";
			param default=00000000000000000000000000000000000 name="session.moduleid";
			if ( !listFind('00000000000000000000000000000000000,000000000000000000000000000000000099,00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000099',session.moduleid) ) {
				session.moduleid='00000000000000000000000000000000000';
			}
			if ( len(arguments.rc.moduleid) && listFind('00000000000000000000000000000000000,000000000000000000000000000000000099,00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000099',arguments.rc.moduleid) ) {
				session.moduleid=arguments.rc.moduleid;
			}
			if ( len(arguments.rc.moduleid) && session.moduleid != arguments.rc.moduleid ) {
				arguments.rc.moduleid=session.moduleid;
			} else if ( !len(arguments.rc.moduleid) ) {
				arguments.rc.moduleid=session.moduleid;
			}
			if ( !structKeyExists(session,'m00000000000000000000000000000000000') ) {
				session['m00000000000000000000000000000000000']={topid="00000000000000000000000000000000001"};
			}
			if ( !structKeyExists(session,'m00000000000000000000000000000000003') ) {
				session['m00000000000000000000000000000000003']={topid="00000000000000000000000000000000003"};
			}
			if ( !structKeyExists(session,'m00000000000000000000000000000000004') ) {
				session['m00000000000000000000000000000000004']={topid="00000000000000000000000000000000004"};
			}
			if ( !structKeyExists(session,'m00000000000000000000000000000000099') ) {
				session['m00000000000000000000000000000000099']={topid="00000000000000000000000000000000099"};
			}

			if ( !isDefined("arguments.rc.topid") || !len(arguments.rc.topid) ) {
				arguments.rc.topid=session['m#session.moduleid#'].topid;
			}

			session['m#session.moduleid#']={topid=arguments.rc.topid};
		}
	}

	public function export(rc) output=false {

		var local = {};

			local.currentBean = getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);

			if ( local.currentBean.getIsNew() ) {
				rc.moduleid = '00000000000000000000000000000000000';
				variables.fw.redirect(action='cArch.list', append='siteid,moduleid', path='./');
			} else if ( !local.currentBean.getKidsIterator().getRecordCount() ) {
				variables.fw.redirect(action='cArch.exportcontent', append='contentid,siteid', path='./');
			}

			arguments.rc.crumbdata = variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid,true);
	}

	public function exportcontent(rc) output=false {
		var settingsBundle = rc.$.getBean('settingsBundle');
		var contentBean = rc.$.getBean('content').loadBy(siteid=session.siteid,contentid=arguments.rc.contentID);
		param default=0 name="rc.doChildrenOnly";
		settingsBundle.bundle(siteid=session.siteid,parentid=arguments.rc.contentID,bundlename='export_#rereplace(contentBean.getValue('filename'),"[^[:alnum:]]{1,}","_","all")#',doChildrenOnly=rc.doChildrenOnly);
	}

	public function importcontent(rc) output=false {
		var contentUtility = arguments.rc.$.getBean('contentUtility');
		var hasChangesets = rc.$.getBean('settingsManager').getSite(rc.$.event('siteID')).getValue('hasChangesets');
		var enforceChangesets = rc.$.getBean('settingsManager').getSite(rc.$.event('siteID')).getValue('enforceChangesets');
		if ( (arguments.rc.import_status == "Changeset" || enforceChangesets) && (not structKeyExists(arguments.rc,"changeset_name") || !len(arguments.rc.changeset_name)) ) {
			arguments.rc.changeset_name = "partial_import_#dateformat(now(),"dd_mm_yyyy")#_#timeformat(now(),"hh_mm_ss")#";
			arguments.rc.import_status = "Changeset";
		}
		if ( structKeyExists(arguments.rc,"newfile") && len(arguments.rc.newfile) ) {
			contentUtility.deployPartialBundle(siteid=session.siteid,parentid=arguments.rc.contentid,bundlefile="newFile",importstatus=rc.import_status,changesetname=rc.changeset_name);
			variables.fw.redirect(action="cArch.list",append="siteid,moduleid",path="./");
		} else {
			variables.fw.redirect(action="cArch.import",append="contentid,moduleid,siteid",path="./");
		}
	}

	public string function exportcomponent(struct rc="#StructNew()#") output=false {
		var zipTool	= createObject("component","mura.Zip");
		var tempDir=getTempDirectory();

		var componentStruct = getBean('content').loadBy(contentID=arguments.rc.contentid,siteid=rc.siteid ).getAllValues();
		var componentJSON = {};

		componentJSON.body = componentStruct.body;
		componentJSON = serializeJSON(componentJSON);

		var zipTitle = rereplaceNoCase(lcase(componentStruct.title),"[^a-zA-Z0-9]{1,}","_","all") & "_" & dateFormat(now(),"yyyy_dd_mm") & "_" & rc.siteid;

		rc.zipFileLocation = "#tempDir#/component-#zipTitle#.zip";
		rc.zipTitle = zipTitle;

		fileWrite(tempDir & "/component.json",componentJSON);
		zipTool.AddFiles(zipFilePath=rc.zipFileLocation,directory=tempDir,recurse="false",filter="*.json");
	}

	public string function importcomponent(struct rc="#StructNew()#") output=false {
		var zipTool	= createObject("component","mura.Zip");
		var tempDir=getTempDirectory();
		var tempFolder = createUUID();

		if(structCount(form) && form.componentzip != '') {

			if(form.title == "") {
				rc.errormessage="Title is required";
				return;
			}

			directoryCreate("#tempDir#/#tempFolder#");
			var uploadedFile = fileUpload("#tempDir#/#tempFolder#","form.componentzip","application/zip","overwrite");

			zipTool.Extract(zipFilePath="#tempDir#/#tempFolder#/#uploadedfile.serverfile#",extractPath="#tempDir#/#tempFolder#",overwriteFiles=true);

			var componentJSON = fileRead("#tempDir#/#tempFolder#/component.json");

			if(!isJSON(componentJSON)) {
				rc.errormessage="Upload did not contain an exported Mura CMS component";
				return;
			}

			var componentStruct = deserializeJSON(componentJSON);
			var newcomponentBean = getBean('content');

			newcomponentBean.set('type','Component');
			newcomponentBean.set('siteid',rc.siteid);
			newcomponentBean.set('moduleid','00000000000000000000000000000000003');
			newcomponentBean.set('body',componentStruct.body);
			newcomponentBean.set('title',form.title);

			newcomponentBean.save();
			location("?muraAction=cArch.list&siteid=#rc.siteid#&topid=00000000000000000000000000000000003&moduleid=00000000000000000000000000000000003&activeTab=0",false);
		}

	}



	public function list(rc) output=false {
		arguments.rc.rsTop=variables.contentManager.getlist(arguments.rc);
		if ( !arguments.rc.rsTop.recordcount ) {
			if ( arguments.rc.moduleid == '00000000000000000000000000000000000' ) {
				arguments.rc.topid='00000000000000000000000000000000001';
			} else {
				arguments.rc.topid=arguments.rc.moduleid;
			}
			session['#session.moduleid#']={topid=arguments.rc.topid};
			arguments.rc.rsTop=variables.contentManager.getlist(arguments.rc);
		}
		if ( !listFind('00000000000000000000000000000000099,00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000000',arguments.rc.moduleid ) ) {
			arguments.rc.nextN=variables.utility.getNextN(arguments.rc.rsTop,30,arguments.rc.startrow);
		}
	}

	public function loadsitemanager(rc) output=false {
		arguments.rc.rsTop=variables.contentManager.getlist(arguments.rc);
		if ( !arguments.rc.rsTop.recordcount ) {
			if ( arguments.rc.moduleid == '00000000000000000000000000000000000' ) {
				arguments.rc.topid='00000000000000000000000000000000001';
			} else {
				arguments.rc.topid=arguments.rc.moduleid;
			}
			session['#session.moduleid#']={topid=arguments.rc.topid};
			arguments.rc.rsTop=variables.contentManager.getlist(arguments.rc);
		}
		if ( !listFind('00000000000000000000000000000000099,00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000000',arguments.rc.moduleid) ) {
			arguments.rc.nextN=variables.utility.getNextN(arguments.rc.rsTop,30,arguments.rc.startrow);
		}
	}

	public function loadrepomanager(rc) output=false {
		loadsitemanager(argumentCollection=arguments);
	}

	public function draft(rc) output=false {
		arguments.rc.rsList=variables.contentManager.getDraftList(arguments.rc.siteid);
	}

	public function saveQuickEdit(rc) output=false {
		var local=structNew();
		if ( rc.$.validateCSRFTokens(context=rc.contentid & "quickedit") ) {
			local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);
			local.crumbdata=variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid);
			local.perm=variables.permUtility.getNodePerm(local.crumbData);
			local.args={};
			local.args.approved=1;
			if ( arguments.rc.attribute == "isnav" ) {
				local.args.isnav=arguments.rc.isnav;
			} else if ( arguments.rc.attribute == "display" ) {
				local.args.display=arguments.rc.display;
				local.args.displayStop=arguments.rc.displayStop;
				local.args.displayStart=arguments.rc.displayStart;
				local.args.displayInterval=arguments.rc.displayInterval;
			} else if ( arguments.rc.attribute == "template" ) {
				local.args.template=arguments.rc.template;
				local.args.childTemplate=arguments.rc.childTemplate;
			} else if ( arguments.rc.attribute == "inheritObjects" ) {
				local.args.inheritObjects=arguments.rc.inheritObjects;
			} else {
				abort;
			}
			if ( local.perm == "Editor" && !local.contentBean.hasDrafts() ) {
				local.contentBean.set(local.args);
				local.contentBean.save();
			}
		}
		abort;
	}

	public function editLive(rc) output=false {
		param name="arguments.rc.type" default='';
		param name="arguments.rc.title" default='';

		if(len(arguments.rc.title)){
			if(listFindNoCase('form,component',arguments.rc.type)){
				var content=arguments.rc.$.getBean('content').loadBy(title=arguments.rc.title,siteid=arguments.rc.siteid,type=arguments.rc.type);
			} else {
				var content=arguments.rc.$.getBean('content').loadBy(title=arguments.rc.title,siteid=arguments.rc.siteid);
			}
		} else {
			var content=arguments.rc.$.getBean('content').loadBy(contentid=arguments.rc.contentid,siteid=arguments.rc.siteid);
		}
		content.setType(arguments.rc.type);

		location(url="#content.getEditURL(compactDisplay='true')#&instanceid=#esapiEncode('url',arguments.rc.instanceid)#", addtoken=false );

	}

	public function edit(rc) output=false {
		var local=structNew();
		local.currentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);
		if ( local.currentBean.getIsNew() ) {
			arguments.rc.crumbdata=variables.contentManager.getCrumbList(arguments.rc.parentid,arguments.rc.siteid,true);
		} else {
			arguments.rc.crumbdata=variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid,true);
		}
		arguments.rc.contentBean=variables.contentManager.getcontentVersion(arguments.rc.contenthistid,arguments.rc.siteid);
		if ( arguments.rc.type != 'Variation' && arguments.rc.contentid != ''  && arguments.rc.contenthistid != '' && arguments.rc.contentBean.getIsNew() == 1 && !len(arguments.rc.instanceid) ) {
			variables.fw.redirect(action="cArch.hist",append="contentid,siteid,startrow,moduleid,parentid,type",path="./");
		}
		arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid);
		arguments.rc.rsPageCount=variables.contentManager.getPageCount(arguments.rc.siteid);
		arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid);
		arguments.rc.rsTemplates=variables.contentUtility.getTemplates(arguments.rc.siteid,arguments.rc.type);
		if ( arguments.rc.moduleID == '00000000000000000000000000000000000' ) {
			variables.contentManager.setRequestRegionObjects(arguments.rc.contenthistid,arguments.rc.siteid);
		}
		if ( arguments.rc.locknode ) {
			var stats=arguments.rc.contentBean.getStats();
			if ( !len(stats.getLockID()) || stats.getLockID() == session.mura.userid ) {
				stats.setLockID(session.mura.userID).setLockType('node').save();
			}
		}
		//  This is here for backward plugin compatibility
		appendRequestScope(arguments.rc);
	}

	/**
	 * @ouput false
	 */
	public function update(rc) {
		var local=structNew();
		request.newImageIDList="";
		if ( structKeyExists(arguments.rc,'orderno') && !isNumeric(arguments.rc.orderno) ) {
			arguments.rc.orderno=0;
		}
		if ( isDefined('rc.objectparams') && len(rc.objectparams) && !isJSON(rc.objectparams) ) {
			rc.objectparams=URLDecode(rc.objectparams);
		}
		lock type="exclusive" name="admincontroller#arguments.rc.contentID#" timeout="600" {
			arguments.rc.crumbData=variables.contentGateway.getCrumblist(arguments.rc.contentID, arguments.rc.siteid);
			local.currentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);
			if ( !local.currentBean.getIsNew() ) {
				arguments.rc.crumbData=variables.contentGateway.getCrumblist(arguments.rc.contentID, arguments.rc.siteid);
				arguments.rc.perm=variables.permUtility.getNodePerm(arguments.rc.crumbData);
			}
			if ( local.currentBean.getIsNew() && len(arguments.rc.parentID) ) {
				arguments.rc.crumbData=variables.contentGateway.getCrumblist(arguments.rc.parentID, arguments.rc.siteid);
				arguments.rc.perm=variables.permUtility.getNodePerm(arguments.rc.crumbData);
			}
			arguments.rc.allowAction=listFindNoCase('author,editor',arguments.rc.perm);
			if ( arguments.rc.allowAction && arguments.rc.action == 'deleteall' ) {
				if ( rc.$.validateCSRFTokens(context=rc.contentid & "deleteall") ) {
					arguments.rc.topid=variables.contentManager.deleteAll(arguments.rc);
				} else {
				}
			}
			if ( arguments.rc.allowAction && arguments.rc.action == 'deletehistall' ) {
				if ( rc.$.validateCSRFTokens(context=rc.contentid & "deletehistall") ) {
					variables.contentManager.deletehistAll(arguments.rc);
				} else {
				}
			}
			if ( arguments.rc.allowAction && arguments.rc.action == 'delete' ) {
				if ( rc.$.validateCSRFTokens(context=rc.contenthistid & "delete") ) {
					variables.contentManager.delete(arguments.rc);
				} else {
				}
			}
			if ( arguments.rc.allowAction && arguments.rc.action == 'add' ) {
				if ( structKeyExists(arguments.rc,"sourceid") && isValid('UUID',arguments.rc.sourceid) ) {
					arguments.rc.contentBean=getBean('content').loadBy(contentHistID=arguments.rc.sourceid, siteid=arguments.rc.siteid).set(arguments.rc);
				} else if ( structKeyExists(arguments.rc,"contenthistid") && isValid('UUID',arguments.rc.contenthistid) ) {
					arguments.rc.contentBean=getBean('content').loadBy(contentHistID=arguments.rc.contenthistid, siteid=arguments.rc.siteid).set(arguments.rc);
				} else {
					arguments.rc.contentBean=getBean('content').loadBy(contentID=arguments.rc.contentID, siteid=arguments.rc.siteid).set(arguments.rc);
				}
				if ( rc.$.validateCSRFTokens(context=arguments.rc.contentBean.getContentHistID() & "add") ) {
					arguments.rc.contentBean=arguments.rc.contentBean.save();
				} else {
					arguments.rc.contentBean.validate().getErrors().csrf='Your request contained invalid tokens';
				}
			}
		}
		if ( !arguments.rc.ajaxrequest ) {
			if ( arguments.rc.allowAction && arguments.rc.action == 'multifileupload' ) {
				param default=false name="session.mura.multifileupload";
				lock name="multifileupload#application.instanceid#" timeout="5" {
					session.mura.multifileupload=rc.$.validateCSRFTokens(context=arguments.rc.parentid & "multifileupload") || session.mura.multifileupload;
				}
				if ( session.mura.multifileupload ) {
					variables.contentManager.multiFileUpload(arguments.rc);
				} else {
				}
			}
			if ( arguments.rc.allowAction && arguments.rc.action == 'add' && arguments.rc.contentID != '00000000000000000000000000000000001' ) {
				if ( !(
				  	listFindNoCase(session.openSectionList,rc.contentBean.getParentID())
				  	and structKeyExists(session,'#rc.contentBean.getModuleID()#') && listFindNoCase(rc.contentBean.getPath(),session['#rc.contentBean.getModuleID()#'].topID)
				  ) || !len(rc.contentBean.getPath()) ) {
					arguments.rc.topid=rc.contentBean.getParentID();
					session.openSectionList=listAppend(session.openSectionList,rc.contentBean.getParentID());
				}
			}
			if ( !arguments.rc.murakeepediting ) {
				arguments.rc.murakeepediting=arguments.rc.contentBean.getDisplayConflicts().hasNext();
			}
			if ( (arguments.rc.closeCompactDisplay != 'true'  || arguments.rc.murakeepediting) && arguments.rc.action != 'multiFileUpload' ) {
				if ( len(arguments.rc.returnURL) && (arguments.rc.action == 'delete' || arguments.rc.action == 'deletehistall' || (arguments.rc.preview == 0 && !arguments.rc.murakeepediting)) ) {
					location(url=rc.returnURL, addtoken=false );
				}
				if ( arguments.rc.action == 'delete' || arguments.rc.action == 'deletehistall' || (arguments.rc.return == 'hist' && arguments.rc.preview == 0 && !arguments.rc.murakeepediting && structIsEmpty(arguments.rc.contentBean.getErrors())) ) {
					variables.fw.redirect(action="cArch.hist",append="contentid,siteid,startrow,moduleid,parentid,type,compactDisplay");
				}
				if ( arguments.rc.return == 'changesets' && len(rc.contentBean.getChangesetID()) && !arguments.rc.murakeepediting ) {
					variables.fw.redirect(action="cChangesets.assignments",append="changesetID,siteid",path="./");
				}
				if ( structIsEmpty(arguments.rc.contentBean.getErrors()) ) {
					structDelete(session.mura,"editBean");
					if ( arguments.rc.preview == 0 && !arguments.rc.murakeepediting ) {
						variables.fw.redirect(action="cArch.list",append="topid,siteid,startrow,moduleid",path="./");
					} else {
						arguments.rc.parentid=arguments.rc.contentBean.getParentID();
						arguments.rc.type=arguments.rc.contentBean.getType();
						arguments.rc.contentid=arguments.rc.contentBean.getContentID();
						arguments.rc.contenthistid=arguments.rc.contentBean.getContentHistID();
						arguments.rc.preview=arguments.rc.preview;
						variables.fw.redirect(action="cArch.edit",append="contenthistid,contentid,type,parentid,topid,siteid,moduleid,preview,startrow,return,compactDisplay",path="./");
					}
				}
			}
		}
	}

	/**
	 * @ouput false
	 */
	public function hist(rc) {
		arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid);
		arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid);
	}

	/**
	 * @ouput false
	 */
	public function audit(rc) {
		arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid);
		arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid);
	}

	/**
	 * @ouput false
	 */
	public function datamanager(rc) {
		arguments.rc.crumbData=variables.contentManager.getCrumbList(arguments.rc.contentid,arguments.rc.siteid);
		arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid);
	}

	/**
	 * @ouput false
	 */
	public function downloaddata(rc) {
		arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid);
		arguments.rc.datainfo=variables.contentManager.getDownloadselect(arguments.rc.contentid,arguments.rc.siteid);
	}

	/**
	 * @ouput false
	 */
	public function search(rc) {
		arguments.rc.rslist=variables.contentManager.getPrivateSearch(arguments.rc.siteid,arguments.rc.keywords);
		session.keywords=rc.keywords;
		arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rsList,30,arguments.rc.startrow);
	}

	/**
	 * @ouput false
	 */
	public function loadNotify(rc) {
		if ( arguments.rc.contentid == '' ) {
			arguments.rc.crumbData=variables.contentManager.getCrumbList(arguments.rc.parentid,arguments.rc.siteid);
		} else {
			arguments.rc.crumbData=variables.contentManager.getCrumbList(arguments.rc.contentid,arguments.rc.siteid);
		}
	}

	/**
	 * @ouput false
	 */
	public function copy(rc) {
		variables.contentManager.copy(arguments.rc.siteid,arguments.rc.contentID,arguments.rc.parentID,arguments.rc.copyAll, true, true);
		abort;
	}

	/**
	 * @ouput false
	 */
	public function siteManagerTab(rc) {
		param default=structNew() name="session.flatViewArgs";
		if ( !structKeyExists(session.flatViewArgs,'#session.siteID#') ) {
			session.flatViewArgs['#session.siteID#']=structNew();
		}
		session.flatViewArgs['#session.siteID#'].tab=arguments.rc.tab;
		abort;
	}

	/**
	 * @ouput false
	 */
	public function saveCopyInfo(rc) {
		variables.contentManager.saveCopyInfo(arguments.rc.siteid,arguments.rc.contentID,arguments.rc.moduleid,arguments.rc.copyAll);
		abort;
	}

	/**
	 * @ouput false
	 */
	public function multiFileUpload(rc) {
		arguments.rc.crumbdata=variables.contentManager.getCrumbList(arguments.rc.parentid,arguments.rc.siteid);
		arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid);
		arguments.rc.rsPageCount=variables.contentManager.getPageCount(arguments.rc.siteid);
		arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid);
	}

	/**
	 * @ouput true
	 */
	public function updateObjectParams(rc) {
		var local=structNew();
		local.versionBean=getBean("content").loadBy(contentHistID=arguments.rc.contentHistID, siteID= arguments.rc.siteid);
		if ( !local.versionBean.getIsNew() ) {
			arguments.rc.crumbData=variables.contentGateway.getCrumblist(local.versionBean.getContentID(), arguments.rc.siteid);
			arguments.rc.perm=variables.permUtility.getNodePerm(arguments.rc.crumbData);
		} else {
			abort;
		}
		if ( structKeyExists(arguments.rc,"changesetid") ) {
			local.versionBean.setChangesetID(arguments.rc.changesetID);
		}
		if ( structKeyExists(arguments.rc,"removePreviousChangeset") ) {
			local.versionBean.setRemovePreviousChangeset(arguments.rc.removePreviousChangeset);
		}
		if ( arguments.rc.perm == "author" ) {
			local.versionBean.setApproved(0);
		} else if ( arguments.rc.perm == "editor" ) {
			local.versionBean.setApproved(arguments.rc.approved);
		} else {
			abort;
		}
		if ( isJSON(arguments.rc.params) ) {
			local.versionBean.addDisplayObject(argumentCollection=arguments.rc);
			versionBean.save();
		}
		arguments.rc.versionBean=local.versionBean;
	}

	/**
	 * @ouput false
	 */
	public function lockFile(rc) {
		if ( rc.$.validateCSRFTokens(context=rc.contentid & "lockfile") ) {
			local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);
			local.crumbdata=variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid);
			local.perm=variables.permUtility.getNodePerm(local.crumbData);
			if ( listFindNoCase("author,editor",local.perm)
			or listFindNoCase(session.mura.memberships,"s2") ) {
				local.contentBean.getStats().setLockID(session.mura.userID).setLockType('file').save();
				location(url="#variables.configBean.getContext()#/index.cfm/_api/render/file/?fileid=#local.contentBean.getFileID()#&method=attachment", addtoken=false);
			}
		}
		abort;
	}

	/**
	 * @ouput false
	 */
	public function unlockFile(rc) {
		if ( rc.$.validateCSRFTokens(context=rc.contentid & "unlockfile") ) {
			local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);
			local.stats=local.contentBean.getStats();
			if ( len(local.stats.getLockID())
			and (
				local.stats.getLockID() == session.mura.userID
				or
				listFindNoCase(session.mura.memberships,"s2")
				) ) {
				local.stats.setLockID("").setLockType("").save();
			}
		}
		abort;
	}

	/**
	 * @ouput false
	 */
	public function unlockNode(rc) {
		if ( rc.$.validateCSRFTokens(context=rc.contentid & "unlocknode") ) {
			local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);
			local.stats=local.contentBean.getStats();
			if ( len(local.stats.getLockID())
			and (
				local.stats.getLockID() == session.mura.userID
				or
				listFindNoCase(session.mura.memberships,"s2")
				) ) {
				local.stats.setLockID("").setLockType("").save();
			}
		}
		abort;
	}

	public function getAuditTrail(rc) output=true {
		var trail=[];
		arguments.rc.item=rc.$.getBean('content').loadBy(contenthistid=arguments.rc.contenthistid,siteid=arguments.rc.siteid);
		while ( not arguments.rc.item.getIsNew() ) {
			arrayAppend(trail, arguments.rc.item.getContentHistID());
			arguments.rc.item=arguments.rc.item.getSource();
		}

		getpagecontext().getResponse().setContentType('application/json; charset=utf-8');

		writeOutput(createObject("component","mura.json").encode(trail));

		abort;
	}

	public function getImageSizeURL(rc) output=true {
		getpagecontext().getResponse().setContentType('application/json; charset=utf-8');
		writeOutput(createObject("component","mura.json").encode(rc.$.getURLForImage(fileID=rc.fileid,size=rc.size)));
		abort;
	}

}
