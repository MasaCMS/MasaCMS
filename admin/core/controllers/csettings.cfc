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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
*/
component extends="controller" output="false" {

	public function setPluginManager(pluginManager) output=false {
		variables.pluginManager=arguments.pluginManager;
	}

	public function setClusterManager(clusterManager) output=false {
		variables.clusterManager=arguments.clusterManager;
	}

	public function before(rc) output=false {
		if ( !(
				(
					listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0')
					and !listFindNoCase('list,editPlugin,deployPlugin,updatePlugin,updatePluginVersion,siteCopy,sitecopyselect,sitecopyresult',listLast(rc.muraAction,"."))
				)
				or listFind(session.mura.memberships,'S2')
				) ) {
			secure(arguments.rc);
		}
	}

	public function list(rc) output=false {
		param default="" name="arguments.rc.orderID";
		param default="" name="arguments.rc.orderno";
		param default="" name="arguments.rc.deploy";
		param default="" name="arguments.rc.action";
		param default="" name="arguments.rc.siteid";
		param default="site" name="arguments.rc.siteSortBy";

		if ( isdefined("arguments.rc.refresh") ) {
			variables.fw.redirect(action="cSettings.list",path="./");
		}
		if ( rc.$.validateCSRFTokens(context='updatesites') ) {
			variables.settingsManager.saveOrder(arguments.rc.orderno,arguments.rc.orderID);
			variables.settingsManager.saveDeploy(arguments.rc.deploy,arguments.rc.orderID);
		}
		arguments.rc.rsSites=variables.settingsManager.getList(sortBy=arguments.rc.siteSortBy);
		arguments.rc.rsPlugins=variables.pluginManager.getAllPlugins();
	}

	public function editSite(rc) output=false {
		arguments.rc.siteBean=variables.settingsManager.read(arguments.rc.siteid);
	}

	public function deletePlugin(rc) output=false {
		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.moduleid) ) {
			variables.pluginManager.deletePlugin(arguments.rc.moduleID);
		}


		location(url="./?muraAction=cSettings.list&refresh=1##tabPlugins", addtoken="false");


	}

	public function editPlugin(rc) output=false {
		arguments.rc.pluginXML=variables.pluginManager.getPluginXML(arguments.rc.moduleID);
		arguments.rc.rsSites=variables.settingsManager.getList();
	}

	public function updatePluginVersion(rc) output=false {
		arguments.rc.pluginConfig=variables.pluginManager.getConfig(arguments.rc.moduleID);
	}

	public function deployPlugin(rc) output=false {
		var tempID="";
		param default="" name="arguments.rc.moduleID";
		if ( len(arguments.rc.moduleid) && arguments.rc.$.validateCSRFTokens(context=arguments.rc.moduleid)
		or arguments.rc.moduleid == '' && arguments.rc.$.validateCSRFTokens(context='newplugin') ) {
			tempID=variables.pluginManager.deploy(arguments.rc.moduleID);
		}
		if ( isDefined('tempid') && len(tempID) ) {
			arguments.rc.moduleID=tempID;
			variables.fw.redirect(action="cSettings.editPlugin",append="moduleid",path="./");
		} else {
			if ( len(arguments.rc.moduleID) ) {
				variables.fw.redirect(action="cSettings.editPlugin",append="moduleid",path="./");
			} else {

			location(url="./?muraAction=cSettings.list&refresh=1##tabPlugins",addtoken="false");

			}
		}
	}

	public function updatePlugin(rc) output=false {
		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.moduleid) ) {
			arguments.rc.moduleID=variables.pluginManager.updateSettings(arguments.rc);
		}

		location(url="./?muraAction=cSettings.list&refresh=1##tabPlugins",addtoken="false");

	}

	public function updateSite(rc) output=false {
		var bean=variables.settingsManager.read(siteid=arguments.rc.siteid);
		if ( bean.getIsNew() && arguments.rc.$.validateCSRFTokens()
		or !bean.getIsNew() && arguments.rc.$.validateCSRFTokens(context=arguments.rc.siteID) ) {
			request.newImageIDList="";
			if ( arguments.rc.action == 'Update' ) {
				lock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200" {
					application.appInitialized=false;
					bean=variables.settingsManager.update(arguments.rc);
				}
				variables.clusterManager.reload();
				if ( !structIsEmpty(bean.getErrors()) ) {
					getCurrentUser().setValue("errors",bean.getErrors());
				} else {
					if ( len(request.newImageIDList) ) {
						arguments.rc.fileid=request.newImageIDList;
						variables.fw.redirect(action="cArch.imagedetails",append="siteid,fileid,compactDisplay",path="./");
					}
				}
			}
			if ( listFind(session.mura.memberships,'S2') && arguments.rc.action == 'Add' ) {
				lock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200" {
					bean=variables.settingsManager.create(arguments.rc);
					variables.settingsManager.setSites();
				}
				variables.clusterManager.reload();
				session.userFilesPath = "#application.configBean.getAssetPath()#/#rc.siteid#/assets/";
				session.siteid=arguments.rc.siteid;
				if ( !structIsEmpty(bean.getErrors()) ) {
					getCurrentUser().setValue("errors",bean.getErrors());
				} else {
					if ( len(request.newImageIDList) ) {
						arguments.rc.fileid=request.newImageIDList;
						variables.fw.redirect(action="cArch.imagedetails",append="siteid,fileid,compactDisplay",path="./");
					}
				}
			}
			if ( listFind(session.mura.memberships,'S2') && arguments.rc.action == 'Delete' ) {
				variables.settingsManager.delete(arguments.rc.siteid);
				session.siteid="default";
				session.userFilesPath = "#application.configBean.getAssetPath()#/default/assets/";
				arguments.rc.siteid="default";
			}
		}
		if ( listFind(session.mura.memberships,'S2') ) {
			variables.fw.redirect(action="cSettings.list",path="./");
		} else {
			variables.fw.redirect(action="cDashboard.main",append="siteid",path="./");
		}
	}

	public function sitecopyselect(rc) output=false {
		arguments.rc.rsSites=variables.settingsManager.getList();
	}

	public function exportHTML(rc) output=false {
		variables.settingsManager.getSite(arguments.rc.siteID).exportHTML();
	}

	public function sitecopy(rc) output=false {
		if ( arguments.rc.$.validateCSRFTokens(context='sitecopy') && arguments.rc.fromSiteID != arguments.rc.toSiteID ) {
			getBean('publisher').copy(fromSiteID=rc.fromSiteID,toSiteID=rc.toSiteID);
		}
		variables.fw.redirect(action="cSettings.sitecopyresult",append="fromSiteID,toSiteID",path="./");
	}

	public function createBundle(rc) output=false {
		param default="" name="arguments.rc.moduleID";
		param default="copy" name="arguments.rc.bundleImportKeyMode";
		param default="" name="arguments.rc.BundleName";
		param default=false name="arguments.rc.includeTrash";
		param default=false name="arguments.rc.includeVersionHistory";
		param default=false name="arguments.rc.includeMetaData";
		param default=false name="arguments.rc.includeMailingListMembers";
		param default=false name="arguments.rc.includeUsers";
		param default=false name="arguments.rc.includeFormData";
		param default=false name="arguments.rc.saveFile";
		param default="" name="arguments.rc.saveFileDir";
		param default="" name="arguments.rc.bundleMode";
		if ( len(arguments.rc.saveFileDir) ) {
			if ( directoryExists(arguments.rc.saveFileDir) ) {
				arguments.rc.saveFile=true;
			} else {
				arguments.rc.saveFileDir="";
				arguments.rc.saveFile=false;
			}
		}
		arguments.rc.bundleFilePath=application.serviceFactory.getBean("Bundle").Bundle(
			siteID=arguments.rc.siteID,
			moduleID=arguments.rc.moduleID,
			BundleName=arguments.rc.BundleName,
			includeVersionHistory=arguments.rc.includeVersionHistory,
			includeTrash=arguments.rc.includeTrash,
			includeMetaData=arguments.rc.includeMetaData,
			includeMailingListMembers=arguments.rc.includeMailingListMembers,
			includeUsers=arguments.rc.includeUsers,
			includeFormData=arguments.rc.includeFormData,
			saveFile=arguments.rc.saveFile,
			saveFileDir=arguments.rc.saveFileDir,
			bundleMode=arguments.rc.bundleMode
			);
	}

	public function selectBundleOptions(rc) output=false {
		arguments.rc.rsplugins=application.serviceFactory.getBean("pluginManager").getSitePlugins(arguments.rc.siteID);
	}

}
