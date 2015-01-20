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

		arguments.rc.isAdmin = ListFind(rc.$.currentUser().getMemberships(), 'Admin;#rc.$.siteConfig('privateUserPoolID')#;0') || ListFind(rc.$.currentUser().getMemberships(), 'S2');

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
			  !arguments.rc.isAdmin 
				&& !( 
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

		// defaults
			param name='arguments.rc.error' default='#{}#';
			param name='arguments.rc.startrow' default='1';
			param name='arguments.rc.recordsperpage' default='25';
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
			param name='arguments.rc.error' default='#{}#';
			param name='arguments.rc.returnurl' default='';
			param name='arguments.rc.search' default='';
			param name='arguments.rc.newsearch' default=false;
			param name='arguments.rc.unassigned' default='0';

		// var scrubbing
			if ( !IsBoolean(arguments.rc.ispublic) || !arguments.rc.isAdmin ) { arguments.rc.ispublic = 1; }
			if ( !IsBoolean(arguments.rc.unassigned) ) { arguments.rc.unassigned = 0; }
			arguments.rc.unassignedlink = arguments.rc.unassigned == 0 ? 1 : 0;
			arguments.rc.startRow = Val(arguments.rc.startRow);
			if ( arguments.rc.startRow < 1 ) { arguments.rc.startRow = 1; }
			arguments.rc.recordsperpage = Val(arguments.rc.recordsperpage);
			if ( arguments.rc.recordsperpage < 1 ) { arguments.rc.recordsperpage = 25; }

		arguments.rc.rsUserSites=getSettingsManager().getUserSites(session.siteArray, ListFind(rc.$.currentUser().getMemberships(),'S2'));
	}

	public any function default(rc) {
		variables.fw.redirect(action='cUsers.list', append='siteid', path='./');
	}

	public any function list(rc) {
		arguments.rc.rs = getUserManager().getUserGroups(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic);

		// Iterator
			setUsersIterator(rc);
	}

	public any function listUsers(rc) {
		if ( arguments.rc.siteid == 'all' ) {
			arguments.rc.siteid = '';
		}

		arguments.rc.msgArg = arguments.rc.unassigned == 1
			? "'" & arguments.rc.$.rbKey('user.unassigned') & "'"
			: '';

		arguments.rc.noUsersMessage = getBean('resourceBundle').messageFormat(
			arguments.rc.$.rbKey('user.nousersavailable')
			, [arguments.rc.msgArg]
		);

		arguments.rc.rs= getUserManager().getUsers(
		 siteid=arguments.rc.siteid
		 , ispublic=arguments.rc.ispublic
		 , isunassigned=arguments.rc.unassigned
		);

		// Iterator
			setUsersIterator(rc);

		// unassigned users
			arguments.rc.rsUnassignedUsers = getUserManager().getUnassignedUsers(
				siteid=arguments.rc.siteid
				, ispublic=arguments.rc.ispublic
				, isunassigned=1
			);

			arguments.rc.listUnassignedUsers = ValueList(arguments.rc.rsUnassignedUsers.userid);
	}

	public any function editGroup(rc) {
		if ( IsDefined('arguments.rc.groupid') && Len(arguments.rc.groupid) ) {
			arguments.rc.userid = arguments.rc.groupid;
		}
		if ( !IsDefined('arguments.rc.userBean') ) {
			arguments.rc.userBean = getUserManager().read(arguments.rc.userid);
		}

		// this is used to populate the radio button
		arguments.rc.tempIsPublic = IsDefined('arguments.rc.setispublic') && rc.isAdmin
			? arguments.rc.setispublic
			: arguments.rc.userBean.getIsPublic();

		arguments.rc.nousersmessage = arguments.rc.$.rbKey('user.nogroupmembers');
		arguments.rc.rsSiteList = getSettingsManager().getList();
		arguments.rc.rs = getUserManager().readGroupMemberships(arguments.rc.userid);
		
		// Iterator
			setUsersIterator(rc);
	
		// This is here for backward plugin compatibility
		appendRequestScope(arguments.rc);
	}

	public any function editUser(rc) {
		if ( !IsDefined('arguments.rc.userBean') ) {
			arguments.rc.userBean=getUserManager().read(arguments.rc.userid);
		}	

		// this is used to populate the radio button
		arguments.rc.tempIsPublic = IsDefined('arguments.rc.setispublic') && rc.isAdmin
			? arguments.rc.setispublic
			: arguments.rc.userBean.getIsPublic();

		arguments.rc.rsPrivateGroups = getUserManager().getPrivateGroups(arguments.rc.siteid);
		arguments.rc.rsPublicGroups = getUserManager().getPublicGroups(arguments.rc.siteid);

		// used to populate the SiteID dropdown
		arguments.rc.rsSiteList = getSettingsManager().getList();

		// This is here for backward plugin compatibility
		appendRequestScope(arguments.rc);
	}

	public any function editGroupMembers(rc) {
		editGroup(arguments.rc);
	}

	public any function downloadGroupMembers(rc) {
		arguments.rc.records = getUserManager().readGroupMemberships(userid=arguments.rc.userid);
		variables.fw.redirect(action='cUsers.download', preserve='records');
	}

	public any function addToGroup(rc) {
		getUserManager().createUserInGroup(arguments.rc.userid, arguments.rc.groupid);
		route(arguments.rc);
	}

	public any function removeFromGroup(rc) {
		getUserManager().deleteUserFromGroup(arguments.rc.userid, arguments.rc.groupid);
		variables.fw.redirect(action='cUsers.editGroupMembers', preserve='groupid,siteid');
	}

	public any function editAddress(rc) {
		if ( !IsDefined('arguments.rc.userBean') ) {
			arguments.rc.userBean=getUserManager().read(arguments.rc.userid);
		}
	}

	public any function update(rc) {
		var origSiteID = arguments.rc.siteID;
		request.newImageIDList = '';

		if ( arguments.rc.$.validateCSRFTokens(context=arguments.rc.userid) ) {
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
	   
	  // image processing
		if ( Len(request.newImageIDList) ) {
			arguments.rc.fileid = request.newImageIDList;
			arguments.rc.userid = arguments.rc.userBean.getUserID();
			variables.fw.redirect(action='cArch.imagedetails', append='userid,siteid,fileid,compactDisplay', path='./');
		}

		if ( arguments.rc.action != 'delete' && StructIsEmpty(arguments.rc.userBean.getErrors()) || arguments.rc.action == 'delete' ) {
			route(arguments.rc);
		}

		if ( arguments.rc.action != 'delete' && !StructIsEmpty(arguments.rc.userBean.getErrors()) && arguments.rc.type == 1 ) {
			variables.fw.redirect(action='cUsers.editgroup', preserve='all', path='./');
		} else if ( arguments.rc.action != 'delete' && !StructIsEmpty(arguments.rc.userBean.getErrors()) && arguments.rc.type == 2 ) {
			session.mura.editBean = arguments.rc.userBean;
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
		arguments.rc.rs = getUserManager().getSearch(
			search=arguments.rc.search
			, siteid=arguments.rc.siteid
			, ispublic=arguments.rc.isPublic
		);

		// Iterator
			setUsersIterator(rc);

		arguments.rc.rsUnassignedUsers = getUserManager().getUnassignedUsers(
			siteid=arguments.rc.siteid
			, ispublic=arguments.rc.ispublic
			, isunassigned=1
		);

		arguments.rc.listUnassignedUsers = ValueList(arguments.rc.rsUnassignedUsers.userid);
		arguments.rc.noUsersMessage = arguments.rc.$.rbKey('user.nosearchresults');

		// if only one match, then go to edit user form
		// if ( arguments.rc.rs.recordcount == 1 ) {
		// 	arguments.rc.userID = rc.rslist.userid;
		// 	variables.fw.redirect(action='cUsers.editUser', append='siteid,userid', path='./');
		// }
	}

	public any function advancedSearch(rc) {
		var i = '';

		arguments.rc.nousersmessage = arguments.rc.$.rbKey('user.nosearchresults');

		arguments.rc.rsGroups = arguments.rc.ispublic == 1
			? variables.userManager.getPublicGroups(arguments.rc.siteid, 1)
			: variables.userManager.getPrivateGroups(arguments.rc.siteid, 1);

		arguments.rc.rs = getUserManager().getAdvancedSearch(session, arguments.rc.siteid, arguments.rc.ispublic);

		// Iterator
			setUsersIterator(rc);

		// scrub the query string for links
			arguments.rc.querystruct = Duplicate(getPageContext().getRequest().getParameterMap());
			StructDelete(arguments.rc.querystruct, 'ispublic', 0);	
			StructDelete(arguments.rc.querystruct, 'muraaction', 0);
			arguments.rc.qs = '';
			for ( var key in arguments.rc.querystruct ){
				i = arguments.rc.querystruct[key][1];
				arguments.rc.qs &= key & '=' & i & '&';
			}
	}

	public any function advancedSearchToCSV(rc) {
		arguments.rc.records = getUserManager().getAdvancedSearch(data=session, siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic);
		variables.fw.redirect(action='cUsers.download', preserve='records');

	}

// ----------------- DOWNLOAD ----------------------------- //
	public any function download(rc) {
		if ( !IsDefined('arguments.rc.records') ) {
			arguments.rc.rs = arguments.rc.unassigned
				? getUserManager().getUnassignedUsers(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic)
				: getUserManager().getUsers(siteid=arguments.rc.siteid, ispublic=arguments.rc.ispublic);

			arguments.rc.records = arguments.rc.rs;
		}

		setDownloadData(arguments.rc);
	}

// ----------------- PRIVATE / HELPERS ----------------------------- //
	private any function setDownloadData(rc) {
		var i = '';
		var r = '';
		var col = '';
		var cols = '';

		rc.str = '';
		arguments.rc.rs = arguments.rc.records;
		arguments.rc.origColumnList = ListFindNoCase(arguments.rc.rs.columnlist, 'password')
			? ListDeleteAt(arguments.rc.rs.columnlist, ListFindNoCase(arguments.rc.rs.columnlist, 'password'))
			: arguments.rc.rs.columnlist;
		arguments.rc.qualifiedColumns = ListQualify(arguments.rc.origColumnList, '"', ",", "CHAR");
		arguments.rc.str = arguments.rc.str & arguments.rc.qualifiedColumns & chr(10);

		cols = ListToArray(arguments.rc.rs.columnlist);

		for ( i=1; i <= arguments.rc.rs.recordcount; i++ ) {
			r = '';
			for ( col in cols ) {
				r = ListAppend( r, Replace( arguments.rc.rs[col][i], ",", "**comma**", "ALL" ) & " " );
			}
			arguments.rc.str = arguments.rc.str & ListQualify(r, '"', ",", "CHAR") & chr(10);
		}
	}

	private any function setUsersIterator(rc) {
		// pagination setup
			if ( arguments.rc.startRow > arguments.rc.rs.recordcount ) {
				arguments.rc.startRow = 1;
			}

			// nextN
			arguments.rc.nextn = variables.utility.getNextN(
				data=arguments.rc.rs.recordcount
				, recordsPerPage=arguments.rc.recordsperpage
				, startRow=arguments.rc.startRow
				, pageBuffer=3
			);

		// iterator
			arguments.rc.it = getBean('userIterator')
				.setQuery(arguments.rc.rs)
				.setNextN(arguments.rc.nextn.recordsperpage)
				.setStartRow(arguments.rc.nextn.startrow)
				.setPage(arguments.rc.nextn.startrow);
	}
}