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
component extends="controller" output="false" {

	public function setFeedManager(feedManager) output=false {
		variables.feedManager=arguments.feedManager;
	}

	public function setContentUtility(ContentUtility) output=false {
		variables.contentUtility=arguments.contentUtility;
	}

	public function before(rc) output=false {
		if ( !variables.settingsManager.getSite(arguments.rc.siteid).getHasfeedManager() || (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') && !listFind(session.mura.memberships,'S2')) && !( variables.permUtility.getModulePerm('00000000000000000000000000000000011',arguments.rc.siteid) && variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid)) ) {
			secure(arguments.rc);
		}
		param default=1 name="arguments.rc.startrow";
		param default="" name="arguments.rc.keywords";
		param default="" name="arguments.rc.categoryID";
		param default="" name="arguments.rc.contentID";
		param default=0 name="arguments.rc.restricted";
		param default="" name="arguments.rc.closeCompactDisplay";
		param default="" name="arguments.rc.compactDisplay";
		param default="" name="arguments.rc.homeID";
		param default="" name="arguments.rc.action";
		param default="" name="arguments.rc.assignmentID";
		param default=0 name="arguments.rc.regionID";
		param default=0 name="arguments.rc.orderno";
		param default="" name="arguments.rc.instanceParams";
		param default="" name="arguments.rc.instanceid";
	}

	public function list(rc) output=false {
		arguments.rc.rsLocal=variables.feedManager.getFeeds(arguments.rc.siteID,'Local');
		arguments.rc.rsRemote=variables.feedManager.getFeeds(arguments.rc.siteID,'Remote');
	}

	public function edit(rc) output=false {
		arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid);
		arguments.rc.feedBean=variables.feedManager.read(feedid=arguments.rc.feedID,siteid=arguments.rc.siteid);
		arguments.rc.rslist=variables.feedManager.getcontentItems(arguments.rc.feedBean);
	}

	public function update(rc) output=false {
		if ( rc.$.validateCSRFTokens(context=arguments.rc.feedid) ) {
			if ( arguments.rc.action == 'update' ) {
				if ( len(arguments.rc.assignmentID) && isJSON(arguments.rc.instanceParams) ) {
					getBean("contentManager").updateContentObjectParams(arguments.rc.assignmentID,arguments.rc.regionID,arguments.rc.orderno,arguments.rc.instanceParams);
					arguments.rc.feedBean=variables.feedManager.read(feedid=arguments.rc.feedID,siteid=arguments.rc.siteid);
				} else {
					arguments.rc.feedBean=variables.feedManager.update(arguments.rc);
				}
			}
			if ( arguments.rc.action == 'delete' ) {
				variables.feedManager.delete(arguments.rc.feedID,arguments.rc.siteid);
			}
			if ( arguments.rc.action == 'add' ) {
				arguments.rc.feedBean=variables.feedManager.create(arguments.rc);
				if ( structIsEmpty(arguments.rc.feedBean.getErrors()) ) {
					arguments.rc.feedID=rc.feedBean.getFeedID();
				}
			}
			if ( arguments.rc.closeCompactDisplay != 'true' && !(arguments.rc.action !=  'delete' && !structIsEmpty(arguments.rc.feedBean.getErrors())) ) {
				variables.fw.redirect(action="cFeed.list",append="siteid",path="./");
			}
			if ( arguments.rc.action !=  'delete' && !structIsEmpty(arguments.rc.feedBean.getErrors()) ) {
				arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid);
				arguments.rc.rslist=variables.feedManager.getcontentItems(arguments.rc.feedBean);
			}
		} else {
			variables.fw.redirect(action="cFeed.list",append="siteid",path="./");
		}
	}

	public function import2(rc) output=false {
		arguments.rc.theImport=variables.feedManager.doImport(arguments.rc);
	}

}
