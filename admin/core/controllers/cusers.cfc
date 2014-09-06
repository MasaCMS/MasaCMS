/*
	This file is part of Mura CMS.

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
component persistent='false' accessors='true' output='false' extends='controller' {

	property name='userManager';
	property name='settingsManager';

	public any function setUserManager(userManager) {
		variables.userManager = arguments.userManager;
	}

	public any function setSettingsManager(settingsManager) {
		variables.settingsManager = arguments.settingsManager;
	}

	public any function before(rc) {

		if ( !Len(arguments.rc.siteid) ) {
			arguments.rc.siteid = StructKeyExists(session, 'siteid') ? session.siteid : 'default';
		}

		if ( !(
					IsDefined('arguments.rc.baseID') 
					&& ListLast(arguments.rc.muraAction, ':') == 'cUsers.loadExtendedAttributes'
					&& (
						arguments.rc.baseID == session.mura.userID
						|| getUserManager().getReversePermLookUp(arguments.rc.siteID)
					)
				)
		) {
			if ( 
				( 
					!ListFind(session.mura.memberships, 'Admin;#getSettingsManager().getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') && !ListFind(session.mura.memberships, 'S2')
				) && !( 
					variables.permUtility.getModulePerm(
						'00000000000000000000000000000000008'
						, arguments.rc.siteid
					) && variables.permUtility.getModulePerm(
						'00000000000000000000000000000000000'
						, arguments.rc.siteid
					)
				)
			) {
				secure(arguments.rc);
			}
		}

		param name='arguments.rc.error' default='#{}#';
		param name='arguments.rc.startrow' default='1';
		param name='arguments.rc.userid' default='';
		param name='arguments.rc.routeid' default='';
		param name='arguments.rc.categoryid' default='';
		param name='arguments.rc.Type' default='0';
		param name='arguments.rc.ContactForm' default='0';
		param name='arguments.rc.isPublic' default='1';
		param name='arguments.rc.email' default='';
		param name='arguments.rc.jobtitle' default='';
		param name='arguments.rc.lastupdate' default='';
		param name='arguments.rc.lastupdateby' default='';
		param name='arguments.rc.lastupdatebyid' default='0';
		param name='arguments.rc.rsGrouplist.recordcount' default='0';
		param name='arguments.rc.groupname' default='';
		param name='arguments.rc.fname' default='';
		param name='arguments.rc.lname' default='';
		param name='arguments.rc.address' default='';
		param name='arguments.rc.city' default='';
		param name='arguments.rc.state' default='';
		param name='arguments.rc.zip' default='';
		param name='arguments.rc.phone1' default='';
		param name='arguments.rc.phone2' default='';
		param name='arguments.rc.fax' default='';
		param name='arguments.rc.perm' default='0';
		param name='arguments.rc.groupid' default='';
		param name='arguments.rc.routeid' default='';
		param name='arguments.rc.s2' default='0';
		param name='arguments.rc.InActive' default='0';
		param name='arguments.rc.startrow' default='1';
		param name='arguments.rc.error' default='#{}#';
		param name='arguments.rc.returnurl' default='';
		param name='arguments.rc.search' default='';
		param name='arguments.rc.newsearch' default=false;
		param name='arguments.rc.unassigned' default='0';

		if ( !IsBoolean(arguments.rc.ispublic) ) { arguments.rc.ispublic = 1; }
		if ( !IsBoolean(arguments.rc.unassigned) ) { arguments.rc.unassigned = 0; }
		arguments.rc.unassignedlink = arguments.rc.unassigned == 0 ? 1 : 0;

		if ( !Len(arguments.rc.userid) ) {
			param name='arguments.rc.action' default='Add';
		} else {
	  	param name='arguments.rc.action' default='Update';
		}

		arguments.rc.rsUserSites=application.settingsManager.getUserSites(session.siteArray,ListFind(session.mura.memberships,'S2'));
	}

	public any function default(rc) {
		variables.fw.redirect(action='cUsers.list', append='siteid', path='./');
	}

	public any function list(rc) {
		param name='rc.ispublic' default='0';
		rc.rsGroups = getUserManager().getUserGroups(siteid=rc.siteid, ispublic=rc.ispublic);
		rc.itGroups = getUserManager().getIterator().setQuery(rc.rsGroups);
	}

	public any function editGroup(rc) {
		if ( !IsDefined('arguments.rc.userBean') ) {
			arguments.rc.userBean = getUserManager().read(arguments.rc.userid);
		}
		arguments.rc.rsSiteList = getSettingsManager().getList();
		arguments.rc.rsGroupList = getUserManager().readGroupMemberships(arguments.rc.userid);
		arguments.rc.nextn = variables.utility.getNextN(arguments.rc.rsGroupList,15,arguments.rc.startrow);
	
		// This is here for backward plugin compatibility
		appendRequestScope(arguments.rc);
	}

	public any function editGroupMembers(rc) {
		editGroup(rc);
	}

	// public any function deleteGroup(rc) {

	// }

	public any function addToGroup(rc) {
		getUserManager().createUserInGroup(arguments.rc.userid, arguments.rc.groupid);
		route(arguments.rc);
	}

	public any function removeFromGroup(rc) {
		getUserManager().deleteUserFromGroup(arguments.rc.userid, arguments.rc.groupid);
		route(arguments.rc);
	}

	public any function route(rc) {
		StructDelete(session.mura, 'editBean');

		if ( !Len(arguments.rc.routeid) ) {
			if ( Len(arguments.rc.returnurl) ) {
				location(url=arguments.rc.returnurl, addtoken=false);
			} else {
				variables.fw.redirect(action='cUsers', append='siteid', path='./');
			}
		}
	
		if ( arguments.rc.routeid == 'adManager' && arguments.rc.action != 'delete' ) {
			variables.fw.redirect(action='cAdvertising.viewAdvertiser', append='siteid,userid', path='./');
		}
	
		if ( arguments.rc.routeid == 'adManager' && arguments.rc.action == 'delete' ) {
			variables.fw.redirect(action='cAdvertising.listAdvertisers', append='siteid', path='./');
		}

		if ( arguments.rc.routeid != '' && arguments.rc.routeid != 'adManager' ) {
			arguments.rc.userid = rc.routeid;
			variables.fw.redirect(action='cUsers.editgroup', append='siteid,userid', path='./');
		}
	
		variables.fw.redirect(action='cUsers', append='siteid', path='./');
	}


// ----------------- SEARCH ----------------------------- //
	public any function search(rc) {
		param name='rc.isPublic' default='1';
		arguments.rc.rslist=getUserManager().getSearch(
			search=arguments.rc.search
			, siteid=arguments.rc.siteid
			, isPublic=rc.isPublic
		);

		// if only one match, then go to edit user form
		// if ( arguments.rc.rslist.recordcount == 1 ) {
		// 	arguments.rc.userID = rc.rslist.userid;
		// 	variables.fw.redirect(action='cUsers.editUser', append='siteid,userid', path='./');
		// }

		arguments.rc.nextn=variables.utility.getNextN(
			arguments.rc.rsList
			, 15
			, arguments.rc.startrow
		);
	}

	public any function advancedSearch(rc) {
		param name='rc.ispublic' default='1';
		arguments.rc.rsGroups = rc.ispublic == 1
			? variables.userManager.getPublicGroups(arguments.rc.siteid, 1)
			: variables.userManager.getPrivateGroups(arguments.rc.siteid, 1);
	}

	public any function advancedSearchToCSV(rc) {
		param name='rc.ispublic' default='1';
		arguments.rc.rsGroups = rc.ispublic == 1
			? variables.userManager.getPublicGroups(arguments.rc.siteid, 1)
			: variables.userManager.getPrivateGroups(arguments.rc.siteid, 1);
	}

	public any function editUser(rc) {
		if ( !IsDefined('arguments.rc.userBean') ) {
			arguments.rc.userBean=getUserManager().read(arguments.rc.userid);
		}
		
		arguments.rc.rsPrivateGroups = getUserManager().getPrivateGroups(arguments.rc.siteid);
		arguments.rc.rsPublicGroups = getUserManager().getPublicGroups(arguments.rc.siteid);

		// This is here for backward plugin compatibility
		appendRequestScope(arguments.rc);
	}

	public any function editAddress(rc) {
		if ( !IsDefined('arguments.rc.userBean') ) {
			arguments.rc.userBean=getUserManager().read(arguments.rc.userid);
		}
	}

	public any function update(rc) {
		var origSiteID = arguments.rc.siteID;
		request.newImageIDList = '';

		if ( rc.$.validateCSRFTokens(context=rc.userid) ) {
			switch(arguments.rc.action) {
				case 'Update' :
					arguments.rc.userBean=getUserManager().update(arguments.rc);
					break;
				case 'Delete' :
					getUserManager().delete(arguments.rc.userid,arguments.rc.type);
					break;
				case 'Add' :
					arguments.rc.userBean=getUserManager().create(arguments.rc);
					if ( StructIsEmpty(arguments.rc.userBean.getErrors()) ) {
						arguments.rc.userid=arguments.rc.userBean.getUserID();
					}
					break;
			}
		}
	  
	  arguments.rc.siteID = origSiteID;
	   
		if ( Len(request.newImageIDList) ) {
			arguments.rc.fileid = request.newImageIDList;
			arguments.rc.userid = arguments.rc.userBean.getUserID();
			variables.fw.redirect(action='cArch.imagedetails', append='userid,siteid,fileid,compactDisplay', path='./');
		}

		if ( 
			arguments.rc.action == 'delete' ||
			( 
				arguments.rc.action != 'delete' 
				&& StructIsEmpty(arguments.rc.userBean.getErrors())
			)
		) {
			route(arguments.rc);
		}

		if ( 
			arguments.rc.action != 'delete'
			&& !StructIsEmpty(arguments.rc.userBean.getErrors()) 
		) {
			if ( arguments.rc.type == 2 ) {
				session.mura.editBean = arguments.rc.userBean;
			}
			variables.fw.redirect(action='cUsers.edituser', preserve='all', path='./');
		}
	}

	public any function updateAddress(rc) {
		switch(arguments.rc.action) {
			case 'Update' :
				getUserManager().updateAddress(arguments.rc);
				break;
			case 'Delete' :
				getUserManager().deleteAddress(arguments.rc.addressid);
				break;
			case 'Add' :
				getUserManager().createAddress(arguments.rc);
				break;
		}

		variables.fw.redirect(action='cUsers.edituser', preserve='siteid,userid,routeid', path='./');
	}

	public any function download(rc) {
		arguments.rc.rsUsers = arguments.rc.unassigned
			? getUserManager().getUnassignedUsers(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic)
			: getUserManager().getUsers(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic);

		rc.str = '';
		rc.records = arguments.rc.rsUsers;
		rc.origColumnList = ListDeleteAt(rc.records.columnlist, ListFindNoCase(rc.records.columnlist, 'password'));
		rc.qualifiedColumns = ListQualify( rc.origColumnList, '"', ",", "CHAR" );
		rc.str = rc.str & rc.qualifiedColumns & chr(10);
	}

	public any function listUsers(rc) {

		if ( arguments.rc.siteid == 'all' ) {
			arguments.rc.siteid = '';
		}

		// arguments.rc.rsUsers = arguments.rc.unassigned
		// 	? getUserManager().getUnassignedUsers(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic)
		// 	: getUserManager().getUsers(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic);

		arguments.rc.rsUsers = getUserManager().getUsers(
		 siteid=arguments.rc.siteid
		 , ispublic=arguments.rc.ispublic
		 , isunassigned=arguments.rc.unassigned
		);

		arguments.rc.itUsers = getBean('userIterator').setQuery(arguments.rc.rsUsers);

		arguments.rc.rsUnassignedUsers = getUserManager().getUnassignedUsers(
		  siteid=arguments.rc.siteid
		  , ispublic=arguments.rc.ispublic
		  , isunassigned=1
		 );

		arguments.rc.listUnassignedUsers = ValueList(arguments.rc.rsUnassignedUsers.userid);
	}

}